include { PharokkaAnnotate } from './modules/pharokka'

workflow
{
    PharokkaAnnotate(params.phageGenome, params.pharokkaDB)
}