# Use AWS credentials and config from Windows path (WSL setup)
export AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/<user_name>/.aws/credentials
export AWS_CONFIG_FILE=/mnt/c/Users/<user_name>/.aws/config
# Create symbolic links to AWS config and credentials
ln -s /mnt/c/Users/<user_name>/.aws/config ~/.aws/config
ln -s /mnt/c/Users/<user_name>/.aws/credentials ~/.aws/credentials

# Start an AWS SSM automation to resize an EC2 instance
aws ssm start-automation-execution \
  --document-name "AWS-ResizeInstance" \
  --parameters '{"InstanceId":["<instance_id>"],"InstanceType":["<instance_type>"]}' \
  --region <region_name>

# Update IAM user console login password (default profile)
aws iam update-login-profile \
  --user-name <user_name> \
  --password <new_password>
# Update IAM user console login password using a specific AWS profile
aws iam update-login-profile \
  --user-name <user_name> \
  --password <new_password> \
  --profile <profile_name>

# Fetch and decode EC2 instance user-data script
aws ec2 describe-instance-attribute \
  --instance-id <instance_id> \
  --attribute userData \
  --query 'UserData.Value' \
  --output text | base64 --decode

# List IAM instance profile associations for EC2 instances
aws ec2 describe-iam-instance-profile-associations
# Detach an IAM instance profile from an EC2 instance
aws ec2 disassociate-iam-instance-profile \
  --association-id '<iam_instance_profile_id>'
# Get IAM instance profile associated with a specific EC2 instance
aws ec2 describe-iam-instance-profile-associations \
  --filters Name=instance-id,Values='<instance_id>'

# Move all objects from an S3 prefix to local directory
aws s3 mv --recursive \
  's3://<s3_bucket_name1>/<s3_prefix1>/' .
# Move local files to another S3 bucket/prefix
aws s3 mv --recursive \
  . 's3://<s3_bucket_name2>/<s3_prefix2>/'

# Create a folder (prefix) in an S3 bucket
aws s3api put-object \
  --bucket <s3_bucket_name> \
  --key <s3_prefix1>/

# Create a nested folder structure in an S3 bucket
aws s3api put-object \
  --bucket <s3_bucket_name> \
  --key <s3_prefix1>/<s3_prefix2>/

# Variables
s3_bucket="<s3_bucket_name>"
prefix="<s3_prefix>"
today_date=$(date +%Y-%m-%d)
# List S3 objects under a prefix modified on today's date
aws s3api list-objects \
  --bucket "$s3_bucket" \
  --prefix "$prefix" \
  --query "Contents[?contains(LastModified, '$today_date')].Key" \
  --output text
