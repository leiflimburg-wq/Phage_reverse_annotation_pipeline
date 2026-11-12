process Folddisco_Match
{
    maxForks params.folddiscoForks
    cache params.folddiscoCache

    conda "${params.conda_path}/folddisco"

    tag "compares Motives with Foldddisco"

    //publishDir "$params.outputDir/output", pattern: "*folddisco_output*.txt", mode: params.pubDirMode

    input: 
        tuple val(geneID), path(foldedProteins), val(prot_ID), path(curated_ch), path(site_txts)

    output:
        tuple val(geneID), path("*folddisco_output*.txt"),  emit: folddisco_matches
      
        
    script:
    def clean_prot_ID = prot_ID.trim()
    """

    mkdir -p index

    folddisco index \\
        -p folded_proteins \\
        -i index/phage_proteome_folddisco \\
        -t ${params.folddiscoCPUs}

    for file in map_${clean_prot_ID}*.txt; do
        echo "Using motif file: \$file"
        site="\${file:20}"
        site="\${site%.txt}"
        touch ${geneID}_folddisco_output_${clean_prot_ID}_\${site}.txt
        folddisco query \\
            -i index/phage_proteome_folddisco \\
            -p ${curated_ch} \\
            -q "\$(cat "\$file")" \\
            -t ${params.folddiscoCPUs} \\
            --rmsd ${params.folddisco_rmsd} \\
            >> "${geneID}_folddisco_output_${clean_prot_ID}_\${site}.txt"

    done

    """
}