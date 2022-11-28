# Paste in the agent Helm configuration from the Sysdig UI over the top of the 
# commented out lines below. Then add in your API token and leave the other
# lines in order to deploy the admission controller without the legacy vuln
# scanner 

#kubectl create ns sysdig-agent
#helm repo add sysdig https://charts.sysdig.com
#helm repo update
#helm install sysdig-agent --namespace sysdig-agent \
#    --set global.sysdig.accessKey=xxx \
#    --set global.sysdig.region=au1 \
#    --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
#    --set global.kspm.deploy=true \
#    --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=false \
#    --set global.clusterConfig.name=microk8s-cluster \
    --set global.sysdig.secureAPIToken=xxx \
    --set admissionController.enabled=true \
    --set admissionController.scanner.enabled=false \
    sysdig/sysdig-deploy