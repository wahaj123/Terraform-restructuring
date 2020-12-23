resource "aws_instance" "web" {
  ami               = var.image_id
  instance_type     = var.instance_type
  subnet_id         = var.subnets
  key_name          = var.key_name
  security_groups   = [var.security_groups.id]
  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }
  tags = {
    Name = var.name
  }
}