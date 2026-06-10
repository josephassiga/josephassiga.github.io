# Aothers 

yum update -y

mkdir tools

cd tools/

export OCP_VERSION=latest-4.22
export ARCH=x86_64
export HOST_ARCH=$(uname -m)

curl -k https://mirror.openshift.com/pub/openshift-v4/$HOST_ARCH/clients/ocp/$OCP_VERSION/openshift-client-linux.tar.gz -o oc.tar.gz
file oc.tar.gz
tar zxf oc.tar.gz

rm -f oc.tar.gz README.md

chmod +x oc kubectl

mv oc kubectl /usr/local/bin/

vi ~/.bashrc
export PATH=$PATH:/usr/local/bin

curl -k https://mirror.openshift.com/pub/openshift-v4/$HOST_ARCH/clients/ocp/$OCP_VERSION/openshift-install-linux.tar.gz -o openshift-install-linux.tar.gz
file openshift-install-linux.tar.gz
tar zxf openshift-install-linux.tar.gz
rm -f openshift-install-linux.tar.gz README.md
chmod +x openshift-install
mv openshift-install /usr/local/bin/


ssh-keygen -t ed25519 -N '' -f ~/.ssh/rhoai-demo
Generating public/private ed25519 key pair.
Your identification has been saved in /home/ec2-user/.ssh/rhoai-demo
Your public key has been saved in /home/ec2-user/.ssh/rhoai-demo.pub
The key fingerprint is:
SHA256:TvVyNnvypex5FAg9WxF70YSsL6Esnk0DHjRLJQpbPk8 ec2-user@ip-172-31-27-222.eu-west-3.compute.internal
The key's randomart image is:
+--[ED25519 256]--+
|    . . ... .. *=|
|     = .+. . oo.+|
|    . +oEo. ..=..|
|       ++. .oo ..|
|       .S+..=o  .|
|       oo =+.o. .|
|       ..= .o....|
|        o .  = +.|
|             .*. |
+----[SHA256]-----+

[ec2-user@ip-172-31-27-222 ~]$ eval "$(ssh-agent -s)"
Agent pid 55209

[ec2-user@ip-172-31-27-222 ~]$ ssh-add ~/.ssh/rhoai-demo
Identity added: /home/ec2-user/.ssh/rhoai-demo (ec2-user@ip-172-31-27-222.eu-west-3.compute.internal)

[ec2-user@ip-172-31-27-222 ~]$ cat ocp-install/install-config.yaml
````
apiVersion: v1
baseDomain: rhoai.rh-aiservices.com
compute:
  - architecture: amd64
    hyperthreading: Enabled
    name: worker
    platform:
      aws:
        type: m6i.4xlarge
    replicas: 0
controlPlane:
  architecture: amd64
  hyperthreading: Enabled
  name: master
  platform:
    aws:
      type: g6.12xlarge
      rootVolume:
        size: 1000
  replicas: 1
metadata:
  name: rhoai-demo
networking:
  clusterNetwork:
    - cidr: 10.128.0.0/14
      hostPrefix: 23
  machineNetwork:
    - cidr: 10.0.0.0/16
  networkType: OVNKubernetes
  serviceNetwork:
    - 172.30.0.0/16
platform:
  aws:
    region: eu-west-3
publish: External
pullSecret: '{"auths":{"cloud.openshift.com":{"auth":"<token>","email":"<email>"}}}'
sshKey: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoXoLh7nqQy8m9sH+0u2v6kK7a9n5j5z'
