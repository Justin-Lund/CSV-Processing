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

# Import list of names from a .csv with First Name & Last Name in separate fields
$Names = Import-CSV $InputFile -Header Givenname, Surname -Delimiter ","
            
ForEach ($Name in $Names)
{
    # Set variables for First & Last names
    $FirstName = $Username.Givenname
	$LastName = $Username.Surname

    # Find the user by searching their first & last name
	$User = Get-ADUser -Filter {GivenName -Like $FirstName -And Surname -Like $LastName} |
    
    # Select listed properties, & pull the Distinguished Name without the excess output (OU, CN, etc)
    Select Enabled, SamAccountName, @{n="ou";e={($_.distinguishedname -split ",*..=")[2]}}

    # Add the below-listed properties to $ItemDetails variable
    $ItemDetails = New-Object -TypeName PsObject -Property @{    
        UserName = $User.SamAccountName
		FirstName = $FirstName
		LastName = $LastName
    }

    #Add data to array
    $Results += $ItemDetails
}

$Results | Export-CSV -NoType $OutputFile
