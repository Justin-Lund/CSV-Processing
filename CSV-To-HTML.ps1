# This script will convert all CSV files in the current folder to HTML

##################################################

# One liner to convert a single file:
# Import-CSV ".\FileToConvert.csv" | ConvertTo-Html | Out-File ".\HTMLOutput.html"

##################################################

# Input/Output stored as variables so that the script can be re-worked for different use cases
$InputExtension = "csv"
$OutputExtension = "html"

##################################################

# Create new directory named after the output filetype (eg. html)
New-Item -Name "$OutputExtension" -ItemType "Directory"

# Search all files in the folder, and filter by filetype (eg. csv)
Get-ChildItem .\ -Filter *.$InputExtension |

# For each file of the target filetype found:
ForEach-Object {

    # Set the new file names by removing the input extension (csv) & replacing it with the output extension (html)
    $NewName = $_.Name.Remove($_.Name.Length - $_.Extension.Length) + ".$OutputExtension"

    # Import CSV file, convert to HTML, & output to new file
    Import-CSV $_.FullName | ConvertTo-Html | Out-File ".\$OutputExtension\$NewName"
}