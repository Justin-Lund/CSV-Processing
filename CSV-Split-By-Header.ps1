# Take a header from a CSV, and create new CSVs for each entry under said header, grouping items with the same value together into new CSVs.

# Example: A CSV has a header "Location", and has multiple entries with the values of "London" and "New York".
# A new CSV will be created for both London & New York, each with its corresponding entries in the new CSV files.

#################################################################

# Input filename
$InputCSV = "Input.csv"

# Output folder name
$OutputDir = "Output"

# CSV Header to Split file by:
$Header = "Location"

#################################################################

# Import CSV
$CSV = Import-CSV ".\$InputCSV" |

    # Sort contents of CSV by the target header
    Sort-Object $Header |
        Group-Object -Property $Header

# Create output folder
New-Item -Path ".\$OutputDir" -ItemType "Directory"

# Loop through CSV, & create new file for each item
ForEach ($Line in $CSV) {
  $Line.Group | 
    Export-CSV -Delimiter ',' -Encoding UTF8 -NoTypeInformation -Force -Path (".\$OutputDir\"+$Line.Name+".csv")
}