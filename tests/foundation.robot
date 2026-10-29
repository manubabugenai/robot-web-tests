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

Reproduce Reported Incident Join Link Jumps To How To Join Section
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the Foundation page menu jumps to the How To Join section with its steps and application form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Join Link Should Jump To How To Join
    How To Join Should Show Steps And Application Form

Check Sticky Header Offset For Jumped To Headings
    [Documentation]    SIT-INCIDENT-2-02: After the Join jump, the How To Join heading is fully visible below the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Join Link Should Jump To How To Join
    Section Heading Should Clear Sticky Header    how-to-join

Re-Check Other Links In The Foundation Page Menu
    [Documentation]    SIT-INCIDENT-2-03: The other Foundation page menu links jump to their correct sections below the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    FOR    ${text}    ${section_id}    IN
    ...    Benefits    your-benefits-and-cost
    ...    Fees    annual-fee
    ...    Members    foundation-members
        Open Foundation Page
        Page Menu Link Should Target    ${text}    ${section_id}
        Click Page Menu Link    ${section_id}
        Section Heading Should Clear Sticky Header    ${section_id}
    END
