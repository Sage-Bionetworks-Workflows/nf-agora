// Ensure DSL2
nextflow.enable.dsl = 2

process AGORA_DATA_RUN {

    tag "$dataset"

    container "ghcr.io/sage-bionetworks/agora-data-tools:latest"

    secret "SYNAPSE_AUTH_TOKEN"

    // allocate more memory for known large datasets
    memory {
        def largeDatasets = params.large_memory_datasets ? params.large_memory_datasets.split(',') : []
        def mem = largeDatasets.contains(dataset) ? params.large_memory_gb.GB * task.attempt : params.default_memory_gb.GB * task.attempt
        mem
    }


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



workflow.onComplete {
    def msg = """\
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """.stripIndent()

    sendMail(to: params.email, subject: "nf-agora run ${workflow.runName}", body: msg)
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

}
