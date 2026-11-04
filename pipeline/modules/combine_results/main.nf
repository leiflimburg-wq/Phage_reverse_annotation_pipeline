process Combine_results
{
    cache false
    conda "${params.conda_path}/python"

    tag "combines foldseek and folddisco files"
    
    publishDir "$params.outputDir/output", pattern: "Additional_Hits.txt", mode: params.pubDirMode


    input:
        path folddisco_matches
        path foldseek_matches

    output: 
        path "Additional_Hits.txt"
    script:
    """
    mkdir -p folddisco
    cp ${folddisco_matches} folddisco/
    python ${projectDir}/bin/src/combine_results.py --folddisco folddisco --foldseek ${foldseek_matches}
    """

}