# School Studies Skills

A catalog of [Claude](https://claude.ai) skills for school studies. Each skill is
packaged as a Claude Code plugin, and this repository is a plugin marketplace,
so you can install any skill straight from the GitHub link.

Every skill is written in the open [Agent Skills](https://code.claude.com/docs/en/skills)
`SKILL.md` format (plain Markdown with a YAML frontmatter `name` and
`description`), so the same files also work with
[GitHub Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills),
which understands this format too — see **Option 4** below.

## Skills in this catalog

| Skill | What it does |
|-------|--------------|
| [saxon-algebra-1](plugins/saxon-algebra-1/) | Builds lesson-focused Saxon Algebra 1 problem set PDFs, and solves screenshots of book pages with step-by-step solution PDFs. |

## Install

### Option 1: Claude Code (recommended)

Inside Claude Code, run:

```
/plugin marketplace add SiddharthMishraPersonal/School-Studies-Skills
/plugin install saxon-algebra-1@school-studies-skills
```

Restart Claude Code if the skill does not show up right away. To get updates
later:

```
/plugin marketplace update school-studies-skills
```

### Option 2: Claude Code, manual copy

```bash
git clone https://github.com/SiddharthMishraPersonal/School-Studies-Skills.git
cp -R School-Studies-Skills/plugins/saxon-algebra-1/skills/saxon-algebra-1 ~/.claude/skills/
```

### Option 3: Claude app (claude.ai or desktop)

1. Download [`dist/saxon-algebra-1.zip`](dist/saxon-algebra-1.zip) (open the
   file on GitHub and click **Download raw file**).
2. In Claude, go to **Settings → Capabilities → Skills** and upload the zip.

### Option 4: GitHub Copilot

Copilot discovers Agent Skills from the same `SKILL.md` folder layout. Clone
the repo, then copy the skill into one of Copilot's recognized skill folders:

```bash
git clone https://github.com/SiddharthMishraPersonal/School-Studies-Skills.git

# Personal (available in every project / the Copilot CLI):
cp -R School-Studies-Skills/plugins/saxon-algebra-1/skills/saxon-algebra-1 ~/.copilot/skills/

# Or project-level (only inside one repo/folder):
cp -R School-Studies-Skills/plugins/saxon-algebra-1/skills/saxon-algebra-1 .github/skills/
```

Copilot also reads `.claude/skills/` inside a project, so a project-level
copy there (as in Option 2, but placed in the project instead of `~/.claude`)
works for both Claude Code and Copilot at once.

## Repository layout

```
.claude-plugin/marketplace.json        catalog of all plugins in this repo
plugins/<plugin>/.claude-plugin/plugin.json
plugins/<plugin>/skills/<skill>/SKILL.md
plugins/<plugin>/README.md             setup and usage for that skill
dist/<skill>.zip                       upload-ready zips for the Claude app
scripts/build-zips.sh                  rebuilds the zips in dist/
```

## Adding a new skill

1. Create `plugins/<new-skill>/.claude-plugin/plugin.json` and
   `plugins/<new-skill>/skills/<new-skill>/SKILL.md` (copy the
   saxon-algebra-1 plugin as a template).
2. Add an entry for it to the `plugins` list in
   `.claude-plugin/marketplace.json` and a row to the table above.
3. Run `./scripts/build-zips.sh` to create its zip in `dist/`.
4. Commit and push. Friends get it with `/plugin marketplace update`.

When you change an existing skill, bump its `version` in both `plugin.json`
and `marketplace.json`, and rebuild the zips.

Keep `SKILL.md` itself host-agnostic so it keeps working with Copilot (see
Option 4 above) as well as Claude: don't name Claude-only tools (e.g.
`AskUserQuestion`) as a hard requirement — describe the behavior instead
("ask both questions in one turn") and mention the Claude Code tool only as
an example. The `.claude-plugin/` manifests and `dist/` zips are purely for
Claude's install/marketplace flow and aren't read by Copilot.
