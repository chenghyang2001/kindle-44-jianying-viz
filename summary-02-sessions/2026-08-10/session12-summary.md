# Session 12 — 2026-08-10

## 完成事項

- **執行 `/resume-session`，接續 Session 11 交接**：讀取 `session11-summary.md` 的 HANDOFF 區塊並簡報給使用者（立即行動3項、進行中的CapCut專案狀態、注意事項），交叉比對 `.claude/session-state.md` 確認無未記錄的落差。使用者選擇先處理「更新 skill 預設行為」這項。
- **更新全域 skill `capcut-chapter-livedemo` 的螢幕錄影預設值**：呼應 Session 11 使用者的永久性指示（螢幕錄影從預設開啟改為預設關閉），修改了 `~/.claude/skills/capcut-chapter-livedemo/SKILL.md` 的 5 處：frontmatter description、「四個已確認的預設行為」第3點（並加註 2026-08-10 更新歷史）、Phase 2 步驟5（建立留存資料夾但不錄影）、Phase 4 步驟1（整理留存檔案不含停止錄影）、步驟3（回報位置只含筆記路徑）。因為是 `.md` 檔案，依鐵律豁免清單直接編輯，不需走 code-writer/QA/reviewer 三 agent 流程。
- **查證剪映（CapCut）草稿格式/路徑/分享/範本/版控相關問題**：使用者用語音輸入問了 5 個問題（部分因語音辨識誤植需要來回確認，如「城市」實為「程式」的同音誤植），派 subagent 上網查證（非憑訓練記憶回答，遵循既有記憶規則 `capcut_ui_feature_verify_before_answer.md`）。查證結果：
  1. 草稿是 JSON 資料夾（`draft_content.json` + `draft_meta_info.json`），路徑因版本而異，需用剪映內建功能實測確認
  2. 檔案加密與否查到互相矛盾的說法（新舊版本不同），需使用者自行打開確認
  3. 官方沒有直接編輯剪映內建範本的功能，只能「剪同款」替換素材，自製範本需創作者 Lv.5 資格
  4. 剪映雲空間支援跨裝置接續編輯但不支援多人即時共編；分享到 Google Drive/OneDrive 給他人協作沒查到官方支援
  5. 沒查到類似 Git 的正式版本控制系統，只有撤銷步數限制與「恢復草稿備份」隱藏功能
- **使用者截圖分析，現場發現介面本身有「分享」按鈕**（比查到的網路資料更準確），且確認截圖中的 CapCut 專案就是 Session 11 交接的「視覺定調-圖層混合文字錯位」專案，Module 2 技法5 蒙版推屏卡點狀態與交接記錄吻合（遮罩形狀圖示全灰未選取）。
- **產生一份彙整筆記，同步三管道通知**：把上述剪映查證結果 + Session 11 交接摘要寫成 `doc/claude筆記-剪映草稿與交接摘要-2026-08-10.md`，用 `gws gmail users messages send` 寄到 <chenghyang2001@gmail.com>（message id `19fe86f100fde3af`），用環境變數裡現成的 `TELEGRAM_BOT_TOKEN`/`TELEGRAM_CHAT_ID` 直接呼叫 Telegram Bot API 送出摘要通知（message id 843）。已 commit + push（commit `360ccba`）。
- **CapCut 桌面自動化實測「新增預設文字」＋改內容為 Hello World**：查證剪映最簡單的文字範本是「文字」分頁下的「預設文字」（零樣式空白文字框，區別於已有動畫效果的「文字範本」庫）。用 `win32gui`/`ctypes` 找到 CapCut 主視窗（一個全新未命名專案「0810」）、點擊「文字」分頁、hover 卡片喚出「+」號插入時間軸、把內容改成「Hello World」並成功套用、驗證截圖確認。**過程中發現兩次自動化輸入不穩定的踩坑**（見下方關鍵技術筆記），最終在清理過程中把片段長度從 3 秒意外縮到約 0.4 秒，使用者中斷收工前的 AskUserQuestion（要不要拉回3秒），決定直接收工，這部分留待下次接續。

## 關鍵技術筆記

- **CapCut 文字輸入：`SendInput` + `KEYEVENTF_UNICODE` 直接打字會靜默失敗**（畫面完全沒反應，連錯誤都不報），改用「PowerShell `Set-Clipboard` 設剪貼簿 → `Ctrl+A` 全選 → `Ctrl+V` 貼上」的方式才成功套用文字內容，即使是純 ASCII 英文（`Hello World`）也一樣要走剪貼簿貼上，不能單純模擬鍵盤輸入。這點會更新進 `capcut_narration_params.md` 或新增獨立記憶。
- **CapCut（本機這台機器 Yama-Desktop）是 Qt 應用但不吐出 UIAutomation tree**：用 `pywinauto Application(backend='uia').connect(handle=hwnd).window(handle=hwnd).descendants()` 只回傳 3 個 `Window` 型別的節點（沒有任何 `Edit`/`Button` 等控制項），代表這個視窗整個畫面是自繪（canvas-based rendering），UIAutomation 這條路完全走不通，只能靠座標點擊 + 截圖驗證這種暴力流程，不像 `windows-desktop-automation.md` 文件裡 Telegram Desktop 那樣能透過 Accessibility Tree 精準操作。
- **誤觸連鎖反應的根因推測**：第一次用 `SendInput unicode` 打字失敗時，那些按鍵事件很可能沒有真的「什麼都沒發生」，而是被 CapCut 當成快捷鍵吃掉（因為當時 focus 可能不在文字輸入框內），累積效果是造成文字片段被重複貼上兩次（變成 3 個相同片段）+ 連續套用了好幾層不同的「花字」裝飾樣式。用 `Ctrl+Z`（一次 1 次、再一次 10 次連按）逐步撤銷回到單一乾淨片段的狀態，但連帶把片段長度從 3 秒撤銷回到約 0.4 秒（因為「插入 3 秒預設文字」這個動作本身也在被撤銷的歷史範圍內，撤销撤過頭了一點點）。這證實了先前記憶 `capcut_editing_techniques.md` 提過的踩坑：CapCut 的 Undo/Redo 歷史記錄容易搞混，操作後應立即小範圍截圖驗證，不要連續做多個動作才驗證——這次踩坑正是因為第一次打字失敗後沒有立刻截圖確認，隔了一段對話（查證剪映範本問題、寄信、發 Telegram）才回頭看畫面，中間累積的誤觸已經來不及回溯精確步驟。
- **剪映草稿實際路徑（本機 Yama-Desktop，CapCut 國際版桌面版，非剪映 JianyingPro 中國版）**：`C:/Users/user/AppData/Local/CapCut/User Data/Projects/com.lveditor.draft/<專案資料夾名>`，可在編輯器右側「詳細資料」面板直接看到（不用去猜路徑），這條是本次網路查證後用使用者截圖驗證過的第一手 ground truth，比網路上查到的兩種猜測路徑都準確。

## 關鍵決定

- 使用者確認「Halowa」/「HAIloude」是語音輸入誤轉自英文「Hello World」（程式設計慣用語「最簡單的起始範例」的意思），不是某個專有名詞範本名稱，避免了誤查方向。
- 使用者中斷本次 CapCut 自動化收尾（片段長度修復的 AskUserQuestion），直接要求收工，片段長度修復與「0810」專案改名兩件事都留到下次 session 處理，不在本次勉強做完。

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `~/.claude/skills/capcut-chapter-livedemo/SKILL.md` | 全域 skill，螢幕錄影預設值改為預設關閉（5處修改） |
| `doc/claude筆記-剪映草稿與交接摘要-2026-08-10.md` | 剪映查證結果 + Session 11 交接摘要，已 commit `360ccba`，已寄 Gmail + Telegram |
| `summary-02-sessions/2026-08-10/session12-summary.md` | 本檔 |

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 修復 CapCut 專案「0810」裡「Hello World」文字片段的長度：目前被意外的 Undo 清理過程縮到約 0.4 秒（00:00:00:12），原本插入時是 3 秒（00:00:03:00）。建議用滑鼠拖曳片段右邊緣手動拉長，不要再用鍵盤模擬（這個視窗這次連續踩了兩次鍵盤自動化的坑）。修好後再幫使用者把專案從預設名稱「0810」改名成「Hello-World」（使用者在對話尾聲明確提出的改名請求，因片段長度問題被中斷還沒做）
- [ ] 接續 Session 11 遺留的 Module 2 技法5「蒙版推屏」卡點（另一個專案「視覺定調-圖層混合文字錯位」）：線性蒙版套用後預覽畫面沒有可拖曳控制點，推測是還沒點選遮罩形狀圖示，下次可先試點選看看
- [ ] CapCut 桌面自動化下次遇到需要輸入文字的情境，直接採用本次驗證過的「剪貼簿貼上」流程（`Set-Clipboard` → `Ctrl+A` → `Ctrl+V`），不要再嘗試 `SendInput unicode` 直接打字（已確認在這台機器/這個 CapCut 版本上會靜默失敗且有誤觸快捷鍵的風險）

### 進行中（需接續）

- CapCut 專案「0810」：時間軸上只有 1 個「Hello World」純文字片段（白色基礎樣式，無花俏效果），內容正確，但長度異常短（0.4秒），專案名稱還沒改。這是一個全新的、獨立於「視覺定調-圖層混合文字錯位」之外的示範用小專案。
- CapCut 專案「視覺定調-圖層混合文字錯位」：狀態與 Session 11 交接時相同，未在本次 session 繼續動它。

### 注意事項

- 本次驗證了「CapCut 這個視窗不吐出 UIAutomation tree」（`pywinauto` 的 `descendants()` 只回傳 3 個 Window 節點），意味著這個應用的桌面自動化**只能靠座標點擊 + 每一步立刻截圖驗證**，不能像 Telegram Desktop 那樣用 Accessibility Tree 精準定位元素。下次做任何 CapCut 自動化都要記得這點，每個關鍵動作後都要截圖確認，不要連續做兩個以上動作才回頭看畫面（這正是本次誤觸連鎖沒被及時發現的原因）。
- 使用量狀態：本次 session 開始與過程中都持續看到「週用量 ~249%」的警告，遠超配額，且 session jsonl 已達 3.3MB 觸發建議 compact/開新 session 的提示。這已經是連續第二個 session 看到超額警告，建議下次跟使用者確認是否要調整近期的使用節奏（減少長 session 或降低截圖/自動化操作頻率）。
- 剪映查證結果中，「分享」按鈕的實際行為（點下去會跳出什麼選項）仍未實測，只是在截圖中確認按鈕存在，下次若使用者想繼續深入了解分享/協作功能，建議直接請他點開這個按鈕截圖，比再查网路資料準確。
