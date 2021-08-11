
resource "aws_lb" "tomcat" {
  name               = "tomcat-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets  = ["${aws_subnet.data[0].id}","${aws_subnet.data[1].id}","${aws_subnet.data[2].id}"]
  enable_deletion_protection = false


  tags = {
    Environment = "dev"
  }
}


# instance target group

resource "aws_lb_target_group" "tomcat" {
  name     = "tomcat-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.petclinic.id
}



resource "aws_lb_target_group_attachment" "tomcat" {
  target_group_arn = aws_lb_target_group.tomcat.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}





# listner


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.tomcat.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tomcat.arn
  }
}
