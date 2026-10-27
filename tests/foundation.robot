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
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the page menu jumps to the How To Join section, which
    ...    shows the four steps and the external application form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Click Page Menu Link    how-to-join
    How To Join Section Shows Four Steps
    Application Form Link Should Point To External Form

Join Link Target Heading Is Below The Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After clicking Join, the How To Join heading is fully visible below the
    ...    sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Click Page Menu Link    how-to-join
    Heading Should Clear Sticky Header    how-to-join

Application Form Link Points To External Form
    [Documentation]    SIT-INCIDENT-2-03: The How To Join section links to the external application form; the href
    ...    is checked without opening or submitting the form.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Open How To Join Anchor
    Application Form Link Should Point To External Form

Fees Link Jumps To Annual Fee Section
    [Documentation]    SIT-INCIDENT-2-04: Clicking Fees in the page menu jumps to the Annual fee section with its
    ...    heading fully visible below the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Click Page Menu Link    annual-fee
    Heading Should Clear Sticky Header    annual-fee
