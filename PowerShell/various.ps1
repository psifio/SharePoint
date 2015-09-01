# below are some SP scripts that do some basic tricks

function GetDocInfo
{
     #//this checks existence of a file in a specified SPList

  Param ( [parameter(Mandatory=$true)][string]$LibName, 
          [parameter(Mandatory=$true)][string]$DocName 
         )

   $web = Get-SPWeb http://yourSPserver
   $docLibrary = $web.Lists[$LibName]
   $folder = $docLibrary.RootFolder  
   $spFilePath = ("/" + $DocName)
   $spFullPath = $folder.Url + $spFilePath
   write-host $spFullPath "exists: " $web.GetFile($spFullPath).Exists   
}

function GetListFields
{
   #// This returns all the Fields of a given SPList
   #// Also shows how to loop through a collection with 'ForEach'
    Param (  
            [parameter(Mandatory=$true)][string]$ListName 
          )
    
    $ctx = Get-SPServiceContext http://yourSPserver
    $Scope = New-Object Microsoft.SharePoint.SPServiceContextScope $ctx
    $web = Get-SPWeb http://yourSPserver
    $splist = $web.Lists[$ListName]
    $Column = $splist.Fields
	
    foreach($Field in $Column)
	{
	   Write-Host "Field:" $Field
	}
}

function QueryList
{
  #//This queries the "Title" field of a given value in a given SPList
     Param (  
            [parameter(Mandatory=$true)][string]$Title, 
            [parameter(Mandatory=$true)][string]$ListName 
           )

    $web = Get-SPWeb http://yourSPserver
    $splist = $web.Lists[$ListName]
    $spQuery = New-Object Microsoft.SharePoint.SPQuery
    $camlQuery = '$Title'
    $spQuery.Query = $camlQuery
    $spQuery.RowLimit = 10
    $spListItems = $spList.GetItems($spQuery)

    foreach ($item in $spListItems)
    {
      write-host "Name:" $item.Name
      write-host "Title:" $item["Title"]
    } 
}
