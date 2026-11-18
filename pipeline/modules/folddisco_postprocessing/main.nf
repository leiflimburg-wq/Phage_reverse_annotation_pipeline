process Folddiso_postprocessing
{
    cache false
    conda "${params.conda_path}/python"

    tag "combines folddisco results to one tsv"
    
    publishDir "$params.outputDir/output", pattern: "folddiscoHits.tsv", mode: params.pubDirMode
    publishDir "$params.outputDir/output", pattern: "folddisco_phages/*", mode: params.pubDirMode


    input:
        path(folddisco_matches)

    output: 
        path "folddiscoHits.tsv"
        path "folddisco_phages/*"

    script:
    """
    mkdir -p folddisco
    mkdir -p folddisco_phages
    cp ${folddisco_matches} folddisco/

    python ${projectDir}/bin/src/folddisco_postprocessing.py --folddisco folddisco
    """

}