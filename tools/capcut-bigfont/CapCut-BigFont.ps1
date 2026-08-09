<#
CapCut 大字版啟動腳本

用途：透過設定 QT_SCALE_FACTOR 與 QT_FONT_DPI 這兩個 Qt 環境變數，
      讓 CapCut（Qt 開發的桌面應用）介面整體放大顯示，
      方便在高解析度螢幕上操作或錄製教學影片時看得更清楚。

背景：CapCut-大字版.bat（cmd.exe 批次檔）曾因中文字元的 Big5/cp950 第二位元組
      剛好等於 cmd.exe 的管線符號「|」，被解析器誤判導致指令從中間被切斷。
      這是 cmd.exe 批次檔處理雙位元組中文字的已知經典陷阱，無法靠「避開幾個
      危險字」根治。因此把含中文邏輯的部分整個搬到這支 PowerShell 腳本，
      PowerShell 剖析器沒有這種 DBCS 陷阱，可以放心使用繁體中文。

注意：QT_SCALE_FACTOR / QT_FONT_DPI 用 $env: 設定，只在本次啟動的
      PowerShell process 及其後續啟動的子行程（CapCut.exe）中生效，
      不會寫入系統全域環境變數，不影響其他程式或下次開機。
#>

# ---- 可調整設定區 ----
# 縮放比例：1.0 為原始大小，數字越大介面元件越大
$ScaleFactor = "1.25"
# 字體 DPI：Windows 預設約 96，調高可讓文字額外放大
$FontDpi = "120"
# ----------------------

# 不可寫死使用者名稱，一律用環境變數組出安裝路徑，確保跨機器（公司機／家用機）都能執行
$AppPath = "$env:USERPROFILE\AppData\Local\CapCut\Apps\CapCut.exe"

Write-Host "目前設定：縮放比例 = $ScaleFactor，字體 DPI = $FontDpi"

# 先確認 CapCut.exe 真的存在，避免設完環境變數後才發現路徑錯誤
if (-not (Test-Path -LiteralPath $AppPath)) {
    Write-Host "[錯誤] 找不到 CapCut.exe"
    Write-Host "預期路徑：$AppPath"
    Write-Host "請確認 CapCut 是否已安裝於此路徑，或自行修改本檔案開頭的 AppPath 設定值。"
    exit 1
}

# 設定環境變數（僅本 process 及其子行程有效，不污染系統全域設定）
$env:QT_SCALE_FACTOR = $ScaleFactor
$env:QT_FONT_DPI = $FontDpi

Write-Host "正在啟動 CapCut，請稍候..."

try {
    Start-Process -FilePath $AppPath
}
catch {
    Write-Host "[錯誤] 啟動 CapCut 失敗：$($_.Exception.Message)"
    exit 1
}

Write-Host "[成功] CapCut 已使用放大介面設定啟動，這個視窗可以關閉。"
exit 0
