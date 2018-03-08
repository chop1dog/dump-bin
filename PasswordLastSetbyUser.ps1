$bccgADuser = get-aduser -Filter * -Properties * | select Name,passwordlastset | Sort-Object passwordlastset
$bccgADuser