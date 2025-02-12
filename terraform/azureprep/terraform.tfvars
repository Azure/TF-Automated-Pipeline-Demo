#
#   YOU MUST FILL IN THE VALUES FOR THE VARIABLES BELOW

#   *** THE SUBSCRIPTIONS ARE THE DEPLOYMENT TARGETS, IF YOU ONLY HAVE ONE SUBSCRIPTION, USE THAT VALUE FOR BOTH dev_subscription_id AND prod_subscription_id
#   *** THE EMAIL ALIAS IS USED TO DISPLAY THE SERVICE PRINCIPAL AND APPLICATION INFORMATION IN ENTRA, IF YOU EVER NEED TO REFERENCE IT LATER/IF SOMETHING GOES WRONG

#   YOU MUST PROVIDE AZURE SUBSCRIPTION(S) AND AN EMAIL ALIAS FOR THE PERSON LOGGED INTO AZURE RUNNING THE DEMO
dev_subscription_id  = "<DEV_SUBSCRIPTION>"  # This is the subscription ID for the development environment, or the subscription you have access to
prod_subscription_id = "<PROD_SUBSCRIPTION>" # This is the subscription ID for the production environment, or the subscription you have access to
app_owner = "<your@email.here>" # This is generally going to be the email address of the person running the script, someone who can create Service Pincipals and Applications in Azure


#   *** NO CHANGES SHOULD BE NECESSARY BELOW THIS LINE ***
#   These are Key Vault names for the development and production environments, Key Vaults need to have a unique name and it's
#   possible the default names are already in use in your subscription, if so, you can change them here
#   this will manifest as a deployment failure when running "Terraform apply" in the "azureprep" directory.  A "Terraform plan"
#   will not show this error, so do not be alarmed if you see a name conflict error when deploying the infrastructure.

#  NOTE: if you change these values, you will need to update the "terraform.tfvars" file in the "adobuild" directory to reflect the new names

prod_kv_name = "prod-kv-demo"

dev_kv_name = "dev-kv-demo"