.env file in `./src` directory
```dotenv
TF_LOG=[TRACE, DEBUG, INFO, WARN or ERROR]

TF_VAR_contributors=__
TF_VAR_team_projects_backends=__

GITHUB_TOKEN=__
GITHUB_OWNER=__

ARM_CLIENT_ID=__
ARM_CLIENT_SECRET=__
ARM_SUBSCRIPTION_ID=__
ARM_TENANT_ID=__

TF_CLI_ARGS_init=`cat <<EOF
-backend-config="resource_group_name=__"
-backend-config="storage_account_name=__"
-backend-config="container_name=__"
-backend-config="key=__"
EOF`
```
