# robot-web-tests

Robot Framework + SeleniumLibrary tests for [robotframework.org](https://robotframework.org), run in headless
Chrome. New tests are added through pull requests, by people or by Kiro (from a TQ-approved Jira incident).

## Tags

| Tag | Meaning |
|---|---|
| `smoke` | A few quick checks that the site is up |
| `regression` | Every regression test |
| `REQ-100` | Home page |
| `REQ-200` | Site navigation (shared header and footer) |
| `REQ-300` | Foundation page |
| `sit`, `<INCIDENT-KEY>` | SIT tests added for an incident, e.g. `INCIDENT-1` |

## Run locally

```powershell
python -m venv .venv; .venv\Scripts\pip install -r requirements.txt
.venv\Scripts\robot --outputdir results --include smoke tests            # 3 tests
.venv\Scripts\robot --outputdir results --include REQ-300 tests          # 3 tests
.venv\Scripts\robot --outputdir results --include smokeORREQ-300 tests   # 5 tests
```

Reports: `results/report.html` and `results/log.html`.

## Run on GitHub

**Actions → Robot tests → Run workflow**, then set *include* to a tag pattern. The job summary shows the totals
and failed tests, and the full report is in the `robot-results` artifact. Pull requests run the regression set.

## Layout

- `tests/*.robot`: one suite per area (`home`, `navigation`, `foundation`).
- `resources/*.resource`: page keywords and locators, reused by every test; `common.resource` opens the
  browser, and tests wait for elements instead of sleeping.
- `ci/summary.py`: writes the results to the job summary.
