import argparse
import os
import pandas as pd
from pathlib import Path

def get_args():
    #imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--foldseek', type = str)
    return parser.parse_args()
args = get_args()

old_tsv = open(args.foldseek)
new_tsv = open(f"foldseekHits.tsv","w")

for line in old_tsv:
    if line.startswith("query"):
        header = line.strip()
        new_tsv.write(f"{header[:6]}Phage\t{header[6:]}\n")
    else:
        hit = line.strip()
        new_tsv.write(f"{hit[:7]}{hit[7:15]}\t{hit[7:]}\n")
new_tsv.close()

df = pd.read_csv("foldseekHits.tsv", sep="\t", dtype=str)

for phage, hits in df.groupby("Phage"):
    hits.to_csv(f"foldseek_Phages/foldseek_hits_{phage}.tsv", sep="\t", index = False)
        