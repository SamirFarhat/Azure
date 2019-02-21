param([Parameter(Position=0,mandatory=$false)][string]$paramfilename="onboardwindowsagent.json",
[Parameter(Position=1,mandatory=$True)][string]$PAT,
[Parameter(Position=1,mandatory=$false)][bool]$Force=$false,
[Parameter(Position=2,mandatory=$false)][string]$installroot="c:")


$serviceexist = Get-Service | where {($_.Name).StartsWith("vstsagent.")}
if ($serviceexist-and $Force) {Write-Output "The Agent is already installed, re-installing"}
if ($serviceexist -and $Force -or -not$serviceexist) {


Write-Output "Intalling and configuring the Azure DevOps Agent..."
#Loading the parameter file
$Paramfile = Get-Content $pwd\$paramfilename | ConvertFrom-Json
if ($Force)
{
& $installroot"\devopsagentinstallfolder\agent\config.cmd" remove --auth $Paramfile.AuthenticationType --token $Paramfile.PersonalAccessToken

if (Get-Item -Path $Paramfile.WorkFolder -ErrorAction SilentlyContinue) {Remove-Item -Path $Paramfile.WorkFolder -force -confirm:$false -Recurse}
New-Item -ItemType Directory -Path $Paramfile.WorkFolder -Force


if (Get-Item -Path $installroot\devopsagentinstallfolder -ErrorAction SilentlyContinue){Remove-Item -Path $installroot\devopsagentinstallfolder -force -confirm:$false -Recurse}
New-Item -ItemType Directory -Path $installroot\devopsagentinstallfolder -Force


#Download the Agent
Invoke-WebRequest -Uri $paramfile.agentdownloadurl -OutFile $installroot\devopsagentinstallfolder\devopsagent.zip

#Unpacking the agent
New-Item -ItemType Directory -Path $installroot\devopsagentinstallfolder\agent
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$installroot\devopsagentinstallfolder\devopsagent.zip", "$installroot\devopsagentinstallfolder\agent")


#Install and configure the Agent
& $installroot"\devopsagentinstallfolder\agent\config.cmd" --unattended --url $Paramfile.OrganizationUrl  --auth $Paramfile.AuthenticationType --token $Paramfile.PersonalAccessToken --pool $Paramfile.AgentPool --agent $env:computername --runAsService --windowsLogonAccount $Paramfile.UserAccount  --work $Paramfile.WorkFolder
} 

elseif (-not$serviceexist)
{
if (Get-Item -Path $Paramfile.WorkFolder -ErrorAction SilentlyContinue) {Remove-Item -Path $Paramfile.WorkFolder -force -confirm:$false -Recurse}
New-Item -ItemType Directory -Path $Paramfile.WorkFolder -Force


if (Get-Item -Path $installroot\devopsagentinstallfolder -ErrorAction SilentlyContinue){Remove-Item -Path $installroot\devopsagentinstallfolder -force -confirm:$false -Recurse}
New-Item -ItemType Directory -Path $installroot\devopsagentinstallfolder -Force


#Download the Agent
Invoke-WebRequest -Uri $paramfile.agentdownloadurl -OutFile $installroot\devopsagentinstallfolder\devopsagent.zip

#Unpacking the agent
New-Item -ItemType Directory -Path $installroot\devopsagentinstallfolder\agent
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$installroot\devopsagentinstallfolder\devopsagent.zip", "$installroot\devopsagentinstallfolder\agent")


#Install and configure the Agent
& $installroot"\devopsagentinstallfolder\agent\config.cmd" --unattended --url $Paramfile.OrganizationUrl  --auth $Paramfile.AuthenticationType --token $PAT --pool $Paramfile.AgentPool --agent $env:computername --runAsService --windowsLogonAccount $Paramfile.UserAccount  --work $Paramfile.WorkFolder
}
}

else {Write-Output "The Agent is already installed, use -Force $true to remove and re-install the agent"}

