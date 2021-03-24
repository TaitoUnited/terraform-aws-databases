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

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "database_subnets" {
  type = list(string)
}

variable "monitoring_role_arn" {
  type = string
}

variable "postgresql_clusters" {
  type = list(object({
    name = string
    version = string
    instanceClass = string
    storageType = string
    storageSizeGb = number
    maxStorageSizeGb = number
    backupRetentionDays = number
    backupWindow = string
    maintenanceWindow = string
    adminUsername = string
  }))
  default = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}

variable "mysql_clusters" {
  type = list(object({
    name = string
    version = string
    instanceClass = string
    storageType = string
    storageSizeGb = number
    maxStorageSizeGb = number
    backupRetentionDays = number
    backupWindow = string
    maintenanceWindow = string
    adminUsername = string
  }))
  default = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
