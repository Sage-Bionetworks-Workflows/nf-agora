// Ensure DSL2
nextflow.enable.dsl = 2

process AGORA_DATA_RUN {

    tag "$dataset"

    container params.container

    secret "SYNAPSE_AUTH_TOKEN"

    //make sure other tasks can finish when one task fails
    errorStrategy 'finish'

    input:
    path(config)
    val dataset

    output:
    val dataset

    script:
    // omit --dataset flag entirely if dataset is empty
    def datasetFlag = dataset ? "--dataset '${dataset}'" : ''
    """
    adt process ${config} --upload --platform NEXTFLOW --run_id ${workflow.runName} ${datasetFlag} --skip-manifest
    """

}


process RELEASE_MANIFEST {
    container params.container

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    path(config)

    script:
        """
        echo "All data processing complete. Upload manifest csv and dataversion.json to Synapse."
        adt release ${config}
        """
}

workflow {

    if (params.dataset) {
        // split comma-separated dataset names (handles optional spaces) into separate channel items
        datasets_ch = Channel.fromList(params.dataset.split(',\\s*').toList().toUnique())
    } else {
        // fetch and parse the YAML config file
        def yaml = new org.yaml.snakeyaml.Yaml().load(new URL(params.config).text)
        // extract each dataset name and emit as separate channel items
        datasets_ch = Channel.fromList(yaml.datasets.collect { it.keySet().first() })
    }

    datasets_ch.view { "Dataset: $it" }

    AGORA_DATA_RUN(params.config, datasets_ch)
    RELEASE_MANIFEST(AGORA_DATA_RUN.out.collect().map { params.config })

}
