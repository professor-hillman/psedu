
# Adds 30 random users to Acitve Directory, along with global and domain local groups

# Change this to match your environment!!
$domain   = 'lbcc.internal'
$groupsOU = 'OU=Groups,OU=Corp,DC=lbcc,DC=internal'
$usersOU  = 'OU=Users,OU=Corp,DC=lbcc,DC=internal'

$passwd = Read-Host -AsSecureString -Prompt "Enter Temporary Password"

$req1 = Invoke-WebRequest "http://names.drycodes.com/15?nameOptions=girl_names&separator=space&format=text"
$req2 = Invoke-WebRequest "http://names.drycodes.com/15?nameOptions=boy_names&separator=space&format=text"

$names = $req1.content.split("`n") + $req2.content.split("`n")

$depts = @('IT', 'HR', 'Accounting', 'Sales', 'Engineering')

foreach ($group in $depts) {

    $globalgroup = @{
        Name            = "$group Users"
        SamAccountName  = $group.ToLower() + "_users"
        GroupCategory   = "Security"
        GroupScope      = "Global"
        Path            = $groupsOU
        Description     = "Members of this group work in the $group Department"
    }
    New-ADGroup @globalgroup

    $dlgroup = @{
        Name            = "$group Resources"
        SamAccountName  = $group.ToLower() + "_resources"
        GroupCategory   = "Security"
        GroupScope      = "DomainLocal"
        Path            = $groupsOU
        Description     = "Security Group for controlling access to the $group Department's resources"
    }
    New-ADGroup @dlgroup

    Add-ADGroupMember -Identity $dlgroup.SamAccountName -Members $globalgroup.SamAccountName
}

$i = 0
foreach ($name in $names) {

    $user = @{
        Name                  = $name
        DisplayName           = $name
        GivenName             = $name.split(' ')[0]
        Surname               = $name.split(' ')[1]
        SamAccountName        = $($name[0] + $name.split(' ')[1]).ToLower()
        Title                 = $depts[($i % 5)] + " Employee"
        Department            = $depts[($i % 5)]
        EmailAddress          = $($name[0] + $name.split(' ')[1]).ToLower() + "@" + $domain
        AccountPassword       = $passwd
        ChangePasswordAtLogon = $true
        Path                  = $usersOU
        Enabled               = $true
    }
    New-ADUser @user

    Add-ADGroupMember -Identity $($user.Department.ToLower() + "_users") -Members $user.SamAccountName

    $i++
}
