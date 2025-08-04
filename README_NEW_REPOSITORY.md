# Movie Theater Management System

## 📋 Mô tả
Hệ thống quản lý rạp chiếu phim với đầy đủ tính năng booking, payment, và admin management.

## 🚀 Tính năng chính
- **User Management**: Đăng ký, đăng nhập, quản lý profile
- **Movie Booking**: Đặt vé xem phim với seat selection
- **Payment Integration**: Tích hợp VNPay, QR Payment
- **Admin Dashboard**: Quản lý phim, rạp, nhân viên
- **Real-time Features**: Chat, seat booking real-time
- **Code Quality**: SonarQube integration với 49.35% coverage

## 🛠️ Tech Stack
- **Backend**: ASP.NET Core 8.0
- **Database**: Entity Framework Core
- **Testing**: xUnit, Moq
- **Code Quality**: SonarQube, Coverlet
- **Frontend**: Razor Pages, Bootstrap, jQuery
- **Real-time**: SignalR

## 📊 Code Quality Metrics
- **Coverage**: 49.35%
- **Files Analyzed**: 78
- **Test Projects**: MovieTheater.Tests
- **Static Analysis**: SonarQube integration

## 🚀 Setup Instructions

### Prerequisites
- .NET 8.0 SDK
- Visual Studio 2022 hoặc VS Code
- SQL Server (LocalDB hoặc SQL Server Express)

### Installation
1. **Clone repository**
   ```bash
   git clone <new-repository-url>
   cd team03
   ```

2. **Restore dependencies**
   ```bash
   dotnet restore
   ```

3. **Setup database**
   ```bash
   dotnet ef database update
   ```

4. **Run application**
   ```bash
   dotnet run
   ```

5. **Run tests**
   ```bash
   dotnet test MovieTheater.Tests
   ```

## 🧪 Testing
```bash
# Run all tests
dotnet test MovieTheater.Tests

# Run with coverage
dotnet test MovieTheater.Tests --settings coverlet.runsettings

# Run SonarQube analysis locally
.\run-sonarqube-analysis.ps1
```

## 📁 Project Structure
```
team03/
├── Controllers/          # API Controllers
├── Models/              # Entity Models
├── Repository/          # Data Access Layer
├── Service/             # Business Logic
├── ViewModels/          # View Models
├── Views/               # Razor Pages
├── MovieTheater.Tests/  # Unit Tests
├── wwwroot/             # Static Files
└── Program.cs           # Application Entry
```

## 🔧 Configuration
- **appsettings.json**: Database connection, JWT settings
- **coverlet.runsettings**: Test coverage configuration
- **run-sonarqube-analysis.ps1**: Local SonarQube analysis script

## 📈 Code Quality
- **SonarQube Integration**: Static code analysis
- **Unit Tests**: 49.35% code coverage
- **Coverage Reports**: OpenCover, Cobertura formats
- **Quality Gates**: Automated quality checks

## 🤝 Contributing
1. Create feature branch
2. Make changes
3. Run tests: `dotnet test`
4. Run SonarQube analysis: `.\run-sonarqube-analysis.ps1`
5. Create pull request

## 📞 Support
- **Repository**: [New Repository URL]
- **Documentation**: See README files in project
- **Issues**: Use GitHub Issues

---
**Last Updated**: August 2024
**Version**: 1.0.0
**Status**: Production Ready ✅ 