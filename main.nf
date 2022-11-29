// Ensure DSL2
nextflow.enable.dsl = 2

//test params
params.config = "test.config.yaml"

//runs test config for Agora
process AGORA_DATA_RUN {

    container "sagebionetworks/agora-data-tools"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    val(config)

    script:
    """
    python ./agoradatatools/process.py ${config}
    """

}

workflow{

    AGORA_DATA_RUN(params.config)

}
