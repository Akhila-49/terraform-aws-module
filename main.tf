provider "aws" {
  region     = "${var.region}"
  access_key = "${var.accesskey}"
  secret_key = "${var.secretkey}"
}

resource "aws_instance" "myfirst" {
  ami             = "${var.ami}"
  instance_type   = "t2.micro"
  key_name        = "${var.keyname}"
  security_groups = ["${aws_security_group.allow_all1.name}"]

provisioner "remote-exec" {
    inline                  = [
        "sudo yum install httpd -y",
	     "sudo service httpd start"
    ]

    connection {
        type                = "ssh"
        user                = "ec2-user"
        private_key         = file("${var.privateKey}")
        host                = aws_instance.myfirst.public_ip
    }
  }
}
resource "aws_security_group" "allow_all1" {
  name        = "allow_all1"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-07d5db6ff22dbd67e"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}