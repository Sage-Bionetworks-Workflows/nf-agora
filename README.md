# nf-agora

## Intro

This repository contains a Nextflow Pipeline that wraps agora-data-tools and therefore the Agora ETL process. It is deployed on Sage's Nextflow Tower Instance, making it simple to trigger and monitor runs. 

## Running the pipeline on Nextflow Tower

### Getting Oriented in Nextflow Tower

1. Navigate to https://tower.sagebionetworks.org/login.
2. Click “Sign in with Google” and enter your Sage credentials.
3. In the top left corner, you should see “Sage-Bionetworks/agora-project”. This indicates that you are in the workspace for Agora in our Nextflow Tower instance.
4. If you are not in the correct workspace, click on the drop-down and select “agora-project”.

### Launching the Pipeline for Testing

1. In the “Launchpad” tab, click on the tile labeled “nf-agora”.
2. At the top, give your Workflow run a name if you want. If you leave it blank, a randomly generated name will be given to it.
3. Under "Config profile", add `test`.
* There is no need to add to "Pipeline parameters", as the `test` profile provides the path to `test_config.yaml` to the pipeline by default
4. In the bottom right corner, click "Launch"

### Launching the ETL Pipeline

1. In the “Launchpad” tab, click on the tile labeled “nf-agora”.
2. At the top, give your Workflow run a name if you want. If you leave it blank, a randomly generated name will be given to it.
3. Under "Pipeline parameters", paste the following text: 
   `config: "https://raw.githubusercontent.com/Sage-Bionetworks/agora-data-tools/dev/config.yaml"`
4. In the bottom right corner, click "Launch"

### Monitoring your Run

1. Switch to the "Runs" tab near the top of the page. You should see your new run pop up in orange as it is being submitted. When it has been submitted and starts to run, it will turn blue. This may take a few minutes.
2. If the job succeeds it will turn green and if it fails it will turn red.
3. In the event of a failed job, contact DPE and we will look into the issue further.
