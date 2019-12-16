
#
# Syntax: validate schema-file xml-file

echo
echo "############################################################"
echo Validating $2
echo "############################################################"
echo ============== Phase 1: XSD schema validation ==============
sh w3cschema.sh $1 $2 2>&1 >output.txt
if [ $? -eq 0 ]
then echo No schema validation errors.
else cat output.txt; exit
fi
echo ============ Phase 2: XSLT code list validation ============
sh xslt.sh $2 XHE-DefaultDTQ-1.0.xsl /dev/null 2>output.txt
if [ $? -eq 0 ]
then echo No code list validation errors.
else cat output.txt
fi
