Function Read-XmlSchema {

    <#
        Based on a Code Sample from # http://blogsprajeesh.blogspot.com/2015/06/powershell-xml-Schema-validation.html 
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path $_})]
        [String]
        $SchemaPath
    )

    process {

        try {
            $SchemaItem = Get-Item $SchemaPath
            $Stream= $SchemaItem.OpenRead()
            $Schema = [Xml.Schema.XmlSchema]::Read($Stream, $null)
            $Schema
        }
        catch {     
            throw
        }
        finally {

            If ($Stream) {
                $Stream.Close()
            }
            
        }

    }

}