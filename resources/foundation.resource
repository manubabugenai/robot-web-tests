*** Settings ***
Documentation       Foundation page (REQ-300): locators and keywords.
Resource            common.resource


*** Variables ***
${FOUNDATION_PATH}      /foundation/
${MEMBERS_SECTION}      id:foundation-members
${HOW_TO_JOIN}          id:how-to-join
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
    [Documentation]    Clicks the Foundation page menu link to #${section_id} and waits for the hash in the URL.
    [Arguments]    ${section_id}
    ${locator}=    Page Menu Link    ${section_id}
    ${hash}=    Set Variable    ${{'#' + $section_id}}
    Click First Visible    ${locator}
    Wait Until Location Contains    ${hash}

Application Form Link Should Target External Form
    [Documentation]    The How To Join section links to the external application form without submitting it.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    Page Should Contain Element    xpath://*[@id="how-to-join"]/following::a[@href="${APPLICATION_FORM}"]

How To Join Should Show Four Steps
    [Documentation]    The How To Join section lists the 4 steps to become a member.
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    ${steps}=    Execute Javascript
    ...    const s = document.getElementById("how-to-join");
    ...    let n = s; let ol = null;
    ...    for (let i = 0; i < 6 && n; i++) { n = n.nextElementSibling; if (n && n.querySelector('ol')) { ol = n.querySelector('ol'); break; } }
    ...    return ol ? ol.querySelectorAll('li').length : 0;
    Should Be True    ${steps} >= 4    Expected at least 4 steps in How To Join, found ${steps}

Section Heading Below Sticky Header
    [Documentation]    Passes when the top of #${section_id} sits below the bottom of the sticky header and is visible.
    [Arguments]    ${section_id}
    Wait Until Element Is Visible    id:${section_id}
    Wait Until Keyword Succeeds    5s    250ms    Section Heading Not Hidden Under Header    ${section_id}

Section Heading Not Hidden Under Header
    [Documentation]    Fails unless the top of #${section_id} is at or below the bottom of the sticky header and in view.
    [Arguments]    ${section_id}
    ${not_hidden}=    Execute Javascript
    ...    const s = document.getElementById("${section_id}");
    ...    const nav = document.querySelector('nav[data-component="nav-top"]');
    ...    const sr = s.getBoundingClientRect();
    ...    const hr = nav.getBoundingClientRect();
    ...    const headerBottom = hr.top + hr.height;
    ...    return sr.top >= headerBottom - 1 && sr.top < window.innerHeight;
    Should Be True    ${not_hidden}    Section "${section_id}" heading is hidden under the sticky header or out of view

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
