output "ip" {
  # value = aws_eip.elastic_ip.public_ip
  # value = aws_instance.ec2_instance.public_ip
  value = [
    for inst in aws_instance.ec2_instance :
     inst.public_ip
  ]
}
