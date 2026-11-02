process FoldseekMatch
{
    tag "matches curted proteins against Phage proteins"

    conda "${params.conda_path}/foldseek"

    publishDir "$params.outputDir/output", pattern: "foldseekMatches.m8", mode: params.pubDirMode

    input: 
        path foldseekDB_phage
        path curatedDB

    output: 
       path "foldseekMatches.m8"

// e value might have to be fine tuned
// targetphageDB was created by a prior 
    script:
    """
    foldseek easy-search \\
    --input-format 2 \\
    ${params.curatedDB} \\
    targetphageDB \\
    foldseekMatches.m8 \\
    tmp \\
    -e 0.025 \\
    --threads 16
    """  
}