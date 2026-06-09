// Ensure DSL2
nextflow.enable.dsl = 2

//runs test config for Agora
process AGORA_DATA_RUN {

    container "ghcr.io/sage-bionetworks/agora-data-tools:latest"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    path(config)
    val dataset

    script:
    def datasetFlag = dataset ? "--dataset '${dataset}'" : ''
    """
    adt ${config} --upload --platform NEXTFLOW --run_id ${workflow.runName} ${datasetFlag}
    """

}



workflow{

    AGORA_DATA_RUN(params.config, params.dataset)

}
