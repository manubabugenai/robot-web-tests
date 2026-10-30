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
    [Documentation]    SIT-INCIDENT-2-01: Clicking Join in the page menu jumps to the How To Join section and the URL ends with #how-to-join.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Join Link Jumps To How To Join
    Location Should Contain    \#how-to-join

Join Target Heading Is Not Hidden By Sticky Header
    [Documentation]    SIT-INCIDENT-2-02: After jumping to How To Join, the heading stays visible below the sticky header thanks to the scroll offset.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Join Link Jumps To How To Join
    Section Heading Should Be Below Sticky Header    ${JOIN_SECTION}

Other Page Menu Links Jump To Their Sections
    [Documentation]    SIT-INCIDENT-2-03: Our Work, Benefits, Fees and Members menu links each jump to their section with the heading in view.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    FOR    ${text}    IN    Our Work    Benefits    Fees    Members
        Open Foundation Page
        Menu Link Jumps To Section    ${text}
    END

Application Form Link Points To External Form
    [Documentation]    SIT-INCIDENT-2-05: The How To Join section links to an external application form; its href is checked without submitting.
    [Tags]    sit    INCIDENT-2    regression    REQ-300
    Join Link Jumps To How To Join
    Application Form Link Target Should Be External
