#
#   YOU MUST FILL IN THE VALUES FOR THE VARIABLES BELOW

#   *** THE SUBSCRIPTIONS ARE THE DEPLOYMENT TARGETS, IF YOU ONLY HAVE ONE SUBSCRIPTION, USE THAT VALUE FOR BOTH dev_subscription_id AND prod_subscription_id
#   *** THE EMAIL ALIAS IS USED TO DISPLAY THE SERVICE PRINCIPAL AND APPLICATION INFORMATION IN ENTRA, IF YOU EVER NEED TO REFERENCE IT LATER/IF SOMETHING GOES WRONG

#   YOU MUST PROVIDE AZURE SUBSCRIPTION(S) AND AN EMAIL ALIAS FOR THE PERSON LOGGED INTO AZURE RUNNING THE DEMO
dev_subscription_id  = "<DEV_SUBSCRIPTION>"  # This is the subscription ID for the development environment, or the subscription you have access to
prod_subscription_id = "<PROD_SUBSCRIPTION>" # This is the subscription ID for the production environment, or the subscription you have access to
app_owner = "<your@email.here>" # This is generally going to be the email address of the person running the script, someone who can create Service Pincipals and Applications in Azure
