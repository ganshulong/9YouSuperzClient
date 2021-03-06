
cc.exports.gt = {
	-- AppID 房卡版100 阿牛哥定制版101 根据appid客户端显示界面有所不同
	app_id = 102,
	
	-- 微信ID
	wxId = "wxbd98d14ed37b0959",
	
	-- 热更地址
	defaultVersionUrl = "http://apps.xmsgl2017.com/szn/hotupdate/version.manifest",
	defaultManifestUrl = "http://apps.xmsgl2017.com/szn/hotupdate/project.manifest",

	defaultAppVerAnd = "1.0.0",
	defaultAppVerIos = "1.0.0",
	defaultAppUrlAnd = "http://apps.xmsgl2017.com/szn",
	defaultAppUrlIos = "http://apps.xmsgl2017.com/szn",

	-- 版本号
	version = "1.0.0",

	layersStack = {},
	eventsListener = {},
	playerData = {},

	-- 调试模式；AppStore 需更新为false
	debugMode = true,

	-- 本地版本直接跳过UpdateScene
	-- 测试服务器；AppStore 需更新为false
	localVersion = true,

	-- 是否要显示商城
	isShoppingShow = false,

	-- debug模式状态表
	debugInfo = {},

	fontNormal = "res/font/main.ttf",

	winSize = cc.Director:getInstance():getWinSize(),
	scheduler = cc.Director:getInstance():getScheduler(),
	targetPlatform = cc.Application:getInstance():getTargetPlatform(),

	-- 遮挡层透明度值
	MASK_LAYER_OPACITY			= 192,
}
gt.winCenter = cc.p(gt.winSize.width * 0.5, gt.winSize.height * 0.5)

local function isIOSPlatform()
	return (cc.PLATFORM_OS_IPHONE == gt.targetPlatform) or (cc.PLATFORM_OS_IPAD == gt.targetPlatform)
end
gt.isIOSPlatform = isIOSPlatform

local function isAndroidPlatform()
	return cc.PLATFORM_OS_ANDROID == gt.targetPlatform
end
gt.isAndroidPlatform = isAndroidPlatform

local function isIOSReview()
	if gt.isInReview == true and gt.isIOSPlatform() then
		return true
	end
	return false
end
gt.isIOSReview = isIOSReview

local function getDeviceId()
	if isIOSPlatform() then
		return "IOS"
	elseif isAndroidPlatform() then
		return "ANDROID"
	else
		return "OTHER"
	end
end
gt.getDeviceId = getDeviceId


-- start --
--------------------------------
-- @class function pushLayer
-- @description 用于界面有压栈层关系处理
-- @param layer 要压入的层
-- @param visible 当前层是否需要隐藏,默认是隐藏
-- @param zorder 压入层z值
-- @param rootLayer 压入层要加入到的父层
-- @return
-- end --
local function pushLayer(layer, visible, rootLayer, zorder)
	local layersStack = gt.layersStack
	local curLayer = layersStack[#layersStack]
	if curLayer and not visible then
		curLayer:setVisible(false)
	end

	-- 插入到栈顶
	table.insert(layersStack, layer)

	local zorder = zorder or 1
	if rootLayer then
		rootLayer:addChild(layer, zorder)
	else
		local runningScene = display.getRunningScene()
		if runningScene then
			runningScene:addChild(layer, zorder)
		end
	end
end
gt.pushLayer = pushLayer

-- start --
--------------------------------
-- @class function popLayer
-- @description 弹出当前层,从父节点移除,调用lua的destroy析构函数
-- @return
-- end --
local function popLayer()
	local layersStack = gt.layersStack
	if #layersStack > 0 then
		-- 从栈顶移除
		local layer = table.remove(layersStack, #layersStack)
		if layer then
			layer:removeFromParent(true)
			if layer.destroy then
				layer:destroy()
			end
		end

		-- 显示栈顶层
		local curLayer = layersStack[#layersStack]
		if curLayer then
			curLayer:setVisible(true)
		end
	end
end
gt.popLayer = popLayer

-- start --
--------------------------------
-- @class function registerEventListener
-- @description 注册事件回调
-- @param eventType 事件类型
-- @param target 实例
-- @param method 方法
-- @return
-- gt.registerEventListener(2, self, self.eventLis)
-- end --
local function registerEventListener(eventType, target, method)
	if not eventType or not target or not method then
		return
	end

	local eventsListener = gt.eventsListener
	local listeners = eventsListener[eventType]
	if not listeners then
		-- 首次添加eventType类型事件，新建消息存储列表
		listeners = {}
		eventsListener[eventType] = listeners
	else
		-- 检查重复添加
		for _, listener in ipairs(listeners) do
			if listener[1] == target and listener[2] == method then
				return
			end
		end
	end

	-- 加入到事件列表中
	local listener = {target, method}
	table.insert(listeners, listener)
end
gt.registerEventListener = registerEventListener

-- start --
--------------------------------
-- @class function dispatchEvent
-- @description 分发eventType事件
-- @param eventType 事件类型
-- @param ... 调用者传递的参数
-- @return
-- end --
local function dispatchEvent(eventType, ...)
	if not eventType then
		return
	end
	local listeners = gt.eventsListener[eventType] or {}
	for _, listener in ipairs(listeners) do
		-- 调用注册函数
		listener[2](listener[1], eventType, ...)
	end
end
gt.dispatchEvent = dispatchEvent

-- start --
--------------------------------
-- @class function removeTargetEventListenerByType
-- @description 移除target注册的事件
-- @param target self
-- @param eventType 消息类型
-- @return
-- end --
local function removeTargetEventListenerByType(target, eventType)
	if not target or not eventType then
		return
	end

	-- 移除target的注册的eventType类型事件
	local listeners = gt.eventsListener[eventType] or {}
	for i = #listeners,1,-1 do
		if listeners[i][1]==target then
			table.remove(listeners, i)
		end
	end
end
gt.removeTargetEventListenerByType = removeTargetEventListenerByType

-- start --
--------------------------------
-- @class function removeTargetAllEventListener
-- @description 移除target的注册的全部事件
-- @param target self
-- @return
-- end --
local function removeTargetAllEventListener(target)
	if not target then
		return
	end

	-- 移除target注册的全部事件
	for _, listeners in pairs(gt.eventsListener) do
		for i = #listeners,1,-1 do
			if listeners[i][1]==target then
				table.remove(listeners,i)
			end
		end
	end
end
gt.removeTargetAllEventListener = removeTargetAllEventListener

-- start --
--------------------------------
-- @class function removeAllEventListener
-- @description 移除全部消息注册回调
-- @return
-- end --
local function removeAllEventListener()
	gt.eventsListener = {}
end
gt.removeAllEventListener = removeAllEventListener

local function getTableLen(tables)
	local len = 0
	for k,v in pairs(tables) do
		len = len + 1
	end
	return len
end
gt.getTableLen = getTableLen

-- start --
--------------------------------
-- @class function
-- @description 加载csb文件,遍历查找Label和Button设置设定的语言文本
-- @param csbFileName 文件名称
-- @return 创建的节点
-- end --
local function createCSNode(csbFileName, isScale)
	local csbNode = cc.CSLoader:createNode(csbFileName)

	if isScale then
		csbNode:setScale(gt.scaleFactor)
	end

	-- 检查是否符合规定写法名称Label_xxx_key Txt_xxx_key
	local function setSpecifyLabelString(labelName, specifyLable)
		local subStrs = string.split(labelName, "_")
		local prefix = subStrs[1]
		local suffix = subStrs[#subStrs]
		if prefix == "Label" or prefix == "Txt" then
			local strKey = "LTKey_" .. suffix
			local ltString = gt.getLocationString(strKey)
			if ltString ~= strKey then
				-- 本地语言字符串存在设置文本
				specifyLable:setString(ltString)
			end
		end
	end

	-- 遍历节点
	local function travelLabelNode(rootNode)
		if not rootNode then
			return
		end

		local nodeName = rootNode:getName()
		setSpecifyLabelString(nodeName, rootNode)

		local children = rootNode:getChildren()
		if not children or #children == 0 then
			return
		end
		for _, childNode in ipairs(children) do
			travelLabelNode(childNode)
		end

		return
	end

	-- travelLabelNode(csbNode)

	return csbNode
end
gt.createCSNode = createCSNode

-- start --
--------------------------------
-- @class function createCSAnimation
-- @description 创建csb文件编辑的动画
-- @param csbFileName 文件路径名称
-- @return node, action 创建的节点和动画
-- end --
local function createCSAnimation(csbFileName, isScale)
	local csbNode = cc.CSLoader:createNode(csbFileName)
	local action = cc.CSLoader:createTimeline(csbFileName)
	csbNode:runAction(action)

	if isScale then
		csbNode:setScale(gt.scaleFactor)
	end

	return csbNode, action
end
gt.createCSAnimation = createCSAnimation

-- start --
--------------------------------
-- @class function seekNodeByName
-- @description 深度遍历查找节点
-- @param rootNode 根节点
-- @param nodeName 查找节点名称
-- @return 查找到的节点
-- end --
local function seekNodeByName(rootNode, name)
	if not rootNode or not name then
		return nil
	end

	if rootNode:getName() == name then
		return rootNode
	end

	local children = rootNode:getChildren()
	if not children or #children == 0 then
		return nil
	end
	for i, parentNode in ipairs(children) do
		local childNode = seekNodeByName(parentNode, name)
		if childNode then
			return childNode
		end
	end

	return nil
end
gt.seekNodeByName = seekNodeByName

local function showLoadingTips(tipsText)
	local runningScene = cc.Director:getInstance():getRunningScene()
	if runningScene then
		local loadingTips = runningScene:getChildByName("LoadingTips")
		if loadingTips then
			loadingTips:show(tipsText)
			return
		end
	end

	require("app/views/LoadingTips"):create(tipsText)
end
gt.showLoadingTips = showLoadingTips

local function removeLoadingTips()
	local runningScene = cc.Director:getInstance():getRunningScene()
	if runningScene then
		local loadingTips = runningScene:getChildByName("LoadingTips")
		if loadingTips then
			loadingTips:removeFromParent()
		end
	end
end
gt.removeLoadingTips = removeLoadingTips

-- start --
--------------------------------
-- @class function
-- @description 获取节点的世界坐标
-- @param node 节点
-- @return 世界坐标
-- end --
local function getWorldPos(node)
	if not node:getParent() then
		return cc.p(node:getPosition())
	end

	local nodeList = {}
	while node do
		-- 遍历节点,存储所有父节点
		table.insert(nodeList, node)
		node = node:getParent()
	end
	-- 移除Scene节点/世界坐标是基于Scene节点
	table.remove(nodeList, #nodeList)

	local worldPosition = cc.p(0, 0)
	for i, node in ipairs(nodeList) do
		local nodePosition = cc.p(node:getPosition())
		local idx = i + 1
		if idx <= #nodeList then
			-- 累加父节点锚点相对位置
			local parentNode = nodeList[idx]
			local parentSize = parentNode:getContentSize()
			local parentAnchor = parentNode:getAnchorPoint()
			local anchorPosition = cc.p(parentSize.width * parentAnchor.x, parentSize.height * parentAnchor.y)
			local subPosition = cc.pSub(nodePosition, anchorPosition)
			worldPosition = cc.pAdd(worldPosition, subPosition)
		else
			-- +最后父节点位置
			worldPosition = cc.pAdd(worldPosition, nodePosition)
		end
	end

	return worldPosition
end
gt.getWorldPos = getWorldPos

-- start --
--------------------------------
-- @class function
-- @description 创建ttfLabel
-- @param text 文本内容
-- @param fontSize 字体大小
-- @param font 字体名称
-- @return ttfLabel
-- end --
local function createTTFLabel(text, fontSize, font)
	text = text or ""
	font = font or gt.fontNormal
	fontSize = fontSize or 18

	local ttfConfig = {}
	ttfConfig.fontFilePath = font
	ttfConfig.fontSize = fontSize
	local ttfLabel = cc.Label:createWithTTF(ttfConfig, text, cc.TEXT_ALIGNMENT_LEFT)

	return ttfLabel
end
gt.createTTFLabel = createTTFLabel

local function setRadioTextSelectColor(checkRadio, isSelect)

	local lblDesc = checkRadio:getChildByName("Label_Desc")
	if lblDesc then
		if isSelect then
    		lblDesc:setTextColor(cc.c4b(147,37,0,255))
		else
    		lblDesc:setTextColor(cc.c4b(120,64,51,255))
		end
	end
end
gt.setRadioTextSelectColor =  setRadioTextSelectColor
-- start --
--------------------------------
-- @class function
-- @description 文本描边颜色outline
-- @param ttfLabel 要被设置描边的文本控件
-- @param color cc.c4b颜色
-- @param size int像素Size
-- @return
-- end --
local function setTTFLabelStroke(ttfLabel, color, size)
	if not ttfLabel then
		return
	end

	color = color or cc.c4b(27, 27, 27, 255)
	size = size or 1

	ttfLabel:enableOutline(color, size)
end
gt.setTTFLabelStroke = setTTFLabelStroke

-- start --
--------------------------------
-- @class function
-- @description 文本阴影
-- @param ttfLabel 要被设置阴影的文本控件
-- @param color cc.c4b颜色
-- @param offset Size偏移量cc.size(2, -2)
-- @return
-- end --
local function setTTFLabelShadow(ttfLabel, color, offset)
	if not ttfLabel then
		return
	end

	ttfLabel:enableShadow(color, offset, 0)
end
gt.setTTFLabelShadow = setTTFLabelShadow

-- start --
--------------------------------
-- @class function
-- @description 统一打印日志
-- @param msg 日志信息
-- @return
-- end --

local function log(msg, ...)
	if not gt.debugMode then
		return
	end
	-- local traceback = string.split(debug.traceback("", 2), "\n")
	-- print("print from:[" .. string.trim(traceback[3]) .. "]\n---------:" .. msg)
	msg = msg .. " "
	local args = {...}
	for i,v in ipairs(args) do
		msg = msg .. tostring(v) .. " "
	end
	local traceString = debug.traceback()
	if not gt.localVersion then
		release_print("[" .. debug.traceback() .. "]---------:" .. msg)
	end
	print(os.date("%Y-%m-%d %H:%M:%S") .. "------lua log:" .. msg)
	if cc.PLATFORM_OS_WINDOWS == gt.targetPlatform then
		local file = io.open("gameclient.log", "a")
		if file then
			file:write(msg.."\n")
			file:close()
		end
	end
end
gt.log = log

-- start --
--------------------------------
-- @class function
-- @description 用当前时间反置设置随机数种子
-- @return
-- end --
local function setRandomSeed()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
end
gt.setRandomSeed = setRandomSeed

-- start --
--------------------------------
-- @class function
-- @description 获取 [minVar, maxVar] 区间随机值
-- @param minVar 最小值
-- @param maxVar 最大值
-- @return 区间随机值
-- end --
local function getRangeRandom(minVar, maxVar)
	if minVar == maxVar then
		return minVar
	end

	return math.floor((math.random() * 1000000)) % (maxVar - minVar + 1) + minVar
end
gt.getRangeRandom = getRangeRandom

-- start --
--------------------------------
-- @class function
-- @description 重载cocos提供的弧度转换角度
-- @param radian 弧度
-- @return 角度
-- end --
function math.radian2angle(radian)
	return radian * 57.29577951
end

-- start --
--------------------------------
-- @class function
-- @description 重载cocos提供的角度转换弧度
-- @param angle 角度
-- @return 弧度
-- end --
function math.angle2radian(angle)
	return angle * 0.01745329252
end

function string.lastString(input, pattern)
	local idx = 1
	local saveIdx = nil
	while true do
		idx = string.find(input, pattern, idx)
		if idx == nil then
			break
		else
			saveIdx = idx
			idx = idx + 1
		end
	end

	return saveIdx
end

local function scaleNode(node)
	local duration = 0.2
	local scale1 = cc.ScaleTo:create(duration,1.04)
	local scale2 = cc.ScaleTo:create(duration,1.08)
	local scale3 = cc.ScaleTo:create(duration,1.04)
	local scale4 = cc.ScaleTo:create(duration,1)
	local delayTime1 = cc.DelayTime:create(0.8)
	local delayTime2 = cc.DelayTime:create(2.2)

	local sequenceAction = cc.Sequence:create(delayTime1,scale1,scale2,scale3,scale4,delayTime2)
	local repeatAction = cc.RepeatForever:create(sequenceAction)

	node:stopAllActions()
	node:runAction(repeatAction)
end
gt.scaleNode = scaleNode

-- start --
--------------------------------
-- @class function
-- @description 震动节点
-- @param node 震动节点
-- @param time 持续时间
-- @param originPos 节点原始位置,为了防止多次shake后节点位置错位
-- @return
-- end --
local function shakeNode(node, time, originPos, offset)
	local duration = 0.03
	if not offset then
		offset = 6
	end
	-- 一个震动耗时4个duration左,复位,右,复位
	-- 同时左右和上下震动
	local times = math.floor(time / (duration * 4))
	local moveLeft = cc.MoveBy:create(duration, cc.p(-offset, 0))
	local moveLReset = cc.MoveBy:create(duration, cc.p(offset, 0))
	local moveRight = cc.MoveBy:create(duration, cc.p(offset, 0))
	local moveRReset = cc.MoveBy:create(duration, cc.p(-offset, 0))
	local horSeq = cc.Sequence:create(moveLeft, moveLReset, moveRight, moveRReset)
	local moveUp = cc.MoveBy:create(duration, cc.p(0, offset))
	local moveUReset = cc.MoveBy:create(duration, cc.p(0, -offset))
	local moveDown = cc.MoveBy:create(duration, cc.p(0, -offset))
	local moveDReset = cc.MoveBy:create(duration, cc.p(0, offset))
	local verSeq = cc.Sequence:create(moveUp, moveUReset, moveDown, moveDReset)
	node:runAction(cc.Sequence:create(cc.Repeat:create(cc.Spawn:create(horSeq, verSeq), times), cc.CallFunc:create(function()
		node:setPosition(originPos)
	end)))
end
gt.shakeNode = shakeNode

-- start --
--------------------------------
-- @class function
-- @description 给BUTTON注册触屏事件
-- @param btn 注册按钮
-- @param listener 注册事件回调
-- @param sfx 音效文件路径(根目录是sound 不带后缀)
-- @param sex 性别1男，2女 如果声音分性别sfx直接传音效名就行
-- end --
local function addBtnPressedListener(btn, listener, sfx, sex)
	if not btn or not listener then
		gt.log("addBtnPressedListener btn=null!!!")
        return
	end
    if sfx ~= nil and string.len(sfx) > 0 then
        if(sex ~= nil) then
            if sex == 1 then
                sfx = "man/"..sfx
            elseif sex == 2 then
                sfx = "woman/"..sfx
            end
        end
    else
        sfx = gt.clickBtnAudio
    end
	btn:removeObjectAllHandlers()
	btn:addClickEventListener(function(sender)
		listener(sender)
        if sfx ~= nil and string.len(sfx) > 0 then
			gt.soundEngine:playEffect(sfx, false)
        end
	end)
end
gt.addBtnPressedListener = addBtnPressedListener

-- start --
--------------------------------
-- @class function
-- @description 创建shader
-- @param shaderName 名称
-- @return 创建的shaderState
-- end --
local function createShaderState(shaderName)
	local shaderProgram = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not shaderProgram then
		shaderProgram = cc.GLProgram:createWithFilenames(string.format("shader/%s.vsh", shaderName), string.format("shader/%s.fsh", shaderName))
		cc.GLProgramCache:getInstance():addGLProgram(shaderProgram, shaderName)
	end
	local shaderState = cc.GLProgramState:getOrCreateWithGLProgram(shaderProgram)

	return shaderState
end
gt.createShaderState = createShaderState

-- start --
--------------------------------
-- @class function
-- @description 弹出panel节点的动画效果
-- @param panel 要进行动画展示的节点
-- @return
-- end --
local function popupPanelAnimation(panel, cbFunc)
	assert(panel, "panel should not be nil.")
	local nowScale = panel:getScale()
	panel:setScale(0)
	local action = cc.ScaleTo:create(0.2, nowScale)
	action = cc.EaseBackOut:create(action)
	if not cbFunc then
		panel:runAction(action)
	else
		local callFunc = cc.CallFunc:create(cbFunc)
		local seqAction = cc.Sequence:create(action, callFunc)
		panel:runAction(seqAction)
	end
end
gt.popupPanelAnimation = popupPanelAnimation

-- start --
--------------------------------
-- @class function
-- @description 隐藏panel节点的动画效果，同时remove掉panel所在的父节点
-- @param panel 要进行动画隐藏效果的节点
-- @return
-- end --
local function removePanelAnimation(panel, isHide)
	assert(panel, "panel and parentMaskLayer should not be nil.")
	local action = cc.ScaleTo:create(0.2, 0)
	action = cc.EaseBackIn:create(action)
	local sequence = cc.Sequence:create(action, cc.CallFunc:create(function()
		if isHide then
			panel:setVisible(false)
		else
			panel:removeFromParent(true)
		end
	end))
	panel:runAction(sequence)
end
gt.removePanelAnimation = removePanelAnimation

-- start --
--------------------------------
-- @class function
-- @description 创建触摸屏蔽层
-- @param opacity 触摸屏的透明图
-- @return 屏蔽层
-- end --
local function createMaskLayer(opacity)
	if not opacity then
		-- 用默认透明度
		opacity = gt.MASK_LAYER_OPACITY
	end

	local maskLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, opacity), gt.winSize.width, gt.winSize.height)
	local function onTouchBegan(touch, event)
		return true
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = maskLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, maskLayer)

	return maskLayer
end
gt.createMaskLayer = createMaskLayer

-- start --
--------------------------------
-- @class function
-- @description 获取蒙版剪切精灵
-- @param sprFrameName 需要剪切图片的名称
-- @param isCircle 圆形或者矩形,默认是矩形
-- @return
-- end --
local function getMaskClipSprite(sprFrameName, isCircle, frameAdapt)
	local frameSpr = cc.Sprite:createWithSpriteFrameName(sprFrameName)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/icon/icon_mask.plist")
	local maskName = "rect_icon_mask.png"
	if isCircle then
		maskName = "circle_icon_mask.png"
	end
	local clipMaskSpr = cc.Sprite:createWithSpriteFrameName(maskName)
	local maskSize = clipMaskSpr:getContentSize()
	if frameAdapt then
		local frameSize = frameSpr:getContentSize()
		frameSpr:setScale(maskSize.width / frameSize.width)
	end
	frameSpr:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)
	clipMaskSpr:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)
	local renderTexture = cc.RenderTexture:create(maskSize.width, maskSize.height)
	clipMaskSpr:setBlendFunc(cc.blendFunc(gl.ZERO, gl.SRC_ALPHA))
	renderTexture:begin()
	frameSpr:visit()
	clipMaskSpr:visit()
	renderTexture:endToLua()
	local clipSpr = cc.Sprite:createWithTexture(renderTexture:getSprite():getTexture())
	clipSpr:setScaleY(-1)
	return clipSpr
end
gt.getMaskClipSprite = getMaskClipSprite

-- start --
--------------------------------
-- @class function
-- @description 创建扫光动态效果精灵
-- @param targetSpr 目标精灵
-- @param lightSpr 光柱精灵
-- @return 扫光动态效果精灵
-- end --
local function createTraverseLightSprite(targetSpr, lightSpr)
	targetSpr:removeFromParent()
	targetSpr:setPosition(0, 0)
	lightSpr:removeFromParent()
	lightSpr:setPosition(0, 0)
	local clippingNode = cc.ClippingNode:create()
	clippingNode:setStencil(targetSpr)
	clippingNode:setAlphaThreshold(0)

	local contentSize = targetSpr:getContentSize()
	clippingNode:addChild(targetSpr:clone())
	lightSpr:setPosition(-contentSize.width * 0.5,0)
	clippingNode:addChild(lightSpr)

	local moveAction = cc.MoveTo:create(1, cc.p(contentSize.width, 0))
	local delayTime = cc.DelayTime:create(1)
	local callFunc = cc.CallFunc:create(function(sender)
		sender:setPosition(-contentSize.width, 0)
	end)
	local sequenceAction = cc.Sequence:create(moveAction, delayTime, callFunc)
	local repeatAction = cc.RepeatForever:create(sequenceAction)
	lightSpr:runAction(repeatAction)

	return clippingNode
end
gt.createTraverseLightSprite = createTraverseLightSprite

-- start --
--------------------------------
-- @class function
-- @description 是否在屏幕上显示,遍历父节点有隐藏的情况
-- @return false:隐藏 true:显示
-- end --
local function isDisplayVisible(node)
	while node do
		if not node:isVisible() then
			return false
		end

		node = node:getParent()
	end

	return true
end
gt.isDisplayVisible = isDisplayVisible

-- start --
--------------------------------
-- @class function
-- @description 为避免货币位数过多导致显示不下，修改数字格式
-- @param num 要换算的数字，应为数字型
-- @return 1,000,000及以上的数字显示以K为单位换算后的字符串，1,000,000以下仍返回原值
-- end --
local function convertNumberForShort(num)
	assert(type(num) == "number", "the parameter should be numeric.")
	if num < 1000000 then
		return num
	else
		return math.floor(num * 0.001) .. "K"
	end
end
gt.convertNumberForShort = convertNumberForShort

-- start --
--------------------------------
-- @class function
-- @description 将时间以"HH:MM:SS"或者"MM:SS"的格式返回，不满两位填充0
-- @param deltaTime 要被转化的时间，以秒为单位；应为数字型，正负数皆可
-- @return 格式化的时间，字符串形式
-- end --
local function convertTimeSpanToString(deltaTime)
	assert(type(deltaTime) == "number", "the parameter should be numeric.")

	-- 那必须先四舍五入取整，否则会出现 -00：00：00 的情况
	deltaTime = math.round(deltaTime)

	local timeConversion = 60

	local timePrefix = ""
	if deltaTime < 0 then
		timePrefix = "-"
		deltaTime = -deltaTime
	end

	local hStr = math.floor(deltaTime / (timeConversion * timeConversion))
	deltaTime = deltaTime - timeConversion * timeConversion * hStr
	local mStr = math.floor(deltaTime / timeConversion)
	local sStr = math.floor(deltaTime - timeConversion * mStr)

	if hStr == 0 then
		return string.format("%s%02d:%02d", timePrefix, mStr, sStr)
	end

	local localStr =  string.format("%s%02d:%02d:%02d", timePrefix, hStr, mStr, sStr)
	return localStr
end
gt.convertTimeSpanToString = convertTimeSpanToString

-- start --
--------------------------------
-- @class function
-- @description 将本地时间以字符串的格式返回
-- @param deltaTime 目标时间与当前本地时间的差值。单位秒，正数为未来，负数为过去
-- @return 格式化的时间，字符串形式，AM/PM+HH:MM:SS
-- end --
local function getLocalTimeSpanStr(deltaTime)
	if not deltaTime then deltaTime = 0 end

	local targetTime = os.time() + deltaTime
	local timeTbl = os.date("*t", targetTime)

	if timeTbl.hour > 12 then
		return string.format("PM %02d:%02d:%02d", timeTbl.hour - 12, timeTbl.min, timeTbl.sec)
	else
		return string.format("AM %02d:%02d:%02d", timeTbl.hour, timeTbl.min, timeTbl.sec)
	end
end
gt.getLocalTimeSpanStr = getLocalTimeSpanStr

local function dump_value_(v)
	if type(v) == "string" then
		v = "\"" .. v .. "\""
	end
	return tostring(v)
end

function dump(value, desciption, nesting)
	if not gt.debugMode then
		return
	end
	if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))
	

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

if gt.localVersion then
	for i, line in ipairs(result) do
		gt.log(line)
	end
	    end
end
gt.dump = dump


local function checkName( str, limit )
	local retStr = ""
	local num = 0
	local lenInByte = #str
	local x = 1
	limit = limit or 8
	for i=1,lenInByte do
		i = x
	    local curByte = string.byte(str, x)
	    local byteCount = 1;
	    if curByte>0 and curByte<=127 then
	        byteCount = 1
	    elseif curByte>127 and curByte<240 then
	        byteCount = 3
	    elseif curByte>=240 and curByte<=247 then
	        byteCount = 4
	    end
	    local curStr = string.sub(str, i, i+byteCount-1)
	    retStr = retStr .. curStr
	    x = x + byteCount
	    if x > lenInByte then
	    	return retStr
	    end
	    num = num + 1
	    if num >= limit then
	    	return retStr
	    end
    end

    return retStr
end
gt.checkName = checkName

-- start --
--------------------------------
-- @class function
-- @description 文本描边颜色outline
-- @param ttfLabel 要被设置描边的文本控件
-- @param color cc.c4b颜色
-- @param size int像素Size
-- @return
-- end --
local function setTTFLabelStroke(ttfLabel, color, size)
	if not ttfLabel then
		return
	end

	color = color or cc.c4b(27, 27, 27, 255)
	size = size or 1

	ttfLabel:enableOutline(color, size)
end
gt.setTTFLabelStroke = setTTFLabelStroke


-- start --
--------------------------------
-- @class function floatText
-- @description 浮动文本
-- @param content 内容
-- @return
-- end --
gt.golbalZOrder = 10000
local function floatText(content)
	if not content or content == "" then
		return
	end

	local offsetY = 20
	local rootNode = cc.Node:create()
	rootNode:setPosition(cc.p(gt.winCenter.x, gt.winCenter.y - offsetY))

	local bg = cc.Scale9Sprite:create("res/images/otherImages/float_text_bg.png")
	local capInsets = cc.size(200, 5)
	local textWidth = bg:getContentSize().width - capInsets.width * 2
	bg:setScale9Enabled(true)
	bg:setCapInsets(cc.rect(capInsets.width, capInsets.height, bg:getContentSize().width - capInsets.width, bg:getContentSize().height - capInsets.height))
	bg:setAnchorPoint(cc.p(0.5, 0.5))
	bg:setGlobalZOrder(gt.golbalZOrder)
	gt.golbalZOrder = gt.golbalZOrder + 1
	rootNode:addChild(bg)

	local ttfConfig = {}
	ttfConfig.fontFilePath = gt.fontNormal
	ttfConfig.fontSize = 38
	local ttfLabel = cc.Label:createWithTTF(ttfConfig, content)
	ttfLabel:setGlobalZOrder(gt.golbalZOrder)
	gt.golbalZOrder = gt.golbalZOrder + 1
	ttfLabel:setTextColor(cc.YELLOW)
	ttfLabel:setAnchorPoint(cc.p(0.5, 0.5))
	rootNode:addChild(ttfLabel)

	if ttfLabel:getContentSize().width > textWidth then
		bg:setContentSize(cc.size(bg:getContentSize().width + (ttfLabel:getContentSize().width - textWidth), bg:getContentSize().height))
	end
	
	local action = cc.Sequence:create(
		cc.MoveBy:create(0.8, cc.p(0, 120)),
		cc.CallFunc:create(function()
			rootNode:removeFromParent(true)
		end)
	)
	cc.Director:getInstance():getRunningScene():addChild(rootNode)
	rootNode:runAction(action)

end
gt.floatText = floatText

local function UpLoadMsg(msg)
	local url = "http://report.9you.net/tao.php"
	local xhr = cc.XMLHttpRequest:new()
	local openid = gt.playerData.openid or 0
	local plat=0
	local uid =gt.playerData.uid or 0
	local nickname=gt.playerData.nickname
	if gt.isAndroidPlatform() then
		plat=1
	elseif gt.isIOSPlatform() then
		plat=2
	end
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("POST",url)
	local function onResp()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			local response = xhr.response
			print("Upload Success:" .. response)
		elseif xhr.readyState == 1 and xhr.status == 0 then
			print("Upload Faild")
		end
		xhr:unregisterScriptHandler()
	end
	xhr:registerScriptHandler(onResp)
	require("json")
	local data = {
		ResVersion = gt.resVersion,
		Time = os.time(),
		Msg = msg,
		AppID = gt.app_id,
		ID=uid,
		Nick=nickname
	}
	xhr:send(string.format("gameid=%d&datetime=%d&openid=%s&content=%s&user_agent=%d&type=1&desc=default",gt.app_id,os.time(),openid,json.encode(data),plat))
end
gt.UpLoadMsg=UpLoadMsg
