// Ensure DSL2
nextflow.enable.dsl = 2

//runs test config for Agora
process AGORA_DATA_RUN {


    container "ghcr.io/sage-bionetworks/agora-data-tools:latest"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    path(config)

    script:
    """
    adt ${config} --upload --platform NEXTFLOW
    """

}



workflow{

    AGORA_DATA_RUN(params.config)

}
