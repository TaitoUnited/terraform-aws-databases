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

resource "aws_security_group" "postgres" {
  name_prefix = "postgres"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "10.10.1.0/24",
      "10.10.2.0/24",
      "10.10.3.0/24",
    ]
  }

  tags = local.tags
}

resource "random_string" "postgres_admin_password" {
  for_each = {for item in local.postgresqlClusters: item.name => item}

  length  = 32
  special = false
  upper   = true

  keepers = {
    postgres_instance = each.value.name
    postgres_admin    = each.value.adminUsername
  }
}

module "postgres" {
  for_each = {for item in local.postgresqlClusters: item.name => item}

  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.0"

  identifier = each.value.name
  username   = each.value.adminUsername
  password   = random_string.postgres_admin_password[each.key].result
  port       = "5432"

  tags = local.tags

  engine                = "postgres"
  engine_version        = each.value.version
  instance_class        = each.value.instanceClass
  allocated_storage     = each.value.storageSizeGb
  max_allocated_storage = each.value.maxStorageSizeGb
  storage_type          = each.value.storageType
  storage_encrypted     = false

  # TODO: kms_key_id = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = each.value.backupWindow
  backup_window      = each.value.maintenanceWindow

  vpc_security_group_ids = [aws_security_group.postgres.id]
  subnet_ids             = var.database_subnets

  # Snapshot name upon DB deletion
  final_snapshot_identifier = each.value.name

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  backup_retention_period = each.value.backupRetentionDays

  # Logging
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Enhanced Monitoring
  monitoring_interval = "30"
  monitoring_role_arn = aws_iam_role.monitoring.arn
}
