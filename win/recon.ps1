Set-PSDebug -Off

# todo
$user_table = Get-WmiObject win32_UserAccount | Select-Object Name, FullName, Caption, Domain, SID | Format-Table -AutoSize
$users = Get-WmiObject win32_UserAccount | Select-Object Name
$cyber_patriot_users = @()
$found = $()
#$fileHash = Get-FileHash -Algorithm alg file

$names = @($users.Name)

#Default Users that you don't want to touch
$blacklisted_users = @("Administrator", "DefaultAccount", "WDAGUtilityAccount", "Guest") 

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
    elseif ($blacklisted_users.Contains($name)) {
        Write-Host $name "is a blacklisted user don't touch"
        
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

$media_files = Get-ChildItem -Path C:\Users\ -Include *.txt -File -Recurse -ErrorAction SilentlyContinue
$media_files