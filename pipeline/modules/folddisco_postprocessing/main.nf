process Folddiso_postprocessing
{
    cache false
    conda "${params.conda_path}/python"

    tag "combines folddisco results to one tsv"
    
    publishDir "$params.outputDir/output", pattern: "*_folddiscoHits.tsv", mode: params.pubDirMode


    input:
        tuple val(geneID), path(folddisco_matches)

    output: 
        path "${geneID}_folddiscoHits.tsv"

    script:
    """
    mkdir -p folddisco
    cp ${folddisco_matches} folddisco/

    python ${projectDir}/bin/src/folddisco_postprocessing.py --folddisco folddisco --geneID ${geneID}
    """

}