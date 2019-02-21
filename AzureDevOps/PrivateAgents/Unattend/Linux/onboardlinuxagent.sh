#$1 must be the PAT Token
#$2 must be $(pwd)
cd $2
#Install jq for json parsing
sudo apt  install jq -y
#path of the parameter file
jsoninput=$(pwd)/onboardlinuxagent.json
#create installation directory
sudo mkdir $(pwd)/myagent
sudo chmod -R o+w $(pwd)/myagent
cd $(pwd)/myagent
#Download and install the agent
sudo wget "$(jq -r .agentdownloadurl $jsoninput)"
sudo tar zxvf *.tar.gz
cd ..
sudo chmod -R o+w $(pwd)/myagent
cd $(pwd)/myagent
./config.sh --unattended --url "$(jq -r .OrganizationUrl $jsoninput)"  --auth "$(jq -r .AuthenticationType $jsoninput)"  --token $1 --pool "$(jq -r .AgentPool $jsoninput)" --agent $(hostname) --runAsService
sudo ./svc.sh install 
sudo ./svc.sh start 
sudo ./svc.sh status