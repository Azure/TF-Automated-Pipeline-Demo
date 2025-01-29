# Introduction 
This project creates an Azure DevOps Project, imports a sample Repository, sets up deployment pipelines for multiple target environments (dev and prod) and creates all the backend Azure components.  The point of the demonstration is to show how to use pipelines and Service Principals to target environments and maintain DRY coding principles; removing the need for multiple repos for multiple environments, no need for sharing credentials with developers that can leak/wind up getting misused, etc…  There are deployment options that can get the demo closer to “real” production or make it work with potentially limited resources; like only having one Azure Subscription to work with vs. multiple.  Once deployed, the demo can be used to do some Terraform dev work just to show/see how it functions in real production.

It is not advisable to use this code in production.  Several security choices have been made for the sake of easy deployment and demonstration that make this a less than ideal production deployment.  It is possible to modify this deployment to make it production ready.  Making those changes is well beyond the scope of this demo.

# Getting Started

Requirements:

•	At least one, preferably two, Azure Subscription(s) that you have “Owner” access to

•	Azure DevOps Organization that you have the ability to create, manage, delete Projects

•	Terraform, Azure CLI, and VS Code installed on your local machine and/or an existing VM – instructions follow on how to set this up if you haven’t previously installed and done this part

If you do not have access to multiple Azure Subscriptions, don’t worry.  That’s not a deal breaker.  All the code and deployments will work with only one Subscription, it is just one step removed from showing the true power of this type of deployment.  Ideally, you have two subscriptions to use for maximum “wow” factor.  

# Build and Test

This demo creates a number of Azure resources.  In the interest of full disclosure, running through the steps below will create two Azure Resource Groups, two Storage Accounts (w/containers), two Key Vaults, two SPN’s (w/”Contributor” permissions to the target Subscription(s)), and the Demo itself will generate a single Azure Resource Group when you run either the “prod” or “dev” pipelines – up to two RG’s if you run both “apply” pipelines.  The storage accounts are not connected to any networks and have anonymous access disabled, they are public facing as is required for the demo to work.  Ideally, you will follow the instructions at the very end of this document to clean up/destroy all these resources with the same automation that created them.  Total cost of this environment (as of Q1 2025) is less than $50/mo on a pay-as-you-go account.  Additional cost will be incurred if you deploy a VM to run all your Terraform code and will vary depending on the VM sku.

# Environment Prep

All of the instructions, code, etc… can be deployed from your personal workstation or an Azure VM with a Windows-based OS.  Recommended method is to create a new Azure VM with the latest Windows client OS image.  This allows maximum flexibility and the VM can simply be deleted when you’re done and/or if problems arise that are too complex/cumbersome to troubleshoot.  You can always delete the VM and start over, it’s much more challenging to reimage your personal workstation.

Terraform install/setup

Log into your Azure VM or continue with your workstation (whichever option is appropriate):<br><br>
•	Download latest Windows Terraform package from the Hashicorp website<br>
> Extract Terraform executable into a folder (recommended “C:\Terraform”)<br>
> Add the folder to your System Environment Path. Note: if you don’t know how to do this, search “modify System Environment Path on Windows 11” in your preferred search engine.  There are ample instructions out there on how to do this<br>

•	Update PowerShell and install Azure extensions<br><br>
> Open a PowerShell window as “Administrator” and execute each of the following commands:<br>
> “Install-Module -Name PowerShellGet -Force”<br>
> “Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser”<br>
> “Install-Module -Name Az -Repository PSGallery -Force”<br>
> “Update-Module -Name Az -Force”<br>

•	Download and install the latest Azure CLI package from Microsoft<br><br>
> Can be done via PowerShell, download MSI package, etc…  Here is the PowerShell command: “Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'”<br>

•	Install VS Code – download latest image from web<br><br>
> Optionally, but strongly recommended you install VS Code extensions: Hashicorp Terraform, Azure Terraform.<br>

# Clone Git Repository and verify Terraform functionality

•	Open VS Code, select "Clone Git Repository..." and clone this repo to your VM/workstation.  Select a destination that you will remember/know as you'll need it later.<br><br>

•	Verify Terraform/CLI is functioning<br><br>
> Open a Terminal window, navigate to directory “c:…\TF-AUTOMATED-PIPELINE-DEMO\terraform\verify”
> Log into your Azure account: “az login --use-device-code”.  If you have multiple Azure subscriptions, ensure you have changed your context to the appropriate subscription and have “Contributor” or “Owner” permissions.<br><br>
> At the PowerShell Terminal window prompt, type: “terraform init” and hit “enter”. This initializes Terraform.<br><br>
> At the PowerShell Terminal window prompt, type: “terraform plan” and hit “enter”. This will show you an output of what Terraform is going to do, indicating it’s going to create a single resource, name, location, etc…<br><br>
> At the PowerShell Terminal window prompt, type: “terraform apply -auto-approve” and hit “enter”. This will deploy the Resource Group to your Azure subscription<br><br>
> Verify in Azure that you can now see the “MCAPS-TF-Validate” Resource Group<br><br>
> Return to your PowerShell window, At the PowerShell prompt, type: “terraform destroy -auto-approve” and hit “enter”. This will delete the “MCAPS-TF-Validate” Resource Group.<br><br>
Congratulations, Terraform is now setup and functioning properly!<br><br>

# ADO setup

•	Log into ADO<br>
•	Create a Personal Access Token and save it in a safe/secure location<br><br>
> How to create a PAT: https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows<br>

Required PAT Scopes – DO NOT just grant full control of everything to the PAT, that is a huge security risk and completely unnecessary for the demo to function. You will need to expand to "show all scopes" in order to assign all required:<br><br>
Agent Pools: Read & manage<br>
Build: Read & execute<br>
Code: Read, write, & manage<br>
Deployment Groups: Read & manage<br>
Environment: Read & manage<br>
Identity: Read & manage<br>
Member Entitlement Management: Read & write<br>
Pipeline Resources: Use & manage<br>
Project and Team: Read, write, & manage<br>
Release: Read, write, execute, & manage<br>
Service Connections: Read, query, & manage<br>
Variable Groups: Read, create, & manage<br>

•	Retrieve your Azure DevOps organization url (https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/organization-management?view=azure-devops)<br>

# Azure setup

•	In VSCode, open the following files:<br>
    	../terraform/adobuild/terraform.tfvars<br>
    	../terraform/azureprep/terraform.tfvars<br><br>
•	Follow the instructions in the comments for each file – no other changes need to be made to any files in the demo.  Making additional changes will result in unknown behavior and is not recommended.<br><br>
•	SAVE YOUR CHANGES<br><br>
•	Open a Terminal window, change directory to “c:…\terraform\azureprep”<br><br>
•	If you haven’t continued from the previous steps above, log into your Azure account: “az login --use-device-code”, otherwise, skip this step.  If you have multiple Azure subscriptions, ensure you have changed your context to the appropriate subscription and have “Contributor” or “Owner” permissions<br><br>
•	At the PowerShell Terminal window prompt, type: “terraform init” and hit “enter”<br><br>
•	At the PowerShell Terminal window prompt, type: “terraform apply -auto-approve” and hit “enter”. This will generate two Azure Resource Groups, two Azure Storage Accounts, two Key Vaults, a number of Key Vault secrets, and two Azure SPN’s and apply “Contributor” permissions to the target subscription(s).<br><br>
> IF Terraform fails creating a resource, try running the “terraform apply -auto-approve” again, sometimes the Azure/Terraform automation doesn’t get all the automatic ‘depends on’ logic right the first time.<br>
> Open your Azure Portal and verify you now have two Resource Groups:<br>
    	"MCAPS-prod-demo" – w/storage account: prodstoragetfdemo and a Key Vault w/multiple secrets<br>
    	"MCAPS-dev-demo" – w/storage account: devstoragetfdemo and a Key Vault w/multiple secrets<br>

# Deploying ADO Project

•	Open VS Code, if you have not done so already, follow the instructions above to get your environment setup and/or follow the readme.md file<br><br>
•	Open a Terminal window in VS Code, change directory to “c:…\terraform\adobuild”<br><br>
•	If you have not continued from a previous step, log into your Azure tenant and set context to the appropriate Subscription (az login --use-device-code)<br><br>
•	In the terminal type: “terraform init” and hit “enter”<br><br>
•	In the terminal type: “terraform plan”<br>
>	    Note: you do not need to specify the terraform.tfvars file because Terraform is smart enough to look for and use that file if it is present in the directory. This will run and validate the plan but will not deploy anything. If the plan successfully executes move onto the next step.<br><br>

•	In the terminal type: “terraform apply -auto-approve”. This will run and apply the Terraform code to your ADO environment.<br>
> NOTE: if there are 401 errors when Terraform is attempting to build the environment, this is likely due to improper permissions on the Personal Access Token, double check that the appropriate scope/permissions have been granted to the PAT and try again.<br><br>

•	Log into ADO and verify the new ADO Project is visible<br><br>
•	Run the pipelines, verify in the Azure portal that the appropriate resources are being created, deleted, etc… NOTE: you will likely need to approve resource access the first time you run a pipeline, simply approve the request and the pipeline will execute, this is a one-time approval.<br><br>
•	If desired, you can connect to the repo generated by the Demo, create a branch, make some updates, commit, and push with the pipelines – this is purely optional, keep in mind anything you create with the demo will need to be manually deleted later as there are only "plan" and "apply" pipelines.  Or build your own "destroy" pipeline as an exercise.  Future versions of this demo will have instructions on how to do this.<br><br>

# CLEAN UP YOUR ENVIRONMENT

•	When you are done, clean up the resources from the terminal. Ensure you are still in the “c:…\terraform\adobuild” folder and type: “terraform destroy -auto-approve” and hit “enter”. This will delete all ADO resources previously deployed by the Demo.<br><br>

•	In the Terminal window, change directory to “c:…\terraform\azureprep”, run “terraform init”, run “terraform destroy -auto-approve”. This will destroy the Service Principals, Storage Accounts, Key Vaults and Resource Groups.<br><br>

•	Log into your Azure Portal – manually locate and delete the Resource Group(s) deployed by the ADO pipeline(s)<br><br>


