# Session 6 — 父親節照片影片實戰產出、建立 capcut-photo-video Skill

**日期**：2026-08-08（家用機 Yama-Desktop / user 帳號）
**接續**：Session 5（建立 `capcut-narration-video` skill 但未實測）

---

## 完成事項

### 1. 產出「2026父親節快樂」照片轉場影片（第一次跑「照片轉場」類型，非旁白類型）

- 需求釐清：長度抓 45–50 秒、16:9、純照片轉場（無旁白）、模糊背景填滿、片尾字卡＋特效
- 用 Read 工具逐張看過 11 張照片（9 張聚餐合照 + 使用者後補 2 張），找出唯一一張「爸媽單獨合照」作為重點畫面
- 建新 CapCut 專案「2026父親節快樂」，16:9，全 11 張匯入 + 套用「背景：模糊」填滿（用「套用到全部」一次搞定，不用逐張套）
- 用 JSON 直接改 `target_timerange`/`source_timerange` 把 11 張時長精算成 3.5 秒/張（38.5 秒），比 UI 拖曳精準快速
- 片尾：暖色漸層背景（縮放 400% 填滿去黑邊）＋「楊爸爸 父親節快樂」白字標題（字級 20）＋「光暈散景」暖色光斑特效，10 秒
- 背景音樂「溫暖的鋼琴 Warm Piano Background」，−6dB，淡入淡出各 1 秒，修正拖曳造成的 6.57 秒起點偏移後裁到與總長一致
- 最終匯出：48.5 秒／1920×1080／H.264+AAC／70MB，ffprobe 與抽格畫面（10 秒、43 秒）雙重驗收通過
- 產出：`C:\Users\user\workspace\2026父親節\output\2026父親節快樂-楊爸爸.mp4`

### 2. Ken Burns 緩推動畫嘗試失敗，主動跳過並誠實回報

UI 上點「動感放大」後截圖看起來套上了，但關閉重開檢查 JSON，`material_animations` 與相關欄位皆為空
——判定沒有真的生效。為了不讓整條 pipeline 卡住，選擇跳過此效果、優先完成使用者明確要求的項目，
並在交付時主動告知這個限制，讓使用者決定要不要之後補做。

### 3. 建立 `capcut-photo-video` Skill（使用者要求，user-level，供任何專案使用）

使用者反饋本次操作太慢（大量截圖猜座標、來回試錯），要求分析原因並提出加速方案。
釐清核心：CapCut 是單一桌面視窗，多 sub-agent 平行點擊同一視窗會互相打架，**多派 agent 不是解法**；
真正的瓶頸是「用截圖+像素座標瞎猜」取代了「用已知座標直接執行」。

於 `~/.claude/skills/capcut-photo-video/` 建立四個檔案：

| 檔案 | 內容 |
| --- | --- |
| `SKILL.md` | 固定流程：環境檢查→新專案→匯入照片+模糊背景→JSON精算時長→背景音樂→片尾字卡→匯出驗收 |
| `references/environment.md` | Yama-Desktop 雙螢幕座標基準（左螢幕＝終端機／右螢幕＝CapCut 全螢幕）＋ 其他機器重新校準流程 |
| `references/ui-recipe.md` | 慢速拖曳手法（本次卡最久的坑）、找「背景」模糊選項路徑、CJK輸入、Ctrl+S驗證順序 |
| `references/json-schema-photo.md` | 多時間軸陷阱、照片時長公式、片尾色塊/文字/特效的 JSON 結構 |

### 4. 示範新 skill 的觸發提示詞

使用者提供新目錄 `C:\Users\user\workspace\20260808-cindy`（16 張照片，無子資料夾），
依此給出可直接複製貼上的觸發提示詞範本，供下次（母親節/生日等）直接套用。

---

## 關鍵決定（為什麼這樣做）

### 「多派 sub-agent 平行」對桌面 GUI 自動化不適用，講清楚原因而非照單全收

使用者原本設想的加速方向是「派幾個 sub-agent 並行處理」。但 CapCut 是單一有狀態的桌面視窗，
同時間只能有一個操作序列在控制滑鼠鍵盤，多個 agent 搶同一視窗只會互相干擾、點錯目標。
真正可行的加速槓桿是：① 改用 UIAutomation 元件查找取代像素座標猜測、② 把驗證過的座標/技巧/JSON schema
固化成 skill（本次做的）、③ 用 JSON 直接改數值取代 UI 拖曳、④ 使用者預先鎖定風格偏好減少來回問答。
「多支影片才用得上平行（各自獨立 CapCut 草稿依序處理）」——誠實區分「適用」與「不適用」的情境，
沒有為了迎合「派 sub-agent」的期待而勉強套用不合適的方案。

### JSON 精算時長優先於 UI 拖曳，這次比 Session 5 更早就切換過去

Session 5 交接文件已建立「新增元素走 UI、改既有元素數值走 JSON」的界線；本次一開始就直接套用這條界線
——匯入/拖曳交給 UI，時長/位置全部用 JSON 一次算對，省下大量反覆拖曳試誤的時間。

### 主動告知 Ken Burns 失敗而非隱藏或硬凹

UI 截圖顯示套用成功，但沒有依賴這個表象——關閉重開讀 JSON 驗證，發現實際沒有生效。
沒有為了「看起來完成」而略過驗證步驟，交付時誠實列出這個限制，讓使用者知情選擇要不要之後補做。

---

## 關鍵技術筆記

### 多時間軸陷阱（本次新發現，capcut-narration-video 沒踩過）

用「以選取的項目新增時間軸」批次匯入照片時，CapCut 會建立新時間軸（如「時間軸 02」），
但專案原本的空白「時間軸 01」還在，且 `Timelines/project.json` 的 `main_timeline_id`
預設仍指向空的那個。必須手動把 `main_timeline_id` 改成有內容的 UUID，並將空的標記 `is_marked_delete: true`，
否則匯出/重開容易對到空專案。已寫入新 skill 的 `json-schema-photo.md`。

### 拖曳一定要「慢速」才會觸發 CapCut 的 HTML5 drag 偵測

直接從 A 點跳到 B 點放開會 100% 失敗（截圖顯示片段確實被選取/移動了，但實際沒有加入時間軸）。
正確做法：mousedown → 小幅位移 10-20px → 停頓 200-250ms → 再分 20-30 段緩慢移動到終點 → 停頓 → 放開。
用於：從音樂庫拖音樂、從資料庫拖背景色塊、從文字庫拖「預設文字」、從特效庫拖特效——這四種操作
點擊/雙擊都不會生效，雙擊「預設文字」甚至會誤觸左側選單切到「您的」分頁。這是本次除錯耗時最久的環節。

### 找「背景」模糊填滿選項需要在右側面板往下捲動好幾層

路徑：選取照片片段 → 基礎分頁 → 往下捲過 混合模式/增強品質/減少影像雜訊/變更背景(AI功能,非目標)/
AI移除/AI裝飾/AI混編/眼神接觸/打光 才到「背景」。選好模糊強度後再往下捲會出現「套用到全部」按鈕
（灰底文字，容易錯過但能一次套用到所有片段，非常關鍵）。

### 背景音樂拖曳常見 bug：起點沒對齊 0

拖曳音樂到音軌時，滑鼠放開位置若沒精準落在時間軸最左端，CapCut 不會自動吸附到 0，
本次實測產生了 6.57 秒的靜音空檔。每次加完背景音樂都要用 JSON 檢查 `target_timerange.start`。

### CJK 檔名會讓 Git Bash 直接呼叫 ffprobe/ffmpeg 噴 `Illegal byte sequence`

一律包在 Python `subprocess.run([...], encoding='utf-8')` 裡呼叫，不要在 Bash 命令列直接傳 CJK 路徑。

### `tasklist`/`taskkill` 在 Git Bash 需要 `MSYS_NO_PATHCONV=1` 前綴

不加的話 `/FI` `/IM` 會被誤判成路徑做轉換，指令直接失敗。

### CapCut 開機常停在「上一個專案的分享完成對話框」

這次一開機就撞見上次 `ep1-demo-2` 專案的分享完成畫面，而非空白首頁。已建立標準處理流程：
先確認是獨立子視窗（標題如「匯出-<專案名>」）、SetForegroundWindow 到該子視窗、點「確定」安全關閉、
回首頁再開新專案，全程不碰舊專案內容。

---

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `C:\Users\user\workspace\2026父親節\output\2026父親節快樂-楊爸爸.mp4` | 最終成品，48.5秒/1080P/70MB |
| `%LOCALAPPDATA%\CapCut\User Data\Projects\com.lveditor.draft\0808 (1)\` | CapCut 專案原始檔（可作範本） |
| `~/.claude/skills/capcut-photo-video/SKILL.md` | 新 skill 主流程 |
| `~/.claude/skills/capcut-photo-video/references/environment.md` | Yama-Desktop 座標基準 |
| `~/.claude/skills/capcut-photo-video/references/ui-recipe.md` | 拖曳手法與 UI 導覽 |
| `~/.claude/skills/capcut-photo-video/references/json-schema-photo.md` | 照片影片專用 JSON schema |

---

## 意外與失誤（誠實記錄）

- Ken Burns 動畫 UI 上看似套用成功，實際 JSON 驗證是空的——沒有隱藏這個落差，主動回報並跳過
- 拖曳「預設文字」直接跳轉座標失敗多次（點擊/雙擊/快速拖曳皆失敗），最後才抓出「慢速拖曳」是正解，
  這段來回耗費本 session 最多時間，也是本次要建立 skill 固化流程的直接動機
- 匯出按鈕、背景按鈕、套用到全部按鈕的座標都要往下捲/裁切截圖多次才找到，過程中多次誤觸「Ctrl+A 全選所有片段」
  （因焦點不在文字欄位卻按了全選快捷鍵）

---

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 實跑一次 `capcut-photo-video` skill 驗證（使用者已給下一個素材路徑 `C:\Users\user\workspace\20260808-cindy`，16 張照片），確認 skill 文件描述與實際操作一致，跑完補新發現的坑進 `ui-recipe.md`
- [ ] 評估是否要研究 pywinauto UIAutomation（`child_window(title=...)`）取代像素座標點擊——這是本次分析出的最大加速槓桿，但這個 session 還沒有實際驗證過，只是理論建議
- [ ] Ken Burns 動畫若使用者要求補做，需要重新研究 UI 正確操作路徑或改走 JSON keyframe（風險較高，需先找到可靠的欄位範例）

### 進行中（需接續）

- `capcut-photo-video` skill 已建立且已註冊到系統，**未經第二次實測**（只有本次「2026父親節」這一輪算是同時「首次實作」與「首次驗證」）
- 使用者已提供下一批素材路徑（20260808-cindy，16張照片），尚未告知節慶主題與片尾祝賀語文字，等使用者下一句提示詞

### 注意事項

- 本 session 用量偏高（session jsonl 一度達 69.4MB，收到紅色用量警告），下次做 CapCut 相關工作前先確認用量，必要時提前 /compact 或拆 session
- CapCut 桌面自動化目前仍是「截圖驗證每一步」的保守做法，速度換取正確性；若要進一步加速，UIAutomation 元件查找是下一步該投資的方向
- `capcut-narration-video`（旁白類）與 `capcut-photo-video`（照片轉場類）是兩個不同素材類型的 skill，觸發詞不重疊，不要混用
