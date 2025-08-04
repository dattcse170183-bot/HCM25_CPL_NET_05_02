# Script phân tích coverage chi tiết
param(
    [string]$CoverageType = "cobertura"
)

Write-Host "=== PHAN TICH COVERAGE CHI TIET ===" -ForegroundColor Green

# Kiểm tra thư mục TestResults
if (-not (Test-Path "TestResults")) {
    Write-Host "Loi: Khong tim thay thu muc TestResults. Hay chay test coverage truoc." -ForegroundColor Red
    exit 1
}

# Tìm tất cả file coverage
$coverageFiles = Get-ChildItem -Path "TestResults" -Recurse -Filter "coverage.$CoverageType.xml"
if ($coverageFiles.Count -eq 0) {
    Write-Host "Loi: Khong tim thay file coverage.$CoverageType.xml" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay $($coverageFiles.Count) file coverage:" -ForegroundColor Cyan
foreach ($file in $coverageFiles) {
    Write-Host "  - $($file.FullName)" -ForegroundColor White
}

# Phân tích từng file
foreach ($file in $coverageFiles) {
    Write-Host "`n=== PHAN TICH FILE: $($file.Name) ===" -ForegroundColor Yellow
    
    try {
        # Đọc file XML
        [xml]$coverage = Get-Content $file.FullName
        
        if ($CoverageType -eq "cobertura") {
            # Phân tích Cobertura format
            $packages = $coverage.coverage.packages.package
            $totalLines = 0
            $coveredLines = 0
            $totalBranches = 0
            $coveredBranches = 0
            
            Write-Host "`nChi tiet theo package:" -ForegroundColor Cyan
            
            foreach ($package in $packages) {
                $packageName = $package.name
                $classes = $package.classes.class
                
                Write-Host "`nPackage: $packageName" -ForegroundColor Green
                
                foreach ($class in $classes) {
                    $className = $class.name
                    $filename = $class.filename
                    $lines = $class.lines.line
                    
                    $classLines = 0
                    $classCovered = 0
                    
                    foreach ($line in $lines) {
                        $classLines++
                        if ($line.hits -gt 0) {
                            $classCovered++
                        }
                    }
                    
                    $coveragePercent = if ($classLines -gt 0) { [math]::Round(($classCovered / $classLines) * 100, 2) } else { 0 }
                    
                    Write-Host "  Class: $className" -ForegroundColor White
                    Write-Host "    File: $filename" -ForegroundColor Gray
                    Write-Host "    Lines: $classCovered/$classLines ($coveragePercent%)" -ForegroundColor $(if ($coveragePercent -ge 80) { "Green" } elseif ($coveragePercent -ge 60) { "Yellow" } else { "Red" })
                    
                    $totalLines += $classLines
                    $coveredLines += $classCovered
                }
            }
            
            # Tổng kết
            $totalCoverage = if ($totalLines -gt 0) { [math]::Round(($coveredLines / $totalLines) * 100, 2) } else { 0 }
            
            Write-Host "`n=== TONG KET ===" -ForegroundColor Green
            Write-Host "Tong so dong code: $totalLines" -ForegroundColor White
            Write-Host "So dong duoc cover: $coveredLines" -ForegroundColor White
            Write-Host "Do bao phu: $totalCoverage%" -ForegroundColor $(if ($totalCoverage -ge 80) { "Green" } elseif ($totalCoverage -ge 60) { "Yellow" } else { "Red" })
            
        } elseif ($CoverageType -eq "opencover") {
            # Phân tích OpenCover format
            $modules = $coverage.CoverageSession.Modules.Module
            
            Write-Host "`nChi tiet theo module:" -ForegroundColor Cyan
            
            foreach ($module in $modules) {
                $moduleName = $module.ModuleName
                $classes = $module.Classes.Class
                
                Write-Host "`nModule: $moduleName" -ForegroundColor Green
                
                foreach ($class in $classes) {
                    $className = $class.Name
                    $methods = $class.Methods.Method
                    
                    Write-Host "  Class: $className" -ForegroundColor White
                    
                    foreach ($method in $methods) {
                        $methodName = $method.Name
                        $sequencePoints = $method.SequencePoints.SeqPnt
                        
                        $methodLines = 0
                        $methodCovered = 0
                        
                        foreach ($seqPoint in $sequencePoints) {
                            $methodLines++
                            if ($seqPoint.vc -gt 0) {
                                $methodCovered++
                            }
                        }
                        
                        $coveragePercent = if ($methodLines -gt 0) { [math]::Round(($methodCovered / $methodLines) * 100, 2) } else { 0 }
                        
                        Write-Host "    Method: $methodName - $methodCovered/$methodLines ($coveragePercent%)" -ForegroundColor $(if ($coveragePercent -ge 80) { "Green" } elseif ($coveragePercent -ge 60) { "Yellow" } else { "Red" })
                    }
                }
            }
        }
        
    } catch {
        Write-Host "Loi khi doc file $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== HUONG DAN CAI THIEN COVERAGE ===" -ForegroundColor Yellow
Write-Host "1. Xem cac class co coverage thap (< 60%)" -ForegroundColor White
Write-Host "2. Them unit tests cho cac method chua duoc cover" -ForegroundColor White
Write-Host "3. Kiem tra cac branch chua duoc test" -ForegroundColor White
Write-Host "4. Them integration tests cho cac scenario phuc tap" -ForegroundColor White
Write-Host "5. Chay lai test coverage sau khi them tests" -ForegroundColor White

Write-Host "`n=== LENH HUU ICH ===" -ForegroundColor Yellow
Write-Host "De xem coverage HTML report:" -ForegroundColor Cyan
Write-Host "dotnet test --collect:'XPlat Code Coverage' --logger 'html;LogFileName=coverage.html'" -ForegroundColor White
Write-Host "`nDe chay test coverage moi:" -ForegroundColor Cyan
Write-Host ".\run-sonarqube-analysis.ps1" -ForegroundColor White 