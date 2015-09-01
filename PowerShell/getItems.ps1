cls
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
    Add-PSSnapin Microsoft.SharePoint.PowerShell;
}

$sourceWebURL = "http://sharepointsite"
$sourceListName = "mylist"

$spSourceWeb = Get-SPWeb $sourceWebURL
$spSourceList = $spSourceWeb.Lists[$sourceListName]
#$spSourceItems = $spSourceList.GetItems()
#$spSourceItems = $spSourceList.GetItemById("1")
$spSourceItems = $spSourceList.Items | where {$_['ID'] -eq 1}

$spSourceItems | ForEach-Object {
    Write-Host $_['ID']
    Write-Host $_['Title']
}