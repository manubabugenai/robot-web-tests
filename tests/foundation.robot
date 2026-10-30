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
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the page menu jumps to the How To Join section, which
    ...    shows its four steps and the application form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Jump To Section Via Menu    ${HOW_TO_JOIN_SECTION}
    How To Join Should Show Steps

How To Join Heading Is Visible Below Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After jumping to How To Join, its heading stays visible below the sticky
    ...    header thanks to scroll-padding-top.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Jump To Section Via Menu    ${HOW_TO_JOIN_SECTION}
    Section Should Be In View    ${HOW_TO_JOIN_SECTION}

Foundation Menu Links Jump To Their Sections
    [Documentation]    SIT-INCIDENT-2-03: Each Foundation page menu anchor jumps to its section without being
    ...    hidden under the sticky header.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    FOR    ${section_id}    IN    your-benefits-and-cost    annual-fee    foundation-members
        Jump To Section Via Menu    ${section_id}
    END
