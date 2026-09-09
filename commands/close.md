---
description: Brain session 收尾——寫 ceremony、更新 memory/ 模組、更新相關 README、staging 所有改動。在哪個 brain 跑就整理那個 brain。
argument-hint: [session 標題，例如 "2026-08-24-weekly-review"；不給就自己從對話判斷]
---

這是任何 brain 資料夾（例如 `SALES BRAIN`、`RESEARCH BRAIN`）session 結束時的標準收尾指令。在哪個 brain 的 project 裡跑，sessions/ 和 memory/ 就整理在那個 brain 裡。**不要在 session 結束後才做這些事；每次有決策拍板就立即同步，`/close` 是最後確認，不是第一次寫。**

---

## Step 0 — 確認 brain 根目錄

先確認你在哪個 brain 的 project 裡，確定 `CLAUDE.md`、`sessions/`、`memory/` 這三個路徑都在同一個根目錄下。這個 brain 的所有產出都只進這個根目錄，不跨 brain。

---

## Step 1 — 判斷這次 session 等級

| 等級 | 條件 | 產出 |
|---|---|---|
| **Full Ceremony** | 有架構決策、規則改動、SOP 更新、新 memory 模組 | sessions/ 完整 ceremony 文件 + 所有 memory/wiki/CLAUDE.md 更新 |
| **Lightweight Log** | 純輸出 session（跑了分析、改了腳本、做了報表），無決策 | sessions/ 索引文件（1頁，只記產出和關鍵數字）|
| **不記錄** | 純問答、無產出 | 不建 session 資料夾 |

---

## Step 2 — 新建 session 文件（append-only）

**`sessions/` 是歷史紀錄，只能新增，不能改。** 每次 `/close` 一律建立一個**全新**的 session 資料夾，絕對不去修改、覆蓋或往任何**既有**的 session 資料夾裡新增檔案——即使這次的主題跟舊 session 相同、即使發現舊 session 寫錯了。舊的寫錯就在新 session 裡寫「更正：某月某日 session 的 X 應為 Y」，讓兩份都留著，歷史才是真的。

（這條規則只管 `sessions/`。`memory/`、`CLAUDE.md`、各層 `README.md` 是「現況文件」，本來就該被每次 session 覆蓋更新，不受此限。）

目錄（在這個 brain 根目錄下）：`sessions/YYYY-MM-DD-<topic>/YYYY-MM-DD-<topic>.md`

**建立前必做的撞名檢查：**

```bash
ls -d "sessions/YYYY-MM-DD-<topic>" 2>/dev/null
```

如果該路徑**已經存在**，不准寫進去。改用 `sessions/YYYY-MM-DD-<topic>-2/`（再撞就 `-3`、`-4`…）建立新資料夾，並在新文件開頭註明「延續自 `YYYY-MM-DD-<topic>`」。

Step 6 `git add` 時，只允許出現這次新建的那一個 session 資料夾路徑；如果 `git status --short` 裡出現任何**其他** session 資料夾底下的改動，代表寫錯地方了，要 `git restore --staged` 排除並回頭修正。

**Full Ceremony 格式：**

```markdown
<!-- LLM: 人讀部分 → 下方各節（ZH）。結構化資料 → 直接跳至文末「🤖 MACHINE BLOCK」-->

# YYYY-MM-DD · <Topic>

> 📁 **Session Workspace**：工作產出直接放在這個資料夾裡。

## 本次 Session 總覽

## Doctrine（決策 & 原則）
[每個決策：- **決策描述**（原因：...）]

## Governance（規則 & 治理）

## Harnessing（如何運用）

## 待辦（人工執行項）
[包含 git commit 指令]

## Amendment（精確更動清單）
| 文件/資料夾 | 更動 | 原因 |

## 🤖 MACHINE BLOCK
\`\`\`yaml
session_id: YYYY-MM-DD-topic
status: ...
\`\`\`
```

**Lightweight Log 格式：**

```markdown
<!-- LLM: 此 session 為輕量紀錄（純輸出，無架構決策）。 -->
# YYYY-MM-DD · <Topic>（Lightweight）

## 產出
## 備註
```

---

## Step 3 — 更新 memory/ 模組（依需要）

這個 brain 有哪些 memory/ 模組，看該 brain 的 `memory/README.md`（每個 brain 的模組不同）。

通用判斷邏輯：

- **Evergreen + Operational + Reference** → 值得建/更新 memory 模組
- **時間綁定 / 探索過程** → 只進 sessions/，不建 memory 模組
- **不確定** → 留在 session 記錄，不建暫存區，等下次有更多資訊再升級

特別注意：如果這次 session 改動了**知識系統本身的架構**（新增 memory 模組類別、README 格式、git 規則），要更新該 brain 的 `memory/knowledge-architecture.md`（如果存在）。

更新格式規定：
- YAML frontmatter（name / description / sources / aliases）
- 人讀內容
- `## 🤖 MACHINE BLOCK`（YAML，含所有 IDs / thresholds / paths）

---

## Step 4 — 更新 CLAUDE.md 導航表

如果這次 session 新增了 memory 模組，或現有模組從「待建」變為「完成」：
1. Navigation 表格加入或更新對應列
2. 移除任何 `（待建）` 標記
3. IDs / 路徑有改名就同步更新

---

## Step 5 — 更新相關 README

**只在這次 session 改動了某個資料夾的結構/定位時才更新對應 README。**

每個 README 的第一行（行號 1）必須是：
```
<!-- LLM: [一行導航，說明知識在哪裡] -->
```

更新完的 README 確認第一行仍然是 LLM nav comment，沒有被其他內容頂上去。

---

## Step 6 — Staging + 提醒 commit

**只 add 這次 Step 2–5 實際新建/修改過的檔案，逐一列出路徑，絕對不要對整個 `sessions/`、`memory/`、`wiki/` 資料夾下 `git add`。** 這幾個資料夾裡常常躺著其他 session 還沒 commit 的改動，整包 add 進去會把不相干的檔案也一起 staged。

**Agent 可以做（device_bash）：**
```bash
# 找出 brain 根目錄在 mnt/ 下的名稱，例如 "SALES BRAIN"
cd "$HOME/mnt/<BRAIN_FOLDER_NAME>"

# 只 add 這次 session 實際動到的檔案（明確列路徑，不要用資料夾）
git add "<檔案1路徑>" "<檔案2路徑>" ...

# 檢查有沒有誤 add 到不屬於這次 session 的檔案
git status --short
```

如果 `git status --short` 裡出現任何不在這次動到清單裡的檔案（無論是本來就 staged 還是這次不小心連帶抓進來的），要先 `git restore --staged <那個檔案>` 排除掉，再往下走。

**Agent 做不到（sandbox 封鎖 unlink）：**
- `rm .git/index.lock`
- `git commit`

給使用者在 Terminal 跑的指令（每次 /close 都要給這一段，永遠不能省略）：

```bash
rm "<BRAIN_ROOT_PATH>/.git/index.lock" 2>/dev/null; true
cd "<BRAIN_ROOT_PATH>"
git commit -m "session: <session-id> — <一句話說明>"
```

其中 `<BRAIN_ROOT_PATH>` 是該 brain 在本機的絕對路徑，例如 `$HOME/Documents/SALES BRAIN`（以實際路徑為準）。

---

## Step 7 — 收尾確認

用繁體中文收尾，格式規定如下：

**先逐檔列出這次 staged/commit 的每一個文件/表格**（不要用「session 文件／memory 模組／README」這種分類匯總帶過，要一個檔案一個 bullet）：

- `<檔案完整路徑>` — <這次具體更新了什麼內容，講到段落/欄位層級，例如「新增 XX 決策段落」「更新 YY 表格第 3 列」「新建此檔案，內容為 ZZ」>
- `<檔案完整路徑>` — <...>

（每個在 `git status --short` 裡出現的檔案都要有一行，包括 sessions/、memory/、wiki/、CLAUDE.md 底下的所有改動）

**接著列：**
- 哪些東西因為範圍不確定被跳過，需要使用者確認
- **Terminal git commit 指令**（永遠要提，永遠放在最後）
