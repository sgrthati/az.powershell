# Create Java folder.
Write-Host "creating a directory"
$path = New-Item -ItemType directory -Path C:\ -name "Java" -Force

# Download JDK
write-host "Downloading software" 
$jdk_url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=245805_df5ad55fdd604472a86a45a217032c7d"

$jdk_zip_file = "$path\jdk.exe"

Invoke-WebRequest $jdk_url -OutFile $jdk_zip_file
Write-Host "installing softaware"
Start-Process $jdk_zip_file  /s -Wait
Write-Host " software installation completed"