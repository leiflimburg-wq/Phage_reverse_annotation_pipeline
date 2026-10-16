process FoldseekMatch
{
    tag "matches curted proteins against Phage proteins"

    conda "${params.conda_path}/foldseek"

    publishDir "$params.outputDir/output", pattern: "foldseekMatches.m8", mode: params.pubDirMode

    input: 
        path foldseekDB_phage
        path validationprotein_reference

    output: 
       path "aln.m8"

// e value might have to be fine tuned
    script:
    """
    foldseek easy-search \\
    ${validationprotein_reference} \\
    targetphageDB \\
    foldseekMatches.m8 \\
    tmp \\
    -e 0.001 \\
    --threads 16
    """  
}