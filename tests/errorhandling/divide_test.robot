*** Settings ***
Library    src.calculator    # Imports the Python module as a library

*** Test Cases ***
Divide By Zero Should Fail
    Run Keyword And Expect Error    *Division by zero error*    Divide    10    0