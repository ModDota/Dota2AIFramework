import re

def generateAPI( filename, section ):
	
	fileString = ""

	with open( filename, "r" ) as myFile:
		fileString = myFile.read()

	print( '#'+section )

	#Find all comment blocks
	regex = '--\[\[\s*([^\n]+)\s*(((?!\n\s*\n)[\s\S])*)\s*Modification: (((?!\s*Parameters)[\s\S])*)\s*Parameters:\s*((?!]])[\s\S]+?)\s*\]\]'
	blocks = re.finditer( regex, fileString )

	for block in blocks:
		#Parse each block
		funcName = block.group( 1 )
		description = block.group( 2 )
		modification = block.group( 4 )
		params = block.group( 6 )

		print( '**'+funcName+'**<br>' )
		print( description+'<br><br>' )
		print( '**Modification:** ' + modification + '<br>' )
		if len( params ) > 1:
			print( '**Parameters:**' )
			print( params.replace( '\t', '' ).replace( '\n', '<br>' ).replace( '<br>+', '\n\t+' ).replace('<br>*', '\n*') )
		else:
			print( '**Parameters:** -' )
		print( '\n***\n' )
	

generateAPI( '../Game/scripts/vscripts/AI/AIWrapper.lua', 'Global functions' )
generateAPI( '../Game/scripts/vscripts/AI/UnitWrapper.lua', 'Unit functions' )
generateAPI( '../Game/scripts/vscripts/AI/AbilityWrapper.lua', 'Ability functions' )