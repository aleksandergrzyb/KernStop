-- This file is for use with Corona Game Edition
-- 
-- The function getSpriteSheetData() returns a table suitable for importing using sprite.newSpriteSheetFromData()
-- 
-- This file is automatically generated with TexturePacker (http://texturepacker.com). Do not edit
-- $TexturePacker:SmartUpdate:937775aa50ceeb6dc76cb08f1bf85db5$
-- 
-- Usage example:
--        local sheetData = require "ThisFile.lua"
--        local data = sheetData.getSpriteSheetData()
--        local spriteSheet = sprite.newSpriteSheetFromData( "Untitled.png", data )
-- 
-- For more details, see http://developer.anscamobile.com/content/game-edition-sprite-sheets

local SpriteSheet = {}
SpriteSheet.getSpriteSheetData = function ()
	return {
		frames = {
			{
				name = "KernStop_1.png",
				spriteColorRect = { x = 0, y = 0, width = 122, height = 120 },
				textureRect = { x = 2, y = 2, width = 122, height = 120 },
				spriteSourceSize = { width = 122, height = 120 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_2.png",
				spriteColorRect = { x = 0, y = 0, width = 74, height = 82 },
				textureRect = { x = 170, y = 208, width = 74, height = 82 },
				spriteSourceSize = { width = 74, height = 82 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_3.png",
				spriteColorRect = { x = 0, y = 0, width = 66, height = 80 },
				textureRect = { x = 2, y = 252, width = 66, height = 80 },
				spriteSourceSize = { width = 66, height = 80 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_4.png",
				spriteColorRect = { x = 0, y = 0, width = 92, height = 80 },
				textureRect = { x = 126, y = 2, width = 92, height = 80 },
				spriteSourceSize = { width = 92, height = 80 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_5.png",
				spriteColorRect = { x = 0, y = 0, width = 86, height = 126 },
				textureRect = { x = 2, y = 124, width = 86, height = 126 },
				spriteSourceSize = { width = 86, height = 126 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_6.png",
				spriteColorRect = { x = 0, y = 0, width = 62, height = 102 },
				textureRect = { x = 2, y = 334, width = 62, height = 102 },
				spriteSourceSize = { width = 62, height = 102 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_7.png",
				spriteColorRect = { x = 0, y = 0, width = 78, height = 82 },
				textureRect = { x = 90, y = 208, width = 78, height = 82 },
				spriteSourceSize = { width = 78, height = 82 },
				spriteTrimmed = false,
				textureRotated = false
			},
			{
				name = "KernStop_8.png",
				spriteColorRect = { x = 0, y = 0, width = 88, height = 122 },
				textureRect = { x = 126, y = 84, width = 88, height = 122 },
				spriteSourceSize = { width = 88, height = 122 },
				spriteTrimmed = false,
				textureRotated = false
			},
		}
	}
end
return SpriteSheet
