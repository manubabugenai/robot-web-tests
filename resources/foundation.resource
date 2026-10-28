*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN}          id:how-to-join
${ANNUAL_FEE}           id:annual-fee
${APPLICATION_FORM}     https://docs.google.com/forms/d/e/1FAIpQLScOilsVlkYEB9a48OBmFG7NFTstSs5H5rqPEHjruC-gbE-NaQ/viewform
${STICKY_HEADER}        css:nav[data-component="nav-top"]


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
    [Documentation]    Clicks the Foundation page menu link to #${section_id} (visible one; some links repeat in a hidden menu).
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}

Location Hash Should Be
    [Documentation]    The browser URL ends with the anchor #${section_id}.
    [Arguments]    ${section_id}
    ${hash}=    Set Variable    #${section_id}
    Wait Until Location Contains    ${hash}

Section Heading Should Be Below Sticky Header
    [Documentation]    The top of the section with id ${section_id} sits below the sticky header bottom and is fully visible.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Heading Top Clears Sticky Header    ${section_id}

Heading Top Clears Sticky Header
    [Documentation]    Fails unless the top of the section is at or below the sticky header bottom and inside the window.
    [Arguments]    ${section_id}
    ${clears}=    Execute Javascript
    ...    const header = document.querySelector('nav[data-component="nav-top"]');
    ...    const headerBottom = header ? header.getBoundingClientRect().bottom : 0;
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= headerBottom - 1 && r.top < window.innerHeight;
    Should Be True    ${clears}    Section "${section_id}" heading is hidden behind or outside the sticky header

How To Join Steps Should Count
    [Documentation]    The How To Join section lists ${count} ordered steps.
    [Arguments]    ${count}
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    ${steps}=    Execute Javascript
    ...    const s = document.getElementById("how-to-join");
    ...    return s ? s.querySelectorAll("ol li").length : 0;
    Should Be Equal As Integers    ${steps}    ${count}

Application Form Link Should Point To Form
    [Documentation]    The How To Join section has a link whose href is the external application form, without submitting it.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    Page Should Contain Element    css:a[href="${APPLICATION_FORM}"]
