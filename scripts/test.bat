@echo off
echo ========================================
echo   Pill Line AI - Test Runner
echo ========================================

:menu
echo.
echo Choose an option:
echo 1. Run all tests
echo 2. Run tests with watch mode
echo 3. Build mocks only
echo 4. Build mocks with watch mode
echo 5. Clean and rebuild mocks
echo 6. Full clean and rebuild
echo 7. Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto run_tests
if "%choice%"=="2" goto run_tests_watch
if "%choice%"=="3" goto build_mocks
if "%choice%"=="4" goto build_mocks_watch
if "%choice%"=="5" goto clean_mocks
if "%choice%"=="6" goto full_clean
if "%choice%"=="7" goto exit
goto menu

:run_tests
echo.
echo Running all tests...
flutter test
echo.
pause
goto menu

:run_tests_watch
echo.
echo Running tests in watch mode...
echo Press Ctrl+C to stop
flutter test --watch
goto menu

:build_mocks
echo.
echo Building mocks...
flutter pub run build_runner build
echo.
pause
goto menu

:build_mocks_watch
echo.
echo Building mocks in watch mode...
echo Press Ctrl+C to stop
flutter pub run build_runner watch
goto menu

:clean_mocks
echo.
echo Cleaning mocks...
flutter pub run build_runner clean
echo Building mocks...
flutter pub run build_runner build
echo.
pause
goto menu

:full_clean
echo.
echo Full clean and rebuild...
flutter clean
flutter pub get
flutter pub run build_runner build
echo.
pause
goto menu

:exit
echo Goodbye!
exit 