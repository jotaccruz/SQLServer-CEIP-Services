# SQL Server services current status #
Get-DbaService -Type SSAS,SSRS,SSIS,Engine,Agent,Browser,FullText
Get-Service |? name -Like "*TELEMETRY*" | select -property name,starttype,status

# Disabling SQL Server CEIP services#
Get-Service -name "*TELEMETRY*" | Stop-Service -passthru | Set-Service -startmode disabled

# SQL Server services current status #
Get-DbaService -Type SSAS,SSRS,SSIS,Engine,Agent,Browser,FullText
Get-Service |? name -Like "*TELEMETRY*" | select -property name,starttype,status

##################################################
# Disabling CEIP Key Register                    #
##################################################
# Set to 0 the CustomerFeedback and EnableErrorReporting keys in the register HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\***\CustomerFeedback=0
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\***\EnableErrorReporting=0
# *** --> SQL Server Version (100,110,120,130,140,...)
# For SQL Server
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSSQL**.<instance>\CPE\CustomerFeedback=0
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSSQL**.<instance>\CPE\EnableErrorReporting=0
# For SQL Server Analysis Server (SSAS)
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSAS**.<instance>\CPE\CustomerFeedback=0
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSAS**.<instance>\CPE\EnableErrorReporting=0
# For SQL Server Reporting Server (SSRS)
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSRS**.<instance>\CPE\CustomerFeedback=0
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSRS**.<instance>\CPE\EnableErrorReporting=0
# ** --> SQL Server Version (100,110,120,130,140,...)
##################################################
$Key = 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server'
$FoundKeys = Get-ChildItem $Key -Recurse | Where-Object -Property Property -eq 'EnableErrorReporting'
foreach ($Sqlfoundkey in $FoundKeys)
{
$SqlFoundkey | Set-ItemProperty -Name EnableErrorReporting -Value 0
$SqlFoundkey | Set-ItemProperty -Name CustomerFeedback -Value 0
}

##################################################
# Set HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Microsoft SQL Server\***\CustomerFeedback=0
# Set HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Microsoft SQL Server\***\EnableErrorReporting=0
# ** --> SQL Server Version (100,110,120,130,140,...)
##################################################
$WowKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server"
$FoundWowKeys = Get-ChildItem $WowKey | Where-Object -Property Property -eq 'EnableErrorReporting'
foreach ($SqlFoundWowKey in $FoundWowKeys)
{
$SqlFoundWowKey | Set-ItemProperty -Name EnableErrorReporting -Value 0
$SqlFoundWowKey | Set-ItemProperty -Name CustomerFeedback -Value 0
}

# https://blog.dbi-services.com/sql-server-tips-deactivate-the-customer-experience-improvement-program-ceip/ 
# https://docs.microsoft.com/en-us/sql/sql-server/sql-server-customer-feedback?view=sql-server-2017 