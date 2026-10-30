*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN_SECTION}      howjoin


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

Jump To Section Via Menu
    [Documentation]    Clicks the page menu link to #${section_id} and waits until that section is in view
    ...    below the sticky header (scroll-padding-top keeps it from being hidden).
    [Arguments]    ${section_id}
    Click First Visible    css:nav[data-component="nav-top"] a[href="#${section_id}"]
    Wait Until Location Contains    \#${section_id}
    Section Should Be In View    ${section_id}

How To Join Should Show Steps
    [Documentation]    The How To Join section shows its four steps and the application form link.
    ...    The #how-to-join id is on the heading, so the steps and link live in the block after it.
    Wait Until Element Is Visible    id:${HOW_TO_JOIN_SECTION}
    ${steps}=    Get Element Count    xpath://*[@id="${HOW_TO_JOIN_SECTION}"]/following-sibling::div[1]//ol/li
    Should Be True    ${steps} >= 4    How To Join should list at least 4 steps
    Page Should Contain Element    xpath://*[@id="${HOW_TO_JOIN_SECTION}"]/following-sibling::div[1]//a
