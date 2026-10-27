*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN}          id:how-to-join
${HOW_TO_JOIN_BODY}     xpath://section[.//h2[@id="how-to-join"]]
${APPLICATION_FORM}     https://docs.google.com/forms/d/e/1FAIpQLScOilsVlkYEB9a48OBmFG7NFTstSs5H5rqPEHjruC-gbE-NaQ/viewform


*** Keywords ***
Open Foundation Page
    [Documentation]    Opens the Foundation page and waits for its headings.
    Go To    ${BASE_URL}${FOUNDATION_PATH}
    Wait Until Page Contains    Robot Framework Foundation

Page Menu Link
    [Documentation]    Returns the locator of the Foundation page menu link to #${section_id}.
    [Arguments]    ${section_id}
    RETURN    css:nav[data-component="nav-top"] a[href="#${section_id}"]

Click Page Menu Link
    [Documentation]    Clicks the Foundation page menu link to #${section_id} and waits for the URL hash and for the
    ...    section heading to clear the sticky header. The site repeats the menu in a hidden mobile menu.
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}
    Wait Until Keyword Succeeds    5s    250ms    Location Hash Should Be    ${section_id}
    Heading Should Clear Sticky Header    ${section_id}

Open How To Join Anchor
    [Documentation]    Navigates directly to the Foundation How To Join anchor and waits for the section heading.
    Go To    ${BASE_URL}${FOUNDATION_PATH}#how-to-join
    Wait Until Element Is Visible    ${HOW_TO_JOIN}

How To Join Section Shows Four Steps
    [Documentation]    The How To Join section lists exactly four steps.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    ${count}=    Get Element Count    ${HOW_TO_JOIN_BODY}//ol/li
    Should Be Equal As Integers    ${count}    4    How To Join lists ${count} steps, expected 4

Application Form Link Should Point To External Form
    [Documentation]    The How To Join section links to the external application form; the href is checked, the
    ...    form is never opened or submitted.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    Page Should Contain Element    ${HOW_TO_JOIN_BODY}//a[@href="${APPLICATION_FORM}"]

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
