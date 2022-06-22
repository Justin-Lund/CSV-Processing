#--------------------------------------#
#        Information Gathering         #
#--------------------------------------#

# Set Input & Output File Names
$InputFile = "List.csv"
$OutputFile = "Usernames.csv"

#--------------------------------------#
#              Functional              #
#--------------------------------------#

$((Get-Content $InputFile) -Split ",") |

ForEach-object {
    Get-ADUser -Filter {EmailAddress -Like $_}
} | Select-Object SamAccountName, GivenName, Surname | Export-CSV -NoType $OutputFile