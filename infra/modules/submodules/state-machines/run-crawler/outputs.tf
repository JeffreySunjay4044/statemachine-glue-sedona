output "state_machine_arn" {
  value = aws_sfn_state_machine.run_crawler_state_machine.arn
}

output "state_machine_name" {
  value = aws_sfn_state_machine.run_crawler_state_machine.name
}
