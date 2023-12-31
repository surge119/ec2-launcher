variable "name" {
  type    = string
  default = "ec2_launcher"
}

variable "ports" {
  type    = list(number)
  default = [22, 8080]
}

variable "instance_type" {
  type    = string
  default = "c7gn.xlarge"
}

variable "ami" {
  type = string
  // first on is arm ubuntu, second is x86 ubuntu
  default = true ? "ami-0a0c8eebcdd6dcbd0" : "ami-053b0d53c279acc90"
  // first is arm amazon linux, second is x86
  // default = true ? "ami-06f9c0b2ce386dda7" : "ami-04cb4ca688797756f"
}
