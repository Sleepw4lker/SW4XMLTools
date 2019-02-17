Function Get-XmlConfig {

    param (
        [Parameter(Mandatory=$True)]
        [ValidateScript({Test-Path $_})]
        [String]
        $Path,

        [Parameter(Mandatory=$False)]
        [ValidateScript({Test-Path $_})]
        [String]
        $SchemaPath
    )

    process {

        Write-Verbose "Loading Configuration File $Path"

        If (-not ($SchemaPath)) {

            Try {
                # Trying to extract the Schema Path from the XML File
                $Namespace = @{xsi='http://www.w3.org/2001/XMLSchema-instance'}
                $locationAttr = Select-Xml -Path $Path -Namespace $Namespace -XPath */@xsi:noNamespaceSchemaLocation
                $a = $($locationAttr.Node."#text")
                If ($a) {
                    
                    $b = "$((Get-Item $Path).Directory.FullName)\$a"
                    $c = "$($Script:BaseDirectory)\conf\$a"
                    If (Test-Path $b) {
                        $SchemaPath = $b
                        Write-Verbose "Found inline Schema File $SchemaPath"
                    }
                    ElseIf (Test-Path $c) {
                        # Fallback to conf Directory
                        $SchemaPath = $c
                        Write-Verbose "Found inline Schema File $SchemaPath"
                    }
                    
                }
            }
            Catch {
                # Nothing
            }
            Finally {
                # Nothing
            }

        }

        # Use a Schema if explicitly given or found inline
        If ($SchemaPath) {

            If (Test-XmlSchema2 -Path $Path -SchemaPath $SchemaPath) {
                [XML]$Config = Get-Content $Path
            }
            Else {
                # Whadda we goinna do?
                Write-Verbose "Schema Validation failed!"
                return

            }

        }
        Else {
       
            # Decided to make the function fail instead of loading without a Schema, too dangerous!
            Write-Verbose "No XML Schema File found."
            #[XML]$Config = Get-Content $Path
            return

        }

        $Config

    }

}