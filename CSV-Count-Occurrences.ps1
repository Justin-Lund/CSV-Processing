# Count occurrences of a given field in a CSV

#--------------------------------------#
#              Variables               #
#--------------------------------------#

# Input filename
$CSVInput = "Input.csv"

# Output filename
$CSVOutput = ".\Count_Output.csv"

# CSV header to count occurrences of
$CSVHeader = "Recipients"

#################################################################

# Import target CSV file
Import-CSV $CSVInput |

  # Read each line under the target CSV header
  ForEach-Object $CSVHeader |

  # If multiple objects are listed on one line (eg. in one cell, when viewing in Excel) & comma delimited, separate them
  ForEach-Object Split ', ' |

  # Group-Object counts the occurrences of each item
  Group-Object -NoElement |

  # Select only the count & name attributes
  Select-Object -Property Count, Name |

  # Eliminate blank lines
  Select-Object | Where Name -ne '' | 

  # Sort by count, with the highest counts on top
  Sort-Object Count -Descending |

  # Export CSV
  Export-CSV $CSVOutput -NoTypeInformation