#Import Module
import-module ActiveDirectory -ErrorAction Stop

#Import Data
$UserCreations = import-csv 'C:\users\jhiller_a.corp\documents\userimport.csv' -ErrorAction Stop
foreach ($UserCreation in $UserCreations){
    {new-aduser `
        -NAME $($UserCreation.FirstName) $($UserCreation.LastName) `
        -GivenName $UserCreation.FirstName `
        -Initial $UserCreation.MiddleInitial `
        -SurName $UserCreation.LastName `
        -SAMAccountName $UserCreation.SAMAccountName `
        -AccountPassword (ConvertTo-SecureString “$UserCreation.Password” -AsPlainText -force) `
        -Title $UserCreation.Title `
        -Department $UserCreation.Department `
        -Enabled $False `
        -ChangePasswordAtLogon $True 
        #-Path $UserCreation.Path
    }
    #$VerifyUserAdded = get-aduser -identity "$UserCreation.FirstName + " " + $UserCreation.LastName"
}

#Add Manager
If ($False -ne $VerifyUserAdded) {
    write-host '$($UserCreation.SAMAccountName) added successfully' -ForegroundColor Green
}else {
    write-host '$($UserCreation.SAMAccountName) failed to be added' -ForegroundColor Red
}
foreach ($UserCreation in $UserCreations){
    set-aduser -identity $UserCreation.DisplayName -Manager $UserCreation.Manager 
    $VerifyUserAdded = -get-aduser -identity $UserCreation.DisplayName
}
