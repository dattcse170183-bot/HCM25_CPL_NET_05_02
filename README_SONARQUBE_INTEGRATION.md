# SonarQube Integration với Unit Test Coverage

## Tổng quan
Dự án này đã được cấu hình để tích hợp unit test coverage vào SonarQube. Coverage được tạo bằng Coverlet và được gửi đến SonarQube để phân tích chất lượng code.

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

## Cách sử dụng nhanh

### 1. Kiểm tra cấu hình
```bash
test-sonarqube-integration.bat
```

### 2. Chạy SonarQube analysis (cần server)
```bash
sonar-analysis-with-coverage.bat
```

### 3. Xem HTML coverage report
```bash
generate-coverage.bat
```

## Files quan trọng

### Scripts:
- `sonar-analysis-with-coverage.bat` - Script chính
- `sonar-analysis-with-coverage.ps1` - PowerShell version
- `test-sonarqube-integration.bat` - Test integration
- `generate-coverage.bat` - Tạo HTML report

### Cấu hình:
- `sonar-project.properties` - Cấu hình SonarQube
- `MovieTheater.Tests.csproj` - Cấu hình test project

### Documentation:
- `SONARQUBE_COVERAGE_SETUP.md` - Hướng dẫn chi tiết
- `SONARQUBE_INTEGRATION_ISSUES.md` - Phân tích vấn đề

## Yêu cầu hệ thống

### Bắt buộc:
- .NET 8.0 SDK
- SonarQube Scanner
- ReportGenerator (tự động cài đặt)

### Tùy chọn:
- SonarQube server (để chạy analysis thực tế)
- SONAR_HOST_URL và SONAR_TOKEN (để kết nối server)

## Cấu trúc coverage

```
TestResults/
└── [timestamp]/
    └── coverage.cobertura.xml
```

## Kết quả

### Coverage Report:
- File: `coverage-report/index.html`
- Hiển thị chi tiết coverage theo từng file
- Tương tác với source code

### SonarQube Dashboard:
- Truy cập SonarQube server
- Xem metrics coverage trong project
- Kiểm tra Quality Gate

## Troubleshooting

### Vấn đề thường gặp:

1. **Test failures**: Sửa lỗi EmailService constructor
2. **Không có coverage**: Kiểm tra cấu hình Coverlet
3. **SonarQube không nhận coverage**: Kiểm tra đường dẫn file

### Debug commands:
```bash
# Kiểm tra coverage files
Get-ChildItem -Path TestResults -Recurse -Filter "*.xml"

# Chạy test với verbose
dotnet test --logger "console;verbosity=detailed"

# Kiểm tra SonarQube Scanner
sonar-scanner --version
```

## Khuyến nghị

### Ngay lập tức:
- Sử dụng Cobertura format (đã hoạt động)
- Chạy `test-sonarqube-integration.bat` để kiểm tra

### Ngắn hạn:
- Sửa lỗi EmailService test
- Cấu hình SonarQube server

### Dài hạn:
- Cải thiện test code quality
- Giảm nullability warnings
- Tạo OpenCover format (nếu cần)

## Liên kết hữu ích

- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Coverlet Documentation](https://github.com/coverlet-coverage/coverlet)
- [ReportGenerator](https://github.com/danielpalme/ReportGenerator)

## Hỗ trợ

Nếu gặp vấn đề, hãy:
1. Chạy `test-sonarqube-integration.bat` để kiểm tra
2. Xem `SONARQUBE_INTEGRATION_ISSUES.md` để tìm giải pháp
3. Kiểm tra logs trong console output 