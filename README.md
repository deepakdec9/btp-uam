# btp-uam
Powershell based GUI tool to bulk add or remove users from SAP BTP Cloudfoundry environment.
How to use
- download and extract the files
- right click and run powershell script btp-user-management.ps1 to open GUI
- when using first time enter your btp credentials and click reload data button to load the btp subaccounts and spaces
- once loaded use the GUI to add remove uer access for all subaccounts or space with single click
- (API endpoints can be adjusted as per your requirement in the script, just open and add/update/remove the endpoint in variable "$apiEndpoints")
