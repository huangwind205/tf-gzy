terraform {
  required_providers {
    alibabacloudstack = {
      source = "aliyun/alibabacloudstack"
      version = "1.0.22"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "alibabacloudstack" {
  access_key = "xxx"
  secret_key = "xxxxx"
  region     = "cn-wh-hbgzy-d01"
  insecure    =  true
  resource_group_set_name ="Testing"
  domain = "internal.asapi.cn-wh-hbgzy-d01.ops.hbgzcloud.com/asapi/v3"
  protocol = "HTTP"
}

