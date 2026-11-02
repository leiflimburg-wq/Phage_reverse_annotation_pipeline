import argparse
import os
import pandas as pd
import csv
import logging

#reads CSV 
def get_args():
    #imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--queryProtein', type = str)
    parser.add_argument('--site_map', type = str)
    return parser.parse_args()
args = get_args()



db = pd.read_excel(args.site_map)
uniprot_id = db["uniprot"]
binding = db["Binding Site"]
active = db["Active Site"]
site = db["Site"]
files = args.queryProtein
numprot = len(uniprot_id)
i = 0
p = 0
while not p == numprot:
    if uniprot_id[p] in files:
        if not str(binding[p]) == "nan":
            logging.info(binding[p])
            with open(f"./{uniprot_id[p]}_folddiscoBinding.txt", "w") as fdbd :
                fdbd.write(str(binding[p]).replace(".",","))
        if not str(active[p]) == "nan":
            logging.info(active[p])
            with open(f"./{uniprot_id[p]}folddiscoActive.txt", "w") as fdac :
                fdac.write(str(active[p]).replace(".",","))
        if not str(site[p]) == "nan":
            logging.info(site[p])
            with open(f"./{uniprot_id[p]}folddiscoSite.txt", "w") as fdsi :
                fdsi.write(str(site[p]).replace(".",","))
        print(uniprot_id[p])
        p = numprot
    else :
        p = p + 1
        i = i +1
