# Session 13 — 2026-08-10

## 完成事項

- **回答兩個 CapCut 快捷鍵問題**：（1）有沒有快捷鍵跳到時間軸窗格、（2）有沒有快捷鍵跳到下一個/上一個素材。先查了 `doc/交接文件-capcut-practice.md` 確認過去練習沒記錄過這兩個快捷鍵，然後誠實回答「就我所知沒有」而非瞎猜，並建議使用者自行到 CapCut 設定裡的「快捷鍵」面板核對最準確的官方清單。
- **CapCut Kindle 電子書調查（含一次誠實拒絕造假的過程）**：使用者要求找 10 本「CapCut 主題、含範例程式碼/GitHub/zip、近 6 個月出版」的 Kindle 書。跑了 6+ 次 WebSearch 查證後確認：Amazon 上完全沒有這類書附帶下載範例程式碼、範例專案或參考檔案（CapCut 書全是自出版的「App 教學指南」內容農場，不附加任何資源包）。**沒有為了滿足格式要求而捏造 10 筆假資料**，而是用 AskUserQuestion 讓使用者選擇下一步（放寬條件），使用者選擇「列出 10 本相關度最高的書，只給書名+連結，不驗證價格/熱門度」。嘗試用 WebFetch 直接讀 Amazon 商品頁驗證價格/評分/出版日期，**連續 4 次都回傳 HTTP 500**（Amazon 擋自動化查詢），確認此路不通後誠實告知使用者。
- **Gmail + Telegram 送出 CapCut Kindle 書單**：用 `gws gmail users messages send`（message id `19fea79b75879166`）寄到 <chenghyang2001@gmail.com>，用環境變數 `TELEGRAM_BOT_TOKEN` + `~/.claude/channels/telegram/access.json` 裡的 `allowFrom` chat_id（`7292664350`）直接呼叫 Telegram Bot API `sendMessage` 送出精簡版書單，兩者皆明確註記「價格/評分/出版日期未經驗證」。
- **工會大會團隊留念影片規劃**：使用者想用 CapCut + 同事照片做慶祝工會大會的影片，問了背景音樂建議。推薦 3 個 CapCut 音樂庫搜尋詞（`upbeat corporate`【已驗證帳號內搜得到，之前用過】、`corporate celebration`/`team celebration`【未驗證】、`feel good acoustic`/`happy ukulele`【未驗證】），並指出使用者已有一個現成的全域 skill `capcut-photo-video` 正是為這種「照片轉節慶影片」場景打造的。
- **釐清「VPS 執行任務 + 上傳 Drive + 發布 YouTube」的可行性**：使用者一開始想把整個任務（CapCut 製作+上傳+發布）都丟給 VPS。查證 `n8n2vps-hub-deployment.md` 確認 VPS（187.127.109.145）是無 GUI 的 Linux 主機只跑 systemd 服務，CapCut 桌面版是 Windows/Mac 應用，**VPS 完全無法執行 CapCut 桌面自動化**。同時確認：Google Drive 上傳可行（`rclone copy`，不需要經過 VPS）；YouTube 發布**目前完全沒有 API/OAuth 整合**（檢查過所有已載入的 MCP 工具與 skill，都沒有 YouTube 上傳能力），需要使用者本人做一次性互動式 Google OAuth 授權才能開始建置；另外主動提醒使用者影片含同事照片，公開發布前要考慮可見度設定與同事同意兩件事。原本想用 AskUserQuestion 問「執行機器」+「YouTube 处理方式」兩個問題，使用者中途打斷說要先澄清，改口說明機器選 Yama-Desktop、但今晚/明早才會實際動手，並要求先寫交接文件。
- **建立並寄出交接文件 `doc/交接文件-工會大會影片.md`**：內容涵蓋照片/祝賀語準備事項、背景音樂建議表（同上）、Yama-Desktop 開工方式（直接呼叫 `capcut-photo-video` skill、不需重新校準座標）、Phase 0-6 流程摘要、VPS/Drive/YouTube 限制說明、`doc/交接文件-capcut-practice.md` 已知踩坑重點提示。用 `gws gmail users messages send` 寄出（message id `19fea85cd0e7254d`）。**此檔案目前是 uncommitted 狀態**，本次收工會一併 commit。
- **CapCut Kindle 書單追問：篩選 Kindle Unlimited**：使用者貼回先前寄出的 email 內容，要求只列出有加入 Kindle Unlimited 方案的書（使用者是訂閱戶）。嘗試 WebFetch 兩本書的商品頁驗證 KU 徽章，**再次確認 Amazon 一律回傳 HTTP 500**，且不採信 WebSearch AI 摘要中「這本書似乎屬於 KU 目錄」這種模糊、未驗證的推論句。誠實回報：無法逐本驗證，但依經驗法則說明這類自出版 App 教學書幾乎都會加入 KDP Select/KU（這是該類型書的主要獲利模式），並教使用者用 Amazon Kindle Store 左側「Kindle Unlimited Eligible」篩選框或直接看商品頁的「Read for $0.00」按鈕自行確認，同時提議：若使用者確認哪幾本有 KU 徽章，我可以重建清單。
- **CapCut 官方 API 查證**：使用者問 CapCut 是否支援 API 上傳照片/TTS/文字檔到工作區。查證確認**沒有官方公開 API**（CapCut「Open Platform」只做編輯器內掛件開發，不支援 server-side 上傳/生成）。找到 4 個第三方/逆向工程開源工具作為替代方案：`cutcli-cookbook`、`CapCutAPI`（ashreo）、`capcut-mate`、`capcut-cli`（renezander030），並指出使用者現有的 `capcut-photo-video`/`capcut-narration-video` skill 本質上已經是同一種手法（直接操作 `draft_content.json`）。
- **深度評估 `cutcli-cookbook` vs `capcut-photo-video`**：用 WebFetch 實際讀了 GitHub repo README + `docs.cutcli.com`（不是憑印象猜），確認關鍵事實：cutcli 支援 Windows/Mac/Linux binary、不需要 CapCut 開著就能寫草稿（CapCut 下次開啟時讀取）、但**模糊背景填滿與片尾字卡功能完全沒有文件記錄**（未確認是否支援）、且需要 `cutcli auth set --api-key`（暗示背後有雲端服務，價格未知）。產出完整比較表（可靠度/功能完整度/TTS/依賴/機台實績/維護狀態），建議**今晚任務仍用已驗證的 `capcut-photo-video`**，`cutcli` 列為未來可评估的替代方案（可解決目前 GUI 自動化的脆弱性問題，但需先單獨試跑驗證兩個功能缺口）。使用者選擇這份評估只留在對話裡，不寫進任何檔案。

## 關鍵技術筆記

- **Amazon 對 WebFetch 的自動化查詢一律回傳 HTTP 500**：本次 session 內至少 4 次不同商品頁 URL（`.com` 與 `.us.amazon.com` 皆同）都被擋，確認這不是單次失敗而是系統性阻擋，之後任何需要驗證 Amazon 商品頁細節（價格/評分/KU 徽章/出版日期）的任務都要先假設「無法自動化查證」，直接請使用者本人確認，不要重複浪費 WebFetch 呼叫。
- **WebSearch 工具自己生成的摘要句可能包含未驗證的模糊推論**（例如「這本書似乎屬於 Kindle Unlimited 目錄」），這類句子是搜尋工具自己的推論生成，不是從實際頁面驗證到的事實，不能當作已確認資訊呈現給使用者，必須明確區分「查證到的事實」與「工具自己的猜測性摘要」。
- **VPS（n8n2vps-hub, 187.127.109.145）是無 GUI 的純 Linux 主機**（只跑 systemd 服務），任何需要 CapCut/Photoshop 等桌面應用 GUI 自動化的任務都不能指派給這台 VPS，這點已经在 `n8n2vps-hub-deployment.md` 確認過，未來遇到類似「把桌面應用工作丟給 VPS」的請求可以直接引用此結論快速澄清。
- **`~/.claude/channels/telegram/access.json` 的 `allowFrom` 陣列存有使用者已配對的 Telegram chat_id**（本次讀到 `7292664350`），搭配環境變數 `TELEGRAM_BOT_TOKEN`，可以直接用 Python `urllib.request` 呼叫 Telegram Bot API `sendMessage` 端點送出通知，不需要額外的 MCP 工具或 skill（`telegram:access` skill 只管配對/權限，不負責送訊息）。
- **CapCut 沒有官方公開 API**（查證兩次，時間點不同、query 不同，結果一致）：官方「Open Platform」僅限編輯器內掛件開發，不提供 server-side 上傳素材或生成草稿的端點。第三方工具（`cutcli-cookbook`／`CapCutAPI`／`capcut-mate`／`capcut-cli`）都是靠逆向工程 `draft_content.json` 格式達成類似效果，本質上跟使用者專案既有的 `capcut-photo-video`/`capcut-narration-video` skill 是同一種手法，差別只在於是否需要 CapCut 開著執行 GUI 自動化。

## 關鍵決定

- 使用者面對「找不到符合全部條件的書」時，選擇「放寬範例檔案這條件，只列相關度最高的 10 本」，而不是要求硬湊假資料 —— 這次互動確認了使用者能接受「誠實回報找不到 + 給替代方案」而非「不計代價滿足格式」，之後遇到查無實據的情境可以延續這個處理模式（見對話紀錄，這是本次驗證到的協作偏好，值得記入 feedback 記憶）。
- 使用者決定工會大會影片製作**今晚或明早在 Yama-Desktop 進行**，本次 session 只做規劃與交接文件，不在公司機嘗試執行（因為 `capcut-photo-video` 座標只在 Yama-Desktop 校準過）。
- 使用者要求 `cutcli-cookbook` 評估結果**只留在對話裡，不寫入任何檔案**（不進 `doc/交接文件-capcut-practice.md`，也不建新檔）——明確的「這次不需要持久化」指示。

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `doc/交接文件-工會大會影片.md` | 新建，工會大會影片交接文件（音樂建議+開工步驟+已知限制），已寄 Gmail (`19fea85cd0e7254d`)，本次收工一併 commit |
| `summary-02-sessions/2026-08-10/session13-summary.md` | 本檔 |

（本次未修改任何 skill/程式碼檔案，兩次 Gmail 發送與一次 Telegram 發送皆為對話中即時產生的內容，未落地成獨立檔案）

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 使用者今晚/明早會在 **Yama-Desktop** 開新 session 執行 `capcut-photo-video` skill 製作工會大會留念影片：需要同事照片（8-12 張）與片尾祝賀語文字（使用者尚未在本次 session 決定文字內容，開工時要先問）。背景音樂優先用 `upbeat corporate`（已驗證），沒有 CapCut Pro 座標校準問題（該機器已校準過）。完整步驟見 `doc/交接文件-工會大會影片.md`。
- [ ] 若使用者之後想繼續 YouTube 自動發布這條路，需要先協助建置 YouTube Data API v3 OAuth（一次性、需要使用者本人互動登入），這件事本次 session 只有澄清「還沒做」，沒有實際著手。
- [ ] 若使用者回報哪幾本 CapCut Kindle 書確認有 Kindle Unlimited 徽章，要用那份確認清單重建書單（不要再嘗試 WebFetch Amazon 商品頁，已知必定 500）。

### 進行中（需接續）

- 工會大會團隊留念影片：目前僅完成規劃 + 交接文件，尚未在任何機器實際開始執行 `capcut-photo-video` skill。
- Session 12 遺留的兩項（CapCut 專案「0810」片段長度修復+改名、「視覺定調-圖層混合文字錯位」專案 Module 2 技法5 蒙版推屏卡點）**本次 session 完全沒有碰**，仍然原封不動，狀態同 session12-summary.md 記錄。

### 注意事項

- **不要再用 WebFetch 嘗試讀取 Amazon 商品頁細節**（價格/評分/出版日期/KU 徽章）——本次 session 內至少 4 次確認一律 HTTP 500，這是系統性阻擋不是偶發錯誤，之後遇到類似需求應直接請使用者本人查看或改用 WebSearch 的間接資訊並明確標註「未驗證」。
- **不要建議把 CapCut/任何桌面 GUI 應用的自動化工作丟給 n8n2vps-hub 那台 VPS**——已確認是無 GUI 純 Linux 主機，這點已經是本次 session 澄清過的結論，未來可以直接引用不需要重新查證。
- `cutcli-cookbook` 若之後要認真評估取代 `capcut-photo-video`，**兩個關鍵功能缺口必須先實測驗證**才能下決定：模糊背景填滿（blur-fill）、片尾字卡（title card）是否支援；另外 `cutcli auth set --api-key` 暗示的雲端服務/計費方式也未查清楚，不要假設它是完全免費的本地工具。
