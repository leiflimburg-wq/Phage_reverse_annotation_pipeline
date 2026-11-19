process StructurePredict
{
    //maxForks params.esmForks
    maxForks 1 

    conda "${params.conda_path}/ESMfoldCuda"

    tag "Predict protein structures from phold Annotation" 

    //publishDir "$params.outputDir/output", pattern: "folded_proteins/*.cif", mode: params.pubDirMode
    publishDir "$params.outputDir/output", pattern: "long_proteins/*.txt", mode: params.pubDirMode

    input:
        path(pholdaaAnnotation)
        path esm_model_cache
        
    output:
        path("folded_proteins/*.cif"), emit: foldedProteins
        path("long_proteins/*.txt"), emit: longProteins, optional:true
    
    script:
    """
        python ${projectDir}/bin/src/esmfold2.py --aaFasta ${pholdaaAnnotation} \\
        --esm_model_cache ${params.esm_model_cache} \\
        --cuda_device ${params.cuda_device} \\
        --protein_path ${params.protein_folder} \\
        --known_naming_structure ${params.known_naming_structure} \\
        --max_folding ${params.maxfolding}
    """
}