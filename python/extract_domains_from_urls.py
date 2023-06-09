# Required libraries are imported
import csv
import tldextract
import argparse

# The main function that will read a CSV file, extract domains from the URLs, and write the results to a new CSV file
def main(input_file, output_file, column):
    column -= 1  # convert to 0-indexed. The column number is 0-indexed in python, so we subtract 1 from the input

    # Open the input and output CSV files. 'unicode_escape' encoding is used to avoid errors with special characters
    with open(input_file, newline='', encoding='unicode_escape') as csv_input, open(output_file, 'w') as csv_output:
        # Create a CSV reader and writer objects
        reader = csv.reader(csv_input)
        writer = csv.writer(csv_output)

        # Extract the header (first row) from the CSV file and insert a new column "Extracted Domain"
        header = next(reader)
        header.insert(column + 1, "Extracted Domain")
        writer.writerow(header)

        # Loop through each row in the CSV file
        for row in reader:
            # Extract the domain from the URL using the tldextract library
            domain = tldextract.extract(row[column])[1] + "." + tldextract.extract(row[column])[2]
            # Insert the extracted domain into the row
            row.insert(column + 1, domain)
            # Write the row with the new domain to the output CSV file
            writer.writerow(row)

# This is the entry point of the script
if __name__ == "__main__":
    # ArgumentParser object is created which will hold all the command line arguments
    parser = argparse.ArgumentParser(description='Extracts domain from URLs in a CSV file.')
    # Required command line arguments are added
    parser.add_argument('-i', '--input', help='Input CSV file.', required=True)
    parser.add_argument('-o', '--output', help='Output CSV file.', required=True)
    parser.add_argument('-c', '--column', help='Column number of URLs in CSV.', type=int)

    # Parse the command line arguments
    args = parser.parse_args()

    # If the column number is provided, call the main function directly
    if args.column is not None:
        main(args.input, args.output, args.column)
    else:
        # If the column number is not provided, open the input CSV file and ask the user to select the column
        with open(args.input, newline='', encoding='unicode_escape') as csv_input:
            reader = csv.reader(csv_input)
            header = next(reader)
            print("Please select the column number:")
            for i, col_name in enumerate(header, start=1):  # start counting at 1
                print(f"{i}: {col_name}")
            # Get the user's selection and call the main function with it
            selected_column = int(input("Enter column number: "))
            main(args.input, args.output, selected_column)
