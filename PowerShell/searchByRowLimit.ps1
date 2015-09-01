#We are running the query to search for a Text string “Attachment.pdf” in a TEXT Field of the List.
#See that I bring 20 rows each time
if((Get-PSSnapin | Where {$_.Name -eq &quot;Microsoft.SharePoint.PowerShell&quot;}) -eq $null)
{
 Add-PSSnapin Microsoft.SharePoint.PowerShell;
}&lt;/pre&gt;
$WebUrl = &quot;http://YourSide/sites/SiteCollectionName&quot;
 
#Get the Web &amp; Lists to upload the file
$web = Get-SPWeb $WebURL
 
# $WebUrl=$site.OpenWeb()
$list = $web.Lists[&quot;Your_BigListName&quot;]
 
$spQuery = New-Object Microsoft.SharePoint.SPQuery
$spQuery.ViewAttributes = &quot;Scope='Recursive'&quot;;
$spQuery.RowLimit = 20
 
$Ref = &quot;My Attachment.pdf&quot;
 
$sQry = '&lt;Where&gt;&lt;Contains&gt;&lt;FieldRef Name=&quot;Body&quot;/&gt;&lt;Value Type=&quot;Note&quot;&gt;' + $Ref + '&lt;/Value&gt;&lt;/Contains&gt;&lt;/Where&gt;'
 
$caml = $sQry
 
$spQuery.Query = $caml
 
do
{
$listItems = $list.GetItems($spQuery)
$spQuery.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
foreach($item in $listItems)
{
Write-Host $item.ID &quot;-&quot; $item.Title &quot;-&quot; $item.body
Echo &quot;&quot;
}
}
while ($spQuery.ListItemCollectionPosition -ne $null)
 
$Web.dispose