:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;;;;;;;;;;;;::::
::This is Jenkins Deployment script for DS Jobs Import and compile
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

TITLE DS DEPLOY BATCH SCRIPT

:: VARIABLES DECLARATION

SET JOBS=%1
SET DSIMPORT=\some\path\to\Clients\Classic\DSCMDIMPORT
SET DSCOMPILE=\some\path\to\Clients\Classic\DSCC
SET AUTH_PATH=\some\path\to\credentials
SET DEPLOYMENT_ENV=%2

IF %DEPLOYMENT_ENV%==IT (
  SET AUTHFILE=%AUTH_PATH%\ds_cred11v5_IT.txt
  SET PROJECT=FCEF
) ELSE IF %DEPLOYMENT_ENV%==QA (
	      SET AUTHFILE=%AUTH_PATH%\ds_cred11v5_qa.txt
              SET PROJECT=FCED
) ELSE IF %DEPLOYMENT_ENV%==PROD (
          SET AUTHFILE=%AUTH_PATH%\ds_cred11v5_prod.txt
	  SET AUTHFILE_DR=%AUTH_PATH%\ds_cred11v5_prod_dr.txt
          SET PROJECT=FCED
)

:: FINDS ALL THE JOBS FROM THE CHECKOUT FILE LIST
:: JB_STR REPLACES '/' WITH 'SPACE'
:: JB_PATH REPLACES '/' WITH '\'
:: JB_EXT FINDS THE JOB NAME WITH EXTENSION LIKE JOB.DSX WITHOUT PATH
:: JB_NM FINDS THE JOB NAME WITHOUT EXTENSION

ECHO Looking for DS files..               
ECHO.
FOR /F %%I IN (%JOBS%) DO (
  SET P=%%I
  SET JB_STR=!P:/= !
  SET JB_PATH=!P:/=\!

  FOR %%B IN (!JB_STR!) DO SET JOB_EXT=%%B

  SET JB_TXT=!JOB_EXT:.= !
  
  FOR %%B IN (!JB_TXT!) DO SET FILEEXT=%%B
  
  IF !FILEEXT!==dsx (
    FOR /F "tokens=1" %%P IN ("!JB_TXT!") DO SET JOB_NM=%%P

    :: JOB IMPORT
    ECHO.
    ECHO Importing Job !JOB_EXT! in FCNA-%DEPLOYMENT_ENV% 
    ECHO.
    ::ECHO %DSIMPORT% /AF=%AUTHFILE% %PROJECT% !JB_PATH! /NUA
    CALL %DSIMPORT% /AF=%AUTHFILE% %PROJECT% !JB_PATH! /NUA
    ECHO.
    
    IF %DEPLOYMENT_ENV%==PROD (
      :: JOB IMPORT IN DR
      ECHO.
      ECHO ===== !JOB_EXT! ===== FCNA-PROD-DR ===== 
      ECHO.
      ::ECHO %DSIMPORT% /AF=%AUTHFILE_DR% %PROJECT% !JB_PATH! /NUA
      CALL %DSIMPORT% /AF=%AUTHFILE_DR% %PROJECT% !JB_PATH! /NUA
      ECHO.
    )
  )
)

:: COMPILING IS SEPRATED FROM IMPORTING SO ALL DEPENDENT OBJECTS GETS IMPORTED FIRST
ECHO.
FOR /F %%I IN (%JOBS%) DO (
  SET P=%%I
  SET JB_STR=!P:/= !
  SET JB_PATH=!P:/=\!

  FOR %%B IN (!JB_STR!) DO SET JOB_EXT=%%B

  SET JB_TXT=!JOB_EXT:.= !
  
  FOR %%B IN (!JB_TXT!) DO SET FILEEXT=%%B
  
  IF !FILEEXT!==dsx (
    FOR /F "tokens=1" %%P IN ("!JB_TXT!") DO SET JOB_NM=%%P
    :: JOB COMPILE
    ECHO Compiling Job !JOB_EXT! in FCNA-%DEPLOYMENT_ENV% 
    ECHO.
    ::ECHO %DSCOMPILE% /AF %AUTHFILE% %PROJECT% /J !JOB_NM! /F
    CALL %DSCOMPILE% /AF %AUTHFILE% %PROJECT% /J !JOB_NM! /F
    ECHO.
    
    IF %DEPLOYMENT_ENV%==PROD (
      :: JOB IMPORT IN DR
      ECHO.
      ECHO ===== !JOB_EXT! ===== FCNA-PROD-DR ===== 
      :: JOB COMPILE IN DR
      ECHO.
      ::ECHO %DSCOMPILE% /AF %AUTHFILE_DR% %PROJECT% /J !JOB_NM! /F
      CALL %DSCOMPILE% /AF %AUTHFILE_DR% %PROJECT% /J !JOB_NM! /F
      ECHO.
    )
  )
)
PAUSE
