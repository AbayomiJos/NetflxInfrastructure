#terraform {
 # backend "s3" {
   # bucket         = "infras-terraform-remote-state"
   # key            = "infras/terraform/state.tfstate"
   # region         = "us-west-1"
   # encrypt        = true

    # Optional: Configure DynamoDB table for state locking
    #dynamodb_table = "infras-terraform-remote-lock"
 # }
#}
