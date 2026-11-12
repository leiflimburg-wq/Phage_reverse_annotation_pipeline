process Combine_results
{
    cache false
    conda "${params.conda_path}/python"

    tag "combines foldseek and folddisco files"
    
    publishDir "$params.outputDir/output", pattern: "*Additional_Hits.txt", mode: params.pubDirMode


    input:
        tuple val(geneID), path(folddisco_matches), path(foldseek_matches)

    output: 
        path "${geneID}_Additional_Hits.txt"
    script:
    """
    mkdir -p folddisco
    for file in ${folddisco_matches}; do
        cp \$file folddisco/
    python ${projectDir}/bin/src/combine_results.py --folddisco folddisco --foldseek ${foldseek_matches} --geneID ${geneID}
    """

}