# Update-PETimestamp.ps1

## Overview
`UpdatePETimestamp.ps1` is a PowerShell script designed to modify IMAGE_NT_HEADERS -> IMAGE_FILE_HEADER -> Time Data Stamp inside PE files. Some EDR 

Script is just loose thing that came to my mind during reading [Practical Malware Analysis - The Hands On Guide to Dissecting Malicious Software](https://www.amazon.com/Practical-Malware-Analysis-Hands-Dissecting/dp/1593272901)

## Running

### Update-PETimestamp
This function scans directories to identify folders excluded from Windows Defender scans.

#### Parameters
- **File (Mandatory)**: The PE file that will have data modified.
- **NewTimestamp (Optional)**: The timestamp that will be set inside PE file headers. Default is 01/01/1970 (0 epoch time).

#### Usage
**Example**  
First import module into current session.
`Import-Module .\UpdatePETimestamp.ps1`

This example sets the timestmap of `lab-modified.exe` file to `5/14/2014 8:40:00 PM` - `1400100000` epoch time
`Update-PETimestamp -File .\lab-modified.exe -NewTimestamp 1400100000`

## Output

Sample output:

    PS C:\Users\student\Desktop> Update-PETimestamp -File .\lab-modified.exe -NewTimestamp 1400100000
    [*] Original TimeStamp: 1300100000 - 3/14/2011 10:53:20 AM
    [*] Updating TimeStamp to: 1400100000 - 5/14/2014 8:40:00 PM
    [+] Successfully updated the PE timestamp!

## Screenshots
Using PEview
Before:
![Alt text](/before-update.png?raw=true "Before Update")
After:
![Alt text](/after-update.png?raw=true "After Update")

## Requirements
- PowerShell
