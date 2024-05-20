/**
 * Copyright 2024 Google LLC
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

data "google_compute_network" "host-network" {
  name    = var.created_resources.vpc_name
  project = var.project_id
}

data "google_compute_subnetwork" "host-subnetwork" {
  name    = var.created_resources.subnet_name
  project = var.project_id
  region  = var.region
}

module "service-project" {
  source          = "../../../../modules/project"
  name            = var.service_project.project_id
  prefix          = var.prefix
  project_create  = var.service_project.billing_account_id != null
  billing_account = try(var.service_project.billing_account_id, null)
  parent          = try(var.service_project.parent, null)
  services = [
    "compute.googleapis.com",
    "run.googleapis.com",
  ]
  shared_vpc_service_config = {
    host_project = var.project_id
  }
  skip_delete = true
}