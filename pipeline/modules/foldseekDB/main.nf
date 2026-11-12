process FoldseekDB
{
    cache params.foldseekCache
    maxForks params.foldseekForks
    tag "creates DB of folded Phage proteins"

    conda "${params.conda_path}/foldseek"

    input: 
        tuple val(geneID), path(foldedProteins)

    output: 
        tuple val(geneID), path("${geneID}_targetphageDB*"), emit: foldseekDB_phage

    script:
    """
    foldseek createdb \\
    ${foldedProteins} \\
    ${geneID}_targetphageDB \\
    --input-format 2 \\
    """
} 