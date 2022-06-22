#--------------------------------------#
#        Information Gathering         #
#--------------------------------------#

# Set Input & Output File Names
$InputFile = "List.csv"
$OutputFile = "EmailAddresses.csv"

#--------------------------------------#
#              Functional              #
#--------------------------------------#

$((Get-Content $InputFile) -Split ",") |

ForEach-object {
    Get-ADUser $_ -Properties EmailAddress
} | Select-Object SamAccountName, GivenName, Surname, EmailAddress | Export-CSV -NoType $OutputFile