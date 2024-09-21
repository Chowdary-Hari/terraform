resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id     = data.aws_ssm_parameter.public_subnet.value
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion.value]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                      = "0"
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.component}-${var.env}-bastion"
    }
  )
}
