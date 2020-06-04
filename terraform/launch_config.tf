resource "aws_launch_configuration" "rails_app" {
  lifecycle { create_before_destroy = true }
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  security_groups = [
    "${var.rails_http_inbound_sg_id}",
    "${var.rails_ssh_inbound_sg_id}",
    "${var.rails_outbound_sg_id}"
  ]
  user_data = "${file("./launch_configurations/userdata.sh")}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
}
output "rails_lc_id" {
  value = "${aws_launch_configuration.rails_lc.id}"
}
output "rails_lc_name" {
  value = "${aws_launch_configuration.rails_lc.name}"
}
