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

Home Page Renders Correctly With Shared Global Styles
    [Documentation]    SIT-INCIDENT-2-05: The Home page loads with the shared global styles intact and anchor scrolling clears the sticky header.
    [Tags]    sit    INCIDENT-2    REQ-100    regression
    Title Should Be    Robot Framework
    Element Should Be Visible    ${HOME_HERO}
    ${hero_height}=    Execute Javascript
    ...    return document.querySelector('h1.hero-title').getBoundingClientRect().height;
    Should Be True    ${hero_height} > 0    Hero title has no rendered height; global styles may be broken
    Go To    ${BASE_URL}/#get-started
    Home Section Heading Below Sticky Header    get-started
