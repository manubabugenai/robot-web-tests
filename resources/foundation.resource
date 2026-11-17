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

Click Page Menu Link Named
    [Documentation]    Clicks the Foundation page menu link with the text ${name} and returns the section id it targets.
    [Arguments]    ${name}
    ${locator}=    Set Variable
    ...    xpath://nav[@data-component="nav-top"]//a[starts-with(@href, "#")][normalize-space()="${name}"]
    Wait Until Page Contains Element    ${locator}
    ${href}=    Get Element Attribute    ${locator}    href
    ${section_id}=    Evaluate    $href.split("#")[-1]
    Click First Visible    ${locator}
    RETURN    ${section_id}

Menu Link Should Jump To Section
    [Documentation]    Clicking the menu link ${name} brings its target section into view and updates the URL hash.
    [Arguments]    ${name}
    ${section_id}=    Click Page Menu Link Named    ${name}
    Wait Until Location Contains    \#${section_id}
    Section Should Be In View    ${section_id}

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
