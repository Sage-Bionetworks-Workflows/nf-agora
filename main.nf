// Ensure DSL2
nextflow.enable.dsl = 2

import org.yaml.snakeyaml.Yaml

def LARGE_MEMORY_DATASETS = ['rna_de_individual', 'rna_de_aggregate']

process AGORA_DATA_RUN {

    container "ghcr.io/sage-bionetworks/agora-data-tools:latest"

    secret "SYNAPSE_AUTH_TOKEN"

    memory { LARGE_MEMORY_DATASETS.contains(dataset) ? 64.GB * task.attempt : 32.GB * task.attempt }
    //make sure other tasks can finish when one task fails
    errorStrategy 'finish'

    input:
    path(config)
    val dataset

    script:
    """
    adt ${config} --upload --platform NEXTFLOW --run_id ${workflow.runName} --dataset '${dataset}'
    """

}



workflow {

    if (params.dataset) {
        datasets_ch = Channel.of(params.dataset)
    } else {
        def yaml = new Yaml().load(new URL(params.config).text)
        datasets_ch = Channel.from(yaml.datasets.collect { it.keySet().first() })
    }

    AGORA_DATA_RUN(params.config, datasets_ch)

}
