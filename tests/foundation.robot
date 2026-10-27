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
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the Foundation page menu jumps to the How To Join section with its steps and application form link.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Page Menu Link Should Open Section    ${HOW_TO_JOIN_SECTION}
    How To Join Section Should Show Steps And Form

Foundation Page Menu Anchor Links Navigate Correctly
    [Documentation]    SIT-INCIDENT-2-02: Each Foundation page menu link (Our Work, Benefits, Fees, Members) brings its section into view.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    FOR    ${section_id}    IN
    ...    what-we-do    your-benefits-and-cost    annual-fee    foundation-members
        Page Menu Link Should Open Section    ${section_id}
    END
