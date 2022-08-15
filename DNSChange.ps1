#Author - Cengiz YILMAZ
#Company- FixCloud Teknoloji AS

$dnsservers = "8.8.8.8","4.2.2.2"
$computers = Get-Content C:\abc\servers.txt
foreach ($computer in $computers)
{
        $adapters = gwmi -q "select * from win32_networkadapterconfiguration where ipenabled='true'" -ComputerName $computer
        foreach ($adapter in $adapters)
        {
                $adapter.setDNSServerSearchOrder($dnsservers)
        }
         
}


$computer = Get-Content "C:\abc\server.txt"
Foreach($computer in $computer){
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |where{$_.IPEnabled -eq “TRUE”}
}
 Foreach($NIC in $NICs) {
$DNSServers = "8.8.8.8","4.2.2.2" # set dns servers here
 $NIC.SetDNSServerSearchOrder($DNSServers)
 $NIC.SetDynamicDNSRegistration(“TRUE”)
}

*************************************************************************


$servers_list_file = Read-Host -prompt "C:\temp\server.txt"
$dns_servers = Read-Host -prompt "8.8.8.8","4.2.2.2"
$servers = get-content $servers_list_file
foreach ($server in $servers){
invoke-command $server -ScriptBlock{
get-netIPaddress | Where {$_.PrefixOrigin -eq "Manual"} | Select -ExpandProperty InterfaceAlias | foreach {set-dnsclientserveraddress -InterfaceAlias $_ -ServerAddresses $using:dns_servers}
}
}