# One line script to return current IPv4 addresses on a Windows host
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'} | ForEach-Object IPAddress