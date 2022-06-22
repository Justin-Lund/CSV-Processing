<# This Script will take a list of email addresses from a CSV,
and validate whether or not the addresses exist in Active Directory #>

##################################
# --- Configurable Variables --- #
##################################

# Input filename
$InputCSV = "EmailTrace.csv"

# CSV Header that email addresses are listed under
$CSVHeader = "Recipient (SMTP)"

# Multiple email address split character
# If there are multiple email addresses grouped together on the same line (eg. in the same cell when viewing in Excel), separate them by this character
# Typically will be a comma or semicolon
$SplitCharacter = ","

#------------------------------------#

######################################
# --- Non-configurable Variables --- #
######################################

# Initialize Counters
$ValidCount = 0
$InvalidCount = 0

# Initialize arrays
$Emails=@() 
$ValidEmails= @()
$InvalidEmails= @()

#------------------------------------#


# Text divider for cleaner output
Function Divider {
    Write-Host ""
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
    }

#------------------------------------#


########################################################
# --- Importing & Sorting Email Addresses From CSV --- #
########################################################

# Add all email addresses from the CSV to an array varaible, "$Emails"
$Emails += Import-CSV $InputCSV | Select -ExpandProperty $CSVHeader

# If there are multiple emails listed together on one line, split them
$Emails = $Emails.Split($SplitCharacter)

# Remove blank lines
$Emails = $Emails | Where {$_ -ne ''}

# Remove leading & trailing white-space characters from all objects in the array
$Emails = $Emails.Trim()

# Sort alphabetically
$Emails = $Emails | Sort

# Remove duplicate email addresses
$Emails = $Emails | Select-Object -Unique

#------------------------------------#


####################################
# --- Email Address Validation --- #
####################################

<# Loop through the list of email addresses & sort which ones are valid & invalid,
by referencing email address against Active Directory
Also iterate a counter for each valid/invalid email address #>

ForEach ($Email in $Emails) {
    If (Get-ADUser -Filter "EmailAddress -like '$Email'") {
        $ValidCount += 1
        $ValidEmails += $Email
    }

    Else {
        $InvalidCount += 1
        $InvalidEmails += $Email
    }
}

#------------------------------------#


#######################
# --- Text Output --- #
#######################

Divider

# Display valid email addresses
ForEach ($Email in $ValidEmails) {
        Write-Host "$Email is valid"
    }

Divider

# Display invalid email addresses
ForEach ($Email in $InvalidEmails) {
        Write-Host "$Email is invalid"
    }

Divider

# Display the number/count of valid & invalid email addresses
Write-Host "There are" -NoNewline
Write-Host " $ValidCount " -NoNewLine -ForegroundColor Red
Write-Host "valid email addresses"

Write-Host "There are" -NoNewline
Write-Host " $InvalidCount " -NoNewLine -ForegroundColor Red
Write-Host "invalid email addresses"

Write-Host ""

Pause