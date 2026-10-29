*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN}          how-to-join


*** Keywords ***
Page Menu Should Link To
    [Documentation]    The Foundation page menu has a link whose href is #${section_id}.
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Page Should Contain Element    ${locator}

Click Page Menu Link
    [Documentation]    Clicks the Foundation page menu link to #${section_id} (first visible one).
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}

Page Menu Link Jumps To Section
    [Documentation]    Clicks the page menu link to #${section_id} and verifies the section scrolls into view.
    [Arguments]    ${section_id}
    Click Page Menu Link    ${section_id}
    ${hash}=    Set Variable    #${section_id}
    Wait Until Location Contains    ${hash}
    Section Should Be In View    ${section_id}

How To Join Shows Steps And Form
    [Documentation]    The How To Join section shows its 4 steps and a link to the application form.
    Wait Until Element Is Visible    id:${HOW_TO_JOIN}
    ${steps}=    Get Element Count    css:#${HOW_TO_JOIN} ol li
    Should Be True    ${steps} >= 4    How To Join should list at least 4 steps, found ${steps}
    Page Should Contain Element    css:#${HOW_TO_JOIN} a[href]
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
