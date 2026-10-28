---
name: locator-repair
description: Self-healing for failing Robot Framework UI tests. Use when a test failed because an element was not found, a count or text did not match, or a locator may be stale; diagnose on the live page, fix the locator in resources/, verify by re-running the test.
---

# Locator repair (self-healing)

The team's procedure for repairing a failing UI test without weakening it.

## 1. Read the failure
- The message says what went wrong: `Element '...' not visible`, `0 != 4` (a count), `'x' does not contain 'y'`.
- Find the failing step: the test calls keywords from `resources/*.resource`; the locator is in the keyword or a
  `${VARIABLE}` at the top of the resource file.

## 2. Classify before changing anything
- **Test-code defect** (repair it): the locator points to the wrong element (e.g. counting items inside a heading
  when they are in the block after it), an old id or class, a missing wait, an element hidden in the mobile menu.
  `StaleElementReferenceException` means the page re-rendered between finding and using an element: re-find
  it inside `Wait Until Keyword Succeeds` (as `Click First Visible` does) instead of keeping an old reference.
- **Product defect** (don't touch it): the page really shows something else than the approved test case expects
  (a missing section, a wrong text, a broken link). Report it instead.

## 3. Inspect the live page
Write a temporary `tests/_diag.robot` that opens the page (`Open Site` from `resources/common.resource`) and logs
what you need, then run it with `robot --outputdir results tests/_diag.robot`. Useful checks:
- `Get Element Count` for a candidate locator (expect exactly the elements you mean),
- `Execute Javascript` returning the outer HTML of an element and its next sibling,
- `Get Element Attribute` for `id`, `href`, `class`.
Delete `tests/_diag.robot` when done.

## 4. Fix
- Prefer stable locators: `id:` > `data-*` attributes (e.g. `data-component`) > structure relative to an id
  (e.g. `xpath://*[@id="how-to-join"]/following-sibling::div[1]//ol/li`) > visible text. Avoid long absolute
  XPaths and generated class names.
- Fix the **keyword or variable in `resources/`**, so every test that uses it is healed; touch the `.robot` test
  only if the test itself calls a raw locator.
- Keep every assertion and expected value. Never add `Sleep` or `Skip`; use `Wait Until ...` keywords for timing.

## 5. Verify
Run only the repaired test: `robot --outputdir results --test "<test name>" tests`. If it still fails, read the
new message and go back to step 3 (at most 3 tries). Then run the other tests of the same suite once, to check the
changed keyword didn't break them.

## 6. Report
One line per test: what was wrong, what you changed, and the run result. A CI guard rejects any repair that
adds, removes or weakens a test, or shortens a keyword.
