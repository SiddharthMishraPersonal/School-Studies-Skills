---
name: saxon-algebra-1
description: Builds Saxon Algebra 1 problem sets as PDFs focused on one specific lesson's concept, using the Saxon_Algebra1_Concept_Guide.pdf in the user's "Saxon Algebra 1" folder as the lesson list, and saves them in that folder under "Problem Sets YYYY-MM-DD". Before building, asks how many questions to make and whether to include solutions at the end. Also solves the questions on a screenshot or photo of an actual Saxon Algebra 1 book page: saves the image in "Saxon Algebra 1/media" and a step-by-step solutions PDF in "Saxon Algebra 1/adhoc-solutions", marking any answer that is not certain with [Likely]. Use when asked to generate a problem set, practice set, questions, or worksheet for a Saxon Algebra 1 lesson number, or when the user uploads or pastes a screenshot of a Saxon Algebra 1 page to be solved.
---

This skill has two modes:

- **Mode A: Generate a problem set** for a lesson number (Step 1 onward).
- **Mode B: Solve a book page screenshot** when the user uploads or pastes a
  screenshot/photo of a Saxon Algebra 1 book page. Go straight to
  "Mode B" at the end of this file; do not ask the Step 1 questions.

## Finding the base folder (both modes, do this first)

The **base folder** is a folder named `Saxon Algebra 1` that contains
`Saxon_Algebra1_Concept_Guide.pdf`. Never assume a fixed path; find it in
this order and stop at the first match:

1. The current working directory, if it is that folder.
2. A `Saxon Algebra 1` folder inside the current working directory.
3. Otherwise, search the user's home folder (up to about 4 levels deep,
   skipping hidden and system folders such as `Library`) for
   `Saxon_Algebra1_Concept_Guide.pdf`, and use the folder that contains it.
   If more than one is found, ask the user which one to use.
4. If nothing is found (or, in the Claude app, the folder is not shared with
   the session), stop and ask the user where their `Saxon Algebra 1` folder
   is, or ask them to give access to it. Do not create files anywhere else
   as a fallback.

Every other path in this skill (`Problem Sets YYYY-MM-DD/`, `media/`,
`adhoc-solutions/`) is inside the base folder, written below as
`<base>/...`. Read from and save to the base folder only: never to the
working directory itself, a downloads or outputs folder, or a scratch/temp
folder. When reporting saved files, give their full absolute paths.

## Step 1: Ask before creating (always, Mode A only)

Before reading the guide or generating anything, ask the user two questions
in a single AskUserQuestion call:

1. **How many questions?** Offer options such as 10, 15, 20 and 30
   (the user can type any other number through "Other").
2. **Include solutions?** Options: "Yes, step-by-step solutions at the end"
   and "No, questions only".

If the user's request did not include a lesson number, ask for it in the same
call. If the user already stated the number of questions or the solutions
choice in their request, do not ask that question again; use what they said.
Do not start building the problem set until both answers are known.

## Folder and file rules (always follow these)

- **Base folder:** found as described in "Finding the base folder" above.
  Never save a problem set outside it.
- **Lessons and topics:** read
  `<base>/Saxon_Algebra1_Concept_Guide.pdf`. It gives each lesson's
  number, title, key rule and example. Use it to find lesson N's concept. Do
  not ask the user for a list of lessons. If lesson N is not in the guide,
  tell the user and stop.
- **Output folder:** `<base>/Problem Sets YYYY-MM-DD/`, using
  today's date (for example `Problem Sets 2026-11-19`). Create it if it does
  not exist; reuse it if it does.
- **File type:** PDF only.
- **File name:** `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf`, using today's date,
  for example `Lesson34_Problem_Set_2026-11-19.pdf`.
- **Duplicates:** never overwrite. If that name is already taken in the
  output folder, add the next free two-digit number:
  `Lesson34_Problem_Set_2026-11-19_01.pdf`, then `_02`, `_03`, and so on.
- When finished, tell the user the full path of the saved PDF.

# Saxon Lesson Problem Set Generator

## Purpose
Generate a practice set of Q questions (Q = the number the user chose) that
all practise the concept taught in the target lesson N.

## Content rules
- **Every question tests lesson N's concept.** Use the lesson's title, key
  rule and example from the concept guide to decide what the questions cover.
  Do not fill the set with review of other lessons.
- **Prerequisites only as support.** A question may use skills from lessons
  1 to N-1 when lesson N's concept needs them (for example, arithmetic with
  negatives inside an equation), but never use a skill from a lesson after N.
- **Difficulty ramp.** Order questions from easiest to hardest:
  - first third: direct, one-step applications of the key rule, close to the
    guide's example;
  - middle third: standard-difficulty problems with two or more steps;
  - last third: harder forms, including at least one word problem when the
    concept allows it.
- **Variety.** Vary numbers, signs, variable names and problem forms. No two
  questions should be the same problem with different numbers only, unless
  the set is very short.
- **Rotation.** If earlier problem sets for the same lesson exist in the
  `Problem Sets ...` folders, avoid repeating their exact questions.

## Output format
Produce one PDF (saved per the folder and file rules above), letter size.
Write exponents as real superscripts, not `^`. Compute every answer with code
rather than by hand, and check it before writing the PDF, even when solutions
are not printed.

**Questions section** (always):
- Title "Lesson N Problem Set", the lesson title, and a
  Name / Date / Score ___ / Q line.
- Clean numbered list 1 to Q, no answers or hints visible, with room to work
  under each question.

**Solutions section** (only if the user chose to include solutions):
- Starts on a new page, titled "Solutions".
- Same 1 to Q order, each with the original question restated, full
  step-by-step work, and the final answer clearly marked (bold, or prefixed
  "Answer:").

If the user chose no solutions, the PDF contains only the questions section.

## When asked to generate several lessons at once
Ask the two questions once and apply the answers to every lesson, unless the
user asks for different settings per lesson. Save one PDF per lesson.

# Mode B: Solve a Saxon Algebra 1 book page screenshot

Use this mode whenever the user uploads, pastes or points to an image
(screenshot or photo) of an actual Saxon Algebra 1 lesson page. Do not ask
how many questions or whether to include solutions: solve every question on
the page and always include step-by-step solutions.

## B1: Save the screenshot in `<base>/media/`
- **Folder:** `<base>/media/`
  (create it if missing). Never save the screenshot anywhere else.
- **Find the image file:** if the user gave a file path, or the image was
  attached as a file, copy that file (do not move or delete the original). If
  it was pasted into the chat, look for the cached copy of the pasted image
  (for example the newest image under `~/.claude/image-cache/`, matching the
  time of the message) and copy it. If no file of the image can be found on
  disk, still solve the page, then tell the user the screenshot could not be
  saved automatically and ask them to drop the file into `media/` or give its
  path, so you can copy it there.
- **File name:** `Lesson<N>_Page_<YYYY-MM-DD>.<ext>`, keeping the original
  extension (png, jpg, heic, ...), where N is the lesson number printed on
  the page. If the page shows a lesson number range or none, use
  `Saxon_Page_<YYYY-MM-DD>.<ext>`. If the user uploads several pages at once,
  save each one.
- **Duplicates:** never overwrite; add `_01`, `_02`, ... as needed.

## B2: Read the page and find the questions
- Read every question on the page: lesson practice problems (a, b, c, ...),
  numbered problem-set problems (1, 2, 3, ...), example problems the user
  asks about, and any parts of multi-part questions. Keep the book's own
  labels and order.
- If the page has no questions (only explanation), say so, summarise the
  concept briefly, and do not create a PDF unless the user asks.
- If part of the page is cut off, blurry or hidden, solve what is readable,
  and list the unreadable questions in the PDF and in your reply as
  "could not read" rather than guessing silently.
- Use `<base>/Saxon_Algebra1_Concept_Guide.pdf` to identify the lesson's concept
  and to solve the way Saxon teaches it (its methods and vocabulary).

## B3: Solve
- Give **full step-by-step work** for every question, then the **final
  answer** clearly marked (bold and prefixed "Answer:").
- Check every numerical/algebraic answer with code (for example Python with
  sympy or fractions) before writing the PDF. Simplify answers the way Saxon
  expects (reduced fractions, like terms combined, units on word problems).
- For multiple-choice questions, show the work and name the chosen letter.
- **Confidence marking:** if you are not 100% sure a solution is correct (the
  question was hard to read, the wording is ambiguous, a figure/diagram was
  unclear, the answer could not be verified with code, or more than one
  interpretation is possible), put **[Likely]** next to that question's
  label in the PDF (for example "7. [Likely]") and add a one-line note under
  its answer saying why it is uncertain. Only questions you are fully certain
  of go unmarked.

## B4: Save the solutions PDF in `<base>/adhoc-solutions/`
- **Folder:** `<base>/adhoc-solutions/`
  (create it if missing). Never save the solutions anywhere else.
- **File name:** `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` (or
  `Saxon_Page_Solutions_<YYYY-MM-DD>.pdf` if no lesson number), with `_01`,
  `_02`, ... instead of overwriting. Several screenshots of the same lesson
  uploaded together go in one PDF.
- **PDF layout (letter size):**
  - Title "Lesson N Solutions", the lesson title, today's date, and the
    screenshot file name it was solved from.
  - If any question is marked [Likely], a short line under the title:
    "Questions marked [Likely] could not be fully verified; please check
    them."
  - Each question in book order: the label and the question restated, the
    numbered steps, then the final answer.
  - Real superscripts for exponents, not `^`; proper fraction formatting.

## B5: Reply to the user
Tell the user the full paths of the saved screenshot and the solutions PDF,
list the final answers briefly (question label and answer), and name any
questions marked [Likely] or not readable.
