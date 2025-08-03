# Hướng dẫn Setup SONAR_TOKEN

## 🔑 **Vấn đề hiện tại:**
SonarQube workflows đang fail vì **SONAR_TOKEN không được cấu hình đúng**.

## 📋 **Bước 1: Kiểm tra Token hiện tại**

### Từ SonarCloud:
1. Vào [SonarCloud](https://sonarcloud.io)
2. Click vào **Account** (góc trên bên phải)
3. Chọn **Security**
4. Kiểm tra token `github-actions-token`:
   - **Name:** github-actions-token
   - **Last use:** < 1 hour ago
   - **Created:** 14 July 2025

## 📋 **Bước 2: Copy Token Value**

1. Click vào token `github-actions-token` (màu xanh)
2. Copy token value được hiển thị
3. **Lưu ý:** Token chỉ hiển thị 1 lần, nếu không thấy thì cần tạo mới

## 📋 **Bước 3: Tạo Token mới (nếu cần)**

Nếu không thấy token value:
1. Vào **Security** → **Generate Tokens**
2. Nhập tên: `github-actions-token-v2`
3. Click **Generate Token**
4. Copy token value

## 📋 **Bước 4: Thêm vào GitHub Secrets**

1. Vào GitHub repository
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. **Name:** `SONAR_TOKEN`
5. **Value:** Paste token từ SonarCloud
6. Click **Add secret**

## 📋 **Bước 5: Test Token**

Sau khi thêm token:
1. Vào **Actions** tab
2. Tìm workflow **"Test SONAR_TOKEN"**
3. Kiểm tra kết quả:
   - ✅ **SUCCESS:** Token được cấu hình đúng
   - ❌ **FAILED:** Token có vấn đề

## 🔧 **Workflows hiện tại:**

### ✅ **Đã hoạt động:**
- **`.NET Build & Publish`** - Build cơ bản

### ❌ **Đang fail:**
- **`SonarQube Analysis`** - Cần SONAR_TOKEN
- **`Debug SonarQube`** - Cần SONAR_TOKEN
- **`Test SonarQube`** - Cần SONAR_TOKEN

## 🎯 **Bước tiếp theo:**

Sau khi setup SONAR_TOKEN:
1. **Commit và push** để trigger workflows
2. **Kiểm tra Actions** để xem kết quả
3. **Kiểm tra SonarCloud** để xem analysis

## 📞 **Hỗ trợ:**

Nếu vẫn gặp vấn đề:
1. Kiểm tra **GitHub Actions logs** để xem lỗi chi tiết
2. Kiểm tra **SonarCloud project** có tồn tại không
3. Kiểm tra **Project key** trong workflow configuration 