process Lolalign
{
    tag "Matches using Lolalign"

    conda "${params.conda_path}/lolalign"

    publishDir "$params.outputDir/output", pattern: "LolalignMatches.m8", mode: params.pubDirMode

    input: 
        path foldseekDB_phage
        path curatedDB

    output: 
       path "LolalignMatches.m8"

// e value might have to be fine tuned
// targetphageDB was created by a prior process
    script:
    """
    foldseek version
    foldseek easy-search \\
    --input-format 2 \\
    ${curatedDB} \\
    targetphageDB \\
    LolalignMatches.m8 \\
    temp \\
    --alignment-type 3 \\
    --e 0.025
    --threads 16
    """  
}