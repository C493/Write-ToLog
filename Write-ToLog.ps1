Function Write-ToLog {
    <#
    .SYNOPSIS
        A PowerShell function for writing specified messages to a log file.
    
    .DESCRIPTION
        Add this function to your script for easy, consitent writes to a log file.
        Writes a specified message to a log file, creating the log file if it does not already exist.
        Log entries are date and time stamped using ISO 8601 date format (e.g. 2022-09-02 19:22:00)
        Logging is enabled by default unless $script:LoggingEnabled variable is present and set to zero.
        If the log file cannot be created, logging will be disabled for the session.

    .NOTES
        Author  :   Patrick Cage (patrick@patrickcage.com)
        Version :   1.0.4 (2023-04-16)
        License :   GNU General Public License (GPL) v3
    
    .PARAMETER Message
        <string> [Required] The message to be written to the log file
    
    .PARAMETER Severity
        <string> [Optional] The severity of the message being written

        Valid values: DEBUG, INFO, WARNING, ERROR
    
    .PARAMETER Tag
        <string> [Optional] The Tag to be added to the logged message
    
    .PARAMETER LogFile
        <System.IO.FileInfo> [Optional] The full path of the log file to be written to

        If not specified when calling the function or in the calling script,
        a file will be created within a LOGS folder inside the scripts parent folder.
        If the scripts parent folder path can't be obtained, it will fall back to C:\LOGS
    
    .EXAMPLE
        Write-ToLog "This message will be written to the log file"

            2022-09-02 19:22:00 : This message will be written to the log file
    
    .EXAMPLE
        Write-ToLog "This message will be written to the log file" -LogFile "C:\Path\To\LogFile.txt"

            2022-09-02 19:22:00 : This message will be written to the log file
    
    .EXAMPLE
        Write-ToLog -Message "This message will be written to the log file" -Severity INFO -Tag "TagValue"

            2022-09-02 19:22:00 : INFO: [TagValue] This message will be written to the log file
    
    .EXAMPLE
        Write-ToLog -Message "This message will be written to the log file" -Tag "TagValue"

            2022-09-02 19:22:00 : [TagValue] This message will be written to the log file
    
    .LINK
        https://www.patrickcage.com/write-tolog
    
    .LINK
        https://github.com/C493/write-tolog
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0,HelpMessage="The message to be written to the log file")]
        [string] $Message,
        [Parameter(HelpMessage="The severity of the message being written")]
        [ValidateSet("DEBUG","INFO","WARNING","ERROR")]
        [string] $Severity=$null,
        [Parameter(HelpMessage="The Tag to be added to the logged message")]
        [string] $Tag=$null,
        [Parameter(HelpMessage="The path to the log file to be written to")]
        [System.IO.FileInfo] $LogFile
    )
    # If Message is empty, there is nothing to log
    If (($null -eq $Message) -or ("" -eq $Message)) { Return }

    # Check if logging is Disabled (LoggingEnabled = 0), otherwise logging is enabled
    If ($script:LoggingEnabled -eq 0) { Return }

    # Set LogFile if not otherwise specified
    If (($null -eq $LogFile) -or ("" -eq $LogFile)) {
        If (($null -eq $script:LogFile) -or ("" -eq $script:LogFile)) {
            # Get ParentPath (PSScriptRoot is not usable when compiled to EXE)
            Try {
                New-Item -ItemType File -Name "tmp_write-tolog" -Path ".\" -Force -ErrorAction Stop | Out-Null
                $ParentPath = (Get-ChildItem -Path ".\tmp_write-tolog").DirectoryName
                Remove-Item "tmp_write-tolog" -Force
            }
            Catch { $ParentPath = "C:\LOGS" } # Set to "C:\LOGS" if unable to obtain actual ParentPath
            Write-Verbose -Message "LogFile was not set, setting to `"$($ParentPath)\LOGS\$(Get-Date -Format "yyyy-MM-dd").txt`""
            $LogFile = "$($ParentPath)\LOGS\$(Get-Date -Format "yyyy-MM-dd").txt"
        }
        else { $LogFile = $script:LogFile }
    }
    
    # Create the LogFile path if it doesn't exist
    If (!(Test-Path $LogFile -PathType Leaf)) {
        Try {
            New-Item -Path $LogFile -ItemType File -Force -ErrorAction Stop | Out-Null
            Add-Content -Path $LogFile -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") : LOG FILE CREATED"
        }
        Catch {
            Write-Warning -Message "Unable to access `"$($LogFile)`", disabling logging."
            # Cannot access LogFile, so disable logging for this script run
            Set-Variable -Name "LoggingEnabled" -Scope Script -Value 0
            Return
        }
    }

    # Build the log entry and write it to the LogFile
    $Timestamp = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") : "
    If(($null -ne $Severity) -and ("" -ne $Severity)){$SeverityLevel = "$($Severity): "}
    If (($null -ne $Tag) -and ("" -ne $Tag)){$Tag = "[$($Tag)] "}
    Add-Content -Path $LogFile -Value "${Timestamp}${SeverityLevel}${Tag}${Message}" -Force
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] ${SeverityLevel}${Tag}${Message}"
}

Get-Help Write-ToLog -Full