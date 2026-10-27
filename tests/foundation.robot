*** Settings ***
Documentation       REQ-300 Foundation page: https://robotframework.org/foundation/
Resource            ../resources/foundation.resource
Suite Setup         Open Site    ${FOUNDATION_PATH}
Suite Teardown      Close Site
Test Setup          Open Foundation Page


*** Test Cases ***
Foundation Page Shows Headings
    [Documentation]    The page shows "More Than A Project" and "Robot Framework Foundation".
    [Tags]    smoke    regression    REQ-300
    Title Should Be    Robot Framework Foundation
    Page Should Contain    More Than A Project
    Page Should Contain    Robot Framework Foundation

Annual Fee Table Lists Five Bands
    [Documentation]    The Annual fee table shows the five yearly fees.
    [Tags]    regression    REQ-300
    FOR    ${amount}    IN    €500    €1,500    €3,000    €6,000    €12,000
        Fee Table Should Show    ${amount}
    END

Members List Includes ABB And Nokia
    [Documentation]    Foundation Members lists member companies, among them ABB and Nokia.
    [Tags]    regression    REQ-300
    Members Should Include    ABB
    Members Should Include    Nokia

Join Link Jumps To How To Join Section
    [Documentation]    SIT-INCIDENT-2-01: Join in the page menu jumps to How To Join showing the 4 steps and the application form link.
    [Tags]    sit    INCIDENT-2    REQ-300    regression
    Click Page Menu Link    how-to-join
    Section Should Be In View    how-to-join
    Page Should Contain    How To Join
    How To Join Should Show Four Steps
    Application Form Link Should Target External Form

Join Link Target Heading Is Below The Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After clicking Join, the How To Join heading stays fully visible below the sticky header.
    [Tags]    sit    INCIDENT-2    REQ-300    regression
    Click Page Menu Link    how-to-join
    Section Heading Below Sticky Header    how-to-join

Application Form Link Points To External Form
    [Documentation]    SIT-INCIDENT-2-03: The How To Join application link targets the external application form and is not submitted.
    [Tags]    sit    INCIDENT-2    REQ-300    regression
    Go To    ${BASE_URL}${FOUNDATION_PATH}#how-to-join
    Wait Until Element Is Visible    ${HOW_TO_JOIN}
    Application Form Link Should Target External Form

Fees Link Jumps To Annual Fee Section
    [Documentation]    SIT-INCIDENT-2-04: Fees in the page menu jumps to the Annual fee section with its heading fully visible.
    [Tags]    sit    INCIDENT-2    REQ-300    regression
    Click Page Menu Link    annual-fee
    Section Should Be In View    annual-fee
    Section Heading Below Sticky Header    annual-fee
