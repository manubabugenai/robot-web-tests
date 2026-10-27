*** Settings ***
Documentation       Home page (REQ-100) and the shared site header and footer (REQ-200): locators and keywords.
Resource            common.resource


*** Variables ***
${HOME_HERO}            css:h1.hero-title
${NAV_TOP}              css:nav[data-component="nav-top"]
${NAV_FOUNDATION}       css:nav[data-component="nav-top"] a[href="/foundation"]


*** Keywords ***
Open Home Page
    [Documentation]    Opens the home page and waits for its hero heading.
    Go To    ${BASE_URL}/
    Wait Until Element Is Visible    ${HOME_HERO}

Top Navigation Should Link To
    [Documentation]    The site header has a link to ${href}.
    [Arguments]    ${href}
    Page Should Contain Element    css:nav[data-component="nav-top"] a[href="${href}"]

Open Foundation From Header
    [Documentation]    Clicks Foundation in the site header and waits for the Foundation page.
    Click First Visible    ${NAV_FOUNDATION}
    Wait Until Location Contains    /foundation
    Wait Until Page Contains    Robot Framework Foundation

Footer Should Link To
    [Documentation]    The page footer links to ${href}.
    [Arguments]    ${href}
    Page Should Contain Element    css:a[href="${href}"]

Home Section Heading Below Sticky Header
    [Documentation]    Passes when the top of #${section_id} sits below the bottom of the shared sticky header and is in view.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Home Section Not Hidden Under Header    ${section_id}

Home Section Not Hidden Under Header
    [Documentation]    Fails unless the top of #${section_id} is at or below the bottom of the sticky header and in view.
    [Arguments]    ${section_id}
    ${not_hidden}=    Execute Javascript
    ...    const s = document.getElementById("${section_id}");
    ...    const nav = document.querySelector('nav[data-component="nav-top"]');
    ...    const sr = s.getBoundingClientRect();
    ...    const hr = nav.getBoundingClientRect();
    ...    const headerBottom = hr.top + hr.height;
    ...    return sr.top >= headerBottom - 1 && sr.top < window.innerHeight;
    Should Be True    ${not_hidden}    Section "${section_id}" heading is hidden under the sticky header or out of view
