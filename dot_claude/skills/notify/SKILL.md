---
name: notify
description: Send a macOS desktop notification that stays on screen until the user closes it. Use when the user asks to be notified, pinged, alerted, or told when something happens — "notify me when", "ping me when", "let me know when", "tell me when CI is green", "alert me if it fails" — or invokes /notify.
---

# Notify

Run this command once, at the moment the event occurs:

```sh
claude-notify "<title>" "<message>"
```

The notification persists until the user clicks Close. A click on the notification brings Ghostty to the front.

## Rules

- Send the notification only when the event the user asked about occurs. Do not send it when you start to wait.
- Put the outcome in the title. Examples: `CI green`, `Build failed`, `Needs your input`.
- Put the fact the user acts on in the message. Keep it to one line under 150 characters. Example: `#16981: 2 auth tests fail in api-test`.
- If the event is in the future, wait for it first. Use `Monitor`, `run_in_background`, or `ScheduleWakeup`, then notify.
- If the work fails or stops, send a notification that says so. The user is not watching the terminal.
- With no title, the title is `Claude Code`: `claude-notify "<message>"`.

## Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| Exit 1, `Notifications are not allowed` | Permission is off | System Settings → Notifications → Claude Notify → Allow |
| The banner goes away by itself | Style is Temporary | System Settings → Notifications → Claude Notify → Persistent |
| Nothing shows until later | A Focus mode holds it | Add Claude Notify to the allowed apps of that Focus |
| `No such file` | The app is not built | `chezmoi apply` (runs `run_onchange_after_40-build-claude-notify.sh`) |
