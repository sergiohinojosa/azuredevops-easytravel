@Library('keptn-library')_
def keptn = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'performance', description: 'Name of your Keptn Project for Performance as a Self-Service', name: 'Project', trim: false), 
         string(defaultValue: 'integration', description: 'Stage in your Keptn project used for Performance Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'evalservice', description: 'Servicename used to keep SLIs, SLOs, test files ...', name: 'Service', trim: false),
         choice(choices: ['performance', 'performance_10', 'performance_50', 'performance_100', 'performance_long'], description: 'Test Strategy aka Workload, e.g: performance, performance_10, performance_50, performance_100, performance_long', name: 'TestStrategy', trim: false),
         string(defaultValue: 'http://easytravel.demo.dynatrace.com', description: 'URI of the EasyTravel Application you want to run a test against', name: 'DeploymentURI', trim: false),
         string(defaultValue: '60', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ])
    ])

    stage('Initialize Keptn') {
        // keptn.downloadFile('https://raw.githubusercontent.com/keptn-sandbox/performance-testing-as-selfservice-tutorial/master/shipyard.yaml', 'keptn/shipyard.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/dynatrace.conf.yaml", 'keptn/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/slo.yaml", 'keptn/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/sli.yaml", 'keptn/sli.yaml')
        keptn.downloadFile('https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/jmeter/easytravel-classic-random-book.jmx', 'keptn/jmeter/easytravel-classic-random-book.jmx')
        keptn.downloadFile('https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/jmeter/easytravel-users.txt', 'keptn/jmeter/easytravel-users.txt')
        keptn.downloadFile('https://raw.githubusercontent.com/sergiohinojosa/easytravel-sre/master/keptn/jmeter/jmeter.conf.yaml', 'keptn/jmeter/jmeter.conf.yaml')
        archiveArtifacts artifacts:'keptn/**/*.*'

        // Initialize the Keptn Project
        keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", monitoring:"dynatrace" // , shipyard:'shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
        keptn.keptnAddResources('keptn/jmeter/easytravel-classic-random-book.jmx','jmeter/easytravel-classic-random-book.jmx')
        keptn.keptnAddResources('keptn/jmeter/easytravel-users.txt','jmeter/easytravel-users.txt')
        keptn.keptnAddResources('keptn/jmeter/jmeter.conf.yaml','jmeter/jmeter.conf.yaml')
    }

    stage('Trigger Performance Test') {
        echo "Performance as a Self-Service: Triggering Keptn to execute Tests against ${params.DeploymentURI}"

        // send deployment finished to trigger tests
        def keptnContext = keptn.sendDeploymentFinishedEvent testStrategy:"${params.TestStrategy}", deploymentURI:"${params.DeploymentURI}" 
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
    }


    stage('Wait for Result') {
        waitTime = 0
        if(params.WaitForResult?.isInteger()) {
            waitTime = params.WaitForResult.toInteger()
        }

        if(waitTime > 0) {
            echo "Waiting until Keptn is done and returns the results"
            def result = keptn.waitForEvaluationDoneEvent setBuildResult:true, waitTime:waitTime
            echo "${result}"
        } else {
            echo "Not waiting for results. Please check the Keptns bridge for the details!"
        }

        // Generating the Report so you can access the results directly in Keptns Bridge
        publishHTML(
            target: [
                allowMissing         : false,
                alwaysLinkToLastBuild: false,
                keepAll              : true,
                reportDir            : ".",
                reportFiles          : 'keptn.html',
                reportName           : "Keptn Result in Bridge"
            ]
        )
    }
}