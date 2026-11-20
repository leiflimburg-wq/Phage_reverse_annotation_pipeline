process Gemmiconvert {
    conda "${params.conda_path}/gemmi"


    publishDir "$params.outputDir/output", pattern: "after_gemmi/*.cif", mode: params.pubDirMode

    input:
        path beforegemmi
    output:
        path "after_gemmi/*.cif"
    
    
    script:
    def protID = beforegemmi.baseName.trim()
    """
    mkdir after_gemmi
    gemmi convert ${beforegemmi} after_gemmi/${protID}.cif
    """

    

}
