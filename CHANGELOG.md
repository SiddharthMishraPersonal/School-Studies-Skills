# Changelog

All notable changes to the skills in this repository, grouped by the
`study-problem-sets` plugin version (the version in
[`plugins/study-problem-sets/.claude-plugin/plugin.json`](plugins/study-problem-sets/.claude-plugin/plugin.json)
and [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)).

## 4.0.0 — 2026-11-25

**Breaking change:** concept guide files no longer need to be named exactly
`Concept_Guide.pdf`. If you have an existing one, rename it to match the new
pattern below (for example `Algebra1_Concept.pdf`) before using any skill.

- **New concept guide file pattern**, used by all three skills:
  `<suffix>_Concept.pdf` or `<suffix>_Concept.docx`/`.doc` — the suffix can
  be anything, but the `_Concept` part and the PDF/Word file type are
  strict. `.docx`/`.doc` guides are now supported (text is extracted before
  reading); previously only a fixed-name PDF was supported.
- **Multiple concept files in one folder are combined automatically**
  (for example `Algebra1_Concept.pdf` + `Geometry_Concept.docx`), instead of
  only ever reading a single fixed-name file. Questions can now combine a
  concept from one file with a concept from another.
- **Alias citations:** each concept file's suffix becomes its alias. When
  more than one guide is active, every lesson reference printed under a
  question number is prefixed with its alias (`(Algebra1-24)`) instead of a
  plain number, and the page footer gets a small alias-to-filename legend.
  With only one guide active, plain lesson numbers are used, unchanged from
  before.
- **Output location is now always asked, with no silent default**, and a
  new ZIP option was added everywhere a save location is chosen: "the usual
  folder", "another folder", or "a ZIP file with everything generated"
  (the PDF(s), scan copies, and the catalog, bundled into one download).
  Previously, no-folder requests produced a single bare file download; now
  they default to a ZIP and explicitly warn that uniqueness/history
  tracking won't carry over to future requests unless a real folder is
  given or the ZIP's catalog is re-uploaded.
- Catalog schema: added `concept_guides` (alias → file name) to
  `problem_sets`/`sat_sets` entries; `lesson_refs` entries are now
  `{alias, lesson}` pairs (previously bare lesson numbers) in both
  `problem-set-builder` and `sat-practice-builder`.
- `problem-set-grader` updated to discover concept files/catalogs with the
  same pattern and multi-file logic, and to default to ZIP output the same
  way.
- Plugin bumped to 4.0.0 in `plugin.json`/`marketplace.json`.

## 3.0.0 — 2026-11-25

- **Added `sat-practice-builder`**, a new skill that builds SAT-style math
  practice sets from the same concept guide: scope defaults to the whole
  course, or can be one lesson or a range ("through lesson 49" covers
  1-49). Real digital-SAT-Math item format (four-choice multiple choice
  plus a grid-in minority, a geometry reference box), easy/medium/hard
  difficulty tags, and distractors modeled on specific real mistakes
  (recorded so solutions explain *why* each wrong choice is wrong).
  Deliberately allows ~15% reinforcement repeats from earlier sets per
  scope, unlike `problem-set-builder`'s strict never-repeat rule, since the
  goal is practice volume.
- Added an `argument-hint` frontmatter field so Claude Code's
  `/sat-practice-builder` suggests its arguments (lesson, difficulty,
  count) — noted in the README that this opts the skill out of
  claude.ai's/ChatGPT's strict zip-upload path (Projects/paste still work).
- Broadened the repo disclaimer to cover test organizations (College Board)
  alongside textbook publishers.

## 2.0.0 — 2026-11-19 through 2026-11-25

- **Renamed away from Saxon-specific branding**: `saxon-algebra-1` →
  `study-problem-sets` (plugin), `saxon-algebra-1` → `problem-set-builder`,
  `saxon-algebra-1-grader` → `problem-set-grader`, and
  `Saxon_Algebra1_Concept_Guide.pdf`/`Saxon_Algebra1_Catalog.json` →
  `Concept_Guide.pdf`/`Problem_Set_Catalog.json`. The skill now works with
  any numbered-lesson textbook or course, not just one publisher's book,
  and carries no trademark exposure.
- Added `LICENSE` (MIT) and a disclaimer in the README (no bundled
  copyrighted content; AI-generated output may contain errors).
- Fixed multi-subject concept-guide matching: when more than one concept
  guide is found (separate subject folders), the builder matches a named
  subject or lists candidates instead of guessing, and the grader checks
  every candidate catalog for the scanned set ID instead of assuming there
  is only one, since two subjects could coincidentally produce the same set
  ID on the same day.
- Documented compatibility with GitHub Copilot, ChatGPT, and OpenAI Codex
  (all adopted the same open [Agent Skills](https://agentskills.io)
  `SKILL.md` standard as Claude) — no skill-file changes were needed beyond
  keeping instructions host-agnostic (no hard-required Claude-only tool
  names or paths).
- Added a Saxon-style lesson-number reference under each question's number
  (`(31)`, or `(24,65,99)` for several concepts), stored as `lesson_refs`
  in the catalog.

## 1.2.0 — 2026-11-19

- Added the grading skill (`saxon-algebra-1-grader`): reads a scanned PDF or
  photos of a solved, printed problem set, matches it to its answer key by
  the set ID printed in the page footer, scores each answer (correct/wrong/
  `[Check]` for unclear handwriting, with half credit optionally available),
  and produces a graded report PDF with notes on every mistake. Made
  problem sets gradable by printing a set ID and footer on every page.

## 1.1.0 — 2026-11-19

- Always locate the concept guide first (or ask the user to upload it)
  before generating or solving anything, rather than assuming a fixed path.
- Added output-location confirmation (usual folder, another folder, or
  download only) before creating files.
- Added a catalog (`Saxon_Algebra1_Catalog.json`) of every generated
  problem set and solved page, enabling reuse of earlier sets/solutions on
  repeat requests.
- New problem sets never repeat a question from an earlier set for the same
  lesson, verified with code before the PDF is written.

## 1.0.0 — 2026-11-19

- Initial release: the `saxon-algebra-1` skill and plugin marketplace.
  Builds Saxon Algebra 1 lesson-focused problem set PDFs from a
  user-supplied concept guide, and solves screenshots of Saxon Algebra 1
  book pages with step-by-step solution PDFs.
