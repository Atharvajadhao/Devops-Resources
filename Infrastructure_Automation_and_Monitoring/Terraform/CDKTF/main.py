#!/usr/bin/env python
from constructs import Construct
from cdktf import App, NamedRemoteWorkspace, TerraformStack, TerraformOutput, RemoteBackend
from cdktf_cdktf_provider_aws.provider import AwsProvider
from cdktf_cdktf_provider_aws.instance import Instance


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, ns: str):
        super().__init__(scope, ns)

        AwsProvider(self, "AWS", region="us-east-2")

        instance = Instance(self, "compute",
                            ami="ami-05fb0b8c1424f266b",
                            instance_type="t2.micro",
                            )
        TerraformOutput(self, "instance_public_ip",
                        value=instance.public_ip,
                        )


app = App()
stack = MyStack(app, "aws_instance")

RemoteBackend(stack,
              hostname='app.terraform.io',
              organization='my_demo_org_atharva',
              workspaces=NamedRemoteWorkspace('cdktf_practice')
              )

app.synth()
