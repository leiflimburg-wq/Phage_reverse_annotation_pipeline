import argparse
import os
import pandas as pd
from pathlib import Path

def get_args():
    #imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--folddisco', type = str)
    return parser.parse_args()
args = get_args()

combi_tsv = open(f"folddiscoHits.tsv","w")
folddisco_folder = Path(args.folddisco)
combi_tsv.write("query\tPhage\tfident\tnode_count\ttid\trmsd\tmatching_residues\tquery_residues\tHitSite" + "\n")

for files in folddisco_folder.iterdir() :
      with open(files, "r") as folddisco_in :
        SiteHit = files.name[24:].replace(".txt","")
        ProtName = files.name[17:23]
        for line in folddisco_in :
            folddisco_hit = line.strip()
            if not folddisco_hit == "":
                folddisco_hit = folddisco_hit.replace("folded_proteins/","")
                Phage = folddisco_hit[:8]
                folddisco_hit = f"{ProtName}\t{Phage}\t{folddisco_hit}\t{SiteHit}"
                combi_tsv.write(folddisco_hit + "\n")
            
combi_tsv.close()

df = pd.read_csv("folddiscoHits.tsv", sep="\t", dtype=str)

for phage, hits in df.groupby("Phage"):
    hits.to_csv(f"folddisco_phages/folddisco_hits_{phage}.tsv", sep="\t", index = False)
