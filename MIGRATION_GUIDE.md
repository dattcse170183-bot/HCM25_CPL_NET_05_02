# 🚀 Migration Guide: Repository Cũ → Repository Mới

## 📊 Tình trạng hiện tại

### ❌ Repository Cũ (HCM25_CPL_NET_05_02)
- **Billing Issues**: GitHub Actions bị giới hạn
- **SonarQube**: 0% coverage do billing
- **Status**: Không thể push hoặc chạy CI/CD

### ✅ Repository Mới (movie-theater-management-system)
- **Billing**: Không bị giới hạn
- **SonarQube**: 49.35% coverage (local)
- **Status**: Sẵn sàng cho development

## 🔄 Migration Steps

### 1. Tạo Repository Mới trên GitHub
```bash
# Truy cập: https://github.com/new
# Repository name: movie-theater-management-system
# Description: ASP.NET Core Movie Theater Management System
# Public/Private: Tùy chọn
# Không check "Add README"
```

### 2. Thay đổi Remote
```bash
# Xem remote hiện tại
git remote -v

# Thêm remote mới
git remote add new-origin https://github.com/YOUR_USERNAME/movie-theater-management-system.git

# Hoặc thay đổi origin
git remote set-url origin https://github.com/YOUR_USERNAME/movie-theater-management-system.git
```

### 3. Push lên Repository Mới
```bash
# Đảm bảo đang ở nhánh setup
git checkout new-repository-setup

# Push lên repository mới
git push -u new-origin new-repository-setup

# Hoặc nếu đã set-url origin
git push -u origin new-repository-setup
```

### 4. Setup Main Branch
```bash
# Tạo main branch từ nhánh hiện tại
git checkout -b main
git push -u new-origin main

# Hoặc merge vào main
git checkout main
git merge new-repository-setup
git push -u new-origin main
```

## 🎯 Kết quả mong đợi

### ✅ Repository Mới sẽ có:
- **Đầy đủ source code** từ repository cũ
- **49.35% test coverage** (đã verify)
- **SonarQube integration** hoạt động
- **GitHub Actions** không bị giới hạn billing
- **README chi tiết** với setup instructions
- **Local SonarQube script** hoạt động

### 📈 Metrics từ Repository Cũ:
- **Coverage**: 49.35% ✅
- **Files Analyzed**: 78 ✅
- **Test Projects**: MovieTheater.Tests ✅
- **SonarQube Integration**: Working ✅

## 🔧 Setup SonarCloud (Tùy chọn)

### 1. Tạo SonarCloud Organization
- Truy cập: https://sonarcloud.io
- Tạo organization mới

### 2. Tạo Project
- Import từ GitHub repository mới
- Setup token

### 3. Thêm SonarQube Workflow
```yaml
# .github/workflows/sonarqube.yml
name: SonarQube Analysis

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  sonarqube:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
    - name: Install SonarQube Scanner
      run: dotnet tool install --global dotnet-sonarscanner
    - name: Run tests with coverage
      run: dotnet test MovieTheater.Tests --settings coverlet.runsettings
    - name: SonarQube Analysis
      run: |
        dotnet sonarscanner begin /k:"PROJECT_KEY" /o:"ORGANIZATION" /d:sonar.token="${{ secrets.SONAR_TOKEN }}"
        dotnet build
        dotnet sonarscanner end /d:sonar.token="${{ secrets.SONAR_TOKEN }}"
```

## ✅ Verification Checklist

- [ ] Repository mới được tạo trên GitHub
- [ ] Remote URL đã được thay đổi
- [ ] Code đã được push lên repository mới
- [ ] GitHub Actions workflow đã được setup
- [ ] Build và test pass trên repository mới
- [ ] SonarQube analysis hoạt động (nếu setup)
- [ ] Documentation đã được update

## 🎉 Kết quả cuối cùng

**Repository mới sẽ có:**
- ✅ **Không bị giới hạn billing**
- ✅ **49.35% code coverage**
- ✅ **78 files analyzed**
- ✅ **SonarQube integration**
- ✅ **GitHub Actions working**
- ✅ **Complete documentation**

---
**Lưu ý**: Repository cũ có thể được archive hoặc delete sau khi migration hoàn tất! 