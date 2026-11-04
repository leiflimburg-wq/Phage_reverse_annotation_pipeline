include { PharokkaAnnotate } from './modules/pharokka'
include { PholdAnnotate } from './modules/phold'
include { StructurePredict } from './modules/structure_predict'
include { FoldseekDB } from './modules/foldseekDB'
include { FoldseekMatch } from './modules/foldseekMatch'
include { SplitFasta } from './modules/split_Fasta'
include { GBKextraction } from './modules/gbk_extraction'
include { Folddisco_processing } from './modules/folddisco_processing'
include { Folddisco_Match} from './modules/folddiscoMatch'
include { Lolalign } from './modules/lolalign'


workflow
{
    PharokkaAnnotate(params.phageGenome, params.pharokkaDB)
    PholdAnnotate(PharokkaAnnotate.out.pharokkaAnnotation,params.pholdDB)

    if (params.annotateAll == true)
    {
        SplitFasta(PholdAnnotate.out.pholdaaAnnotation)
        StructurePredict(SplitFasta.out.singleProteinFastas.flatten(), params.esm_model_cache)
    }
    else 
    {
        GBKextraction(PholdAnnotate.out.pholdAnnotation)
        StructurePredict(GBKextraction.out.singleProteinFastas.flatten(), params.esm_model_cache)
    }
    FoldseekDB(StructurePredict.out.foldedProteins.collect())
    FoldseekMatch(FoldseekDB.out.foldseekDB_phage.collect(), params.curatedDB)
    curated_ch = Channel.fromPath("${params.curatedDB}/*.cif")
    Folddisco_processing(curated_ch.flatten(),params.site_map)
    Folddisco_Match(StructurePredict.out.foldedProteins.collect(),Folddisco_processing.out.preProc_folddisco)
    //Lolalign(FoldseekDB.out.foldseekDB_phage.collect(), params.curatedDB) //lolalign ist not yet available 
}