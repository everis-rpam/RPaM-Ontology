@echo off
rem
rem Syntax: validate schema-file xml-file

echo.
echo ############################################################
echo Validating %2
echo ############################################################
@echo off
echo ============== Phase 1: XSD schema validation ==============
call w3cschema %1 %2 >output.txt
if %errorlevel% neq 0 goto :error
echo No schema validation errors.

echo ============ Phase 2: XSLT code list validation ============
call xslt %2 XHE-DefaultDTQ-1.0.xsl nul 2>output.txt

if %errorlevel% neq 0 goto :error
echo No code list validation errors.
goto :done

:error
type output.txt

:done
