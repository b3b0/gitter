$commitMessage = $args[0]
$server = $args[1]
$serverUser = $args[2]
$destinationFolder = $args[3]
git.exe add .
git.exe commit -m $commitMessage
git.exe push
$currentFolder = Split-Path -Leaf $PWD.Path
$date = Get-Date -Format "yyyy-MM-dd-HH-mm"
$sourcePath = (Resolve-Path "../latest").Path
$destinationPath = "/var/www/html/$currentFolder-$date"
$zipFileName = "$currentFolder-$date.zip"
$zipFilePath = Join-Path (Split-Path $PWD.Path -Parent) $zipFileName
Compress-Archive -Path $sourcePath -DestinationPath $zipFilePath -Force
$remotePath = "$server:/var/www/html/$zipFileName"
scp.exe $zipFilePath $serverUser@$remotePath
Invoke-Expression "ssh $serverUser@$server 'unzip -o -q $destinationFolder/$zipFileName -d $destinationPath'" #-SessionId $thing
