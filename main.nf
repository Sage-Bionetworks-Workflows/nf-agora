// Ensure DSL2
nextflow.enable.dsl = 2

//runs test config for Agora
process AGORA_DATA_RUN {

    container "ghcr.io/linglp/agora-ag-1092:latest"

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
