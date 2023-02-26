.env file in `./src` directory
```dotenv
TF_LOG=[TRACE, DEBUG, INFO, WARN or ERROR]

TF_VAR_subscription_id=__
TF_VAR_owners=__

TF_CLI_ARGS_init=`cat <<EOF
-backend-config="resource_group_name=__"
-backend-config="storage_account_name=__"
-backend-config="container_name=__"
-backend-config="key=__"
EOF`
```
