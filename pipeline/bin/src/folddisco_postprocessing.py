import argparse
import os
import pandas as pd
from pathlib import Path

def get_args():
    #imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--folddisco', type = str)
    parser.add_argument('--geneID', type = str)
    return parser.parse_args()
args = get_args()

combi_tsv = open(f"{args.geneID}_folddiscoHits.tsv","w")
folddisco_folder = Path(args.folddisco)
combi_tsv.write("DB_Hit\tunkonwn_protein_annotation_ID\tnode_count\ttid\trmsd\tmatching_residues\tquery_residues\tSite" + "\n")

for files in folddisco_folder.iterdir() :
      with open(files, "r") as folddisco_in :
        SiteHit = files.name[33:].replace(".txt","")
        ProtName = files.name[26:33]
        for line in folddisco_in :
            folddisco_hit = line.strip()
            if not folddisco_hit == "":
                folddisco_hit = folddisco_hit.replace("folded_protein_cifs/","")
                folddisco_hit = f"{ProtName}\t{folddisco_hit}\t{SiteHit}"
                combi_tsv.write(folddisco_hit + "\n")
            
combi_tsv.close()