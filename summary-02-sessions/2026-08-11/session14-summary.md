# Session 14 摘要

**日期**：2026-08-11
**機器**：Yama-Desktop（家用雙螢幕機）

## 完成事項

- **找回並重新寄出工會大會影片交接文件**：使用者含糊描述「之前有個檔案好像也寄過，是接續原先工作、電腦沒裝就要裝的那種」，經比對 `doc/交接文件-工會大會影片.md` 與既有 Gmail 記錄，確認就是 2026-08-10 從公司機寄出的「交接文件：工會大會團隊留念影片（待 Yama-Desktop 接續）」（原信 message id `19fea85cd0e7254d`，內容含 Phase 0 CapCut 環境檢查）。用 `gws gmail users messages send` 重新寄出一份到 <chenghyang2001@gmail.com>（新 message id `19fed8babf001e82`），信件開頭註明是哪封信的重寄以利對照。
- **CapCut 匯入 PDF/PPT 效果查證（先文件後實測兩階段）**：先派 Explore subagent 上網查證 CapCut 官方支援格式清單（只有影片/音訊/圖片三大類，不含 pdf/ppt/pptx）與中英文社群教學（明確指出「剪映不支持直接導入和編輯PPT文件」），給出文件層級的初步答案。使用者要求實測，於是在這台機器的 CapCut（專案「0811」）實際操作：點「匯入」開啟原生 Windows 檔案選取對話框，導覽到 `kindle-45-ai-video-toolbox/slides/01 前言與目錄.pptx` 所在資料夾時清單顯示「沒有符合搜尋條件的項目」；進一步把完整路徑直接貼進「檔案名稱」欄位、繞過清單按「開啟」，跳出明確的 Windows 錯誤視窗「您無法使用這個程式開啟此位置。請嘗試不同的位置。」，證實 CapCut 對 PPTX 是**在檔案選取層級硬性擋下**，不是匯入後才失敗。全程用 pywin32 EnumWindows 抓視窗、PIL ImageGrab 截圖驗證每一步，未產生任何殘留素材或錯誤狀態（媒體庫與時間軸最終仍是空的）。
- **語音摘要轉字幕逐字稿並寄送**：使用者在 CapCut 匯入了 `kindle-45-ai-video-toolbox/audio/01 前言與目錄.m4a`（NotebookLM 生成的雙人對談語音摘要，長度 20:27），要求抓出全部字幕、存檔並寄 Gmail。確認本機已裝 `faster-whisper 1.2.1`（無 GPU，CPU-only）與 `opencc-python-reimplemented`，背景執行轉錄（small 模型、`language="zh"`、`vad_filter=True`、`beam_size=5`），耗時 556.4 秒（約 9.3 分鐘）產出 615 段字幕，並用 opencc `s2twp` 轉換成台灣正體中文。轉錄完成後**先實際讀取輸出檔案檢查內容合理性**（開頭/中段/結尾皆通順可讀，僅有少數同音錯字如「剪映」→「簡印」），才產出成品：新建 `kindle-45-ai-video-toolbox/srt/01 前言與目錄.srt`（含時間軸，41540 bytes）與 `01 前言與目錄.txt`（純文字，18278 bytes），與既有 `audio/`／`pdf/`／`slides/` 同層。
- **Gmail 寄送逐字稿踩坑與修復**：先用既有的 `gws gmail users messages send --json "$(cat file.json)"` 模式寄送（含附件的 multipart 版本 base64 約 138KB、純文字版本約 33KB），兩次都在 Node 層直接失敗「Argument list too long」，證實這條路對較長內容的信件有命令列引數長度上限（介於 5KB~33KB 之間）。改用 `mcp__claude_ai_Gmail__create_draft`（走 MCP 協定傳參數，不受 shell 引數長度限制）建立含完整逐字稿內文的草稿，再用 `gws gmail users drafts send --json '{"id":"<draft_id>"}'`（只傳一個短 id，不受限）實際送出，成功寄達（message id `19fedafc4d085d19`）。過程中也踩到 `drafts send` 的 `id` 必須放在 `--json` 的 request body 而非 `--params` 查詢參數，用 `--params` 會得到 `400 Invalid draft`。

## 關鍵技術筆記

- **CapCut 桌面版 PPTX/PDF 匯入是檔案選取層級的硬性阻擋**，不只是清單篩選器不顯示，連貼完整路徑直接開啟都會被 Windows 對話框攔下明確錯誤「您無法使用這個程式開啟此位置」。這是本次 session 唯一一次真人實測（非文件推論）得到的結論，PDF 邏輯上同理但尚未實測。
- **`gws` CLI 走 `--json "$(cat file.json)"` 模式對大內容信件會失敗**：138KB 與 33KB 的 base64 payload 都在 Node 啟動時直接報 `Argument list too long`（Git Bash/MSYS 對單一指令列引數長度的實務上限，落在 5KB~33KB 之間，需要以後再抓更精確的臨界值）。**修復模式**：改用 `mcp__claude_ai_Gmail__create_draft`（MCP 協定傳參數不受此限）建草稿，再用 `gws gmail users drafts send --json '{"id":"<draft_id>"}'`（只傳短 id）送出，繞開 CLI 引數長度限制。這條 workaround 值得記入全域 `tool-commands.md`，未來任何較長內容（> 幾 KB）要寄的信都直接走這條路，不要再嘗試一次性塞大 base64 字串。
- **`gws gmail users drafts send` 的 `id` 要放在 `--json` request body**，放在 `--params`（URL/query 參數）會得到 `400 Invalid draft` / `invalidArgument`。
- **faster-whisper（small 模型，CPU-only，無 GPU）處理 20:28 分鐘中文語音約需 9.3 分鐘**（556.4 秒，615 段），搭配 `opencc-python-reimplemented` 的 `s2twp` 模式可把 Whisper 預設偏簡體的中文輸出轉為台灣用語正體中文。這是本機首次驗證這條 pipeline 可行，可作為未來替其餘 14 章 `kindle-45-ai-video-toolbox` 語音摘要產字幕的參考基準（14 章預估總計 CPU 時間 2-3.5 小時）。

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `summary-02-sessions/2026-08-11/session14-summary.md` | 本檔 |
| `kindle-45-ai-video-toolbox/srt/01 前言與目錄.srt` | 新建（另一 repo），第1章語音摘要字幕檔（含時間軸） |
| `kindle-45-ai-video-toolbox/srt/01 前言與目錄.txt` | 新建（另一 repo），第1章語音摘要純文字逐字稿 |

（本專案 `kindle-44-jianying-viz` 本次無檔案異動，僅重寄既有交接文件的 email 副本；實質產出檔案落在同機的 `kindle-45-ai-video-toolbox` repo。）

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 若要繼續把 `kindle-45-ai-video-toolbox` 其餘 14 章語音摘要轉成字幕，比照本次驗證過的 pipeline（faster-whisper small + CPU + opencc s2twp），每章約 9-15 分鐘 CPU 時間，14 章預估總計 2-3.5 小時，建議背景批次跑、每章跑完先抽查內容再繼續下一章（不要無人值守盲跑全部）。
- [ ] 把「`gws` CLI 大內容信件走 MCP create_draft + `drafts send --json` 送出」這條 workaround 補進全域 `~/.claude/instructions/tool-commands.md`（目前只有原本的 `messages send` 小內容範本，缺大內容範本）。
- [ ] 若要驗證 PDF 匯入 CapCut 的實際效果，可比照本次 PPTX 的實測方法（貼完整路徑到檔案名稱欄位、觀察是否跳出同樣的「無法使用這個程式開啟此位置」錯誤）；PDF 這條路目前只有文件層級推論，還沒真人實測過。

### 進行中（需接續）

- 無未完成的任務，本次三個子任務（重寄交接文件 / CapCut PPTX 匯入實測 / 語音轉字幕寄送）皆已驗證完成並回報使用者。

### 注意事項

- CapCut 匯入對話框對非白名單副檔名是**硬性擋在檔案選取層級**（連貼路徑直接開都被攔），不是匯入後才報錯，往後遇到類似「CapCut 能不能匯入 X 格式」的問題可以直接用這個方法快速實測（開匯入對話框→貼完整路徑到檔案名稱欄位→按開啟→看有沒有跳 Windows 錯誤視窗），不需要每次都先查文件。
- `gws` CLI 命令列引數長度上限（實測落在 5KB 可行、33KB 與 138KB 皆失敗，確切臨界值未鎖定），任何預期內容較長（例如完整逐字稿、長篇報告）的 Gmail 寄送都直接走 MCP create_draft + `gws drafts send --json '{"id":"..."}'`，不要再嘗試 `--json "$(cat big_file.json)"` 一次性塞值。
