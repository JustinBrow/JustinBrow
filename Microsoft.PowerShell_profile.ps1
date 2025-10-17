Add-Type -AssemblyName System.Windows.Forms

$ProgressPreference = 'SilentlyContinue'

$PSDefaultParameterValues=@{
   'Invoke-WebRequest:UserAgent'='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0'
}

[enum]::GetNames([Net.SecurityProtocolType]) | % {[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_}

if (-not (Get-PSDrive -Name HKU -ErrorAction SilentlyContinue))
{
  [void](New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS)
}

$TypeData = @{
   TypeName   = [System.Diagnostics.Process].ToString()
   MemberType = [System.Management.Automation.PSMemberTypes]::ScriptProperty
   MemberName = 'CommandLine'
   Value = {(Get-CimInstance Win32_Process -Filter "ProcessId = $($this.Id)").CommandLine}
}
Update-TypeData @TypeData
