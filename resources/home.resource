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

Hero Title Should Have Height
    [Documentation]    The hero title is visible and rendered with a height greater than 0, i.e. global styles apply.
    Wait Until Element Is Visible    ${HOME_HERO}
    ${height}=    Execute Javascript
    ...    return document.querySelector("h1.hero-title").getBoundingClientRect().height;
    Should Be True    ${height} > 0    Hero title height is ${height}, expected greater than 0

Open Home Section
    [Documentation]    Navigates directly to the home page anchor #${section_id} and waits for the section.
    [Arguments]    ${section_id}
    Go To    ${BASE_URL}/#${section_id}
    Wait Until Element Is Visible    id:${section_id}
