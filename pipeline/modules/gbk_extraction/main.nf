process GBKextraction
{
    conda "${params.conda_path}/python"

    tag "filters for unannotated proteins and exports their aa fasta"

    publishDir "$params.outputDir/output", pattern: "combined_unannoted_aa_fasta/*.fasta", mode: params.pubDirMode
    
    input: 
        tuple val(geneID), path(pholdAnnotation)

    output: 
        tuple val(geneID), path("combined_unannotated_aa_fasta/*.fasta"), emit: unannoted_aa_fasta_combined
        tuple val(geneID), path("unannotated_aa_fasta/*.fasta"), emit: singleProteinFastas

    script:  
    """
    python ${projectDir}/bin/src/gbk_extraction.py --pholdAnnotation ${pholdAnnotation} --geneID ${geneID}
    """

}