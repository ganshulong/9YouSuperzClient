local gt = cc.exports.gt

local YvYinNode = class("YvYinNode", function()
	return cc.Node:create()
end)

YvYinNode.YINCANG= 0			--未显示
YvYinNode.YVYIN  = 1			--录音状态状态
YvYinNode.QVXIAO = 2			--抬起取消状态

YvYinNode.MAX_TIME  = 15		--最大录音时间
YvYinNode.SHOW_TIME = 5			--剩余多长时间显示

function YvYinNode:ctor()

	self.time = 0.0
	self.callback = nil
	self.state = YvYinNode.YINCANG
	self.maxTime = YvYinNode.MAX_TIME
	self.showTime = YvYinNode.SHOW_TIME

	local yvyin, action = gt.createCSAnimation("csd/Yvyin.csb")
	action:gotoFrameAndPlay(0,120,true)
	self.yvyin = yvyin
	self.yvyin:setAnchorPoint(0.5, 0.5)
	self:addChild(self.yvyin)
	
	self.qvxiao = cc.Sprite:createWithSpriteFrameName("image/yvyin/yuyin2.png")
	self.qvxiao:setAnchorPoint(0.5, 0.5)
	self.qvxiao:setPosition(0,0)
	self:addChild(self.qvxiao)

	self.daojishi = cc.Sprite:createWithSpriteFrameName("image/yvyin/cancel.png")
	self.daojishi:setAnchorPoint(0.5, 0.5)
	self:addChild(self.daojishi)

	local size = self.daojishi:getContentSize()

	self.daojishi_shuzi = {}
	for i=1, self.showTime do
		self.daojishi_shuzi[i] = cc.Sprite:createWithSpriteFrameName("image/yvyin/cd"..i..".png")
		self.daojishi_shuzi[i]:setVisible(false)
		self.daojishi_shuzi[i]:setAnchorPoint(0.5, 0.5)
		self.daojishi_shuzi[i]:setPosition(size.width/2, size.height/2)
		self.daojishi:addChild(self.daojishi_shuzi[i])
	end

	self.scheduleHandler = gt.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)

	self:setState(YvYinNode.YINCANG)
end

function YvYinNode:getState(  )
	return self.state
end

function YvYinNode:setMaxTime( time )
	self.maxTime = time
end

function YvYinNode:setShowTime( time )
	self.showTime = time
end

function YvYinNode:setCallback( _callback )
	self.callback = _callback
end

function YvYinNode:update( dt )
	if self.state == YvYinNode.YVYIN then
		self.time = self.time + dt

		if self.time >= self.maxTime then
			self:setState( YvYinNode.YINCANG )
			
			if self.callback ~= nil then
				self.callback(self.state)
			end
			
		else
			local temp = math.ceil(self.maxTime - self.time)
			if temp <= self.showTime then
				for i=1, #self.daojishi_shuzi do
					self.daojishi_shuzi[i]:setVisible(false)
					if i == temp then
						self.daojishi_shuzi[i]:setVisible(true)
					end
				end

				self.yvyin:setVisible(false)
				self.daojishi:setVisible(true)
			end
		end
	end
end

function YvYinNode:setState( state )
	self.state = state
	if self.state == YvYinNode.YVYIN then
		self.time = 0.0
		self.yvyin:setVisible(true)
		self.qvxiao:setVisible(false)
		self.daojishi:setVisible(false)
	elseif self.state == YvYinNode.QVXIAO then
		self.yvyin:setVisible(false)
		self.qvxiao:setVisible(true)
		self.daojishi:setVisible(false)
	else
		self.yvyin:setVisible(false)
		self.qvxiao:setVisible(false)
		self.daojishi:setVisible(false)
	end
end

return YvYinNode