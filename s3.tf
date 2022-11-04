##  In this project i plan to create an s3 bucket, enabled versionning, encryption, block it for public access
##  We will create an S3 bucket by using the aws_s3_bucket resource

resource "aws_s3_bucket" "dev_devops" {
  bucket = "devopspro-s3"
 
  # Prevent accidental deletion of this S3 bucket
  /* lifecycle {
    prevent_destroy = true
  } */
}

##  now add several extra layers of protection to this S3 bucket
##  First, use the aws_s3_bucket_versioning resource to enable 
##  versioning on the S3 bucket so that every update to a file in the bucket actually creates a new version of that file.

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.dev_devops.id
  versioning_configuration {
    status = "Enabled"
  }
}

##  Second, use the aws_s3_bucket_server_side_encryption_configuration resource to
##  turn server-side encryption on by default for all data written to this S3 bucket


resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.dev_devops.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

## Third, use the aws_s3_bucket_public_access_block resource to block all public access to the S3 bucket

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.dev_devops.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##  We will create a DynamoDB table to use for locking our statefile and avoid 2 engineer to apply at the same time
  
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "devopspro-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

## To delete the resource you need to manually delete the lock on the statefile
## Copy the dynamo db id and run the commmand
##  terraform force-unlock <dynamodb ib>
##  terraform destroy -lock=false