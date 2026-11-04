process Folddisco_Match
{
    conda "${params.conda_path}/folddisco"

    tag "compares Motives with Foldddisco"

    publishDir "$params.outputDir/output", pattern: "folddisco_output*.txt", mode: params.pubDirMode

    input: 
        path foldedProteins
        tuple val(prot_ID), path(curated_ch), path(site_txts)

    output:
        path "folddisco_output*.txt",  emit: folddisco_matches
      
        
    script:
     def clean_prot_ID = prot_ID.trim()

    """

    touch folddisco_output_${clean_prot_ID}.txt


    mkdir -p index
    mkdir -p folded_protein_cifs
    cp ${foldedProteins} folded_protein_cifs/

    folddisco index \\
        -p folded_protein_cifs \\
        -i index/phage_proteome_folddisco \\
        -t 4

    for file in map_${clean_prot_ID}.txt; do
        
        folddisco query \\
            -i index/phage_proteome_folddisco \\
            -p ${curated_ch} \\
            -q "\$(cat "\$file")" \\
            -t 16 \\
            --rmsd 3 \\
            >> "folddisco_output_${clean_prot_ID}.txt"

    done

    """
}