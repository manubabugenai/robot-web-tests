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

Foundation Page Join Link Jumps To How To Join Section
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the page menu jumps the view to the How To Join section with its application form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Jump To Section From Page Menu    how-to-join
    How To Join Section Should Be Complete

Jumped-To Heading Visibility Below Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After clicking Join, the How To Join heading is fully visible below the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Jump To Section From Page Menu    how-to-join
    Section Should Be In View    how-to-join

Verify Other Menu Links On The Foundation Page
    [Documentation]    SIT-INCIDENT-2-03: Benefits, Fees and Members page menu links each jump to their section below the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    FOR    ${section_id}    IN    your-benefits-and-cost    annual-fee    foundation-members
        Jump To Section From Page Menu    ${section_id}
    END
