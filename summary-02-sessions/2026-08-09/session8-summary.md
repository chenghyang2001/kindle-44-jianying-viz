# Session 8 — 剪映文本特效課程演練（5 Module）、拆成 5 支獨立影片、tts skill 修復（pygame→VLC）

**日期**：2026-08-09（家用機 / user 帳號）
**接續**：無直接接續（新任務：從一份 PDF 教材出發做 CapCut 文本特效教學演練）

---

## 完成事項

### 1. 讀取 PDF 教材並設計 5-Module 課程架構

- 來源：`c:\Users\user\Downloads\Mastering_Professional_Text_Effects.pdf`（12 頁，剪映/CapCut 文本特效教學，全為圖片構成）
- 直接用 Read 工具解析 PDF 圖片內容，萃取出教材的 4 階段架構（建立基石／視覺塑形／賦予生命／大師級封裝）+ 決策矩陣總複習，合計設計成 5 個 Module
- 用 AskUserQuestion 確認示範形式（截圖逐步示範 vs 旁白影片）與執行範圍（先做 Module 1 試水溫），採納「先做 1 個 Module 驗證流程」

### 2. 在剪映桌面版逐一操作示範 5 個 Module（截圖 + 口頭 TTS 講解）

- **Module 1｜建立基石**：新增默認文字 → 拖曳邊線調整時長（3秒→4秒）→ 切花字分頁套用樣式（文字內容保留、直接覆蓋色彩/格式）→ 點星星圖示收藏花字到專屬素材庫
- **Module 2｜視覺塑形**：排版控制區（縮放拉到130%、旋轉15度）→ 樣式混合區/立體層次區（描邊/背景/光輝/暗調/曲線化完整參數列表）→ 泡泡音套用漫畫爆炸框
- **Module 3｜賦予生命**：進場動畫（打字機II）→ 出場動畫（破碎消散）→ 循環動畫（波浪III）→ 文字轉語音朗讀（解說小帥，按產生語音自動生成音訊軌）
- **Module 4｜大師級封裝**：底圖影片拖到文字軌道下方 → 文字疊加在底圖之上 → 品牌 Logo 貼圖疊在最上層，驗證三層堆疊（底圖/文字/Logo）視覺合成效果
- **Module 5｜總複習**：套用「VLOG」文字範本示範，跟 Module 1/2 的默認文本/花字對比自由度與速度差異，補齊決策矩陣三種文字工具的實際操作畫面

### 3. 修復 TTS 播放 skill 的靜默失敗 bug（pygame → VLC，三輪 Writer→QA→Reviewer 迭代）

- 根因：`~/.claude/skills/tts/scripts/tts_daemon.py` 用 `pygame.mixer` 播放，但本機 Python 3.14 太新裝不上 pygame，daemon 啟動時 `import pygame` 直接崩潰卻無錯誤回報，使用者完全聽不到聲音卻顯示「播放中」
- 第一輪修復：改用本機已裝的 VLC，透過 RC（remote control）TCP socket 介面做 play/pause/seek/stop 控制；`tts_play.py` 新增啟動崩潰偵測（0.8秒 `DAEMON_STARTUP_CHECK_DELAY` + `DAEMON_LOG_FILE`）
- QA 第一輪 FAIL：抓到自然播放結束時 mp3 暫存檔不會被清理（`clear_state()` 只清 STATE_FILE/CMD_FILE，未處理 mp3_path），且系統上已有更早的殘留檔案佐證此問題非單次偶發
- Writer 修正：`clear_state()` 新增 `remove_mp3: bool = True` 參數，統一 `cmd_status`/`cmd_pause`/`cmd_forward`/`cmd_backward` 的清理路徑
- QA 第二輪 PASS，接著派 code-reviewer 做 adversarial review，抓到 3 個 MUST_FIX：① `clear_state()` 尾端清理迴圈缺 try/except（TOCTOU 競態會讓併發 stop 拋出未攔截 `FileNotFoundError`）② seek 的 offset/ts 缺型別驗證（異常型別會讓 daemon 拋 `TypeError` 崩潰）③ daemon 啟動時未清除殘留 `CMD_FILE`（前一輪被強殺的 daemon 可能留下過期指令，被新 daemon 誤執行）
- Writer 修正 3 個 MUST_FIX 後，QA 做最終迴歸驗證（4 個案例：正常播放/殘留CMD_FILE/型別防禦/TOCTOU併發），全數 PASS，案例皆為實測（含 tasklist 驗證 vlc.exe 行程生命週期、error log 檢查），確認結案

### 4. 把 5-Module 課程總結成一支 44 秒精華影片（先做這版，用戶後續要求拆分）

- 用剪映內建「解說小帥」TTS 重新生成 44 秒總結旁白，取代舊的 4 秒佔位文字
- 刪除舊語音、底圖影片用 JSON 調速（`speed = source_duration / target_duration`）拉長對齊 44 秒
- 文字/背景/語音三者用 JSON 精算對齊，畫面播放驗證無卡頓

### 5. 依使用者需求把總結影片拆成 5 支獨立 Module 影片

- 用剪映右鍵「製作副本」複製 5 份原始專案（過程中因選單座標抓錯誤觸發多次複製，產生一批多餘資料夾，事後用 `rm -rf` 清理乾淨，只保留需要的 5 份副本）
- 對 5 份副本分別批次改 JSON：換上各自 Module 的文字內容、字級縮小到 6、開啟 `force_apply_line_max_width` 防止長文字溢出畫面、清空舊語音關聯
- 逐一在剪映開啟每個副本，選文字片段 → 文字轉語音 → 選解說小帥 → 產生語音（過程中一度選錯語音角色「網文解說」，發現後刪除重做）
- Module 1 語音（17.6秒）於本 session 完整跑完；Module 2-5 因使用者中途喊停（`stop this task now`）而暫停在「文字已換好、語音角色選定但尚未點擊產生語音」的狀態

### 6. 使用者要求換一種形式重做：5 段文字各自獨立、純黑底、無背景、無特效

- 使用者釐清真正需求：不是要 5 支個別影片檔，而是在原本空白的「0809」剪映專案裡，用「新增默認文字」建立 5 個獨立文字片段（不是全部塞一段），各自搭配 TTS 語音，不加背景素材、不加動畫特效，只要純黑底文字＋語音
- 在空白的「0809」專案裡建立 5 段獨立默認文字（每段一個新軌道），逐段貼上 Module 1-5 文字內容、選解說小帥、產生語音
- 用 JSON 批次處理：① 字級統一縮小到 6 防止溢出 ② 建立 text_material_id → audio_segment_id 對照，把 5 段文字與對應語音依序前後排列（零空檔零重疊），總長度 1分54秒
- 驗證：Module 1（最短）與 Module 5（最長，124字）在字級 6 時都完整顯示不溢出

### 7. 使用者要求放大字級（6→13 太大會溢出，改用 9）

- 先嘗試字級 13：實測發現連最短的 Module 1（90字）都會上下溢出畫面（第一行「Module 1，建立基石。」被切一半、最後一行「後快速調用。」完全消失在畫面外），用截圖裁切證據確認
- 用 AskUserQuestion 詢問處理方式，採納「改用 9」的建議，重新驗證 Module 1（最短）與 Module 5（最長）都能完整顯示不溢出，字級 9 為安全上限並套用到全部 5 段

---

## 關鍵決定（為什麼這樣做）

### 5 段文字要各自獨立成一個文字片段，不能塞進同一段

使用者最初把 5 個 Module 總結塞進同一個文字框裡做成 44 秒總結影片，後來發現長文字在固定字級下必然溢出畫面（字級不夠小就會被裁切，字級夠小又難以閱讀）。改成 5 段各自獨立的文字片段後，每段可以獨立調字級、獨立配語音，才能兼顧「內容完整顯示」與「字夠大看得清楚」兩個互斥的需求。

### 字級放大前一定要先用最長/最短兩個極端案例驗證，不能只看單一預覽畫面

字級 13 這個需求驗證時，若只看 Module 5（最長）大概率會直接判定失敗很明顯；但反而是先測到 Module 1（最短，90字）就已經溢出，證實「即使是最短的一段」在字級 13 也撐不住，因此不需要再測 Module 5 就能判定 13 太大。這說明驗證字級上限時，最短的段落其實才是「更早出現溢出」的資訊——因為所有段落共用同一個文字框尺寸與字級，行數少不代表安全，真正的限制來自畫面高度能塞下幾行。

### tts skill 修復走完整三 agent 鐵律（Writer→QA→Reviewer），且歷經 3 輪迭代才收工

這是程式碼檔案（.py），依專案鐵律必須走 code-writer → code-qa → code-reviewer 流程，不能主 Claude 直接改。QA 第一輪就抓到真實 bug（mp3 洩漏），reviewer 又抓到 3 個更深層的併發/型別/殘留狀態問題——若只跑 Writer→QA 兩關就收工，這 3 個 MUST_FIX 都會被漏掉，證明「多加一層 adversarial review」在這次修復裡是值得的，尤其是這種涉及 subprocess + socket IPC + 檔案型 IPC 的中等複雜度修復。

---

## 關鍵技術筆記

### 1. 多螢幕環境下，「前景視窗」跟「螢幕座標」必須分開驗證，不能只信任其中一項

本 session 多次因為 `win32gui.GetForegroundWindow()` 回報正確、但 `ImageGrab.grab(bbox=...)` 用的座標其實對應到另一台螢幕（例如剪映主視窗有時開在 `(1912,-8,3848,1048)` 副螢幕、有時因為別的操作被切到 `(-8,-8,1928,1048)` 主螢幕）而抓錯畫面、點錯位置。正確做法：每次要操作前先 `EnumWindows` 印出所有同名視窗的完整 rect 列表，用該次實際回報的 rect 做 `bbox`，不要沿用上一輪操作記住的座標。

### 2. CapCut 右鍵選單在「媒體→空間」面板本身不提供刪除，需去首頁「管理→空間」頁面才有完整檔案操作選單

編輯器內的「媒體」分頁「空間」子選單，縮圖右鍵只有「分享審閱」一個選項。真正的刪除/下載/重新命名/移動功能在首頁左側「管理 → 空間」進去的獨立頁面，縮圖右下角會浮出「...」小圖示，點開才有完整選單（開啟/下載/重新命名/拷貝/移動/刪除 Backspace/分享審閱）。

### 3. CapCut「製作副本」右鍵選單項目位置會隨滑鼠右鍵座標偏移，重複點擊固定座標容易誤觸發多次複製

批次複製 5 份專案時，因為選單彈出位置是相對於右鍵點擊座標（不是固定螢幕位置），用同一組硬編碼座標連續右鍵+點擊「製作副本」，結果部分點擊落在選單以外的空白處又重新觸發右鍵，或點到別的專案卡片，造成多複製出好幾份「0809-副本-副本-副本...」的巢狀命名資料夾。修正方式：每次右鍵後都要截圖確認選單實際位置，不能盲操作連續執行同一組座標。

### 4. edge-tts 產生的語音檔可以直接用 `python -m edge_tts` CLI 產生，不依賴 tts skill 的播放層

本 session 修復 tts skill 播放層問題期間，仍需要立即產生語音檔給使用者聽，於是繞過 `tts_play.py`，直接用 `python -m edge_tts --voice zh-TW-HsiaoChenNeural -f <文字檔> --write-media <輸出mp3>` 產生檔案，再用系統已安裝的 VLC CLI（`"C:\Program Files\VideoLAN\VLC\vlc.exe" --intf dummy --play-and-exit <mp3>`）播放，繞過壞掉的 daemon 層，這是本次定位「pygame 是播放層的問題、edge-tts 產生語音檔的功能完全沒問題」的關鍵排查手法。

### 5. CapCut JSON 排列多段文字+語音時，用「material_id → audio_segment_id」對照表能可靠地依序重排，不需依賴 UI 的視覺對齊

5 段文字獨立生成語音後，時間軸上預設是重疊的（每段 audio/text 都從 `start=0` 或 `start=100000` 開始）。透過先建立 `text_material_id -> text_to_audio_ids[0]` 的對照關係，再依文字內容判斷 Module 順序（用 `txt.startswith(f"Module {i}")` 判斷），最後用一個游標（cursor）依序把每段的 text segment 和 audio segment 的 `target_timerange.start` 設成前一段結束的時間點，就能保證零空檔零重疊地精確排列，比在 UI 上一段段拖曳更可靠。

---

## Memory 更新建議（供 Memory Keeper subagent 參考）

- `capcut_multiwindow_coordinate_verify.md` — 多螢幕環境每次操作前必須重新 EnumWindows 取得實際 rect，不可沿用先前記住的座標假設
- `capcut_space_delete_location.md` — 空間素材刪除功能在首頁「管理→空間」頁面，不在編輯器內「媒體→空間」面板（該面板右鍵只有分享審閱）
- `capcut_duplicate_menu_position_drift.md` — 「製作副本」等右鍵選單位置相對於點擊座標偏移，批次操作需每次截圖確認選單位置，不可盲用固定座標連續操作
- `tts_skill_pygame_to_vlc_fix.md` — tts skill 播放層已從 pygame 換成 VLC RC socket（因本機 Python 3.14 裝不上 pygame），已通過三輪 Writer→QA→Reviewer 迭代修復並最終驗收 PASS，涉及 `~/.claude/skills/tts/scripts/tts_daemon.py` 與 `tts_play.py`

---

## 產出檔案

| 檔案/位置 | 說明 |
| --- | --- |
| `C:\Users\user\.claude\skills\tts\scripts\tts_daemon.py` | 播放後端從 pygame 改為 VLC RC socket，含型別驗證、殘留 CMD_FILE 清除（三輪修復後版本） |
| `C:\Users\user\.claude\skills\tts\scripts\tts_play.py` | 新增 daemon 崩潰偵測、`clear_state()` 補齊 mp3 清理與 try/except（三輪修復後版本） |
| CapCut 專案 `0809` | 5 段獨立默認文字＋解說小帥語音，純黑底，字級 9，總長 1分54秒 |
| CapCut 專案 `0809-副本` 等 5 份 | 拆分成 5 支獨立 Module 影片的中途產物（Module 1 已完整含底圖+語音，Module 2-5 中途暫停） |

本 session 未修改 `kindle-44-jianying-viz` repo 內的程式碼檔案，僅修改 `~/.claude/skills/tts/` 下的兩支腳本（已走完整三 agent 鐵律）與本篇 session summary。

---

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 若使用者要接續「5 支獨立 Module 影片」（`0809-副本` 系列，Module 2-5 尚未產生語音）的任務，先確認這批專案是否還要保留，或者現在的「0809 單一專案含 5 段文字」版本已經滿足需求、可以直接刪除那 5 份中途產物
- [ ] tts skill 已修復完成並通過三輪驗證，之後任何需要 TTS 播放的任務可以直接正常使用，不需要再繞道 `python -m edge_tts` + VLC CLI 手動播放
- [ ] 若要把本次 5-Module 課程正式發布（比照 `capcut-narration-video` skill 流程），仍差匯出＋YouTube 發布這兩步

### 進行中（需接續）

- CapCut 專案「0809」目前狀態：5 段獨立默認文字＋語音，字級 9，純黑底，總長 1分54秒，已在畫面驗證不溢出，尚未匯出成影片檔
- `0809-副本` 系列 5 份專案：Module 1 完整（含底圖影片+語音），Module 2-5 只有文字內容跟語音角色選定，尚未實際產生語音（使用者中途喊停後未回頭處理，後續改走純文字版路線，這批可能已經是廢棄分支）

### 注意事項

- 本機 Python 是 3.14（`C:\Users\user\AppData\Local\Python\pythoncore-3.14-64\python.exe`），pygame 沒有對應 wheel 裝不上，未來若有其他 skill 依賴 pygame 播放音訊會踩到同樣的坑，優先改用 VLC CLI 或 RC socket 方案
- CapCut 視窗開啟位置不固定（曾出現在主螢幕 `(0,0,1920,1040)`、`(-8,-8,1928,1048)`，副螢幕 `(1912,-8,3848,1048)`、`(1920,0,3840,1040)` 等多種組合），每次操作前務必重新 `EnumWindows` 確認實際 rect 再截圖/點擊
- 使用者本週訂閱用量已用到接近上限（本 session 初期一度顯示 90%+），session 中途使用者完成訂閱升級（`/login` 成功），後續配額限制已解除
