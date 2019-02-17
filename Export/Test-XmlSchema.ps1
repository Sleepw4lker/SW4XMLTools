Function Test-XmlSchema {

    <#
        Based on a Code Sample from # http://blogsprajeesh.blogspot.com/2015/06/powershell-xml-Schema-validation.html 
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path $_})]
        [String]
        $Path,
       
        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path $_})]
        [String]
        $SchemaPath
    )

    process {

        Write-Verbose "Validating $Path against $SchemaPath"

        $Schemas = New-Object System.Xml.Schema.XmlSchemaSet
        $Schemas.CompilationSettings.EnableUpaCheck = $False
        $Schema = Read-XmlSchema $SchemaPath
        [void]($Schemas.Add($Schema))
        $Schemas.Compile()
        
        try {

            [xml]$xmlData = Get-Content $Path
            $xmlData.Schemas = $Schemas

            # Validate the Schema. This will fail if is invalid Schema
            $xmlData.Validate($null)
            Write-Verbose "Schema Validation Successful!"
            $True

        }
        catch [System.Xml.Schema.XmlSchemaValidationException] {

            $False

        }

    }

}