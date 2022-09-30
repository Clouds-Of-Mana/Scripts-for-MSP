#Create/Modify Reg Keys
Write-Host -ForegroundColor Green "Modifying Registry"
New-Item "HKCU:\Software\Classes\skype\shell\open\command" -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\skype" -Name '(Default)' -Value 'URL:skype' -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\skype" -Name 'URL Protocol' -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\skype\shell\open\command" -Name '(Default)' -Value '"C:\SkypeToTeams\SkypeToTeams.bat" "%1"' -Force | Out-Null

#Make sure C:\SkypeToTeams folder exists
Write-Host -ForegroundColor Green "Creating Directory C:\SkypeToTeams"
if (!(Test-Path C:\SkypeToTeams)) {New-Item -Type Directory 'C:\SkypeToTeams'}

#Create Bat file
Write-Host -ForegroundColor Green "Creating .bat file"
$BatFile = "@echo off
set origNumber=%1
set number=%origNumber:?call=%
`"$env:USERPROFILE\AppData\Local\Microsoft\Teams\current\Teams.exe`" tel:+1%number%"
$BatFile | Out-file -Encoding "ASCII" C:\SkypeToTeams\SkypeToTeams.bat
