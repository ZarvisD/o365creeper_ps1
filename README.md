# o365creeper_ps1

### Description
This tool is the powershell version of o365creeper.py, which is used to validate the email address against the Office 365 tenants. The more information about the python version can be found at https://github.com/LMGsec/o365creeper.


### Examples

```
Import-Module o365creeper.ps1 
Description
-----------
This command will import the module
```

```
Invoke-EmailVerify -Email "something@something.com" 
Description
-----------
This command will validate the given email address 
```
```
Invoke-EmailVerify -File "emails.txt"
Description
-----------
This command will validate the email addresses from the given file
```
```
Invoke-EmailVerify -File "emails.txt" -Output results.txt
Description
-----------
This command will validate the email addresses from the given file and output the results in results.txt file
```

### Working
The working of this tool is based on the URL 'https://login.microsoftonline.com/common/GetCredentialType' which returns a parameter **IfExistsResult** in response with value 1 for incorrect email address and value 0 for correct email address

