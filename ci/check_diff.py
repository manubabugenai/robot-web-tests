"""Guardrail for changes Kiro makes: reject anything but new or extended tests, before anything is pushed.

Usage: python ci/check_diff.py <base-ref> <INCIDENT-KEY>

Fails (exit 1) when:
- a file outside tests/ or resources/ changed (results/ is ignored),
- an existing test was removed or renamed,
- an existing test lost tags or became shorter (a weakened assertion),
- a new test lacks the tags sit, <INCIDENT-KEY>, regression and a REQ id, or uses Sleep or Skip,
- nothing new was added.
"""

import re
import subprocess
import sys
import tempfile
from pathlib import Path

from robot.api import TestSuiteBuilder

ALLOWED = ("tests/", "resources/")
REQ = re.compile(r"^REQ-\d+$")
FORBIDDEN_KEYWORDS = {"sleep", "skip", "skip if", "pass execution"}


def git(*args: str) -> str:
    return subprocess.run(["git", *args], capture_output=True, text=True, check=True).stdout


def changed_files(base: str) -> list[str]:
    tracked = git("diff", "--name-only", base).splitlines()
    untracked = git("ls-files", "--others", "--exclude-standard").splitlines()
    return sorted(set(tracked + untracked))


def tests_in(directory: Path) -> dict[str, dict]:
    """Every test in the .robot files under `directory`: {name: {"tags", "keywords", "steps"}}."""
    found = {}
    if not any(directory.glob("*.robot")):
        return found
    suite = TestSuiteBuilder().build(str(directory))
    for test in suite.all_tests:
        keywords = [getattr(item, "name", "") or "" for item in test.body]
        found[test.name] = {"tags": set(test.tags), "keywords": [k.lower() for k in keywords],
                            "steps": len(test.body)}
    return found


def base_tests(base: str) -> dict[str, dict]:
    """The tests as they are on `base`, parsed from a temporary copy of its tests/ folder."""
    with tempfile.TemporaryDirectory() as tmp:
        for path in git("ls-tree", "-r", "--name-only", base, "tests/").splitlines():
            if path.endswith(".robot"):
                target = Path(tmp) / Path(path).name
                target.write_text(git("show", f"{base}:{path}"), encoding="utf-8")
        return tests_in(Path(tmp))


def main(base: str, incident: str) -> int:
    problems = []
    outside = [f for f in changed_files(base) if not f.startswith(ALLOWED) and not f.startswith("results/")]
    problems += [f"changed a file outside tests/ and resources/: {f}" for f in outside]

    before, after = base_tests(base), tests_in(Path("tests"))
    for name, old in before.items():
        new = after.get(name)
        if new is None:
            problems.append(f"removed or renamed an existing test: {name}")
        elif not old["tags"] <= new["tags"]:
            problems.append(f"removed tags from {name}: {sorted(old['tags'] - new['tags'])}")
        elif new["steps"] < old["steps"]:
            problems.append(f"{name} has fewer steps than before ({old['steps']} -> {new['steps']})")

    added = {name: t for name, t in after.items() if name not in before}
    for name, test in added.items():
        missing = [tag for tag in ("sit", incident, "regression") if tag not in test["tags"]]
        if not any(REQ.match(tag) for tag in test["tags"]):
            missing.append("REQ-<id>")
        if missing:
            problems.append(f"new test {name!r} is missing tags: {', '.join(missing)}")
        if bad := sorted(FORBIDDEN_KEYWORDS & set(test["keywords"])):
            problems.append(f"new test {name!r} uses forbidden keywords: {', '.join(bad)}")
    if not added:
        problems.append("no new test was added")

    print(f"Base {base}: {len(before)} tests. Now: {len(after)} tests, {len(added)} new:")
    for name, test in added.items():
        print(f"  + {name}  [{', '.join(sorted(test['tags']))}]")
    if problems:
        print("\nREJECTED:")
        print("\n".join(f"  - {p}" for p in problems))
        return 1
    print("\nOK: only new, tagged tests in tests/ and resources/.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2]))
