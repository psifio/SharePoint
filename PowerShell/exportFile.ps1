cls

$mydate = Get-Date
write-host "Starting AEIS:" $mydate.ToShortDateString()  $mydate.ToShortTimeString()

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
    #write-host "ID:" $item.ID "ΚωδικόςΑΕΙΣ: " $item["ΚωδικόςΑΕΙΣ"]  "CDI Πελάτη:" $item["CDI Πελάτη"] "ΑΦΜ:" $item["ΑΦΜ"]
    #write-host "Νόμισμα" $item["Νόμισμα"] "Ποσό Παραστατικού" $item["Ποσό Παραστατικού"] "epitropi" $item["epitropi"]
    #write-host "Ημερομηνία Εγκρίσεως ΥΕΤΣ:" $item["Ημερομηνία Εγκρίσεως ΥΕΤΣ"] "Ημερομηνία Απόφασης ΕΕΤΣ:" $item["Ημερομηνία Απόφασης ΕΕΤΣ"]
    #write-host "-------------"
   	#$obj = New-Object PSObject -Property @{
         #"ΚωδικόςΑΕΙΣ"= $item["ΚωδικόςΑΕΙΣ"] 
         #"CDI Πελάτη" = $item["CDI Πελάτη"]
         #"ΑΦΜ"= $item["ΑΦΜ"]
         #"Νόμισμα"= $item["Νόμισμα"]
         #"Ποσό Παραστατικού"= $item["Ποσό Παραστατικού"] 
         #"EE.YY"= $item["epitropi"]						
	#}
	#$exportlist += $obj
    $line=$item["ΚωδικόςΑΕΙΣ"]+$sp+$item["ΑΦΜ"]+$sp+$item["Νόμισμα"]+$sp+$item["Ποσό Παραστατικού"]+$sp+$item["epitropi"]
    #write-host $line  $item["status ΔΠΧΠ"] 
    #write-host $line $item["status ΔΠΧΠ"] $item["EgkrisiYETSDate"] $item["LipsiApofasisEETSDate"] 
    $line | Out-File $filenam -Append
} 
#$exportlist | select * | Export-Csv -Encoding:UTF8 -path 'D:\Safedeposits\pnpdemands\export.csv' -noType
 
$users = "nikolaos.klavdianos@alpha.gr,serafeim.kroustallis@alpha.gr" # List of users to email your report to (separate by comma)
$fromemail = "dms_admin@alpha.gr"
$server = "10.29.23.50" #enter your own SMTP server DNS name / IP address here
$smtpServer = "10.29.23.50"
$att = new-object Net.Mail.Attachment($filenam)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "dms_admin@alpha.gr"
$msg.To.Add("nikolaos.klavdianos@alpha.gr,serafeim.kroustallis@alpha.gr")
$msg.Subject = "PNP Demands Export"
$msg.Body = "Attached is the PNPDemands CSV"
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()

$mydate = Get-Date
write-host "Completed AEIS:" $mydate.ToShortDateString()  $mydate.ToShortTimeString()
