Set-PSDebug -Off

# todo
$user_table = Get-WmiObject win32_UserAccount | Select-Object Name, FullName, Caption, Domain, SID | Format-Table -AutoSize
$users = Get-WmiObject win32_UserAccount | Select-Object Name
$cyber_patriot_users = @()
$found = $()

$names = @($users.Name)

try {
    if ($args[0] -Like "*.txt") {
        Get-Content $args[0] | ForEach-Object {
            $cyber_patriot_users += $_
        }
    }
}
catch {
    "Please specify a txt to read"
}

# iterate through windows users and find out
# if they are supposed to exist or not.
foreach ($name in $names) {
    if ($cyber_patriot_users.Contains($name)) {
        Write-Host $name "exists"
        $found += $name
    }
    else {
        Write-Host $name "shouldnt exist"
    }
}

# iterate through provided users
# and check to see if they were found.
foreach ($user in $cyber_patriot_users) {
    if (!$found.Contains($user)) {
        Write-Host "could not find" $user
    }
}