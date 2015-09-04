cls

$mydate = Get-Date
write-host "Starting:" $mydate.ToShortDateString()  $mydate.ToShortTimeString()

Add-PSSnapin Microsoft.Sharepoint.Powershell
$splList =(Get-Spweb "http://myserver/sysite/").GetList("http://myserver/sysite/list")

$spqQuery = New-Object Microsoft.SharePoint.SPQuery 
$spqQuery.Query = @"
<Where>
    <And>
       <And> 
            <And>
                <Eq>
                    <FieldRef Name='Title'/>
                    <Value Type='Text'>BBBBBB </Value>
                </Eq>
                <Neq>
                    <FieldRef Name='myField'/>
                    <Value Type='Text'>NA</Value>
                </Neq>
            </And>
            <Contains>
                <FieldRef Name="status_x0020" />
                <Value Type='Text'>AAAAAA</Value>
            </Contains>
       </And>
       <Or>
            <Eq>
                <FieldRef Name='aDate' />
                <Value Type='DateTime'><Today /></Value>
            </Eq>
            <Eq>
                <FieldRef Name='bDate' />
                <Value Type='DateTime'><Today /></Value>
            </Eq>
       </Or>     
    </And>
</Where>
<OrderBy>
    <FieldRef Name='FieldToSort' />
</OrderBy>
"@
$spqQuery.ViewAttributes = "Scope='RecursiveAll'"
$splListItems = $splList.GetItems($spqQuery) 
#echo $splListItems
#$exportlist = @()
$sp=";"
$a = Get-Date
$filenam="export_"+$a.Year + "_" + $a.Month+"_"+$a.Day +"__"+$a.Hour+"."+$a.Minute+"."+$a.Second+".csv"
$filenam="Path\"+$filenam
New-Item $filenam -type file
#$stringBuilder = New-Object System.Text.StringBuilder
foreach ($item in $splListItems)
{
    #write-host "ID:" $item.ID "ccc: " $item["ccc"] 
    #write-host "-------------"
   	#$obj = New-Object PSObject -Property @{
         #"ccc"= $item["ccc"] 
	#}
	#$exportlist += $obj
    $line=$item["cc"]+$sp+$item["bb"]
    $line | Out-File $filenam -Append
} 
#$exportlist | select * | Export-Csv -Encoding:UTF8 -path $filenam -noType
 
$users = "c@e.com,a@b" # List of users to email your report to (separate by comma)
$fromemail = "admin@domain.gr"
$server = "9999.9999" #enter your own SMTP server DNS name / IP address here
$smtpServer = "99.2222"
$att = new-object Net.Mail.Attachment($filenam)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "from@domain.gr"
$msg.To.Add("a@k,c@k")
$msg.Subject = "Subject"
$msg.Body = "Attached is the  CSV"
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()

$mydate = Get-Date
write-host "Completed:" $mydate.ToShortDateString()  $mydate.ToShortTimeString()
