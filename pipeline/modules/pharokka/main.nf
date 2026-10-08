process PharokkaAnnotate 
{
   conda "${params.conda_path}/pharokka"

   tag "Annotate Genome with Pharokka" 
   publishDir "$params.outputDir/output", pattern: "**.gbk", mode: params.pubDirMode

   input:
      path phageGenome
      path pharokkaDB

   output:
      path "**.gbk" , emit: pharokkaAnnotation

   script:
   """
      pharokka.py -i ${phageGenome} \\
      -d ${params.pharokkaDB} \\
      -t 16 \\
      -p pharokkaGBK
   """
}