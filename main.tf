resource "aws_security_group" "example_sg" {
  name        = "example_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-abc123"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
