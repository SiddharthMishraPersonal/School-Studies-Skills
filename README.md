# School Studies Skills

A catalog of [Claude](https://claude.ai) skills for school studies. Each skill is
packaged as a Claude Code plugin, and this repository is a plugin marketplace,
so you can install any skill straight from the GitHub link.

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
