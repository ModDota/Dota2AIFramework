# DotA 2 AI Competition Framework
The purpose of this framework is to provide a platform for AI competitions in DotA 2. It handles AI setup as well as wrapping the regular DotA 2 lua API to prevent AI scripts from accessing data or performing actions, to emulate the AI playing as a human player.

[Preview Video](https://www.youtube.com/watch?v=lKfmYQgBC8o)

### Goals of the framework:
+ Encourage the development of Lua AI for dota custom games.
+ Provide a starting point for developers that want AI in their games.
+ Eventually having decent AI for bot matches.

## Challenges
Different challenges will drive development in different directions. Therefore the AI framework provides different challenges for AI to deal with. The challenges currently supported are:
* Farm Optimisation - Multiple AI farm on separate parts of the map, that are set up identically. The goal for each AI is to use that part of the map as efficient as as possible, to farm as much gold as possible within a set duration.
* 1v1 Mid - Two AI face off 1v1 mid on identical heroes on the default dota map. The first AI to kill a tower or get two kills on the other AI wins.

Possible future challenges are:
* Three versus three mid and jungle.
* 1v1v1v1
* Last hit challenge

## Documentation
Framework AI only has access to a limited subset of the regular dota 2 lua AI. The available functions can be found here:
* [Global functions](https://github.com/ModDota/Dota2AIFramework/wiki/Global-AI-API)
* [Unit functions](https://github.com/ModDota/Dota2AIFramework/wiki/Unit-AI-API)
* [Ability functions](https://github.com/ModDota/Dota2AIFramework/wiki/Ability-AI-AI)
* AIEvents
* AIPlayerResource

## Using framework AI in a custom game
To use AI from this framework in a custom game, simply copy the entire scripts/vscripts/AI/ directory, then require AIManager in your gamemode. An existing AI can then be attached to an existing unit using:
```lua
AIManager:AttachAI( 'ai_name', unit )
```
This will load the AI named ai_name from AI/UserAI/ai_name and attach it to unit.
