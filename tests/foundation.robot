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

Join Link Jumps To How To Join
    [Documentation]    SIT-INCIDENT-2-01: Join in the page menu jumps to the How To Join section with its steps and form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Click Page Menu Link    how-to-join
    Section Should Be In View    how-to-join
    How To Join Should Show Steps    4
    How To Join Should Link To Application Form

Join Heading Stays Below Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After jumping to How To Join, the heading is not hidden under the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Go To    ${BASE_URL}${FOUNDATION_PATH}#how-to-join
    Section Should Be In View    how-to-join
    Section Heading Should Not Be Hidden Under Header    how-to-join

Fees Menu Link Jumps To Annual Fee
    [Documentation]    SIT-INCIDENT-2-03: Fees in the page menu jumps to the Annual fee section and the URL ends with #annual-fee.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Click Page Menu Link    annual-fee
    Section Should Be In View    annual-fee
    Location Should Contain    \#annual-fee
