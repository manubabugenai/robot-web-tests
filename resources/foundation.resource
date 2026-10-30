*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}          /foundation/
${MEMBERS_SECTION}          id:foundation-members
${JOIN_SECTION}             how-to-join
${STICKY_HEADER_OFFSET}     ${80}


*** Keywords ***
Open Foundation Page
    [Documentation]    Opens the Foundation page and waits for its headings.
    Go To    ${BASE_URL}${FOUNDATION_PATH}
    Wait Until Page Contains    Robot Framework Foundation

Page Menu Link
    [Documentation]    Returns the locator of the Foundation page menu link to #${section_id}.
    [Arguments]    ${section_id}
    RETURN    css:nav[data-component="nav-top"] a[href="#${section_id}"]

Fee Table Should Show
    [Documentation]    The Annual fee table shows the amount ${amount}.
    [Arguments]    ${amount}
    Wait Until Element Is Visible    css:table
    Element Should Contain    css:table    ${amount}

Members Should Include
    [Documentation]    The Foundation Members section lists ${company}.
    [Arguments]    ${company}
    Wait Until Element Is Visible    ${MEMBERS_SECTION}
    Page Should Contain Element    xpath://h3[normalize-space()="${company}"]

Click Page Menu Link
    [Documentation]    Clicks the Foundation page menu link to #${section_id} (the first visible one).
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}

Page Menu Link By Text
    [Documentation]    Returns the locator of the Foundation page menu link whose visible text is ${text}.
    [Arguments]    ${text}
    RETURN    xpath://nav[@data-component="nav-top"]//a[starts-with(@href, "#")][normalize-space()="${text}"]

Section Id Of Menu Link
    [Documentation]    Returns the section id (the part after #) that the menu link labelled ${text} points to.
    [Arguments]    ${text}
    ${locator}=    Page Menu Link By Text    ${text}
    Wait Until Page Contains Element    ${locator}
    ${href}=    Get Element Attribute    ${locator}    href
    ${section_id}=    Evaluate    $href.rsplit("#", 1)[-1]
    RETURN    ${section_id}

Menu Link Jumps To Section
    [Documentation]    Clicks the page menu link labelled ${text} and verifies its target section is in view.
    [Arguments]    ${text}
    ${section_id}=    Section Id Of Menu Link    ${text}
    ${locator}=    Page Menu Link By Text    ${text}
    Click First Visible    ${locator}
    Wait Until Location Contains    \#${section_id}
    Section Should Be In View    ${section_id}

Join Link Jumps To How To Join
    [Documentation]    Clicks Join in the page menu and waits until the How To Join section is in view.
    Click Page Menu Link    ${JOIN_SECTION}
    Wait Until Location Contains    \#${JOIN_SECTION}
    Wait Until Element Is Visible    id:${JOIN_SECTION}

Section Heading Should Be Below Sticky Header
    [Documentation]    Fails unless the top of section ${section_id} sits at or below the ${STICKY_HEADER_OFFSET}px
    ...    scroll-padding-top offset, so the sticky header does not cover the jumped-to heading.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Section Top Should Clear Offset    ${section_id}

Section Top Should Clear Offset
    [Documentation]    Checks the top of section ${section_id} is between -5px and the window bottom, allowing for the
    ...    sticky header offset so the heading is fully visible.
    [Arguments]    ${section_id}
    ${clear}=    Execute Javascript
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= -5 && r.top < window.innerHeight;
    Should Be True    ${clear}    Section "${section_id}" top is hidden under the sticky header

Application Form Link Target Should Be External
    [Documentation]    The How To Join section has a link to an external application form; checks its href is an
    ...    absolute http(s) URL (without submitting the form).
    Wait Until Element Is Visible    id:${JOIN_SECTION}
    ${locator}=    Set Variable
    ...    xpath://section[.//*[@id="${JOIN_SECTION}"]]//a[starts-with(@href, "http")]
    Wait Until Page Contains Element    ${locator}
    ${href}=    Get Element Attribute    ${locator}    href
    Should Match Regexp    ${href}    ^https?://    The application form link is not an absolute external URL
