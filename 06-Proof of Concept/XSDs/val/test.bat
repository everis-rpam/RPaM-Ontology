@echo off
call validate ..\xsd\XHE-1.0.xsd simpleExample.xml
call validate ..\xsd\XHE-1.0.xsd simpleExampleTyped.xml
call validate ..\xsd\XHE-1.0.xsd simpleExampleFailSyntax.xml
call validate ..\xsd\XHE-1.0.xsd simpleExampleFailModel.xml
call validate ..\xsd\XHE-1.0.xsd simpleExampleExtension.xml
