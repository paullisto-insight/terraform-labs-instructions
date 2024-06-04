# Run this in the terminal before attempting to use Terraform
$env:Path += ";C:\Temp\terraform;C:\Temp\az\bin"
Set-Location -Path 'C:\Temp\az\bin'
Start-Process -FilePath 'az' -ArgumentList "login" -NoNewWindow -PassThru -Wait
Set-Location -Path 'C:\Temp\terraform'
$labpath = Read-Host -Prompt "Enter the full path to your Lab folder"
if(Test-Path $Labpath){
    Set-Location -Path $labpath
    Start-Process -FilePath 'terraform' -ArgumentList 'init' -NoNewWindow -PassThru -Wait
}
else {
    Write-Debug -Message 'Invalid path selected for Lab' -Verbose
}