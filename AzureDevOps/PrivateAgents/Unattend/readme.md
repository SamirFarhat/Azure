# Automated Azure DevOps agents installation
  
This document shows how to deploy automatically Azure Devops private agents using scripts
  
## Getting Started
  
These instructions will get you to: 

- Prepare the environment
- Prerequisites to deploy private agents
- How to Update the parameter files
 
### Prerequisites

- You need to generate a PAT token from Azure DevOps. Please see here: <https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops#authenticate-with-a-personal-access-token-pat>  
  
- You need to access the private agent operating system in order to run the script

- The Machine where you are installing the agent must have outbound access to Azure DevOps endpoints

### Deployment

#### Parameter file

The parameter file name is onboardwindowsagent.json. Each operating system (Windows or Linux) have its own parameter file, but they are similar.
The following shows the details/content of each parameter within the parameter file

```json
{
    "OrganizationUrl":"https://dev.azure.com/cloudcaseorg", //The Azure DevOps Organization URL
    "AuthenticationType":"PAT", // The Authentication type, must be set to PAT
    "PersonalAccessToken":"", // The PAT value (Not used)
    "AgentPool":"Custom Windows 2016", // The Agent Pool name where the agent will be registered
    "WorkFolder":"c:\\devopswork", // The workfolder where the agent will download artifacts (only for Windows)...
    "UserAccount":"NT Authority\\System", // The user account under which the agent will run, the recommended value is NT Authority\\System for Windows (only for Windows)
    "agentdownloadurl":"https://vstsagentpackage.azureedge.net/agent/2.146.0/vsts-agent-win-x64-2.146.0.zip" // The agent download URL, see <https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops> or <https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops> to see how to get it
    }
```

#### Run the script

##### Windows

-Open a powershell window as Administrator and browse the directory where the script is located (onboardwindowsagent.json and onboardwindowsagent.ps1)

-Type the following command

```powershell
.\onboardwindowsagent.ps1 -paramfilename onboardwindowsagent.json -PAT "gshsgjhsghsjsghsjshsq" -Force $false -installroot "c:"
```

where:

- paramfilename: The parameter file name (optional, default = onboardwindowsagent.json)
- PAT: The PAT that you have generated (mandatory)
- Force: Force re-installing the agent is it does already exist (optional, default = $false)
- installroot: The installation directory. Do not add '\' at the end of teh path (optional, default = c:)



##### Linux Ubuntu

-Open a shel session and browse the directory where the script is located (onboardwindowsagent.json and onboardwindowsagent.sh)

-Type the following command

```bash
sh onboardlinuxagent.sh patpatpatpat $(pwd)
```

where:

- patpatpatpat: The PAT that you have generated (mandatory)