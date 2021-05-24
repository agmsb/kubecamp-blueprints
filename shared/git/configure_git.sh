#! /bin/bash

set -o nounset
set -o errexit
set -o pipefail

gcloud secrets versions access latest --secret=github_agmsb > /root/.ssh/id_github

chmod 600 /root/.ssh/id_github

cat <<EOF >/root/.ssh/config
Hostname github.com
IdentityFile /root/.ssh/id_github
EOF

ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

git config --global user.email "agmsb@google.com"
git config --global user.name "Cloud Build"
git clone git@github.com:agmsb/kubecamp-env
cd kubecamp-env
git checkout -b candidate-${SHORT_SHA}
cp /workspace/resources.yaml /workspace/kubecamp-env/resources.yaml
git add .
git commit -m "Update app to image with tag ${SHORT_SHA}"
git push --set-upstream origin candidate-${SHORT_SHA}