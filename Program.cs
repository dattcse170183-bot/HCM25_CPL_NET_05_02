﻿using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using MovieTheater.Hubs;
using MovieTheater.Models;
using MovieTheater.Repository;
using MovieTheater.Service;
using System.Text;

namespace MovieTheater
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Database
            builder.Services.AddDbContext<MovieTheaterContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

            // JWT Settings
            builder.Services.Configure<JwtSettings>(builder.Configuration.GetSection("JwtSettings"));
            builder.Services.AddScoped<IJwtService, JwtService>();

            var jwtSettings = builder.Configuration.GetSection("JwtSettings").Get<JwtSettings>();
            var key = Encoding.UTF8.GetBytes(jwtSettings.SecretKey);

            // Authentication
            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidIssuer = jwtSettings.Issuer,
                    ValidateAudience = true,
                    ValidAudience = jwtSettings.Audience,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.Zero
                };

                options.Events = new JwtBearerEvents
                {
                    OnMessageReceived = context =>
                    {
                        context.Token = context.Request.Cookies["JwtToken"];
                        return Task.CompletedTask;
                    }
                };
            });

            builder.Services.AddAuthentication(options =>
            {
                options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;

                //code dưới sẽ khiến middleware challenge bằng Google OAuth thay vì chuyển hướng về trang login nội bộ
                //options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;

            })
            .AddCookie(options =>
            {
                options.LoginPath = "/Account/Login";
                options.LogoutPath = "/Account/Logout";
                options.AccessDeniedPath = "/Account/AccessDenied";
                options.ExpireTimeSpan = TimeSpan.FromMinutes(60);
                options.Cookie.Name = "MovieTheater.Auth";
                options.Cookie.HttpOnly = true;
                options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                options.Cookie.SameSite = SameSiteMode.Lax;
                options.SlidingExpiration = true;
            })
            .AddGoogle(options =>
            {
                IConfigurationSection googleAuthNSection = builder.Configuration.GetSection("Authentication:Google");
                options.ClientId = googleAuthNSection["ClientId"];
                options.ClientSecret = googleAuthNSection["ClientSecret"];
                options.CallbackPath = "/signin-google";
            });


            builder.Services.AddScoped<IAccountRepository, AccountRepository>();
            builder.Services.AddScoped<IAccountService, AccountService>();
            builder.Services.AddScoped<IMovieRepository, MovieRepository>();
            builder.Services.AddScoped<IMovieService, MovieService>();
            builder.Services.AddScoped<ICinemaRepository, CinemaRepository>();
            builder.Services.AddScoped<ICinemaService, CinemaService>();
            builder.Services.AddScoped<IEmployeeRepository, EmployeeRepository>();
            builder.Services.AddScoped<IEmployeeService, EmployeeService>();
            builder.Services.AddScoped<IMemberRepository, MemberRepository>();
            builder.Services.AddScoped<IBookingService, BookingService>();
            builder.Services.AddScoped<IPromotionRepository, PromotionRepository>();
            builder.Services.AddScoped<IPromotionService, PromotionService>();
            builder.Services.AddScoped<ISeatRepository, SeatRepository>();
            builder.Services.AddScoped<ISeatService, SeatService>();
            builder.Services.AddScoped<ISeatTypeRepository, SeatTypeRepository>();
            builder.Services.AddScoped<ISeatTypeService, SeatTypeService>();
            builder.Services.AddScoped<IEmailService, EmailService>();
            builder.Services.AddScoped<ICoupleSeatRepository, CoupleSeatRepository>();
            builder.Services.AddScoped<ICoupleSeatService, CoupleSeatService>();
            builder.Services.AddScoped<IVNPayService, VNPayService>();
            builder.Services.AddScoped<IInvoiceRepository, InvoiceRepository>();
            builder.Services.AddScoped<IInvoiceService, InvoiceService>();
            builder.Services.AddScoped<IScheduleSeatRepository, ScheduleSeatRepository>();
            builder.Services.AddScoped<IScheduleRepository, ScheduleRepository>();
            builder.Services.AddScoped<MovieTheater.Repository.IRankRepository, MovieTheater.Repository.RankRepository>();
            builder.Services.AddScoped<MovieTheater.Service.IRankService, MovieTheater.Service.RankService>();
            builder.Services.AddScoped<IVoucherRepository, VoucherRepository>();
            builder.Services.AddScoped<IVoucherService, VoucherService>();
            builder.Services.AddScoped<IPointService, PointService>();
            builder.Services.AddScoped<IScoreService, ScoreService>();
            builder.Services.AddScoped<IPaymentSecurityService, PaymentSecurityService>();
            builder.Services.AddScoped<IBookingDomainService, BookingDomainService>();
            builder.Services.AddScoped<IBookingPriceCalculationService, BookingPriceCalculationService>();
            builder.Services.AddScoped<ITicketVerificationService, TicketVerificationService>();
            builder.Services.AddSignalR(); //ADD SignalR
            builder.Services.AddScoped<IFoodRepository, FoodRepository>();
            builder.Services.AddScoped<IFoodService, FoodService>();
            builder.Services.AddScoped<IVersionRepository, VersionRepository>();
            builder.Services.AddScoped<IFoodInvoiceRepository, FoodInvoiceRepository>();
            builder.Services.AddScoped<IFoodInvoiceService, FoodInvoiceService>();
            builder.Services.AddScoped<ITicketService, TicketService>();
            builder.Services.AddScoped<IVersionRepository, VersionRepository>();
            builder.Services.AddScoped<IPersonRepository, PersonRepository>();
            builder.Services.AddScoped<IDashboardService, DashboardService>();

            builder.Services.Configure<VNPayConfig>(
             builder.Configuration.GetSection("VNPay")
                );
            
            builder.Services.Configure<QRPaymentConfig>(
             builder.Configuration.GetSection("QRPayment")
                );
            
            builder.Services.AddScoped<IQRPaymentService, QRPaymentService>();
            builder.Services.AddScoped<IGuestInvoiceService, GuestInvoiceService>();
            builder.Services.AddHostedService<CinemaAutoEnableService>();

            builder.Services.AddHttpContextAccessor();

            // Add session support for rank-up notifications and TempData
            builder.Services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromMinutes(30);
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
            });

            builder.Services.AddControllersWithViews();

            var app = builder.Build();

            // Middleware
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseRouting();
            app.UseSession(); // Enable session before authentication/authorization

            // Thêm middleware kiểm tra bảo mật thanh toán
            app.UseMiddleware<MovieTheater.Middleware.PaymentSecurityMiddleware>();

            app.UseAuthentication();
            app.UseAuthorization();

            // Prevent caching redirects
            app.Use(async (context, next) =>
            {
                await next();
                if (context.Response.StatusCode == 302)
                {
                    if (!context.Response.Headers.ContainsKey("Cache-Control"))
                        context.Response.Headers.Add("Cache-Control", "no-cache, no-store");
                    if (!context.Response.Headers.ContainsKey("Pragma"))
                        context.Response.Headers.Add("Pragma", "no-cache");
                }
            });

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.MapControllerRoute(
                name: "seat",
                pattern: "Seat/{action}/{id?}",
                defaults: new { controller = "Seat", action = "Select" });

            app.MapHub<ChatHub>("/chathub"); //Tuyen duong cho hub
            app.MapHub<SeatHub>("/seathub"); //Tuyen duong cho hub
            app.MapHub<DashboardHub>("/dashboardhub"); //Tuyen duong cho hub
            app.MapHub<CinemaHub>("/cinemahub"); //Tuyen duong cho hub

            app.Run();
        }
    }
}
