import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY
)

ec2 = session.client("ec2")
response = ec2.terminate_instances(
    InstanceIds = [
        "i-03bb1192929bb6914"
    ]
)

print(response)