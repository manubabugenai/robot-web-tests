*** Settings ***
Documentation       REQ-200 Site navigation: the shared header and footer.
Resource            ../resources/home.resource
Suite Setup         Open Site
Suite Teardown      Close Site
Test Setup          Open Home Page


*** Test Cases ***
Foundation Link Opens Foundation Page
    [Documentation]    Foundation in the site header opens the Foundation page.
    [Tags]    smoke    regression    REQ-200
    Open Foundation From Header
    Title Should Be    Robot Framework Foundation

Back To Robot Framework Returns Home
    [Documentation]    On the Foundation page, "< Back to Robot Framework" returns to the home page.
    [Tags]    regression    REQ-200
    Open Foundation From Header
    Click First Visible    xpath://nav[@data-component="nav-top"]//a[@href="/"][contains(normalize-space(), "Back to Robot Framework")]
    Wait Until Element Is Visible    ${HOME_HERO}
    Title Should Be    Robot Framework

Footer Shows Legal Links
    [Documentation]    The footer links to the Privacy Policy and the Code of Ethics.
    [Tags]    regression    REQ-200
    Footer Should Link To    https://robotframework.org/privacy-policy
    Footer Should Link To    https://robotframework.org/code-of-ethics

Shared Header Navigation Works On Foundation Page
    [Documentation]    SIT-INCIDENT-2-05: On the Foundation page, "< Back to Robot Framework" navigates to the home page.
    [Tags]    sit    INCIDENT-2    regression    REQ-200
    Open Foundation From Header
    Click First Visible    xpath://nav[@data-component="nav-top"]//a[@href="/"][contains(normalize-space(), "Back to Robot Framework")]
    Wait Until Element Is Visible    ${HOME_HERO}
    Title Should Be    Robot Framework
