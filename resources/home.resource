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

Scroll Padding Top Should Be Applied
    [Documentation]    The document root has a non-zero scroll-padding-top (the shared global.css offset so anchor
    ...    targets clear the sticky header), proving the shared CSS update loaded.
    ${padding}=    Execute Javascript
    ...    return getComputedStyle(document.documentElement).scrollPaddingTop;
    Should Not Be Empty    ${padding}
    Should Not Be Equal    ${padding}    auto    scroll-padding-top is not set on the document root
    Should Not Be Equal    ${padding}    0px    scroll-padding-top is not set on the document root
