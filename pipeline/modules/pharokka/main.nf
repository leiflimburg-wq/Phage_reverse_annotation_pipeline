process PharokkaAnnotate 
{
   // loads the pharokka conda enviorment (see pharokka.yml) and gives a process description
   conda "${params.conda_path}/pharokka"

   tag "Annotate Genome with Pharokka" 

   // publishes all files, in a subdirectory of the work directory, named "pharokkaGBK.gbk" to a subfolder named "output" of the external outputdirectory (defined in the config)
   publishDir "$params.outputDir/output", pattern: "*/pharokkaGBK.gbk", mode: params.pubDirMode

   // loads the phagegenome and the pharokka from external folders (defined in the config)
   input:
      path phageGenome
      path pharokkaDB

   // emits the pharokkaGBK.gbk (located in workdirectory/anyfolder/pharokkaGBK.gbk) to a channel named pharokkaAnnotation
   output:
      path "*/pharokkaGBK.gbk" , emit: pharokkaAnnotation

   // runs the standard pharokka script with: the phageGenome (as defined in the config), the pharokka Database (as defined in the config), 16 threads, and creates files named "pharokkaGBK.XXX"
   script:
   """
      pharokka.py \\
      -i ${phageGenome} \\
      -d ${params.pharokkaDB} \\
      -t 16 \\
      -p pharokkaGBK
   """
}