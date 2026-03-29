---
name: resend
version: 1.0.0
description: Manage Resend email platform via CLI — send emails, manage contacts, broadcasts, templates, segments, domains, webhooks, and more. Use when the user wants to send emails, manage contacts/segments, create broadcasts, manage templates, check domain status, or any Resend-related task. Trigger words: "resend", "send email", "broadcast", "contacts", "email template", "domain verify", "webhook".
user_invocable: true
---

# Resend CLI Skill

You are an expert at managing the Resend email platform via the `resend` CLI (v1.6.0+). Execute commands directly — do not ask the user to run them manually.

## Pre-flight Check

Before running any command, verify authentication:

```bash
resend whoami --json
```

If `"authenticated": false`:
1. Check if `RESEND_API_KEY` is set in the environment
2. If not, tell the user to run `! resend login` interactively (Claude cannot handle the interactive prompt)
3. Do NOT proceed until authenticated

## Command Reference

### Emails

| Command | Description |
|---------|-------------|
| `resend emails list` | List sent emails |
| `resend emails send --from <addr> --to <addr> --subject "..." --html "..."` | Send email |
| `resend emails send --from <addr> --to <addr> --template <id> --var key=value` | Send with template |
| `resend emails send ... --html-file ./email.html` | Send from HTML file |
| `resend emails send ... --attachment ./file.pdf` | Send with attachment |
| `resend emails send ... --scheduled-at "in 1 hour"` | Schedule email |
| `resend emails get <id>` | Get email details |
| `resend emails batch --file ./emails.json` | Batch send (up to 100) |
| `resend emails cancel <id>` | Cancel scheduled email |

### Contacts

| Command | Description |
|---------|-------------|
| `resend contacts list` | List all contacts |
| `resend contacts create --email <email> --first-name <name>` | Create contact |
| `resend contacts get <id-or-email>` | Get contact by ID or email |
| `resend contacts update <id-or-email> --properties '{"key":"value"}'` | Update contact properties |
| `resend contacts update <id-or-email> --unsubscribed` | Unsubscribe contact |
| `resend contacts delete <id-or-email> --yes` | Delete contact |
| `resend contacts segments <id-or-email>` | List contact's segments |
| `resend contacts add-segment <contactId> --segment-id <segmentId>` | Add contact to segment |
| `resend contacts remove-segment <contactId> <segmentId>` | Remove from segment |
| `resend contacts topics <id-or-email>` | List contact's topic subs |
| `resend contacts update-topics <id> --topics '[{"id":"...","subscription":"opt_in"}]'` | Update topic subs |

### Segments

| Command | Description |
|---------|-------------|
| `resend segments list` | List all segments |
| `resend segments create --name "..."` | Create segment |
| `resend segments get <id>` | Get segment details |
| `resend segments delete <id> --yes` | Delete segment |

No update endpoint — delete and recreate to rename.

### Broadcasts

| Command | Description |
|---------|-------------|
| `resend broadcasts list` | List all broadcasts |
| `resend broadcasts create --from <addr> --subject "..." --segment-id <id> --html "..."` | Create draft |
| `resend broadcasts create ... --send` | Create and send immediately |
| `resend broadcasts send <id>` | Send a draft |
| `resend broadcasts send <id> --scheduled-at "tomorrow at 9am ET"` | Schedule send |
| `resend broadcasts get <id>` | Get broadcast details (includes HTML) |
| `resend broadcasts update <id> --subject "..."` | Update draft |
| `resend broadcasts delete <id> --yes` | Delete/cancel broadcast |
| `resend broadcasts open [id]` | Open in Resend dashboard |

**Template variables in broadcasts**: Use triple-brace syntax `{{{PROPERTY_NAME|fallback}}}` in HTML.

**Lifecycle**: create (draft) -> update (optional) -> send. Dashboard-created broadcasts cannot be sent via API.

### Templates

| Command | Description |
|---------|-------------|
| `resend templates list` | List all templates |
| `resend templates create --name "..." --html "..." --subject "..." --var KEY:type` | Create template |
| `resend templates get <id>` | Get template |
| `resend templates update <id> --subject "..."` | Update template |
| `resend templates publish <id>` | Publish draft template |
| `resend templates duplicate <id>` | Duplicate template |
| `resend templates delete <id> --yes` | Delete template |
| `resend templates open [id]` | Open in dashboard |

**Variables**: Declared with `--var KEY:type` or `--var KEY:type:fallback`. Used in HTML as `{{{KEY}}}`.

**Lifecycle**: create (draft) -> publish. Re-publish after updates.

### Domains

| Command | Description |
|---------|-------------|
| `resend domains list` | List all domains |
| `resend domains create --name example.com` | Create domain (get DNS records) |
| `resend domains verify <id>` | Trigger DNS verification |
| `resend domains get <id>` | Get domain + DNS records + status |
| `resend domains update <id> --tls enforced --open-tracking` | Update settings |
| `resend domains delete <id> --yes` | Delete domain |

**Lifecycle**: create -> configure DNS -> verify -> get (poll until "verified").

### Topics

| Command | Description |
|---------|-------------|
| `resend topics list` | List all topics |
| `resend topics create --name "..."` | Create topic |
| `resend topics create --name "..." --default-subscription opt_out` | Create with default opt-out |
| `resend topics get <id>` | Get topic |
| `resend topics update <id> --name "..."` | Update topic |
| `resend topics delete <id> --yes` | Delete topic |

### Contact Properties

| Command | Description |
|---------|-------------|
| `resend contact-properties list` | List property definitions |
| `resend contact-properties create --key <key> --type string` | Create string property |
| `resend contact-properties create --key <key> --type number --fallback-value 0` | Create number property |
| `resend contact-properties update <id> --fallback-value "..."` | Update fallback |
| `resend contact-properties delete <id> --yes` | Delete property |

**Reserved keys** (built-in): FIRST_NAME, LAST_NAME, EMAIL, UNSUBSCRIBE_URL. Keys and types are immutable after creation.

### Webhooks

| Command | Description |
|---------|-------------|
| `resend webhooks list` | List webhook endpoints |
| `resend webhooks create --endpoint <url> --events all` | Create webhook |
| `resend webhooks get <id>` | Get webhook config |
| `resend webhooks listen` | Listen locally (dev) |
| `resend webhooks update <id> --status disabled` | Disable webhook |
| `resend webhooks delete <id> --yes` | Delete webhook |

**Events**: email.sent, email.delivered, email.bounced, email.complained, email.opened, email.clicked, email.failed, email.scheduled, email.suppressed, email.received, email.delivery_delayed, contact.created, contact.updated, contact.deleted, domain.created, domain.updated, domain.deleted

### API Keys

| Command | Description |
|---------|-------------|
| `resend api-keys list` | List API keys (no tokens shown) |
| `resend api-keys create --name "..."` | Create key (token shown once!) |
| `resend api-keys create --name "..." --permission sending_access --domain-id <id>` | Scoped key |
| `resend api-keys delete <id> --yes` | Delete key (immediate revocation) |

### Utility

| Command | Description |
|---------|-------------|
| `resend doctor` | Diagnose CLI, API key, domains |
| `resend whoami` | Show auth status |
| `resend open` | Open Resend dashboard |

## Global Flags

All commands accept:
- `--json` — force JSON output
- `--quiet` / `-q` — suppress spinners, implies JSON
- `--api-key <key>` — override stored key for single command
- `-p, --profile <name>` — use alternate profile

## Best Practices

1. **Always use `--json` or `--quiet`** when parsing output programmatically
2. **Use `--yes`** on destructive commands (delete, rm) to skip confirmation prompts
3. **Broadcasts**: Never delete a segment before a scheduled broadcast is sent — it will fail
4. **Templates**: Always publish after creating/updating before using in emails
5. **Batch sends**: Create a JSON file with array of email objects for `resend emails batch`
6. **Scheduling**: Supports ISO 8601 and natural language ("in 1 hour", "tomorrow at 9am ET")
7. **For HTML emails**: Prefer `--html-file` over inline `--html` for complex templates
8. **Contact properties**: Use triple-brace syntax in broadcasts `{{{PROP|fallback}}}` for personalization

## ClawRapid-specific Notes

- Sending domain: check with `resend domains list`
- Resend free plan limits: Transactional 100/day, 3,000/month. Marketing: 1,000 contacts, 3 segments
- For bulk sends over 100/day, use Marketing Broadcasts instead of transactional emails
- Resend Broadcasts DO support template variable interpolation with `{{{VAR|fallback}}}` triple-brace syntax in HTML
