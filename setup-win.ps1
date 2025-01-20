#                       _oo0oo_
#                      o8888888o
#                      88" . "88
#                      (| -_- |)
#                      0\  =  /0
#                    ___/`---'\___
#                  .' \\|     |# '.
#                 / \\|||  :  |||# \
#                / _||||| -:- |||||- \
#               |   | \\\  -  #/ |   |
#               | \_|  ''\---/''  |_/ |
#               \  .-\__  '-'  ___/-. /
#             ___'. .'  /--.--\  `. .'___
#          ."" '<  `.___\_<|>_/___.' >' "".
#         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
#         \  \ `_.   \_ __\ /__ _/   .-` /  /
#     =====`-.____`.___ \_____/___.-`___.-'=====
#                       `=---='
#
#     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#            Phật phù hộ, không bao giờ BUG
#     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Write-Start {
    param($msg)

    Write-Host (">> START: " + $msg) -ForegroundColor Gray
}

function Write-Done {
    param($msg)

    Write-Host (">> DONE: " + $msg) -ForegroundColor Green
    Write-Host
}

function DisableUAC {
    $msg = "Disbale UAC"

    Write-Start -msg $msg

    Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
    
    Write-Done -msg $msg
}

function InstallChocolatey {
    $msg = "Install Chocolatey"

    Write-Start -msg $msg

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Warning "Chocolatey already installed"
    }
    else {
        Set-ExecutionPolicy Bypass -Scope Process
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    Write-Done -msg $msg
}

function InstallSoftware {
    $msg = "Install Software"

    Write-Start -msg $msg

    choco install obs-studio -y
    choco install winrar -y
    choco install revo-uninstaller -y
    choco install zalopc -y
    choco install choco-cleaner -y
    choco install crystaldiskinfo -y
    choco install unikey
    choco install tabby
    choco install anydesk
    choco install microsoft-office-deployment -y

    Write-Done -msg $msg
}

function InstallDevTools {
    $msg = "Install Dev Tools"

    Write-Start -msg $msg

    choco install git -y
    choco install gitkraken -y
    choco install vscode -y
    choco install nvm -y
    choco install powertoys -y
    choco install microsoft-windows-terminal -y
    choco install ngrok -y
    choco install notepadplusplus -y

    Write-Done -msg $msg
}


function DoIt {
    DisableUAC
    InstallChocolatey
    InstallSoftware
    InstallDevTools
}

#########################

# Check-Is-Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

## If not admin, restart as admin
if (-not $isAdmin) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs

    Exit
}

DoIt
