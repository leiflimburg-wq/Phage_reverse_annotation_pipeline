process Folddisco_processing
{
    cache false
    conda "${params.conda_path}/python"

    tag "Assigns Sites to Proteins"

    //publishDir "${params.outputDir/output}", pattern: "combined_unannoted_aa_fasta/*.fasta" 
    
    input:
        path curated_ch
        path params.site_map

    output: 

        tuple stdout,
            path(curated_ch),
            path("*.txt"), 
            emit: preProc_folddisco

    script:
    """
    python ${projectDir}/bin/src/folddsico_processing.py --queryProtein ${curated_ch} --site_map ${params.site_map}
    """

}