@echo off
echo ==============================================
echo   Clarity Workspace - Vercel Deployment
echo ==============================================
echo.
echo 1. Ensuring latest Flutter web build...
call flutter build web
if %errorlevel% neq 0 (
    echo [ERROR] Flutter build failed!
    pause
    exit /b %errorlevel%
)
echo.
echo 2. Deploying to Vercel...
echo.
call npx --yes vercel --prod
echo.
echo ==============================================
echo   Deployment finished! Check the URL above.
echo ==============================================
pause
