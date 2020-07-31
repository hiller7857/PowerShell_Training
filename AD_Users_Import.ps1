#Define log Path and start capturing output
$Log = C:\users\jhiller_a.corp\documents\UserCreation_$(get-date -f yyyy-MM-dd).txt
Start-Transcript

#Import Module need to create users
import-module ActiveDirectory -ErrorAction Stop

#Import Data
$UserCreations = import-csv 'C:\users\jhiller_a.corp\documents\userimport.csv' -ErrorAction Stop

#Create Accounts
$UserCount = 1
foreach ($UserCreation in $UserCreations){
    write-host "Creating $($UserCreation.DisplayName) user in Active Directory"
    Write-Progress -activity "Create new users" -status "$($UserCreation.Displayname) being added, $UserCount of $($UserCreations.count)" -PercentComplete (($UserCount / $UserCreations.count) * 100)
    {new-aduser `
        -NAME $UserCreation.DisplayName `
        -GivenName $UserCreation.FirstName `
        -Initial $UserCreation.MiddleInitial `
        -SurName $UserCreation.LastName `
        -SAMAccountName $UserCreation.SAMAccountName `
        -UserPrincipalName $UserCreation.userprincipalname `
        -AccountPassword (ConvertTo-SecureString “$UserCreation.Password” -AsPlainText -force) `
        -Title $UserCreation.Title `
        -Department $UserCreation.Department `
        -Enabled $False `
        -DisplayName $UserCreation.DisplayName `
        -ChangePasswordAtLogon $True `
        -Path $UserCreation.Path `
    }
    #Verify account exists and specify Manager
    $VerifyUserAdded = get-aduser -identity $UserCreation.DisplayName
    If ($Null -ne $VerifyUserAdded) {
        write-host "$($UserCreation.SAMAccountName) added successfully" -ForegroundColor Green
        get-aduser -filter {displayname -eq $UserCreation.DisplayName} | set-aduser -Manager $UserCreation.Manager 
    }else {
        write-host "$($UserCreation.SAMAccountName) failed to be added. check for errors in output log" -ForegroundColor Red
    }
}
Write-Progress -activity "Create new users" -Completed
Write-Host "Script Completed" -ForegroundColor Green
Stop-Transcript


