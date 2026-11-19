import os
import argparse
import torch
import re
import shutil
from esm.models.esmfold2 import EsmFold2Model
from esm.models.esmfold2 import ESMFold2InputBuilder, ProteinInput, StructurePredictionInput

#makes folder for the results
os.makedirs("folded_proteins", exist_ok=True)
os.makedirs("long_proteins", exist_ok=True)

#import of the single Protein fastas
def get_args():
    ## imports files from nextflow channels
    parser = argparse.ArgumentParser()
    parser.add_argument('--aaFasta', type=str)
    parser.add_argument('--esm_model_cache', type=str)
    parser.add_argument('--cuda_device', type=int)
    parser.add_argument('--protein_path', type=str)
    parser.add_argument('--known_naming_structure',type=str)
    parser.add_argument('--max_folding',type=int)
    return parser.parse_args()
args = get_args()

# reuqiered to pass the boolean from nextflow to python
if args.known_naming_structure == "true":
    name_structure_known = True
else:
    name_structure_known = False

print(name_structure_known,flush=True)


def clean_name(name):
    # everything except letters, digits, '.', '_' and '-' becomes '_'
    return re.sub(r"[^A-Za-z0-9._-]", "_", name)

#creates lists containing the name of the gene and the sequence. The Code will later itterate on these lists, the AA fasta has come from phold or folow the sheme of alternating rows of header an AA Sequence
sequenceDict = dict()
with open(args.aaFasta,"r") as aafasta :
    for line in aafasta:
        if line.startswith(">"):
            protname = line.strip()
            aasequence = next(aafasta).strip()

            # This is used to remove the locus tag from phold annotations as it clutters the protein name. For external aa_fastas a more general protein name is used.
            if name_structure_known == True:
                protname = f"{protname[1:9]}{protname[20:]}"
            else:
                protname = protname.replace(">","")
                protname = clean_name(protname)

            #this is to prevent long proteins from folding
            if len(aasequence) <= args.max_folding :
                sequenceDict[protname] = aasequence
            else :
                with open(f"long_proteins/long_protein{clean_name(protname)}.fasta","w") as toolong :
                    toolong.write(f">{protname}\n{aasequence}")

print(f"read {sequenceDict} loading model", flush=True)

# the model is loaded in to the cache as definied in the config 
model = EsmFold2Model.from_pretrained("biohub/ESMFold2", cache_dir=args.esm_model_cache).cuda(device=args.cuda_device).eval()
model = model.to(torch.bfloat16)
# 
print(f"loaded model", flush=True)
#print("Current allocated:",torch.cuda.memory_allocated() / 1024**3,"GB",flush=True)
#print("Current reserved:",torch.cuda.memory_reserved() / 1024**3,"GB",flush=True)

#iterates through the name list and hands the protein name and corrosponding AA Sequnce to ESM Fold
for protname,aasequence in sequenceDict.items():
    # ESMFold2 gets the aa Sequence and the protein name is set as ID.
    if not os.path.isfile(f"{args.protein_path}/{clean_name(protname)}.cif" ) and not os.path.isfile(f"long_proteins/long_protein{clean_name(protname)}.fasta" ):
        spi = StructurePredictionInput(
            sequences=[
                    ProteinInput(id=protname, sequence=aasequence)
            ]
        )
        print(f"Now folding {protname}")
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

                # the results are written as .cif and copyed to the folder specified in the config as protein_folder
                with open(f"folded_proteins/{clean_name(protname)}.cif", "w") as f:
                    f.write(result.complex.to_mmcif())
                shutil.copy(f"folded_proteins/{clean_name(protname)}.cif",args.protein_path)
                print(f"Finished folding {protname}")
    
        except torch.cuda.OutOfMemoryError:
            print(f"OOM while folding {protname} (lengh {len(aasequence)}), skipped", flush=True)
            with open(f"long_proteins/long_protein{clean_name(protname)}.fasta","w") as toolong :
                toolong.write(f">{protname}\n{aasequence}")

        finally:
            #print(f"Peak GPU memory: {torch.cuda.max_memory_allocated()/2**30:.1f} GiB", flush=True)
            torch.cuda.empty_cache()
    else:
        print(f"skipping {protname}. Already folded!", flush=True)
        shutil.copy(f"{args.protein_path}/{clean_name(protname)}.cif",f"folded_proteins/")