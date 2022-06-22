#--------------------------------------#
#        Information Gathering         #
#--------------------------------------#

# Set Company Names
$Company1 = "Google*"
$Company2 = "Amazon*"
$Company3 = "Microsoft*"

# Set Output File Name
$OutputFile = "Company Users.csv"


#--------------------------------------#
#              Functional              #
#--------------------------------------#

# Find all AD users with the specified company names, and pull the listed properties
Get-ADUser -Filter 'Company -Like $Company1 -Or Company -Like $Company2 -Or Company -Like $Company3' -Properties "Company", "AccountExpirationDate", "EmailAddress" |

# Set the fields that will appear in the exported CSV
Select GivenName, Surname, SamAccountName, EmailAddress, Company, AccountExpirationDate |

# Export the results to a CSV file
Export-CSV -NoType $OutputFile