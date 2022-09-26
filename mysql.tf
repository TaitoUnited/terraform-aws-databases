/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "aws_security_group" "mysql" {
  name_prefix = "mysql"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      for subnet in data.aws_subnet.client_subnets:
      subnet.cidr_block
    ]
  }

  tags = local.tags
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql"
  subnet_ids = var.database_subnets

  tags = local.tags
}

resource "random_string" "mysql_admin_password" {
  for_each = {for item in local.mysqlClusters: item.name => item}

  length  = 32
  special = false
  upper   = true

  keepers = {
    mysql_instance = each.value.name
    mysql_admin    = each.value.adminUsername
  }
}

module "mysql" {
  for_each = {for item in local.mysqlClusters: item.name => item}

  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  identifier = each.value.name
  username   = each.value.adminUsername
  password   = random_string.mysql_admin_password[each.key].result
  port       = "3306"

  # parameter_group_name            = each.value.name
  # parameter_group_use_name_prefix = false

  iam_database_authentication_enabled = each.value.iamEnabled

  tags = local.tags

  engine                = "mysql"
  family                = each.value.family
  engine_version        = each.value.version
  instance_class        = each.value.instanceClass
  allocated_storage     = each.value.storageSizeGb
  max_allocated_storage = each.value.maxStorageSizeGb
  storage_type          = each.value.storageType
  storage_encrypted     = false

  # TODO: kms_key_id  = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = each.value.maintenanceWindow
  backup_window      = each.value.backupWindow

  vpc_security_group_ids = [aws_security_group.mysql.id]
  subnet_ids             = var.database_subnets
  db_subnet_group_name   = aws_db_subnet_group.mysql.name

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  backup_retention_period = each.value.backupRetentionDays

  # Logging
  enabled_cloudwatch_logs_exports = ["audit", "slowquery"]

  # Enhanced Monitoring
  # TODO: Disabled as this doesn't seem to work
  monitoring_interval = "0"
  monitoring_role_arn = aws_iam_role.monitoring.arn

  parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    },
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"
      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
