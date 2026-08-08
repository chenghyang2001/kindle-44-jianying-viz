# Session 5 — 完成第八輪旁白影片、發布 YouTube、建立 capcut-narration-video Skill

**日期**：2026-08-08（家用機 Yama-Desktop / user 帳號）
**接續**：Session 4（第八輪做到 4/14 段後因批次自動化失敗停工）

---

## 完成事項

### 1. 補完第八輪旁白（4/14 → 14/14）

- 完成第 4-13 段的字幕文字圖層 ＋ 中文 TTS（解說小帥），全 14 段**字幕零重疊、語音零重疊**
- 旁白時間軸：0.67 → 128.60 秒（影片全長 135 秒）
- 每段完成後讀草稿 JSON 驗證精確秒數，取代原本的截圖驗證

### 2. 修掉四個既有瑕疵（都不是本 session 造成的）

| 瑕疵 | 詳情 | 處理 |
| --- | --- | --- |
| 第 2 段語音幾乎無聲 | `volume = 0.009`（−40.5 dB），畫面完全看不出來 | 改回 0 dB，`ffmpeg volumedetect` 驗證匯出檔為 mean −18.5 dB |
| 第 2/3 段語音重疊 2.50 秒 | 第 0-2 段字幕比語音長，合計多 3.24 秒把第 3 段擠後 | 三段字幕縮到與語音等長並前移 |
| 殘留「剪映教學示範」TTS | 33.17→34.60，第三個聲音疊在第 4 段上 | 刪除，並把第 4 段語音移到 33.10 |
| 後半段無配樂 | Cooking Music 只到 80.43 秒，之後是 **−91 dB 數位靜音** | 複製第二份鋪到 135.00 秒，自帶 1 秒淡入淡出 |

### 3. 字幕與標題調整

- 第 3 段字幕 12.17 → 13.13 秒（覆蓋整段語音），第 4 段順移不連鎖影響後續
- 「剪映教學示範」標題文字從 36.87 秒縮到 6.73 秒，移到 72.47 秒（旁白唸到它的那一刻）

### 4. 發布兩支 YouTube 影片（皆公開）

| 版本 | 網址 | 狀態 |
| --- | --- | --- |
| v1 | <https://www.youtube.com/watch?v=YDOwmPXJ95s> | 字幕溢出未修 |
| **v2** | <https://www.youtube.com/watch?v=Zz3kFnQdews> | **字幕修正版** |

兩支皆以 YouTube Data API 覆核 `privacyStatus: public` / `uploadStatus: processed`。
每次發布後寄 Gmail（`19fde935cd1730ac`、`19fdeb2928e12dba`）＋ Telegram（msg 841、842）。

### 5. 修正字幕溢出畫面（v1 → v2）

- **根因**：旁白貼進「預設文字」元件，字級沿用標題用的 15（每字 150 px）；
  且 `line_max_width=0.82` 但 `force_apply_line_max_width=false`，換行完全不生效
- **量化**：49 字一行需 7350 px，畫面僅 1920 px，**只看得到 26%（約 12 字）**
- **修法**：14 段 `font_size` 15 → 6 且 `force_apply_line_max_width = true`，
  `content.styles[].size` 同步改。每段自動折成 2-3 行

### 6. 新增旁白字數 → 語音長度換算表（實測）

- 樣本 602 字 / 109.77 秒 → **每秒 5.48 字**（每分鐘約 330 字）
- 心算法：**字數 ÷ 5.5 ≈ 秒數**；建議每句 40-55 字（≈8 秒語音、2-3 行字幕）

### 7. 建立 `capcut-narration-video` Skill

`~/.claude/skills/capcut-narration-video/`（SKILL.md 173 行 + 3 個 reference 共 573 行，全 `.md` 未觸發三 agent 鐵律）

---

## 關鍵決定（為什麼這樣做）

### 建立文字圖層走 UI，不走 JSON —— 而且這條界線後來被明確劃出來

開工時我提議「用 JSON 預先建好 14 段文字圖層，UI 只做 TTS」，可把 UI 操作量從約 80 次降到 40 次。
**使用者選擇完全照交接文件的 UI 流程逐段做。** 當時的理由成立：JSON 方案要**憑空產生文字素材**
（複製一百多個欄位的 schema、新 UUID、`extra_material_refs` 相依物件），schema 風險高。

但後來修 seg0-3 重疊時，情況不同了——那只是改**既有片段**的 `start` / `duration` 兩個整數，
不新增任何素材。我把這個差異講清楚後，使用者改選 JSON。於是浮現一條可複用的界線：

> **建立新元素 → 一律走 UI**（讓 CapCut 自己處理 id、素材複本與相依物件）
> **修改既有元素的純數值屬性**（`font_size` / `volume` / 時間點 / 時長）**→ 可直接改 JSON**，
> 但必須：寫入 `Timelines/<UUID>/` 那份 ＋ 同步全部 5 個檔案 ＋ 事前確認 CapCut 進程歸零。

這條界線是本 session 最重要的方法論產出，已寫進 `capcut-narration-video` skill 的 Phase 1 與 Phase 3 分工。
後半段補配樂就是照它做的：**UI 複製貼上讓 CapCut 建素材複本，再用 JSON 把位置裁精準**。

### TTS 維持 CapCut 內建「解說小帥」，不改用 edge-tts

規劃 skill 時我提出替代方案：改用 edge-tts 外部產生 mp3，秒數事前就知道，整條時間軸可一次寫入 JSON，
**UI 操作量從 70+ 次降到約 6 次**，穩定度大幅提升。

**使用者選擇維持解說小帥。** 理由是本階段「只變內容」，TTS 語音角色被明確列入**未來優化清單**。
代價是 Phase 2（逐段 TTS）成為整條 pipeline 唯一的風險集中點，因此 skill 把它設計成**可續跑**
（每段成功即記錄進度，重跑時從失敗那段接續）。

⚠️ 這是刻意偏離全域 `tech-stack.md`「TTS 用 edge-tts」的預設，**不是疏漏**，下次不要「順手改回去」。

### Skill 採純 `.md` 內嵌 Python，不產出 `.py` 模組

這些腳本高度依賴當下的 UI 座標與視窗狀態，需要臨場改寫，模組化反而降低彈性；
本 session 全程也都是用 heredoc 貼程式碼跑的，已實戰驗證。副帶效果是不觸發三 agent 鐵律，建置成本低很多。
使用者在被告知兩種選項與成本差異後選了這個。

---

## 關鍵技術筆記

### 🔴 CapCut 權威草稿檔在 `Timelines/<UUID>/draft_content.json`

根目錄的 `draft_content.json` / `.bak` / `template-2.tmp` 都是**衍生副本，改它們不生效**。
本 session 花了很久才查出：把根目錄三個檔全改、甚至完全結束進程再重啟，依然無效。
修改時要把同一份內容寫入全部 5 個檔案，且必須先確認 CapCut 進程歸零。

### 🔴 不要用「Ctrl+S 後讀回檔案」自證

CapCut 認為專案沒變更時 Ctrl+S 是空操作，讀到的只是自己剛寫進去的內容 —— **等於自己證明自己**。
可靠的驗證是**開匯出對話框看「時長」**，那反映記憶體裡時間軸的真實長度。

### 貫穿全部失敗的母題：快取座標

軌道會重排、片段選取會換邊框色、視窗會被搶走、對話框會從「畫在主視窗內」變成獨立視窗。
本 session 因此失敗 5 次以上。可靠做法只有兩種：每次操作前重新確認，或用顏色／結構特徵動態定位。

### 五道防護（已寫進 skill）

| 防護 | 做法 |
| --- | --- |
| 前景守衛 | 每個動作前 assert 前景 hwnd 與 rect 未變 |
| 按鈕顏色護欄 | 「產生語音」啟用時青色 `RGB(42,218,237)`，與座標重疊的「修改」是深灰；按前取樣 |
| 找框架不找內容 | 用片段邊框色 `RGB(98,57,48)` 上下配對定位，不用填色（會被標籤文字打斷） |
| 拖完就驗、抓錯就退 | 拖曳後讀 JSON 比對起點，被誤移就 Ctrl+Z 換抓取點重試 |
| 驗證讀 JSON | 且必須讀 Timelines 那份 |

### 更正 Session 4 交接文件的誤判

前一版寫「批次 3 段全部沒建立」是**錯的** —— 第 4 段文字圖層有成功建立，只是停在預設 3 秒。
誤判原因：只用截圖判斷，而時間軸會垂直捲動，被捲出畫面的軌道等於不存在。

### 其他踩坑

- `SW_RESTORE` 會把最大化視窗縮成 1280×720 讓座標全失效 → 要用 `SW_MAXIMIZE`
- CapCut 關閉專案時把草稿資料夾更名為專案顯示名稱（`0808 (1)` → `ep1-demo-2`）
- 匯出檔案 10 秒內即達最終大小（預先配置），**大小穩定 ≠ 完成**
- `gws` 沒有 youtube 服務，不能用它上傳；CapCut 內建分享面板最省事
- Python heredoc 遇 Windows 路徑 `\Users` 會噴 `truncated \UXXXXXXXX escape` → 用 raw string

---

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `%USERPROFILE%\AppData\Local\CapCut\Videos\ep1-demo-2-narrated.mp4` | v1，205.2 MB |
| `%USERPROFILE%\AppData\Local\CapCut\Videos\ep1-demo-2-narrated-v2.mp4` | **v2 字幕修正版**，205.2 MB |
| `doc/交接文件-capcut-practice.md` | 765 行（本 session 新增約 250 行） |
| `~/.claude/skills/capcut-narration-video/SKILL.md` | 173 行 |
| `~/.claude/skills/capcut-narration-video/references/ui-helpers.md` | 258 行 |
| `~/.claude/skills/capcut-narration-video/references/json-schema.md` | 159 行 |
| `~/.claude/skills/capcut-narration-video/references/troubleshooting.md` | 156 行 |
| `~/.claude/doc/my-skills-catalog.md` | YouTube 分類 10 → 11 |
| `~/.claude/projects/.../memory/capcut_draft_json_ground_truth.md` | 新增後又更正（路徑原本寫錯） |

**Commits**：`4caef58`、`745ffd0`、`2e3e305`、`8ada750`

---

## 意外與失誤（誠實記錄）

- **弄動了使用者的 Chrome**：CapCut 被 Chrome 搶走前景時，一輪點擊落到 YouTube 分頁上把影片換掉了
- **誤把「剪映教学示范」平移 2.67 秒**：定位抓錯片段，當下 Ctrl+Z 復原並確認回到 34.00，無殘留
- **白等 9 分鐘**：按「匯出」時點在按鈕下方空白處（對話框變成獨立視窗、位置偏移），是使用者手動按下才跑起來
- **兩次 Bash 呼叫被權限提示拒絕**，使用者一度以為我停止工作，應更早說明

---

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] **實跑一次 `capcut-narration-video` skill 驗證**。建議先給 3-4 段、約 150 字的短旁白（成品約 30 秒），跑通再上長的。整條 pipeline 目前只是紙上規劃，尚未端到端跑過
- [ ] 跑完把新發現的失敗模式補進 `~/.claude/skills/capcut-narration-video/references/troubleshooting.md`
- [ ] 決定 v1 影片（`YDOwmPXJ95s`）要不要改成不公開。使用者當時選擇兩支都公開，但 v2 出來後 v1 的字幕問題仍在，可能誤導觀看者

### 進行中（需接續）

- `capcut-narration-video` skill 已建立且已註冊到系統，**未經實測**。Phase 2（逐段 TTS）是唯一的風險集中點，設計上支援續跑但尚未驗證
- CapCut 專案 `ep1-demo-2` 目前是 v2 狀態（字級 6 + 自動換行），可作為 skill 的模板來源

### 注意事項

- **本 session 用量很大**（桌面自動化上百次操作 + 兩次 205 MB 匯出 + 兩次 YouTube 上傳）。下次做 CapCut 相關工作前先確認用量
- 執行 CapCut 自動化前**務必請使用者關閉 Chrome 自動播放與 Telegram 通知**，並在執行期間不要操作滑鼠鍵盤
- 記憶檔 `capcut_draft_json_ground_truth.md` 已更正為 Timelines 路徑；若看到舊版寫「根目錄 draft_content.json」的說法，那是錯的
- 未來優化清單（背景素材、TTS 語音、字幕樣式、片頭尾、縮圖）已寫進 SKILL.md 並標註「本階段不做」，下次執行時不要發散
