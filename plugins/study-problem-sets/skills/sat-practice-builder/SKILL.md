---
name: sat-practice-builder
description: Builds SAT-style math practice sets as PDFs from the user's own concept guide file(s) — files named SUFFIX_Concept.pdf or SUFFIX_Concept.docx, combined when a folder has more than one, with lesson citations using each file's suffix as an alias. Scope defaults to the whole course, or can be one lesson or a range ("through lesson 49" = lessons 1-49). Real digital SAT Math format: mostly four-choice multiple choice plus some grid-in, a reference-formula box, each question tagged with its source lesson(s) and an easy/medium/hard label. Wrong choices are built from real common mistakes, not random numbers; every answer is code-verified. Always asks where to save (a folder, or a ZIP of everything) before creating anything. Mostly brand-new questions each time, with a small share of reinforcement repeats allowed on purpose, unlike problem-set-builder's strict never-repeat rule. Use for SAT-level, SAT-style, SAT-prep, or test-prep practice, optionally scoped to specific lessons.
argument-hint: [lesson <N> | lessons 1-<N> | whole course (default)] [difficulty easy|medium|hard|mixed (default)] [count <Q> (default 22)] [solutions]
---

> **Not affiliated with the College Board.** "SAT" is the College Board's
> trademark; this skill only models the test's public format and difficulty
> conventions. It never reproduces real SAT questions — every question is
> newly written against the user's own concept guide file(s).

This skill builds a practice set that looks and behaves like a real digital
SAT Math module, but is scoped to whatever lessons the user asks for, using
their own concept guide as the source of truth for what each lesson teaches.

Whenever this file says "ask", ask all the questions due at that point
together in one turn (use a structured multiple-choice prompt if your
environment has one, such as Claude Code's AskUserQuestion tool; otherwise
ask them in plain text in a single message). Never ask a question the user
already answered in their request.

# Shared step 1: Get the concept guide(s) (always, before anything else)

A **concept guide** is any file named `<suffix>_Concept.pdf`,
`<suffix>_Concept.docx`, or `<suffix>_Concept.doc` — the suffix can be
anything (for example `Algebra1_Concept.pdf`), but the `_Concept.` part and
the file type (PDF or Word only) are a strict requirement. Each one lists
its lessons' numbers, titles, key rules and examples — how this skill knows
what each lesson teaches and what the whole course covers. **Never generate
anything without reading the relevant guide(s) first, and never invent a
lesson's content from memory.**

**A folder can have more than one concept file** (for example a course
split into `Algebra1_Concept.pdf` and `Geometry_Concept.docx`). When it
does, use all of them together as one combined course, not just one, and
the scope in Shared step 2 spans lesson numbers across all of them.

Find candidates in this order:

1. Any matching file the user attached or uploaded in this conversation.
2. Every matching file in the current working directory, or in any one
   immediate subfolder of it.
3. If neither finds anything, search the user's home folder (up to about 4
   levels deep, skipping hidden and system folders such as `Library`).

Then:

- **Found one or more matching files in a single location:** use all of
  them together. Tell the user in one line which file(s) you're using.
- **Found candidates in more than one folder** (for example, separate
  folders for different subjects): if the request names a subject and
  exactly one folder clearly matches, use that folder's file(s) and say
  which. Otherwise list the folders by subject/folder name and ask which to
  use — then use every matching file inside the chosen folder together.
- **Found none anywhere:** **do not assume anything** — stop and ask the
  user to either attach a concept file (matching the pattern above) or tell
  you which folder their concept files are in. Do not continue until you
  have at least one.
- **Two matching files would share the same alias** (identical suffix,
  different file type, in the same folder): ambiguous — ask the user to
  rename one or say which to use.

**Reading each guide:** read `.pdf` files directly; for `.docx`/`.doc`
files, extract the text first (for example with `python-docx`, or by
converting to PDF/plain text) before reading.

**Alias:** each guide's alias is its suffix — the part before `_Concept`
(for example `Algebra1_Concept.pdf` → alias `Algebra1`). Used to cite
lesson numbers unambiguously when more than one guide is active, since the
same lesson number can exist in more than one guide.

Read every active guide in full and note every lesson number each one
contains — together, this is the course's full lesson range, used below
when the scope is "whole course".

The **base folder** is the folder that contains the guide(s) on disk. If
every active guide was only uploaded into the chat, there is no base
folder.

# Shared step 2: Determine the scope

Parse the user's request for a scope, in this order:

1. **One lesson** ("only for lesson 12", "just lesson 34"): scope is that
   single lesson number.
2. **A range or ceiling** ("through lesson 49", "up to lesson 49",
   "lessons 1-49"): scope is every lesson from 1 (or the stated start) to
   the stated end, inclusive — not just the end lesson. When more than one
   concept guide is active, this range applies within each guide (lesson
   1-49 of every active guide), not just one of them, unless the user names
   a specific guide/subject.
3. **Not stated:** scope defaults to the **whole course** — every lesson
   number found across all active concept guides.

If a lesson number in the stated scope isn't in any active guide, tell the
user and ask them to adjust it. State the resolved scope back to the user in
one line (for example "whole course (lessons 1-120)" or "lessons 1-49") so
they can correct it before you build anything.

# Shared step 3: Read the catalog

The catalog is `Problem_Set_Catalog.json`, shared with the `problem-set-builder`
and `problem-set-grader` skills. This skill only reads and writes its own
`sat_sets` list in it; leave every other list (`problem_sets`,
`solved_pages`, `gradings`) untouched.

**Where it lives:** in the base folder. If there is no base folder, or it
is not writable, it lives in the output folder chosen in Shared step 5. If
the user uploaded a catalog file in the chat, use that one.

If the file doesn't exist yet, start it with all four lists empty:

```json
{
  "catalog_version": 1,
  "problem_sets": [],
  "solved_pages": [],
  "gradings": [],
  "sat_sets": []
}
```

If it exists but has no `sat_sets` key yet (an older catalog), add it as an
empty list without touching the rest.

Each `sat_sets` entry:

```json
{
  "id": "SAT-L1-49-2026-11-25-01",
  "scope": {"type": "range", "from": 1, "to": 49},
  "concept_guides": [{"alias": "Algebra1", "file": "Algebra1_Concept.pdf"}],
  "created": "2026-11-25",
  "question_count": 22,
  "difficulty_mix": {"easy": 7, "medium": 8, "hard": 7},
  "solutions": true,
  "delivery": "saved",
  "file": "/full/path/to/SAT_Practice_L1-49_2026-11-25.pdf",
  "question_pages": "1-4",
  "solution_pages": "5-9",
  "questions": [
    {
      "n": 1,
      "text": "If 3x + 5 = 20, what is the value of x?",
      "lesson_refs": [{"alias": "Algebra1", "lesson": 12}],
      "difficulty": "easy",
      "type": "multiple_choice",
      "choices": {"A": "3", "B": "5", "C": "15", "D": "25"},
      "correct": "B",
      "distractor_notes": {"A": "divided before subtracting 5", "C": "forgot to divide by 3", "D": "added 5 instead of subtracting"},
      "reused_from": null
    },
    {
      "n": 2,
      "text": "...",
      "lesson_refs": [{"alias": "Algebra1", "lesson": 34}, {"alias": "Geometry", "lesson": 10}],
      "difficulty": "hard",
      "type": "grid_in",
      "answer": "3/4",
      "accept": ["0.75"],
      "reused_from": "SAT-L1-40-2026-10-02-01#7"
    }
  ]
}
```

`scope.type` is `"lesson"` (with a `lesson` field), `"range"` (with `from`
and `to`), or `"book"` (whole course, no extra fields). `concept_guides`
lists every guide used (alias and file name), same as in
`problem-set-builder`. `type` is `"multiple_choice"` (always has 4
`choices` A-D and a `correct` letter) or `"grid_in"` (a numeric `answer`,
plus `accept` for equivalent forms, and no `choices`/`correct`/
`distractor_notes`). `reused_from` is `null` for a newly written question,
or `"<set id>#<n>"` pointing at the earlier question it was reused from
(see A3 below). `lesson_refs` works exactly like in `problem-set-builder`:
a list of `{alias, lesson}` pairs for every lesson that question's concept
actually draws on, always including the alias even when only one guide is
active (whether it gets *printed* depends on how many guides are active —
see A2).

**Earlier sets not in the catalog:** if SAT practice PDFs exist in
`<base>/SAT Practice */` (or the chosen output folder) but are missing from
`sat_sets`, extract their question and choice text (for example with
`pdftotext` or `pypdf`) and add entries for them before generating new
questions, so reuse and difficulty-mix history stay accurate.

# Shared step 4: Ask before creating

In one turn (together with the scope confirmation above), ask:

1. **How many questions?** Default 22 if not stated (one digital SAT Math
   module's length) — offer that plus a few alternatives such as 10 or 44.
2. **Difficulty:** "Mixed easy/medium/hard" (default, and the realistic
   choice) or a single tier only, if the user wants to drill just one level.
3. **Include solutions?** "Yes, with full explanations and why each wrong
   choice is wrong" or "No, questions only".
4. **Where should it go?** (Shared step 5)

Do not start building until every answer is known.

# Shared step 5: Confirm where the output goes

**Always ask — never assume a save location**, even if earlier turns wrote
files somewhere, and never silently use a generic "outputs" area your
environment offers by default. Offer:

1. **The usual folder** (`<base>/SAT Practice YYYY-MM-DD/`, only when there
   is a base folder).
2. **Another folder on my computer** (the user gives the path).
3. **A ZIP file with everything this generates** (the PDF plus the catalog
   as it stands after this request), handed over as a single download.

**If the user doesn't give a real folder** (picks option 3, or doesn't
answer with a folder), **default to the ZIP option** and say so plainly,
with this caveat: *since nothing is saved anywhere readable later, future
sets for this scope may repeat these questions beyond the usual ~15% unless
you give a real folder next time, or re-upload this ZIP's catalog file.* If
the user says uniqueness matters, ask them for a real folder instead.

**ZIP mode:** build the PDF and the updated catalog as files, package them
into one `.zip` (for example `SAT_Practice_L1-49_2026-11-25.zip`), and hand
it over through whatever download mechanism the environment has. If there's
no way to hand over a download at all, say so and offer a temporary folder
instead.

**Files never overwrite:** if a name is taken, add `_01`, `_02`, ... before
the extension.

# A1: Build the questions

Generate Q questions (Q = the number chosen) covering the resolved scope.

**Coverage**
- Every question's concept must come from a lesson inside the scope, in any
  active guide. For a range or whole-course scope, spread questions across
  the range (and across guides, when more than one is active) rather than
  clustering on a few lessons — this is meant to be cumulative review, not
  a repeat of `problem-set-builder`'s single-lesson focus.
- **Combining concepts across guides.** When more than one concept guide is
  active, a question isn't limited to one file: combine a concept from one
  guide with a prerequisite or related concept from another (for example,
  an Algebra lesson's equation combined with a Geometry fact), as long as
  every concept used is inside the scope. This is especially good for
  "hard" questions.
- **Lesson reference per question**, same rule as `problem-set-builder`:
  note every lesson a question's concept actually draws on, as `{alias,
  lesson}` pairs (usually one pair; more than one when a question combines
  skills from different lessons, in the same guide or across guides). This
  becomes `lesson_refs` and is printed under the question number (see A2).

**Difficulty**
- Tag every question `easy`, `medium`, or `hard` based on how many
  reasoning steps it takes and how much the phrasing disguises a familiar
  concept (a word-problem wrapper, an extra unit conversion, a two-part
  question). When difficulty is "Mixed", aim for roughly even thirds,
  ordered easiest to hardest like a real test section. When the user asked
  for a single tier, make every question that tier.
- Tag honestly: a question isn't "hard" just because the lesson is late in
  the course — base it on the question itself.

**Question types**
- Default to multiple choice (four options, A-D). Make roughly 1 in 4 or 5
  questions a grid-in (student-produced response, no choices) instead,
  matching the real test's mix — but only when the correct answer is a
  single positive number or simple fraction (grid-in has no way to enter a
  negative sign, a variable, or units); keep anything else multiple choice.
- **Distractors are not random.** For every multiple-choice question, each
  of the 3 wrong choices must come from one specific, realistic mistake —
  a sign error, the wrong formula, stopping one step early, solving for the
  wrong variable, a common arithmetic slip, and so on. Vary which mistakes
  you use across the set rather than reusing the same trick every time.
  Record the mistake behind each wrong choice in `distractor_notes`
  (one short phrase per choice) — this is what makes the solutions useful.

**Uniqueness and reuse (different from problem-set-builder — repeats are
allowed here, on purpose)**
- Collect every question already in `sat_sets` whose `lesson_refs` fall
  entirely inside the current scope, matching on alias and lesson number
  together (an `Algebra1`-lesson-34 question is eligible for a "whole
  course" or "lessons 1-49" set, not for a "lesson 12 only" set, and not
  confused with a `Geometry`-lesson-34 question from a different guide).
- **About 15% of Q, rounded down (0 for small sets), may be reinforcement
  repeats** reused from that pool — prefer ones not reused in the most
  recent set for this scope, so the same handful of questions don't keep
  resurfacing. Mark each with `reused_from` pointing at its original
  `<set id>#<n>`.
- **The rest (at least ~85%) must be brand-new.** Check every new question
  with code against the full question history for the relevant lessons
  (normalize: lowercase, collapse whitespace, strip punctuation, placeholder
  the variable letters) the same way `problem-set-builder` does, and against
  the rest of the new set. Replace any match and recheck until clean.
- If the scope is narrow enough that there's little room for new questions,
  say so before building and either widen the reuse share or offer a
  shorter set — don't silently fall back to repeating questions without
  saying so.

**Answers:** compute and verify every answer with code (for example Python
with sympy or fractions) before writing the PDF, even when solutions aren't
printed:
- Multiple choice: confirm the computed answer equals exactly one of the
  four choices, and that no two choices are numerically equal to each
  other.
- Grid-in: confirm the stored answer is a positive number or simple
  fraction the real grid-in format can represent.

**Set ID:** before writing the PDF, give the set an ID:
`SAT-L<lesson>-<YYYY-MM-DD>-<NN>` for a single lesson,
`SAT-L<from>-<to>-<YYYY-MM-DD>-<NN>` for a range, or
`SAT-ALL-<YYYY-MM-DD>-<NN>` for the whole course (NN increments per scope
per day, check the catalog). Printed on every page, and is the
`"<set id>#<n>"` anchor other sets point to when they reuse one of its
questions.

# A2: Write the PDF

- **File name:** `SAT_Practice_<scope-tag>_<YYYY-MM-DD>.pdf`, where
  `<scope-tag>` is `L<lesson>`, `L<from>-<to>`, or `Full`, for example
  `SAT_Practice_L1-49_2026-11-25.pdf` (plus `_01`, `_02`, ... if taken).
- **Location:** as chosen in Shared step 5. For the usual folder, create
  `<base>/SAT Practice YYYY-MM-DD/` if needed.
- Letter size, PDF only. Real superscripts for exponents, not `^`.
- **Footer on every page:** `Set <ID> · Page <p> of <total>`, plain black
  text at least 9 pt, centred at the bottom. **When more than one concept
  guide is active**, add a second small line right below it with the alias
  key, for example `Algebra1 = Algebra1_Concept.pdf · Geometry =
  Geometry_Concept.docx`. Omit this line when only one guide is active.
- **Title page/header:** "SAT-Style Math Practice", the resolved scope in
  plain words (for example "Lessons 1-49" or "Full Course"), a
  Name / Date / Score ___ / Q line, and a one-line pacing note ("~1.5
  minutes per question, like the real test").
- **Reference box**, printed once near the top before question 1 (this is
  how the real SAT's math section opens): the standard geometry facts —
  circle area and circumference, rectangle area, triangle area, the
  Pythagorean theorem, the 30-60-90 and 45-45-90 side ratios, volumes of a
  rectangular prism/cylinder/sphere/cone, and that a triangle's angles sum
  to 180° and a circle has 360°. These are plain mathematical facts, not
  test content — write your own box, don't copy any publisher's wording.
- **Directions line** before the questions: state plainly that most
  questions are multiple choice (pick one of four) and a few have no
  choices — write the answer as a number or simplified fraction instead.
- **Each question:**
  - **Lesson reference under the question number**, exactly like
    `problem-set-builder`: in the same narrow margin column as the number,
    not beside the question text. **One guide active:** plain lesson
    numbers in parentheses, comma-separated with no spaces for more than one
    (`(31)` or `(24,65,99)`). **More than one guide active:** `alias-lesson`
    pairs instead, even for a question citing only one guide (for
    consistency across the sheet), comma-separated for several
    (`(Algebra1-31)` or `(Algebra1-24,Geometry-10)`). Italic, one point
    smaller than body text. A citation, never something to solve.
  - The question stem, then immediately after it (same line or wrapping
    straight on), the difficulty tag in parentheses, *italic*, one point
    smaller than body text: for example "...what is the value of x? *(Medium)*".
  - **Multiple choice:** four choices labelled A) B) C) D), stacked or in a
    simple grid, with enough space to circle one.
  - **Grid-in:** no choices; instead a labelled answer box: "Answer: (enter
    a number or fraction) ______________".
  - Blank work space under every question (more for multi-step and word
    problems). Never split a question, its choices/answer box, or its
    lesson/difficulty tags across two pages.
- **Scan-friendly layout:** black text on white only, margins at least 0.75
  inch, body text at least 12 pt, nothing near the page edges except the
  footer.
- **Solutions section** (only if chosen): new page titled "Solutions"; same
  order, each with the question restated, full step-by-step work, the
  final answer clearly marked, and — for multiple choice — one line per
  wrong choice naming the mistake it represents (from `distractor_notes`),
  so the student learns what went wrong rather than just which letter was
  right. Record page ranges in `question_pages`/`solution_pages`.

# A3: Update the catalog and reply

Add the new entry to `sat_sets` (ID, scope, `concept_guides` used, every
question with its `lesson_refs`, `difficulty`, type-specific fields,
`distractor_notes` where applicable, and `reused_from`) and save the
catalog. Then tell the user:

- where the PDF is (full path, or that it's ready to download inside the
  zip) and its set ID;
- the resolved scope and the difficulty mix actually used (for example
  "7 easy, 8 medium, 7 hard");
- how many questions were brand-new versus reinforcement repeats, and which
  earlier set(s) the repeats came from;
- if solutions were included, that each wrong choice's mistake is explained,
  not just the right answer.

## Several scopes or regenerating

If asked to "make another set" for the same scope, treat it as a new A1-A3
pass: same reuse rule (~15% from history, prefer ones not just used), fresh
new questions for the rest, next `NN` in the set ID.
