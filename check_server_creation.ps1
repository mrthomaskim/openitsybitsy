<#
Author:		Thomas Kim
File Name:	check_server_creation.ps1
Time Stamp:	03:36 PM 08/20/2019

Description:

#>
try {
#    $computers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*") -and (Enabled -eq "True")} `
    $computers = Get-ADComputer -Filter {Enabled -eq "True"} `
                -Properties DistinguishedName, Created, createTimeStamp, LastLogonDate, OperatingSystem, OperatingSystemVersion, DNSHostName, Enabled, PasswordLastSet| Sort Name
}
catch {
    exit 1
}

# Output Log
$dt_stamp = Get-Date -Format 'yyyy-MM-dd_HH_mm_ss'
$logFile = "check_server_creation_" + $dt_stamp + ".csv"

If ((Test-Path -Path $logFile) -eq $false) {
	$logFile = New-Item $logFile -ItemType file -Force
	Add-Content $logFile "dt_stamp,Hostname,DistinguishedName,operating_system,os_version,enabled,created,created_timestamp,last_logondate,pwd_lastset,notes"
}

if ($computers) {
    foreach ($computer in $computers) {
        $hostname          = $null; $hostname          = $computer.DNSHostName
        $dn                = $null; $dn                = $computer.DistinguishedName
        $operating_system  = $null; $operating_system  = $computer.OperatingSystem
        $os_version        = $null; $os_version        = $computer.OperatingSystemVersion
        $enabled           = $null; $enabled           = $computer.Enabled
        $created           = $null; $created           = $computer.Created
        $created_timestamp = $null; $created_timestamp = $computer.createTimeStamp
        $last_logondate    = $null; $last_logondate    = $computer.LastLogonDate
        $pwd_lastset       = $null; $pwd_lastset    = $computer.PasswordLastSet
        
        Add-Content $logFile "$dt_stamp,$hostname,$dn,$operating_system,$os_version,$enabled,$created,$created_timestamp,$last_logondate,$pwd_lastset,"


    }
}