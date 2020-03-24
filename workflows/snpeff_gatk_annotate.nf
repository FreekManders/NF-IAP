include snpEffFilter from '../NextflowModules/snpEff/4.3t/snpEffFilter.nf' params(optional: 'GRCh37.75 -hgvs -lof -no-downstream -no-upstream -no-intergenic', mem: "${params.snpefffilter.mem}")
include SnpSiftDbnsfp from '../NextflowModules/snpEff/4.3t/SnpSiftDbnsfp.nf' params(optional: "${params.snpsiftsbnsfp.toolOptions}", mem: "${params.snpsiftsbnsfp.mem}", genome_dbnsfp: "${params.genome_dbnsfp}")
include SnpSiftAnnotate from '../NextflowModules/snpEff/4.3t/SnpSiftAnnotate.nf' params(optional: '-tabix -name GoNLv5 -info AF,AN,AC', mem: "${params.snpsiftannotate.mem}", genome_snpsift_annotate_db: "${params.genome_snpsift_annotate_db}")
include VariantAnnotator from '../NextflowModules/GATK/4.1.3.0/VariantAnnotator.nf' params(mem: "${params.variantannotator.mem}", genome_fasta : "${params.genome_fasta}", genome_variant_annotator_db: "${params.genome_variant_annotator_db}")


workflow snpeff_gatk_annotate {
  take:
    vcfs
  main:
    //Run snpEffFilter annotation step
    snpEffFilter(vcfs)

    // Run snpSift filter step
    SnpSiftDbnsfp(snpEffFilter.out)

    //Run GATK Cosmic annotation step
    VariantAnnotator(SnpSiftDbnsfp.out)

    //Run snpSift GoNL annotation step
    SnpSiftAnnotate(VariantAnnotator.out)

  emit:
    SnpSiftAnnotate.out

}
