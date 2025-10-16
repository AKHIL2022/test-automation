*** Settings ***
Library    src.calculator    # Imports the Python module as a library

*** Test Cases ***
Add Positive Numbers
    ${result}=    Add    2    3
    Should Be Equal    ${result}    5