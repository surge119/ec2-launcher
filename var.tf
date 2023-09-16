variable "name" {
  type = string
  default = "ec2_launcher"
}

variable "ports" {
  type = list(number)
  default = [ 22, 8080 ]
}

variable "instance_type" {
  type = string
  default = "t4g.nano"
}

variable "instance_count" {
  type = number
  default = 5
}

variable "ami" {
  type = string
  // first on is arm ubuntu, second is x86 ubuntu
  default = true ? "ami-0a0c8eebcdd6dcbd0" : "ami-053b0d53c279acc90"
}