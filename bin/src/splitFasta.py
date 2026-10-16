# imports the librarys argparse (for passing the channel from the nextflow to the python script) and os (to create a folder for the output files" 
import argparse
import os

#import of AA sequence from the channel "aaFASTA" revieved after phold annotation
def get_args():
    ## imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--aaFASTA', type=str)
    return parser.parse_args()
args = get_args()

print(type(args.aaFASTA))
# Reads the lines of an aminoacid (AA) fasta as produced by phold and then creates smaller single protein fastas named after the header. 
# These new fastas contain the header and the aminoacid sequence of a single protein

out = None
with open(args.aaFASTA,"r") as genomeFASTA:
    # creates folder for splited fastas
    os.makedirs("splited_genomes", exist_ok=True)
    for line in genomeFASTA:
        if ">" in line: 
            # if header line is detected old files are closed
            if out:
                out.close()
                print("No AA sequence after header! Please check the AA annotaion by Phold!")
            # to avoid problems with invalid file names ">" is removed and ":" is replaced by "_" 
            name = line[0:].strip()
            name = name.replace(">","")
            name = name.replace(":","_")
            # a new fasta with the modified header as name is created
            out = open(f"splited_genomes/{name}_split.fasta","w")
            # and the header is written in the freshly created fasta
            out.write(line)
        # a line without a header contains the aa sequence and is written in the still open file.
        elif out:
            out.write(line)
             # the aa sequence is always written in just one line, so the file is closed after it is written
            out.close()
        # to prevent errors from text before the first header (shold not apply)
        else:
            print("No header in first line of fasta file! Please check the AA annotaion by Phold!")
# to prevent errors from a missing aa sequence after the last header (shold not apply)
if out:
    out.close()
    print("No AA sequence after header! Please check the AA annotaion by Phold!")