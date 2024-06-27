locals {
  vpc_id = "vpc-gl8fd81k605vbw69hp9ge" #测试VPC
  vswitch_id = "vsw-gl8wsvkhs1cnbs4w2t8hf"  #测试vswitch
  prefix = "test-"  #项目代码作为前缀
  count = 3

  sg-ingress-rules = [ "443/443","22/22"]
  ecs-groups = [
    {
      group-name = "",
      count = "",
      system_disk_size = 50,

    }
  ]
}


data "alibabacloudstack_instance_types" "default" {
  cpu_core_count = 4
  memory_size    = 8
}

data "alibabacloudstack_images" "default" {
  name_regex  = "^centos_7_9"
  most_recent = true
  owners      = "system"
}

# 按照密码策略生成密码
resource "random_password" "password" {
  count = local.count
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# 虚拟机
resource "alibabacloudstack_instance" "ecs" {
  count = local.count
  image_id             = data.alibabacloudstack_images.default.images.0.id
  instance_type        = data.alibabacloudstack_instance_types.default.instance_types.0.id
  password             = random_password.password[count.index].result
  system_disk_category = "cloud_sperf"
  system_disk_size     = 600
  security_groups      = [alibabacloudstack_security_group.default.id]
  instance_name        = "${local.prefix}_${count.index}"
  host_name            = "${local.prefix}_${count.index}"
  vswitch_id           = local.vswitch_id
  tags = {
  "env" = "testing",
  "For" = "Test"
  }
}

# 安全组
resource "alibabacloudstack_security_group" "default" {
  name        = "default"
  description = "default"
  vpc_id      = local.vpc_id
}

# 安全组策略
resource "alibabacloudstack_security_group_rule" "default" {
  count = length(local.sg-ingress-rules)
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "drop"
  port_range = local.sg-ingress-rules[count.index]
  priority = 100
  cidr_ip ="0.0.0.0/0"
  security_group_id = "${alibabacloudstack_security_group.default.id}"
  description = "abc"
}


output "ecsinfo" {
  sensitive = true
  value = alibabacloudstack_instance.ecs.*
}


