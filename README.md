# alpine-rabbitmq-autocluster
RabbitMQ image with the autocluster plugin

RabbitMQ Version: 3.6.6

### Enabled plugins
```
Configured: E = explicitly enabled; e = implicitly enabled
[e ] amqp_client                       3.6.6
[E ] autocluster                       0.6.1
[e ] cowboy                            1.0.3
[e ] cowlib                            1.0.1
[e ] mochiweb                          2.13.1
[  ] rabbitmq_amqp1_0                  3.6.6
[  ] rabbitmq_auth_backend_ldap        3.6.6
[  ] rabbitmq_auth_mechanism_ssl       3.6.6
[e ] rabbitmq_aws                      0.1.2
[E ] rabbitmq_consistent_hash_exchange 3.6.6
[E ] rabbitmq_delayed_message_exchange 0.0.1
[  ] rabbitmq_event_exchange           3.6.6
[E ] rabbitmq_federation               3.6.6
[E ] rabbitmq_federation_management    3.6.6
[  ] rabbitmq_jms_topic_exchange       3.6.6
[E ] rabbitmq_management               3.6.6
[e ] rabbitmq_management_agent         3.6.6
[E ] rabbitmq_management_visualiser    3.6.6
[E ] rabbitmq_message_timestamp
[E ] rabbitmq_mqtt                     3.6.6
[E ] rabbitmq_recent_history_exchange  1.2.1
[E ] rabbitmq_sharding                 0.1.0
[E ] rabbitmq_shovel                   3.6.6
[E ] rabbitmq_shovel_management        3.6.6
[E ] rabbitmq_stomp                    3.6.6
[E ] rabbitmq_top                      3.6.6
[  ] rabbitmq_tracing                  3.6.6
[  ] rabbitmq_trust_store              3.6.6
[e ] rabbitmq_web_dispatch             3.6.6
[E ] rabbitmq_web_stomp                3.6.6
[  ] rabbitmq_web_stomp_examples       3.6.6
[e ] sockjs                            0.3.4
[e ] webmachine                        1.10.3
```

### Configuration
All configuration of the auto-cluster plugin should be done via environment variables.

See the [RabbitMQ AutoCluster](https://github.com/aweber/rabbitmq-autocluster/wiki) plugin Wiki for configuration settings.

### Example Usage
The following example configures the `autocluster` plugin for use in an AWS EC2 Autoscaling group:

```bash
docker run --name rabbitmq -d \
  -e AUTOCLUSTER_TYPE=aws \
  -e AUTOCLUSTER_CLEANUP=true \
  -e CLEANUP_WARN_ONLY=false \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -p 4369:4369 \
  -p 5672:5672 \
  -p 15672:15672 \
  -p 25672:25672 \
  checkr/rabbitmq-autocluster
```
To use the AWS autocluster features, you will need an IAM policy that allows the plugin to discover the node list. The following is an example of such a policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

If you do not want to use the IAM role for the instances, you could create a role and specify the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` when starting the container.

There is a [CloudFormation template](https://github.com/checkr/coreos-rabbitmq-autocluster/blob/master/cloudformation.tpl.json) that is used to generate `cloudformation.json` by running `make gen`. The template creates an IAM Policy and Role, Security Group, ELB, Launch Configuration, and Autoscaling group.
