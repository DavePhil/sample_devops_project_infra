terraform {
  backend "remote" {
    organization = "devopslearningM2"
    workspaces {
      name = "first_terraform"
    }
  }
}

resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "Terraform-Server"
  }

  # Security Group to allow SSH access
  vpc_security_group_ids = [aws_security_group.sg1.id]

  provisioner "file" {
    source      = "../ansible/playbook.yml"
    destination = "/tmp/playbook.yml"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "../my-ssh-key.pem"
    destination = "/tmp/my-ssh-key.pem"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3-pip",
      "sudo pip3 install ansible",
      "sudo chmod 600 /tmp/my-ssh-key.pem",
      "echo ${var.dockerhub_pwd}",
      "echo ${var.docker_user_name}",

      # Création du fichier vars.yml
      "echo 'docker_user_name: \"${var.docker_user_name}\"' > /tmp/vars.yml",
      "echo 'dockerhub_pwd: \"${var.dockerhub_pwd}\"' >> /tmp/vars.yml",
      "echo 'image_name: \"${var.image_name}\"' >> /tmp/vars.yml",

      # Création dynamique de l'inventaire Ansible
      "echo '[servers]' > /tmp/inventory.ini",
      "echo 'my_server ansible_host=${self.public_ip}' >> /tmp/inventory.ini",
      "echo '[servers:vars]' >> /tmp/inventory.ini",
      "echo 'ansible_ssh_user=ubuntu' >> /tmp/inventory.ini",
      "echo 'ansible_ssh_private_key_file=/tmp/my-ssh-key.pem' >> /tmp/inventory.ini",
      "echo 'ansible_ssh_common_args=\"-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\"' >> /tmp/inventory.ini",
      "ansible-playbook -i /tmp/inventory.ini -u ubuntu --private-key /tmp/my-ssh-key.pem /tmp/playbook.yml --extra-vars '@/tmp/vars.yml'"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt-get update
  #             sudo apt-get install -y python3-pip
  #             EOF
}

resource "aws_security_group" "sg1" {
  name        = "terraform-sg1"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
