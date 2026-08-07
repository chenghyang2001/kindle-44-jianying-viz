# Session 2 — 2026-08-07（公司機 B00332）

## 日期

2026-08-07

## 完成事項

- 讀取 `doc/*` 全部檔案（交接文件 + Session 1 summary），確認第二輪進度：草稿 `0807-R2` Stage 1-2（8 堂課）已完成，卡在 Stage 3（素材無語音問題）
- **關鍵發現**：這台是公司機 B00332，但第二輪草稿 `0807-R2` 存在家用機（user 帳號），CapCut 草稿不跨機同步，公司機本機只有第一輪草稿 `0806`（另有更早的 `0723`）。用 `AskUserQuestion` 向使用者確認後，選擇「在這台機器新建第三輪草稿」接續排查
- 確認本機已安裝 CapCut 桌面版（`C:\Users\B00332\AppData\Local\CapCut\Apps\CapCut.exe`，版本 9.1.0.3879）、必要 Python 套件（pywin32/pywinauto/PIL）皆已就緒
- 啟動 CapCut，確認登入楊政憲帳號（2820807665）、**Pro 續訂日期 2026/08/12 有效**
- 新建第三輪草稿：CapCut 預設命名 `0807`（與家用機第一輪同名但不同機器/不同資料夾，路徑 `C:/Users/B00332/AppData/Local/CapCut/User Data/Projects/com.lveditor.draft/0807`），30fps、原圖比例；**改名嘗試失敗**（雙擊標題文字沒有進入編輯狀態）
- 在資料庫搜尋「interview talking camera」，測試候選素材 1：**"News reporter talking in studio."**（14:27 秒新聞主播棚拍）加入時間軸後選取，確認右側屬性面板只有「影片／速度／插入動畫／調整／AI風格化」5 個分頁、**沒有「音樂」分頁**——跟第二輪卡住的素材（"old senior man talks to camera"）同樣是無聲 B-roll。已用 Ctrl+Z 復原移除
- 開始測試候選素材 2（自拍講話風格、00:11 秒）過程中，CapCut 視窗被其他視窗（本機同時開多個 Claude Code CLI 分頁、WeChat 等）意外搶焦點縮到最小，用 `AttachThreadInput` + `SetForegroundWindow` API 拉回前景並確認 `IsIconic: 0`
- 使用者主動要求中止任務（「不用繼續，把目前做的事記下來」），更新交接文件 `doc/交接文件-capcut-practice.md` 新增「## 第三輪（公司機 B00332 接續嘗試）」完整章節，並同步更新專案記憶 `capcut-practice-project.md`，commit + push（commit `597b9c8`）

## 關鍵技術筆記

- **CapCut 草稿完全不跨機同步，且沒有提示**：換機器操作前務必先 `ls "$USERPROFILE/AppData/Local/CapCut/User Data/Projects/com.lveditor.draft/"` 確認本機實際有哪些草稿，不能只憑交接文件推測「應該在」
- **判斷素材是否真有語音的可靠方法**（第三輪再次驗證）：選取素材後看右側屬性面板分頁列有沒有「音樂」分頁，比畫面判斷「像不像在講話」更準確；目前累積兩支「studio/news/green screen」風格的免版稅素材都證實是無聲 B-roll，下次找素材應優先嘗試「vlog/selfie/interview response/street interview」等隨手拍風格關鍵字
- **多視窗桌面環境是這台機器（B00332）自動化的主要風險來源**：同時開多個 Claude Code CLI 分頁、WeChat、小算盤等，螢幕座標點擊/截圖至少 3 次誤觸其他視窗（誤開 CapCut 設定對話框、誤開快速鍵設定對話框、CapCut 被縮到最小切到別的 terminal）。每次操作前應重新 `EnumWindows` 確認 hwnd 仍在前景，不要沿用舊的視窗控制代碼變數
- **CapCut 專案改名（雙擊頂部標題文字）這次沒有成功**，原因未查清，之後可改試「首頁專案清單 → 右鍵縮圖 → 重新命名」路徑

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `doc/交接文件-capcut-practice.md` | 新增「第三輪（公司機 B00332 接續嘗試）」章節：機器不同步發現、已知無聲素材黑名單、下一步建議（commit `597b9c8`） |
| CapCut 草稿 `0807`（公司機 B00332） | 第三輪嘗試建立的新草稿，時間軸內容未確定（測試素材已復原刪除，第 2 支候選素材是否殘留待下次核實），路徑 `C:\Users\B00332\AppData\Local\CapCut\User Data\Projects\com.lveditor.draft\0807` |

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 開始前先確認目前在哪台機器（`whoami` + `ls` 草稿資料夾），對照交接文件決定接續家用機 `0807-R2`（第二輪）還是公司機 `0807`（第三輪）——**只需擇一接續，不用兩條都做**
- [ ] 若接續公司機 `0807`：先打開草稿實際確認時間軸目前內容（上次候選素材 2 是否成功加入未確認），再繼續找有語音的素材，避開「studio/news/green screen」關鍵字，優先試「vlog/selfie/interview response」
- [ ] 若接續家用機 `0807-R2`：直接依 Session 1 summary 的 HANDOFF 繼續（找有音樂分頁的素材、測擷取音訊/自動字幕/逐字稿）

### 進行中（需接續）

- 第二輪（家用機 `0807-R2`）Stage 1-2 已完成，卡在 Stage 3 素材選擇
- 第三輪（公司機 `0807`）僅完成草稿建立 + 測試 1 支無聲候選素材，Stage 1-2 都還沒真正重建（本次選擇跳過完整重跑，直接找 Stage 3 素材）

### 注意事項

- 兩輪草稿（`0806`、`0807-R2`）均未被本次 session 觸碰，保持原狀
- 本次 session 中止原因是使用者主動要求停止，不是功能卡死或用量超支，但本 session 結束時週用量已達 93%（257MB/275MB），下個 session 開始前建議先確認用量是否已重置
- 桌面自動化務必減少不必要的截圖次數，只在關鍵結果處驗證（延續 Session 1 的教訓）
