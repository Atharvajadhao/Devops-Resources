terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "5.31.0"
		}
	}
}

provider aws{
	region = "us-east-2"
	access_key = "AKIAUIBNA22BGFKV44LZ"
	secret_key = "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"
}
