import os
import argparse
import torch
import re
from esm.models.esmfold2 import EsmFold2Model
from esm.models.esmfold2 import ESMFold2InputBuilder, ProteinInput, StructurePredictionInput

#makes folder for the results
os.makedirs("folded_proteins", exist_ok=True)

#import of the single Protein fastas
def get_args():
    ## imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--aaFasta', type=str)
    parser.add_argument('--esm_model_cache', type=str)
    parser.add_argument('--cuda_device', type=int)
    return parser.parse_args()
args = get_args()

#creates lists containing the name of the gene and the sequence. The Code will later itterate on these lists, the AA fasta has come from phold or folow the sheme of alternating rows of header an AA Sequence
with open(args.aaFasta,"r") as genomeFASTA:
    name_list = list()
    sequence_list = list()
    for line in genomeFASTA:
        # if a header line is detected the name is added to the name list and removes inavlid symbols
        if ">" in line: 
            name = line[0:].strip()
            name = re.sub(r"['´`#/\\.<>!?*]","",name)
            name = name.replace(":","_")
            name_list.append(name)
        # a line without a header contains the aa sequence and is written added to the sequence list
        # the aa sequence is always written in just one line and teh file starts with the first header, so the name list should always be longer than the sequences list
        elif len(name_list) > len(sequence_list):
            aaLine = line[0:].strip()
            sequence_list.append(aaLine)
        # Error Messages to diagnose problems with the reading of the file due to an unexpected format
        elif len(name_list) <= 0:
            print("Error: No header in first line of fasta file! Please check the AA annotaion by Phold!", flush=True)
        elif len(name_list) <= len(sequence_list):
            print("Error: More than one line of AA Sequences check aaFasta", flush=True)
        else:
            print("Error: unexpected problem in the reading of the aaFasta, check phold annotation and aaFasta")


# the model is loaded in to the cache as definied in the config 
model = EsmFold2Model.from_pretrained("biohub/ESMFold2", cache_dir=args.esm_model_cache).cuda(device=args.cuda_device).eval()
model = model.to(torch.bfloat16)


# 
print("Current allocated:",torch.cuda.memory_allocated() / 1024**3,"GB",flush=True)
print("Current reserved:",torch.cuda.memory_reserved() / 1024**3,"GB",flush=True)

#iterates through the name list and hands the protein name and corrosponding AA Sequnce to ESM Fold
if len(name_list) == len(sequence_list):
    for proteinname,aaSequence in zip(name_list,sequence_list):
    # ESMFold2 gets the aa Sequence and the protein name is set as ID.gibt es eine möglich
        spi = StructurePredictionInput(
            sequences=[
                ProteinInput(id=proteinname, sequence=aaSequence)
            ]
    )
    # ESM Fold folds the protein 
        try:
            with torch.inference_mode():
                with torch.autocast(device_type="cuda",dtype=torch.bfloat16):
                    result = ESMFold2InputBuilder().fold(
                    # loads the model and sequence
                        model, spi, 
                    # defines the model parameters
                        num_loops=3, 
                        num_sampling_steps=25, 
                        num_diffusion_samples=1, 
                        seed=0
            )
    # the results are written as .cif 
            with open(f"folded_proteins/{proteinname}.cif", "w") as f:
                f.write(result.complex.to_mmcif())
        finally:
            print(f"Peak GPU memory: {torch.cuda.max_memory_allocated()/2**30:.1f} GiB", flush=True)
else:
    print("Error, amount of headers and sequences differs in aaFasta (normlay created by phold). Aborting structure prediction", flush=True)
    quit()