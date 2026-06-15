@echo off
:: ==============================================================================
:: KỊCH BẢN SAO LƯU CƠ SỞ DỮ LIỆU HÀNG TUẦN (WEEKLY BACKUP SCRIPT)
:: DỰ ÁN: MAISON VIE CRM/ERP INVENTORY SYSTEM v8.0
:: ==============================================================================
:: Hướng dẫn: 
:: 1. Thay đổi thông tin kết nối Supabase PostgreSQL dưới đây.
:: 2. Đảm bảo máy chạy đã cài đặt công cụ pg_dump (thuộc bộ PostgreSQL client).
:: 3. Sử dụng Windows Task Scheduler để lập lịch chạy file .bat này tự động vào 
::    mỗi tối Chủ Nhật lúc 23:30.
:: ==============================================================================

chcp 65001 > nul
setlocal enabledelayedexpansion

echo ==============================================================================
echo BẮT ĐẦU SAO LƯU CƠ SỞ DỮ LIỆU MAISON VIE (SUPABASE)
echo ==============================================================================

:: Cấu hình kết nối Supabase (Cần cập nhật các thông số thực tế từ Supabase Dashboard)
set DB_HOST=aws-0-ap-southeast-1.pooler.supabase.com
set DB_PORT=6543
set DB_NAME=postgres
set DB_USER=postgres.xxxxxxxxxxxxxxxxxxxx
set DB_PASS=YOUR_SUPABASE_PASSWORD

:: Thiết lập đường dẫn lưu trữ file backup
set BACKUP_DIR=D:\Invenroty\backups
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
    echo [INFO] Đã tự động tạo thư mục sao lưu: %BACKUP_DIR%
)

:: Tạo tên file theo ngày tháng năm hiện tại (Format: YYYYMMDD)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set DATE_STR=%datetime:~0,8%
set BACKUP_FILE=%BACKUP_DIR%\maison_vie_backup_%DATE_STR%.sql

echo [INFO] Ngày chạy: %DATE_STR%
echo [INFO] Đang sao lưu tới file: %BACKUP_FILE%

:: Thiết lập mật khẩu tạm thời cho pg_dump để chạy tự động không hỏi mật khẩu
set PGPASSWORD=%DB_PASS%

:: Tiến hành pg_dump (Chỉ dump schema public và các bảng liên quan đến inventory)
echo [PROGRESS] Đang xuất dữ liệu từ Supabase PostgreSQL...
pg_dump -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -F c -b -v -f "%BACKUP_FILE%"

if %ERRORLEVEL% equ 0 (
    echo ==============================================================================
    echo [SUCCESS] SAO LƯU THÀNH CÔNG!
    echo [SUCCESS] File sao lưu: %BACKUP_FILE%
    echo ==============================================================================
) else (
    echo ==============================================================================
    echo [ERROR] SAO LƯU THẤT BẠI! Vui lòng kiểm tra:
    echo 1. Kết nối internet / mạng nội bộ.
    echo 2. Thông số Host, Port, Username, Password của Supabase.
    echo 3. Công cụ pg_dump đã được cài đặt và thêm vào PATH hệ thống chưa.
    echo ==============================================================================
)

:: Xóa biến môi trường chứa mật khẩu để bảo mật
set PGPASSWORD=
pause
