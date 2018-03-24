$PreferredSSID = 'zeppelin_2.4G' # otherwise change this to '$PreferredSSID = 'Your-SSID''

function Get-WifiNetwork {
 end {
  netsh wlan show networks mode=bssid | % -process {
    if ($_ -match '^SSID (\d+) : (.*)$') {
        $current = @{}
        $networks += $current
        $current.Index = $matches[1].trim()
        $current.SSID = $matches[2].trim()
    } else {
        if ($_ -match '^\s+(.*)\s+:\s+(.*)\s*$') {
            $current[$matches[1].trim()] = $matches[2].trim()
            $current.Signal = [int]($current.Signal -replace '%')
        }
    }
  } -begin { $networks = @() } -end { $networks|% { new-object psobject -property $_ } }
 }
}

Function AutoConnect ($PreferredSSID){

    # WiFi auto-connect
    if($PreferredSSID -ne $null){
        if(Get-NetAdapter | where {($_.Name -like "*wi-fi*" -or $_.Name -like "*wifi*") -and ($_.Status -eq "Disconnected")}){
            netsh wlan connect name=$PreferredSSID
            Start-Sleep -Seconds 2
            netsh wlan set profileparameter name=$PreferredSSID connectionmode=auto
        }

    } else {

    $wlanprofile = @()
    $wlanprofiles = @()
    $wlanprofileNames = @()
    $visiblenetworks = @()
    # get known profiles
    $wlanprofiles = (netsh wlan show profiles)
    $wlanprofileNames = $wlanprofiles | Select-String -Pattern "(?<=: ).+" | % { $_.Matches[0].Value }
    # get visible networks and sort by strength
    $visiblenetworks = Get-WifiNetwork | select index, ssid, signal, 'radio type' | sort signal -Descending
    # match visible networks with known profiles
    $ApprovedNetworks = Compare-Object -ReferenceObject $wlanprofileNames -DifferenceObject $visiblenetworks.ssid -IncludeEqual | where {$_.SideIndicator -eq "=="}
    # connect to the strongest known network
    if(Get-NetAdapter | where {($_.Name -like "*wi-fi*" -or $_.Name -like "*wifi*") -and ($_.Status -eq "Disconnected")}){
        netsh wlan connect name=($ApprovedNetworks[0]).InputObject
        Start-Sleep -Seconds 2
        netsh wlan set profileparameter name=($ApprovedNetworks[0]).InputObject connectionmode=auto
    }
    }

    # LTE auto-connect for devices that have SIM cards
    while ((Get-NetAdapter | where {$_.Name -like "*mobile*"}).Status -eq "Disconnected")
    {
    Start-Sleep -Seconds 1
    $mbnprofile = @()
    $mbnprofiles = @()
    $mbnprofiles = (netsh mbn show profiles) -join "" -replace ".*Profiles.*-    ",""
    ForEach($mbnprofile in $mbnprofiles){
    netsh mbn connect interface="Mobile Broadband" connmode=name name=$mbnprofile
    }
    }

}

AutoConnect $PreferredSSID

## Adding a pause for 5 minutes in case the wireless router is restarting 
Start-Sleep -Seconds 10

AutoConnect $PreferredSSID