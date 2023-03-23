Function Invoke-EmailVerify {
    <#
    .SYNOPSIS
    o365creeper.ps1 is a powershell version of 0365creeper.py. More information about the python version can be found over here https://github.com/LMGsec/o365creeper 
    
    .DESCRIPTION
    This is a powershell script that helps to validate the email addresses(that belong to o365 tenant) gathered during the recon phase. You can either provide email address or exact path including filename. 
    The validation of email address is based on the parameter "IfExistsResult" value. If the value is 1, it means the email is invalid and 0 means valid.

    .PARAMETER Email
    Email address that needs to be validated

    .PARAMETER File
    Path along with file name that contains 1 email per line

    .PARAMETER Output
    Output file name where the result will be stored

    .EXAMPLE
    Invoke-EmailVerify -Email "something@something.com" 
    Description
    -----------
    This command will validate the given email address 

    .EXAMPLE
    Invoke-EmailVerify -File "emails.txt"
    Description
    -----------
    This command will validate the email addresses from the given file

    .EXAMPLE
    Invoke-EmailVerify -File "emails.txt" -Output results.txt
    Description
    -----------
    This command will validate the email addresses from the given file and output the results in results.txt file
    #>

    Param(

        [parameter(Mandatory= $False)]
        [String] $Email,

        [parameter(Mandatory=$False)]
        [String] $File,

        [parameter(Mandatory=$False)]
        [String] $Output
    )

    $url = 'https://login.microsoftonline.com/common/GetCredentialType'

    if ($Email -ne "" -and $File -ne ""){

        Write-Host "Please check usage. You can either provide email address or file name, not both" -ForegroundColor Red 

    } elseif ($Email -ne "" -and $Output -ne "" ) {

        Write-Host "Please check usage. You can either provide email address or file name, not both" -ForegroundColor Red 

    } elseif ($Email -ne "") {
        
        $body = @{'Username'=[string] $Email}
        $vc = Invoke-RestMethod -Method 'POST' -Uri $url -Body ($body|ConvertTo-Json) -ContentType 'application/json' | Select-Object -ExpandProperty "IfExistsResult"

        if ($vc -eq 1) {
            Write-Host "[-]" $Email "is Invalid" -ForegroundColor Red
        }else {
            Write-Host "[+]" $Email "is Valid" -ForegroundColor DarkGreen
        }

    } elseif ($File -ne "" -and $Output -eq ""){

        Foreach ($mail in Get-Content $File)
        {
            $body = @{'Username'=[string] $mail}
            $vc = Invoke-RestMethod -Method 'POST' -Uri $url -Body ($body|ConvertTo-Json) -ContentType 'application/json' | Select-Object -ExpandProperty "IfExistsResult"

            if ($vc -eq 1) {
                Write-Host "[-]" $mail "is Invalid" -ForegroundColor Red 
            } else {
                Write-Host "[+]" $mail "is Valid" -ForegroundColor DarkGreen
            }

        }

    } elseif ($File -ne "" -and $Output -ne ""){

        Foreach ($mail in Get-Content $File)
        {
            $body = @{'Username'=[string] $mail}
            $vc = Invoke-RestMethod -Method 'POST' -Uri $url -Body ($body|ConvertTo-Json) -ContentType 'application/json' | Select-Object -ExpandProperty "IfExistsResult"

            if ($vc -eq 1) {
                
                $data = "$mail is Invalid"
                Add-Content -Path $Output -Value $data
                Write-Host $mail "is Invalid" -ForegroundColor Red
            } else {
                $data = "$mail is Valid"
                Add-Content -Path $Output -Value $data
                Write-Host $mail "is Valid" -ForegroundColor DarkGreen
            }

        }
    } else {
        Write-Host "Please use get-help test -Examples"
    }

}
