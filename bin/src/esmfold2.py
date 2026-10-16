import os
import argparse
import torch
from esm.models.esmfold2 import EsmFold2Model
from esm.models.esmfold2 import ESMFold2InputBuilder, ProteinInput, StructurePredictionInput

#makes folder for the results
os.makedirs("folded_proteins", exist_ok=True)

#import of the single Protein fastas
def get_args():
    ## imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--singleFASTA', type=str)
    parser.add_argument('--esm_model_cache', type=str)
    return parser.parse_args()
args = get_args()

# opens the single protein fasta to get the AA Sequence
with open(args.singleFASTA,"r") as singleFASTA:
    for line in singleFASTA:
        # skipts header lines
        if ">" in line:
            name = line[0:].strip()
            name = name.replace(">","")
            name = name.replace(":","_")
        # saves the aminoacid sequnece in the non header line as aaSequence
        else:
            aaSequence = line[0:].strip()

# ESMFold2 gets the aa Sequence and the protein name is set as ID

spi = StructurePredictionInput(
            sequences=[
                ProteinInput(id=name, sequence=aaSequence)
            ]
        )
# making sure the model is loaded on the GPU

# the model is loaded in to the cache as definied in the config
model = EsmFold2Model.from_pretrained("biohub/ESMFold2", cache_dir=args.esm_model_cache).cuda(device=0).eval()

# ESM Fold folds the protein 
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
with open(f"folded_proteins/{name}.cif", "w") as f:
                f.write(result.complex.to_mmcif())

