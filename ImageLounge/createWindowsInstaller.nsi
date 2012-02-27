; Script generated by the HM NIS Edit Script Wizard.
 !include "FileAssociation.nsh"
 !insertmacro RegisterExtension
 ${FileAssociation_VERBOSE} 4   # all verbosity
!include nsDialogs.nsh
!include LogicLib.nsh

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "nomacs - Image Lounge"
!define PRODUCT_VERSION "0.2.4 beta"
!define PRODUCT_WEB_SITE "http://www.nomacs.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\nomacs.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "nomacs.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "Readme/LICENSE.GPLv3"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

; custom page
Page custom fileAssociation fileAssociationFinished

; Finish page
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction
!define MUI_FINISHPAGE_RUN "$INSTDIR\nomacs.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

BrandingText "nomacs - Image Lounge"
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "nomacs-setup.exe"
InstallDir "$PROGRAMFILES\nomacs"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Var Dialog
Var Label
Var FullySupportedGroupBox
Var PartiallySupportedGroupBox

; Fully Supported
Var checkAllFully
Var checkAllFully_state
Var jpg
Var png
Var tif
Var bmp
Var pbm
Var pgm
Var xbm
Var xpm

Var jpg_state
Var png_state
Var tif_state
Var bmp_state
Var pbm_state
Var pgm_state
Var xbm_state
Var xpm_state

; Partially Supported
Var checkAllPartially
Var checkAllPartially_state
Var gif
Var nef
Var crw
Var cr2
Var arw

Var gif_state
Var nef_state
Var crw_state
Var cr2_state
Var arw_state


Function .onInit
	FindProcDLL::FindProc "nomacs.exe"
	IntCmp $R0 1 0 notRunning
		MessageBox MB_OK|MB_ICONEXCLAMATION "nomacs is running. Please close it first" /SD IDOK
		Abort
	notRunning:
FunctionEnd
	
Function fileAssociation
	nsDialogs::Create 1018
	Pop $Dialog
	
    ; FULLY SUPPORTED 	
	${NSD_CreateLabel} 0 0 100% 12u "Set File Associations:"
	Pop $Label

	${NSD_CreateCheckbox} 5u 35u 20% 10u "Check All"
	Pop $checkAllFully
	
	${NSD_CreateCheckbox} 10u 50u 15% 10u "jpg"
	Pop $jpg

	${NSD_CreateCheckbox} 10u 65u 15% 10u "png"
	Pop $png

	${NSD_CreateCheckbox} 10u 80u 15% 10u "tif"
	Pop $tif

	${NSD_CreateCheckbox} 10u 95u 15% 10u "bmp"
	Pop $bmp

	${NSD_CreateCheckbox} 70u 50u 15% 10u "pbm"
	Pop $pbm

	${NSD_CreateCheckbox} 70u 65u 15% 10u "pgm"
	Pop $pgm

	${NSD_CreateCheckbox} 70u 80u 15% 10u "xbm"
	Pop $xbm

	${NSD_CreateCheckbox} 70u 95u 15% 10u "xpm"
	Pop $xpm

	${NSD_CreateGroupBox} 0 18u 40% 120u "Fully supported:";
	Pop $FullySupportedGroupBox
	
	; PARTIAL SUPPORTED
	${NSD_CreateCheckbox} 155u 35u 20% 10u "Check All"
	Pop $checkAllPartially

	${NSD_CreateCheckbox} 160u 50u 15% 10u "gif"
	Pop $gif
	
	${NSD_CreateCheckbox} 160u 65u 15% 10u "nef"
	Pop $nef

	${NSD_CreateCheckbox} 160u 80u 15% 10u "crw"
	Pop $crw

	${NSD_CreateCheckbox} 220u 50u 15% 10u "cr2"
	Pop $cr2

	${NSD_CreateCheckbox} 220u 65u 15% 10u "arw"
	Pop $arw
	

	${NSD_CreateGroupBox} 150u 18u 40% 120u "Partially supported:";
	Pop $PartiallySupportedGroupBox
	
	${NSD_OnClick} $checkAllFully checkAllFully
	${NSD_OnClick} $checkAllPartially checkAllPartially
	
	nsDialogs::Show
FunctionEnd

Function fileAssociationFinished

	; DELETE REGISTRY ENTRIES FROM OLD VERSION
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "highlightColor"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "invertZoom"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "resetMatrix"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "saveThumb"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "thumbSize"
	
	; DELETE OLD DLLs
	Delete "$INSTDIR\opencv_imgproc220.dll"
	Delete "$INSTDIR\opencv_core220.dll"


	; RESET UPDATE FLAG
	WriteRegStr HKCU "Software\nomacs\Image Lounge\NetworkSettings\" "updateDialogShown" "false"
	
	; FULLY SUPPORTED
	${NSD_GetState} $jpg $jpg_state
	${NSD_GetState} $png $png_state
	${NSD_GetState} $tif $tif_state
	${NSD_GetState} $bmp $bmp_state
	${NSD_GetState} $pbm $pbm_state
	${NSD_GetState} $pgm $pgm_state
	${NSD_GetState} $xbm $xbm_state
	${NSD_GetState} $xpm $xpm_state

	${If} $jpg_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".jpg" "nomacs.file.jpg" "JPG Image"
		${registerExtension} "$INSTDIR\nomacs.exe" ".jpeg" "nomacs.file.jpg" "JPG Image"
	${EndIf}
	
	${If} $png_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".png" "nomacs.file.png" "PNG Image"
	${EndIf}

	${If} $tif_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".tif" "nomacs.file.tif"  "TIF Image"
		${registerExtension} "$INSTDIR\nomacs.exe" ".tiff" "nomacs.file.tif" "TIF Image"
	${EndIf}

	${If} $bmp_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".bmp" "nomacs.file.bmp" "BMP Image"
	${EndIf}

	${If} $pbm_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".pbm" "nomacs.file.pbm" "PBM Image"
	${EndIf}

	${If} $pgm_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".pgm" "nomacs.file.pgm" "PGM Image"
	${EndIf}

	${If} $xbm_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".xbm" "nomacs.file.xbm" "XBM Image"
	${EndIf}

	${If} $xpm_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".xpm" "nomacs.file.xpm" "XPM Image"
	${EndIf}
	
	; PARTIALLY SUPPORTED
	${NSD_GetState} $gif $gif_state
	${NSD_GetState} $nef $nef_state
	${NSD_GetState} $crw $crw_state
	${NSD_GetState} $cr2 $cr2_state
	${NSD_GetState} $arw $arw_state

	${If} $gif_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".gif" "nomacs.file.gif" "GIF Image"
	${EndIf}

	${If} $nef_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".nef" "nomacs.file.nef" "NEF Image"
	${EndIf}

	${If} $crw_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".crw" "nomacs.file.crw" "CRW Image"
	${EndIf}

	${If} $cr2_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".cr2" "nomacs.file.cr2" "CR2 Image"
	${EndIf}

	${If} $arw_state == ${BST_CHECKED}
		${registerExtension} "$INSTDIR\nomacs.exe" ".arw" "nomacs.file.arw" "ARW Image"
	${EndIf}
	
	Call RefreshShellIcons
	
FunctionEnd

Function checkAllFully
	${NSD_GetState} $checkAllFully $checkAllFully_State
	${If} $checkAllFully_state == ${BST_CHECKED}
		${NSD_SetState} $jpg ${BST_CHECKED}
		${NSD_SetState} $png ${BST_CHECKED}
		${NSD_SetState} $tif ${BST_CHECKED}
		${NSD_SetState} $bmp ${BST_CHECKED}
		${NSD_SetState} $pbm ${BST_CHECKED}
		${NSD_SetState} $pgm ${BST_CHECKED}
		${NSD_SetState} $xbm ${BST_CHECKED}
		${NSD_SetState} $xpm ${BST_CHECKED}
	${Else}
		${NSD_SetState} $jpg ${BST_UNCHECKED}
		${NSD_SetState} $png ${BST_UNCHECKED}
		${NSD_SetState} $tif ${BST_UNCHECKED}
		${NSD_SetState} $bmp ${BST_UNCHECKED}
		${NSD_SetState} $pbm ${BST_UNCHECKED}
		${NSD_SetState} $pgm ${BST_UNCHECKED}
		${NSD_SetState} $xbm ${BST_UNCHECKED}
		${NSD_SetState} $xpm ${BST_UNCHECKED}	
	${EndIf}
	

FunctionEnd


Function checkAllPartially
	${NSD_GetState} $checkAllPartially $checkAllPartially_State
	${If} $checkAllPartially_state == ${BST_CHECKED}
		${NSD_SetState} $gif ${BST_CHECKED}
		${NSD_SetState} $nef ${BST_CHECKED}
		${NSD_SetState} $crw ${BST_CHECKED}
		${NSD_SetState} $cr2 ${BST_CHECKED}
		${NSD_SetState} $arw ${BST_CHECKED}
	${Else}
		${NSD_SetState} $gif ${BST_UNCHECKED}
		${NSD_SetState} $nef ${BST_UNCHECKED}
		${NSD_SetState} $crw ${BST_UNCHECKED}
		${NSD_SetState} $cr2 ${BST_UNCHECKED}
		${NSD_SetState} $arw ${BST_UNCHECKED}
	${EndIf}
	

FunctionEnd

!define SHCNE_ASSOCCHANGED 0x08000000
!define SHCNF_IDLIST 0
 
Function RefreshShellIcons
  ; By jerome tremblay - april 2003
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd


Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "ReallyRelease\nomacs.exe"
  CreateDirectory "$SMPROGRAMS\nomacs - image lounge"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\nomacs - image lounge.lnk" "$INSTDIR\nomacs.exe"
  
  File "nomacs_*.qm"

  File "ReallyRelease\exiv2.dll"
  File "ReallyRelease\libexpat.dll"
  File "ReallyRelease\libraw.dll"
  File "ReallyRelease\msvcp100.dll"
  File "ReallyRelease\msvcr100.dll"
  File "ReallyRelease\opencv_core231.dll"
  File "ReallyRelease\opencv_imgproc231.dll"
  File "ReallyRelease\QtCore4.dll"
  File "ReallyRelease\QtGui4.dll"
  File "ReallyRelease\QtNetwork4.dll"
  File "ReallyRelease\zlib1.dll"
  
  File "Readme\COPYRIGHT"
  File "Readme\LICENSE.GPLv2"
  File "Readme\LICENSE.GPLv3"
  File "Readme\LICENSE.LGPL"
  File "Readme\LICENSE.OPENCV"
  SetOutPath "$INSTDIR\imageformats"
  File "ReallyRelease\imageformats\qgif4.dll"
  File "ReallyRelease\imageformats\qico4.dll"
  File "ReallyRelease\imageformats\qjpeg4.dll"
  File "ReallyRelease\imageformats\qmng4.dll"
  File "ReallyRelease\imageformats\qsvg4.dll"
  File "ReallyRelease\imageformats\qtiff4.dll"
SectionEnd

Function finishpageaction
	CreateShortCut "$DESKTOP\nomacs - image lounge.lnk" "$INSTDIR\nomacs.exe"
FunctionEnd
  

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\nomacs.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\nomacs.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
	FindProcDLL::FindProc "nomacs.exe"
	IntCmp $R0 1 0 notRunning
		MessageBox MB_OK|MB_ICONEXCLAMATION "nomacs is running. Please close it first" /SD IDOK
		Abort
	notRunning:
   
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
    Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR/imageformats\qtiff4.dll"
  Delete "$INSTDIR/imageformats\qsvg4.dll"
  Delete "$INSTDIR/imageformats\qmng4.dll"
  Delete "$INSTDIR/imageformats\qjpeg4.dll"
  Delete "$INSTDIR/imageformats\qico4.dll"
  Delete "$INSTDIR/imageformats\qgif4.dll"
  Delete "$INSTDIR\zlib1.dll"
  Delete "$INSTDIR\QtNetwork4.dll"
  Delete "$INSTDIR\QtGui4.dll"
  Delete "$INSTDIR\QtCore4.dll"
  Delete "$INSTDIR\opencv_imgproc220.dll"
  Delete "$INSTDIR\opencv_core220.dll"
  Delete "$INSTDIR\opencv_imgproc231.dll"
  Delete "$INSTDIR\opencv_core231.dll"
  Delete "$INSTDIR\msvcr100.dll"
  Delete "$INSTDIR\msvcp100.dll"
  Delete "$INSTDIR\libraw.dll"
  Delete "$INSTDIR\expatw.dll"
  Delete "$INSTDIR\expat.dll"
  Delete "$INSTDIR\libexpat.dll"
  Delete "$INSTDIR\exiv2.dll"
  Delete "$INSTDIR\nomacs.exe"
  Delete "$INSTDIR\*.qm"
  
  Delete "$INSTDIR\COPYRIGHT"
  Delete "$INSTDIR\LICENSE.GPLv2"
  Delete "$INSTDIR\LICENSE.GPLv3"
  Delete "$INSTDIR\LICENSE.LGPL"
  Delete "$INSTDIR\LICENSE.OPENCV"
  
  Delete "$SMPROGRAMS\nomacs - image lounge\Uninstall.lnk"
  Delete "$SMPROGRAMS\nomacs - image lounge\Website.lnk"
  Delete "$DESKTOP\nomacs - image lounge.lnk"
  Delete "$SMPROGRAMS\nomacs - image lounge\nomacs - image lounge.lnk"

  RMDir "$SMPROGRAMS\nomacs - image lounge"
  RMDir "$INSTDIR\imageformats"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
  ${UnRegisterExtension} ".jpg" "nomacs.file.jpg"
  ${UnRegisterExtension} ".jpeg" "nomacs.file.jpg"
  ${UnRegisterExtension} ".png" "nomacs.file.png"
  ${UnRegisterExtension} ".tif" "nomacs.file.tif" 
  ${UnRegisterExtension} ".tiff" "nomacs.file.tif"
  ${UnRegisterExtension} ".bmp" "nomacs.file.bmp"
  ${UnRegisterExtension} ".pbm" "nomacs.file.pbm"
  ${UnRegisterExtension} ".pgm" "nomacs.file.pgm"
  ${UnRegisterExtension} ".xbm" "nomacs.file.xbm"
  ${UnRegisterExtension} ".xpm" "nomacs.file.xpm"  

  ${UnRegisterExtension} ".gif" "nomacs.file.gif"
  ${UnRegisterExtension} ".nef" "nomacs.file.nef"  
  ${UnRegisterExtension} ".crw" "nomacs.file.crw"  
  ${UnRegisterExtension} ".cr2" "nomacs.file.cr2"  
  ${UnRegisterExtension} ".arw" "nomacs.file.arw"  



  
  SetAutoClose true
SectionEnd