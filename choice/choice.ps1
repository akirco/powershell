$title = "Install Path Selection"

$message = "Please select a option from this useless choice menu?"

$10 = New-Object System.Management.Automation.Host.ChoiceDescription "&10", "Display the number 10"
$20 = New-Object System.Management.Automation.Host.ChoiceDescription "2&0", "Display the number 20."
$Ducks = New-Object System.Management.Automation.Host.ChoiceDescription "Du&cks", "Ducks are evil"

#---------------------------------------------------------------------------------------

$options = [System.Management.Automation.Host.ChoiceDescription[]]($10, $20, $Ducks)

#===================================================================================

$result = $host.ui.PromptForChoice($title, $message, $options, 0)



#--------------------THE MAGIC----------------------------

switch ($result) {
  0 { "C:\DEVHOME" }
  1 { "D:\DEVHOME" }
  2 { "E:\DEVHOME" }
}
