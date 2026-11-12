process Folddisco_preprocessing
{
    cache params.folddiscoCache

    conda "${params.conda_path}/python"
    
    tag "Assigns Sites to Proteins"
    
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
    python ${projectDir}/bin/src/folddsico_preprocessing.py --queryProtein ${curated_ch} --site_map ${params.site_map}
    """

}