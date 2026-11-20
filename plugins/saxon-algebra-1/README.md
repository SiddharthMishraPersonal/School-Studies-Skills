# saxon-algebra-1

A Claude skill for students using the Saxon Algebra 1 textbook. It does two
things:

1. **Problem sets:** ask for a problem set for a lesson number, and it builds
   a PDF of practice questions on that lesson's concept, easiest to hardest,
   with optional step-by-step solutions at the end.
2. **Solve a book page:** upload or paste a screenshot or photo of a Saxon
   Algebra 1 page, and it solves every question on it in a PDF with
   step-by-step work and a clearly marked final answer. Any answer Claude is
   not fully sure of is marked **[Likely]** so you know to double-check it.

## One-time setup: the `Saxon Algebra 1` folder

The skill works inside a folder named `Saxon Algebra 1` that you create
yourself. It must contain a file named `Saxon_Algebra1_Concept_Guide.pdf`
listing each lesson's number, title, key rule and an example. The skill uses
it to know what each lesson teaches. This guide is **not** included in this
repository; make your own or get it from whoever shared this skill with you.

```
Saxon Algebra 1/
├── Saxon_Algebra1_Concept_Guide.pdf    you provide this
├── Problem Sets YYYY-MM-DD/            created by the skill
├── media/                              screenshots you uploaded
└── adhoc-solutions/                    solutions for those screenshots
```

Claude finds the folder by looking, in order, at:

1. the folder Claude was started in (if it is `Saxon Algebra 1` itself),
2. a `Saxon Algebra 1` folder inside the folder Claude was started in,
3. a search of your home folder for `Saxon_Algebra1_Concept_Guide.pdf`.

If it still cannot find it, it asks you where it is. In the Claude app, give
Claude access to your `Saxon Algebra 1` folder.

## How to use

Start Claude in your `Saxon Algebra 1` folder (or the folder above it) and
say, for example:

- "Make a problem set for lesson 34"
- "Give me 15 questions on lesson 47 with solutions"
- *(paste a screenshot of a book page)* "Solve this"

For problem sets, Claude first asks how many questions you want and whether
to include solutions.

## Output files

| What | Where | Name |
|------|-------|------|
| Problem set | `Problem Sets YYYY-MM-DD/` | `Lesson<N>_Problem_Set_<YYYY-MM-DD>.pdf` |
| Your screenshot | `media/` | `Lesson<N>_Page_<YYYY-MM-DD>.<ext>` |
| Screenshot solutions | `adhoc-solutions/` | `Lesson<N>_Solutions_<YYYY-MM-DD>.pdf` |

Files are never overwritten; a repeat gets `_01`, `_02`, and so on.
