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

Hero Title Should Render With Height
    [Documentation]    The hero title element has a rendered height greater than 0, confirming shared global styles apply.
    Wait Until Element Is Visible    ${HOME_HERO}
    ${height}=    Execute Javascript
    ...    const h = document.querySelector("h1.hero-title");
    ...    return h ? h.getBoundingClientRect().height : 0;
    Should Be True    ${height} > 0    Hero title has no rendered height; global styles did not apply

Home Section Heading Should Be Below Sticky Header
    [Documentation]    After navigating to #${section_id}, its heading sits below the sticky header bottom and is visible.
    [Arguments]    ${section_id}
    Go To    ${BASE_URL}/#${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Home Heading Top Clears Sticky Header    ${section_id}

Home Heading Top Clears Sticky Header
    [Documentation]    Fails unless the top of the section is at or below the sticky header bottom and inside the window.
    [Arguments]    ${section_id}
    ${clears}=    Execute Javascript
    ...    const header = document.querySelector('nav[data-component="nav-top"]');
    ...    const headerBottom = header ? header.getBoundingClientRect().bottom : 0;
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= headerBottom - 1 && r.top < window.innerHeight;
    Should Be True    ${clears}    Section "${section_id}" heading is hidden behind or outside the sticky header
