process StructurePredict
{
    //maxForks params.esmForks
    maxForks 1 

    conda "${params.conda_path}/ESMfoldCuda"

    tag "Predict protein structures from phold Annotation" 

    publishDir "$params.outputDir/output", pattern: "folded_proteins/*.cif", mode: params.pubDirMode

    input:
        tuple val(geneID), path(pholdaaAnnotation)
        path esm_model_cache
        
    output:
        path("folded_proteins/*.cif"), emit: foldedProteins
        //path("long_proteins/*.txt"), emit: longProteins
    
    script:
    """
        python ${projectDir}/bin/src/esmfold2.py --aaFasta ${pholdaaAnnotation} --esm_model_cache ${params.esm_model_cache} --cuda_device ${params.cuda_device}
    """
}