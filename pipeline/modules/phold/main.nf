process PholdAnnotate 
{
   cache params.pholdCache
   maxForks params.pholdForks

   // loads the pharokka conda enviorment (see pholdENV.yml) and gives a process description
   conda "${params.conda_path}/pholdENV"

   tag "Annotate genome with Phold" 

   // publishes all files, in a subdirectory of the work directory, named "phold.gbk" to a subfolder named "output" of the external output directory (defined in the config)
   publishDir "$params.outputDir/output", pattern: "*/*phold.gbk", mode: params.pubDirMode

   // loads the content of the channel pharokkaAnnotation (recieved from PharokkaAnnotate) and the pholdDB (location definied in config)
   input:
      tuple val(geneID), path(pharokkaAnnotation)
      path pholdDB

   // finds the files: "phold.gbk", "phold_3di.fasta" and "phold_aa.fasta" in subdirectory of the work directory; and emits them each into their own channel
   output:
      tuple val(geneID), path("*/*phold.gbk"), emit: pholdAnnotation
      tuple val(geneID), path("*/*phold_3di.fasta"), emit: phold3diAnnotation
      tuple val(geneID), path("*/*phold_aa.fasta"), emit: pholdaaAnnotation

   // runs the phold script with: the annotation recieved by pharokka, 16 threads, creates output files named "phold.XXX" , and the external database "pholdDB" as definied in the configs
   script:
   """
      phold run \\
      -i ${pharokkaAnnotation} \\
      -t ${params.pholdCPUs} \\
      -p ${geneID}_phold \\
      -d ${params.pholdDB}
   """
}