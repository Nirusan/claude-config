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

#### `config/settings.json` - Paramètres Claude

```json
{
  "model": "opus",
  "language": "French",
  "permissions": { "allow": ["Bash(pnpm ...)"] },
  "enabledPlugins": { "mgrep": true, "frontend-design": true, ... }
}
```

| Paramètre | Valeur | Description |
|-----------|--------|-------------|
| `model` | `opus` | Utilise Claude Opus (le plus capable) |
| `language` | `French` | Claude répond en français |
| `permissions` | commandes pnpm | Auto-approve pnpm dev/build/test/etc. |
| `enabledPlugins` | 6 plugins | Plugins activés par défaut |

---

### Commandes personnalisées

Les commandes s'invoquent avec `/nom-commande` dans Claude Code.

| Commande | Quand l'utiliser | Ce qu'elle fait |
|----------|------------------|-----------------|
| `/validate` | Avant de commit | Exécute `pnpm lint` → `pnpm build` → `pnpm test:e2e` en séquence. S'arrête au premier échec. |
| `/implement <tâche>` | Démarrer une nouvelle tâche | Workflow complet : lire docs → planifier avec todos → implémenter → valider → code review → commit |
| `/db-check` | Après modifs DB | Vérifie les advisors Supabase pour problèmes de sécurité (RLS manquant) et performance |
| `/git-add-commit-push` | Prêt à commit | Stage tout, génère le message de commit depuis le diff, push sur la branche actuelle |
| `/next-task` | Entre deux tâches | Lit le plan MVP et le fichier progress, identifie la prochaine tâche à faire |
| `/refresh-context` | Début de session | Relit CLAUDE.md, progress.txt, schema.sql pour comprendre l'état du projet |
| `/update-progress` | Après avoir terminé | Ajoute une entrée dans progress.txt avec date, fichiers modifiés, ce qui a été fait |

**Exemple :**
```
> /implement Ajouter un toggle dark mode dans la page settings

Claude va :
1. Lire les docs projet (CLAUDE.md, progress.txt)
2. Créer une todo list avec sous-tâches
3. Implémenter la feature
4. Lancer lint/build/tests
5. Review le code
6. Mettre à jour progress.txt
7. Commit avec message descriptif
```

---

### Agents personnalisés

Les agents sont des assistants spécialisés que Claude spawn pour des tâches spécifiques. Ils sont déclenchés automatiquement selon le contexte ou explicitement via l'outil Task.

| Agent | Expertise | Déclenché quand |
|-------|-----------|-----------------|
| `code-reviewer` | Qualité de code, sécurité, bonnes pratiques | Après des changements de code, pendant `/implement` |
| `nextjs-developer` | Next.js 14+, App Router, RSC, Server Actions | Travail sur du code Next.js |
| `supabase-developer` | PostgreSQL, Auth, policies RLS | Requêtes DB, problèmes d'auth |
| `prompt-engineer` | Prompts Claude API, extraction de contexte | Écriture de prompts pour suggestions IA |

**Ce que les agents apportent :**
- `code-reviewer` : Vérifie les vulnérabilités, code smells, suggère des améliorations
- `nextjs-developer` : Connaît les APIs async (`await cookies()`), patterns de data fetching
- `supabase-developer` : Écrit les policies RLS, optimise les requêtes, gère les flows d'auth
- `prompt-engineer` : Optimise les prompts pour génération de réponses Twitter/Reddit/LinkedIn

---

### Skills

Les skills sont des guides détaillés que Claude suit pour des domaines spécifiques. Ils s'activent automatiquement quand c'est pertinent.

| Skill | Objectif |
|-------|----------|
| `design-principles` | Applique un design system précis et minimal inspiré de Linear, Notion et Stripe |

**`design-principles` inclut :**
- Système de grille 4px pour les espacements
- Hiérarchie typographique (échelle 11px-32px)
- Patterns d'ombres/élévation
- Règles d'utilisation des couleurs (gris pour la structure, couleur pour le sens)
- Anti-patterns à éviter (pas d'animations bouncy, pas de dégradés décoratifs)
- Considérations dark mode

---

### Plugins (niveau utilisateur uniquement)

Les plugins étendent Claude Code avec des capacités supplémentaires.

| Plugin | Ce qu'il fait |
|--------|---------------|
| `mgrep` | Recherche sémantique dans le code via embeddings (meilleur que grep pour les concepts) |
| `frontend-design` | Génère des composants UI distinctifs et production-ready |
| `code-review` | Code review automatisée avec checks sécurité et qualité |
| `typescript-lsp` | Intégration du language server TypeScript |
| `security-guidance` | Bonnes pratiques de sécurité et détection de vulnérabilités |
| `context7` | Récupère la documentation à jour des librairies |

---

### Serveurs MCP (Optionnel)

Les serveurs MCP (Model Context Protocol) étendent Claude Code avec des intégrations de services externes. Contrairement aux plugins, les serveurs MCP nécessitent des clés API séparées et sont configurés dans `~/.claude.json`.

**Template inclus :** `config/mcp-servers.template.json`

| Serveur | Utilité | Type d'auth |
|---------|---------|-------------|
| `brave-search` | Recherche web | Clé API (obtenir sur [brave.com/search/api](https://brave.com/search/api)) |
| `firecrawl` | Scraping web avancé | Clé API (obtenir sur [firecrawl.dev](https://firecrawl.dev)) |
| `supabase` | Gestion de base de données | OAuth (pas de clé nécessaire) |

**Configuration :**

1. Copier le template vers ta config Claude :
```bash
# Première fois - créer le fichier
cp config/mcp-servers.template.json ~/.claude.json

# Ou fusionner avec config existante
cat config/mcp-servers.template.json
# Puis ajouter manuellement la section mcpServers à ~/.claude.json
```

2. Remplacer les placeholders de clés API :
```bash
# Éditer ~/.claude.json et remplacer :
# - YOUR_BRAVE_API_KEY_HERE
# - YOUR_FIRECRAWL_API_KEY_HERE
```

3. Redémarrer Claude Code

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
- `~/.claude/commands/*.md` → `commands/`
- `~/.claude/agents/*.md` → `agents/`
- `~/.claude/skills/` → `skills/`

### Optionnel : commande /sync-config

Crée une commande locale pour synchroniser rapidement (gitignorée, chemins spécifiques à l'utilisateur) :

```bash
cat > ~/.claude/commands/sync-config.md << 'EOF'
---
allowed-tools: Bash(*)
description: Sync local Claude config to GitHub repo
---

Lancer sync et afficher le status :
```bash
cd ~/chemin/vers/claude-config && ./sync.sh && git status
```
EOF
```

---

## Personnalisation

### Ajouter une nouvelle commande

1. Créer `commands/ma-commande.md` :
```markdown
---
allowed-tools: Bash(*), Read, Write
description: Ce que fait cette commande
---

## Instructions pour Claude

Expliquer ce que Claude doit faire quand cette commande est invoquée.
```

2. Lancer `./install.sh`
3. Utiliser avec `/ma-commande` dans Claude Code

### Ajouter un nouvel agent

1. Créer `agents/mon-agent.md` :
```markdown
---
name: mon-agent
description: Quand utiliser cet agent
tools: Read, Write, Bash
model: sonnet
---

Tu es un expert en X. Ton rôle est de...
```

2. Lancer `./install.sh`

### Ajouter un nouveau skill

1. Créer `skills/mon-skill/skill.md` :
```markdown
---
name: mon-skill
description: Ce que couvre ce skill
---

# Guidelines détaillées...
```

2. Lancer `./install.sh`

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
├── scripts/
│   ├── ralph.sh            # Boucle autonome (N itérations)
│   └── ralph-once.sh       # Tâche autonome unique
├── config/
│   ├── CLAUDE.md           # Conventions de code
│   ├── settings.json       # Model, plugins, langue
│   └── mcp-servers.template.json  # Template serveurs MCP (nécessite clés API)
├── commands/
│   ├── validate.md         # Lancer lint/build/tests
│   ├── implement.md        # Workflow complet de tâche
│   ├── db-check.md         # Advisors Supabase
│   ├── git-add-commit-push.md
│   ├── next-task.md        # Trouver prochaine tâche MVP
│   ├── refresh-context.md  # Relire docs projet
│   └── update-progress.md  # Mettre à jour fichier progress
├── agents/
│   ├── code-reviewer.md    # Expert qualité de code
│   ├── nextjs-developer.md # Spécialiste Next.js
│   ├── supabase-developer.md # Expert base de données
│   └── prompt-engineer.md  # Optimisation de prompts
└── skills/
    └── design-principles/
        └── skill.md        # Guide design system
```

---

## Licence

MIT - N'hésite pas à fork et personnaliser.
