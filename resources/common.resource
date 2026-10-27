*** Settings ***
Documentation       Shared setup for every suite: browser, base URL, waits. Tests never sleep; they wait for elements.
Library             SeleniumLibrary    timeout=10s    implicit_wait=0s


*** Variables ***
${BASE_URL}         https://robotframework.org
${BROWSER}          headlesschrome


*** Keywords ***
Open Site
    [Documentation]    Opens the browser on ${BASE_URL}${path} with a desktop window size.
    [Arguments]    ${path}=/
    Open Browser    ${BASE_URL}${path}    ${BROWSER}    options=add_argument("--window-size=1920,1080")
    Set Selenium Page Load Timeout    30s

Close Site
    [Documentation]    Closes all browsers opened by the suite.
    Close All Browsers

Section Should Be In View
    [Documentation]    Passes when the element with id ${section_id} is visible inside the browser window.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Element Top Should Be In Viewport    ${section_id}

Element Top Should Be In Viewport
    [Documentation]    Fails unless the top of the element is between the top and the bottom of the window.
    [Arguments]    ${section_id}
    ${in_view}=    Execute Javascript
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= -5 && r.top < window.innerHeight;
    Should Be True    ${in_view}    Section "${section_id}" is not in view

Click First Visible
    [Documentation]    Clicks the first visible element matching ${locator}. The site repeats some links in a hidden
    ...    mobile menu, so the first match in the page is not always the one a user can click.
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}
    ${elements}=    Get WebElements    ${locator}
    FOR    ${element}    IN    @{elements}
        ${visible}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        IF    ${visible}
            Click Element    ${element}
            RETURN
        END
    END
    Fail    No visible element matches ${locator}

Location Hash Should Be
    [Documentation]    Passes when the browser URL hash equals #${section_id}.
    [Arguments]    ${section_id}
    ${hash}=    Execute Javascript    return location.hash.replace("#", "");
    Should Be Equal    ${hash}    ${section_id}    URL hash is "${hash}", expected "${section_id}"

Heading Should Clear Sticky Header
    [Documentation]    Passes when the element with id ${section_id} sits in the viewport with its top at or below
    ...    the bottom of the sticky site header, so it is not hidden under the header.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Heading Top Is Below Header    ${section_id}

Heading Top Is Below Header
    [Documentation]    Fails unless the top of the element is between the sticky header bottom and the window bottom.
    [Arguments]    ${section_id}
    ${clears}=    Execute Javascript
    ...    const nav = document.querySelector('nav[data-component="nav-top"]');
    ...    const hb = nav ? nav.getBoundingClientRect().bottom : 0;
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= hb - 1 && r.top < window.innerHeight;
    Should Be True    ${clears}    Heading "${section_id}" is hidden under the sticky header or out of view
