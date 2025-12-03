# Powershell script to generate a secure, anonymous keystore
# Usage: .\generate_keystore.ps1

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   SECURE KEYSTORE GENERATOR (ANONYMOUS)" -ForegroundColor Cyan
Write-Host "============================================================"
Write-Host "This script generates an Android signing key locally."
Write-Host "NO data is sent to the internet."
Write-Host "WARN: To remain unlinked, DO NOT use your personal name." -ForegroundColor Yellow
Write-Host "============================================================"
Write-Host ""

# Check for keytool
$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    # Try common Android Studio paths
    $possiblePaths = @(
        "$env:LOCALAPPDATA\Android\sdk\build-tools",
        "C:\Program Files\Android\Android Studio\jbr\bin",
        "C:\Program Files\Android\Android Studio\jre\bin",
        "$env:JAVA_HOME\bin"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path "$path\keytool.exe") {
            $keytool = "$path\keytool.exe"
            break
        }
    }
}

if (-not $keytool) {
    Write-Error "Could not find 'keytool'. Please ensure Java or Android Studio is installed."
    exit
}

# Inputs
$companyName = Read-Host "Enter Company Name (e.g. 'Safehand Poultry')"
$countryCode = Read-Host "Enter 2-letter Country Code (e.g. 'NG', 'US')"
$password = Read-Host -AsSecureString "Enter a Strong Password"
$passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Confirm
Write-Host ""
Write-Host "Generating keystore with:"
Write-Host "  CN=Admin"
Write-Host "  OU=IT"
Write-Host "  O=$companyName"
Write-Host "  C=$countryCode"
Write-Host ""

# Generate
$dname = "CN=Admin, OU=IT, O=$companyName, L=City, S=State, C=$countryCode"
$keystorePath = "upload-keystore.jks"

& $keytool -genkey -v -keystore $keystorePath -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload -dname $dname -storepass $passwordPlain -keypass $passwordPlain

Write-Host ""
if (Test-Path $keystorePath) {
    Write-Host "SUCCESS! Keystore created at: $PWD\$keystorePath" -ForegroundColor Green
    Write-Host "------------------------------------------------------------"
    Write-Host "NEXT STEPS FOR GITHUB ACTIONS:"
    Write-Host "1. Copy the base64 string below:"
    Write-Host ""
    
    $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystorePath))
    Write-Host $base64 -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "2. Go to GitHub -> Settings -> Secrets -> New Repository Secret"
    Write-Host "3. Name: KEYSTORE_BASE64"
    Write-Host "4. Value: (The long string above)"
    Write-Host "5. Create other secrets: KEY_PASSWORD, ALIAS_PASSWORD (same as password you typed), KEY_ALIAS = upload"
    Write-Host "------------------------------------------------------------"
    Write-Host "NOTE: Delete '$keystorePath' from this folder after adding to secrets if you don't want it on this PC." -ForegroundColor Yellow
} else {
    Write-Error "Failed to create keystore."
}

