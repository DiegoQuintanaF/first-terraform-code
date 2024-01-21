add-content -path c:/users/$Env:UserName/.ssh/config -value @'

Host ${hostname}-aws
    HostName ${hostname}
    User ${user}
    IdentityFile ${indentityFile}
'@