
local gt = cc.exports.gt

local MainScene = class("MainScene", function()
	return cc.Scene:create()
end)

MainScene.ZOrder = {
	HISTORY_RECORD			= 5,
	CREATE_ROOM				= 6,
	JOIN_ROOM				= 7,
	GUILD    				= 7,
	MY_ROOM                 = 8,
	PLAYER_INFO_TIPS		= 9,
	SETTING                 = 10,
	PAY_RESULT              = 11,
	SERVICE                 = 12,
	SHARE                   = 13,
	REALNAME                = 14,
	PROXY_CODE              = 15,
    SIGN                    = 16,
    ANNOUNCEMENT            = 17,
    CAISHENDAO            	= 18,
}

function MainScene:ctor(isFromLogin)
	--清理纹理
	cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()

	-- 注册节点事件
	self:registerScriptHandler(handler(self, self.onNodeEvent))

	self.isFromLogin = isFromLogin or false

	local csbNode = cc.CSLoader:createNode("csd/MainScene.csb")
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(gt.winCenter)
	csbNode:setContentSize(gt.winSize)
    ccui.Helper:doLayout(csbNode)
	self:addChild(csbNode)
	self.csbNode = csbNode

	-- 注册消息回调
	gt.socketClient:registerMsgListener(gt.ROOM_CARD, self, self.onRcvRoomCard)
	gt.socketClient:registerMsgListener(gt.NOTICE, self, self.onRcvMarquee)
	gt.socketClient:registerMsgListener(gt.LOGIN_USERID, self, self.onRcvLoginUserId)
	gt.socketClient:registerMsgListener(gt.PAY_RESULT, self, self.onRcvPayResult)
    gt.socketClient:registerMsgListener(gt.OPEN_SIGN, self, self.onRcvOpenSign)
    gt.socketClient:registerMsgListener(gt.OPEN_DIAL, self, self.onRcvOpenDial)
    gt.socketClient:registerMsgListener(gt.SYSTEM_NOTICE, self, self.onRcvOpenAnnouncement)
	gt.socketClient:registerMsgListener(gt.BINDING_PROXY_CODE, self, self.onRcvBind)
	gt.socketClient:registerMsgListener(gt.IOS_PAY_ORDER, self, self.onRcvIAPResult)
	gt.socketClient:registerMsgListener(gt.APPLY_GUILD, self, self.onRcvApplyGuild)
    gt.socketClient:registerMsgListener(gt.GUILD_ROOM, self, self.onRcvGuildRoom)

	gt.registerEventListener(gt.EventType.GM_CHECK_HISTORY, self, self.gmCheckHistoryEvt)
    gt.registerEventListener(gt.EventType.EXIT_HALL, self, self.exitHallEvt)
    gt.registerEventListener(gt.EventType.NEED_UPDATE, self, self.needUpdateEvt)
	gt.registerEventListener(gt.EventType.CLOSE_ANNOUNCEMENTLAYER, self, self.exitAnnounce)
	gt.registerEventListener(gt.EventType.UPDATE_ROOMCARD, self, self.updateRoomCard)
	gt.socketClient:registerMsgListener(gt.WEBGAME_URL, self, self.onRcvWebgameUrl)
end

function MainScene:onRcvWebgameUrl(msgTbl)
	-- gt.log(msgTbl.full_url)
	gt.removeLoadingTips()

	-- local webgame = ccexp.WebView:create()
	-- -- webgame:setContentSize(gt.winSize) 
	-- webgame:setContentSize(400,600) 
	-- webgame:setPosition(gt.winCenter)
	-- webgame:setAnchorPoint(0.5,0.5)
	-- webgame:loadURL(msgTbl.full_url)
	-- self:addChild(webgame)
	if self:isOpenWebview() then
        local function resumeSoundCallBack(str)
            gt.soundEngine:playMusic("bgm1",true)
            gt.log("------------------test resumeSoundCallBack:"..str)
        end
		extension.openWebview(msgTbl.full_url,resumeSoundCallBack)
	else
		cc.Application:getInstance():openURL(msgTbl.full_url)
	end
end

function MainScene:isOpenWebview()
	local isOpen = false
	if gt.isAndroidPlatform() then
		local appVersion = extension.getAppVersion()
		if appVersion then
			local nAppVersion = string.gsub(tostring(appVersion),"%.","0")
			if tonumber(nAppVersion) >= 10009 then
				isOpen = true
			end
		end
	end
	return isOpen
end

function MainScene:initUI()

	local playerData = gt.playerData

    --点击特效
    local panelTouch = gt.seekNodeByName(self.csbNode, "Panel_Touch")
    panelTouch:removeFromParent()
    self:addChild(panelTouch, 10000)
	panelTouch:setSwallowTouches(false)
    --self.click = sp.SkeletonAnimation:create("image/main/djtx.json", "image/main/djtx.atlas")
    --panelTouch:addChild(self.click)
    --self.click:setVisible(false)
    panelTouch:addTouchEventListener(function(sender, eventType)
        if eventType == TOUCH_EVENT_BEGAN then
            local pos = sender:getTouchBeganPosition()
            gt.soundEngine:playEffect("click", false)
			--self.click:setVisible(true)
            --self.click:setAnimation(0, "animation", false)
            --self.click:setPosition(pos)
			local emitter = cc.ParticleSystemQuad:create("image/main/click.plist")
			emitter:setPosition(pos)
			sender:addChild(emitter)
			emitter:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.RemoveSelf:create()))
        end
    end)


    -- 公告弹窗
	if self.isFromLogin and not gt.isIOSReview() and cc.PLATFORM_OS_WINDOWS ~= gt.targetPlatform  then
        local id = cc.UserDefault:getInstance():getIntegerForKey("announcementID", 0)
        local msgToSend = {}
        msgToSend.cmd = gt.SYSTEM_NOTICE
        msgToSend.id = id
        gt.socketClient:sendMessage(msgToSend)

        if gt.playerData.phone == nil or gt.playerData.phone == "" or gt.playerData.phone == 0 then
        	local mobileBinding = require("app/views/MobileBinding"):create()
 	 		self:addChild(mobileBinding, 16)
        end

        local announcementLayer = require("app/views/Announcement"):create(false)
        self:addChild(announcementLayer, MainScene.ZOrder.ANNOUNCEMENT)
        -- 是否已经显示公告
        self.showAnnounce = true
    end
    local btnAnnounce = gt.seekNodeByName(self.csbNode, "Btn_Announce")
    gt.addBtnPressedListener(btnAnnounce, function()
        local announcementLayer = require("app/views/Announcement"):create(false)
        self:addChild(announcementLayer, MainScene.ZOrder.ANNOUNCEMENT)
    end)
	
	--代理链接按钮
	local btnAgency = gt.seekNodeByName(self.csbNode, "Btn_Agency")
    gt.addBtnPressedListener(btnAgency, function()
        gt.soundEngine:playEffect(gt.clickBtnAudio, false)
		cc.Application:getInstance():openURL("http://p2.szn.xmsgl2017.com/")
    end)
	
	--代理链接提示
	local Image_AgencyTip = gt.seekNodeByName(self.csbNode, "Image_AgencyTip")
	if self.isFromLogin then
		Image_AgencyTip:setVisible(true)
		local sequeceScale = cc.Sequence:create(cc.ScaleTo:create(1, 1.2), cc.ScaleTo:create(1, 1))
		Image_AgencyTip:runAction(cc.RepeatForever:create(sequeceScale))
		local sequece = cc.Sequence:create(cc.DelayTime:create(30), cc.RemoveSelf:create())
		Image_AgencyTip:runAction(sequece)
	else
		Image_AgencyTip:setVisible(false)
	end
	
	--分享下载按钮
	local btnShareDownload = gt.seekNodeByName(self.csbNode, "Btn_ShareDownload")
    gt.addBtnPressedListener(btnShareDownload, function()
		-- extension.shareToURL(extension.SHARE_TYPE_SESSION, "战斗牛", "激情牛牛/拼三张/三公/推筒子，全新模式，等你来玩！", gt.shareRoomWeb)
		-- cc.Application:getInstance():openURL(gt.shareWeb)
		gt.showLoadingTips("")
		gt.commonTool:sendHttpUrl(function(infoData)
			gt.removeLoadingTips()
				if gt.http_url_down then
					cc.Application:getInstance():openURL(gt.http_url_down)
				end
			end)
    end)
    
    -- 版本号
    local versionLabel = gt.seekNodeByName(self.csbNode, "Label_version")
	versionLabel:setString(gt.resVersion)

	-- 玩家信息
	local playerInfoNode = gt.seekNodeByName(self.csbNode, "Panel_HeadFrame")

	-- 昵称
	local nicknameLabel = gt.seekNodeByName(playerInfoNode, "Label_Nick")
	local nameString =  gt.interceptString(playerData.nickname)
	nicknameLabel:setString(gt.checkName(nameString, 8))
	-- 点击头像显示信息
	local headFrameBtn = gt.seekNodeByName(playerInfoNode, "Panel_HeadFrame")
	if headFrameBtn then
		headFrameBtn:addClickEventListener(function()
	        gt.soundEngine:playEffect(gt.clickBtnAudio, false)
			local playerInfoTips = require("app/views/PlayerInfoTips"):create(gt.playerData, 0)
			self:addChild(playerInfoTips, MainScene.ZOrder.PLAYER_INFO_TIPS)
		end)
	end

	-- 头像
	local headSpr = gt.seekNodeByName(playerInfoNode, "Spr_head")
--[[	headSpr:removeFromParent(true)
	headSpr:setPosition(cc.p(0,0))

	--头像遮罩
	local stencil = cc.Sprite:create("image/mainNew/clipping.png")
	local clipper = cc.ClippingNode:create()
	clipper:setStencil(stencil)
	clipper:setInverted(true)
	clipper:setAlphaThreshold(0)
	local x,y = headFrameBtn:getPosition()
	local headFrameSize = headFrameBtn:getContentSize()
	clipper:setPosition(cc.p(headFrameSize.width/2,headFrameSize.height/2))
	clipper:addChild(headSpr)
	headFrameBtn:addChild(clipper)--]]

	self.playerHeadMgr = require("app/PlayerHeadManager"):create("main")
	self.playerHeadMgr:attach(headSpr, playerData.uid, playerData.headURL)
	self:addChild(self.playerHeadMgr)

    local cardNumberLabel = gt.seekNodeByName(self.csbNode, "Label_CardNumber")
	cardNumberLabel:setString(playerData.roomCardsCount[1])

	-- id信息
	local useridLabel = gt.seekNodeByName(self.csbNode,"Label_ID")
	useridLabel:setString(string.format("ID %d", playerData.uid))

    local btnMall = gt.seekNodeByName(self.csbNode, "Btn_Mall")
    btnMall:setPressedActionEnabled(false)
    gt.addBtnPressedListener(btnMall, function()
        -- 购买钻石
        local buyCard
        if playerData.proxyCode == 0 then
            --未绑定邀请码
            buyCard = require("app/views/Store"):create(false)
        else
            --已绑定邀请码
            buyCard = require("app/views/Store"):create(true)
        end
        self:addChild(buyCard)
    end)

	local roomCardPanel = gt.seekNodeByName(self.csbNode, "Panel_Room_Card")
	if roomCardPanel then
		roomCardPanel:addClickEventListener(function(sender)

			-- 购买钻石
	        local buyCard
	        if playerData.proxyCode == 0 then
	            --未绑定邀请码
	            buyCard = require("app/views/Store"):create(false)
	        else
	            --已绑定邀请码
	            buyCard = require("app/views/Store"):create(true)
	        end
	        self:addChild(buyCard)
		end)
	end

    --邀请码
    local btn_invite = gt.seekNodeByName(self.csbNode, "Btn_Invitation_code")
    gt.addBtnPressedListener(btn_invite, function()
        local invite_code
        if playerData.proxyCode == 0 then
            --未绑定邀请码
            invite_code = require("app/views/Invite"):create(false)
            self:addChild(invite_code, MainScene.ZOrder.PROXY_CODE)
        else
            --已绑定邀请码
            invite_code = require("app/views/Invite"):create(true)
            self:addChild(invite_code, MainScene.ZOrder.PROXY_CODE)
        end
    end)

	-- 跑马灯
	local marqueeNode = gt.seekNodeByName(self.csbNode, "Node_marquee")
	local marqueeMsg = require("app/MarqueeMsg"):create()
	marqueeNode:addChild(marqueeMsg)
	self.marqueeMsg = marqueeMsg
	-- self.marqueeMsg:showMsg("【久游网】春节巨献！限时赛场2月15日起每天送出一部iPhone X！获奖者绑定的代理额外获得1000张房卡！成为代理实现百万收益，颠覆你的想象，还等什么马上咨询上级代理，实现财富梦想。")
	self.marqueeMsg:setVisible(false)
    if gt.marqueeMsgTemp then
		self.marqueeMsg:showMsg(gt.marqueeMsgTemp)
		gt.marqueeMsgTemp = nil
	end

    --实名认证
    local realNameBtn = gt.seekNodeByName(self.csbNode, "Btn_RealName")
    if realNameBtn then
	    realNameBtn:addClickEventListener(function()
			gt.soundEngine:playEffect(gt.clickBtnAudio, false)
	        local realNameLayer = require("app/views/RealName"):create()
	        self:addChild(realNameLayer, MainScene.ZOrder.REALNAME)
	    end)
	end
	
	--财神到
	local btnMammon = gt.seekNodeByName(self.csbNode, "Button_Mammon")
    gt.addBtnPressedListener(btnMammon, function()
		local announcementLayer = require("app/games/Godofwealth/PlaySceneGF"):create()
		self:addChild(announcementLayer, MainScene.ZOrder.CAISHENDAO)
    end)

	--传奇来了
	local btnLegendCome = gt.seekNodeByName(self.csbNode, "Button_LegendCome")
    gt.addBtnPressedListener(btnLegendCome, function()
		local msgToSend = {}
		msgToSend.cmd = gt.WEBGAME_URL
		msgToSend.user_id = gt.playerData.uid
		msgToSend.open_id = gt.playerData.openid
		gt.socketClient:sendMessage(msgToSend)
    end)
	
	local sz
	-- 创建房间
	local createRoomPanel = gt.seekNodeByName(self.csbNode, "Panel_CreateRoom")
	if createRoomPanel then
	createRoomPanel:addClickEventListener(function()
        gt.soundEngine:playEffect(gt.clickBtnAudio, false)
        
		local createRoomLayer = require("app/views/CreateRoom"):create()
		self:addChild(createRoomLayer, MainScene.ZOrder.CREATE_ROOM)
	end)
	end

   	self.sk1 = sp.SkeletonAnimation:create("image/main/hlssmheguan.json", "image/main/hlssmheguan.atlas")
	self.sk1:setAnimation(0, "animation", true)
	sz = createRoomPanel:getContentSize()
	self.sk1:setPosition(sz.width/2, 15)
   	self.sk1:setScale(0.38)
	createRoomPanel:getChildByName("node_Spine"):addChild(self.sk1)
	
	-- 加入房间
	local joinRoomPanel = gt.seekNodeByName(self.csbNode, "Panel_JoinRoom")
	if joinRoomPanel then
		joinRoomPanel:addClickEventListener(function()
	        gt.soundEngine:playEffect(gt.clickBtnAudio, false)
			local joinRoomLayer = require("app/views/JoinRoom"):create()
			self:addChild(joinRoomLayer, MainScene.ZOrder.JOIN_ROOM)
		end)
end
--    local imgJoinRoom = gt.seekNodeByName(joinRoomPanel, "Img_Join")
--    imgJoinRoom:setLocalZOrder(2)
    local imgBtn = gt.seekNodeByName(joinRoomPanel, "Img_Btn")
    if imgBtn then
	    imgBtn:setLocalZOrder(2)
	end

   self.sk2 = sp.SkeletonAnimation:create("image/main/sdb_npc_b.json", "image/main/sdb_npc_b.atlas")
	self.sk2:setAnimation(0, "animation", true)
	sz = joinRoomPanel:getContentSize()
	self.sk2:setPosition(sz.width/2-20, -365)
   self.sk2:setScale(0.42)
	joinRoomPanel:getChildByName("node_Spine"):addChild(self.sk2)
	

	-- 俱乐部
	local guildBtn = gt.seekNodeByName(self.csbNode, "Btn_Guild")
	if guildBtn then
		guildBtn:addClickEventListener(function()
			gt.soundEngine:playEffect(gt.clickBtnAudio, false)
			local function joinUnionFun()
				local guildNode = self:getChildByName("guildNode")
				if guildNode then
					guildNode:removeFromParent()
				end
				local guildLayer = require("app/views/Guild/Union"):create(0)
				self:addChild(guildLayer, MainScene.ZOrder.GUILD)
			end
			local guildLayer = require("app/views/Guild/Guild"):create(joinUnionFun)
			self:addChild(guildLayer, MainScene.ZOrder.GUILD)
		end)
	end
	
	-- 赛场
	local sportBtn = gt.seekNodeByName(self.csbNode, "Btn_Sport")
	local icon=gt.seekNodeByName(sportBtn,"Img_Iphone")
	icon:setVisible(false)
	if sportBtn then
		sportBtn:addClickEventListener(function()
			gt.soundEngine:playEffect(gt.clickBtnAudio, false)
			local UnionLayer = require("app/views/Guild/Union"):create()
			self:addChild(UnionLayer, MainScene.ZOrder.GUILD)
		end)


	end


	-- 签到
	local signBtn = gt.seekNodeByName(self.csbNode, "Btn_Sign")
	gt.addBtnPressedListener(signBtn, function()
        gt.showLoadingTips("")
		local msgToSend = {}
		msgToSend.cmd = gt.OPEN_SIGN
		msgToSend.user_id = gt.playerData.uid
		msgToSend.open_id = gt.playerData.openid
		gt.socketClient:sendMessage(msgToSend)
	end)

	-- 战绩
	local recordBtn = gt.seekNodeByName(self.csbNode, "Btn_Record")
    recordBtn:setPressedActionEnabled(false)
	gt.addBtnPressedListener(recordBtn, function()
		local historyRecord = require("app/views/HistoryRecord"):create(playerData.uid, 0, 0)
		self:addChild(historyRecord, MainScene.ZOrder.HISTORY_RECORD)
	end)
 
	-- 分享按钮
	local shareBtn = gt.seekNodeByName(self.csbNode,"Btn_Share")
    shareBtn:setPressedActionEnabled(false)
	gt.addBtnPressedListener(shareBtn,function()
		local description = "人人都爱玩的棋牌游戏，简单好玩，随时随地组局，亲们快快加入吧！猛戳下载！"
		local title = "Sbattle战斗牛"
		local shareSelect = require("app/views/ShareSelect"):create(description, title, gt.shareRoomWeb)
		self:addChild(shareSelect, MainScene.ZOrder.SHARE)
	end)

    local guildListBtn = gt.seekNodeByName(self.csbNode, "Btn_GuildList")
	local myRoomBtn = gt.seekNodeByName(self.csbNode, "Btn_MyRoom")
    local myRoomList = gt.seekNodeByName(self.csbNode, "ListView_MyRoom")
    local pTemplate = gt.seekNodeByName(myRoomList, "Panel_Template")
    self.imgTip = gt.seekNodeByName(self.csbNode, "Img_Tip")
    self.guildList = gt.seekNodeByName(self.csbNode, "ListView_Guild")
    self.pTemplate = gt.seekNodeByName(self.guildList, "Panel_Template")
    self.pTemplate:retain()
    self.guildList:removeAllChildren()
    --self.imgTip:setVisible(false)
    myRoomList:setVisible(false)
	-- 我的房间
	gt.addBtnPressedListener(myRoomBtn, function()
        myRoomBtn:setEnabled(false)
        guildListBtn:setEnabled(true)
        myRoomList:setVisible(true)
        self.guildList:setVisible(false)
        local myRoom = require("app/views/MyRoom"):create(myRoomList, pTemplate, self.imgTip)
	end)

    -- 俱乐部列表
    gt.addBtnPressedListener(guildListBtn, function()
        guildListBtn:setEnabled(false)
        myRoomBtn:setEnabled(true)
        myRoomList:setVisible(false)
        self.guildList:setVisible(true)
        self:queryGuildRoomList()
	end)
    self:queryGuildRoomList()

	-- 规则
	local ruleBtn = gt.seekNodeByName(self.csbNode, "Btn_Rule")
    ruleBtn:setZoomScale(0)
	gt.addBtnPressedListener(ruleBtn, function()
        local checkHistory = require("app/views/HelpLayer"):create()
		self:addChild(checkHistory, MainScene.ZOrder.HISTORY_RECORD)
	end)

	-- 客服按钮
	self.feedback = gt.seekNodeByName(self.csbNode, "Btn_Service")
    self.feedback:setZoomScale(0)
	gt.addBtnPressedListener(self.feedback, function()
		local service = require("app/views/Service"):create()
        self:addChild(service, MainScene.ZOrder.SERVICE)
	end)

	-- 设置
	local setBtn = gt.seekNodeByName(self.csbNode, "Btn_Setting")
    setBtn:setZoomScale(0)
	gt.addBtnPressedListener(setBtn, function()
		local settingPanel = require("app/views/Setting"):create(nil, 2)
		self:addChild(settingPanel, MainScene.ZOrder.SETTING)
	end)

    local pTouch = gt.seekNodeByName(self.csbNode, "Panel_Touch2")
    pTouch:setVisible(false)

    pTouch:addTouchEventListener(function (sender, touchType)
        if touchType == TOUCH_EVENT_ENDED then
            popMenu:setVisible(false)
            popActivity:setVisible(false)
            pTouch:setVisible(false)
        end
    end)

    --幸运转盘
	local dialBtn = gt.seekNodeByName(self.csbNode, "Btn_Dial")
    dialBtn:setZoomScale(0)
	gt.addBtnPressedListener(dialBtn, function()
        gt.showLoadingTips("")
        local msgToSend = {}
		msgToSend.cmd = gt.OPEN_DIAL
		-- msgToSend.cmd = gt.WEBGAME_URL
		msgToSend.user_id = gt.playerData.uid
		msgToSend.open_id = gt.playerData.openid
		gt.socketClient:sendMessage(msgToSend)
	end) 
	
	 --手机绑定
    local phoneBtn = gt.seekNodeByName(self.csbNode, "Btn_Phone")
	--dialBtn:setVisible(false)
    gt.addBtnPressedListener(phoneBtn, function()
		local mobileBinding = require("app/views/MobileBinding"):create()
		self:addChild(mobileBinding, 16)
    end)

	-- 苹果审核
	if gt.isIOSReview() then
		marqueeNode:setVisible(false)
		shareBtn:setVisible(false)
		realNameBtn:setVisible(false)
		dialBtn:setVisible(false)

		btn_invite:setPositionX(1030)
		ruleBtn:setPositionX(330)
		self.feedback:setPositionX(630)

	end
end

function MainScene:playSceneResetEvt()
	gt.showLoadingTips(gt.getLocationString("LTKey_0001"))
	--从后台回来先清除下之前缓存的消息
	gt.socketClient:clearMessage()
	self:reLogin()
end

function MainScene:exitAnnounce()
    self.showAnnounce = false
end

function MainScene:updateRoomCard()
    local cardNumberLabel = gt.seekNodeByName(self.csbNode, "Label_CardNumber")
	cardNumberLabel:setString(gt.playerData.roomCardsCount[1])
end

function MainScene:joinRoomFromUrl()
	-- 从url进入房间
	
	--testShare
	local roomId = extension.getURLRoomID()
	local subStrs = string.split(roomId, "_")
	-- gt.log("-----test-----joinRoomFromUrl:"..roomId)
	-- subStrs = string.split("g_231426_512847", "_")
	if 'g' == subStrs[1] or 'u' == subStrs[1] then
		local guild_id = tonumber(subStrs[2])
		local invite_id = tonumber(subStrs[3])
		
		if guild_id and invite_id then
			local msgToSend = {}
			msgToSend.cmd = gt.APPLY_GUILD
			msgToSend.user_id = gt.playerData.uid
			msgToSend.open_id = gt.playerData.openid
			msgToSend.icon = gt.playerData.headURL
			msgToSend.nick = gt.playerData.nickname
			msgToSend.guild_id = guild_id
			msgToSend.invite_id = invite_id
			if 'g' == subStrs[1] then
				msgToSend.is_union = 0
				self.joinType = 0
			else
				msgToSend.is_union = 1
				self.joinType = 1
			end
			gt.socketClient:sendMessage(msgToSend)
		end
		return
	end
	
	local roomID = tonumber(roomId)
	if roomID and roomID > 0 then
		local msgToSend = {}
		msgToSend.cmd = gt.JOIN_ROOM
		msgToSend.room_id = roomID
		msgToSend.app_id = gt.app_id
		msgToSend.user_id = gt.playerData.uid
		msgToSend.ver = gt.version
		msgToSend.dev_id = gt.getDeviceId()

		gt.socketClient:sendMessage(msgToSend)
		gt.socketClient:registerMsgListener(gt.JOIN_ROOM, self, self.onRcvJoinRoom)
		gt.showLoadingTips(gt.getLocationString("LTKey_0006"))
		
		return true
	end

	return false
end

function MainScene:onRcvApplyGuild(msgTbl)
	gt.removeLoadingTips()
	local typeStr = "俱乐部"
	if 1 == self.joinType then
		typeStr = "大联盟"
	end
	if msgTbl.code == 3 then
		require("app/views/CommonTips"):create("您所输入的"..typeStr.."ID不存在，请输入正确"..typeStr.."ID", 2)
	elseif msgTbl.code == 4 then
		require("app/views/CommonTips"):create("您所输入的是俱乐部ID，请去俱乐部入口进行操作", 2)
	elseif msgTbl.code == 2 then
		require("app/views/CommonTips"):create("您已经加入该"..typeStr.."", 2)
	else
		require("app/views/CommonTips"):create("申请已发送", 2)
	end
end

function MainScene:onNodeEvent(eventName)
	if "enter" == eventName then
		if not self:joinRoomFromUrl() then	-- 先检测，发现没有房间ID再启动定时器监视
			gt.soundEngine:playMusic("bg",true)

			self:initUI()
		    self:playEffect()
			
			if gt.localVersion == false then
				self.scheduleHandler = gt.scheduler:scheduleScriptFunc(handler(self, self.joinRoomFromUrl), 2, false)
			end

			-- 回俱乐部界面
			if gt.guildid then
				gt.guildid = nil
				local function joinUnionFun()
					local guildNode = self:getChildByName("guildNode")
					if guildNode then
						guildNode:removeFromParent()
					end
					local guildLayer = require("app/views/Guild/Union"):create(0)
					self:addChild(guildLayer, MainScene.ZOrder.GUILD)
				end
				local guildLayer = require("app/views/Guild/Guild"):create(joinUnionFun)
				self:addChild(guildLayer, MainScene.ZOrder.GUILD)
			end			
			-- 回大联盟界面
			if gt.unionid then
				gt.unionid = nil
				local guildLayer = require("app/views/Guild/Union"):create(0)
				self:addChild(guildLayer, MainScene.ZOrder.GUILD)
			end
		end
        self.scheduleAnnounce = gt.scheduler:scheduleScriptFunc(handler(self, self.updateAnnouncement), 300, false)
        self.scheduleQueryRoomHandler = gt.scheduler:scheduleScriptFunc(handler(self, self.queryGuildRoomList), 30, false)

        --清理纹理
	    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	    cc.Director:getInstance():getTextureCache():removeUnusedTextures()

	elseif "exit" == eventName then
		if self.scheduleHandler then
			gt.scheduler:unscheduleScriptEntry(self.scheduleHandler)
			self.scheduleHandler = nil
		end
        gt.scheduler:unscheduleScriptEntry(self.scheduleAnnounce)
		gt.scheduler:unscheduleScriptEntry(self.scheduleQueryRoomHandler)
		self.playerHeadMgr:close()
		self.pTemplate:release()

		gt.socketClient:unregisterMsgListener(gt.ROOM_CARD)
	    gt.socketClient:unregisterMsgListener(gt.NOTICE)
		gt.socketClient:unregisterMsgListener(gt.LOGIN_USERID)
		gt.socketClient:unregisterMsgListener(gt.JOIN_ROOM)
        gt.socketClient:unregisterMsgListener(gt.OPEN_SIGN)
        gt.socketClient:unregisterMsgListener(gt.OPEN_DIAL)
        gt.socketClient:unregisterMsgListener(gt.SYSTEM_NOTICE)
		gt.socketClient:unregisterMsgListener(gt.BINDING_PROXY_CODE)
		gt.socketClient:unregisterMsgListener(gt.GUILD_ROOM)
	    gt.removeTargetAllEventListener(self)
	end
end
				
function MainScene:updateAnnouncement(detal)
    local id = cc.UserDefault:getInstance():getIntegerForKey("announcementID", 0)
    local msgToSend = {}
    msgToSend.cmd = gt.SYSTEM_NOTICE
    msgToSend.id = id
    gt.socketClient:sendMessage(msgToSend)
end

-- 断线重连,使用userid重建连接
function MainScene:reLogin()
	gt.log("========重连登录")
	if gt.playerData.uid then
		local msgToSend = {}
		msgToSend.cmd = gt.LOGIN_USERID
		msgToSend.ver = gt.resVersion
		msgToSend.user_id = gt.playerData.uid
		msgToSend.open_id = gt.playerData.openid 
		gt.socketClient:sendMessage(msgToSend)
	end
end


-- start --
--------------------------------
-- @class function
-- @description 接收房卡信息
-- @param msgTbl 消息体
-- end --
function MainScene:onRcvRoomCard(msgTbl)
	local playerData = gt.playerData
	playerData.roomCardsCount = {msgTbl.card, msgTbl.card, msgTbl.card}

	-- 房卡信息
	local ttf_eight = gt.seekNodeByName(self.csbNode, "Label_CardNumber")
	if (gt.app_id == gt.GameAppID.CUSTOM_ANIUGE) then
		ttf_eight:setString(playerData.roomCardsCount[1] * 10)
	else
		ttf_eight:setString(playerData.roomCardsCount[1])
	end
end

-- start --
--------------------------------
-- @class function
-- @description 接收跑马灯消息
-- @param msgTbl 消息体
-- end --
function MainScene:onRcvMarquee(msgTbl)
	gt.marqueeMsgTemp = msgTbl.msg
	self.marqueeMsg:showMsg(msgTbl.msg)
end

function MainScene:onRcvLoginUserId(msgTbl)
	gt.removeLoadingTips()
	if msgTbl.code == 0 then
		local playerData = gt.playerData
		playerData.roomCardsCount = {msgTbl.card, msgTbl.card, msgTbl.card}
        playerData.game_count = msgTbl.game_count
--        playerData.reg_time = msgTbl.reg_time
		-- 房卡信息
		local ttf_eight = gt.seekNodeByName(self.csbNode, "Label_CardNumber")
		if (gt.app_id == gt.GameAppID.CUSTOM_ANIUGE) then
			ttf_eight:setString(playerData.roomCardsCount[1] * 10)
		else
			ttf_eight:setString(playerData.roomCardsCount[1])
		end
        local id = cc.UserDefault:getInstance():getIntegerForKey("announcementID", 0)
        local msgToSend = {}
        msgToSend.cmd = gt.SYSTEM_NOTICE
        msgToSend.id = id
        gt.socketClient:sendMessage(msgToSend)
	elseif msgTbl.code == 6 then
        gt.dispatchEvent(gt.EventType.NEED_UPDATE)
	else
        gt.dispatchEvent(gt.EventType.EXIT_HALL)
	end
end

function MainScene:onRcvPayResult(msgTbl)
	if msgTbl.code == 0 then
		local rechargeSucess = require("app/views/RechargeTips"):create(2, msgTbl.count, msgTbl.payMoney, msgTbl.chargeUser, msgTbl.genre)
		self:addChild(rechargeSucess,MainScene.ZOrder.PAY_RESULT)
		if msgTbl.productID and string.len(msgTbl.productID)>0 then
			extension.luaBridge.callStaticMethod('iospay','removerPurchaseFromQueue',
			{identifier = msgTbl.productID}
			)
		end
	elseif msgTbl.code==2 then
		--重复订单号
		require("app/views/NoticeTips"):create("提  示", "订单重复。", nil, nil, true)
		if msgTbl.productID and string.len(msgTbl.productID)>0 then
			extension.luaBridge.callStaticMethod('iospay','removerPurchaseFromQueue',
			{identifier = msgTbl.productID}
			)
		end
	else
		require("app/views/NoticeTips"):create(gt.getLocationString("LTKey_0007"), gt.getLocationString("LTKey_0060"), nil, nil, true)
	end
	gt.removeLoadingTips()
end

function MainScene:onRcvIAPResult(msgTbl)
	if msgTbl.code==0 then
		--extension.luaBridge.callStaticMethod('iospay','removerPurchaseFromQueue',
		--{ID = "xxx"}
		--)
	end
end

function MainScene:onRcvBind(msgTbl)
    if msgTbl.code == 0 then
		gt.playerData.proxyCode = msgTbl.proxy_code
        gt.dispatchEvent(gt.EventType.CLOSE_INVITE)
    end
end

function MainScene:onRcvOpenSign(msgTbl)
    gt.removeLoadingTips()
    if msgTbl.code == 0 then
        local signView = require("app/views/Sign"):create(msgTbl)
	    self:addChild(signView, MainScene.ZOrder.SIGN)
	else
        gt.dispatchEvent(gt.EventType.EXIT_HALL)
    end    
end

function MainScene:onRcvOpenDial(msgTbl)
    gt.removeLoadingTips()
    if msgTbl.code == 0 then
        local dialLottery = require("app/views/DialLottery"):create(msgTbl)
	    self:addChild(dialLottery, MainScene.ZOrder.SETTING)
	else
        gt.dispatchEvent(gt.EventType.EXIT_HALL)
    end    
end

function MainScene:onRcvOpenAnnouncement(msgTbl)
    cc.UserDefault:getInstance():setIntegerForKey("announcementID", msgTbl.id)
    cc.UserDefault:getInstance():setStringForKey("updataContent", msgTbl.msg)
    if self.showAnnounce then
        gt.dispatchEvent(gt.EventType.SHOW_UPDATA_ANNOUNCE)
    else
        local announcementLayer = require("app/views/Announcement"):create(msgTbl)
        self:addChild(announcementLayer, MainScene.ZOrder.ANNOUNCEMENT)
    end
end

function MainScene:needUpdateEvt()
	
	local function needUpdate()
		self:removeFromParent()

		-- 关闭socket连接时,赢停止当前定时器
		if gt.socketClient.scheduleHandler then
			gt.scheduler:unscheduleScriptEntry( gt.socketClient.scheduleHandler )
		end
		-- 关闭事件回调
		gt.removeTargetAllEventListener(gt.socketClient)

		gt.socketClient:close()

		cc.Director:getInstance():endToLua()
			-- os.exit(0)
			
		-- local LogoScene = require("app/views/LogoScene"):create()
		-- cc.Director:getInstance():replaceScene(LogoScene)
	end
	require("app/views/NoticeTips"):create(gt.LocationStrings.LTKey_0007, "版本过低，请更新客户端", needUpdate, nil, true)
end

function MainScene:exitHallEvt()
	-- 1:会话已过期，请重新登录
	-- 2:账号校验失败，请重新登录
	local function exitHall()
		self:removeFromParent()

		-- 关闭socket连接时,赢停止当前定时器
		if gt.socketClient.scheduleHandler then
			gt.scheduler:unscheduleScriptEntry( gt.socketClient.scheduleHandler )
		end
		-- 关闭事件回调
		gt.removeTargetAllEventListener(gt.socketClient)

		gt.socketClient:close()

		local loginScene = require("app/views/LoginScene"):create()
		cc.Director:getInstance():replaceScene(loginScene)
	end
	require("app/views/NoticeTips"):create(gt.LocationStrings.LTKey_0007, gt.LocationStrings.LTKey_0059, exitHall, nil, true)
end

function MainScene:gmCheckHistoryEvt(eventType, uid)
	local historyRecord = require("app/views/HistoryRecord"):create(uid)
	self:addChild(historyRecord, MainScene.ZOrder.HISTORY_RECORD)
end

function MainScene:onRcvJoinRoom(msgTbl)
	if msgTbl.code ~= 0 then
		-- 进入房间失败
		gt.removeLoadingTips()
		-- 1：未登录 2：服务器维护中 3：房卡不足 4：人数已满 5：房间不存在 6：中途不能加入
		local errorMsg = ""
		if msgTbl.code == 1 then
			errorMsg = gt.getLocationString("LTKey_0058")
		elseif msgTbl.code == 2 then
			errorMsg = gt.getLocationString("LTKey_0054")
		elseif msgTbl.code == 3 then
			errorMsg = gt.getLocationString("LTKey_0049")
		elseif msgTbl.code == 4 then
			errorMsg = gt.getLocationString("LTKey_0018")
		elseif msgTbl.code == 5 then
			errorMsg = gt.getLocationString("LTKey_0015")
        elseif msgTbl.code == 6 then
			errorMsg = gt.getLocationString("LTKey_0057")
		elseif msgTbl.code == 7 then
			errorMsg = gt.getLocationString("LTKey_0065")
		elseif msgTbl.code == 8 then
			errorMsg = gt.getLocationString("LTKey_0067")
		elseif msgTbl.code == 9 then
            -- 参数错误
			errorMsg = gt.getLocationString("LTKey_0069")
		end
		require("app/views/NoticeTips"):create(gt.getLocationString("LTKey_0007"), errorMsg, nil, nil, true)
	end
end

-- 显示俱乐部房间列表
function MainScene:queryGuildRoomList()
    local lastGuildId = cc.UserDefault:getInstance():getIntegerForKey("guildid"..gt.playerData.uid, 0)
    if lastGuildId > 0 then
        local msgToSend = {}
	    msgToSend.cmd = gt.GUILD_ROOM
	    msgToSend.user_id = gt.playerData.uid
	    msgToSend.open_id = gt.playerData.openid
        msgToSend.guild_id = lastGuildId
        msgToSend.include_match = 1
        gt.socketClient:sendMessage(msgToSend)
    end
end

function MainScene:onRcvGuildRoom(msgTbl)
    local function enterRoom(sender)
		local roomId = sender:getTag()
		local msgToSend = {}
		msgToSend.cmd = gt.JOIN_ROOM
		msgToSend.room_id = roomId
		msgToSend.app_id = gt.app_id
		msgToSend.user_id = gt.playerData.uid
		msgToSend.ver = gt.version
		msgToSend.dev_id = gt.getDeviceId()
		gt.socketClient:sendMessage(msgToSend)
	end
	self.guildList:removeAllChildren()
	if msgTbl.rooms and #msgTbl.rooms > 0 then
		self.imgTip:setVisible(false)
		for i, v in ipairs(msgTbl.rooms) do
			local pItem = self.pTemplate:clone()
			local par = json.decode(v.kwargs)
			-- 房间类型
			local roomType = gt.seekNodeByName(pItem, "Img_Type")
			if v.match == 0 then
				roomType:loadTexture("image/mainNew/flagGuild.png")
			else
				roomType:loadTexture("image/mainNew/flagMatch.png")
			end
			-- 房号
			pItem:getChildByName("Label_RoomId"):setString(tostring(v.id))
			-- 局数
			pItem:getChildByName("Label_Round"):setString(string.format("%d/%d局", v.round, par.rounds))
			-- 底分
			local fraction = "1/2"
			if par.game_id==gt.GameID.NIUYE or par.game_id == gt.GameID.NIUNIU or par.game_id == gt.GameID.TTZ then
				if par.score == 2 then
					fraction = "2/4"
				elseif par.score == 4 then
					fraction = "4/8"
				elseif par.score==3 then
					fraction="3/6"
				elseif par.score==5 then
					fraction="5/10"
				end
			elseif par.game_id == gt.GameID.SANGONG then
				fraction = "5/10/15/20"
				if par.score == 10 then
					fraction = "10/20/30/40"
				elseif par.score == 20 then
					fraction = "20/40/60/80"
				end
			elseif par.game_id == gt.GameID.QIONGHAI then
				fraction = tostring(par.qh_base_score)
			elseif par.game_id == gt.GameID.ZJH then
				fraction = tostring(par.zjh_base_score)
			end
			pItem:getChildByName("Label_Score"):setString(fraction)
			-- 人数
			pItem:getChildByName("Label_PlayerCount"):setString(string.format("%d/%d", v.player_count, par.max_chairs))
			-- 进入房间
			pItem:setTag(v.id)
			pItem:addClickEventListener(enterRoom)
			self.guildList:pushBackCustomItem(pItem)
			-- 邀请
			local btnInvite = gt.seekNodeByName(pItem, "Btn_InvitePlayer")
			gt.addBtnPressedListener(btnInvite, function(sender)
				gt.getRoomShareString(par, v.player_count, v.id, msgTbl.guild_id , v.match)
			end)
		end
	else
		self.imgTip:setVisible(true)
	end
end

-- 播放特效
function MainScene:playEffect()
    local actionTimeLine_1 = cc.CSLoader:createTimeline("csd/MainScene.csb")
    self.csbNode:runAction(actionTimeLine_1)
    actionTimeLine_1:play("animation_woman",true)

    local csbFile_1 = "csd/texiao/Node1.csb"
    local actionTimeLine_2 = cc.CSLoader:createTimeline(csbFile_1)
    self.csbNode:runAction(actionTimeLine_2)
    actionTimeLine_2:play("animation_main", true)

    local csbFile_2 = "csd/texiao/julebudonghua.csb"
    local actionTimeLine_3 = cc.CSLoader:createTimeline(csbFile_2)
    self.csbNode:runAction(actionTimeLine_3)
    actionTimeLine_3:play("animation_frame", true)

    local csbFile_3 = "csd/texiao/xianshibisaidonghua.csb"
    local actionTimeLine_4 = cc.CSLoader:createTimeline(csbFile_3)
    self.csbNode:runAction(actionTimeLine_4)
    actionTimeLine_4:play("animation_match", true)
	
	local csbFile_mammon = "games/Godofwealth/csb/texiao/MammonWinning.csb"
    local actionTimeLine_mammon = cc.CSLoader:createTimeline(csbFile_mammon)
    self.csbNode:runAction(actionTimeLine_mammon)
    actionTimeLine_mammon:play("animation_Winning", true)
	
	local csbFile_xccsd = "games/Godofwealth/csb/texiao/xccsd.csb"
    local actionTimeLine_xccsd = cc.CSLoader:createTimeline(csbFile_xccsd)
    self.csbNode:runAction(actionTimeLine_xccsd)
    actionTimeLine_xccsd:play("animation0", true)
	
	--灯笼
	local Image_Lantern = gt.seekNodeByName(self.csbNode, "Image_Lantern")
	local rotateLeft = cc.EaseSineInOut:create(cc.RotateTo:create(2, 30))
	local rotateRight = cc.EaseSineInOut:create(cc.RotateTo:create(2, 0))
	local sequeceRotate = cc.Sequence:create(rotateLeft, rotateRight)
	Image_Lantern:runAction(cc.RepeatForever:create(sequeceRotate))
	
	--中国结
	local Image_ChineseKnot = gt.seekNodeByName(self.csbNode, "Image_ChineseKnot")
	rotateLeft = cc.EaseSineInOut:create(cc.RotateTo:create(2, 15))
	rotateRight = cc.EaseSineInOut:create(cc.RotateTo:create(2, -15))
	sequeceRotate = cc.Sequence:create(rotateLeft, rotateRight)
	Image_ChineseKnot:runAction(cc.RepeatForever:create(sequeceRotate))
	
	--鞭炮
	local Image_widgetFirecracker = gt.seekNodeByName(self.csbNode, "Image_widgetFirecracker")
	rotateLeft = cc.EaseSineInOut:create(cc.RotateTo:create(2, -30))
	rotateRight = cc.EaseSineInOut:create(cc.RotateTo:create(2, 20))
	sequeceRotate = cc.Sequence:create(rotateLeft, rotateRight)
	Image_widgetFirecracker:runAction(cc.RepeatForever:create(sequeceRotate))
	
	--烟花彩带
	local csbFile_aniBg = "csd/texiao/chunjiebigbang.csb"
    local actionTimeLine_aniBg = cc.CSLoader:createTimeline(csbFile_aniBg)
    self.csbNode:runAction(actionTimeLine_aniBg)
    actionTimeLine_aniBg:play("animation0", true)
	
	--传奇来了
	local csbFile_LegendCome = "csd/texiao/chuanqilaile.csb"
    local actionTimeLine_LegendCome = cc.CSLoader:createTimeline(csbFile_LegendCome)
    self.csbNode:runAction(actionTimeLine_LegendCome)
    actionTimeLine_LegendCome:play("animation0", true)
end

return MainScene


