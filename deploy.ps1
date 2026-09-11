Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   Clarity Workspace - Vercel Deployment" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Ensuring latest Flutter web build..." -ForegroundColor Yellow
flutter build web
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Flutter build failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host ""
Write-Host "2. Deploying to Vercel..." -ForegroundColor Yellow
npx --yes vercel --prod
Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host "   Deployment finished! Check the URL above." -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green
