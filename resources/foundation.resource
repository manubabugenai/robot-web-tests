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
    [Documentation]    Clicks the Foundation page menu link to #${section_id} and waits for the URL hash.
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    Click First Visible    ${locator}
    Wait Until Location Contains    \#${section_id}

How To Join Should Show Steps
    [Documentation]    The How To Join section lists ${count} numbered steps in its body (the block after the heading).
    [Arguments]    ${count}
    ${steps}=    Set Variable    xpath://*[@id="how-to-join"]/following-sibling::div[1]//ol/li
    Wait Until Element Is Visible    id:how-to-join
    Wait Until Keyword Succeeds    5s    250ms    Element Count Should Be    ${steps}    ${count}

Element Count Should Be
    [Documentation]    Fails unless exactly ${count} elements match ${locator}.
    [Arguments]    ${locator}    ${count}
    ${found}=    Get Element Count    ${locator}
    Should Be Equal As Integers    ${found}    ${count}

How To Join Should Link To Application Form
    [Documentation]    The How To Join section body links to the membership application form.
    Wait Until Element Is Visible    id:how-to-join
    Page Should Contain Element
    ...    xpath://*[@id="how-to-join"]/following-sibling::div[1]//a[contains(@href, "forms")]

Section Heading Should Not Be Hidden Under Header
    [Documentation]    The top of section #${section_id} sits at or below the sticky header, so its heading is not
    ...    covered. Uses the global scroll-padding-top (80px); allows a small tolerance.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Section Top Should Clear Header    ${section_id}

Section Top Should Clear Header
    [Documentation]    Fails unless the top of #${section_id} is below the sticky header and inside the window.
    [Arguments]    ${section_id}
    ${header_bottom}=    Execute Javascript
    ...    const h = document.querySelector(".site-header");
    ...    return h ? h.getBoundingClientRect().bottom : 72;
    ${cleared}=    Execute Javascript
    ...    const r = document.getElementById("${section_id}").getBoundingClientRect();
    ...    return r.top >= ${header_bottom} - 5 && r.top < window.innerHeight;
    Should Be True    ${cleared}    Section "${section_id}" heading is hidden under the sticky header
