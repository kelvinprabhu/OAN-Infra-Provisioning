output "launch_template_id" { value = aws_launch_template.main.id }
output "asg_name"           { value = aws_autoscaling_group.main.name }
output "instance_ids"       { value = aws_autoscaling_group.main.id }
