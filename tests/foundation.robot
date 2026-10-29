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
    Page Menu Should Link To    ${HOW_TO_JOIN}
    Page Menu Link Jumps To Section    ${HOW_TO_JOIN}
    How To Join Shows Steps And Form

Foundation Menu Anchor Accuracy For Other Links
    [Documentation]    SIT-INCIDENT-2-02: Each other Foundation page menu link jumps to its section, fully visible below the sticky header.
    [Tags]    sit    INCIDENT-2    REQ-300    regression
    FOR    ${section}    IN    our-work    your-benefits-and-cost    annual-fee    foundation-members
        Open Foundation Page
        Page Menu Link Jumps To Section    ${section}
    END
