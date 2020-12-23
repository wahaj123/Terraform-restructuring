output "output" {
  value = {
    cidr_block     = aws_vpc.main.cidr_block
    id             = aws_vpc.main.id
    public_subnet  = aws_subnet.public_subnet.*.id
    private_subnet = aws_subnet.private_subnet.*.id
  }
}