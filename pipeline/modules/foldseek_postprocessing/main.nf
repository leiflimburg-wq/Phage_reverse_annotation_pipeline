process Foldseek_postprocessing{
    cache false
    conda "${params.conda_path}/python"

    tag "processes the foldseek results"
    
    publishDir "$params.outputDir/output", pattern: "foldseekHits.tsv", mode: params.pubDirMode
    publishDir "$params.outputDir/output", pattern: "foldseek_Phages/*", mode: params.pubDirMode

    input:
        path(foldseek_matches)

    output: 
        path "foldseekHits.tsv"
        path "foldseek_Phages/*"

    script:
    """
    mkdir -p foldseek_Phages

    python ${projectDir}/bin/src/foldseek_postprocessing.py --foldseek ${foldseek_matches}
    """
}
    
