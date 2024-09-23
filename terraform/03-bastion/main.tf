module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name               = "${var.env}-${var.component}"
  ami                = data.aws_ami.ami_info.id
  instance_type      = var.instance_type
  subnet_id          = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

#   # Provide the user_data script
#   user_data = file("${path.module}/userdata.sh")

  tags = merge(
    var.common_tags,
    {
      Name = "${var.env}-${var.component}"
    }
  )
}

resource "cloudflare_record" "bastion" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.component
  content = module.bastion.private_ip  # Use the private IP from the EC2 instance module
  type    = "A"
  ttl     = 60
  proxied = false
  allow_overwrite = true

  # Lifecycle rules to create before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}

# resource "cloudflare_record" "bastion" {
#   zone_id = data.cloudflare_zone.zone.id
#   name    = var.component
#   content = module.bastion.private_ip  # Use the private IP from the EC2 instance module
#   type    = "A"
#   ttl     = 60
#   proxied = false
#   allow_overwrite = true
# }

