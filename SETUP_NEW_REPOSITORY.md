# 🚀 Setup Repository Mới

## 📋 Bước 1: Tạo Repository mới trên GitHub

1. **Đăng nhập GitHub**
2. **Click "New repository"**
3. **Đặt tên**: `movie-theater-management-system`
4. **Description**: "ASP.NET Core Movie Theater Management System with SonarQube Integration"
5. **Public/Private**: Tùy chọn
6. **Không check "Add a README"** (vì đã có sẵn)
7. **Click "Create repository"**

## 🔗 Bước 2: Thay đổi Remote URL

Sau khi tạo repository mới, thay đổi remote:

```bash
# Xem remote hiện tại
git remote -v

# Thêm remote mới
git remote add new-origin https://github.com/YOUR_USERNAME/movie-theater-management-system.git

# Hoặc thay đổi origin
git remote set-url origin https://github.com/YOUR_USERNAME/movie-theater-management-system.git
```

## 📤 Bước 3: Push lên Repository mới

```bash
# Đảm bảo đang ở nhánh mới
git checkout new-repository-setup

# Add tất cả files
git add .

# Commit changes
git commit -m "Initial setup: Movie Theater Management System with SonarQube integration"

# Push lên repository mới
git push -u new-origin new-repository-setup

# Hoặc nếu đã set-url origin
git push -u origin new-repository-setup
```

## 🔧 Bước 4: Setup GitHub Actions (Tùy chọn)

Tạo file `.github/workflows/ci.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: 8.0.x
    
    - name: Restore dependencies
      run: dotnet restore
    
    - name: Build
      run: dotnet build --no-restore
    
    - name: Test
      run: dotnet test --no-build --verbosity normal
```

## 📊 Bước 5: Setup SonarCloud (Tùy chọn)

1. **Truy cập SonarCloud**
2. **Tạo organization mới**
3. **Tạo project mới**
4. **Setup token**
5. **Thêm GitHub Actions workflow cho SonarQube**

## ✅ Bước 6: Verify Setup

```bash
# Clone repository mới
git clone https://github.com/YOUR_USERNAME/movie-theater-management-system.git
cd movie-theater-management-system

# Test build
dotnet build

# Test run
dotnet run

# Test coverage
dotnet test MovieTheater.Tests --settings coverlet.runsettings
```

## 🎯 Kết quả mong đợi

- ✅ **Repository mới** với đầy đủ code
- ✅ **README** chi tiết với setup instructions
- ✅ **49.35% coverage** từ SonarQube analysis
- ✅ **Local SonarQube script** hoạt động
- ✅ **GitHub Actions** (nếu setup)
- ✅ **SonarCloud integration** (nếu setup)

## 🔄 Migration Checklist

- [ ] Tạo repository mới trên GitHub
- [ ] Thay đổi remote URL
- [ ] Push code lên repository mới
- [ ] Setup GitHub Actions (tùy chọn)
- [ ] Setup SonarCloud (tùy chọn)
- [ ] Test build và run
- [ ] Verify SonarQube analysis
- [ ] Update documentation

---
**Lưu ý**: Repository mới sẽ không bị giới hạn billing như repository cũ! 