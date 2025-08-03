# SonarQube Analysis with Coverage Setup - PowerShell Version
Write-Host "========================================" -ForegroundColor Green
Write-Host "SonarQube Analysis with Coverage Setup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if SonarQube Scanner is installed
try {
    $null = Get-Command sonar-scanner -ErrorAction Stop
    Write-Host "✓ SonarQube Scanner found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: SonarQube Scanner is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install SonarQube Scanner from: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if ReportGenerator is installed
try {
    $null = Get-Command reportgenerator -ErrorAction Stop
    Write-Host "✓ ReportGenerator found" -ForegroundColor Green
} catch {
    Write-Host "Installing ReportGenerator..." -ForegroundColor Yellow
    dotnet tool install --global dotnet-reportgenerator-globaltool
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install ReportGenerator" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "Step 1: Clean previous test results..." -ForegroundColor Cyan
if (Test-Path "TestResults") { Remove-Item "TestResults" -Recurse -Force }
if (Test-Path "MovieTheater.Tests\TestResults") { Remove-Item "MovieTheater.Tests\TestResults" -Recurse -Force }
if (Test-Path "coverage-report") { Remove-Item "coverage-report" -Recurse -Force }

Write-Host "Step 2: Restore dependencies..." -ForegroundColor Cyan
dotnet restore
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to restore dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Step 3: Build project..." -ForegroundColor Cyan
dotnet build --configuration Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to build project" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Step 4: Run tests with coverage..." -ForegroundColor Cyan
dotnet test --no-build --collect:"XPlat Code Coverage" --results-directory "TestResults" --configuration Release --logger "console;verbosity=normal"
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to run tests" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Step 5: Check coverage files..." -ForegroundColor Cyan
$coverageFound = $false

$opencoverFiles = Get-ChildItem -Path "TestResults" -Recurse -Filter "coverage.opencover.xml"
if ($opencoverFiles) {
    Write-Host "SUCCESS: OpenCover coverage files found" -ForegroundColor Green
    foreach ($file in $opencoverFiles) {
        Write-Host "Found OpenCover file: $($file.FullName)" -ForegroundColor Green
        $coverageFound = $true
    }
}

$coberturaFiles = Get-ChildItem -Path "TestResults" -Recurse -Filter "coverage.cobertura.xml"
if ($coberturaFiles) {
    Write-Host "SUCCESS: Cobertura coverage files found" -ForegroundColor Green
    foreach ($file in $coberturaFiles) {
        Write-Host "Found Cobertura file: $($file.FullName)" -ForegroundColor Green
        $coverageFound = $true
    }
}

if (-not $coverageFound) {
    Write-Host "WARNING: No coverage files found" -ForegroundColor Yellow
    Write-Host "Checking TestResults directory structure..." -ForegroundColor Yellow
    Get-ChildItem -Path "TestResults" -Recurse | Format-Table Name, FullName
    Read-Host "Press Enter to continue"
}

Write-Host "Step 6: Generate HTML coverage report..." -ForegroundColor Cyan
if ($opencoverFiles) {
    reportgenerator -reports:"TestResults/**/coverage.opencover.xml" -targetdir:"coverage-report" -reporttypes:Html;TextSummary -sourcedirs:"." -verbosity:Normal
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNING: Failed to generate HTML report" -ForegroundColor Yellow
    } else {
        Write-Host "SUCCESS: HTML coverage report generated" -ForegroundColor Green
        if (Test-Path "coverage-report\index.html") {
            Write-Host "Opening coverage report..." -ForegroundColor Cyan
            Start-Process "coverage-report\index.html"
        }
    }
}

Write-Host "Step 7: Run SonarQube analysis..." -ForegroundColor Cyan
sonar-scanner
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: SonarQube analysis failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SUCCESS: SonarQube analysis completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Coverage files generated:" -ForegroundColor Cyan
if ($opencoverFiles) {
    foreach ($file in $opencoverFiles) {
        Write-Host "- $($file.FullName)" -ForegroundColor White
    }
}
if ($coberturaFiles) {
    foreach ($file in $coberturaFiles) {
        Write-Host "- $($file.FullName)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "HTML coverage report: coverage-report\index.html" -ForegroundColor Cyan
Write-Host "SonarQube dashboard: Check your SonarQube server" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to exit" 