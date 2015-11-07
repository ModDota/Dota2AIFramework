""""
Lua docs generator
Generates code documentation based on comments.

Comment syntax:

This script only considers comment blocks with a --[[[ opening and ]] ending, one comment block per function.
Data can be added to each documentation entry using the following keywords:
@func [name] - The name of the function (Required!).
@desc [text] - Adds a description of the function.
@modification [text] - Adds a description of the modification of this function.
@param {[type]} [name] [description] - Adds a single parameter description, multiple of these can be used.
	the type part is optionals for example '@param varA variable A' is valid and '@param {string} varB variable B' is too.
@return {[type]} [description] - Adds a description for the output of this function.
"""""

import sys
import re

def GenerateDocs( inputFileName, outputFileName ):
	inputString = ""

	with open( inputFileName, "r" ) as myFile:
		inputString = myFile.read()

	blockPattern = '--\[\[\[([\s\S]*?)\]\]'
	blocks = re.finditer( blockPattern, inputString )

	docList = []

	for block in blocks:
		blockString = block.group(1)

		functionDoc = {}

		funcIndices = FindAllIndices( '@func', blockString )
		descIndices = FindAllIndices( '@desc', blockString )
		paramIndices = FindAllIndices( '@param', blockString )
		modIndices = FindAllIndices( '@modification', blockString )
		returnIndices = FindAllIndices( '@return', blockString )

		allIndices = [len( blockString )]
		allIndices.extend( funcIndices )
		allIndices.extend( descIndices )
		allIndices.extend( paramIndices )
		allIndices.extend( modIndices )
		allIndices.extend( returnIndices )
		allIndices.sort()

		#Add function name
		funcStart = funcIndices[0]
		funcEnd = FindNextIndex( allIndices, funcStart )
		functionDoc['func'] = blockString[funcStart+6:funcEnd].strip().replace('( ','(').replace(' )',')')

		#Add description
		if len( descIndices ) > 0:
			descStart = descIndices[0]
			descEnd = FindNextIndex( allIndices, descStart )
			functionDoc['desc'] = blockString[descStart+6:descEnd].strip()

		#Add modification
		if len( descIndices ) > 0:
			modStart = modIndices[0]
			modEnd = FindNextIndex( allIndices, modStart )
			functionDoc['mod'] = blockString[modStart+14:modEnd].strip()

		#Add return
		if len( returnIndices ) > 0:
			returnStart = returnIndices[0]
			returnEnd = FindNextIndex( allIndices, returnStart )
			returnString = blockString[returnStart+8:returnEnd].strip()
			returnType = re.match('^{([\S]*?)} ', returnString)
			if returnType == None:
				functionDoc['return'] = {'desc' : returnString}
			else:
				functionDoc['return'] = {'desc' : returnString.replace(returnType.group(0),''), 'type' : returnType.group(1)}

		functionDoc['params'] = []
		for paramIndex in paramIndices:
			paramStart = paramIndex
			paramEnd = FindNextIndex( allIndices, paramStart )
			paramString = blockString[paramStart+7:paramEnd].strip()
			paramType = re.match('^{([\S]*?)} ', paramString)
			if paramType != None:
				paramString = paramString.replace(paramType.group(0),'')
			firstSpace = paramString.find(' ')
			paramName = paramString[0:firstSpace]
			paramDesc = paramString[firstSpace+1:]

			if paramType == None:
				functionDoc['params'].append({'name':paramName,'desc':paramDesc})
			else:
				functionDoc['params'].append({'name':paramName,'desc':paramDesc,'type':paramType.group(1)})

		docList.append( functionDoc )

	WriteDocs( docList, outputFileName )

def WriteDocs( docList, outputFileName ):
	docList.sort(key=lambda f: f['func'])

	lines = []

	lines.append( '## Table of contents\n' )
	for f in docList:
		funcName = f['func'][:f['func'].find('(')]
		refName = GetRefName( f['func'] )
		lines.append( '+ [' + funcName + '](#' + refName + ')\n' )

	lines.append( '\n# Function List\n\n' )

	for f in docList:
		lines.append( '## ' + f['func'].replace('(','(_').replace(')','_)').replace('__','') + '\n' )
		
		if 'desc' in f:
			lines.append( '#### Description\n' + f['desc'].replace('\n','<br>') + '\n' )

		if len(f['params']) > 0:
			lines.append('\n#### Parameters\n')
			for p in f['params']:
				if 'type' in p:
					lines.append( '+ **' + p['name'] + '** - ' + p['desc'] + '\n' )
				else:
					lines.append( '+ **' + p['name'] + '** [_' + p['type'] + '_] - ' + p['desc'] + '\n' )

		if 'mod' in f:
			lines.append( '\n#### Modification\n' + f['mod'].replace('-','\-').replace('\n','<br>') + '\n' )

		if 'return' in f:
			lines.append( '\n#### Return value\n' )
			if 'type' in f['return']:
				lines.append( '**Type:** '+ f['return']['type'] +'<br>\n' )
			lines.append( '**Description:** '+ f['return']['desc'].replace('\n','<br>') +'\n' )

		lines.append( '\n****\n\n' )

	with open( outputFileName, 'w' ) as fo:
		fo.writelines( lines )

def FindAllIndices( word, string ):
	list = []
	index = -1

	while True:
		index = string.find( word, index + 1 )

		if index == -1: break

		list.append( index )

	return list

def FindNextIndex( indices, oldIndex ):
	for index in indices:
		if index > oldIndex:
			return index
	return -1

def GetRefName( name ):
	newstring = name.replace(' ','-')
	newstring = newstring.replace('(','')
	newstring = newstring.replace(')','')
	newstring = newstring.replace(',','')
	newstring = newstring.replace(':','')
	return newstring.lower()

GenerateDocs( sys.argv[1], sys.argv[2] )