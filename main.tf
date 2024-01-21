resource "aws_vpc" "mtc_aws" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_aws.id
  cidr_block              = "10.123.1.0/24"
  availability_zone       = "${var.provider_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_public"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_aws.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_aws.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}


resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "Allow inbound traffic - dev"
  vpc_id      = aws_vpc.mtc_aws.id


  /* El contenedor no tiene acceso a internet por defecto, es recomendado que el
  cidr_block sea restrictivo, por ejemplo "192.168.0.1/32" para que solo pueda
  hacer ping a una ip especifica. o un grupo de ips.
  
  En este caso se permite el acceso a cualquier ip de internet a cualquier
  puerto y protocolo. */
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # El contenedor no tiene salida a internet por defecto, el cidr_block debe 
  # ser "0.0.0.0/0" para que pueda hacer ping a cualquier ip de internet.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("${var.ssh_key_path}.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev_node"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityFile = var.ssh_key_path
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
    //interpreter = ["bash", "-c"] # For Linux
    #interpreter = ["Powershell", "-Command"] # For Windows
  }
}
