# School Studies Skills

A catalog of [Claude](https://claude.ai) skills for school studies. Each skill is
packaged as a Claude Code plugin, and this repository is a plugin marketplace,
so you can install any skill straight from the GitHub link.

Every skill is written in the open [Agent Skills](https://agentskills.io)
`SKILL.md` format (plain Markdown with a YAML frontmatter `name` and
`description`), the same standard now used by
[GitHub Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills),
[ChatGPT](https://help.openai.com/en/articles/20001066-skills-in-chatgpt) and
[OpenAI Codex](https://developers.openai.com/codex/build-skills) — so the
same files work across all of them. See **Options 4–5** below.

> **Disclaimer:** This project is not affiliated with, endorsed by, or
> sponsored by any textbook publisher or test organization (including the
> College Board — "SAT" is its trademark, referenced here only to describe
> a practice format). No textbook content, real test questions, or other
> copyrighted material is included in this repository — you supply your own
> concept guide file(s) for whatever course you're using. Generated problems,
> solutions, and grading are produced by an AI model and may contain errors;
> review them before relying on them. Licensed under the
> [MIT License](LICENSE) — provided as-is, with no warranty.

See [CHANGELOG.md](CHANGELOG.md) for the full version history.

## Skills in this catalog

| Skill | What it does |
|-------|--------------|
| [problem-set-builder](plugins/study-problem-sets/) | Builds lesson-focused problem set PDFs from your own concept guide, and solves screenshots of textbook pages with step-by-step solution PDFs. Works with any numbered-lesson textbook or course. |
| [problem-set-grader](plugins/study-problem-sets/) | Grades a printed problem set your student solved by hand: scan or photograph it and get a score and a graded report PDF. Installed with the study-problem-sets plugin. |
| [sat-practice-builder](plugins/study-problem-sets/) | Builds SAT-style math practice sets covering one lesson, a lesson range, or the whole course — real SAT item format, easy/medium/hard tagging, and meaningful wrong-answer choices. Installed with the study-problem-sets plugin. |

## Install

### Option 1: Claude Code (recommended)

Inside Claude Code, run:

```
/plugin marketplace add SiddharthMishraPersonal/School-Studies-Skills
/plugin install study-problem-sets@school-studies-skills
```

Restart Claude Code if the skill does not show up right away. To get updates
later:

```
/plugin marketplace update school-studies-skills
```

### Option 2: Claude Code, manual copy

```bash
git clone https://github.com/SiddharthMishraPersonal/School-Studies-Skills.git
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-builder ~/.claude/skills/
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-grader ~/.claude/skills/
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/sat-practice-builder ~/.claude/skills/
```

### Option 3: Claude app (claude.ai or desktop)

1. Download [`dist/problem-set-builder.zip`](dist/problem-set-builder.zip) and
   [`dist/problem-set-grader.zip`](dist/problem-set-grader.zip) (open
   each file on GitHub and click **Download raw file**).
2. In Claude, go to **Settings → Capabilities → Skills** and upload each zip.

`sat-practice-builder` isn't included here: it uses an `argument-hint` field
(for its Claude Code `/sat-practice-builder` autocomplete) that's outside
the strict six-field Agent Skills spec claude.ai's upload validator
enforces, so its zip would be rejected. It works on Claude Code (Option 2)
and in ordinary claude.ai/desktop conversation if you just paste its
`SKILL.md` content into the chat instead of uploading it as a Skill.

### Option 4: GitHub Copilot

Copilot discovers Agent Skills from the same `SKILL.md` folder layout. Clone
the repo, then copy the skill into one of Copilot's recognized skill folders:

```bash
git clone https://github.com/SiddharthMishraPersonal/School-Studies-Skills.git

# Personal (available in every project / the Copilot CLI):
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-builder ~/.copilot/skills/

# Or project-level (only inside one repo/folder):
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-builder .github/skills/
```

Copilot also reads `.claude/skills/` inside a project, so a project-level
copy there (as in Option 2, but placed in the project instead of `~/.claude`)
works for both Claude Code and Copilot at once. `sat-practice-builder`
copies the same way; its extra `argument-hint` line is a Claude Code
extension, not part of Copilot's documented fields — folder-based readers
generally just ignore frontmatter keys they don't recognize (only claude.ai's
dedicated upload validator is confirmed to hard-error on this), but if
Copilot ever complains, delete that one line.

### Option 5: ChatGPT and OpenAI Codex

**ChatGPT** (Business, Enterprise, Healthcare and Edu plans) has a native
Skills feature:

1. Download [`dist/problem-set-builder.zip`](dist/problem-set-builder.zip)
   and [`dist/problem-set-grader.zip`](dist/problem-set-grader.zip) — the
   same zips used for the Claude app in Option 3. (`sat-practice-builder`'s
   zip isn't upload-ready for the same `argument-hint` reason as Option 3 —
   paste its `SKILL.md` into a Project instead, below.)
2. In ChatGPT, open **Plugins → Skills → Create → Upload from your
   computer** and upload each zip.

On **Free, Go, Plus or Pro**, there's no Skills menu, so instead create a
**Project**, open its **Project settings**, and paste the skill's
`SKILL.md` content into the project instructions. It won't run supporting
scripts, but the instructions themselves still work. This is also the route
for `sat-practice-builder` on any ChatGPT plan.

**OpenAI Codex** (CLI / IDE) discovers Agent Skills from folders the same
way Copilot does:

```bash
git clone https://github.com/SiddharthMishraPersonal/School-Studies-Skills.git

# Personal (every project):
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-builder ~/.agents/skills/
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-grader ~/.agents/skills/
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/sat-practice-builder ~/.agents/skills/

# Or project-level (only inside one repo/folder):
cp -R School-Studies-Skills/plugins/study-problem-sets/skills/problem-set-builder .agents/skills/
```

`.agents/skills/` is the shared convention Codex and Copilot both read, so
one copy there covers both.

## How to use

### One-time setup

Create a folder for your course, named whatever you like (for example
`Algebra 1` or `AP Chemistry`), containing at least one **concept guide
file** named `<anything>_Concept.pdf` or `<anything>_Concept.docx` (Word
works too) — for example `Algebra1_Concept.pdf`. The `_Concept` part and
the PDF/Word file type are a strict requirement; the part before it is your
choice and becomes that file's short name (its **alias**). Each guide lists
its lessons' numbers, titles, key rules and examples. You write this
yourself — it is how Claude knows what each lesson teaches. It is not
included in this repository, and no textbook content is needed beyond what
you put in it.

```
Algebra 1/                          (or any name you like)
├── Algebra1_Concept.pdf            you provide this
├── Problem_Set_Catalog.json        record of everything generated
├── Problem Sets YYYY-MM-DD/        created by the skill
├── Graded YYYY-MM-DD/              graded reports and scan copies
├── media/                          screenshots you uploaded
└── adhoc-solutions/                solutions for those screenshots
```

Start Claude in that folder (or the folder above it), or give the Claude app
access to it. If Claude can't find a matching file anywhere, it won't
assume anything — it asks you to either attach one or tell it which folder
your concept files are in.

### Several concept files for one course (combined automatically)

A single folder can hold more than one concept file — for example a course
split into `Algebra1_Concept.pdf` and `Geometry_Concept.docx`:

```
Algebra 1/
├── Algebra1_Concept.pdf
├── Geometry_Concept.docx
└── ...
```

Claude treats every matching file in that folder as one combined course,
and can even write a single question that draws on more than one of them
(for example, an algebra equation that also needs a geometry fact). Because
the same lesson number could exist in more than one file, every lesson
reference printed under a question is prefixed with its alias whenever more
than one guide is active — `(Algebra1-24)` instead of plain `(24)` — so it's
always clear which file a citation points to. With only one concept file,
plain lesson numbers are used, same as before.

### Multiple subjects, kept separate (Math, Chemistry, Physics, ...)

This is a different situation from the one above: here you want entirely
separate courses that should **not** be combined. Make one folder per
subject, as siblings under a parent folder — each folder's own concept
file(s) are combined with each other (as above), but never across folders:

```
Study/
├── Math/
│   └── Algebra1_Concept.pdf
├── Chemistry/
│   └── Chemistry_Concept.pdf
└── Physics/
    └── Physics_Concept.docx
```

Each subject's `Problem_Set_Catalog.json`, problem sets, and graded reports
are created inside its own folder, so progress and question history for
Math never mix with Chemistry or Physics.

To point Claude at the right subject:

- **Start Claude inside that subject's folder** (for example `cd Math` first)
  — this is the most reliable way, since there's then only one folder's
  files to find.
- Or start Claude in the parent `Study/` folder and just say the subject in
  your request (for example "make a chemistry problem set for lesson 12").
  Claude matches it to the right subject's folder automatically when the
  match is unambiguous.
- If Claude finds candidates in more than one folder and can't tell which
  you mean, it lists them by subject/folder name and asks — it never
  guesses.

The same applies to grading: give Claude access to the right subject folder
(or the parent `Study/` folder), and it matches the scanned sheet to the
correct subject's answer key using the set ID in the footer. If two
different subjects happen to produce the same set ID on the same day, it
shows both matches (with subject and lesson title) and asks which one is
correct rather than guessing.

### Make a problem set

Say, for example:

- "Make a problem set for lesson 34"
- "Give me 15 questions on lesson 47 with solutions"

Before building, Claude asks how many questions you want, whether to include
solutions, and where to save the PDF — see "Where output goes" below. Every
new set's questions are checked against your earlier sets for that lesson so
they never repeat.

### Solve a textbook page

Paste or upload a screenshot or photo of a page and say "solve this". Claude
solves every question on it with full step-by-step work in a PDF, marking
any answer it isn't fully sure of as **[Likely]**.

### Grade a solved sheet

1. **Print** the problem set (question pages only, if it has solutions).
2. The student solves it by hand, writing the final answer on the
   **Answer:** line.
3. **Scan or photograph** each page and give it to Claude, saying "grade
   this".
4. Claude matches it to the right answer key using the set ID printed in the
   footer, asks your grading style (final answer only, or final answer plus
   partial credit), and produces a score and a graded report PDF with notes
   on every mistake.

Unclear handwriting is marked **[Check]** with both possible readings rather
than guessed at.

### Where output goes

All three skills ask the same way, every time — **never assuming a save
location**, including never silently writing to a generic "outputs" area
your environment might offer by default:

1. **The usual folder** inside your study folder (shown with its full path).
2. **Another folder on your computer** (you give the path).
3. **A ZIP file with everything generated** — the PDF(s), plus the catalog
   as it stands after the request — handed to you as a download.

If you don't give it a real folder, it defaults to the ZIP option and says
so plainly, including a caveat: since it can't read anything back from a
ZIP automatically, **future requests won't have that history**, so new
sets might repeat these questions unless you give it a real folder next
time, or re-upload that ZIP's catalog file. If you care about unique
questions, give it a folder.

### Build SAT-style practice

Say, for example:

- "Make SAT-level practice questions" — defaults to the whole course and 22
  questions (one real digital SAT Math module's length), mixed easy/medium/hard.
- "SAT questions through lesson 49" — covers lessons 1–49, not just lesson 49.
- "SAT practice for just lesson 12 only" — scoped to that one lesson.

Scope and concept guides work exactly like the other two skills: more than
one concept file in the folder is combined, and lesson references get an
alias prefix when more than one guide is active. Each question shows the
lesson(s) it's drawn from under its number (like `problem-set-builder`) and
an *(Easy/Medium/Hard)* tag after the question.
Most questions are multiple choice with four real-SAT-style answer choices
— each wrong one built from an actual common mistake, not a random number —
plus a smaller share of grid-in (no-choices) questions, matching the real
test's mix. Unlike the other two skills, a small share (about 15%) of
questions may be deliberate repeats from earlier sets for reinforcement;
Claude tells you how many were new versus reused. In Claude Code, typing
`/sat-practice-builder` suggests the arguments it takes (lesson, difficulty,
count) as you type.

Full details, including the catalog format and output file names, are in
the [plugin README](plugins/study-problem-sets/README.md).

## Repository layout

```
.claude-plugin/marketplace.json        catalog of all plugins in this repo
plugins/<plugin>/.claude-plugin/plugin.json
plugins/<plugin>/skills/<skill>/SKILL.md
plugins/<plugin>/README.md             setup and usage for that skill
dist/<skill>.zip                       upload-ready zips for the Claude app and ChatGPT Business/Enterprise
scripts/build-zips.sh                  rebuilds the zips in dist/
CHANGELOG.md                           version history for the plugin
```

## Adding a new skill

1. Create `plugins/<new-skill>/.claude-plugin/plugin.json` and
   `plugins/<new-skill>/skills/<new-skill>/SKILL.md` (copy the
   study-problem-sets plugin as a template).
2. Add an entry for it to the `plugins` list in
   `.claude-plugin/marketplace.json` and a row to the table above.
3. Run `./scripts/build-zips.sh` to create its zip in `dist/`.
4. Commit and push. Friends get it with `/plugin marketplace update`.

When you change an existing skill, bump its `version` in both `plugin.json`
and `marketplace.json`, and rebuild the zips.

Keep `SKILL.md` itself host-agnostic so it keeps working with Copilot,
ChatGPT and Codex (see Options 4–5 above) as well as Claude: don't name
Claude-only tools (e.g. `AskUserQuestion`) or paths (e.g.
`~/.claude/image-cache/`) as a hard requirement — describe the behavior
instead ("ask both questions in one turn") and mention the Claude Code
mechanism only as an example. The `.claude-plugin/` manifests are purely for
Claude's plugin-marketplace flow; the `dist/` zips are read by both the
Claude app and ChatGPT's Skills upload. None of this is read by Copilot or
Codex, which discover `SKILL.md` straight from the repo folders instead.

Also keep skill content generic rather than naming a specific publisher,
textbook brand, or test organization (see the disclaimer above) — name the
file/folder conventions the skill expects instead (for example the
`<suffix>_Concept.pdf`/`.docx` pattern), so the skill works for any course
with that shape and carries no trademark exposure.

Adding frontmatter fields beyond `name` and `description` (for example
`argument-hint`, as `sat-practice-builder` does for its Claude Code
slash-command autocomplete) is fine when a host-specific feature is worth
it, but it opts that skill out of claude.ai's/ChatGPT's strict zip-upload
path — only `name`, `description`, `license`, `compatibility`, `metadata`
and `allowed-tools` are allowed there. Note the tradeoff in the Install
section (see Option 3/5's notes on `sat-practice-builder`) rather than
silently shipping a zip that will fail to upload.
