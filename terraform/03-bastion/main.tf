resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id     = element(split(",",data.aws_ssm_parameter.public_subnet_id.value),0)
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                      = "0"  # Set to 0 for the lowest price, meaning use the current spot price.
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    component = var.component
  }))


  tags = {
    Name = "${var.env}-${var.component}"
  }
}


resource "cloudflare_record" "backend" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.component
  content = aws_instance.frontend.private_ip
  type    = "A"
  ttl     = 60
  proxied = false
  allow_overwrite = true
}
