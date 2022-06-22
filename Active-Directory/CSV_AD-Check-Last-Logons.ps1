# Read a list of users from a CSV & check when they last logged on, & when their password was last reset

# Put users under "Username" header

#--------------------------------------#
#            Initialization            #
#--------------------------------------#

# Initialize Array
$Results = @()


#--------------------------------------#
#        Information Gathering         #
#--------------------------------------#

# Set Input & Output File Names
$InputFile = "List.csv"
$OutputFile = "User Last Logon Times.csv"


#--------------------------------------#
#              Functional              #
#--------------------------------------#

# Pull Username field from CSV
$Usernames += Import-CSV $InputFile | Select -ExpandProperty "Username"

# Loop through each name in the CSV
ForEach ($Username in $Usernames)
{

    # Find the user by username, & get the Last Logon Date, Account Active Status, First Name, & Last Name
	$User = Get-ADUser -Filter {SamAccountName -Like $Username} -Properties LastLogonDate, Enabled, GivenName, Surname, pwdLastSet |

    # Select listed properties
    Select SamAccountName, LastLogonDate, Enabled, GivenName, Surname, @{name ="pwdLastSet";`
    expression={[datetime]::FromFileTime($_.pwdLastSet)}}

    # Add the below-listed properties to $ItemDetails variable
    $ItemDetails = [ordered]@{    
        UserName = $Username
		FirstName = $User.GivenName
		LastName = $User.Surname
        ActiveStatus = $User.Enabled
		LastLogonDate = $User.LastLogonDate
        PasswordLastSet = $User.pwdLastSet
    }

    #Add data to array

    $Results += (New-Object PSObject -Prop $ItemDetails)
}

echo $Results | Export-CSV -NoType $OutputFile
