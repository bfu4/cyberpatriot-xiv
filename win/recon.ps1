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

#create log file 
"Windows Recon Log File" | Out-File -FilePath .\WinRecon.log

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

"Users:" | Add-Content -Path .\WinRecon.log

foreach ($name in $names) {
    if ($cyber_patriot_users.Contains($name)) {
        Write-Host $name "exists"
        "$name exists" | Add-Content -Path .\WinRecon.log
        $found += $name
    }
    elseif ($blacklisted_users.Contains($name)) {
        Write-Host $name "is a blacklisted user don't touch"
        "$name is a blacklisted user don't touch" | Add-Content -Path .\WinRecon.log
        
    }
    else {
        Write-Host $name "shouldnt exist"
        "$name shouldnt exist" | Add-Content -Path .\WinRecon.log
    }
}

# iterate through provided users
# and check to see if they were found.
foreach ($user in $cyber_patriot_users) {
    if (!$found.Contains($user)) {
        Write-Host "could not find" $user
    }
}

"User Table:" | Add-Content -Path .\WinRecon.log
$user_table | Add-Content -Path .\WinRecon.log

$audio_files = Get-ChildItem -Path C:\Users\ -Include *.midi,*.mid,*.mod,*.mp3, *.mp2, *.mpa, *.abs, *.mpega, *.au, *.snd, *.wav, *.aiff, *.aif, *.sid, *.flac, *.ogg -File -Recurse -ErrorAction SilentlyContinue
$video_files = Get-ChildItem -Path C:\Users\ -Include *.mpeg,*.mpg, *.mpe,*.dl, *.movie,*.movi,*.mv,*.iff, *.anim5,*.anim3,*.anim7,*.avi,*.vfw,*.avx,*.fli,*.flc, *.mov, *.qt,*.spl,*.swf,*.dcr,*.dir,*.dxr,*.rpm,*.rm,*.smi,*.ra,*.ram,*.rv,*.wmv,*.asf,*.asx,*.wma,*.wax,*.wmv,*.wmx,*.3gp,*.mov,*.mp4,*.avi,*.swf,*.flv,*.m4v -File -Recurse -ErrorAction SilentlyContinue
$photo_files = Get-ChildItem -Path C:\Users\ -Include *.tiff, *.tif, *.rs, *.im1, *.gif, *.jpeg, *.jpg, *.jpe, *.png, *.rgb, *.xwd, *.xpm, *.ppm, *.pbm, *.pgm, *.pcx, *.ico, *.svg, *.svgz -File -Recurse -ErrorAction SilentlyContinue

"Found Audio Files" | Add-Content -Path .\WinRecon.log
$audio_files | Add-Content -Path .\WinRecon.log

"Found Video Files" | Add-Content -Path .\WinRecon.log
$video_files | Add-Content -Path .\WinRecon.log

"Found Photo Files" | Add-Content -Path .\WinRecon.log
$photo_files | Add-Content -Path .\WinRecon.log