"""Guardrail for changes Kiro makes: reject anything but new or extended tests, before anything is pushed.

Usage: python ci/check_diff.py <base-ref> <INCIDENT-KEY> [--repair]

Fails (exit 1) when:
- a file outside tests/ or resources/ changed (results/ is ignored),
- an existing test was removed or renamed,
- an existing test lost tags or became shorter (a weakened assertion),
- a new test lacks the tags sit, <INCIDENT-KEY>, regression and a REQ id, or uses Sleep or Skip,
- nothing new was added.

With --repair (Kiro fixing failing tests; base = the PR branch before the fix), instead of the last two rules:
- a test was added (a repair only fixes),
- a test now uses Sleep or Skip,
- a keyword in resources/ has fewer steps than before (an assertion removed inside a keyword).
"""

import re
import subprocess
import sys
import tempfile
from pathlib import Path

from robot.api import TestSuiteBuilder
from robot.running import ResourceFile

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


def keyword_steps(directory: Path) -> dict[str, int]:
    """Steps per keyword in the .resource files under `directory`: {"file: keyword": steps}."""
    steps = {}
    for path in sorted(directory.glob("*.resource")):
        for keyword in ResourceFile.from_file_system(str(path)).keywords:
            steps[f"{path.name}: {keyword.name}"] = len(keyword.body)
    return steps


def base_keyword_steps(base: str) -> dict[str, int]:
    """keyword_steps of the resources/ folder as it is on `base`."""
    with tempfile.TemporaryDirectory() as tmp:
        for path in git("ls-tree", "-r", "--name-only", base, "resources/").splitlines():
            if path.endswith(".resource"):
                (Path(tmp) / Path(path).name).write_text(git("show", f"{base}:{path}"), encoding="utf-8")
        return keyword_steps(Path(tmp))


def check_repair(before: dict, after: dict, base: str) -> list[str]:
    """The repair-only rules: nothing added, no Sleep/Skip, no keyword shortened."""
    problems = [f"a repair must not add tests: {name}" for name in after if name not in before]
    for name, test in after.items():
        if bad := sorted(FORBIDDEN_KEYWORDS & set(test["keywords"]) - set(before.get(name, {}).get("keywords", []))):
            problems.append(f"{name!r} now uses forbidden keywords: {', '.join(bad)}")
    old_steps, new_steps = base_keyword_steps(base), keyword_steps(Path("resources"))
    problems += [f"keyword {k} has fewer steps than before ({n} -> {new_steps[k]})"
                 for k, n in old_steps.items() if k in new_steps and new_steps[k] < n]
    return problems


def main(base: str, incident: str, repair: bool = False) -> int:
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

    if repair:
        problems += check_repair(before, after, base)
        print(f"Repair against {base}: {len(before)} tests before, {len(after)} after.")
        if problems:
            print("\nREJECTED:")
            print("\n".join(f"  - {p}" for p in problems))
            return 1
        print("\nOK: only test code fixed; no test added, removed or weakened.")
        return 0

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
    sys.exit(main(sys.argv[1], sys.argv[2], repair="--repair" in sys.argv[3:]))
