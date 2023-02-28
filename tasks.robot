*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library    RPA.Browser.Selenium
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF
Library    RPA.Desktop
Library    RPA.FileSystem
Library    RPA.Archive
*** Variables ***
${PDFOutputDirectory}    ${CURDIR}${/}PDF Output
${ScreenshotsDirectory}    ${CURDIR}${/}Screenshots Directory
*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Create temp directories
    Open the robot order website
    Download Orders file
    ${orders}=    Get Orders    orders.csv
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Wait Until Keyword Succeeds    3x    0.5 sec    Fill the form   ${row}
        ${pdfFile}=    Store the order receipt as a PDF File    ${row}[Order number]
        ${screenShotPath}=    Take a screenshot of the robot image    ${row}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${pdfFile}    ${screenShotPath}
        Go to order another robot

    END
    Create ZIP file of all receipts
    [Teardown]    Delete Temp Directories
*** Keywords ***
Create temp directories
    Create Directory    ${PDFOutputDirectory}
    Create Directory    ${ScreenshotsDirectory}
Open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
Download Orders file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
Get Orders
    [Arguments]
    ...    ${CSVFilePath}
    ${CSVData}=    Read table from CSV    ${CSVFilePath}    header=True
    [Return]    ${CSVData}
Close the annoying modal
    Click Button When Visible    locator=xpath://button[@class='btn btn-dark' and text()='OK']
Fill the form
    [Arguments]    ${row}
    Select From List By Value    id:head    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Input Text    locator=xpath://input[@min='1' and @max='6' and @type='number']    text=${row}[Legs]
    Input Text    id:address    ${row}[Address]
    Click Button    id:preview
    Click Button    id:order
    Wait Until Element Is Visible    id:order-another
Store the order receipt as a PDF File
    [Arguments]    ${rowOrderNumber}
    ${receiptHTML}=    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${receiptHTML}    ${PDFOutputDirectory}${/}robotReceipt_${rowOrderNumber}.pdf
    [Return]    ${PDFOutputDirectory}${/}robotReceipt_${rowOrderNumber}.pdf
Take a screenshot of the robot image
    [Arguments]    ${orderNumber}
    Wait Until Element Is Visible    id:robot-preview
    ${screenShotPath}=    Screenshot    id:robot-preview-image    filename=${ScreenshotsDirectory}${/}robotOrderScreenshot_${orderNumber}.png
    [Return]    ${ScreenshotsDirectory}${/}robotOrderScreenshot_${orderNumber}.png
Embed the robot screenshot to the receipt PDF file
    [Arguments]    ${in_PDFPath}    ${screenShotPath}
    Open Pdf    ${in_PDFPath}
    ${files}=    Create List    ${screenShotPath}:align=center
    Add Files To Pdf    ${files}    ${in_PDFPath}    append=True
    Close Pdf    ${in_PDFPath}
Go to order another robot
    Click Button    id:order-another
    Wait Until Element Is Visible    id:order
Create ZIP file of all receipts
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${PDFOutputDirectory}
    ...    ${zip_file_name}
Delete Temp Directories
    Remove Directory    ${PDFOutputDirectory}    True
    Remove Directory    ${ScreenshotsDirectory}    True