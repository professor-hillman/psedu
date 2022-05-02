
# Import Active Directory Module
Import-Module ActiveDirectory

# Create Root OU (uncomment if not already present)
# New-ADOrganizationalUnit 'Corp'

# Important!! Make sure the path below (domain) matches your environment!!
$CorpOU = 'OU=Corp,DC=lbcc,DC=internal'

# Create Child OUs in Corp
$OUs = @(
    'Users'
    'Groups'
    'Computers'
    'Servers'
)
foreach ($ou in $OUs) {
    New-ADOrganizationalUnit -Path $CorpOU -Name $ou
}
