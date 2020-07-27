$UserCreations = import-csv 'C:\users\jhiller_a.corp\documents\userimport.csv'
import-module ActiveDirectory
foreach ($UserCreation in $UserCreations){
    new-aduser -FirstName $UserCreation.FirstName -MiddleInitial $UserCreation.MiddleInitial -LastName $UserCreation.LastName -SAMAccountName $UserCreation.SAMAccountName -Password $UserCreation.Password -DisplayName $UserCreation.DisplayName -Title $UserCreation.Title -Department $UserCreation.Department -Manager $UserCreation.Manager -Email $UserCreation.Email -Path $UserCreation.Path 
    $VerifyUserAdded = get-aduser $UserCreation.SAMAccountName
    If ($False -ne $VerifyUserAdded) {
        write-host '$($UserCreation.SAMAccountName) added successfully' -ForegroundColor Green
    }else {
        write-host '$($UserCreation.SAMAccountName) failed to be added' -ForegroundColor Red
    }
}
