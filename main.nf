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
    // omit --dataset flag entirely if dataset is empty
    def datasetFlag = dataset ? "--dataset '${dataset}'" : ''
    """
    adt ${config} --upload --platform NEXTFLOW --run_id ${workflow.runName} ${datasetFlag}
    """

}



workflow {

    if (params.dataset) {
        // split comma-separated dataset names (handles optional spaces) into separate channel items
        datasets_ch = Channel.of(params.dataset.split(',\\s*'))
    } else {
        // fetch and parse the YAML config file
        def yaml = new Yaml().load(new URL(params.config).text)
        // extract each dataset name and emit as separate channel items
        datasets_ch = Channel.from(yaml.datasets.collect { it.keySet().first() })
    }

    AGORA_DATA_RUN(params.config, datasets_ch)

}
