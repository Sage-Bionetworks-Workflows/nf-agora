// Ensure DSL2
nextflow.enable.dsl = 2

//runs test config for Agora
process AGORA_DATA_RUN {


    container "sagebionetworks/agora-data-tools"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    path(config)

    script:
    """
    python /agora-data-tools/agoradatatools/process.py ${config}
    """

}



workflow{

    AGORA_DATA_RUN(params.config)

}
