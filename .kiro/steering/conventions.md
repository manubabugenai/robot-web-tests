# Test conventions (robot-web-tests)

Rules for every test in this repo, for people and for Kiro.

## Structure
- One suite per area in `tests/`: `home.robot` (REQ-100), `navigation.robot` (REQ-200), `foundation.robot` (REQ-300).
  Add a test to the suite of the area it checks.
- Locators and page keywords live in `resources/*.resource`. Tests call keywords; they don't hold raw locators
  when a keyword fits. Add a keyword to the matching resource file if one is missing.
- `resources/common.resource` opens the browser (`Open Site`), closes it (`Close Site`), and has shared helpers:
  `Section Should Be In View`, `Click First Visible`.

## Writing tests
- Test name: what is verified, in Title Case ("Join Link Jumps To How To Join").
- Every test has `[Documentation]` (one sentence) and `[Tags]`.
- Tags: `regression`, the REQ id of the area (`REQ-100`, `REQ-200`, `REQ-300`), and for SIT tests from an incident
  also `sit` and the incident key (e.g. `INCIDENT-1`). Add `smoke` only for a quick health check.
- No sleeps (`Sleep` is forbidden). Use waits: `Wait Until Element Is Visible`, `Wait Until Page Contains`,
  `Wait Until Location Contains`, `Wait Until Keyword Succeeds`.
- The site repeats some header links in a hidden mobile menu: click them with `Click First Visible`.
- Never submit external forms (Google Forms, Calendly) or send email: check the link's `href` instead.
- No credentials or personal data in tests.

## Changes
- Never delete or weaken an existing test (no removed assertions, no `Skip`). A CI check rejects it.
- Only change files under `tests/` and `resources/`.
- Run the new tests before finishing: `robot --outputdir results --include <INCIDENT-KEY> tests`.
