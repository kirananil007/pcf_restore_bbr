#!/bin/bash -eu

. "$(dirname $0)"/../../scripts/export-director-metadata
#echo $OPSMAN_KEY > ~/ssh_access
#chmod 600 ~/ssh_access
#chown $USER.$USER ~/ssh_access

echo $OPSMAN_KEY  | sed -e 's/\(KEY-----\)\s/\1\n/g; s/\s\(-----END\)/\n\1/g' | sed -e '2s/\s\+/\n/g' > ~/ssh_access.pem
chmod 600 ~/ssh_access.pem
ssh-agent > ~/agent
eval $(ssh-agent -s)
ssh-add ~/ssh_access.pem

#login to opsman
ssh -i ~/ssh_access.pem -o "StrictHostKeyChecking no"  "${OPSMAN_USER_EC2}"@"${OPSMAN_IP}" <<EOF
cd /var/tempest/workspaces/default/
##set ENV variables for BOSH_CLIENT && BOSH_CLIENT_SECRET

ls -al
#sudo bosh2 alias-env sst-director -e 10.0.16.5 --ca-cert root_ca_certificate
EOF
#echo ${PWD}
#sudo bosh2 -e sst-director login

#om_cmd curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > bbr_keys.json
#BOSH_PRIVATE_KEY=$(jq -r '.credential.value.private_key_pem' bbr_keys.json)

## extract the s3 bucket contents
#cd ../../../director-backup-bucket
#cp -r director-*.tar ../binary/
#cd ../binary/
#tar -xvf director-*.tar

## the restoration of bosh director
#./bbr director --private-key-path <(echo "${BBR_PRIVATE_KEY}") --username bbr --host "${BOSH_ADDRESS}" restore --artifact-path 10.0.*

echo "BOSH director restoration is successful!"
