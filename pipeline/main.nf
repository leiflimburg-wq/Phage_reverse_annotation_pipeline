include { PharokkaAnnotate } from './modules/pharokka'
include { PholdAnnotate } from './modules/phold'
// include { SplitFasta } from './modules/split_Fasta'
include { StructurePredict } from './modules/structure_predict'
include { FoldseekDB } from './modules/foldseekDB'
include { FoldseekMatch } from './modules/foldseekMatch'
include { GBKextraction } from './modules/gbk_extraction'

workflow
{
    PharokkaAnnotate(params.phageGenome, params.pharokkaDB)
    PholdAnnotate(PharokkaAnnotate.out.pharokkaAnnotation,params.pholdDB)
    // SplitFasta(PholdAnnotate.out.pholdaaAnnotation)
    // StructurePredict(SplitFasta.out.singleProteinFastas.flatten(), params.esm_model_cache)
    GBKextraction(PholdAnnotate.out.pholdAnnotation)
    StructurePredict(GBKextraction.out.singleProteinFastas.flatten(), params.esm_model_cache)
    FoldseekDB(StructurePredict.out.foldedProteins)
    FoldseekMatch(FoldseekDB.out.foldseekDB_phage, params.validationprotein_reference)
    
}