process Folddisco_Match
{
    cache false
    conda "${params.conda_path}/folddisco"

    tag "compares Motives with Foldddisco"

    publishDir "$params.outputDir/output", pattern: "*folddisco_output.txt", mode: params.pubDirMode

    input: 
        path foldedProteins
        tuple val(prot_ID), path(curated_ch), path(site_txts)

    output:
        path "*folddisco_output.txt",  emit: folddisco_match
      
        
    script:
     def clean_prot_ID = prot_ID.trim()

    """

    touch ${clean_prot_ID}_folddisco_output.txt


    mkdir -p index
    mkdir -p folded_protein_cifs
    cp ${foldedProteins} folded_protein_cifs/
    folddisco index \\
        -p folded_protein_cifs \\
        -i index/phage_proteome_folddisco \\
        -t 4

    for file in *.txt; do
        
        folddisco query \\
            -i index/phage_proteome_folddisco \\
            -p ${curated_ch} \\
            -q "\$(cat "\$file")" \\
            -d 0.5 \\
            -a 5 \\
            -t 4 \\
            > "${clean_prot_ID}_folddisco_output.txt"

    done

    """
}