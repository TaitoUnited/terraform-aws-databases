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

locals {
  tags = var.tags

  postgresqlClusters = (
    var.postgresql_clusters != null
    ? var.postgresql_clusters
    : []
  )

  mysqlClusters = (
    var.mysql_clusters != null
    ? var.mysql_clusters
    : []
  )
}

resource "aws_iam_role" "monitoring" {
  name = "${var.name}-db-monitoring"
  tags = local.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_subnet" "client_subnets" {
  for_each = {for id in var.client_subnets: id => id}
  id = each.key
}
