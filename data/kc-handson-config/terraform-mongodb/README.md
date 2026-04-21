# Kakao i Cloud - MongoDB Replicaset (w/Terraform)

## Require
* **Terraform** (version >= 1.0)

## Install
	git clone -b docs/mongodb-replicaset  https://github.com/kakaoicloud/hands-on-examples.git

## Execute
```bash
mkdir -p ~/.config/openstack/
cat << EOF > ~/.config/openstack/clouds.yaml
clouds:
  hands-on:
    region_name: 'kr-central-1'
    interface: 'public'
    auth_type: "v3applicationcredential"
    auth:
      auth_url: '<https://identity.kr-central-1.kakaoi.io/v3>' 
      application_credential_id: "${USER_ACCESS_KEY_ID}"
      application_credential_secret: "${USER_ACCESS_SECRET_KEY}"
EOF
```

    cd hands-on-examples
    export OS_CLOUD=hands-on
    terraform init
    terraform plan
    terraform apply
