Function Parse-SecPol($CfgFile){ 
    secedit /export /cfg "$CfgFile" | out-null
    $obj = New-Object psobject
    $index = 0
    $contents = Get-Content $CfgFile -raw
    [regex]::Matches($contents,"(?<=\[)(.*)(?=\])") | ForEach-Object{
        $title = $_
        [regex]::Matches($contents,"(?<=\]).*?((?=\[)|(\Z))", [System.Text.RegularExpressions.RegexOptions]::Singleline)[$index] | ForEach-Object{
            $section = new-object psobject
            $_.value -split "\r\n" | Where-Object{$_.length -gt 0} | ForEach-Object{
                $value = [regex]::Match($_,"(?<=\=).*").value
                $name = [regex]::Match($_,".*(?=\=)").value
                $section | add-member -MemberType NoteProperty -Name $name.tostring().trim() -Value $value.tostring().trim() -ErrorAction SilentlyContinue | out-null
            }
            $obj | Add-Member -MemberType NoteProperty -Name $title -Value $section
        }
        $index += 1
    }
    return $obj
}

Function Set-SecPol($Object, $CfgFile){
    $SecPool.psobject.Properties.GetEnumerator() | ForEach-Object{
         "[$($_.Name)]"
         $_.Value | ForEach-Object{
             $_.psobject.Properties.GetEnumerator() | ForEach-Object{
                 "$($_.Name)=$($_.Value)"
             }
         }
     } | out-file $CfgFile -ErrorAction Stop
     secedit /configure /db c:\windows\security\local.sdb /cfg "$CfgFile" /areas SECURITYPOLICY
 }
 
 
 $SecPool = Parse-SecPol -CfgFile C:\Users\nicol\Documents\GitHub\CyberPatriot\Windows\win\secpols.cfg
 #$SecPool.'System Access'.PasswordComplexity = 1
 $SecPool.'System Access'.MinimumPasswordLength = 8
 #$SecPool.'System Access'.MaximumPasswordAge = 60
 
 Set-SecPol -Object $SecPool -CfgFile C:\Users\nicol\Documents\GitHub\CyberPatriot\Windows\win\secpols.cfg