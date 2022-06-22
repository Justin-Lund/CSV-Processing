# This script was built for use with with FireEye ETP (Email Threat Prevention) & FireEye Helix, but can be repurposed for various use-cases.
# Its purpose is to quickly build Helix IOC lists of malicious email addresses.

# It will take all CSVs (in this case, ETP search exports) in the folder the script is ran from, and extract email addresses under the specified header.
# It will then create a new CSV, formatted & ready to upload to Helix.

#################################################################

# Output filename
$CSVOutput = ".\Email_Addresses_for_Helix.csv"

# CSV Header that malicious email addresses are listed under
$CSVHeader = "From (SMTP)"

#################################################################

# Import all CSV files from the current folder and store in variable "$CSVs"
$CSVs = Get-ChildItem -Filter *.csv

# Initialize arrays
$Emails=@() 
$CSVFields= @()

# For every CSV in the folder, grab the email address from the above-specified header, and add it to "$Emails"
ForEach ($CSV in $CSVs){
$Emails += Import-CSV $CSV | Select -ExpandProperty $CSVHeader
}

# Remove duplicate email addresses. The "where" statement removes blank lines.
$Emails = ($Emails | Select-Object -Unique | Where { $_ -ne ''})

# Add each email address with 4 headers; Notes (adds current date), Risk (set to Medium), Type (email), & Value (the target email address)
ForEach ($Email in $Emails){
    $CSVFields += [PSCustomObject]@{
        'notes' = Get-Date -Format "yyyy/MM/dd"
        'risk' = "Medium"
        'type' = "email"
        'value' = $Email
    }
}

# Filter out Amazonses domain
$CSVFields = $CSVFields -NotMatch 'amazonses.com'

echo $CSVFields | Export-CSV $CSVOutput -NoTypeInformation