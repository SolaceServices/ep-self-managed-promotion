# ep-self-managed-promotion
GitHub Actions - EP Self-Managed Integration 

Promoting Event Portal Changes via GitHub Actions
Event Portal supports a Self-Managed CI/CD mode where you control when and how configuration is pushed to your event brokers — perfect for GitHub Actions workflows.

Step 1: Configure Your Environment for Self-Managed CI/CD
In Solace Cloud, set the runtime configuration option for your environment to Self-Managed. This tells Event Portal to:

Create a configuration push job when you promote an application
Not automatically push it — your pipeline takes over from there
See Setting Event Portal Runtime Configuration Options for how to configure this at the environment level.

Step 2: Obtain a Solace Cloud API Token
Your GitHub Action will need an API token with these permissions (depending on what it needs to do):

Action	Required Permission
Get application/push job IDs	application:get:*
Run a push job (on-demand mode)	application_configuration_push_job:run:*
Fetch Terraform HCL config	application_configuration_push_job:*:*
Update push job status	application_configuration_push_job:update_status:*
Store the token as a GitHub Actions secret (e.g., SOLACE_CLOUD_API_TOKEN).

Step 3: Build Your GitHub Actions Workflow
Your workflow will call three Event Portal REST APIs in sequence:

3a. Get the Application ID
Call the Get an application API using the app name or domain ID to retrieve the application's ID.

3b. Get the Configuration Push Job ID
Call Get a list of configuration push jobs by application identifier with the application ID. Locate the relevant job and capture its id.

3c. Retrieve the Terraform HCL Configuration
Call Get a configuration push job's runtime configurations with the jobId. This returns the full broker configuration as Terraform HCL.

3d. Apply the Configuration
Use terraform apply (or your own tooling) to provision the broker with the returned HCL.

3e. Update the Status in Event Portal
Since self-managed pushes don't auto-update status, call Update the status of a configuration push job to keep Event Portal in sync with your actual deployment state.