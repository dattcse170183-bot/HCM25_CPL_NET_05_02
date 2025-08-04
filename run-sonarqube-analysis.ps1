# SonarQube Analysis Script
# Usage: .\run-sonarqube-analysis.ps1

param(
    [string]$SonarToken = "2b96eae5f71468762a02cb5a496e5a0216c0676a"
)

Write-Host "=== SonarQube Analysis Script ===" -ForegroundColor Green
Write-Host "Starting analysis..." -ForegroundColor Yellow

# Set environment variable
$env:SONAR_TOKEN = $SonarToken

try {
    # Step 1: Run tests with coverage
    Write-Host "Step 1: Running tests with coverage..." -ForegroundColor Cyan
    dotnet test MovieTheater.Tests --settings coverlet.runsettings --results-directory "TestResults" --configuration Release
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Tests failed!" -ForegroundColor Red
        exit 1
    }
    
    # Step 2: Begin SonarQube analysis
    Write-Host "Step 2: Starting SonarQube analysis..." -ForegroundColor Cyan
    dotnet sonarscanner begin /k:"DreamFog20_HCM25_CPL_NET_05" /o:"dreamfog20" /d:sonar.token="$env:SONAR_TOKEN" /d:sonar.host.url="https://sonarcloud.io" /d:sonar.cs.opencover.reportsPaths="TestResults/**/coverage.opencover.xml" /d:sonar.cs.cobertura.reportPaths="TestResults/**/coverage.cobertura.xml" /d:sonar.exclusions="**/MovieTheater.Tests/**,**/bin/**,**/obj/**,**/*.cshtml,**/*.js,**/*.css,**/TestResults/**" /d:sonar.test.inclusions="**/MovieTheater.Tests/**/*.cs"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "SonarQube begin failed!" -ForegroundColor Red
        exit 1
    }
    
    # Step 3: Build project
    Write-Host "Step 3: Building project..." -ForegroundColor Cyan
    dotnet build --configuration Release
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed!" -ForegroundColor Red
        exit 1
    }
    
    # Step 4: End SonarQube analysis
    Write-Host "Step 4: Ending SonarQube analysis..." -ForegroundColor Cyan
    dotnet sonarscanner end /d:sonar.token="$env:SONAR_TOKEN"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "SonarQube end failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "=== Analysis completed successfully! ===" -ForegroundColor Green
    Write-Host "Check results at: https://sonarcloud.io/dashboard?id=DreamFog20_HCM25_CPL_NET_05" -ForegroundColor Yellow
    
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} 