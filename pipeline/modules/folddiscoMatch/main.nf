process Folddisco_Match
{
    maxForks params.folddiscoForks
    cache params.folddiscoCache
    cpus params.folddiscoCPUs

    conda "${params.conda_path}/folddisco"

    tag "compares Motives with Foldddisco"

    //publishDir "$params.outputDir/output", pattern: "*folddisco_output*.txt", mode: params.pubDirMode

    input: 
        path(foldedProteins)
        tuple val(prot_ID), path(curated_ch), path(site_txts)

    output:
        path("folddisco_output*.txt"),  emit: folddisco_matches
      
        
    script:
    def clean_prot_ID = prot_ID.trim()
    """

    mkdir -p index
    mkdir -p folded_proteins
    cp ${foldedProteins} folded_proteins

    folddisco index \\
        -p folded_proteins \\
        -i index/phage_proteome_folddisco \\
        -t ${task.cpus}

    for file in map_${clean_prot_ID}*.txt; do
        echo "Using motif file: \$file"
        site="\${file:20}"
        site="\${site%.txt}"
        touch folddisco_output_${clean_prot_ID}_\${site}.txt
        folddisco query \\
            -i index/phage_proteome_folddisco \\
            -p ${curated_ch} \\
            -q "\$(cat "\$file")" \\
            -t ${task.cpus} \\
            --rmsd ${params.folddisco_rmsd} \\
            >> "folddisco_output_${clean_prot_ID}_\${site}.txt"

    done

    """
}