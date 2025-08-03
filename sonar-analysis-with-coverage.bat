@echo off
echo ========================================
echo SonarQube Analysis with Coverage Setup
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

REM Check if ReportGenerator is installed
where reportgenerator >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing ReportGenerator...
    dotnet tool install --global dotnet-reportgenerator-globaltool
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install ReportGenerator
        pause
        exit /b 1
    )
)

echo Step 1: Clean previous test results...
if exist "TestResults" rmdir /s /q "TestResults"
if exist "MovieTheater.Tests\TestResults" rmdir /s /q "MovieTheater.Tests\TestResults"
if exist "coverage-report" rmdir /s /q "coverage-report"

echo Step 2: Restore dependencies...
dotnet restore
if %errorlevel% neq 0 (
    echo ERROR: Failed to restore dependencies
    pause
    exit /b 1
)

echo Step 3: Build project...
dotnet build --configuration Release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build project
    pause
    exit /b 1
)

echo Step 4: Run tests with coverage...
dotnet test --no-build --collect:"XPlat Code Coverage" --results-directory "TestResults" --configuration Release --logger "console;verbosity=normal"
if %errorlevel% neq 0 (
    echo ERROR: Failed to run tests
    pause
    exit /b 1
)

echo Step 5: Check coverage files...
set COVERAGE_FOUND=false
if exist "TestResults\**\coverage.opencover.xml" (
    echo SUCCESS: OpenCover coverage files found
    for /r "TestResults" %%f in (coverage.opencover.xml) do (
        echo Found OpenCover file: %%f
        set COVERAGE_FOUND=true
    )
)

if exist "TestResults\**\coverage.cobertura.xml" (
    echo SUCCESS: Cobertura coverage files found
    for /r "TestResults" %%f in (coverage.cobertura.xml) do (
        echo Found Cobertura file: %%f
        set COVERAGE_FOUND=true
    )
)

if "%COVERAGE_FOUND%"=="false" (
    echo WARNING: No coverage files found
    echo Checking TestResults directory structure...
    dir /s TestResults
    pause
)

echo Step 6: Generate HTML coverage report...
if exist "TestResults\**\coverage.opencover.xml" (
    reportgenerator -reports:"TestResults/**/coverage.opencover.xml" -targetdir:"coverage-report" -reporttypes:Html;TextSummary -sourcedirs:"." -verbosity:Normal
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

echo Step 7: Run SonarQube analysis...
sonar-scanner
if %errorlevel% neq 0 (
    echo ERROR: SonarQube analysis failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS: SonarQube analysis completed!
echo ========================================
echo.
echo Coverage files generated:
if exist "TestResults\**\coverage.opencover.xml" (
    for /r "TestResults" %%f in (coverage.opencover.xml) do echo - %%f
)
if exist "TestResults\**\coverage.cobertura.xml" (
    for /r "TestResults" %%f in (coverage.cobertura.xml) do echo - %%f
)
echo.
echo HTML coverage report: coverage-report\index.html
echo SonarQube dashboard: Check your SonarQube server
echo.
pause 