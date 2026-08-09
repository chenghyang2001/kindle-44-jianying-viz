# Session 9 — ch6 錄影瘦身、addwii 短片仿製分析、《掌控時間軸》live demo、CapCut 大字版工具（3輪修編碼bug）、Visual Mastery demo 配樂+動畫+YouTube發布

**日期**：2026-08-09（家用機 / user 帳號）
**接續**：Session 8 完成《文本特效》5-Module 演練後的延續工作日，本 session 是全新的一批任務，非直接接續 Session 8 的 HANDOFF

---

## 完成事項

### 1. 第6章媒體功能 demo 錄影瘦身：刪除過大螢幕錄影，只留文字筆記+截圖

- 使用者要求播放並複習 ch6（媒體功能）demo 的錄影，中途改為只看文字筆記，最後認為錄影「太長了、也不實用」，要求整個刪除
- `git rm` 刪除 `doc/demo-recordings/ch6-media-canvas-2026-08-09/screen.mkv` 與 `screen.mp4`（原為因檔案 >100MB 而走 git-lfs 追蹤）
- 一併刪除已無用的根目錄 `.gitattributes`（只剩這兩個檔案的 lfs 規則）
- 更新 `notes.md` 標頭說明錄影已移除、原因與日期
- commit `4099ddb`

### 2. 下載並拆解分析 addwii 公司 YouTube Shorts 短片，補進既有的仿製練習筆記

- 取得使用者明確授權後，用 `yt-dlp`（透過 winget 安裝，含 ffmpeg 依賴）下載
  `https://www.youtube.com/shorts/9tnTPt5j4jc?feature=share`（addwii 智能空氣清淨機宣傳片）到 Downloads
- 匯入 CapCut 分析畫面結構：拆解出 6 個關鍵時刻（開場卡/快遞送貨/快遞上樓/店員安裝/APP監控文字疊加/動畫品牌 Logo 收尾）與對應剪輯技巧
- 用 `ffmpeg` 抽取音軌、產生波形圖、`volumedetect` 分析響度（mean -26.6dB / peak -1.2dB），拆解配樂節奏卡點（穩定拍→文字出現時的重音尖峰→類副歌密集段→Logo收尾前的近靜音→結尾漸強）
- 兩份分析（畫面結構＋配樂節奏）皆為純文字描述，未保留任何抽出的音訊/波形圖檔案，統整存進既有的 `doc/練習題-仿製addwii短片.md`
- commit `16b9839`

### 3. 完成《掌控時間軸：剪輯師的控制台》capcut-chapter-livedemo 演練（5 Module，跳過螢幕錄影）

- 教材來源：`c:\Users\user\Downloads\Mastering_Timeline_Logic.pdf`
- 使用者因用量壓力主動選擇「這次不錄螢幕錄影」，只留文字筆記＋關鍵截圖（單次選擇，非永久改變 skill 預設行為）
- Module 1（精準定位/縮放）：Ctrl+滾輪縮放沒反應，改用鍵盤 `Ctrl+`/`Ctrl-` 成功；TTS 一度完全無聲，追查是 `tts` skill 的 daemon 沒有明確設定音訊輸出裝置/音量，改手動用 VLC `--aout=directsound --gain=4.0` 播放後使用者確認聽到，成為本次演練後續全程的講解播放方式
- Module 2（音量開關邏輯）：軌道靜音圖示 vs 單一素材音量滑桿兩種方式；因免費庫素材無聲，改用先前下載的 addwii 音訊當測試素材
- Module 3（吸附功能）：關閉吸附測試主軌道 vs 一般軌道行為差異
- Module 4（多軌道 Z 軸架構）：拖曳排序軌道測試多次未成功（已知的自動化拖曳限制），改用右上角面板數字輸入排序
- Module 5（聯動與解綁）：**教材宣稱「聯動開啟時刪除主軌道會連動刪除文字」，實測不符**——如實記錄多個可能原因（誤判圖示/版本差異/文字元素例外）而非硬做出「成功」的示範
- 全程筆記存進 `doc/demo-recordings/timeline-logic-2026-08-09/notes.md`，commit `ff723de`

### 4. 開發 CapCut 大字版啟動工具（.bat + .ps1），過程踩到 3 輪編碼 bug 才收工

- 起因：使用者詢問剪映桌面版介面文字太小能否調整，查證 CapCut「設定」四個分頁（草稿/編輯/效能/一般）均無介面字級選項，上網查證確認官方無此功能，屬已知限制
- 上網找到解法：CapCut 底層是 Qt 框架，吃 `QT_SCALE_FACTOR` / `QT_FONT_DPI` 環境變數可放大介面，找到現成的 bat 範本參考
- **第一輪（writer→QA PASS，但實際雙擊失敗）**：bat 存成 UTF-8 無 BOM，寫入前依鐵律走 code-writer→code-qa（QA 用 Python subprocess 管道測試誤判 PASS，掩蓋了真實編碼問題）
- 使用者實際雙擊回報大量「不是內部或外部命令」亂碼錯誤，貼截圖佐證
- **第二輪（改存 cp950，仍 FAIL）**：診斷根因是 cmd.exe 用系統預設編碼（cp950）解析批次檔內容而非等 `chcp 65001` 生效，改整檔存成 Big5/cp950；QA 這次改用真正的 `cmd /c` 直接呼叫（非 subprocess 管道）驗證，抓到新 bug：cp950 部分中文字（如「會」「徑」）的**第二個位元組剛好等於 cmd.exe 特殊字元**（如 `|`），導致指令仍被腰斬——這是 Big5 批次檔的經典陷阱，逐字避開風險字元不現實
- **第三輪（改架構，PASS）**：`.bat` 改成純 ASCII，只負責用 `%~dp0` 呼叫同目錄的 `.ps1` + 執行完 `pause`（系統內建訊息，無編碼風險）；所有中文邏輯與訊息移到 `CapCut-BigFont.ps1`（UTF-8 with BOM，PowerShell 剖析器沒有 cmd.exe 的 DBCS 陷阱）；QA 用 4 種情境完整實測（真雙擊模擬、Test-Path 失敗分支、環境變數確認、Start-Process 例外 catch），且意外在測試 happy path 時真的把使用者的 CapCut 啟動了起來，測完用 `taskkill` 清乾淨
- 完工後複製一份到 repo `tools/capcut-bigfont/`（bat+ps1 兩檔）方便跨公司機/家用機用 git 同步，hash 與桌面驗證通過版本完全一致
- commit `a36dc5f`

### 5. CapCut Visual Mastery demo（「簡映-示範-文字-02」專案）加配樂＋動畫，匯出並公開發布到 YouTube

此專案（來源教材 `CapCut_Visual_Mastery_Playbook.pdf`，5 個 Module：視覺塑形/賦予生命/大師級封裝/總複習）為先前 session 已建立的既有專案，本 session 只做後製加工，未重跑 live demo 本身：

- **加背景音樂**：在 CapCut 音樂庫搜尋「鋼琴」，依使用者要求「溫暖、不能蓋過 TTS」的需求，從候選中挑「美好 幸福 溫馨 鋼琴演奏」（避開「回憶的悲傷」等憂傷曲風候選），設定音量 -20dB、淡入 1.0s、淡出 2.0s，並用分割+刪除尾段的方式把原長 3:24 的音樂精準裁到跟影片原長 00:01:54:09 完全對齊
- **文字動畫需求釐清與方案選擇**：使用者原始需求是「TTS 念到哪個字、畫面文字就有變化（變色/變大/閃爍皆可）」；先分析技術限制（手動文字轉語音沒有逐字時間戳記），列出方案 A（自動字幕+卡拉OK花字，省工但改變投影片版面）/ 方案 B（逐點反白，保留版面但要手動拆圖層+算時間點）/ 方案 C（真逐字，工作量不現實）三個選項讓使用者選，先選定方案 B
- **中途發現更優解**：實際操作時發現 CapCut「插入動畫→進場→打字機 II」的時長欄位輸入超過上限會**自動卡在該文字片段的完整長度**（例如輸入 30 秀自動夾到 17.6s），代表套用打字機動畫等同「文字隨片段播放時間逐字浮現」，效果比方案 B 省工非常多且更貼近逐字級精準度；跟使用者確認後**改用打字機動畫取代方案 B**，5 個 Module 依序套用（時長分別 17.6s/24.5s/23.2s/23.9s/25.0s），實際播放驗證浮現節奏與畫面確實同步
- **匯出並公開發布到 YouTube**：使用者明確要求分享到 YouTube，先用 AskUserQuestion 確認標題（「CapCut 視覺特效教學複習 - 簡映示範文字02」）與公開狀態（選「公開」）後才動手；用 CapCut 內建匯出→分享面板直接發布（免走瀏覽器上傳），過程中一度找不到「分享」按鈕，追查發現分享對話框視窗實際高度（1138px）超出可視螢幕範圍（1048px），底部按鈕被擠到螢幕外，用 `SetWindowPos` 把視窗往上移 100px 後找到按鈕並點擊，成功發布
- 最終網址：**<https://www.youtube.com/watch?v=ZDjBa4mqQOY**（帳號> ChengHsien Yang、1080P、公開）

---

## 關鍵決定（為什麼這樣做）

### CapCut 大字版工具寫到第三輪才穩定，證明「cmd.exe + Big5/cp950 中文」是要主動迴避的技術債，不是修修補補能解的坑

第一輪 UTF-8 失敗、第二輪改 cp950 仍失敗（且失敗原因是更隱蔽的「雙位元組字元第二位元組撞到 shell 特殊字元」），說明只要中文內容還留在 `.bat` 本體裡，不管換哪種單位元組/多位元組編碼都有殘留風險。最終解法不是繼續在編碼上打地鼠，而是**整個換架構**：把所有中文邏輯移到 PowerShell（無此類 legacy 剖析陷阱），`.bat` 降級成純 ASCII 的啟動器。這是本次最重要的工程教訓：遇到同一類 bug 連續兩輪修復都復發時，該考慮換掉整條技術路徑，而不是繼續在同一條路徑上加防禦。

### CapCut「打字機」動畫取代手動方案 B，是「邊做邊發現更優解」的正面案例

使用者一開始選定方案 B（逐點反白），但在準備實作、順手檢查 CapCut 內建「插入動畫」選單時，發現「打字機」動畫的時長欄位有自動夾到片段長度的行為，等於免費取得「文字隨語音時長逐字浮現」的效果。沒有悶頭照原計畫做完 5 個 Module 的手動拆圖層，而是先做一次驗證性測試、把新發現攤開給使用者選擇，使用者確認後才批次套用到全部 5 個 Module——避免了方案 B 原本需要手動拆分文字圖層＋逐點算時間點＋加關鍵影格的龐大工作量。

### YouTube 發布前用 AskUserQuestion 明確確認標題與公開狀態，不是自己判斷後直接發布

公開發布是不可隨意撤回的公開行為，即使使用者說「幫我分享到 YouTube」看似已經同意動作本身，仍先確認了標題文字與「公開/不公開列出/私人」三選一，取得明確答案後才執行匯出+上傳，避免用預設值（例如自動沿用專案名稱、或預設選不公開）誤判使用者真正想要的呈現方式。

---

## 關鍵技術筆記

### 1. CapCut 批次檔（.bat）的分享/匯出對話框視窗高度可能超出可視螢幕範圍，底部按鈕找不到時要用 `EnumWindows` 查真實視窗 rect

Visual Mastery demo 發布 YouTube 時，「分享」按鈕死活找不到，一路以為是要等進度跑完或要多捲動；最後用 `win32gui.EnumWindows` 才發現這個「匯出-XXX」對話框其實是獨立子視窗，`rect` 高度 1138px 而可視螢幕只有 1048px，底部 90px（含分享/關閉按鈕）被擠出螢幕外。用 `SetWindowPos` 把視窗往上移動後才露出按鈕。這是繼續累積的「CapCut 視窗座標不可信任預設值、每次都要重新 EnumWindows 驗證」教訓的新案例——這次的變體是「同一個視窗，尺寸本身就超出螢幕」，不只是位置飄移。

### 2. CapCut 音樂/文字片段的「淡入淡出」等基礎屬性，用分割(split)裁切片段後會被重置，需要裁切完再補回

幫 Visual Mastery demo 裁音樂長度時，原本設好的音量-20dB／淡入1.0s／淡出2.0s，分割掉尾段多餘部分後，**淡出會被歸零**（因為淡出的定義是「離片段結尾前 N 秒」，分割後新的片段結尾變了，這個屬性連帶被重置），但音量與淡入不受影響。裁切類操作後務必重新選取片段檢查所有基礎屬性欄位，不能假設沒被動過的設定會自動延續。

### 3. CapCut「插入動畫」的進場動畫時長輸入超過片段長度時會自動夾到片段長度上限，可用這特性做「動畫涵蓋整段素材」的省工技巧

`打字機 II` 動畫的「時長」欄位輸入遠大於片段實際長度的數字（例如 30、99），系統會自動夾在該文字片段的真實長度（例如 17.6s、24.5s），不會報錯也不需要先手動查片段確切秒數。這個特性可以推廣到任何「想讓某個進場/循環動畫涵蓋整個片段」的情境，不用先去查片段時長。

### 4. Windows 批次檔中文亂碼問題的最終判斷準則：只要中文字元本身仍在 `.bat` 檔案的可執行內容（含 REM 註解）中，就有風險；徹底解法是把中文輸出全部移到子行程（PowerShell / 其他無此陷阱的直譯器）

不要對「換編碼」抱過度信心。cp950 逐字避開危險位元組（第二位元組落在 `( ) % & | < > ^ "` 這幾個 cmd.exe 特殊字元）理論上可行但極度脆弱、無法一次驗證窮盡，任何後續編輯都可能重新踩雷。PowerShell 沒有這個 legacy DBCS 剖析問題，是更穩健的容器。

---

## Memory 更新建議（供 Memory Keeper subagent 参考）

- `capcut_bat_dbcs_pitfall.md`（新增）— Windows cmd.exe 批次檔含中文的編碼地雷：UTF-8 被系統預設 cp950 解析會拆爛多位元組字元；改存 cp950 後仍可能因雙位元組字元第二位元組撞到 shell 特殊字元（如 `|`）而斷詞。最終解法是把中文邏輯移出 `.bat`，改用 PowerShell 承接，`.bat` 降級為純 ASCII 啟動器
- `capcut_export_dialog_offscreen.md`（新增）— CapCut 匯出/分享對話框是獨立子視窗，實際高度可能超出可視螢幕範圍導致底部按鈕（分享/關閉）被擠出螢幕外，需用 `EnumWindows` 查真實 rect + `SetWindowPos` 移動視窗才能找到按鈕
- `capcut_clip_trim_resets_fade.md`（新增）— CapCut 素材分割(split)後，淡出等「相對片段結尾」的屬性會被重置歸零，需裁切完手動補回；音量、淡入等「相對片段開頭/絕對值」的屬性不受影響
- `capcut_typewriter_animation_auto_clamp.md`（新增）— CapCut「插入動畫→打字機」時長欄位輸入超過片段長度會自動夾到片段實際長度，可用於「動畫涵蓋整段素材」的省工技巧，不需先查片段秒數
- 沿用既有 `capcut_multiwindow_coordinate_verify.md`：本次的視窗高度超出螢幕案例是同一教訓的新變體（不只座標飄移，尺寸本身也可能超出可視範圍）

---

## 產出檔案

| 檔案/位置 | 說明 |
| --- | --- |
| `doc/demo-recordings/ch6-media-canvas-2026-08-09/notes.md` | 更新標頭，說明螢幕錄影已刪除（過大且不實用） |
| `doc/練習題-仿製addwii短片.md` | 補記 addwii 短片實測畫面結構分析＋配樂節奏卡點分析 |
| `doc/demo-recordings/timeline-logic-2026-08-09/notes.md` | 新增，《掌控時間軸：剪輯師的控制台》5-Module live demo 完整筆記（含 TTS 靜音 bug 修復記錄、Module 5 教材與實測不符的誠實記錄） |
| `doc/demo-recordings/timeline-logic-2026-08-09/screenshots/` | 新增，9 張關鍵結果截圖 |
| `tools/capcut-bigfont/CapCut-大字版.bat` | 新增，純 ASCII 啟動器，呼叫同目錄 ps1 放大 CapCut 介面字級 |
| `tools/capcut-bigfont/CapCut-BigFont.ps1` | 新增，實際邏輯（QT_SCALE_FACTOR/QT_FONT_DPI 環境變數設定、錯誤處理），UTF-8 with BOM |
| `.gitattributes`（已刪除） | 移除，原本只追蹤已刪除的 ch6 錄影檔 git-lfs 規則，現已無用 |
| CapCut 專案「簡映-示範-文字-02」 | 加背景音樂（美好幸福溫馨鋼琴演奏，-20dB，裁到 01:54:09）＋5 個 Module 打字機進場動畫，已匯出並公開發布至 YouTube |

Commit 紀錄：`4099ddb`（刪除ch6錄影）→ `16b9839`（addwii分析補記）→ `ff723de`（Timeline Logic筆記）→ `a36dc5f`（CapCut大字版工具）。「簡映-示範-文字-02」的配樂/動畫/YouTube發布屬 CapCut 專案內部狀態變更，不在本 git repo 追蹤範圍內。

---

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 確認「簡映-示範-文字-02」YouTube 影片（<https://www.youtube.com/watch?v=ZDjBa4mqQOY）發布後的實際觀看效果與音量平衡是否符合預期，必要時回> CapCut 調整背景音樂音量後重新匯出
- [ ] `tools/capcut-bigfont/` 的大字版工具已在本機驗證通過，下次登入公司機（B00332）後 `git pull` 測試跨機可攜性是否正常（`%USERPROFILE%` 動態路徑理論上沒問題，但尚未實機驗證第二台機器）
- [ ] 若要延續「CapCut Visual Mastery」demo 系列的其他章節，教材 `CapCut_Visual_Mastery_Playbook.pdf` 的來源與涵蓋範圍需要跟使用者確認是否已全部做完，或還有後續章節

### 進行中（需接續）

- 無明確中斷的進行中任務，本 session 涉及的 5 個子任務（ch6清理／addwii分析／Timeline Logic demo／大字版工具／Visual Mastery配樂動畫發布）皆已完整收尾並驗證

### 注意事項

- CapCut 匯出/分享對話框視窗可能超出可視螢幕高度，下次遇到「按鈕找不到」先假設是這個原因，直接用 `EnumWindows` 查 rect 而非一直捲動或等待
- `.bat`/`.ps1` 這類程式碼檔案的鐵律（code-writer→code-qa→必要時code-reviewer）在本 session 確實攔到了 2 輪真實 bug（第一輪 QA 用 subprocess 管道測試曾經漏掉真實編碼 bug，第二輪才用真正的 `cmd /c` 直接呼叫測出來）——往後這類牽涉到終端機/主控台互動的腳本，QA 指示裡要明確要求「用真實雙擊/cmd直接呼叫模擬，不要用 subprocess 管道包裝」，避免驗證方式本身遮蔽真實行為
- 使用者本 session 對於「有更好方案時要不要先問過使用者再換」的態度是：**先簡短展示新發現+差異，再問要不要換**，不要自己直接換掉已核准的方案（打字機動畫案例已驗證這個互動模式使用者滿意）
