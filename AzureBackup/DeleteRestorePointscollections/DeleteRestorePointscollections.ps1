workflow Delete-RestorePointsCollections
{
    param([string[]]$Rgname)
    $resources = Get-AzureRmResource -ResourceGroupName "$Rgname"
    foreach -Parallel ($resource in $resources) 
    {
        $retry = $true
        while ($retry)
        {
            Try
            {
                Write-Output "Removing $($resource.Name)"
                $removeOps= Remove-AzureRmResource -ResourceId $resource.ResourceId -Force 
                if ($removeOps) {$retry = $false}
            }
            Catch
            {
                $retry = $true
            } 
            Finally 
            {
                if ($retry) 
                {
                    write-output "Failed to delete $($resource.Name) --> Retrying"
                } 
                else 
                {
                    write-output "Deletion of  $($resource.Name) successfull"
                }
            }
        }
    }
}

#Parameters
    $SubcriptionName = "Subscription Name"
    $ResourceGroupname = "Resource group Name"
 #Run the workflow
    Login-AzureRmAccount
    Select-AzureRmSubscription -Subscription $SubcriptionName
    Delete-RestorePointsCollections -Rgname $ResourceGroupname
