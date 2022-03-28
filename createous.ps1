
# Import Active Directory Module
Import-Module ActiveDirectory

# Create Root OU
# New-ADOrganizationalUnit 'Corp'

# Create Child OUs in Corp
$OUs = @(
    'Users'
    'Groups'
    'Computers'
    'Servers'
)
foreach ($ou in $OUs) {
    New-ADOrganizationalUnit -Path 'OU=Corp,DC=acme,DC=local' -Name $ou
}
