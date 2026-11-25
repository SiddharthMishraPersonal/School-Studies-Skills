# study-problem-sets

A Claude skill for any numbered-lesson textbook or course — written in the
open Agent Skills format, so it's also compatible with GitHub Copilot,
ChatGPT and OpenAI Codex (see the main
[repo README](../../README.md#install) for how to install it on each). It
includes three skills — `problem-set-builder`, `problem-set-grader`, and
`sat-practice-builder` — which together do four things:

1. **Problem sets:** ask for a problem set for a lesson number, and it builds
   a PDF of practice questions on that lesson's concept, easiest to hardest,
   with optional step-by-step solutions at the end.
2. **Solve a book page:** upload or paste a screenshot or photo of a
   textbook page, and it solves every question on it in a PDF with
   step-by-step work and a clearly marked final answer. Any answer Claude is
   not fully sure of is marked **[Likely]** so you know to double-check it.
3. **Grade a solved sheet:** print a problem set, let the student solve it
   by hand, then scan it or photograph each page. Claude reads the
   handwritten answers, scores them against that set's answer key, and makes
   a graded report PDF.
4. **SAT-style practice:** builds a practice set in real digital-SAT-Math
   format (multiple choice plus grid-in, a reference-formula box,
   easy/medium/hard tags) covering one lesson, a lesson range, or the whole
   course — see "Build SAT-style practice" below.

It is not tied to any specific textbook, publisher, or subject — it works
from a concept guide you provide yourself (see below), so it works just as
well for algebra, chemistry, or any other course organized into numbered
lessons.

## One-time setup: your study folder

The skill works inside a folder you create yourself, named whatever you
like (for example `Algebra 1`, `AP Chemistry`, or just `Study`). It must
contain at least one **concept guide file** — named
`<anything>_Concept.pdf` or `<anything>_Concept.docx` (Word also works).
The `_Concept` part and the PDF/Word file type are required; the part
before it is up to you and becomes that guide's short name (its **alias**).
Each guide lists its lessons' numbers, titles, key rules and examples. This
is **not** included in this repository; make your own for the course you're
studying. If Claude can't find a matching file anywhere, it will not guess
— it asks you to either attach one or tell it which folder your concept
files are in. It never makes up a lesson's content without a guide.

**More than one concept file in the same folder is supported and
combined** — for example a course split into `Algebra1_Concept.pdf` and
`Geometry_Concept.docx`. Claude treats them as one course and can even
write a single question that draws on both. When more than one guide is
active, every lesson reference is prefixed with its alias (`Algebra1-24`)
so a lesson number is never ambiguous about which file it's from; with only
one guide, plain lesson numbers are used.

```
Algebra 1/                          (or any name you like)
├── Algebra1_Concept.pdf            you provide this (and/or more, see above)
├── Geometry_Concept.docx           optional: a second guide, combined with the first
├── Problem_Set_Catalog.json        record of everything generated
├── Problem Sets YYYY-MM-DD/        created by the skill
├── Graded YYYY-MM-DD/              graded reports and scan copies
├── SAT Practice YYYY-MM-DD/        SAT-style practice sets
├── media/                          screenshots you uploaded
└── adhoc-solutions/                solutions for those screenshots
```

Claude finds your concept file(s) by looking, in order, at:

1. any matching file you attached or uploaded in the chat,
2. every matching file in the folder Claude was started in, or in one
   immediate subfolder of it,
3. a search of your home folder, only if neither of those finds anything.

If multiple folders have concept files (different subjects), Claude asks
which one you mean, unless your request already names the subject. If
*nothing* matches anywhere, it stops and asks you to attach a file or point
to the right folder — it never assumes a default.

## How to use

Start Claude in your study folder (or the folder above it) and say, for
example:

- "Make a problem set for lesson 34"
- "Give me 15 questions on lesson 47 with solutions"
- *(paste a screenshot of a book page)* "Solve this"

Before creating anything, Claude:

- tells you which concept guide(s) it is using (or asks you for one — see
  above),
- **always asks where to put the files** — it never assumes or silently
  uses some default output area. Options are: the usual folder, another
  folder, or **a ZIP file with everything generated** (the PDF(s) plus the
  catalog) as a download. If you don't give it a real folder, it defaults
  to the ZIP and tells you plainly that it can't guarantee unique questions
  next time unless you give it a folder, or re-upload that ZIP's catalog
  file,
- for problem sets, asks how many questions you want and whether to include
  solutions.

## Catalog and unique questions

Everything the skill makes is recorded in `Problem_Set_Catalog.json`,
including the text of every question. When you ask for a lesson you have
done before, Claude lists your earlier sets and asks whether to reuse one or
make a new one. A new set never repeats a question from an earlier set for
that lesson: the style and concept stay the same, but the actual questions
are new. Solving the same screenshot twice works the same way.

If you only ever use the ZIP option and have no study folder, the updated
catalog file is always included inside the zip. Upload it next time so
Claude can keep questions unique instead of starting from zero history.

## Print, solve, scan, grade

1. **Print** the problem set. If it has solutions, print only the question
   pages; Claude tells you which ones (for example "pages 1-2").
2. The student writes their work in the space under each question and the
   final answer on the **Answer:** line.
3. **Scan** it into a PDF, or take a photo of each page. Your phone's
   built-in scanner works well (Notes or Files on iPhone, Google Drive on
   Android). Keep the page flat and well lit, with all four edges and the
   footer in the picture. Dark pencil or pen reads best.
4. Give the scan to Claude and say "grade this". It reads the **set ID** in
   the page footer (for example `Set L34-2026-11-19-01`) to find the right
   answer key, then asks:
   - **Grading style:** final answer only (recommended), or final answer
     plus work, with half credit for a right method with a small slip;
   - where to put the report — the usual folder, another folder, or a ZIP
     with the report, the scan copy, and the catalog.
5. You get a score, a report PDF listing what Claude read for each answer
   next to the correct answer, and short notes on each mistake.

**How it scores:** equivalent answers count (1/2 = 0.5 = 2/4), except when
the lesson is about simplifying, where an unsimplified answer is marked
wrong with a note. No connector, OCR app or extra setup is needed: Claude
reads handwriting directly from the scan.

**Unclear handwriting:** if a mark could be read two ways (1 or 7, a minus
sign or a stray mark), the question is marked **[Check]** with both
readings, so you can compare it with the paper. If Claude misread
something, say so (for example "question 4 says 7") and it regrades.

Every grading is saved in the catalog, so Claude can show progress on a
lesson over time.

## Build SAT-style practice

Not affiliated with the College Board — "SAT" describes the practice
format, not an official or licensed product. Say, for example:

- "Make SAT-level practice questions" — defaults to the **whole course**
  (every lesson in your concept guide) and **22 questions** (one real
  digital SAT Math module's length), **mixed** easy/medium/hard.
- "SAT questions through lesson 49" — lessons 1–49, spread across the range,
  not just lesson 49.
- "SAT practice for only lesson 12" — scoped to that one lesson.

In Claude Code, typing `/sat-practice-builder` suggests the arguments it
takes (lesson, difficulty, count) as you type; anywhere else, just say what
you want in plain language and Claude asks for anything missing.

If more than one concept guide is active, scope spans all of them (lessons
1-49 means lesson 1-49 of every active guide), and a question may combine a
concept from one guide with one from another.

Each question shows:
- the lesson(s) its concept comes from, under the question number (same
  style as `problem-set-builder`'s lesson references, including the alias
  prefix when more than one guide is active);
- an *(Easy)*, *(Medium)*, or *(Hard)* tag right after the question, in
  italics, smaller than body text;
- for multiple choice (most questions): four lettered choices, where every
  wrong one is built from a real, specific mistake (a sign error, the wrong
  formula, stopping one step early) rather than a random number;
- for the rest (a grid-in minority, like the real test): just a labelled
  answer box, no choices — only used when the answer is a plain positive
  number or simple fraction, since the real grid-in format can't take a
  negative sign or a variable.

A reference box of standard geometry facts (circle/triangle/rectangle area,
Pythagorean theorem, special right triangles, volumes) is printed once near
the top, the way the real test's math section opens.

**Repeats are allowed here, on purpose** (unlike `problem-set-builder`,
which never repeats): about 15% of a new set may be reinforcement questions
pulled from your earlier SAT sets for the same or a wider scope, so your
student sees a few familiar problems again. The rest are always freshly
written and checked against everything generated before. Claude tells you
how many were new versus reused each time. If solutions are included, every
wrong multiple-choice answer gets a one-line note on the mistake it
represents, not just the right answer.

## Output files

| What | Where | Name |
|------|-------|------|
| Problem set | `Problem Sets YYYY-MM-DD/` | `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf` |
| Your screenshot | `media/` | `Lesson<N>_Page_<YYYY-MM-DD>.<ext>` |
| Screenshot solutions | `adhoc-solutions/` | `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` |
| Graded report | `Graded YYYY-MM-DD/` | `Lesson<N>_Graded_<YYYY-MM-DD>.pdf` |
| Scan copy | `Graded YYYY-MM-DD/` | `Lesson<N>_Scan_<YYYY-MM-DD>.<ext>` |
| SAT practice set | `SAT Practice YYYY-MM-DD/` | `SAT_Practice_<scope>_<YYYY-MM-DD>.pdf` |

These are the usual locations; you can pick another folder, or a ZIP of
everything generated, instead. Files are never overwritten; a repeat gets
`_01`, `_02`, and so on.
