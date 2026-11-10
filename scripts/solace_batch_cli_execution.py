### Accepts a list of CLI files , copies them over to solace appliance, executes them in the given order and downloads output files to a directory named Output_<hostname>
### & deletes the .out and .cli files that were copied over to appliance
### Try --help for usage help
###
### ALS    - 2025/06/05 - WORKING VERSION
### ALS    - 2025/06/11 - ADDED TIMEOUT, DELAY AND INCREASE RECEIVED BUFFER
### ALS/CB - 2025/06/27 - IMPROVED SSH COMMAND EXECUTION
### ALS/CB - 2025/08/21 - INCREASED SHELL TIMEOUT VALUES
### ALS    - 2025/08/22 - modified with code from Alfoso Chacon from Solace Professional Services.
### ALS    - 2025/08/23 - re-enabled removing files after execution.
### ALS    - 2025/08/25 - corrected indentation for delete block.
### ALS    - 2025/09/08 - added code to decrypt user password from file instead of receiving a parameter.
### ALS    - 2025/09/09 - enhanced return of error code via error_flag variable.
### ALS    - 2025/10/09 - commented off printing STDOUT with the password.
###
import argparse
import logging
import re
import sys
import time
import traceback
from io import StringIO

import paramiko


#----------------------------------------------------------------------------
# Standard vars used
#----------------------------------------------------------------------------
remote_directory = "/cliscripts"
cli_dir = "/cliscripts"
LAST_COMMAND = "-----EXIT-----"
LOGOUT_COMMAND = f"logout\n".encode()
REPLACE_LAST_COMMAND_OUTPUT = fr"\s*Invalid command input\s+{LAST_COMMAND}\s+\^\s+-> unknown command, or command not available in current mode\s*"



#------------------------------------------------
# function to execute commands in Solace broker.
#------------------------------------------------
def execute_commands_on_solace(hostname, username, password, commands):
    #-----------------------------------------------------------------------------------------------
    # Executes a sequence of commands on the Solace appliance via an interactive SSH shell_channel
    #-----------------------------------------------------------------------------------------------
    #
    #   capture start time
    #
    execute_start_time = time.time()

    #
    # set IO buffers
    #
    stdout_buffer = StringIO()
    stderr_buffer = StringIO()
    n_bytes = 1048576

    #
    try:
        #
        # say hello - comment out when not needed.
        #
        print(f"\n==== Executing Commands on Solace ====")
        # Establish an SSH connection
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=hostname, username=username, password=password, port=2222)

        # Open an interactive shell_channel session
        shell_channel= ssh.invoke_shell()
        #   2025/08/21 - ALS
        shell_channel.settimeout(600)
        #   2025/08/22 - ALS
        shell_channel.timeout = 600
        #
        print(f"Interactive SSH session established.")

        #
        # Execute basic CLI set up commands before executing the commands received
        #
        # bytes_sent = shell_channel.send("session timeout 600\n".encode())
        setupcmds = []
        setupcmds.append('no paging')
        setupcmds.append('cd /cliscripts')
        setupcmds.append('session timeout 0')
        #
        #  do include the computed source commands.
        #
        for cmd in commands:
            setupcmds.append(cmd)
        #
        #   insert a dummy command at the end OF THE COMMANDS RECEIVED to force exiting the loop
        #
        setupcmds.append(LAST_COMMAND)
        #
        #   convert all commands into a single command line
        #
        cli_commands = '\n'.join(setupcmds)
        cli_commands = f'{cli_commands}\n'

        #-----------------------------------------------------------------
        # 2025/08/22 - updated few lines with SPS Alfonso Chacon's code.
        #-----------------------------------------------------------------

        # ADD A NEW LINE/RETURN TO THE COMMAND
        print(f"Executing: {cli_commands}")
        bytes_sent = shell_channel.send(cli_commands.encode())
        print(f"bytes sent: {bytes_sent}")
        # wait 3 seconds to have data in the buffer
        time.sleep(3)

        # set variables
        start_time = time.time()
        timeout = 180  # 2025/08/22 - Set a timeout of 180 seconds (adjust as needed)

        last_command_execution_regex = fr".*\s+Invalid command input\s+{LAST_COMMAND}\s+\^\s+-> unknown command, or command not available in current mode.*"
        send_logout = False
        logout_command_sent = False
        continue_while: bool = True
        get_output_cycles: int = 0

        # loop to capture the output
        # after
        while continue_while or get_output_cycles < 3:

            ret_bytes = None
            ret_string = ""

            if shell_channel.recv_ready():
                ret_bytes = shell_channel.recv(n_bytes)
                ret_string = ret_bytes.decode()
                stdout_buffer.write(ret_string)
                #
                #  check to see if we are seeing the prompt
                #
                if re.match(last_command_execution_regex, ret_string, re.DOTALL):  # later we could add the trimmed host name to the check in output
                    send_logout = True

                if f'ERROR: script' in ret_string:  # later we could add the trimmed host name to the check in output
                    global error_flag
                    error_flag = 1
                    send_logout = True

            elif shell_channel.recv_stderr_ready():
                print(f"Python command found an error  - ABENDING execution.")
                ret_bytes = shell_channel.recv_stderr(n_bytes)
                ret_string = ret_bytes.decode()
                stderr_buffer.write(ret_string)
                #
                #  check to see if we are seeing the prompt
                #
                if re.match(last_command_execution_regex, ret_string, re.DOTALL):  # later we could add the trimmed host name to the check in output
                    send_logout = True
                    continue_while = False

            elif shell_channel.exit_status_ready():
                 continue_while = False

            if not ret_bytes is None:
                 ret_bytes_length = len(ret_bytes)
                 print(f"{ret_bytes_length} byte(s) received")

            #print(f"ret_string: '{ret_string}', send_logout={send_logout}")

            if send_logout and not logout_command_sent:
                # wait additional 3 seconds to send the logout
                # add another flag to avoid sending the logout command multiple times
                time.sleep(3)
                print(f"Sending logout command {LOGOUT_COMMAND}")
                shell_channel.send(LOGOUT_COMMAND)
                logout_command_sent = True
                continue_while = False

            #
            #   check if we have exceeded the timeout value
            #
            if time.time() - start_time > timeout:
                print(f"Python Program failed to execute CLI commands in a timely manner - timed out after {timeout} seconds.")
                continue_while = False

            if not continue_while:
                # query 3 more times to get any remaining output
                get_output_cycles += 1
                print(f"Increasing cycle {get_output_cycles}")

            #
            #   wait for 3 seconds before checking for more output
            #
            print(f"Waiting to receive more output...3 seconds: cycle {get_output_cycles}, continue_while={continue_while}")
            time.sleep(3)  # Avoid busy-waiting

        print(f'StdOut: {re.sub(REPLACE_LAST_COMMAND_OUTPUT,"\n", stdout_buffer.getvalue())}')
        print(f'StdErr: {stderr_buffer.getvalue()}')

        with open("output.cli", "w") as file:
            file.write(f'StdOut: {re.sub(REPLACE_LAST_COMMAND_OUTPUT,"\n", stdout_buffer.getvalue())}')

        with open("output.err.cli", "w") as file:
            file.write(f'{stderr_buffer.getvalue()}')

        # Close the SSH connection
        shell_channel.close()
        ssh.close()
        print(f"All commands executed successfully.")

        #
        # capture end time, compute and display elapsed time
        #
        execute_end_time = time.time()
        execute_elapsed_time = execute_end_time - execute_start_time
        print(f"Execute Elapsed time: {execute_elapsed_time:.2f} seconds")
        #
        print(f"==== Finished Executing Commands on Solace ====")

    #
    # exceptions section
    #

    except paramiko.AuthenticationException:
        print(f"Authentication failed. Please check your username and password.")
        print(f"Python Script exception - ABENDING execution.")
        sys.exit(1)
    except paramiko.SSHException as e:
        print(f"SSH error: {e}")
        print(f"Python Script exception - ABENDING execution.")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}\n{traceback.format_exc()}")
        print(f"Python Script exception - ABENDING execution.")
        sys.exit(1)



#---------------------------------------------------------------------
# main program
# --------------------------------------------------------------------


def main():
    """
    Main function to handle the workflow of listing, selecting, uploading, executing, and downloading CLI files.
    """

    #
    #   display library versions
    #
    print(f"paramiko version: {paramiko.__version__}")

    script_start_time = time.time()

    #
    #   set logging
    #
    logging.basicConfig()
    # logging.getLogger("paramiko").setLevel(logging.INFO)
    # logging.getLogger("paramiko").setLevel(logging.DEBUG)
    logging.getLogger("paramiko").setLevel(logging.WARNING)
    # logging.getLogger("paramiko").setLevel(logging.CRITICAL)

    try:
        # Set up argument parser
        parser = argparse.ArgumentParser(description="CLI Script execution on Solace appliance")
        parser.add_argument("--hostname", "-H", required=True, help="Solace Host")
        parser.add_argument("--username", "-u", required=True, help="Solace username")
        parser.add_argument("--password", "-p", required=True, help="Encrypted file with Solace user password")
        parser.add_argument("--vpn_name", "-vpn", required=True, help="VPN Name")


        # Parse arguments
        args = parser.parse_args()
        hostname = args.hostname
        username = args.username
        password = args.password
        vpn_name  = args.vpn_name

        commands = []

        cli_dir = "/cliscripts"

        #commands.append(
        #    f"source script {cli_dir}/create_vpn.cli stop-on-error no-prompt > {cli_dir}/create_vpn.out"
        #)
        commands.append(
            f"show current-config all redact"
        )


        execute_commands_on_solace(hostname, username, password, commands)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

    #
    #  capture end time, capture elapsed time and display it

    script_end_time = time.time()
    script_elapsed_time = script_end_time - script_start_time
    print(f"Python execution Elapsed time: {script_elapsed_time:.2f} seconds")

    #
    # if error_flag is 1 then return a 1 to the caller
    #
    print(f"Value of error flag: {error_flag}")
    if error_flag == 1:
        sys.exit(1)

    #
    #   end of main code section
    #

#
error_flag = 0
if __name__ == "__main__":
    main()
