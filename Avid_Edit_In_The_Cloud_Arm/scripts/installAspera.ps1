<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [ValidateNotNullOrEmpty()]
    $AsperaURL,
    [ValidateNotNullOrEmpty()]
    $AvidNEXISClientURL
)

filter Timestamp {"$(Get-Date -Format o): $_"}

function
Write-Log($message) {
    $msg = $message | Timestamp
    Write-Output $msg
}

function
DownloadFileOverHttp($Url, $DestinationPath) {
    $secureProtocols = @()
    $insecureProtocols = @([System.Net.SecurityProtocolType]::SystemDefault, [System.Net.SecurityProtocolType]::Ssl3)

    foreach ($protocol in [System.Enum]::GetValues([System.Net.SecurityProtocolType])) {
        if ($insecureProtocols -notcontains $protocol) {
            $secureProtocols += $protocol
        }
    }
    [System.Net.ServicePointManager]::SecurityProtocol = $secureProtocols

    # make Invoke-WebRequest go fast: https://stackoverflow.com/questions/14202054/why-is-this-powershell-code-invoke-webrequest-getelementsbytagname-so-incred
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest $Url -UseBasicParsing -OutFile $DestinationPath -Verbose
    Write-Log "$DestinationPath updated"
}

function 
Install-NexisClient {
   
    Write-Log "downloading Nexis Client"
    $NexisDestinationPath = "D:\AzureData\AvidNEXISClient.msi"
    Write-Log $DestinationPath
    DownloadFileOverHttp $AvidNEXISClientURL $NexisDestinationPath

    Start-Process -FilePath $NexisDestinationPath -ArgumentList "/quiet", "/passive", "/norestart" -Wait
    
}

function
Install-ChocolatyAndPackages {
    
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    Write-Log "choco Install Google Chrome"
    choco install -y googlechrome -ignore-checksum

    Write-Log "choco install -y 7zip.install"
    choco install -y 7zip.install

    choco install -y vcredist2015

}

function 
Install-Aspera {
   
    Write-Log "downloading Aspera Server"
    $AsperaDestinationPath = "D:\AzureData\IBMAsperaHighSpeedTransferServer.msi"

    Write-Log $AsperaDestinationPath
    DownloadFileOverHttp $AsperaURL $AsperaDestinationPath

    Start-Process -FilePath $AsperaDestinationPath -ArgumentList "/quiet", "/log", "D:\AzureData\aspera_installation.log", "/norestart" -Wait

}

try {
    $dest = "D:\AzureData"
    New-Item -Path $dest -ItemType directory -Force

    try {
            Write-Log "Installing chocolaty and packages"
            Install-ChocolatyAndPackages
        }
        catch {
            # chocolaty is best effort
        }
    
    Write-Log "Call Install-NexisCLient"
    Install-NexisClient

    Write-Log "Call Install-Aspera"
    Install-Aspera

}
catch {
    Write-Error $_
}

