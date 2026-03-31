<div align="center">

**🌐 Language / Langue**

[![English_→](https://img.shields.io/badge/English_→-gray?style=for-the-badge&logo=readme&logoColor=white)](README.md)
![Français](https://img.shields.io/badge/Français-blue?style=for-the-badge&logo=readme&logoColor=white)

</div>

# Configuration Claude Code

Configuration personnelle de Claude Code pour une expérience de développement cohérente sur toutes les machines.

> ⚠️ **Attention** : Ceci va **écraser** votre configuration `~/.claude/` existante. Une sauvegarde est automatiquement créée dans `~/.claude-backup-YYYYMMDD-HHMMSS/` avant l'installation.

## Prérequis

- **git** - pour cloner et synchroniser
- **curl** - pour l'installation one-liner
- **bash** - shell (macOS/Linux/WSL)
- **jq** (optionnel) - pour fusionner les settings lors des mises à jour

## Installation rapide

### Niveau utilisateur (tous les projets sur cette machine)

```bash
# One-liner
curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash

# Ou depuis un clone
git clone https://github.com/Nirusan/claude-config.git
cd claude-config
./install.sh --user
```

### Niveau projet (projet actuel uniquement)

```bash
# One-liner
curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project

# Ou depuis un clone
git clone https://github.com/Nirusan/claude-config.git /tmp/claude-config
cd /chemin/vers/ton/projet
/tmp/claude-config/install.sh --project
```

### Dans Docker

```dockerfile
# Niveau utilisateur (recommandé) - utiliser --yes pour ignorer la confirmation
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --yes

# Niveau projet
WORKDIR /app
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project --yes
```

## Modes d'installation

| Mode | Flag | Cible | Plugins | Cas d'usage |
|------|------|-------|---------|-------------|
| **User** | `--user` (défaut) | `~/.claude/` | Oui | Machine perso, tous les projets |
| **Project** | `--project` | `./.claude/` | Non | Config d'équipe, CI/CD |

### Options

| Flag | Description |
|------|-------------|
| `--yes` ou `-y` | Ignorer la confirmation (pour CI/Docker) |

### Protection de la config existante

Si vous avez déjà une config Claude, l'installateur va :
1. **Vous avertir** (EN/FR) que votre config sera écrasée
2. **Demander confirmation** (appuyer sur `y` pour continuer, autre touche pour annuler)
3. **Créer une sauvegarde** dans `~/.claude-backup-YYYYMMDD-HHMMSS/`
4. **Fusionner vos settings** (nécessite `jq`) :
   - `enabledPlugins` — vos plugins existants sont préservés
   - `permissions.allow` — vos commandes autorisées sont préservées

Pour restaurer votre ancienne config :
```bash
cp -rP ~/.claude-backup-YYYYMMDD-HHMMSS/* ~/.claude/
```

### Comment les configurations se combinent

Claude Code fusionne les configurations de plusieurs niveaux :

```
~/.claude/CLAUDE.md        (préférences user - s'applique partout)
     +
./CLAUDE.md                (règles projet - ce repo uniquement)
     +
./.claude/settings.json    (settings projet)
     =
Configuration finale
```

Le niveau projet peut override ou étendre le niveau utilisateur.

---

## Contenu

### Configuration globale

#### `config/CLAUDE.md` - Conventions de code

Définit les standards de code appliqués à tous les projets :

| Règle | Description |
|-------|-------------|
| **Package Manager** | Toujours `pnpm`, jamais npm ou yarn |
| **Langue** | Anglais pour le code, commits, docs |
| **TypeScript** | Mode strict, éviter `any` (utiliser `unknown` ou generics) |
| **Imports** | Imports absolus avec alias `@/`, pas de chemins relatifs |
| **Style de code** | Fonctionnel/déclaratif, pas de classes |
| **Naming** | `kebab-case` dossiers, `camelCase` fonctions, `PascalCase` composants |
| **React/Next.js** | Préférer Server Components, minimiser `'use client'` |
| **State Management** | Utiliser Zustand plutôt que React Context pour le state global |
| **Data Fetching** | Préférer Server Actions aux API Routes |
| **UI** | Tailwind CSS + shadcn/ui |
| **Performance** | Optimiser Web Vitals, images WebP, lazy loading |
| **No Barrel Imports** | Importer directement (`lucide-react/icons/Check`) pas depuis l'index |
| **No Waterfalls** | `Promise.all()` pour les fetches parallèles, jamais `await` séquentiels |
| **Déduplication** | `React.cache()` pour les fonctions appelées plusieurs fois dans un render |

#### `config/settings.json` - Paramètres Claude

```json
{
  "hooks": { "SessionStart": [...] },
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  },
  "permissions": { "allow": ["Bash(pnpm ...)"] },
  "enabledPlugins": { "mgrep": true, "frontend-design": true, ... },
  "language": "French"
}
```

| Paramètre | Valeur | Description |
|-----------|--------|-------------|
| `model` | `opus` | Utilise Claude Opus (le plus capable) |
| `language` | `French` | Claude répond en français |
| `permissions` | commandes pnpm | Auto-approve pnpm dev/build/test/etc. |
| `enabledPlugins` | 7 plugins | Plugins activés par défaut |
| `hooks` | SessionStart | Charge automatiquement le skill-router au démarrage |
| `env.CLAUDE_CODE_EFFORT_LEVEL` | `max` | Effort de raisonnement maximum par défaut |
| `env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | `1` | Active la coordination multi-agents |

### Hooks & Skill Router

Un hook `SessionStart` injecte automatiquement le **skill-router** dans chaque session. Le skill-router :
- Associe les tâches au bon skill via un arbre de décision
- Invoque automatiquement les agents spécialisés (Gemini MCP, nextjs-developer, supabase-developer, seo-specialist, code-reviewer)
- Impose la vérification navigateur après les changements frontend
- Empêche la rationalisation pour sauter des skills
- Exige des preuves avant de déclarer le succès

---

### Skills

Les skills sont le format unifié de Claude Code (Dec 2025), remplaçant l'ancien système de commandes. Ils peuvent être invoqués manuellement avec `/nom-skill` ou auto-découverts par Claude selon le contexte. Tous les skills supportent les **triggers en français** pour l'auto-découverte.

#### Workflow BMAD Lite (Découverte produit → Implémentation)

| Skill | Triggers | Ce qu'il fait |
|-------|----------|---------------|
| `/brainstorm` | "brainstorm", "réfléchissons", "explorer cette idée" | Session d'idéation interactive → crée `memory-bank/brief.md` |
| `/prd` | "create prd", "créer un prd", "définir les besoins" | Définir les besoins → crée `memory-bank/prd.md` |
| `/tech-stack` | "define tech stack", "définir la stack" | Décisions d'architecture → crée `memory-bank/tech-stack.md` |
| `/implementation-plan` | "/plan", "créer le plan", "découper en stories" | Découper en stories → crée `memory-bank/plan.md` + `progress.md` |

**Flow BMAD Lite :**
```
/brainstorm → /prd → /tech-stack → /implementation-plan → /implement
```

#### Skills de workflow dev

| Skill | Triggers | Ce qu'il fait |
|-------|----------|---------------|
| `/tdd` | "test-driven", "écrire les tests d'abord" | Impose le cycle RED-GREEN-REFACTOR — pas de code sans test en échec |
| `/debug` | "debug ça", "trouver la cause" | Debugging systématique en 4 phases (reproduire → analyser → hypothèse → corriger) |
| `/dispatch` | "agents parallèles", "travailler en parallèle" | Orchestrer plusieurs sous-agents sur des tâches indépendantes |
| `receiving-code-review` | (auto) | Comment réagir aux feedbacks de review — vérifier avant d'implémenter, pas d'accord performatif |
| `/writing-skills` | "créer un skill" | Meta-skill pour créer de nouveaux skills dans la config |

#### Skills de développement

| Skill | Triggers | Ce qu'il fait |
|-------|----------|---------------|
| `/validate` | "valider", "lancer les tests" | Exécute `pnpm lint` → `pnpm build` → `pnpm test:e2e` en séquence |
| `/implement` | "implémenter", "on code", "développer" | Workflow complet : lire docs → planifier → implémenter → valider → review → commit. TDD obligatoire et protocole de blocage |
| `/next-task` | "what's next", "c'est quoi la suite", "prochaine tâche" | Lit le plan, identifie la prochaine tâche |
| `/refresh-context` | "on en est où", "rafraîchir le contexte" | Relit les docs projet (CLAUDE.md, progress.md) |
| `/update-progress` | "update progress", "maj progrès" | Met à jour progress.md avec le travail complété |
| `/git-add-commit-push` | "commit", "push", "pousser" | Stage tout, génère le message de commit, push. Options de finishing de branche (merge/PR/conserver/supprimer) |
| `/validate-update-push` | Fin de session | Valide, met à jour le progress, commit et push |

#### Skills utilitaires

| Skill | Triggers | Ce qu'il fait |
|-------|----------|---------------|
| `/db-check` | Après modifs DB | Vérifie les advisors Supabase pour sécurité et performance |
| `/security-check` | Avant de commit | Audit sécurité red-team des changements récents |
| `/seo-check` | Travail sur pages | Audit SEO : metadata, structure, Core Web Vitals, accessibilité |
| `/permissions-allow` | Setup | Applique les permissions de développement standard |
| `/design-principles` | Travail UI | Applique un design system minimal (style Linear/Notion/Stripe) |
| `/validate-quick` | Avant commits | Validation rapide pass/fail (lint + build) |
| `/sync-config` | Manuel uniquement | Synchronise la config locale `~/.claude/` vers le repo GitHub |

**Auto-découverte :** Les skills comme `db-check`, `security-check` et `seo-check` sont déclenchés automatiquement quand c'est pertinent (ex: après des migrations DB, avant des commits avec des changements sensibles, ou lors du travail sur des pages/contenus).

**Workflows par feature :** Les skills supportent le flag `--feature=X` pour travailler dans `memory-bank/features/{name}/` :
```bash
/prd --feature=dark-mode        # Crée memory-bank/features/dark-mode/prd.md
/implement --feature=dark-mode  # Travaille sur le plan dark-mode
```

**Exemple :**
```
> /implement Ajouter un toggle dark mode dans la page settings

Claude va :
1. Lire les docs projet (CLAUDE.md, progress.md)
2. Créer une todo list avec sous-tâches
3. Implémenter la feature
4. Lancer lint/build/tests
5. Review le code
6. Mettre à jour progress.md
7. Commit avec message descriptif
```

---

### Agents personnalisés

Les agents sont des assistants spécialisés que Claude spawn pour des tâches spécifiques. Ils sont déclenchés automatiquement selon le contexte ou explicitement via l'outil Task.

#### Agents BMAD Lite (Découverte produit)

| Agent | Modèle | Expertise | Utilisé par |
|-------|--------|-----------|-------------|
| `analyst` | inherit | Découverte de problèmes, analyse de marché, idéation | `/brainstorm` |
| `product-manager` | inherit | Besoins, user stories, priorisation | `/prd` |
| `architect` | opus | Décisions tech stack, design système, planification | `/tech-stack`, `/implementation-plan` |

#### Agents de développement

| Agent | Modèle | Expertise | Déclenché quand |
|-------|--------|-----------|-----------------|
| `code-reviewer` | inherit | Qualité de code, sécurité, bonnes pratiques | Après des changements de code, pendant `/implement` |
| `nextjs-developer` | inherit | Next.js 14+, App Router, RSC, Server Actions | Travail sur du code Next.js |
| `supabase-developer` | inherit | PostgreSQL, Auth, policies RLS | Requêtes DB, problèmes d'auth |
| `prompt-engineer` | inherit | Prompts Claude API, extraction de contexte | Écriture de prompts pour suggestions IA |
| `seo-specialist` | inherit | Optimisation SEO, Core Web Vitals, accessibilité | Création/modification de pages, travail sur le contenu |

**Ce que les agents apportent :**
- `analyst` : Pose des questions pertinentes, challenge les hypothèses, crée des briefs produit
- `product-manager` : Définit le scope MVP, écrit les user stories avec critères d'acceptance
- `architect` : Prend des décisions tech pragmatiques, découpe les features en stories implémentables
- `code-reviewer` : Review en deux étapes (conformité spec puis qualité code), vérifie les vulnérabilités, code smells, suggère des améliorations
- `nextjs-developer` : Connaît les APIs async (`await cookies()`), patterns de data fetching
- `supabase-developer` : Écrit les policies RLS, optimise les requêtes, gère les flows d'auth
- `prompt-engineer` : Optimise les prompts pour génération de réponses Twitter/Reddit/LinkedIn

**Héritage de modèle :** Tous les agents utilisent `model: inherit` (utilise le modèle de la session) sauf `architect` qui utilise `opus` pour les décisions architecturales complexes.

---

### Plugins (niveau utilisateur uniquement)

Les plugins étendent Claude Code avec des capacités supplémentaires.

| Plugin | Ce qu'il fait |
|--------|---------------|
| `mgrep` | Recherche sémantique dans le code via embeddings (meilleur que grep pour les concepts) |
| `frontend-design` | Génère des composants UI distinctifs et production-ready |
| `code-review` | Code review automatisée avec checks sécurité et qualité |
| `code-simplifier` | Simplifie et raffine le code pour plus de clarté et maintenabilité |
| `typescript-lsp` | Intégration du language server TypeScript |
| `security-guidance` | Bonnes pratiques de sécurité et détection de vulnérabilités |
| `context7` | Récupère la documentation à jour des librairies |

---

### Serveurs MCP

Les serveurs MCP (Model Context Protocol) étendent Claude Code avec des intégrations de services externes. Ils sont **automatiquement fusionnés** dans `~/.claude.json` lors de l'installation (les serveurs existants sont préservés).

| Serveur | Utilité | Auth |
|---------|---------|------|
| `brave-search` | Recherche web | Clé API ([brave.com/search/api](https://brave.com/search/api)) |
| `firecrawl` | Scraping web avancé | Clé API ([firecrawl.dev](https://firecrawl.dev)) |
| `supabase` | Gestion de base de données | OAuth (pas de clé nécessaire) |
| `exa` | Recherche web IA | OAuth (pas de clé nécessaire) |
| `context7` | Documentation des librairies | Aucune (gratuit) |
| `dev-browser` | Automatisation navigateur (Playwright sandboxé) | Aucune (`npm i -g dev-browser`) |
| `gemini-design-mcp` | Design avec Gemini | Clé API |
| `n8n-mcp` | Automatisation de workflows | Clé API + URL |

**Après installation :**

Éditer `~/.claude.json` pour ajouter vos clés API :
```bash
# Remplacer les placeholders YOUR_API_KEY_HERE avec les vraies clés
nano ~/.claude.json
```

**Note :** Le fichier `~/.claude.json` contient des clés API et ne doit **jamais** être commité dans le contrôle de version.

---

## Mise à jour

### Récupérer les dernières mises à jour du repo

```bash
cd /chemin/vers/claude-config
git pull
./install.sh
```

### Synchroniser les changements locaux vers le repo

Si tu modifies la config localement dans `~/.claude/`, synchronise-la :

```bash
cd /chemin/vers/claude-config
./sync.sh                                    # Copie ~/.claude/ → repo
git add -A && git commit -m "sync" && git push
```

**Ce qui est synchronisé :**
- `~/.claude/CLAUDE.md` → `config/CLAUDE.md`
- `~/.claude/settings.json` → `config/settings.json`
- `~/.claude/agents/*.md` → `agents/`
- `~/.claude/skills/*/SKILL.md` → `skills/`
- Template serveurs MCP depuis `~/.claude.json`

### Utiliser le skill /sync-config

Le skill `/sync-config` est maintenant inclus par défaut. Il lance le script de sync et affiche le statut git :

```bash
/sync-config
```

**Note :** Le skill utilise `disable-model-invocation: true` donc il ne sera pas déclenché automatiquement - tu dois l'invoquer manuellement.

---

## Personnalisation

### Ajouter un nouveau skill

1. Créer `skills/mon-skill/SKILL.md` :
```markdown
---
name: mon-skill
description: Ce que fait ce skill
triggers:
  - "/mon-skill"
  - "lancer mon skill"
tools: Bash, Read, Write
context: fork
---

## Instructions pour Claude

Expliquer ce que Claude doit faire quand ce skill est invoqué.
```

2. Lancer `./install.sh`
3. Utiliser avec `/mon-skill` ou laisser Claude auto-découvrir via les triggers

### Ajouter un nouvel agent

1. Créer `agents/mon-agent.md` :
```markdown
---
name: mon-agent
description: Quand utiliser cet agent
tools: Read, Write, Bash
model: inherit
---

Tu es un expert en X. Ton rôle est de...
```

2. Lancer `./install.sh`

**Note :** Utiliser `model: inherit` pour utiliser le modèle de la session courante, ou `model: opus` pour les tâches complexes nécessitant le maximum de capacité.

---

### Scripts d'automatisation

Scripts pour exécuter Claude Code de façon autonome.

| Script | Utilité |
|--------|---------|
| `scripts/ralph.sh <n>` | Exécute N itérations autonomes (boucle) |
| `scripts/ralph-once.sh` | Exécute 1 tâche autonome puis s'arrête |

**Ce qu'ils font :**
1. Switch sur la branche `ralph`
2. Exécutent `/next-task` → `/implement` → `/validate` → `/update-progress` → `/git-add-commit-push`
3. Répètent (ralph.sh) ou s'arrêtent (ralph-once.sh)

**Prérequis :**
- Dossier `memory-bank/` avec les docs projet (bientôt dans ce repo)
- `progress.txt` pour tracker le travail fait

---

## Structure des fichiers

```
claude-config/
├── README.md               # Documentation anglaise
├── README.fr.md            # Documentation française
├── install.sh              # Installeur (--user/--project)
├── sync.sh                 # Sync ~/.claude/ → repo
├── .gitignore
├── hooks/
│   └── session-start.sh        # Hook SessionStart (injecte skill-router)
├── scripts/
│   ├── ralph.sh            # Boucle autonome (N itérations)
│   └── ralph-once.sh       # Tâche autonome unique
├── config/
│   ├── CLAUDE.md           # Conventions de code
│   ├── settings.json       # Model, plugins, langue
│   └── mcp-servers.template.json  # Serveurs MCP (auto-fusionnés)
├── agents/
│   ├── analyst.md          # BMAD: Découverte de problèmes, idéation
│   ├── product-manager.md  # BMAD: Besoins, user stories
│   ├── architect.md        # BMAD: Tech stack, plans d'implémentation
│   ├── code-reviewer.md    # Expert qualité de code
│   ├── nextjs-developer.md # Spécialiste Next.js
│   ├── supabase-developer.md # Expert base de données
│   ├── prompt-engineer.md  # Optimisation de prompts
│   └── seo-specialist.md   # Expert optimisation SEO
└── skills/                 # Format unifié (Dec 2025)
    ├── brainstorm/SKILL.md       # BMAD: Idéation → brief.md
    ├── prd/SKILL.md              # BMAD: Besoins → prd.md
    ├── tech-stack/SKILL.md       # BMAD: Architecture → tech-stack.md
    ├── implementation-plan/SKILL.md  # BMAD: Stories → plan.md
    ├── skill-router/SKILL.md         # Auto-chargé : associe tâches aux skills
    ├── test-driven-development/SKILL.md  # TDD : RED-GREEN-REFACTOR
    ├── systematic-debugging/SKILL.md     # Debugging 4 phases
    ├── dispatch-agents/SKILL.md          # Orchestration sous-agents parallèles
    ├── receiving-code-review/SKILL.md    # Gestion des feedbacks de review
    ├── writing-skills/SKILL.md           # Meta-skill : créer de nouveaux skills
    ├── implement/SKILL.md
    ├── validate/SKILL.md
    ├── validate-quick/SKILL.md   # Vérification rapide pass/fail
    ├── db-check/SKILL.md
    ├── security-check/SKILL.md
    ├── seo-check/SKILL.md        # Audit SEO
    ├── git-add-commit-push/SKILL.md
    ├── next-task/SKILL.md
    ├── refresh-context/SKILL.md
    ├── update-progress/SKILL.md
    ├── validate-update-push/SKILL.md
    ├── permissions-allow/SKILL.md
    ├── design-principles/SKILL.md
    ├── sync-config/SKILL.md      # Sync config vers repo
    ├── copywriting/SKILL.md
    ├── content-strategy/SKILL.md
    ├── email-sequence/SKILL.md
    ├── humanizer/SKILL.md
    ├── launch-strategy/SKILL.md
    ├── marketing-ideas/SKILL.md
    └── page-cro/SKILL.md
```

---

## Licence

MIT - N'hésite pas à fork et personnaliser.
