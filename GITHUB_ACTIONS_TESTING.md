# Hướng dẫn Test GitHub Actions với Coverage

## Tổng quan
Tài liệu này hướng dẫn cách test SonarQube integration thông qua GitHub Actions.

## Workflows đã tạo

### 1. `test-coverage.yml`
- **Mục đích**: Test coverage cơ bản
- **Trigger**: Push/Pull Request trên main, develop, quality-gate
- **Chức năng**:
  - Chạy tests với coverage
  - Tạo HTML coverage report
  - Upload artifacts

### 2. `sonarqube-with-coverage.yml`
- **Mục đích**: SonarQube analysis với coverage
- **Trigger**: Push/Pull Request trên main, develop
- **Chức năng**:
  - Chạy tests với coverage
  - Gửi kết quả đến SonarCloud
  - Upload artifacts

## Cách test

### Bước 1: Push code lên GitHub
```bash
# Commit và push
git add .
git commit -m "Add coverage workflows"
git push origin main
```

### Bước 2: Kiểm tra GitHub Actions
1. Vào repository trên GitHub
2. Chọn tab "Actions"
3. Xem workflow "Test Coverage" đang chạy

### Bước 3: Xem kết quả
- **Coverage Report**: Tải về từ artifacts
- **SonarCloud**: Xem tại https://sonarcloud.io

## Cấu hình cần thiết

### 1. SonarCloud Token
```bash
# Trong GitHub repository settings
# Settings > Secrets and variables > Actions
# Thêm secret: SONAR_TOKEN
```

### 2. SonarCloud Project
- Project key: `DreamFog20_HCM25_CPL_NET_05`
- Organization: `dreamfog20`

## Test scenarios

### Scenario 1: Test Coverage cơ bản
```bash
# Push lên branch quality-gate
git checkout -b quality-gate
git push origin quality-gate
```
**Kết quả mong đợi**:
- Workflow "Test Coverage" chạy
- Tạo coverage files
- Upload HTML report

### Scenario 2: SonarQube Integration
```bash
# Push lên branch main
git checkout main
git push origin main
```
**Kết quả mong đợi**:
- Workflow "SonarQube with Coverage" chạy
- Gửi coverage đến SonarCloud
- Quality Gate check

### Scenario 3: Pull Request
```bash
# Tạo PR từ feature branch
git checkout -b feature/test-coverage
git push origin feature/test-coverage
# Tạo PR trên GitHub
```
**Kết quả mong đợi**:
- Cả hai workflows chạy
- Coverage check trong PR

## Troubleshooting

### Vấn đề 1: Workflow không chạy
**Kiểm tra**:
- Branch name có đúng không
- File workflow có trong `.github/workflows/` không
- Syntax YAML có đúng không

### Vấn đề 2: Coverage không tạo
**Kiểm tra**:
- Test project có cấu hình Coverlet không
- Tests có chạy thành công không
- Logs trong GitHub Actions

### Vấn đề 3: SonarCloud không nhận coverage
**Kiểm tra**:
- SONAR_TOKEN có đúng không
- Project key có đúng không
- Coverage files có được tạo không

## Debug commands

### Local test
```bash
# Test coverage locally
dotnet test MovieTheater.Tests --collect:"XPlat Code Coverage" --results-directory "TestResults"

# Check coverage files
Get-ChildItem -Path TestResults -Recurse -Filter "*.xml"
```

### GitHub Actions logs
```bash
# Xem logs trong GitHub Actions
# Actions > [Workflow] > [Job] > [Step]
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
- `.github/workflows/test-coverage.yml` - Test coverage cơ bản
- `.github/workflows/sonarqube-with-coverage.yml` - SonarQube integration

### Configuration:
- `sonar-project.properties` - SonarQube config
- `MovieTheater.Tests.csproj` - Test project config

## Liên kết hữu ích

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [SonarCloud Documentation](https://docs.sonarcloud.io/)
- [Coverlet Documentation](https://github.com/coverlet-coverage/coverlet) 