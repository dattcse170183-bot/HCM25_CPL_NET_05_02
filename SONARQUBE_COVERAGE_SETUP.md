# Hướng dẫn tích hợp Unit Test Coverage vào SonarQube

## Tổng quan
Tài liệu này hướng dẫn cách tích hợp unit test coverage vào SonarQube cho dự án Movie Theater Team03.

## Yêu cầu hệ thống

### 1. Cài đặt SonarQube Scanner
```bash
# Tải và cài đặt SonarQube Scanner từ:
# https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
```

### 2. Cài đặt ReportGenerator
```bash
dotnet tool install --global dotnet-reportgenerator-globaltool
```

### 3. Cài đặt Coverlet Collector
Đã được cấu hình trong `MovieTheater.Tests.csproj`:
```xml
<PackageReference Include="coverlet.collector" Version="6.0.4" />
```

## Cấu hình

### 1. SonarQube Configuration (`sonar-project.properties`)
- Hỗ trợ nhiều format coverage: OpenCover, Cobertura
- Cấu hình exclusions cho coverage
- Thiết lập ngưỡng coverage tối thiểu (70%)

### 2. Test Project Configuration (`MovieTheater.Tests.csproj`)
- Cấu hình Coverlet collector
- Thiết lập output formats: OpenCover, Cobertura
- Cấu hình exclusions cho coverage

## Cách sử dụng

### Phương pháp 1: Sử dụng Batch Script (Windows)
```bash
# Chạy script tích hợp
sonar-analysis-with-coverage.bat
```

### Phương pháp 2: Sử dụng PowerShell Script (Windows)
```powershell
# Chạy PowerShell script
.\sonar-analysis-with-coverage.ps1
```

### Phương pháp 3: Chạy thủ công
```bash
# Bước 1: Clean và build
dotnet clean
dotnet restore
dotnet build --configuration Release

# Bước 2: Chạy tests với coverage
dotnet test --no-build --collect:"XPlat Code Coverage" --results-directory "TestResults" --configuration Release

# Bước 3: Tạo HTML report (tùy chọn)
reportgenerator -reports:"TestResults/**/coverage.opencover.xml" -targetdir:"coverage-report" -reporttypes:Html;TextSummary

# Bước 4: Chạy SonarQube analysis
sonar-scanner
```

## Cấu trúc file coverage

### OpenCover Format
```
TestResults/
└── [timestamp]/
    └── coverage.opencover.xml
```

### Cobertura Format
```
TestResults/
└── [timestamp]/
    └── coverage.cobertura.xml
```

## Kiểm tra kết quả

### 1. HTML Coverage Report
- File: `coverage-report/index.html`
- Hiển thị chi tiết coverage theo từng file
- Tương tác với source code

### 2. SonarQube Dashboard
- Truy cập SonarQube server
- Xem metrics coverage trong project
- Kiểm tra Quality Gate

## Troubleshooting

### Vấn đề thường gặp

#### 1. Không tìm thấy file coverage
**Nguyên nhân:** Test không chạy hoặc cấu hình sai
**Giải pháp:**
- Kiểm tra test project có build thành công không
- Kiểm tra cấu hình Coverlet trong `.csproj`
- Chạy test riêng lẻ để debug

#### 2. SonarQube không nhận coverage
**Nguyên nhân:** Đường dẫn coverage file sai
**Giải pháp:**
- Kiểm tra `sonar.cs.opencover.reportsPaths` trong `sonar-project.properties`
- Đảm bảo file coverage tồn tại trước khi chạy sonar-scanner

#### 3. Coverage thấp
**Nguyên nhân:** Test chưa đầy đủ
**Giải pháp:**
- Viết thêm unit tests
- Kiểm tra exclusions trong cấu hình
- Review test strategy

### Debug Commands

```bash
# Kiểm tra cấu trúc TestResults
dir /s TestResults

# Kiểm tra file coverage
find TestResults -name "*.xml"

# Chạy test với verbose output
dotnet test --logger "console;verbosity=detailed"

# Kiểm tra SonarQube Scanner
sonar-scanner --version
```

## Cấu hình nâng cao

### 1. Custom Coverage Exclusions
Thêm vào `sonar-project.properties`:
```properties
sonar.coverage.exclusions=**/Program.cs,**/Startup.cs,**/*.cshtml
```

### 2. Coverage Thresholds
```properties
sonar.coverage.minimum=80
```

### 3. Quality Gate Rules
Cấu hình trong SonarQube Dashboard:
- Coverage trên new code > 80%
- Coverage trên overall > 70%
- No uncovered conditions

## CI/CD Integration

### GitHub Actions Example
```yaml
name: SonarQube Analysis
on: [push, pull_request]
jobs:
  sonarqube:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v3
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '8.0.x'
    - name: Install SonarQube Scanner
      run: |
        # Download and setup sonar-scanner
    - name: Run Tests with Coverage
      run: dotnet test --collect:"XPlat Code Coverage"
    - name: SonarQube Analysis
      run: sonar-scanner
```

## Kết luận

Với cấu hình này, bạn có thể:
1. Chạy unit tests với coverage
2. Tạo HTML report để review
3. Tích hợp coverage vào SonarQube
4. Theo dõi quality metrics trong dashboard

Đảm bảo chạy script `sonar-analysis-with-coverage.bat` hoặc `sonar-analysis-with-coverage.ps1` để có kết quả tốt nhất. 