# Get a list of all computers in the domain
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# The file content
$fileContent = "This is a Security Test."

# Error log file
$errorLogFile = "ErrorLog.txt"

# Script block to create the file
$scriptBlock = {
    param($path, $content)
    Set-Content -Path $path -Value $content
}

# Iterate through each computer and create the file
foreach ($computer in $computers) {
    # Check if the computer is online
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
        # Start a background job to create the file on the remote computer
        Start-Job -ScriptBlock {
            param($computer, $sb, $path, $content)
            try {
                Invoke-Command -ComputerName $computer -ScriptBlock $sb -ArgumentList $path, $content -ErrorAction Stop
                "Successfully created Security-Test.txt on $computer"
            } catch {
                "Failed to create Security-Test.txt on $computer`n$_" | Out-File -FilePath $errorLogFile -Append
            }
        } -ArgumentList $computer, $scriptBlock, "C:\Security-Test.txt", $fileContent
    } else {
        "Computer $computer is offline" | Out-File -FilePath $errorLogFile -Append
    }
}

# Wait for all jobs to complete
Get-Job | Wait-Job

# Display the results
Get-Job | Receive-Job
