"""Write a Robot Framework run's totals and failed tests to the GitHub job summary (and print them).

Usage: python ci/summary.py results/output.xml "<include pattern>"
"""

import os
import sys
import xml.etree.ElementTree as ET


def main(output_xml: str, include: str) -> int:
    """Summarise output.xml; returns 0 (the robot step already carries the pass/fail exit code)."""
    root = ET.parse(output_xml).getroot()
    total = root.find("./statistics/total/stat")
    passed, failed, skipped = (int(total.get(k, 0)) for k in ("pass", "fail", "skip"))
    failures = [(t.get("name"), (t.find("status").text or "").strip().splitlines()[0][:200])
                for t in root.iter("test") if t.find("status").get("status") == "FAIL"]
    lines = [f"## Robot Framework results: `{include}`", "",
             "| Passed | Failed | Skipped | Total |", "|---:|---:|---:|---:|",
             f"| {passed} | {failed} | {skipped} | {passed + failed + skipped} |", ""]
    if failures:
        lines += ["### Failed tests", "", "| Test | Message |", "|---|---|",
                  *(f"| {name} | {msg.replace('|', '/')} |" for name, msg in failures)]
    text = "\n".join(lines) + "\n"
    print(text)
    if path := os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(path, "a", encoding="utf-8") as fh:
            fh.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "all"))
