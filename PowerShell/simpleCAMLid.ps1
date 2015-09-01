Add-PSSnapin Microsoft.SharePoint.Powershell
$QueryObject = New-Object Microsoft.SharePoint.SPQuery
$QueryObject.Query = '
<Lists>
   <List ID="{00000000-0000-0000-0000-000000000000}" />
</Lists>
<ViewFields>
   <FieldRef Name="Title" />
</ViewFields>
<Where>
   <Gt>
     <FieldRef Name="ID"  />
     <Value Type="Counter">1</Value>
   </Gt>
</Where>
'
$($(Get-SPWeb http://contoso.com).Lists[[Guid]'{00000000-0000-0000-0000-000000000000}']).GetItems($QueryObject)