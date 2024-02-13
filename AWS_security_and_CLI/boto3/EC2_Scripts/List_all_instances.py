import json
import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY
)

ec2 = session.client("ec2")
all_instances = ec2.describe_instances()

# print(all_instances)
for instance in all_instances['Reservations']:
    print("Instance Name:", instance['Instances'][0]['Tags'][0]["Value"])
    print("    Instance Id:", instance['Instances'][0]['InstanceId'])
    print("    Instance Private IP:", instance['Instances'][0]['NetworkInterfaces'][0]['PrivateIpAddress'])
    