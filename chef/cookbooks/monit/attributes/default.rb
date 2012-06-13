default[:monit][:notify_email]          = "notify@example.com"

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 120

default[:monit][:eventqueue][:path]     = "/var/spool/monit"
default[:monit][:eventqueue][:slots]    = 1000

default[:monit][:httpd][:port]          = 2812
default[:monit][:httpd][:allow]         = ["localhost"]

default[:monit][:mail_format][:subject] = "$SERVICE $EVENT"
default[:monit][:mail_format][:from]    = "monit@example.com"
default[:monit][:mail_format][:message]    = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

