# Hướng dẫn Test GitHub Actions với SonarQube Coverage

## Tổng quan
Tài liệu này hướng dẫn cách test SonarQube integration thông qua GitHub Actions một cách hiệu quả.

## Trạng thái hiện tại

### ✅ Đã hoàn thành:
- Cấu hình SonarQube cơ bản
- Tạo coverage files (Cobertura format)
- Scripts automation
- HTML coverage report
- Documentation đầy đủ

### ⚠️ Vấn đề cần lưu ý:
- 9 test bị fail do EmailService constructor
- Chỉ có Cobertura format (không có OpenCover)
- 580+ nullability warnings trong test code
- GitHub Actions workflows bị fail

## Cách test nhanh

### Bước 1: Test local trước
```bash
# Test coverage locally
dotnet test MovieTheater.Tests --collect:"XPlat Code Coverage" --results-directory "TestResults"

# Kiểm tra coverage files
Get-ChildItem -Path TestResults -Recurse -Filter "*.xml"
```

### Bước 2: Push lên GitHub để test
```bash
# Commit và push
git add .
git commit -m "Test coverage integration"
git push origin quality-gate
```

### Bước 3: Kiểm tra GitHub Actions
1. Vào repository trên GitHub
2. Chọn tab "Actions"
3. Xem workflow "Debug Test" đang chạy

## Workflows đã tạo

### 1. `debug-test.yml` - MỚI NHẤT
- **Mục đích**: Debug test issues
- **Trigger**: Push/Pull Request trên quality-gate
- **Chức năng**:
  - Kiểm tra .NET version
  - List project files
  - Run tests với detailed output
  - Check test results directory

### 2. `simple-test.yml`
- **Mục đích**: Test cơ bản
- **Trigger**: Push/Pull Request trên quality-gate
- **Chức năng**:
  - Run tests
  - Run tests with coverage
  - List test results

### 3. `test-coverage.yml`
- **Mục đích**: Test coverage cơ bản
- **Trigger**: Push/Pull Request trên main, develop, quality-gate
- **Chức năng**:
  - Chạy tests với coverage
  - Tạo HTML coverage report
  - Upload artifacts

### 4. `sonarqube-with-coverage.yml`
- **Mục đích**: SonarQube analysis với coverage
- **Trigger**: Push/Pull Request trên main, develop
- **Chức năng**:
  - Chạy tests với coverage
  - Gửi kết quả đến SonarCloud
  - Upload artifacts

## Test scenarios

### Scenario 1: Debug Test Issues
```bash
# Push lên branch quality-gate
git checkout quality-gate
git push origin quality-gate
```
**Kết quả mong đợi**:
- Workflow "Debug Test" chạy
- Detailed logs về test execution
- Thông tin về test failures

### Scenario 2: Test Coverage cơ bản
```bash
# Push lên branch quality-gate
git checkout quality-gate
git push origin quality-gate
```
**Kết quả mong đợi**:
- Workflow "Test Coverage" chạy
- Tạo coverage files
- Upload HTML report

### Scenario 3: SonarQube Integration
```bash
# Push lên branch main
git checkout main
git push origin main
```
**Kết quả mong đợi**:
- Workflow "SonarQube with Coverage" chạy
- Gửi coverage đến SonarCloud
- Quality Gate check

## Troubleshooting

### Vấn đề 1: Test failures
**Nguyên nhân**: EmailService constructor issues
**Giải pháp**:
```csharp
// Trong test files, thay vì:
var mockEmailService = new Mock<EmailService>();

// Sử dụng:
var mockEmailService = new Mock<IEmailService>();
```

### Vấn đề 2: Coverage không tạo
**Kiểm tra**:
```bash
# Kiểm tra cấu hình Coverlet
Get-Content MovieTheater.Tests/MovieTheater.Tests.csproj

# Kiểm tra coverage files
Get-ChildItem -Path TestResults -Recurse -Filter "*.xml"
```

### Vấn đề 3: GitHub Actions fail
**Kiểm tra**:
- Logs trong GitHub Actions
- .NET version compatibility
- Test project configuration

## Debug commands

### Local debug
```bash
# Test với verbose output
dotnet test MovieTheater.Tests --logger "console;verbosity=detailed"

# Test coverage với verbose
dotnet test MovieTheater.Tests --collect:"XPlat Code Coverage" --results-directory "TestResults" --logger "console;verbosity=detailed"
```

### GitHub Actions debug
```bash
# Xem logs trong GitHub Actions
# Actions > [Workflow] > [Job] > [Step]
# Tìm step bị fail và xem logs
```

## Kết quả mong đợi

### Coverage Report
- File: `coverage-report/index.html`
- Coverage percentage
- Line-by-line coverage

### SonarCloud Dashboard
- Coverage metrics
- Quality Gate status
- Code quality analysis

## Files quan trọng

### Workflows:
- `.github/workflows/debug-test.yml` - Debug test issues
- `.github/workflows/simple-test.yml` - Test cơ bản
- `.github/workflows/test-coverage.yml` - Test coverage
- `.github/workflows/sonarqube-with-coverage.yml` - SonarQube integration

### Configuration:
- `sonar-project.properties` - SonarQube config
- `MovieTheater.Tests.csproj` - Test project config

## Khuyến nghị

### Ngay lập tức:
1. Chạy `debug-test.yml` để tìm hiểu nguyên nhân test failures
2. Sửa lỗi EmailService test
3. Kiểm tra cấu hình Coverlet

### Ngắn hạn:
1. Sửa tất cả test failures
2. Cấu hình SonarCloud token
3. Test SonarQube integration

### Dài hạn:
1. Cải thiện test code quality
2. Giảm nullability warnings
3. Tạo OpenCover format (nếu cần)

## Liên kết hữu ích

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [SonarCloud Documentation](https://docs.sonarcloud.io/)
- [Coverlet Documentation](https://github.com/coverlet-coverage/coverlet)
- [ReportGenerator](https://github.com/danielpalme/ReportGenerator) 