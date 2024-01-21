cat << EOF >> ~/.ssh/config

Host ${hostname}-aws
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityFile}
EOF