process FoldseekMatch
{
    maxForks params.foldseekForks
    cache params.foldseekCache

    tag "matches curted proteins against Phage proteins"

    conda "${params.conda_path}/foldseek"

    publishDir "$params.outputDir/output", pattern: "*foldseekMatches.tsv", mode: params.pubDirMode

    input: 
        path(foldseekDB_phage)
        path curatedDB

    output: 
        path("foldseekMatches_raw.tsv"), emit: foldseek_matches

// e value might have to be fine tuned
// targetphageDB was created by a prior 
    script:
    """
    foldseek easy-search \\
    --format-mode 4 \\
    --input-format 2 \\
    ${params.curatedDB} \\
    targetphageDB \\
    foldseekMatches_raw.tsv \\
    tmp \\
    -e ${params.foldseek_evalue} \\
    --threads ${params.foldseekCPUs}
    """  
}