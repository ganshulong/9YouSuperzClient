
local gt = cc.exports.gt

local LogoScene = class("LogoScene", function()
	return cc.Scene:create()
end)


function LogoScene:ctor()
	-- 注册节点事件
	self:registerScriptHandler(handler(self, self.onNodeEvent))
end

function LogoScene:onNodeEvent(eventName)
	if "enter" == eventName then
		local function changeScene()
			gt.isShowPoco = false
			if gt.localVersion == true then
				-- gt.isShowPoco = true
				gt.resVersion = "1.2.8.7"
				local loginScene = require("app/views/LoginScene"):create()
				cc.Director:getInstance():replaceScene(loginScene)
			else
				local updateScene = require("app/views/UpdateScene"):create()
				cc.Director:getInstance():replaceScene(updateScene)
			end
		end

		local delayAction = cc.FadeIn:create(1)
		local fadeOutAction = cc.FadeOut:create(1)
		local callFunc = cc.CallFunc:create(function(sender)
			-- 动画播放完毕之后再走这些内容
			changeScene()

			-- 30s启动Lua垃圾回收器
			gt.scheduler:scheduleScriptFunc(function(delta)
				local preMem = collectgarbage("count")
				-- 调用lua垃圾回收器
				for i = 1, 3 do
					collectgarbage("collect")
				end
				local curMem = collectgarbage("count")
				gt.log(string.format("Collect lua memory:[%d] cur cost memory:[%d]", (curMem - preMem), curMem))
				local luaMemLimit = 30720
				if curMem > luaMemLimit then
					gt.log("Lua memory limit exceeded!")
				end
			end, 60, false)
		end)
		local seqAction = cc.Sequence:create(delayAction, fadeOutAction, callFunc)
		local logoSpr = cc.Sprite:create("image/login/logo.jpg")
		logoSpr:runAction(seqAction)
		self:addChild( logoSpr )
		logoSpr:setPosition( display.cx, display.cy )

		--gt.soundEngine:playEffect("logo", false)
	end
end


return LogoScene


