
## **Deploying a spring boot app on an openshift cluster.**

Deploying a simple spring boot app on an openshift cluster with AWS integration for hosting jenkins CI/CD and sonarqube for code quality testing.

![Architecture Diagram](https://github.com/nader12P/MultiCloudDevOpsProject/blob/main/Architecture_Diagram.png)

**Content:**
- Terraform
  - Terraform code and modules to provision necessary resources for the CI/CD and testing environment on AWS and integrating CloudWatch to monitor the ec2 instance CPU utilization
- Ansible
  - Ansible roles for installing docker, jenkins, sonarqube and copying necessary files for deployment
- Dockerfile for image build
- Jenkinsfile for CI/CD pipeline
- Jenkins shared library files
- Application files

**Prerequisites:**
- AWS Account
- AWS CLI
- Terraform
- Ansible
- Docker hub account
- Github account

## AWS:
- Create a user with admin privileges.
- Create a key pair
- Configure AWS CLI on your machine with the user's ACCESS_KEY_ID & SECRET_ACCESS_KEY

## Terraform:
- Change *key_name* and *email* in the *values.auto.tfvars* file
- Comment the *backend "s3"* block in the *main.tf* file for an s3 bucket resource to be created for out state files
- Run the following commands
`terraform init`
`terraform apply`
 - Uncomment *backend "s3"* block in the *main.tf* file  and run the command again to associate the backend with the s3 bucket
 `terraform init`
  `terraform apply`

## Ansible:
- Install the following collections

`ansible-galaxy collection install community.docker`
`ansible-galaxy collection install amazon.aws`
- Put the path of your downloaded key from AWS in the *ansible.cfg* file
- Run the *main.yml* playbook, *make sure you are in the ansible directory*

`[user@host ansible]$ ansible-playbook main.yml`
- Make sure you copy the jenkins initial admin password from the ansible debug output

## GitHub:
- Generate token
	- Go to your profile > Developer settings > Personal access tokens > Tokens (classic) > Generate new token (classic)
- Create Webhook
	- Go to your repository settings, select *Webhooks* from the side menu and then press *Add webhook*
	- Payload URL: http://URL_TO_JENKINS/github-webhook/
	- Content type: application/json
	- Select *Send me everything*

## SonarQube:

- Login with *admin* as username and password
- Create a local project with global settings
- Generate a token
	- Go to *My Account* > *Security* > *Generate Token*
	- Enter preferred token name
	- Choose user token for the type
	- Select preferred expiration period
	- Press *Generate*
	- Copy the generated token

## Jenkins Credentials:
- Create Credentials
	- Dashboard > Manage Jenkins > Credentials
	- Select the global domain
 - Docker Hub credentials
	 - Kind: Username and password
	 - Username: (Your docker hub username)
	 - Password: (Your docker hub password)
	 - ID: (ID to identify credentials, Ex. dockerhub)
- GitHub credentials
	 - Kind: Username and password
	 - Username: (Your GitHub username)
	 - Password: (Your GitHub token)
	 - ID: (ID to identify credentials, Ex. github)
- SonarQube credentials
	 - Kind: Secret text
	 - Secret: (Your SonarQube token)
	 - ID: (ID to identify credentials, Ex. sonartoken)
- OpenShift credentials
	 - Kind: Secret file
	 - Secret: (Your cluster config file)
	 - ID: (ID to identify credentials, Ex. openshift)

## Jenkins Plugins:
- Install Plugins
	- Dashboard > Manage Jenkins > Plugins > Available Plugins
	- Search for *SonarQube Scanner* and install the plugin

## Jenkins SonarQube Tool Installation:
- Dashboard > Manage Jenkins > Tools
- Scroll down to SonarQube Scanner installations
- Press *Add SonarQube Scanner*
	- Name: (Name to identify the tool, Ex. sonarqube)
	- Version: (Select the latest version)

## Jenkins Pipeline creation:
- Dashboard > New Item
- Enter pipeline name and select *Pipeline*
- Configure
	- Build Triggers > GitHub hook trigger for GITScm polling
	- Pipeline > Definition > Pipeline script from SCM
		- SCM: Git
		- Repository URL: (Your repository URL)
		- Branches to build: */main

## Build Pipeline:
- Edit the Jenkinsfile and the library files in vars directory to match your credential IDs, URLs and tools
	- Jenkinsfile
		- SONARQUBE_PROJECT_NAME
		- SONAR_HOST_URL
		- IMAGE_NAME
		- DOCKERHUB_REGISTERY_NAME
		- OPENSHIFT_SERVER_URL
		- OPENSHIFT_PROJECT_NAME
	- vars > sonarQube.groovy
		- SONARQUBE_TOOL_INSTALLATION_NAME
		- SONARQUBE_CREDENTIAL_ID
	- vars > createApp.groovy
		- OPENSHIFT_CREDENTIAL_ID
- Select the created pipeline and press *Build Now*






