@echo off
echo ========================================
echo Testing SonarQube Setup Locally
echo ========================================

echo.
echo 1. Checking environment...
echo Current directory: %CD%
echo SONAR_TOKEN exists: %SONAR_TOKEN%

echo.
echo 2. Checking sonar-project.properties...
if exist "sonar-project.properties" (
    echo sonar-project.properties found
    type sonar-project.properties
) else (
    echo ERROR: sonar-project.properties not found!
    exit /b 1
)

echo.
echo 3. Installing SonarQube Scanner...
dotnet tool install --global dotnet-sonarscanner

echo.
echo 4. Testing SonarQube Scanner...
dotnet sonarscanner --version

echo.
echo 5. Testing SonarQube analysis (if token available)...
if defined SONAR_TOKEN (
    echo Token available, testing analysis...
    dotnet sonarscanner begin /k:"DreamFog20_HCM25_CPL_NET_05" /o:"dreamfog20" /d:sonar.token="%SONAR_TOKEN%" /d:sonar.host.url="https://sonarcloud.io"
    dotnet build
    dotnet sonarscanner end /d:sonar.token="%SONAR_TOKEN%"
    echo Analysis completed
) else (
    echo No SONAR_TOKEN found, skipping analysis test
)

echo.
echo ========================================
echo Local test completed
echo ======================================== 