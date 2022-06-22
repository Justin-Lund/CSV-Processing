# Script to reset passwords for multiple users

# Note - usernames must be listed in CSV under header "SamAccountName"
# To update: better output, OPTIONAL to read different password for each user as well, prompt to run "check-last-logon" against same users for verification
# Password needs to be a variable for single pw resets as well

# Set CSV File
$CSVFile = Import-CSV "Users.csv"

 
ForEach ($User in $CSVFile) {
    #For each name or account in the CSV file $CSVFile, reset the password with the Set-ADAccountPassword string below
    $User.SamAccountName
        Set-ADAccountPassword -Identity $User.SamAccountName -Reset -NewPassword (ConvertTo-SecureString "PasswordGoesHere" -AsPlainText -force)
        Set-ADUser $User.SamAccountName -ChangePasswordAtLogon $true
}
 
 Write-Host ""
 Write-Host "Script completed"
