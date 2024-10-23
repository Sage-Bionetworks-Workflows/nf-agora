// Ensure DSL2
nextflow.enable.dsl = 2

//runs test config for Agora
process AGORA_DATA_RUN {

    container "bwmac2/agora-data-tools:AG-1557"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    path(config)

    script:
    """
    adt ${config} --upload --platform NEXTFLOW --run_id ${workflow.runName}
    """

}



workflow{

    AGORA_DATA_RUN(params.config)

}
