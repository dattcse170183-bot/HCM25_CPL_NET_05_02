# Script chạy test coverage đơn giản
Write-Host "=== CHAY TEST COVERAGE DON GIAN ===" -ForegroundColor Green

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

# Bước 3: Chạy tests với coverage
Write-Host "3. Dang chay tests voi coverage..." -ForegroundColor Yellow
dotnet test --configuration Release --collect:"XPlat Code Coverage" --results-directory TestResults --verbosity normal

# Bước 4: Hiển thị kết quả coverage
Write-Host "`n=== KET QUA COVERAGE ===" -ForegroundColor Green

# Tìm tất cả file coverage
$coverageFiles = Get-ChildItem -Path "TestResults" -Recurse -Filter "coverage.opencover.xml"
if ($coverageFiles.Count -gt 0) {
    Write-Host "Tim thay $($coverageFiles.Count) file coverage:" -ForegroundColor Cyan
    foreach ($file in $coverageFiles) {
        Write-Host "  - $($file.FullName)" -ForegroundColor White
    }
    
    # Phân tích file coverage đầu tiên
    $firstFile = $coverageFiles[0]
    Write-Host "`nPhan tich file: $($firstFile.Name)" -ForegroundColor Yellow
    
    # Đọc và phân tích XML
    try {
        [xml]$coverageXml = Get-Content $firstFile.FullName
        
        # Tính tổng số dòng và số dòng được cover
        $totalLines = 0
        $coveredLines = 0
        
        foreach ($class in $coverageXml.CoverageSession.Modules.Module.Classes.Class) {
            foreach ($method in $class.Methods.Method) {
                foreach ($sequencePoint in $method.SequencePoints.SequencePoint) {
                    $totalLines++
                    if ($sequencePoint.vc -gt 0) {
                        $coveredLines++
                    }
                }
            }
        }
        
        if ($totalLines -gt 0) {
            $coveragePercentage = [math]::Round(($coveredLines / $totalLines) * 100, 2)
            Write-Host "Tong so dong code: $totalLines" -ForegroundColor White
            Write-Host "So dong duoc cover: $coveredLines" -ForegroundColor White
            Write-Host "Do bao phu: $coveragePercentage%" -ForegroundColor Green
            
            if ($coveragePercentage -ge 80) {
                Write-Host "✅ Coverage dat yeu cau (>= 80%)" -ForegroundColor Green
            } elseif ($coveragePercentage -ge 60) {
                Write-Host "⚠️ Coverage trung binh (60-80%)" -ForegroundColor Yellow
            } else {
                Write-Host "❌ Coverage thap (< 60%)" -ForegroundColor Red
            }
        } else {
            Write-Host "Khong tim thay du lieu coverage" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Loi khi doc file coverage: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Khong tim thay file coverage nao" -ForegroundColor Red
}

Write-Host "`n=== HOAN THANH ===" -ForegroundColor Green
Write-Host "Coverage test da duoc chay thanh cong!" -ForegroundColor Cyan
Write-Host "Ban co the xem chi tiet trong thu muc TestResults" -ForegroundColor Cyan 