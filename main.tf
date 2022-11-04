## We need to configure Terraform to store the state in your S3 bucket (with encryption and locking), 
## so we need to add a backend configuration to your Terraform code

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "devopspro-s3"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "devopspro-db"
    encrypt        = true
  }
}