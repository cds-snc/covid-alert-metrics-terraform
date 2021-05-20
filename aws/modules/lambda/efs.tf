resource "aws_efs_file_system" "efs_for_lambda" {
  tags      = "${var.name}_efs"
  encrypted = true
}


resource "aws_efs_mount_target" "mt" {
  file_system_id  = aws_efs_file_system.efs_for_lambda.id
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
}

# EFS access point used by lambda file system
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.efs_for_lambda.id

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}