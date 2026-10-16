process StructurePredict
{
    maxForks params.maxforks

    conda "${params.conda_path}/ESMfoldCuda"

    tag "Predict protein structures from phold Annotation" 

    publishDir "$params.outputDir/output", pattern: "folded_proteins/*.cif", mode: params.pubDirMode

    input:
        path singleProteinFastas
        path esm_model_cache
        
    output:
        path "folded_proteins/", emit: foldedProteins
    
    script:
    """
        python ${projectDir}/bin/src/esmfold2.py --singleFASTA ${singleProteinFastas} --esm_model_cache ${params.esm_model_cache}
    """
}