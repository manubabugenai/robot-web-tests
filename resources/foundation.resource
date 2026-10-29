*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN}          id:how-to-join
${STICKY_HEADER_PX}     ${72}


*** Keywords ***
Open Foundation Page
    [Documentation]    Opens the Foundation page and waits for its headings.
    Go To    ${BASE_URL}${FOUNDATION_PATH}
    Wait Until Page Contains    Robot Framework Foundation

Page Menu Link
    [Documentation]    Returns the locator of the Foundation page menu link to #${section_id}.
    [Arguments]    ${section_id}
    RETURN    css:nav[data-component="nav-top"] a[href="#${section_id}"]

Page Menu Link Should Target
    [Documentation]    The Foundation page menu link labelled ${text} points to #${section_id}.
    [Arguments]    ${text}    ${section_id}
    Page Should Contain Element
    ...    xpath://nav[@data-component="nav-top"]//a[@href="#${section_id}"][contains(normalize-space(), "${text}")]

Click Page Menu Link
    [Documentation]    Clicks the Foundation page menu link to #${section_id} (the first visible one).
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}

Join Link Should Jump To How To Join
    [Documentation]    Clicks Join in the page menu and waits for the How To Join section to be in view.
    Page Menu Link Should Target    Join    how-to-join
    Click Page Menu Link    how-to-join
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    Section Should Be In View    how-to-join

How To Join Should Show Steps And Application Form
    [Documentation]    The How To Join section shows the four steps and a link to the application form.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    ${steps}=    Get Element Count    css:#how-to-join li
    Should Be True    ${steps} >= 4    How To Join should list at least four steps, found ${steps}
    Page Should Contain Element    css:#how-to-join a[href]

Section Heading Should Clear Sticky Header
    [Documentation]    The top of section #${section_id} sits below the sticky header (${STICKY_HEADER_PX}px) and in view.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Section Top Should Clear Header    ${section_id}

Section Top Should Clear Header
    [Documentation]    Fails unless the top of #${section_id} is between the sticky header and the window bottom.
    [Arguments]    ${section_id}
    ${clear}=    Execute Javascript
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= ${STICKY_HEADER_PX} - 5 && r.top < window.innerHeight;
    Should Be True    ${clear}    Section "${section_id}" is hidden behind or outside the sticky header

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
