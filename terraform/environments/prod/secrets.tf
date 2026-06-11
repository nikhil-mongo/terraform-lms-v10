# Fetch the secret value for use in MongoDB Atlas database user resources
data "aws_secretsmanager_secret" "my_secret" {
  name = "atlascreds"
}
data "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = data.aws_secretsmanager_secret.my_secret.id
}
