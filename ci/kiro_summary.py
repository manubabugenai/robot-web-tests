"""Summarise a headless Kiro run (stream-json events): tool calls, failures and Kiro's final reply.

Usage: python ci/kiro_summary.py <events.jsonl>   (prints, and appends to the GitHub job summary)
Exit 1 when Kiro reported an error or no tool call succeeded, so the workflow stops before the guard.
"""

import json
import os
import sys
from collections import Counter


def main(path: str) -> int:
    """Read the events file and write the summary; returns the exit code."""
    calls, done, failed, errors, final = Counter(), Counter(), Counter(), [], ""
    titles = {}
    for line in open(path, encoding="utf-8", errors="replace"):
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        data = event.get("data") or {}
        update = data.get("update") or {}
        if update.get("sessionUpdate") == "tool_call":
            titles[update.get("toolCallId")] = update.get("title", "tool")
            calls[update.get("title", "tool")] += 1
        elif update.get("sessionUpdate") == "tool_call_update" and update.get("status") in ("completed", "failed"):
            name = titles.get(update.get("toolCallId"), update.get("title", "tool"))
            (done if update["status"] == "completed" else failed)[name] += 1
        elif event.get("type") == "runError":
            errors.append(str(data.get("message") or data)[:300])
        elif event.get("type") == "runFinished":
            final = str(data.get("finalText") or "")
    rows = "\n".join(f"| {name} | {calls[name]} | {done[name]} | {failed[name]} |" for name in sorted(calls))
    text = ("## Kiro run\n\n| Tool | Calls | Completed | Failed |\n|---|---:|---:|---:|\n" + (rows or "| (none) | 0 | 0 | 0 |")
            + ("\n\n**Errors:**\n" + "\n".join(f"- {e}" for e in errors) if errors else "")
            + f"\n\n### Kiro's reply\n\n{final[-3000:] or '(no reply)'}\n")
    print(text)
    if summary := os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(summary, "a", encoding="utf-8") as fh:
            fh.write(text)
    with open(os.path.join(os.path.dirname(path), "kiro_reply.md"), "w", encoding="utf-8") as fh:
        fh.write(final[-3000:])
    return 1 if errors or not sum(done.values()) else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
