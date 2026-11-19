include { PharokkaAnnotate } from './modules/pharokka'
include { PholdAnnotate } from './modules/phold'
include { StructurePredict } from './modules/structure_predict'
include { FoldseekDB } from './modules/foldseekDB'
include { FoldseekMatch } from './modules/foldseekMatch'
include { SplitFasta } from './modules/split_Fasta'
include { GBKextraction } from './modules/gbk_extraction'
include { Folddisco_preprocessing } from './modules/folddisco_preprocessing'
include { Folddisco_Match} from './modules/folddiscoMatch'
include { Lolalign } from './modules/lolalign'
include { Combine_results } from './modules/combine_results'
include { Folddiso_postprocessing } from './modules/folddisco_postprocessing'
include { Foldseek_postprocessing } from './modules/foldseek_postprocessing'

workflow
{
    if (params.dontMatch == true) {
        genomes = Channel.fromPath("${params.phageGenomeFolder}/*")
        PharokkaAnnotate(genomes.flatten())
        PholdAnnotate(PharokkaAnnotate.out.pharokkaAnnotation,params.pholdDB)

        if (params.annotateAll == true) {
            StructurePredict(PholdAnnotate.out.pholdaaAnnotation, params.esm_model_cache)
        }
        else {
            GBKextraction(PholdAnnotate.out.pholdAnnotation)
            StructurePredict(GBKextraction.out.singleProteinFastas.transpose(), params.esm_model_cache)
        }
    }

    else if (params.external_aa_fasta == true) {
        external_aa = Channel.fromPath("${params.external_aa_path}")
        StructurePredict(external_aa, params.esm_model_cache)
        FoldseekDB(StructurePredict.out.foldedProteins.collect())
        FoldseekMatch(FoldseekDB.out.foldseekDB_phage, params.curatedDB)
        Foldseek_postprocessing(FoldseekMatch.out.foldseek_matches)
        curated_ch = Channel.fromPath("${params.curatedDB}/*.cif")
        Folddisco_preprocessing(curated_ch.flatten(),params.site_map)
        Folddisco_Match(StructurePredict.out.foldedProteins.collect(), Folddisco_preprocessing.out.preProc_folddisco)
        //Lolalign(FoldseekDB.out.foldseekDB_phage.collect(), params.curatedDB) //lolalign ist not yet available 
        Folddiso_postprocessing(Folddisco_Match.out.folddisco_matches.collect())
    }

    else if (params.onlyMatch == true){
        folded_proteins = Channel.fromPath("${params.protein_folder}")
        FoldseekDB(StructurePredict.out.foldedProteins.collect())
        FoldseekMatch(FoldseekDB.out.foldseekDB_phage, params.curatedDB)
        Foldseek_postprocessing(FoldseekMatch.out.foldseek_matches)
        curated_ch = Channel.fromPath("${params.curatedDB}/*.cif")
        Folddisco_preprocessing(curated_ch.flatten(),params.site_map)
        Folddisco_Match(StructurePredict.out.foldedProteins.collect(), Folddisco_preprocessing.out.preProc_folddisco)
        //Lolalign(FoldseekDB.out.foldseekDB_phage.collect(), params.curatedDB) //lolalign ist not yet available 
        Folddiso_postprocessing(Folddisco_Match.out.folddisco_matches.collect())
    }

    else{
        genomes = Channel.fromPath("${params.phageGenomeFolder}/*")
        PharokkaAnnotate(genomes.flatten())
        PholdAnnotate(PharokkaAnnotate.out.pharokkaAnnotation,params.pholdDB)

        if (params.annotateAll == true) {
            StructurePredict(PholdAnnotate.out.pholdaaAnnotation, params.esm_model_cache)
        }
        else {
            GBKextraction(PholdAnnotate.out.pholdAnnotation)
            StructurePredict(GBKextraction.out.singleProteinFastas.transpose(), params.esm_model_cache)
        }

        FoldseekDB(StructurePredict.out.foldedProteins.collect())
        FoldseekMatch(FoldseekDB.out.foldseekDB_phage, params.curatedDB)
        Foldseek_postprocessing(FoldseekMatch.out.foldseek_matches)
        curated_ch = Channel.fromPath("${params.curatedDB}/*.cif")
        Folddisco_preprocessing(curated_ch.flatten(),params.site_map)
        Folddisco_Match(StructurePredict.out.foldedProteins.collect(), Folddisco_preprocessing.out.preProc_folddisco)
        //Lolalign(FoldseekDB.out.foldseekDB_phage.collect(), params.curatedDB) //lolalign ist not yet available 
        Folddiso_postprocessing(Folddisco_Match.out.folddisco_matches.collect())
    }

}