locals {
  helm_template_cmd = "helm template --values='${local_file.values.filename}' --version='${var.chart.version}' '${var.release}' '${var.chart.name}'"
  values            = yamlencode(var.values)
}

resource "local_file" "values" {
  sensitive_content = local.values
  filename          = "${path.module}/values/${md5(local.values)}.yaml"

  lifecycle {
    create_before_destroy = true
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
    when    = "create"
    command = "${local.helm_template_cmd} | kubectl apply -f -"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "${local.helm_template_cmd} | kubectl delete -f -"
  }
}
