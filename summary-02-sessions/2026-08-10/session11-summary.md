# Session 11 — 2026-08-10

## 完成事項

- **CapCut Live Demo Module 1（視覺定調）全部完成並驗證**：用 `capcut-chapter-livedemo` skill 解析教材 `Video_Magic_Playbook (1).pdf`（21頁圖片型PDF，先裝 poppler 轉PNG逐頁讀取），設計出3個Module課程大綱，完整跑完 Module 1 三個技法：水墨片頭配方（螢幕/Screen混合模式讓黑色暈染區域透明化）、圖層疊加動態入局（漸顯屏幕動畫1.5s）、文字動畫錯位美學（標題文字「水墨新視野」用縮放彈跳動畫於1.5秒進場，三層視覺元素依序登場）。
- **CapCut Live Demo Module 2（無縫過渡）部分完成**：技法3水墨轉場（用CapCut內建「墨水擴散」轉場，底層邏輯同樣是濾色/螢幕混合，不需手動疊軌道）與技法4常規轉場推屏（用「照片滑推」內建轉場套在主軌道兩段素材交界處）都示範成功並驗證；技法5蒙版推屏（Overlap Zone + 關鍵影格）卡在CapCut「線性」蒙版套用後預覽畫面沒有出現可拖曳控制點，本次到此為止，留下詳細踩坑記錄供下次接續。
- **建立新的全域 Skill：`resume-session`**：使用者規劃要一個接續 `/收工`（`/end-session`）的新 skill，先盤點現有基礎設施（`save-session-state.sh`/`restore-context.sh` hook 只顯示輕量 git 狀態、`/收工` 已經會寫完整 HANDOFF 區塊到 `summary-02-sessions/`，但沒有任何機制在新 session 開始時讀取呈現），確認不需要修改 `/收工` 本身，只需新增「讀取端」。定案為手動觸發（非 hook 自動）、名稱 `resume-session`。已建立 `~/.claude/skills/resume-session/SKILL.md` + `evals/evals.json`（3個測試情境），並用本專案真實的 `session10-summary.md` 做活體煙霧測試，驗證排序邏輯（跨日期+數字排序，非字串排序）、HANDOFF抽取、git狀態落差比對、AskUserQuestion詢問流程全部正常運作。

## 關鍵技術筆記

- **poppler-utils 安裝與 PATH 問題**：`winget install --id oschwartz10612.Poppler` 裝完後，Read 工具（背後呼叫 pdftoppm）與新的 Bash session 都讀不到剛更新的 PATH（需要重啟整個 harness 進程才生效）；解法是在 Bash 工具內每次用完整安裝路徑呼叫 `pdftoppm.exe`/`pdftotext.exe`，且 PDF/輸出路徑要用 `cygpath -w` 轉成 Windows 反斜線路徑（正斜線路徑會讓 pdftoppm 寫檔失敗）。
- **CapCut 桌面自動化新增踩坑**（已寫入 `doc/demo-recordings/video-magic-playbook-2026-08-10/notes.md`）：
  - 播放頭停在時間軸前段時點資料庫素材的「+」按鈕會**插入排擠**（ripple insert）後面所有素材，不是加到尾端；正確做法是先把播放頭移到時間軸尾端再按「+」，或直接用滑鼠慢速拖曳素材到目標軌道位置
  - 素材縮圖上的「收藏★」與「下載⬇」圖示距離很近，自動化滑鼠容易點錯
  - 轉場時長數值輸入框對自動化滑鼠點擊反應不穩定，肉眼看似點中但常沒進入編輯狀態，過程中還誤觸快捷鍵把素材時長改壞
  - 片段太短彈出的「建立用於轉場的重複影格」對話框會**擋住並吃掉後續所有點擊事件**，即使截圖範圍看不到對話框本身，也要先確認並點「確定」關閉才能繼續操作
  - CapCut 的 Redo 快捷鍵是 `Ctrl+Shift+Z`，不是 `Ctrl+Y`；多次 Undo/Redo 後歷史記錄容易搞混，建議每個轉場套用完立刻小範圍截圖驗證，不要連續做多個動作才驗證
- **resume-session 設計要點**：排序邏輯要先比資料夾日期、同一天內再用**數字比較**session編號（`session2` vs `session10` 若用字串排序會排錯）；只做讀取+簡報+詢問，絕對不自動執行找到的任務；找不到交接記錄要誠實回報不要編造。

## 關鍵決定

- **使用者明確要求：CapCut Live Demo 從本次開始跳過螢幕錄影（永久生效，非單次）**——原文：「no need to 啟動螢幕錄影...there is no need to do this now and from now on」。這與 `capcut-chapter-livedemo` skill 目前 SKILL.md 記載的預設行為（「留存格式：文字筆記＋靜音螢幕錄影」）產生衝突，**下次使用該 skill 前應該先更新 SKILL.md 的預設行為，或至少在觸發時主動確認**（見下方 HANDOFF）。
- `resume-session` 定案為**手動觸發**（使用者主動打字/開口），不做成自動 hook，理由是「不想每次開新對話都被強迫看到上次的事」；同時明確避開 `morning-briefing` skill 已佔用的「開工／開始工作」觸發詞。

## 產出檔案

| 檔案 | 說明 |
| --- | --- |
| `doc/demo-recordings/video-magic-playbook-2026-08-10/notes.md` | CapCut Live Demo Module 1+2 複習筆記（已 commit: e919a4a） |
| `~/.claude/skills/resume-session/SKILL.md` | 新建全域 skill 主體 |
| `~/.claude/skills/resume-session/evals/evals.json` | 3 個測試情境（正常/找不到/落差偵測） |
| `summary-02-sessions/2026-08-10/session11-summary.md` | 本檔 |

## HANDOFF（下次 session 優先處理）

### 立即行動

- [ ] 接續 Module 2 技法5「蒙版推屏」：先解決 CapCut 線性蒙版套用後預覽畫面沒有出現可拖曳控制點的問題（可能需要先用滑鼠在預覽畫面上點一下蒙版區域喚出控制手把，或改用 JSON 直接改蒙版座標數值繞開 UI 互動問題），完成後才進 Module 3
- [ ] 更新 `~/.claude/skills/capcut-chapter-livedemo/SKILL.md` 的「已確認的預設行為」第3點，把螢幕錄影從預設開啟改成預設關閉（或改成每次觸發時詢問），呼應使用者本次的永久性指示
- [ ] 若使用者想更嚴謹驗證 `resume-session`，可執行完整的 skill-creator 評測流程（跑 `evals/evals.json` 三個情境、產出 grading.json、開 eval-viewer）——本次只做了手動煙霧測試，沒跑完整自動化評測

### 進行中（需接續）

- CapCut 專案「視覺定調-圖層混合文字錯位」（本機路徑見 CapCut 內建專案列表）目前狀態：Module 1 三個技法 + Module 2 技法3/4 都已套用在時間軸上；技法5用的「城市天空中的晚霞景色」疊加素材與線性蒙版還留在時間軸上但未完成關鍵影格動畫，下次可以直接開啟這個專案接續，不用重做前面的部分。

### 注意事項

- 本 session 期間多次觸發 CapCut 的 ripple-insert / undo-redo 混亂，過程中曾意外讓 Module 2 的兩個轉場消失又重新套用，**最終時間軸實際狀態請下次先截圖確認一次**，不要完全相信這份 summary 的描述（尤其技法4的轉場時長最終停在預設 2.0s，不是教材建議的 0.5s，因為時長輸入框互動不穩定，多次嘗試後決定放棄追求精確數值）
- 使用量狀態：session 開始時已見到「週用量 ~247%」的警告（遠超配額），本次收工前建議提醒使用者近期控制新 session 的長度與頻率
- poppler 已透過 winget 裝在本機（Yama-Desktop），下次若在同一台機器處理圖片型 PDF 可直接用完整路徑呼叫，不用重裝
