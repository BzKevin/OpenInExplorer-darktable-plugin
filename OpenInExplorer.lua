--[[	OpenInExplorer plugin for darktable

  copyright (c) 2018  Kevin Ertel
  
  darktable is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  darktable is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with darktable.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[	Version 1.1.0     6/30/2018

This plugin adds the module "OpenInExplorer" to darktable's lighttable view

****Dependencies****
OS: Windows (tested)

****How to use****
Require this file from your luarc file, as with any other dt plug-in.
Select the photo(s) you wish to find in explorer and press "Go to Folder". 
A file explorer window will be opened for each selected file, and that file's folder location will be navigated to, and the file highlighted
]]

local dt = require "darktable"
local df = require "lib/dtutils.file"
require "official/yield"

--Detect OS and modify accordingly--	
local proper_install = 0
if dt.configuration.running_os == "windows" then
	proper_install = 1
end

-- FUNCTION --
local function OpenInExplorer() --Open in Explorer
	--Inits--
	if proper_install ~= 1 then
		return
	end
	local images = dt.gui.selection()
	local curr_image = ""
	
	for _,image in pairs(images) do 
		curr_image = image.path..'\\'..image.filename
		run_cmd = "explorer.exe /select, "..curr_image
		dt.print_log("OpenInExplorer run_cmd = "..run_cmd)
		resp = dt.control.execute(run_cmd)
	end
end

-- GUI --
OpenInExplorer_btn_run = dt.new_widget("button"){
	label = "Go to Folder",
	tooltip = "Opens selected image(s) location(s) in file explorer",
	clicked_callback = function() OpenInExplorer() end
	}
dt.register_lib( --OpenInExplorer
	"OpenInExplorer_Lib",	-- Module name
	"Open In Explorer",	-- name
	true,	-- expandable
	false,	-- resetable
	{[dt.gui.views.lighttable] = {"DT_UI_CONTAINER_PANEL_RIGHT_CENTER", 99}},	-- containers
	dt.new_widget("box"){
		orientation = "vertical",
		OpenInExplorer_btn_run
	}
)