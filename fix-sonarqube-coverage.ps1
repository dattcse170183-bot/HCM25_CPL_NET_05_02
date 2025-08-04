# Script sửa lỗi SonarQube coverage
param(
    [string]$SonarToken = "",
    [string]$ProjectKey = "team03",
    [string]$ProjectName = "MovieTheater",
    [string]$Organization = "your-organization"
)

Write-Host "=== SUA LOI SONARQUBE COVERAGE ===" -ForegroundColor Green

# Kiểm tra xem có đang ở trong thư mục dự án không
if (-not (Test-Path "MovieTheater.csproj")) {
    Write-Host "Loi: Khong tim thay file MovieTheater.csproj. Vui long chay script tu thu muc goc cua du an." -ForegroundColor Red
    exit 1
}

# Bước 1: Clean và restore
Write-Host "1. Dang clean va restore..." -ForegroundColor Yellow
dotnet clean
dotnet restore

# Bước 2: Cài đặt dotnet-sonarscanner
Write-Host "2. Dang cai dat dotnet-sonarscanner..." -ForegroundColor Yellow
dotnet tool install --global dotnet-sonarscanner --version 5.13.0

# Bước 3: Bắt đầu SonarQube analysis với cấu hình coverage
Write-Host "3. Dang bat dau SonarQube analysis..." -ForegroundColor Yellow

if ([string]::IsNullOrEmpty($SonarToken)) {
    Write-Host "Loi: Can cung cap SonarQube token" -ForegroundColor Red
    Write-Host "Su dung: .\fix-sonarqube-coverage.ps1 -SonarToken 'your-token' -Organization 'your-org'" -ForegroundColor Cyan
    exit 1
}

if ([string]::IsNullOrEmpty($Organization)) {
    Write-Host "Loi: Can cung cap organization name" -ForegroundColor Red
    Write-Host "Su dung: .\fix-sonarqube-coverage.ps1 -SonarToken 'your-token' -Organization 'your-org'" -ForegroundColor Cyan
    exit 1
}

# Bắt đầu SonarQube analysis với cấu hình coverage
dotnet sonarscanner begin /k:$ProjectKey /n:$ProjectName /o:$Organization /d:sonar.host.url="https://sonarcloud.io" /d:sonar.login=$SonarToken /d:sonar.cs.opencover.reportsPaths="TestResults/**/coverage.opencover.xml" /d:sonar.coverage.exclusions="**/*.cshtml,**/*.razor,**/*.css,**/*.js,**/*.html"

# Bước 4: Build project
Write-Host "4. Dang build project..." -ForegroundColor Yellow
dotnet build --configuration Release

# Bước 5: Chạy tests với coverage
Write-Host "5. Dang chay tests voi coverage..." -ForegroundColor Yellow
dotnet test --configuration Release --collect:"XPlat Code Coverage" --results-directory TestResults --verbosity normal

# Bước 6: Kết thúc SonarQube analysis
Write-Host "6. Dang ket thuc SonarQube analysis..." -ForegroundColor Yellow
dotnet sonarscanner end /d:sonar.login=$SonarToken

Write-Host "`n=== HOAN THANH ===" -ForegroundColor Green
Write-Host "SonarQube analysis da duoc chay voi coverage configuration." -ForegroundColor Cyan
Write-Host "Kiem tra dashboard SonarQube de xem ket qua." -ForegroundColor Cyan

Write-Host "`n=== LENH HUU ICH ===" -ForegroundColor Yellow
Write-Host "De xem coverage HTML report:" -ForegroundColor Cyan
Write-Host "dotnet test --collect:'XPlat Code Coverage' --logger 'html;LogFileName=coverage.html'" -ForegroundColor White
Write-Host "`nDe chay test coverage moi:" -ForegroundColor Cyan
Write-Host ".\run-sonarqube-analysis.ps1" -ForegroundColor White 