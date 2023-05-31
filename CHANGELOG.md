# Write-ToLog ChangeLog
 
All notable changes to this project will be documented in this file
(newer entries on top)

_The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/)._

---

## [v1.0.4] (2023-04-16)

### ADDED
- Fallback value for $ParentPath if it can't be obtained ("C:\LOGS")

### CHANGED
- Moved $ParentPath to only get set if required, i.e. if $LogFile is not set

## [v1.0.3] (2022-09-29)

### REMOVED
- Removed use of $PSScriptRoot (does not work when compiled to EXE)

## [v1.0.2] (2022-09-03)

### ADDED
- Support for Tagging
- Support for Severity (DEBUG,INFO,WARNING,ERROR)
- If $LogFile is not specified, defaults to ".\LOGS\yyyy-MM-dd.txt"

### CHANGED
- $LogToFile variable changed to $LoggingEnabled
- If $LoggingEnabled is not present, or not 0 value then logging is enabled

---
## [v1.0.1] (2022-07-30)

### ADDED
- $LogToFile requirement in calling script (value must not be zero)  
  (Allows logic to turn off logging if errors are encountered)
- If $LogFile cannot be created, warning is displayed and logging is disabled using $LogToFile variable

---
## [v1.0.0] (2022-07-29) _Initial Verison_
### ADDED
- Write content of $Message to a file specified in $LogFile
