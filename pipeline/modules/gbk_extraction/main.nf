process GBKextraction
{
    conda "${params.conda_path}/python"

    tag "filters the phold Annotation for unannotated proteins and exports them as aa fasta"

    publishDir "$params.outputDir/output", pattern: "combined_unannoted_aa_fasta/*.fasta", mode: params.pubDirMode
    
    input: 
        path pholdAnnotation

    output: 
        path "combined_unannotated_aa_fasta/*.fasta", emit: unannoted_aa_fasta_combined
        path "unannotated_aa_fasta/*.fasta", emit: singleProteinFastas

    script:  
    """
    python ${projectDir}/bin/src/gbk_extraction.py --pholdAnnotation ${pholdAnnotation}
    """

}