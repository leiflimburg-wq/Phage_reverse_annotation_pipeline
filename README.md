# Phage_reverse_annotation_pipeline
 ## Intro
 Welcome Antinotate: An annotation pipeline to assign functions to unannotated phage proteins with reverse protein search. This Pipeline is comprised of five main steps to get from a genome fasta to the matching the proteins encoded in the genome against a custom curated database. This git hub reposotory contains a databse with epgenetic and epitrancriptomic modifiers, just following the installation guide and start finding new functions for the proteins in your Phages. 

 ## Databases
 The storage for path for all databases used by this pipeline can be set in the "params.config" file. Please make sure all paths are correctly set before use. 
 ### curated Database
 This pipeline comes with a curated Database of readers writers and erasers. It is comprised of *.cif* structure files and an *.xlsx* file cotaining the important sites for folddisco. Whenever possible X-Ray structures were used, otherwise the proteins were folded via ESMfold2. Heteroatoms including ATP, DNA, water and catalytic metallions were also removed from structures and all structures were passed through gemmi for better compatibility. For easier matching, homomultimeric X-Ray structures were reduced to their longest chain. If all chains were fully identical the chain comming first in the *.cif* was used. For the *Curated_DB_Sites.xlsx* file uniprot was checked (November 2026) for known **Active Sites, Binding Sites, and Sites** and written down as such together with their Uniprot ID. When there was no site reported on uniprot, mutations with a complete loss of function were added to the DB under the category **Site**. If there was also no mutation the proteins were removed from the database. There is also a supplementary *.xlsx* file with full protein names and informations on the sourcing available, this is however not used in the pipeline.

 ### Required Versions for external Databases
 For a correct annotation with Pharokka, the Pharroka Database Version 1.8.0 is required.
 The pipeline was validated on the phold DB installed on 1.10.2026. 

 ### How to make your own Database of proteins
 1. Create an *.xlsx* file with the columns **uniprot** **Binding Site** **Active Site** **Site**
 2. Find proteins you are intrested in and write down their uniprot ID and important sites in the *.xlsx* file. Note: you don't have to use the actual Uniprot ID, the written down ID however has to match the names of the *.cif* files used in your DB. It is also important that there is at least on site per protein as tehre are problems with folddisco when not specifiying the site. If you want to include a protein with unknown sites for foldseek matching, just write down 1 (or any number in range of the protein size) in your site and ignore the hits of this protein in the folddisco file.
 3. Download or predict the structures of the proteins you want to include as *.cif* and name them according to their Uniprot ID. Note: The pipeline is build for *.cif* files, other formats will cause issues and potential crashes. Other naming shemes are also supoorted and only 
 4. Check your structures and remove multimeric chains an heteroatoms. Note: This step can be skipped if all structures are predicted.
 5. Pass your proteins through gemmi. The pipeline provides a setting in the *params.config* file named **gemmiclean** and **before_gemmi_convert**. Set **gemmiclean** to true and assign the path to a folder containing only your *.cif* files to **before_gemmi_convert** and run the pipeline. The pipeline will generate a folder containing the cleaned files in the specified output directory. Note: This step is requiered for the correct parsing in folddisco and usualy not requiered for predicted structures. However passing the structure through gemmi does not change anything about the structure itself so it is always recommended. These settngs have to be disabled again before a proper run of the pipeline
 6. 





