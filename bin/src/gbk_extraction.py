import argparse
import os

def get_args():
    ## imports files from nextflow channels
   parser = argparse.ArgumentParser()
   parser.add_argument('--pholdAnnotation', type=str)
   return parser.parse_args()
args = get_args()

os.makedirs("unannotated_aa_fasta", exist_ok=True)
os.makedirs("combined_unannotated_aa_fasta", exist_ok=True)

print(type(args.pholdAnnotation))

with open(args.pholdAnnotation,"r") as pholdAnnotation:

    lines = pholdAnnotation.readlines()
    number_of_lines = enumerate(lines)
    name = "combined_unannotated_aaFASTA"
    combined = open(f"combined_unannotated_aa_fasta/{name}.fasta","w")
    i = 0

    while i < len(lines):
        line = lines[i]
        if i < 20 :
             print(line)
        if "CDS" in line:
            #subscript for every gene
                if "ID" in line:
                    geneName = line.strip().replace("\"","")
                    geneName = geneName.replace("=","")
                    geneName = geneName.replace("ID","")
                    fastageneName = geneName.replace("/",">")
                    geneName = geneName.replace("/","")
                    i = i + 1
                   # print ("kommt in iD")
                else:
                    i = i + 1
        elif "function" in line and "unknown" in line :
            while "translation" not in line :
                i = i + 1
                #print("kommt in funktion and unknown")
                line = lines[i]
            if "translation" in line:
                aaSequence = line.strip()[13:].replace("\"","")
                #print("kommt bis while Schleife")
                i = i + 1
                line = lines[i]
                while i + 1 < len(lines) and not line.startswith("     CDS"):
                    aaSequence += line[0:].strip().replace("\"","")
                    i = i + 1 
                    line = lines[i]
                single = open(f"unannotated_aa_fasta/{geneName}.fasta","w")
                single.write(fastageneName + "\n")
                single.write(aaSequence + "\n")
                single.close()
                combined.write(fastageneName + "\n")
                combined.write(aaSequence + "\n")
            else :
                print("Can not find translation")
        elif "function" in line and "unknown" not in line:
            geneName = ""
            fastageneName = ""
            i = i + 1
            line = lines[i]
        else:
            i = i + 1
    combined.close()


