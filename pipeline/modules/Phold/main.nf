process PharokkaAnnotate 
{
   conda "${params.conda_path}/pholdENV"

   tag "Annotate Genome with Phold" 
   publishDir "$params.outputDir/output", pattern: "pholdGBK.gbk", mode: params.pubDirMode

   input:
      path pharokkaAnnotation
      path pholdDB

   output:
      path "pholdGBK.gbk" , emit: pholdAnnotation

   script:
   """
      phold run \\
      -i ${pharokkaAnnotation} 
      -t 16 \\
      -p pholdGBK \\
      -d ${params.pholdDB}
   """
}