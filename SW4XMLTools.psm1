# http://iextendable.com/2018/07/04/powershell-how-to-structure-a-module/

Get-ChildItem *.ps1 -path Export,Private -Recurse | ForEach-Object {
    . $_.FullName
}
    
Get-ChildItem *.ps1 -path Export -Recurse | ForEach-Object {
    Export-ModuleMember $_.BaseName
}