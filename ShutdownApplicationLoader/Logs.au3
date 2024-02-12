#include-once
#include <FileConstants.au3>
#include <File.au3>
#include <Date.au3>

;Static Local $logDir = @ScriptDir & "\Logs\"
Static Local $logDir = @ScriptDir & "\"
Static Local $taskDir = ''
Static Local $idTask = ''

Static Local $logFilePre = "ShutdownApplicationLoaderRun_"

Func DelOldLogs($days = 7)
	WriteLog('Remove older than ' & $days & ' days logs in :' & $logDir)

	Local $hSearch = FileFindFirstFile($logDir & "\*.log")

	If $hSearch = -1 Then
		WriteLog("Error: No files/directories matched the search pattern : " & "$logDir" & "\*.*")
		Return False
	EndIf

	Local $sFileName = "", $iResult = 0

	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop

		$sFileName = $logDir & $sFileName
		Local $aCreateTime = FileGetTime($sFileName, $FT_CREATED, $FT_ARRAY)

		If @error Then
			WriteLog('Get file create time of : ' & $sFileName & ' failed.')
			ContinueLoop
		EndIf

		If _DateDiff('D', $aCreateTime[0] & '/' & $aCreateTime[1] & '/' & $aCreateTime[2] & ' ' & $aCreateTime[3] & ':' & $aCreateTime[4] & ':' & $aCreateTime[5], _NowCalc()) < $days Then
			ContinueLoop
		EndIf

		If FileDelete($sFileName) Then
			WriteLog('Delete old file : ' & $sFileName & ' SUCCEED.')
		Else
			WriteLog('Delete old file : ' & $sFileName & ' FAILED.')
		EndIf
	WEnd

	FileClose($hSearch)

EndFunc   ;==>DelOldLogs

Func SetLogDir($id)
	$logDir = @ScriptDir & "\" & $id & "\"
	$logFilePre = $logFilePre & $id & "__"
EndFunc   ;==>SetLogDir

Func WriteLog($sMsg)
	$date = @YEAR & @MON & @MDAY & '_' & @HOUR

	If DirGetSize($logDir) = -1 Then
		DirCreate($logDir)
	EndIf

	$sMsg = "PID:" & @AutoItPID & " : " & $sMsg

	_FileWriteLog($logDir & $logFilePre & $date & ".log", $sMsg)

	If StringLen($idTask) > 0 Then
		WriteTaskLog($sMsg)
	EndIf
EndFunc   ;==>WriteLog

Func unSetTaskID()
	WriteLog('Task ' & $idTask & ' finished.')
	$idTask = ''
	$taskDir = ''
EndFunc   ;==>unSetTaskID

Func SetTaskID($id)
	$taskDir = @ScriptDir & "\" & $id
	$idTask = $id
EndFunc   ;==>SetTaskID

Func WriteTaskLog($sMsg)
	$TaskLog = $idTask & ".log"

	If DirGetSize($taskDir) = -1 Then
		DirCreate($taskDir)
	EndIf

	_FileWriteLog($taskDir & "\" & $TaskLog, $sMsg)
EndFunc   ;==>WriteTaskLog
