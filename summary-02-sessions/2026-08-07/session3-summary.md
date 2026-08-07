# Session 3 — 2026-08-07（公司機 B00332）

## 日期

2026-08-07

## 完成事項

- 刪除舊重複資料夾 `C:\Users\B00332\workspace\kindle-44-剪映`（驗證過 HEAD、remote、工作樹皆與 `kindle-44-jianying-viz` 一致後才刪除），並執行 `/rename` 將 session 改名為「研能-kindle-44-jianying-viz」
- 依使用者要求 `taskkill /F /IM CapCut.exe /T` 砍掉全部 7 個 CapCut 相關程序，隨後重新啟動 CapCut
- 用 Chrome 瀏覽器實際打開並分析使用者提供的 YouTube Shorts 短片（<https://www.youtube.com/shorts/9tnTPt5j4jc>），透過時間軸縮圖逐段 zoom 檢視畫面內容：
  - 確認影片其實是**使用者自己公司的頻道**——「addwii Clean Room 居家無塵室」，標題「守護孩子的靈感與健康！addwii 智能空氣清淨機正式上線」，33 秒，hashtag `#智能空氣管理 #智能空氣清淨機 #室內空氣品質`
  - 拆解出四段式結構：Hook 開場（黑場淡入）→ 安裝 B-roll（師傅搬運/安裝）→ 證言片段（受訪者+白底字幕框）→ 品牌收尾卡（純白 Logo）
  - 判斷技術/工具：手機直式實拍 + 剪映/CapCut 典型模板風格（黑場轉場、字幕框樣式、Logo 收尾卡），不涉及特效或動畫
- 產出並 push `doc/練習題-仿製addwii短片.md`：把範本片拆成 6 個 Lesson 練習（7.1 找有聲素材 → 7.2 Hook → 7.3 B-roll → 7.4 證言字幕 → 7.5 品牌收尾 → 7.6 配樂匯出），並設計驗收標準，其中 7.1 直接對準既有 [[capcut-practice-project]] 卡在 Stage 3 的「找不到有聲素材」問題
- 實際執行練習題 live demo（第四輪）：用 pywin32 + PIL.ImageGrab 操作公司機 B00332 上的 CapCut 桌面版，發現本機已存在一個先前未記錄的草稿 `0807-R3`（路徑 `com.lveditor.draft/0807 (2)`），選取其中「Mother and her daughter with dog in the park」素材檢查屬性面板，確認**只有 5 個分頁、沒有「音樂」分頁**——又一支無聲素材
- 因週用量已達 ~99-101%（連續觸發兩次用量警告），主動判斷比照前兩輪教訓提前收工，把發現與建議寫回 `doc/交接文件-capcut-practice.md`「第四輪」章節並 push，不悶頭繼續消耗配額

## 關鍵技術筆記

- **修正既有的「素材有沒有聲音」判斷假設**：先前只驗證過「studio/news/green screen」棚拍風格容易無聲，這次證實**連「媽媽女兒公園遛狗」這種居家生活風格素材也一樣沒有內嵌語音**。結論修正為：CapCut 免版稅素材庫「有沒有聲音」跟畫面內容類型無關，**沒有任何關鍵字篩選捷徑**，每支候選素材都必須實際加入時間軸、選取、檢查右側屬性面板分頁列有沒有「音樂」才能確定，`doc/練習題-仿製addwii短片.md` 裡「避開 studio/news、改用 vlog/selfie」的建議應視為弱訊號、不是可靠篩選法
- **YouTube Shorts 縮圖抓取技巧**：影片本身卡在 buffering 黑畫面時，改用滑鼠 hover 在播放進度條上觸發縮圖預覽 tooltip，再用 `computer` 工具的 `zoom` action 對縮圖區域截圖放大，可以在不需要影片真正播放的情況下逐段看清楚畫面內容（比反覆等待緩衝更快）
- **CapCut 桌面版視窗座標抓取要點（延續前幾輪教訓，本次再次驗證）**：`win32gui.GetWindowRect(hwnd)` 每次呼叫前後視窗尺寸可能不同（本次遇到從 1280x720 變成 1936x1056），點擊座標必須用「最新一次截圖當下」的 rect 換算，不能沿用前一次腳本算出的 offset，否則點擊會落在錯誤面板（本次因此誤觸左側文字範本面板）
- **用量守則的實際落地案例**：本 session 是連續第三次在同一個 CapCut 練習專案上因週用量逼近上限而主動停止（前兩輪也是），已經是可辨識的模式——之後啟動這類高截圖量的桌面自動化任務前，應先確認當週剩餘配額，必要時建議使用者等配額重置或另開新 session 分攤

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `doc/練習題-仿製addwii短片.md` | 新增：仿製 addwii 33 秒短片的 6 個 Lesson 練習腳本 + 驗收標準（commit `634df7c`） |
| `doc/交接文件-capcut-practice.md` | 新增「第四輪（公司機 B00332，執行練習題腳本）」章節：`0807-R3` 草稿發現、無聲素材黑名單新增第 3 筆、修正判斷法則、下一步建議（commit `517f84e`） |

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 開始前先確認週用量是否已重置（上個 session 結束時已 ~101%），避免一開始就撞牆
- [ ] 打開公司機 B00332 的草稿 `0807-R3`（路徑 `com.lveditor.draft/0807 (2)`），先看一眼目前時間軸完整內容（倒數數字 + 母女遛狗素材 + STYLE 文字片段），決定沿用或清空重做
- [ ] 繼續在 CapCut 資料庫搜尋候選素材（`interview response`／`street interview`／`talking outdoors`／`vlog` 僅供搜尋起點，**不代表一定有聲**），每支都要選取檢查「音樂」分頁，直到找到一支確認有聲的為止

### 進行中（需接續）

- `doc/練習題-仿製addwii短片.md` 的 Lesson 7.1（找有聲素材）仍未成功，7.2-7.6 完全未開始
- 已知無聲素材黑名單累積到 3 筆：`old senior man talks to camera - green screen - studio`、`News reporter talking in studio.`、`Mother and her daughter with their dog in the park`
- 家用機 `0807-R2`（第二輪）與公司機更早的 `0806`／`0807` 草稿均未被本次觸碰，維持原狀

### 注意事項

- 找到有聲素材後，才能回頭驗證 CapCut 的「擷取音訊」「產生字幕」「逐字稿」三項功能是否真的可用（這是整條線最初的驗證目的，至今尚未達成）
- 桌面自動化每次點擊前務必重新抓取 `GetWindowRect`，不要沿用舊腳本算出的座標 offset
- 這是同一個 CapCut 練習專案第三次因用量問題中止，之後若第四次遇到同樣狀況，可以考慮改用更省截圖的驗證方式（例如一次多找幾支候選素材、批次確認音樂分頁，而不是一支一支反覆截圖）
