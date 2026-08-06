# CapCut 練習專案 — 交接文件

給下一個 session（不論是這台 PC 還是家用機）快速接續用。目標：不用重新摸索，直接從目前進度往下做。

## 這個專案是什麼

Kindle 書 44《剪映：剪出新視野》的視覺化＋實作練習專案。

- 本 repo（`kindle-44-剪映`）原本是 `book-viz-pack` skill 產出的 5 張心智圖 + PPTX 合輯，後來擴充成「CapCut 實戰特訓」：
  - `mermaid/剪映/` — 5 張心智圖 `.mmd`/`.png` + 圖表合輯 PPTX
  - `slide-deck/` — 15 章節投影片，**副檔名是 `.pptx` 但實際內容是 PDF**（NotebookLM harvest 腳本命名遺留問題），要用 PyMuPDF（`fitz`）開，不能用 `python-pptx`
  - `CLAUDE.md` — 專案架構說明
- 課程 Artifact（24 堂互動課程 + 進度追蹤 + 實測踩坑筆記）：
  **<https://claude.ai/code/artifact/fc20a1d8-c2c7-4d63-978a-bfa22c6522b1>**
  這是把 15 章內容改編成 CapCut Web/桌面版的 7 階段 24 堂練習，網頁本身是深色「調色室」風格，用 Big Shoulders Display + JetBrains Mono 字體（base64 內嵌），進度存在瀏覽器 localStorage（換瀏覽器/PC 不會保留，要手動重新勾）。

## 帳號 / 訂閱狀態（截至本次收工）

- CapCut 帳號：已在 capcut.com 用註冊完成（Google / email，視當初操作而定，實際帳號資訊使用者自行確認）
- **CapCut Pro：已購買**（桌面版右上角會顯示「Pro」徽章）
- 桌面版：已透過 `winget install --id ByteDance.CapCut -e --accept-package-agreements --accept-source-agreements` 裝在**這台** PC。換 PC 要重裝，見下方「換新 PC 時」章節。

## 目前進度：Stage 0-2 已完成 Live Demo

在 CapCut 桌面版建了一個練習專案（名稱 `0806`，9:16 比例），走過：

| Stage | Lesson | 做了什麼 | 結果 |
| --- | --- | --- | --- |
| 0 | 帳號與環境 | 註冊 CapCut Web 帳號、認識工作區 | 完成 |
| 1.1 | 建立專案 + 設定比例 | 新建專案，長寬比例 原圖→9:16 | 完成 |
| 1.2 | 匯入素材 | 從內建免版稅資料庫加入素材 | 完成 |
| 1.3 | 時間軸手感 | （示範於分割步驟中一併完成） | 完成 |
| 1.4 | 分割與無縫刪除 | 00:00:14:26 處分割，刪除右段確認 ripple delete（30s→14:26 無縫接合） | 完成 |
| 1.5 | 匯出第一支測試片 | 踩到 Pro 限制 + 版權「未編輯」限制兩個坑，換成免費素材+加濾鏡/文字後成功匯出 1080P mp4 | 完成 |
| 2.1 | 精準剪輯點微調 | 方向鍵逐格移動播放頭（00:05:17→00:05:22，5 幀） | 完成 |
| 2.2 | 素材屬性調整 | 速度 1.00x→1.50x（時長 15.4s→10.3s），套用「漸隱閉幕」退場動畫做淡出 | 完成 |
| 2.3 | 多軌排版做子母畫面 | 免費素材拖到新軌、與主素材時間重疊、縮放 40%、Y 位移 -650 | 完成 |

**草稿本機路徑**（僅供除錯參考，換 PC 不會自動出現）：
`C:\Users\B00332\AppData\Local\CapCut\User Data\Projects\com.lveditor.draft\0806`

## 待辦：Stage 3-6（16 堂課，尚未 demo）

| Stage | Lessons | 內容 |
| --- | --- | --- |
| 3 聲音節奏與字幕包裝 | 3.1-3.4 | 音訊降噪淡入淡出、節奏踩點、自動字幕、花字貼紙動畫 |
| 4 視覺特效與調色 | 4.1-4.4 | 特效轉場、濾鏡調節、LUT 調色、蒙版去背合成 |
| 5 關鍵幀動態 | 5.1-5.3 | 關鍵幀基本運鏡、文字消散進階組合、動態運鏡挑戰 |
| 6 綜合實戰與正式輸出 | 6.1-6.3 | 12 大特效技法命題實作、正式導出設定、素材管理疑難排解 |

具體每堂課的目標/步驟/書中對應章節，看課程 Artifact 網頁即可，不用重複貼在這裡。

## 換新 PC（家用機／另一台公司機）時的啟動步驟

1. `git pull` 這個 repo，確認 `CLAUDE.md`、`slide-deck/`、`mermaid/剪映/` 都在
2. 安裝 CapCut 桌面版：

   ```bash
   winget install --id ByteDance.CapCut -e --accept-package-agreements --accept-source-agreements
   ```

3. 啟動 CapCut，用同一組帳號登入 → 因為 Pro 是綁帳號不是綁機器，登入後應該直接生效，不用重買
4. **草稿不會跨機同步**（除非有開草稿雲端備份且該素材有上傳）。新 PC 上兩個選項：
   - 直接跳去做 Stage 3，不補做 Stage 0-2（推薦，Stage 0-2 已經在這份文件記錄完成，course artifact 上也可以手動勾選）
   - 想要有實體草稿可以操作的話，花 10 分鐘照 Stage 1.1-1.2 重新建一個空專案＋隨便丟一個免費素材進去即可，不用重跑整個 demo
5. 打開課程 Artifact 網址，把 Stage 0-2 的 lesson checkbox 手動勾起來（localStorage 不跨機，這步是必要的）

## 給 Claude 的操作要點（桌面版自動化技術細節）

沿用 `~/.claude/instructions/windows-desktop-automation.md` 的 pywin32 + pywinauto 套路，但 CapCut 桌面版是 canvas 渲染（UIAutomation 抓不到細節元件），實際上是用「螢幕座標點擊」而非 accessibility tree，額外要注意：

- **DPI 感知必開**：多螢幕環境下，Python 若沒呼叫 `ctypes.windll.shcore.SetProcessDpiAwareness(2)`，`win32gui.GetWindowRect()` 回傳的座標會跟 `ImageGrab` 實際截到的像素對不上（座標會隨著滑鼠最後停留的螢幕 DPI 而漂移）。**每個腳本開頭都要設**。
- **截圖用 `PIL.ImageGrab.grab(bbox=rect, all_screens=True)`**，不要用 `pyautogui.screenshot()`（後者只截主螢幕，多螢幕環境下 CapCut 視窗如果在副螢幕會整張黑圖）。
- **CapCut 會開很多個同名「CapCut」隱藏視窗**（helper process），篩選時用 `win32gui.IsWindowVisible(hwnd) and rect 面積夠大` 排除雜訊，主編輯器窗通常是最大的那個 visible window。
- **素材庫 Pro 判斷**：縮圖左上角有紫色鑽石標記 = Pro 專屬素材，免費帳號可預覽/拖進時間軸但無法匯出（本 PC 已買 Pro，不用再迴避，但换到未購買 Pro 的帳號上要記得繞開）。
- **匯出前置條件**：即使素材免費，完全沒編輯過也無法匯出（版權保護機制），至少要加一個濾鏡或文字圖層才會被判定「已編輯」。
- **多軌 PIP 技巧**：新素材預設會接在同軌尾端，要疊成子母畫面必須拖到「時間上與既有素材重疊 + 垂直方向的空白軌道區」，系統才會自動建新軌。
- **CJK 文字輸入**：`pyautogui.typewrite()` 打繁體中文字會變亂碼（掃描碼機制，跟 `windows-desktop-automation.md` 記錄的 Telegram 案例同一個成因）。如果要打乾淨的中文字，改用剪貼簿貼上法（`Set-Clipboard` + `Ctrl+V`），不要用模擬鍵盤逐字打。

## 相關連結

- 課程 Artifact：<https://claude.ai/code/artifact/fc20a1d8-c2c7-4d63-978a-bfa22c6522b1>
- GitHub repo：<https://github.com/chenghyang2001/kindle-44-jianying-viz>
- CapCut 官網：<https://www.capcut.com>

## 起手 Prompt（開新 session 時直接貼這段）

在任何一台已經 `git clone`／`git pull` 過這個 repo 的 PC 上，用 Claude Code CLI 在專案目錄下開新 session，貼這段：

```
讀 doc/交接文件-capcut-practice.md，接續 CapCut 練習專案。
Stage 0-2 已經 live demo 完成，現在要繼續 Stage 3（聲音節奏與字幕包裝，Lesson 3.1-3.4）。
如果這台 PC 還沒裝 CapCut 桌面版，先幫我裝好、開好、確認 Pro 帳號登入狀態；
如果已經裝好，直接開啟或新建一個練習專案，照課程 Artifact 上 Stage 3 的每堂課內容，
一樣用截圖＋自動點擊的方式邊做邊示範給我看，做完一堂就回報結果再繼續下一堂。
```

這段 prompt 的設計重點：

- 第一句強制 Claude 先讀交接文件，不用重新猜專案背景
- 第二句明確給「現在要做哪個 Stage」，避免 Claude 從頭重跑 Stage 0-2 浪費時間
- 第三句涵蓋「新 PC 沒裝過」跟「已裝過」兩種情境，Claude 可以自己判斷分支
- 最後一句延續本次 session 已經驗證過的「截圖＋自動點擊＋逐堂回報」demo 節奏，不用重新講一次要怎麼操作
