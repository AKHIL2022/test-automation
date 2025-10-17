*** Test Cases ***
Subtract Two Numbers
    ${result}=    Evaluate    5 - 3
    Should Be Equal As Integers    ${result}    0    # Intentionally incorrect; correct result is 2
