---
name: saxon-algebra-1
description: Builds Saxon Algebra 1 problem sets as PDFs focused on one specific lesson's concept, using the user's Saxon_Algebra1_Concept_Guide.pdf (asked for if it cannot be found) to know what each lesson teaches. Before building, confirms where the files should go (a folder on the computer, or download only), asks how many questions to make and whether to include solutions, and checks a catalog of earlier sets so the user can reuse one instead; every new set has questions that never appeared in an earlier set for that lesson. Also solves the questions on a screenshot or photo of an actual Saxon Algebra 1 book page in a step-by-step solutions PDF, marking any answer that is not certain with [Likely]. Use when asked to generate a problem set, practice set, questions, or worksheet for a Saxon Algebra 1 lesson number, or when the user uploads or pastes a screenshot of a Saxon Algebra 1 page to be solved.
---

This skill has two modes:

- **Mode A: Generate a problem set** for a lesson number.
- **Mode B: Solve a book page screenshot** when the user uploads or pastes a
  screenshot/photo of a Saxon Algebra 1 book page. Go to "Mode B" near the
  end of this file after doing the two shared steps below.

Both modes always start with **Shared step 1 (concept guide)** and
**Shared step 2 (catalog)**, and always confirm the output location
(**Shared step 3**) before creating any file.

Whenever this file says "ask", ask all the questions due at that point
together in one turn (use a structured multiple-choice prompt if your
environment has one, such as Claude Code's AskUserQuestion tool; otherwise
ask them in plain text in a single message). Never ask a question the user
already answered in their request.

# Shared step 1: Get the concept guide (always, before anything else)

The concept guide `Saxon_Algebra1_Concept_Guide.pdf` lists each lesson's
number, title, key rule and example. It is how this skill knows what a
lesson teaches. **Never generate or solve anything without reading it
first, and never invent a lesson's content from memory.**

Find it in this order and stop at the first match:

1. A copy the user attached or uploaded in this conversation.
2. A file of that name in the current working directory, or in a
   `Saxon Algebra 1` folder inside it.
3. A search of the user's home folder (up to about 4 levels deep, skipping
   hidden and system folders such as `Library`) for
   `Saxon_Algebra1_Concept_Guide.pdf`.

Then:

- **Found exactly one:** tell the user in one line which guide you are using
  (its full path, or "the guide you uploaded") and continue. If they say it
  is the wrong one, ask for the right one.
- **Found more than one:** ask which one to use.
- **Found none** (or, in the Claude app, the folder is not shared with the
  session): stop and ask the user to upload the guide or give its path (or
  give access to the folder that has it). Explain briefly that the guide is
  needed so the questions match what the lesson teaches. Do not continue
  until you have it.

Read the guide and find the target lesson. If lesson N is not in the guide,
tell the user and stop.

The **base folder** is the folder that contains the guide on disk (normally
named `Saxon Algebra 1`). If the guide was only uploaded into the chat,
there is no base folder.

# Shared step 2: Read the catalog

The catalog is a JSON file, `Saxon_Algebra1_Catalog.json`, that records
everything this skill has generated. It lets the skill offer earlier files
for reuse and keep new questions unique.

**Where it lives:** in the base folder. If there is no base folder, or it is
not writable, it lives in the output folder the user chooses in Shared step
3. If the user uploaded a catalog file in the chat, use that one.

If no catalog exists yet, start an empty one:

```json
{
  "catalog_version": 1,
  "problem_sets": [],
  "solved_pages": [],
  "gradings": []
}
```

Each `problem_sets` entry:

```json
{
  "id": "L34-2026-11-19-01",
  "lesson": 34,
  "lesson_title": "Title from the guide",
  "created": "2026-11-19",
  "question_count": 15,
  "solutions": true,
  "delivery": "saved",
  "file": "/full/path/to/Lesson34_Problem_Set_2026-11-19.pdf",
  "question_pages": "1-2",
  "solution_pages": "3-4",
  "questions": ["Solve for x: 3x + 5 = 20", "..."],
  "answers": [
    {"n": 1, "answer": "x = 5", "accept": ["5", "x=5"], "simplest_form_required": false},
    "..."
  ]
}
```

`delivery` is `"saved"` (written to a folder on the user's computer) or
`"download"` (only given to the user as a download; `file` is then just the
file name). `questions` holds the full text of every question, in order, in
plain text (exponents may be written `x^2` here). Always store it, even for
downloads, because it is what keeps future sets unique.

`answers` is the answer key, one entry per question in the same order:
`answer` is the final answer as it would be printed, `accept` lists other
correct ways to write it (equivalent forms a student could reasonably write,
such as `0.5` for `1/2`), and `simplest_form_required` is true when lesson
N's key rule is about simplifying, so an unsimplified answer is not full
credit. **Always store the answer key, even when the user chose "questions
only"**, so the grading skill can score any set. `solution_pages` is null
when there is no solutions section.

The catalog may also contain a `gradings` list written by the
`saxon-algebra-1-grader` skill. Leave it as it is.

Each `solved_pages` entry: `lesson` (or null), `created`, `image_sha256`
(SHA-256 of the screenshot file), `image_file`, `solutions_file`,
`delivery`.

**Earlier sets not in the catalog:** if problem set PDFs exist in
`<base>/Problem Sets */` (or the chosen output folder) for the target lesson
but are missing from the catalog, extract their question text (for example
with `pdftotext` or `pypdf`), add entries for them, and treat them like any
other catalog entry.

# Shared step 3: Confirm where the output goes (always, before creating files)

Ask where the files should go, offering:

1. **The usual folder** (shown with its full path): for problem sets
   `<base>/Problem Sets YYYY-MM-DD/`; for Mode B `<base>/media/` for the
   screenshot and `<base>/adhoc-solutions/` for the solutions PDF. Offer this
   only when there is a base folder.
2. **Another folder on my computer** (the user gives the path).
3. **Don't save to my computer; give me a download.**

If the user already said where in their request, or already answered this
question earlier in the same conversation, use that and do not ask again.

**Download mode:** produce the file through whatever download mechanism the
environment has (for example, in the Claude app, write it to the outputs
folder so it appears as a downloadable file in the chat). If the environment
has no way to hand over a download (for example Claude Code in a terminal),
say so and offer to save it to a temporary folder they can copy it from, or
to a folder of their choice. In download mode, do not write the PDF or the
screenshot anywhere on the user's computer.

**The catalog in download mode:** the catalog is a small text file, not an
output, so keep updating it in the base folder if there is one. If there is
no base folder, also hand over the updated `Saxon_Algebra1_Catalog.json` as
a download and tell the user to upload it next time so the skill can avoid
repeating questions and offer earlier sets.

**Files never overwrite** in any folder: if a name is taken, add the next
free two-digit suffix: `_01`, `_02`, `_03`, ... (before the extension).
When reporting files, give full absolute paths for saved files.

# Mode A: Generate a problem set

## A1: Check for earlier sets of this lesson

If the request has no lesson number, ask for it first.

Look up lesson N in the catalog. If there are earlier problem sets for it,
list them briefly (date, number of questions, with or without solutions,
saved path or "downloaded") and ask:

- **Use an existing set** (name which one, if there are several), or
- **Generate a new set** with new questions.

Ask this together with the A2 questions in the same turn, noting that the
A2 answers are only used if they choose a new set.

If they choose an existing set:
- if its file still exists on disk, give its full path (or, if they want a
  download, provide a copy as a download);
- if the file is gone (or it was a download), say so and offer to rebuild
  that same set from the questions stored in the catalog, or to generate a
  new one. A rebuild keeps its questions and is the only case where
  questions may repeat. Do not add a new catalog entry for a rebuild.

Then stop; do not generate a new set.

## A2: Ask before creating

In one turn (together with A1 and Shared step 3 when those apply), ask:

1. **How many questions?** Offer options such as 10, 15, 20 and 30 (the user
   can give any other number).
2. **Include solutions?** "Yes, step-by-step solutions at the end" or "No,
   questions only".
3. **Where should it go?** (Shared step 3)

Do not start building until every answer is known.

## A3: Build the questions

Generate Q questions (Q = the number chosen) that practise lesson N's
concept.

**Content rules**
- **Every question tests lesson N's concept**, as described by the lesson's
  title, key rule and example in the concept guide. Do not fill the set with
  review of other lessons.
- **Prerequisites only as support.** A question may use skills from lessons
  1 to N-1 when lesson N's concept needs them, but never a skill from a
  lesson after N.
- **Difficulty ramp**, easiest to hardest:
  - first third: direct, one-step applications of the key rule, close to the
    guide's example;
  - middle third: standard problems with two or more steps;
  - last third: harder forms, including at least one word problem when the
    concept allows it.
- **Variety.** Vary numbers, signs, variable names and problem forms.

**Uniqueness rules (strict)**
- Collect every question already stored in the catalog for lesson N (all
  earlier sets, including downloaded ones).
- Every new question must be new. The style, form and concept can match
  earlier sets, but the actual question must differ: different numbers,
  expressions or scenario. Changing only the variable letter, the order of
  terms, or the wording around the same numbers does not count as new.
- No two questions within the new set may be the same either.
- **Check with code before writing the PDF.** Normalize each question
  (lowercase, collapse whitespace, strip punctuation, replace every single
  letter variable with a placeholder, and sort the terms of sums where it is
  easy to do) and compare it with the normalized earlier questions and with
  the rest of the new set. Replace any match with a fresh question and check
  again until there are no matches.
- If the concept is so narrow that there are almost no new questions left
  (rare), tell the user before building and offer a shorter set.

**Answers:** compute every answer with code (for example Python with sympy
or fractions) and check it before writing the PDF, even when solutions are
not printed. Build the answer key (`answers` in the catalog) from these
checked results.

**Set ID:** give the set its ID before writing the PDF:
`L<N>-<YYYY-MM-DD>-<NN>`, where NN is `01` for the first set of lesson N
made today, `02` for the second, and so on (check the catalog). This ID is
printed on every page and is how the grading skill matches a scanned sheet
to its answer key.

## A4: Write the PDF

The sheet will usually be printed, solved by hand, then scanned or
photographed and graded by the `saxon-algebra-1-grader` skill. Lay it out so
handwriting is easy to find and read.

- **File name:** `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf` with today's date,
  for example `Lesson34_Problem_Set_2026-11-19.pdf` (plus `_01`, `_02`, ...
  if taken).
- **Location:** as chosen in Shared step 3. For the usual folder, create
  `<base>/Problem Sets YYYY-MM-DD/` (today's date) if needed.
- Letter size, PDF only. Real superscripts for exponents, not `^`.
- **Footer on every page** (questions and solutions):
  `Set <ID> · Page <p> of <total>`, for example
  `Set L34-2026-11-19-01 · Page 1 of 3`, in plain black text at least 9 pt,
  centred at the bottom.
- **Questions section** (always): title "Lesson N Problem Set", the lesson
  title, a Name / Date / Score ___ / Q line, and one instruction line: "Show
  your work. Write your final answer on the Answer line." Then the numbered
  questions 1 to Q, with no answers or hints.
  - Under each question, blank work space (at least about 1.5 inches, more
    for multi-step and word problems).
  - At the bottom of each question's space, a labelled answer line at the
    right: `Answer: ______________________` (long enough for a fraction or
    an expression).
  - Never split a question, its work space or its answer line across two
    pages.
- **Scan-friendly layout:** black text on a white background only (no grey
  shading, coloured boxes or background images), margins of at least 0.75
  inch on every side, body text at least 12 pt, and nothing printed near the
  page edges except the footer.
- **Solutions section** (only if chosen): starts on a new page titled
  "Solutions"; same 1 to Q order, each with the question restated, full
  step-by-step work, and the final answer clearly marked (bold, or prefixed
  "Answer:"). Keep solutions on their own pages so they can be left out when
  printing. Record the page ranges in `question_pages` and
  `solution_pages`.

## A5: Update the catalog and reply

Add the new set to the catalog (with its ID, all its question texts and the
answer key) and save the catalog as described in Shared steps 2 and 3. Then
tell the user:

- where the PDF is (full path, or that it is ready to download) and its set
  ID;
- that its questions were checked against the earlier sets for this lesson
  (say how many);
- **printing:** if the PDF has solutions, which pages to print for the
  student (for example "print pages 1-2 only; pages 3-4 are the
  solutions");
- **grading:** once the sheet is solved, scan it or take a photo of each
  page (flat, well lit, all four edges and the footer visible) and ask to
  grade it. The `saxon-algebra-1-grader` skill will score it against this
  set's answer key.

## Several lessons at once

Ask the questions once and apply the answers to every lesson, unless the
user asks for different settings per lesson. Do the A1 check for each
lesson (list all earlier sets in one question). Save one PDF and one catalog
entry per lesson.

# Mode B: Solve a Saxon Algebra 1 book page screenshot

Use this mode whenever the user uploads, pastes or points to an image
(screenshot or photo) of an actual Saxon Algebra 1 lesson page. Do Shared
steps 1 and 2 first. Do not ask how many questions or whether to include
solutions: solve every question on the page and always include step-by-step
solutions.

## B1: Find the image and check the catalog

- **Find the image file:** if the user gave a file path, or the image was
  attached as a file, use that file (never move or delete the original). If
  it was pasted into the chat, look for a local cached copy using whatever
  your environment provides (for example, Claude Code caches pasted images
  under `~/.claude/image-cache/`, matching the time of the message).
- Compute the file's SHA-256 and look it up in the catalog's
  `solved_pages`. If this exact page was solved before, tell the user (date
  and where the solutions are) and ask whether to use the existing solutions
  or solve it again. If they choose the existing ones, give the path (or a
  download copy) and stop.
- Otherwise, ask where the output should go (Shared step 3).

## B2: Save the screenshot (only if saving to the computer)

- In the usual folder: `<base>/media/` (create it if missing). In another
  folder: that folder. In download mode: do not save the screenshot.
- **File name:** `Lesson<N>_Page_<YYYY-MM-DD>.<ext>`, keeping the original
  extension, where N is the lesson number printed on the page. If the page
  shows a range of lessons or none, use `Saxon_Page_<YYYY-MM-DD>.<ext>`.
  Save each page if several are uploaded.
- If no file of the image can be found on disk, still solve the page, then
  tell the user the screenshot could not be saved automatically and ask them
  to give its path so you can copy it.

## B3: Read the page and find the questions

- Read every question on the page: lesson practice problems (a, b, c, ...),
  numbered problem-set problems (1, 2, 3, ...), example problems the user
  asks about, and every part of multi-part questions. Keep the book's own
  labels and order.
- If the page has no questions (only explanation), say so, summarise the
  concept briefly, and do not create a PDF unless the user asks.
- If part of the page is cut off, blurry or hidden, solve what is readable,
  and list the unreadable questions in the PDF and in your reply as "could
  not read" rather than guessing silently.
- Use the concept guide to identify the lesson's concept and to solve the
  way Saxon teaches it (its methods and vocabulary).

## B4: Solve

- Give **full step-by-step work** for every question, then the **final
  answer** clearly marked (bold and prefixed "Answer:").
- Check every numerical/algebraic answer with code (for example Python with
  sympy or fractions) before writing the PDF. Simplify answers the way Saxon
  expects (reduced fractions, like terms combined, units on word problems).
- For multiple-choice questions, show the work and name the chosen letter.
- **Confidence marking:** if you are not 100% sure a solution is correct
  (the question was hard to read, the wording is ambiguous, a figure was
  unclear, the answer could not be verified with code, or more than one
  interpretation is possible), put **[Likely]** next to that question's label
  (for example "7. [Likely]") and add a one-line note under its answer saying
  why. Only questions you are fully certain of go unmarked.

## B5: Write the solutions PDF

- **Location:** as chosen in Shared step 3 (usual folder:
  `<base>/adhoc-solutions/`, created if missing).
- **File name:** `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` (or
  `Saxon_Page_Solutions_<YYYY-MM-DD>.pdf` if no lesson number), with `_01`,
  `_02`, ... instead of overwriting. Several screenshots of the same lesson
  uploaded together go in one PDF.
- **Layout (letter size):** title "Lesson N Solutions", the lesson title,
  today's date, and the screenshot file name it was solved from; if any
  question is marked [Likely], a line under the title: "Questions marked
  [Likely] could not be fully verified; please check them."; then each
  question in book order with its label, the question restated, numbered
  steps and the final answer. Real superscripts and proper fractions.

## B6: Update the catalog and reply

Add a `solved_pages` entry for each page and save the catalog. Tell the user
where the screenshot and the solutions PDF are (full paths, or that the PDF
is ready to download), list the final answers briefly (label and answer),
and name any questions marked [Likely] or not readable.
