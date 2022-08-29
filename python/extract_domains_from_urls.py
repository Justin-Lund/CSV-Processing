# To do:
# Create dynamic column count with variables
# Add switches to run script without modifying file
# 

# In current state:
# CSV has 8 columns
# URLs are in the 5th column

import csv
import tldextract

INPUT_FILE = "AllDetails.csv"
OUTPUT_FILE = "output.csv"

with open(INPUT_FILE, newline='', encoding='unicode_escape') as csv_input, open(OUTPUT_FILE, 'w') as csv_output:
    reader = csv.reader(csv_input)
    writer = csv.writer(csv_output)

    header = next(reader)
    header.append("Extracted Domain")
    writer.writerow(header)

    for Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8 in reader:
        writer.writerow( [Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, \
        tldextract.extract(Column5)[1] + "." + tldextract.extract(Column5)[2] \
        ] )
