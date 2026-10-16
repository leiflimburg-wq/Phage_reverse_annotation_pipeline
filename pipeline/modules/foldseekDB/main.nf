process FoldseekDB
{
    tag "creates DB of folded Phage proteins"

    conda "${params.conda_path}/foldseek"

    input: 
        path foldedProteins

    output: 
        path "targetphageDB*", emit: foldseekDB_phage

    script:
    """
    foldseek createdb \\
    ${foldedProteins} \\
     targetphageDB \\
    --input-format 2 \\
    """
} 