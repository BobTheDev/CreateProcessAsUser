#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=NP6.ico
#AutoIt3Wrapper_Outfile=bin\Release\ShutdownApplicationLoaderRun.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "Logs.au3"
Global $localAdminUsername = "Administrator"
Global $localAdminPassword = "Jvr963*14"
;Global $localAdminUsername = "Possupport"
;Global $localAdminPassword = "AUxp07pos"
Global $sDomain = @ComputerName

WriteLog("ShutdownApplicationLoaderRun v2024.1.1 started with user " & @UserName)
runCMD("ShutdownApplicationLoader.exe",False,False)
WriteLog("ShutdownApplicationLoaderRun v2024.1.1 finished with user " & @UserName)

Func runCMD($commandtorun, $wait = True, $logOutput = True)
	$cmd = $commandtorun

	WriteLog("runCMD: command [" & $cmd & "]")
	WriteLog("runCMD: runas [" & $localAdminUsername & "]," )

	Local $ret = 0
	;$pID = RunAs($nodeusername, $sDomain, $nodepassword, $RUN_LOGON_INHERIT, @ComSpec & " /c " & $cmd, @ScriptDir, @SW_HIDE)
	$pID = RunAs($localAdminUsername, $sDomain, $localAdminPassword, 0, @ComSpec & " /c " & $cmd, @ScriptDir, @SW_HIDE)

	WriteLog("Debug: RunAs, return=" & @error)

	If $wait = True Then
		ProcessWaitClose($pID)
		$ret = @extended
		Local $output = StdoutRead($pID)
		WriteLog("Debug: after run [" & $cmd & "], return=" & $ret)
		If $logOutput = True Then
			WriteLog("output: " & $output)
		EndIf
	Else
		$ret = 0
		WriteLog("Debug: run [" & $cmd & "], no waiting..." & $pID)
	EndIf

	Return $ret
EndFunc   ;==>runCMD

