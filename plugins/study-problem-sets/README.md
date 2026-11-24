# study-problem-sets

A Claude skill for any numbered-lesson textbook or course — written in the
open Agent Skills format, so it's also compatible with GitHub Copilot,
ChatGPT and OpenAI Codex (see the main
[repo README](../../README.md#install) for how to install it on each). It
includes two skills, `problem-set-builder` and `problem-set-grader`, which
together do three things:

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

It is not tied to any specific textbook, publisher, or subject — it works
from a concept guide you provide yourself (see below), so it works just as
well for algebra, chemistry, or any other course organized into numbered
lessons.

## One-time setup: your study folder

The skill works inside a folder you create yourself, named whatever you
like (for example `Algebra 1`, `AP Chemistry`, or just `Study`). It must
contain a file named `Concept_Guide.pdf` listing each lesson's number,
title, key rule and an example. The skill uses it to know what each lesson
teaches. This guide is **not** included in this repository; make your own
for the course you're studying. If Claude cannot find the guide, it asks you
to upload it or tell it where it is. It never makes up a lesson's content
without the guide.

```
Algebra 1/                          (or any name you like)
├── Concept_Guide.pdf               you provide this
├── Problem_Set_Catalog.json        record of everything generated
├── Problem Sets YYYY-MM-DD/        created by the skill
├── Graded YYYY-MM-DD/              graded reports and scan copies
├── media/                          screenshots you uploaded
└── adhoc-solutions/                solutions for those screenshots
```

Claude finds the folder by looking, in order, at:

1. the folder Claude was started in (if `Concept_Guide.pdf` is directly in
   it),
2. any immediate subfolder of the folder Claude was started in,
3. a search of your home folder for `Concept_Guide.pdf`.

If it still cannot find it, it asks you where it is. In the Claude app, give
Claude access to your study folder.

## How to use

Start Claude in your study folder (or the folder above it) and say, for
example:

- "Make a problem set for lesson 34"
- "Give me 15 questions on lesson 47 with solutions"
- *(paste a screenshot of a book page)* "Solve this"

Before creating anything, Claude:

- tells you which concept guide it is using (or asks you for one),
- asks where to put the files: the usual folder, another folder, or **just
  give me a download** (nothing saved on your computer),
- for problem sets, asks how many questions you want and whether to include
  solutions.

## Catalog and unique questions

Everything the skill makes is recorded in `Problem_Set_Catalog.json`,
including the text of every question. When you ask for a lesson you have
done before, Claude lists your earlier sets and asks whether to reuse one or
make a new one. A new set never repeats a question from an earlier set for
that lesson: the style and concept stay the same, but the actual questions
are new. Solving the same screenshot twice works the same way.

If you only use downloads and have no study folder, Claude also gives you
the updated catalog file to download. Upload it next time so it can keep
questions unique.

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
   - where to put the report (or just give a download).
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

## Output files

| What | Where | Name |
|------|-------|------|
| Problem set | `Problem Sets YYYY-MM-DD/` | `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf` |
| Your screenshot | `media/` | `Lesson<N>_Page_<YYYY-MM-DD>.<ext>` |
| Screenshot solutions | `adhoc-solutions/` | `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` |
| Graded report | `Graded YYYY-MM-DD/` | `Lesson<N>_Graded_<YYYY-MM-DD>.pdf` |
| Scan copy | `Graded YYYY-MM-DD/` | `Lesson<N>_Scan_<YYYY-MM-DD>.<ext>` |

These are the usual locations; you can pick another folder or a download
instead. Files are never overwritten; a repeat gets `_01`, `_02`, and so on.
