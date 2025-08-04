# Script tạo HTML coverage report
Write-Host "=== TAO HTML COVERAGE REPORT ===" -ForegroundColor Green

# Kiểm tra xem có đang ở trong thư mục dự án không
if (-not (Test-Path "MovieTheater.csproj")) {
    Write-Host "Loi: Khong tim thay file MovieTheater.csproj. Vui long chay script tu thu muc goc cua du an." -ForegroundColor Red
    exit 1
}

# Bước 1: Clean và restore
Write-Host "1. Dang clean va restore..." -ForegroundColor Yellow
dotnet clean
dotnet restore

# Bước 2: Build project
Write-Host "2. Dang build project..." -ForegroundColor Yellow
dotnet build --configuration Release

# Bước 3: Chạy tests với HTML coverage report
Write-Host "3. Dang chay tests voi HTML coverage report..." -ForegroundColor Yellow
dotnet test --configuration Release --collect:"XPlat Code Coverage" --logger "html;LogFileName=coverage.html" --results-directory TestResults

Write-Host "`n=== HOAN THANH ===" -ForegroundColor Green
Write-Host "HTML coverage report da duoc tao trong thu muc TestResults" -ForegroundColor Cyan
Write-Host "Mo file TestResults/coverage.html trong trinh duyet de xem ket qua" -ForegroundColor Cyan

# Tìm file HTML coverage
$htmlFiles = Get-ChildItem -Path "TestResults" -Recurse -Filter "*.html"
if ($htmlFiles.Count -gt 0) {
    Write-Host "`nTim thay HTML coverage files:" -ForegroundColor Cyan
    foreach ($file in $htmlFiles) {
        Write-Host "  - $($file.FullName)" -ForegroundColor White
    }
} else {
    Write-Host "`nKhong tim thay HTML coverage files" -ForegroundColor Yellow
} 