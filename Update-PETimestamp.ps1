function Update-PETimestamp {
    [CmdletBinding()]
    param (
        [string]$File,
        [uint32]$NewTimestamp
    )

    # Ensure the file exists
    if (-Not (Test-Path $File)) {
        Write-Host "[!] Error: File does not exist: $File"
        exit 1
    }

    # Ensure the file is not read-only
    if ((Get-Item $File).IsReadOnly) {
        Write-Host "[!] Error: File is read-only. Change permissions before proceeding."
        exit 1
    }

    # Try opening the file with error handling
    try {
        $fs = [System.IO.File]::Open($File, "Open", "ReadWrite", "Write")
        if (-Not $fs) { throw "Failed to open file." }

        $br = New-Object System.IO.BinaryReader($fs)
        $bw = New-Object System.IO.BinaryWriter($fs)

        # Read PE header offset (DOS Header -> e_lfanew at 0x3C)
        $fs.Seek(0x3C, [System.IO.SeekOrigin]::Begin) | Out-Null
        $peOffset = $br.ReadInt32()

        if ($peOffset -lt 0) {
            throw "Invalid PE header offset: $peOffset"
        }

        # Move to IMAGE_FILE_HEADER -> TimeDateStamp
        $fs.Seek($peOffset + 8, [System.IO.SeekOrigin]::Begin) | Out-Null
        $originalTimestamp = $br.ReadUInt32()
        $zeroDate = Get-Date -Date "01/01/1970"

        Write-Host "[*] Original TimeStamp: $originalTimestamp -"$zeroDate.AddSeconds($originalTimestamp)
        Write-Host "[*] Updating TimeStamp to: $NewTimestamp -"$zeroDate.AddSeconds($NewTimeStamp)

        # Move back and write new timestamp
        $fs.Seek($peOffset + 8, [System.IO.SeekOrigin]::Begin) | Out-Null
        $bw.Write([UInt32]$NewTimestamp)

        Write-Host "[+] Successfully updated the PE timestamp!"
    }
    catch {
        Write-Host "[!] Error: $_"
    }
    finally {
        # Ensure proper cleanup
        if ($br) { $br.Close() }
        if ($bw) { $bw.Close() }
        if ($fs) { $fs.Close() }
    }
}
