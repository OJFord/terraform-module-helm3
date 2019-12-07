locals {
  values          = yamlencode(var.values)
  values_file     = "${path.module}/values/${md5(local.values)}.yaml"
  old_values_file = "${path.module}/values/prior.yaml"
}

resource "local_file" "values" {
  sensitive_content = local.values
  filename          = local.values_file
  file_permission   = "0660"

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    when    = destroy
    command = "mv ${self.filename} ${local.old_values_file}"
  }
}

resource "null_resource" "chart" {
  triggers = {
    chart_name    = var.chart.name
    chart_version = var.chart.version
    release       = var.release
    values        = md5(local_file.values.sensitive_content)
  }

  provisioner "local-exec" {
    when    = create
    command = "helm template --values='${local.values_file}' --version='${var.chart.version}' '${var.release}' '${var.chart.name}' | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "helm template --values='${local.old_values_file}' --version='${var.chart.version}' '${var.release}' '${var.chart.name}' | kubectl delete -f -"
  }
}
