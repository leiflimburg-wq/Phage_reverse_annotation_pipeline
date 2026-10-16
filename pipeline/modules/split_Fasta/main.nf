process SplitFasta
{
    //python script can not be opened without an enviornment containing python
    conda "${params.conda_path}/python"

    //process discription
    tag "split genome fasta from phold into single protein fastas"

    //outputs the splited_genomes folder with all fastas in the output folder defined in the config
    publishDir "$params.outputDir/output", pattern: "splited_genomes/*.fasta", mode: params.pubDirMode

    //recieves the aminoacid sequnces as anotated by phold
    input:
        path pholdaaAnnotation
    
    //emits all fastas in the splited_genomes folder (aka the single protein fastas) in the channel "singleProteinFastas"
    output:
      path "splited_genomes/*.fasta" , emit: singleProteinFastas

    // opens the python script
    script:
    """
        python ${projectDir}/bin/src/splitFasta.py --aaFASTA ${pholdaaAnnotation}
    """
}