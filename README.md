# Provision Infra

- Install Vagrant
- Install VirtualBox
- Run Provisioning of VM
```
  set +o history # disable history
  git_name='Bogdan Calomfirescu' git_email='bogdan.calomfirescu@yahoo.com' vagrant up
  set -o history # enable history
```
- Connect to VM
```
  vagrant ssh
```

# Deploy Servers

```
  cd /home/test
  ansible-playbook -i hosts deploy.yml
```

## Deploy Servers individually

```
  ansible-playbook -i hosts deploy.yml --tags tomcat
  ansible-playbook -i hosts deploy.yml --tags nodejs
  ansible-playbook -i hosts deploy.yml --tags elk-stack
  ...
```

## Deploy Java App

```
  ansible-playbook -i hosts deploy.yml --tags java
```
 
## Deploy Javascript App

```
  ansible-playbook -i hosts deploy.yml --tags javascript
```