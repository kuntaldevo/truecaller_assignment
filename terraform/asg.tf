resource "aws_autoscaling_group" "rails_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = ["${var.pub_subnet_id}"]
  name = "some_name"
  max_size = "2"
  min_size = "2"
  force_delete = true
  launch_configuration = "${var.rails_lc_id}"
  load_balancers = [" "]
  tag {
    key = "Name"
    value = "terraform_asg"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name = "terraform_asg_scale_up"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.rails_asg.name}"
}


resource "aws_autoscaling_policy" "scale_down" {
  name = "terraform_asg_scale_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = "${aws_autoscaling_group.rails_asg.name}"
}

