# RoboCorp-Course2-CreateOrdersRobot

This is a Robot Process Automation (RPA) script that orders robots from RobotSpareBin Industries Inc. It saves the order HTML receipt as a PDF file, takes a screenshot of the ordered robot, embeds the screenshot of the robot to the PDF receipt and creates a ZIP archive of the receipts and images. 

The script uses the following libraries: 
- RPA.Browser.Selenium 
- RPA.HTTP 
- RPA.Tables 
- RPA.PDF 
- RPA.Desktop 
- RPA.FileSystem 
- RPA.Archive 

The script creates two temporary directories: PDF Output and Screenshots Directory, then opens the robot order website, downloads Orders file, fills out the form for each row in orders, stores the order receipt as a PDF file, takes a screenshot of the robot image, embeds it to the receipt PDF file and creates a ZIP file of all receipts before deleting temp directories at teardown.

- Get started from a simple task template in `tasks.robot`.
  - Uses [Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework/basics) syntax.
- You can configure your robot `robot.yaml`.
- You can configure dependencies in `conda.yaml`.

## Learning materials

- [Robocorp Developer Training Courses](https://robocorp.com/docs/courses)
- [Documentation links on Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework)
- [Example bots in Robocorp Portal](https://robocorp.com/portal)

