*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}          /foundation/
${MEMBERS_SECTION}          id:foundation-members
${HOW_TO_JOIN_SECTION}      how-to-join
${HASH}                     ${EMPTY}#


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
    [Documentation]    Clicks the Foundation page menu link to #${section_id}, using the first visible match.
    [Arguments]    ${section_id}
    ${link}=    Page Menu Link    ${section_id}
    Click First Visible    ${link}

Page Menu Link Should Open Section
    [Documentation]    Clicking the page menu link to #${section_id} brings that section into view and updates the URL hash.
    [Arguments]    ${section_id}
    Click Page Menu Link    ${section_id}
    Location Hash Should Become    ${section_id}
    Section Should Be In View    ${section_id}

Location Hash Should Become
    [Documentation]    Waits until the browser URL fragment is #${section_id}.
    [Arguments]    ${section_id}
    Wait Until Keyword Succeeds    10s    250ms    Current Location Hash Should Be    ${section_id}

Current Location Hash Should Be
    [Documentation]    Fails unless the current URL ends with the fragment #${section_id}.
    [Arguments]    ${section_id}
    ${url}=    Get Location
    ${fragment}=    Catenate    SEPARATOR=    ${HASH}    ${section_id}
    Should End With    ${url}    ${fragment}    URL "${url}" does not end with "${fragment}"

How To Join Section Should Show Steps And Form
    [Documentation]    The How To Join section shows the four numbered steps and links to the application form (href only, the form is never submitted).
    Section Should Be In View    ${HOW_TO_JOIN_SECTION}
    ${steps}=    Get Element Count
    ...    xpath://*[@id="${HOW_TO_JOIN_SECTION}"]/following-sibling::div[1]//ol/li
    Should Be True    ${steps} >= 4    How To Join should show at least 4 steps, found ${steps}
    Page Should Contain Element
    ...    xpath://*[@id="${HOW_TO_JOIN_SECTION}"]/following-sibling::div[1]//a[contains(@href,"docs.google.com/forms") or contains(@href,"forms.gle")]

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
