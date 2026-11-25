---
name: problem-set-builder
description: Builds lesson-focused problem sets as PDFs from the user's own concept guide file(s) — any file matching "<suffix>_Concept.pdf" or "<suffix>_Concept.docx" — using them to know what each lesson teaches. If a folder has several concept files, combines them all, citing each question's source lesson(s) by the file's suffix as an alias. Always asks where to save (a folder, or a ZIP of everything generated) before creating anything; never assumes a save location. Also solves the questions on a screenshot or photo of an actual textbook page in a step-by-step solutions PDF, marking any answer that is not certain with [Likely]. Use when asked to generate a problem set, practice set, questions, or worksheet for a numbered lesson in a textbook or course, or when the user uploads or pastes a screenshot of a textbook page to be solved.
---

This skill has two modes:

- **Mode A: Generate a problem set** for a lesson number.
- **Mode B: Solve a book page screenshot** when the user uploads or pastes a
  screenshot/photo of a textbook page. Go to "Mode B" near the end of this
  file after doing the two shared steps below.

Both modes always start with **Shared step 1 (concept guide(s))** and
**Shared step 2 (catalog)**, and always confirm the output location
(**Shared step 3**) before creating any file.

Whenever this file says "ask", ask all the questions due at that point
together in one turn (use a structured multiple-choice prompt if your
environment has one, such as Claude Code's AskUserQuestion tool; otherwise
ask them in plain text in a single message). Never ask a question the user
already answered in their request.

# Shared step 1: Get the concept guide(s) (always, before anything else)

A **concept guide** is any file named `<suffix>_Concept.pdf`,
`<suffix>_Concept.docx`, or `<suffix>_Concept.doc` — the suffix can be
anything (for example `Algebra1_Concept.pdf` or `Unit2_Concept.docx`), but
the `_Concept.` part and the file type (PDF or Word only) are a strict
requirement. Each one lists its lessons' numbers, titles, key rules and
examples. This is how the skill knows what a lesson teaches. **Never
generate or solve anything without reading the relevant guide(s) first, and
never invent a lesson's content from memory.**

**A folder can have more than one concept file** — for example a course
split into `Algebra1_Concept.pdf` and `Geometry_Concept.docx`. When it does,
use all of them together as one combined course, not just one.

Find candidates in this order:

1. Any matching file the user attached or uploaded in this conversation.
2. Every matching file in the current working directory, or in any one
   immediate subfolder of it.
3. If neither of those finds anything, search the user's home folder (up to
   about 4 levels deep, skipping hidden and system folders such as
   `Library`) for matching files.

Then:

- **Found one or more matching files in a single location** (the chat
  upload, or one folder): use all of them together as this request's
  concept guides. Tell the user in one line which file(s) you're using (by
  name, or "the file(s) you uploaded").
- **Found candidates in more than one folder** (for example, separate
  folders for different subjects): if the user's request already names a
  subject or course and exactly one folder clearly matches, use that
  folder's file(s) and say which, as above. Otherwise list the folders by
  subject/folder name (not bare file paths) and ask which one to use —
  then use every matching file inside the chosen folder together.
- **Found none anywhere:** **do not assume anything** — stop and ask the
  user to either attach a concept file (matching the
  `<suffix>_Concept.pdf`/`.docx` pattern) or tell you which folder their
  concept files are in. Do not guess a folder, a subject, or any lesson
  content. Do not continue until you have at least one file.
- **Two matching files would produce the same alias** (their suffixes are
  identical, e.g. `Algebra1_Concept.pdf` and `Algebra1_Concept.docx` in the
  same folder): this is ambiguous — tell the user and ask them to rename
  one or say which to use, rather than guessing.

**Reading each guide:** read `.pdf` files directly. For `.docx`/`.doc`
files, extract the text first (for example with `python-docx`, or by
converting to PDF/plain text) before reading — the expected content
(lesson number, title, key rule, example) is the same regardless of file
type.

**Alias:** each guide's alias is its suffix — the part of the file name
before `_Concept` (for example `Algebra1_Concept.pdf` → alias `Algebra1`).
Aliases are how lesson numbers are cited when more than one guide is in
play (Shared step 1 continued in A3/A4 below), since the same lesson number
can exist in more than one guide.

Read every active guide in full and note every lesson number each one
contains. If the target lesson isn't in any active guide, tell the user and
stop (or ask which guide it should be in, if that's unclear).

The **base folder** is the folder that contains the guide(s) on disk. It
can be named anything — there is no fixed folder name to look for. If every
active guide was only uploaded into the chat, there is no base folder.

# Shared step 2: Read the catalog

The catalog is a JSON file, `Problem_Set_Catalog.json`, that records
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
  "concept_guides": [{"alias": "Algebra1", "file": "Algebra1_Concept.pdf"}],
  "created": "2026-11-19",
  "question_count": 15,
  "solutions": true,
  "delivery": "saved",
  "file": "/full/path/to/Lesson34_Problem_Set_2026-11-19.pdf",
  "question_pages": "1-2",
  "solution_pages": "3-4",
  "questions": ["Solve for x: 3x + 5 = 20", "..."],
  "lesson_refs": [
    [{"alias": "Algebra1", "lesson": 34}],
    [{"alias": "Algebra1", "lesson": 34}, {"alias": "Algebra1", "lesson": 12}],
    "..."
  ],
  "answers": [
    {"n": 1, "answer": "x = 5", "accept": ["5", "x=5"], "simplest_form_required": false},
    "..."
  ]
}
```

`delivery` is `"saved"` (written to a folder on the user's computer),
`"zip"` (bundled into a ZIP download with other files from the same
operation; `file` is then the name inside the zip), or `"download"` (a
single file download on its own; kept for older entries). `questions` holds
the full text of every question, in order, in plain text (exponents may be
written `x^2` here). Always store it, even in zip/download mode, because it
is what keeps future sets unique. `concept_guides` lists every guide used
for this set (alias and file name) so a later session can tell which alias
means which file.

`lesson_refs` is the lesson citation printed under each question's number,
one entry per question in the same order: a list of `{alias, lesson}`
pairs for every lesson that specific question's concept draws on. The
target lesson N (with whichever guide it came from) is always included;
add more pairs only when that particular question actually leans on a
prerequisite skill from another lesson — in the same guide or a different
one (per "Prerequisites only as support" and "Combining concepts" below).
Most questions will just have one pair. Always record the alias, even when
only one concept guide is active, so the catalog stays consistent if a
second guide is added to the folder later; whether the alias gets *printed*
on the page depends on how many guides are active for that document (see
A4).

`answers` is the answer key, one entry per question in the same order:
`answer` is the final answer as it would be printed, `accept` lists other
correct ways to write it (equivalent forms a student could reasonably write,
such as `0.5` for `1/2`), and `simplest_form_required` is true when lesson
N's key rule is about simplifying, so an unsimplified answer is not full
credit. **Always store the answer key, even when the user chose "questions
only"**, so the grading skill can score any set. `solution_pages` is null
when there is no solutions section.

The catalog may also contain a `gradings` list written by the
`problem-set-grader` skill. Leave it as it is.

Each `solved_pages` entry: `lesson` (or null), `created`, `image_sha256`
(SHA-256 of the screenshot file), `image_file`, `solutions_file`,
`delivery`.

**Earlier sets not in the catalog:** if problem set PDFs exist in
`<base>/Problem Sets */` (or the chosen output folder) for the target lesson
but are missing from the catalog, extract their question text (for example
with `pdftotext` or `pypdf`), add entries for them, and treat them like any
other catalog entry. Older PDFs made before this skill printed lesson
references won't have one to extract; leave `lesson_refs` empty (`[]`) for
those questions rather than guessing.

# Shared step 3: Confirm where the output goes (always, before creating files)

**Always ask — never assume a save location**, even if earlier turns in
this conversation wrote files somewhere. Specifically, never silently save
into whatever generic "outputs"/files area your environment offers by
default without the user having chosen it here. Offer:

1. **The usual folder** (shown with its full path): for problem sets
   `<base>/Problem Sets YYYY-MM-DD/`; for Mode B `<base>/media/` for the
   screenshot and `<base>/adhoc-solutions/` for the solutions PDF. Offer this
   only when there is a base folder.
2. **Another folder on my computer** (the user gives the path).
3. **A ZIP file with everything this generates** (the PDF, plus the
   screenshot in Mode B, plus the catalog as it stands after this request),
   handed over as a single download.

If the user already said where in their request, or already answered this
question earlier in the same conversation, use that and do not ask again.

**If the user doesn't give a real folder** (they pick option 3, or don't
answer with a folder when asked), **default to the ZIP option** and say so
plainly, including this caveat: *since nothing is being saved anywhere you
can read back later, future requests won't have this catalog to check
against, so new sets may end up repeating these questions unless you give a
real folder next time, or re-upload this ZIP's catalog file.* If the user
says uniqueness matters to them, ask them for a real folder instead of
proceeding in ZIP mode.

**ZIP mode:** build the PDF(s) and the updated catalog as files, package
them into one `.zip` (name it `<something>_<YYYY-MM-DD>.zip` describing
what's inside, for example `Lesson34_Problem_Set_2026-11-19.zip`), and hand
that zip over through whatever download mechanism the environment has (for
example, in the Claude app, write it to the outputs folder so it appears as
a downloadable file in the chat). If the environment has no way to hand
over a download at all (for example Claude Code in a terminal with no
output-sharing path), say so and offer to save everything to a temporary
folder they can copy from instead. Don't write anything to the user's
computer in ZIP mode beyond that temporary-folder fallback.

**The catalog in ZIP mode:** always include the catalog, current as of this
request, inside the zip (see the caveat above) — this is what lets the user
restore uniqueness tracking later by re-uploading it.

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
  title, key rule and example in its concept guide. Do not fill the set with
  review of other lessons.
- **Prerequisites only as support.** A question may use skills from lessons
  1 to N-1 (in lesson N's own guide, or in another active guide covering
  content taught before lesson N) when lesson N's concept needs them, but
  never a skill taught after N.
- **Combining concepts across guides.** When more than one concept guide is
  active, questions aren't limited to one file: a question may combine
  lesson N's concept with a prerequisite skill from a *different* guide
  (for example, an Algebra lesson needing a Geometry fact from an earlier
  lesson in `Geometry_Concept.docx`), as long as that skill was taught
  before the point this set is practising. This is encouraged where it
  makes a more realistic question, not required for every question.
- **Lesson reference per question.** As you write each question, note every
  lesson its concept actually comes from, as `{alias, lesson}` pairs: lesson
  N's own pair, plus a pair for each prerequisite lesson a question leans
  on, whichever guide it's from (for example, a lesson 47 question in
  `Algebra1` needing `Algebra1` lesson 31 gets
  `[{alias:Algebra1,lesson:47},{alias:Algebra1,lesson:31}]`; one also using
  a Geometry fact gets a third pair with `alias:Geometry`). This is what
  gets printed under the question number (see A4) and stored in the
  catalog's `lesson_refs`.
- **Difficulty ramp**, easiest to hardest:
  - first third: direct, one-step applications of the key rule, close to the
    guide's example;
  - middle third: standard problems with two or more steps;
  - last third: harder forms, including at least one word problem when the
    concept allows it.
- **Variety.** Vary numbers, signs, variable names and problem forms.

**Uniqueness rules (strict)**
- Collect every question already stored in the catalog for lesson N (all
  earlier sets, including zipped/downloaded ones).
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
photographed and graded by the `problem-set-grader` skill. Lay it out so
handwriting is easy to find and read.

- **File name:** `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf` with today's date,
  for example `Lesson34_Problem_Set_2026-11-19.pdf` (plus `_01`, `_02`, ...
  if taken).
- **Location:** as chosen in Shared step 3. For the usual folder, create
  `<base>/Problem Sets YYYY-MM-DD/` (today's date) if needed.
- Letter size, PDF only. Real superscripts for exponents, not `^`.
- **Footer on every page** (questions and solutions): `Set <ID> · Page <p>
  of <total>`, for example `Set L34-2026-11-19-01 · Page 1 of 3`, in plain
  black text at least 9 pt, centred at the bottom. **When more than one
  concept guide is active** for this set, add a second small line right
  below it listing the alias key, for example
  `Algebra1 = Algebra1_Concept.pdf · Geometry = Geometry_Concept.docx`, so
  the lesson references below are unambiguous. Omit this second line
  entirely when only one guide is active.
- **Questions section** (always): title "Lesson N Problem Set", the lesson
  title, a Name / Date / Score ___ / Q line, and one instruction line: "Show
  your work. Write your final answer on the Answer line." Then the numbered
  questions 1 to Q, with no answers or hints.
  - **Lesson reference under the question number**, the way a Saxon-style
    textbook prints it: directly beneath the question's number (in the same
    narrow left-margin column as the number, not beside the question text),
    its `lesson_refs` for that question in parentheses. **When only one
    concept guide is active**, print plain lesson numbers — a single number
    for one lesson (`(31)`), comma-separated with no spaces for several
    (`(24,65,99)`). **When more than one guide is active**, print every
    reference as `alias-lesson` pairs instead, even for a question that
    only cites one guide (for consistency across the sheet), comma-separated
    for several (`(Algebra1-31)` or `(Algebra1-24,Geometry-10)`). Set this
    in *italic*, one point smaller than the body text (for example 11 pt on
    12 pt body). It is a citation, not part of the question: never read it
    aloud as something to solve, and never let it collide with or run into
    the question text to its right.
  - Under each question, blank work space (at least about 1.5 inches, more
    for multi-step and word problems).
  - At the bottom of each question's space, a labelled answer line at the
    right: `Answer: ______________________` (long enough for a fraction or
    an expression).
  - Never split a question, its work space, its answer line or its lesson
    reference across two pages.
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

Add the new set to the catalog (with its ID, `concept_guides` used, all its
question texts, their `lesson_refs` and the answer key) and save the
catalog as described in Shared steps 2 and 3. Then tell the user:

- where the PDF is (full path, inside the zip, or that it is ready to
  download) and its set ID;
- that its questions were checked against the earlier sets for this lesson
  (say how many);
- **printing:** if the PDF has solutions, which pages to print for the
  student (for example "print pages 1-2 only; pages 3-4 are the
  solutions");
- **grading:** once the sheet is solved, scan it or take a photo of each
  page (flat, well lit, all four edges and the footer visible) and ask to
  grade it. The `problem-set-grader` skill will score it against this set's
  answer key.

## Several lessons at once

Ask the questions once and apply the answers to every lesson, unless the
user asks for different settings per lesson. Do the A1 check for each
lesson (list all earlier sets in one question). Save one PDF and one catalog
entry per lesson.

# Mode B: Solve a textbook page screenshot

Use this mode whenever the user uploads, pastes or points to an image
(screenshot or photo) of an actual textbook lesson page. Do Shared steps 1
and 2 first. Do not ask how many questions or whether to include solutions:
solve every question on the page and always include step-by-step solutions.

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

## B2: Save the screenshot (only if saving to a real folder)

- In the usual folder: `<base>/media/` (create it if missing). In another
  folder: that folder. In ZIP mode: include it in the zip instead of saving
  it separately.
- **File name:** `Lesson<N>_Page_<YYYY-MM-DD>.<ext>`, keeping the original
  extension, where N is the lesson number printed on the page. If the page
  shows a range of lessons or none, use `Lesson_Page_<YYYY-MM-DD>.<ext>`.
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
- Use the relevant concept guide (if more than one is active, whichever
  covers the page's lesson) to identify the lesson's concept and to solve it
  the way that guide teaches it (its methods and vocabulary).

## B4: Solve

- Give **full step-by-step work** for every question, then the **final
  answer** clearly marked (bold and prefixed "Answer:").
- Check every numerical/algebraic answer with code (for example Python with
  sympy or fractions) before writing the PDF. Simplify answers the way the
  concept guide expects (reduced fractions, like terms combined, units on
  word problems).
- For multiple-choice questions, show the work and name the chosen letter.
- **Confidence marking:** if you are not 100% sure a solution is correct
  (the question was hard to read, the wording is ambiguous, a figure was
  unclear, the answer could not be verified with code, or more than one
  interpretation is possible), put **[Likely]** next to that question's label
  (for example "7. [Likely]") and add a one-line note under its answer saying
  why. Only questions you are fully certain of go unmarked.

## B5: Write the solutions PDF

- **Location:** as chosen in Shared step 3 (usual folder:
  `<base>/adhoc-solutions/`, created if missing; ZIP mode: included in the
  zip).
- **File name:** `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` (or
  `Lesson_Page_Solutions_<YYYY-MM-DD>.pdf` if no lesson number), with `_01`,
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
where the screenshot and the solutions PDF are (full paths, inside the zip,
or that the PDF is ready to download), list the final answers briefly
(label and answer), and name any questions marked [Likely] or not readable.
