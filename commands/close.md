---
description: Brain session 收尾——寫 ceremony、更新 memory/ 模組、更新相關 README、staging 所有改動。在哪個 brain 跑就整理那個 brain。
argument-hint: [session 標題，例如 "2026-08-24-weekly-review"；不給就自己從對話判斷]
---

這是任何 brain 資料夾（AMAZON BRAIN / CHURON BRAIN / ARITECH BRAIN 等）session 結束時的標準收尾指令。在哪個 brain 的 project 裡跑，sessions/ 和 memory/ 就整理在那個 brain 裡。**不要在 session 結束後才做這些事；每次有決策拍板就立即同步，`/close` 是最後確認，不是第一次寫。**

---

## Step 0 — 確認 brain 根目錄

先確認你在哪個 brain 的 project 裡，確定 `CLAUDE.md`、`sessions/`、`memory/` 這三個路徑都在同一個根目錄下。這個 brain 的所有產出都只進這個根目錄，不跨 brain。

**絕對禁止刪除任何不是這次 session 建立的檔案。** 看到不認識、不在預期內、或看起來壞掉的檔案——那極可能是另一個 session 正在進行中的產出。停下來問使用者，不准自行判斷是殘留物而清掉。

---

## Step 0.5 — 取寫入鑰匙 🔑

同一個 brain 可能同時開著好幾個 session（PPC 一個、財務一個⋯）。`memory/`、`CLAUDE.md`、各層 `README.md` 和 `git add` 是**共用資源**，同時寫會互相覆蓋。所以要先拿鑰匙。

（`sessions/` 不需要鑰匙——Step 2 的 append-only 規則已讓每個 session 只寫自己的新資料夾，天生不會撞。）

**鑰匙檔：`<BRAIN_ROOT>/.brain-key.md`**（每個 brain 各一把，不進 git）

### 先知道自己是誰

用 `ListAgents` 取得本 session 名稱（回覆第一行「This session is ...」），例如 `averychiang-45`。下面用 `<ME>` 代表它。

### 讀鑰匙

```bash
cd "<BRAIN_ROOT>"
cat .brain-key.md
date -u +%Y-%m-%dT%H:%M:%SZ    # 現在時間，用來跟 expires 比對
```

依 MACHINE BLOCK 的 `status` 分三種走法：

**(A) `status: free` → 直接進門**

```bash
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EXP=$(date -u -v+4H +%Y-%m-%dT%H:%M:%SZ)
```

把 `.brain-key.md` 的 MACHINE BLOCK 改成 `status: held`、`holder: <ME>`、`holder_since: $NOW`、`expires: $EXP`、`doing:` 填一句話說明這次要做什麼。**只改 MACHINE BLOCK，上面的使用說明原封不動。**

寫完**一定要 read-back 驗證**（防兩個 session 同時搶）：

```bash
cat .brain-key.md | grep -E "^holder:|^status:"
```

`holder` 不是 `<ME>` → 表示搶輸了，當作情況 (B) 處理，不准硬寫。

**(B) `status: held` 且 `expires` 還沒到 → 敲門**

不准自己寫任何共用資源。用 `SendMessage` 送給 `holder` 那個 session：

> 我是 `<ME>`，在 `<BRAIN>` 要改 `<檔案路徑>` 的 `<段落>`，內容是 `<一句話>`。跟你正在做的事衝突嗎？可以借我鑰匙嗎？

- **對方說可以** → 請對方在鑰匙檔填 `lent_to: <ME>`、`lent_scope: <只有那個檔案那個段落>`。你只做這一件事，做完 `SendMessage` 回報對方，由對方清掉 `lent_to`/`lent_scope`。**不准順手多改別的。**
- **對方說不行** → 停止。把要做的事寫進自己的 session 文件當待辦，Step 7 明列出來給使用者。
- **對方沒回應**（busy 或 offline）→ **不准自己判斷「他大概掛了」**。停下來回報使用者，由使用者決定是否強制收回。

**(C) `status: held` 但 `expires` 已過 → 逾期，仍要問人**

租期 4 小時。逾期**不等於**自動放行，只代表你可以拿這件事去問使用者：「鑰匙在 `<holder>` 手上但已逾期 X 小時，要收回嗎？」等使用者說了才收。

### 拿不到鑰匙怎麼辦

**Step 2 照做**——寫自己的 session 文件不需要鑰匙。Step 3–6 全部跳過，在 Step 7 明白寫出「因未取得鑰匙而未執行的項目」。

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
<!-- LLM: 此 session 為輕量紀錄（純輸出，無架構決策）。結構化資料 → 直接跳至文末「🤖 MACHINE BLOCK」 -->
# YYYY-MM-DD · <Topic>（Lightweight）

## 產出
## 備註

## 🤖 MACHINE BLOCK
\`\`\`yaml
session_id: YYYY-MM-DD-topic
type: lightweight
status: done
outputs:              # 這次產出的檔案路徑 / 試算表 ID，逐項列
  - ...
key_numbers: {}       # 關鍵數字（沒有就留 {}）
touched_modules: []   # 這次動到的 memory/ 模組（沒有就留 []）
\`\`\`
```

**Lightweight 也一定要有 MACHINE BLOCK。** 沒有決策不代表沒有結構化資料——產出的檔案路徑、試算表 ID、關鍵數字，都是之後 LLM 要靠這裡撈的。欄位沒內容就留空容器（`{}` / `[]`），不要整段省略。

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

**前提：只有持鑰匙的 session 能跑 `git add`。** `.git/index` 是最不能共用的資源——兩個 session 同時 `git add` 會撞 `.git/index.lock`，而 sandbox 封鎖 `rm`，agent 清不掉，只能由使用者到 Terminal 手動處理。沒鑰匙就整個 Step 6 跳過，在 Step 7 寫明「檔案已改好但未 staged，待取得鑰匙後補」。

**只 add 這次 Step 2–5 實際新建/修改過的檔案，逐一列出路徑，絕對不要對整個 `sessions/`、`memory/`、`wiki/` 資料夾下 `git add`。** 這幾個資料夾裡常常躺著其他 session 還沒 commit 的改動，整包 add 進去會把不相干的檔案也一起 staged。

**Agent 可以做（device_bash）：**
```bash
# 找出 brain 根目錄在 mnt/ 下的名稱，例如 "AMAZON BRAIN" 或 "CHURON BRAIN"
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

其中 `<BRAIN_ROOT_PATH>` 例如：
- AMAZON BRAIN → `/Users/averychiang/Documents/AMAZON BRAIN`
- CHURON BRAIN → `/Users/averychiang/Documents/CHURON BRAIN`（以實際路徑為準）

---

## Step 7 — 收尾確認

用繁體中文收尾，格式規定如下：

**先逐檔列出這次 staged/commit 的每一個文件/表格**（不要用「session 文件／memory 模組／README」這種分類匯總帶過，要一個檔案一個 bullet）：

- `<檔案完整路徑>` — <這次具體更新了什麼內容，講到段落/欄位層級，例如「新增 XX 決策段落」「更新 YY 表格第 3 列」「新建此檔案，內容為 ZZ」>
- `<檔案完整路徑>` — <...>

（每個在 `git status --short` 裡出現的檔案都要有一行，包括 sessions/、memory/、wiki/、CLAUDE.md 底下的所有改動）

**接著列：**
- 哪些東西因為範圍不確定被跳過，需要使用者確認
- **因為鑰匙而沒做成的事**：沒拿到鑰匙所以跳過的步驟、敲門被拒的項目、對方沒回應待使用者裁決的項目——逐項列，不要含糊帶過

**最後歸還鑰匙 🔑**（只要 Step 0.5 拿到過，就一定要還）：

把 `.brain-key.md` 的 MACHINE BLOCK 改回 `status: free`，`holder` / `holder_since` / `expires` / `doing` / `lent_to` / `lent_scope` 全部設為 `null`。**用覆寫，不要刪檔**（sandbox 封鎖 `rm`，而且鑰匙檔本身必須一直存在）。

還完 read-back 確認一次：

```bash
grep -E "^status:|^holder:" "<BRAIN_ROOT>/.brain-key.md"
```

若這次是**跟別人借**的（情況 B），不要動 `status`/`holder`——那是屋主的。改成 `SendMessage` 回報屋主你做完了，由屋主清 `lent_to`/`lent_scope`。

**最後放 Terminal git commit 指令**（永遠要提，永遠放在最後）
