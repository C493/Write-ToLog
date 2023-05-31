# Write-ToLog
[![PowerShell](https://img.shields.io/badge/Code-PowerShell-blue?&style=flat-square&logo=powershell)](https://learn.microsoft.com/en-us/powershell/)

A PowerShell function for writing specified messages to a log file.

---

## DESCRIPTION

Add this function to your script for easy, consitent writes to a log file.  
Writes a specified message to a log file, creating the log file if it does not already exist.  
Log entries are date and time stamped using ISO 8601 date format (e.g. 2022-09-02 19:22:00)  
Logging is enabled by default unless $script:LoggingEnabled variable is present and set to zero.  
If the log file cannot be created, logging will be disabled for the session.

### NOTES

**Author**  :   Patrick Cage (patrick@patrickcage.com)  
**Version** :   1.0.4 (2023-04-16)  
**License** :   GNU General Public License (GPL) v3  
    
### PARAMETER Message

\<string> [Required] The message to be written to the log file
    
### PARAMETER Severity

\<string> [Optional] The severity of the message being written

**Valid values:** DEBUG, INFO, WARNING, ERROR
    
### PARAMETER Tag

\<string> [Optional] The Tag to be added to the logged message
    
### PARAMETER LogFile

\<System.IO.FileInfo> [Optional] The full path of the log file to be written to

If not specified when calling the function, or in the calling script, a file will be created within a LOGS folder inside the scripts parent folder.  
If the scripts parent folder path can't be obtained, it will fall back to C:\LOGS
    
### EXAMPLE

```powershell
Write-ToLog "This message will be written to the log file"
```

    2022-09-02 19:22:00 : This message will be written to the log file 

### EXAMPLE

```powershell
Write-ToLog -Message "This message will be written to the log file" -LogFile "C:\Path\To\LogFile.txt"
```

    2022-09-02 19:22:00 : This message will be written to the log file

### EXAMPLE

```powershell
Write-ToLog -Message "This message will be written to the log file" -Severity INFO -Tag "TagValue"
```

    2022-09-02 19:22:00 : INFO: [TagValue] This message will be written to the log file
    
### EXAMPLE

```powershell
Write-ToLog -Message "This message will be written to the log file" -Tag "TagValue"
```

    2022-09-02 19:22:00 : [TagValue] This message will be written to the log file

### LINKS

**Website** : https://www.patrickcage.com/write-tolog  

---

If this has helped you, please consider [buying me a coffee](https://www.buymeacoffee.com/patrickcage)