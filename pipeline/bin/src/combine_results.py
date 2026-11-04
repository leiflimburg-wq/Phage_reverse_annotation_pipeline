import argparse
import os
import pandas as pd
from pathlib import Path

def get_args():
    #imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--folddisco', type = str)
    parser.add_argument('--foldseek', type = str)
    return parser.parse_args()
args = get_args()

combi_out = open("Additional_Hits.txt","w")
folddisco_folder = Path(args.folddisco)


with open(args.foldseek,"r") as foldseek_in :
        combi_out.write("Foldseek Hits:" + "\n" + "DB_Hit  unkonwn_protein_annotation_ID   fident|alnlen|mismatch|gapopen|qstart|qend|tstart|tend|evalue|bits" + "\n")
        for line in foldseek_in :
            foldseek_hit = line.strip()
            combi_out.write(foldseek_hit + "\n")
        combi_out.write("\n" + "\n" + "\n")
combi_out.write("Folddisco Hits:" + "\n" + "DB_Hit  unkonwn_protein_annotation_ID       node_count|tid|rmsd|matching_residues|query_residues" + "\n")

for files in folddisco_folder.iterdir() :
      with open(files, "r") as folddisco_in :
        ProtName = files.name.replace("folddisco_output_","")
        ProtName = ProtName.replace(".txt"," ")
        for line in folddisco_in :
            folddisco_hit = line.strip()
            if not folddisco_hit == "":
                folddisco_hit = folddisco_hit.replace("folded_protein_cifs/"," ")
                folddisco_hit = f"{ProtName}{folddisco_hit}"
                combi_out.write(folddisco_hit + "\n")
            
combi_out.close()