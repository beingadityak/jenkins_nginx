#!/bin/bash

set -e;

# Update Jenkins UID
if [[ ${UID_JENKINS} != 1000 ]]; then
    echo "INFO: Setting Jenkins UID to ${UID_JENKINS}"
    usermod -u ${UID_JENKINS} jenkins
    {
        chown -R jenkins:jenkins /var/jenkins_home
        chown -R jenkins:jenkins /usr/share/jenkins/ref
    } || 
    {
        echo "ERROR: Failed to run chown"
    }
fi

# Update Jenkins GID
if [[ ${GID_JENKINS} != 1000 ]]; then
    echo "INFO: Setting Jenkins GID to ${GID_JENKINS}"
    groupmod -g ${GID_JENKINS} jenkins
fi

# Allow Jenkins to run sudo docker
echo "jenkins (ALL)=(root) NOPASSWD: /usr/bin/docker" > /etc/sudoers.d/jenkins
chmod 0440 /etc/sudoers.d/jenkins

# Run Jenkins as jenkins user
sed -i 's# exec java# exec $(which java)#g' /usr/local/bin/jenkins.sh
su jenkins -c 'cd $HOME; /usr/local/bin/jenkins.sh'