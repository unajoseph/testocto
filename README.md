#prerequisite 

Terraform v1.0 or higher 

# testocto 
step to execute this project 
step 1 --> edit the file main.tf and under provider update access_key and secret_key of your aws account and save the file  
step 2 -->  from the folder testocto run the command terraform init followed by terraform plan 
step 3 --> review the plan 
step 4 --> run terraform apply 

#troubleshoot 
1. if terraform apply fails with the error "timeout",  rerun terraform apply command 
