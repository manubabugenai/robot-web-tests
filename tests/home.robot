*** Settings ***
Documentation       REQ-100 Home page: https://robotframework.org/
Resource            ../resources/home.resource
Suite Setup         Open Site
Suite Teardown      Close Site
Test Setup          Open Home Page


*** Test Cases ***
Home Page Loads
    [Documentation]    The home page opens with the Robot Framework title and hero heading.
    [Tags]    smoke    regression    REQ-100
    Title Should Be    Robot Framework
    Element Should Be Visible    ${HOME_HERO}

Top Navigation Shows Main Sections
    [Documentation]    The site header links to Get Started, Resources, Community, Development and Foundation.
    [Tags]    regression    REQ-100
    FOR    ${href}    IN    /#get-started    /#resources    /#community    /#development    /foundation
        Top Navigation Should Link To    ${href}
    END

Get Started Shows Install Command
    [Documentation]    The Get Started section shows how to install Robot Framework with pip.
    [Tags]    regression    REQ-100
    Wait Until Element Is Visible    id:get-started
    Page Should Contain    pip install robotframework

Home Anchor Jump Respects Scroll Padding
    [Documentation]    SIT-INCIDENT-2-04: A home page anchor jump scrolls to the section and keeps its heading
    ...    visible below the sticky header, confirming the shared scroll-padding-top rule.
    [Tags]    sit    INCIDENT-2    regression    REQ-100
    Jump To Home Section    get-started
