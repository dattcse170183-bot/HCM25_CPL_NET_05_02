@echo off
echo ========================================
echo Testing SonarQube Integration
echo ========================================
echo.

REM Check if SonarQube Scanner is installed
where sonar-scanner >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: SonarQube Scanner is not installed or not in PATH
    echo Please install SonarQube Scanner from: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
    pause
    exit /b 1
)

echo Step 1: Clean previous test results...
if exist "TestResults" rmdir /s /q "TestResults"
if exist "coverage-report" rmdir /s /q "coverage-report"

echo Step 2: Run tests with coverage...
dotnet test MovieTheater.Tests --collect:"XPlat Code Coverage" --results-directory "TestResults" --configuration Release --logger "console;verbosity=minimal"
if %errorlevel% neq 0 (
    echo WARNING: Some tests failed, but continuing with coverage analysis...
)

echo Step 3: Check coverage files...
set COVERAGE_FOUND=false
if exist "TestResults\**\coverage.cobertura.xml" (
    echo SUCCESS: Cobertura coverage files found
    for /r "TestResults" %%f in (coverage.cobertura.xml) do (
        echo Found Cobertura file: %%f
        set COVERAGE_FOUND=true
    )
)

if exist "TestResults\**\coverage.opencover.xml" (
    echo SUCCESS: OpenCover coverage files found
    for /r "TestResults" %%f in (coverage.opencover.xml) do (
        echo Found OpenCover file: %%f
        set COVERAGE_FOUND=true
    )
)

if "%COVERAGE_FOUND%"=="false" (
    echo ERROR: No coverage files found
    echo Checking TestResults directory structure...
    dir /s TestResults
    pause
    exit /b 1
)

echo Step 4: Generate HTML coverage report...
if exist "TestResults\**\coverage.cobertura.xml" (
    reportgenerator -reports:"TestResults/**/coverage.cobertura.xml" -targetdir:"coverage-report" -reporttypes:Html;TextSummary -sourcedirs:"." -verbosity:Normal
    if %errorlevel% neq 0 (
        echo WARNING: Failed to generate HTML report
    ) else (
        echo SUCCESS: HTML coverage report generated
        if exist "coverage-report\index.html" (
            echo Opening coverage report...
            start coverage-report\index.html
        )
    )
)

echo Step 5: Test SonarQube analysis (dry run)...
echo Note: This is a dry run to test configuration
echo To run actual analysis, you need:
echo 1. SonarQube server running
echo 2. SONAR_HOST_URL environment variable set
echo 3. SONAR_TOKEN environment variable set
echo.
echo Running sonar-scanner --help to verify installation...
sonar-scanner --help
if %errorlevel% neq 0 (
    echo ERROR: SonarQube Scanner is not working properly
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS: SonarQube integration test completed!
echo ========================================
echo.
echo Coverage files generated:
if exist "TestResults\**\coverage.cobertura.xml" (
    for /r "TestResults" %%f in (coverage.cobertura.xml) do echo - %%f
)
if exist "TestResults\**\coverage.opencover.xml" (
    for /r "TestResults" %%f in (coverage.opencover.xml) do echo - %%f
)
echo.
echo HTML coverage report: coverage-report\index.html
echo.
echo Next steps:
echo 1. Set up SonarQube server
echo 2. Configure SONAR_HOST_URL and SONAR_TOKEN
echo 3. Run sonar-analysis-with-coverage.bat
echo.
pause 