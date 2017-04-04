$DOMAINCONTROLLER = "DC1"
$ADMIN = "broyadmin"

Enter-PSSession -ComputerName $DOMAINCONTROLLER -Credential $ADMIN

$FIRSTNAME = Read-Host -Prompt 'Input the users first name'
$LASTNAME = Read-Host -Prompt 'Input the users last name'
$USERNAME = Read-Host -Prompt 'Input the users username'
$INSTANCE = Get-ADUser -Identity "Template_sftp" -Properties Description,MemberOf,PrimaryGroup
$DOMAIN = "broyuken.com"
$PRIMARYGROUPNAME = "SFTP_Users"
$PASSWORD = (ConvertTo-SecureString -AsPlainText "Changeme1" -Force)

New-ADUser -SAMAccountName $USERNAME -Instance $INSTANCE -Name "$FIRSTNAME $LASTNAME" -GivenName $FIRSTNAME -Surname $LASTNAME -UserPrincipalName $USERNAME@$DOMAIN -AccountPassword $PASSWORD  -Enabled $true
Add-ADGroupMember -Identity $PRIMARYGROUPNAME -Members $USERNAME
Set-aduser -identity $USERNAME -Replace @{PrimaryGroupID="1158"}
Remove-ADGroupMember -identity "domain users" -members $USERNAME -confirm:$false