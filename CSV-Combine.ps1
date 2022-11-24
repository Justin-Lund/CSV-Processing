# Combine all CSVs in the folder that the script is ran from
# CSVs must contain the same headers

# Output filename
$CSVOutput = "Output\CombinedCSVs.csv"

# Find all items in current directory with CSV extension
(Get-ChildItem -Filter *.csv) |

    # Select the full file path & name for each CSV
    Select-Object -ExpandProperty FullName |
    
    # Gather content from each CSV
    Import-CSV |

    # Combine content from all CSVs and export to new file
    Export-CSV $CSVOutput -NoTypeInformation -Append
