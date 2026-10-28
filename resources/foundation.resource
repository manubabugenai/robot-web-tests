*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members


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
    [Documentation]    Clicks the Foundation page menu link to #${section_id} (handles the hidden mobile menu).
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}

Jump To Section From Page Menu
    [Documentation]    Clicks the page menu link to #${section_id} and waits until the hash and the section are reached.
    [Arguments]    ${section_id}
    Click Page Menu Link    ${section_id}
    Wait Until Location Contains    \#${section_id}
    Section Should Be In View    ${section_id}

How To Join Section Should Be Complete
    [Documentation]    The How To Join section is visible and lists an application form link inside it.
    Wait Until Element Is Visible    id:how-to-join
    Page Should Contain Element    xpath://*[@id="how-to-join"]//a[@href]
