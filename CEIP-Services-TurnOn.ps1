# SQL Server services current status #
Get-DbaService -Type SSAS,SSRS,SSIS,Engine,Agent,Browser,FullText
Get-Service |? name -Like "*TELEMETRY*" | select -property name,starttype,status

##################################################
#  Enabling CEIP Key Register #
##################################################
# Set to 1 the CustomerFeedback and EnableErrorReporting keys in the register HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\***\CustomerFeedback=1
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\***\EnableErrorReporting=1
# *** --> SQL Server Version (100,110,120,130,140,...)
# For SQL Server
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSSQL**.<instance>\CPE\CustomerFeedback=1
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSSQL**.<instance>\CPE\EnableErrorReporting=1
# For SQL Server Analysis Server (SSAS)
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSAS**.<instance>\CPE\CustomerFeedback=1
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSAS**.<instance>\CPE\EnableErrorReporting=1
# For SQL Server Reporting Server (SSRS)
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSRS**.<instance>\CPE\CustomerFeedback=1
# Set HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\MSRS**.<instance>\CPE\EnableErrorReporting=1
# ** --> SQL Server Version (100,110,120,130,140,...)
##################################################
$Key = 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server'
$FoundKeys = Get-ChildItem $Key -Recurse | Where-Object -Property Property -eq 'EnableErrorReporting'
foreach ($Sqlfoundkey in $FoundKeys)
{
$SqlFoundkey | Set-ItemProperty -Name EnableErrorReporting -Value 1
$SqlFoundkey | Set-ItemProperty -Name CustomerFeedback -Value 1
}

##################################################
# Set HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Microsoft SQL Server\***\CustomerFeedback=1
# Set HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Microsoft SQL Server\***\EnableErrorReporting=1
# *** --> SQL Server Version (100,110,120,130,140,...)
##################################################
$WowKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server"
$FoundWowKeys = Get-ChildItem $WowKey | Where-Object -Property Property -eq 'EnableErrorReporting'
foreach ($SqlFoundWowKey in $FoundWowKeys)
{
$SqlFoundWowKey | Set-ItemProperty -Name EnableErrorReporting -Value 1
$SqlFoundWowKey | Set-ItemProperty -Name CustomerFeedback -Value 1
}

# Enabling SQL Server CEIP services#
Get-Service -name "*TELEMETRY*" | Set-Service -StartupType Automatic -passthru | Start-Service 

# SQL Server services current status #
Get-DbaService -Type SSAS,SSRS,SSIS,Engine,Agent,Browser,FullText
Get-Service |? name -Like "*TELEMETRY*" | select -property name,starttype,status

# https://blog.dbi-services.com/sql-server-tips-deactivate-the-customer-experience-improvement-program-ceip/ 
# https://docs.microsoft.com/en-us/sql/sql-server/sql-server-customer-feedback?view=sql-server-2017 
