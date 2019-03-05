-- 赛场配置


local sportConfig = {
	{ displayIndex=1, tid = 1, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "每日20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="mask.png",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 2, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "琼海抢庄 8倍 特殊牌型全开放", mode_desc = "每日20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="mask.png",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 3, title = "限时大奖比赛", desc = "", rule_desc = "牛元帅  5/10分  特殊牌型全开放", mode_desc = "久游年会", icon = "",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n" ..
		"2.比赛报名后若玩家进入其他房间进行游戏则视为弃权，入场券不会退还。\n" ..
		"3.随时可以退赛，退赛会退还入场券"
	},
	{ displayIndex=1, tid = 4, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "战斗牛-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "每日20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="mask.png",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=2, tid = 5, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "满30人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.比赛报名后若玩家进入其他房间进行游戏则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励5张房卡\n"..
		"   第二名奖励4张房卡\n"..
		"   第三名奖励3张房卡\n"..
		"   第四名奖励2张房卡\n"..
		"   第五名奖励1张房卡\n"
	},
	{ displayIndex=2, tid = 6, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "战斗牛-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "满30人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.比赛报名后若玩家进入其他房间进行游戏则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励5张房卡\n"..
		"   第二名奖励4张房卡\n"..
		"   第三名奖励3张房卡\n"..
		"   第四名奖励2张房卡\n"..
		"   第五名奖励1张房卡\n"
	},
	{ displayIndex=2, tid = 7, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "琼海抢庄 8倍 特殊牌型全开放", mode_desc = "满30人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.比赛报名后若玩家进入其他房间进行游戏则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励5张房卡\n"..
		"   第二名奖励4张房卡\n"..
		"   第三名奖励3张房卡\n"..
		"   第四名奖励2张房卡\n"..
		"   第五名奖励1张房卡\n"
	},
	{ displayIndex=2, tid = 8, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "满100人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励10张房卡\n"..
		"   第二名奖励8张房卡\n"..
		"   第三名奖励6张房卡\n"..
		"   第四名奖励5张房卡\n"..
		"   第五名奖励4张房卡\n"
	},
	{ displayIndex=2, tid = 9, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "战斗牛-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "满100人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励10张房卡\n"..
		"   第二名奖励8张房卡\n"..
		"   第三名奖励6张房卡\n"..
		"   第四名奖励5张房卡\n"..
		"   第五名奖励4张房卡\n"
	},
	{ displayIndex=2, tid = 10, title = "限时常规比赛", desc = "前5名奖励房卡", rule_desc = "琼海抢庄 8倍 特殊牌型全开放", mode_desc = "满100人开始比赛", icon = "roomcard.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前5名可获得奖励：\n"..
		"   第一名奖励10张房卡\n"..
		"   第二名奖励8张房卡\n"..
		"   第三名奖励6张房卡\n"..
		"   第四名奖励5张房卡\n"..
		"   第五名奖励4张房卡\n"
	},
	{ displayIndex=1, tid = 11, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "2018.2.15 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 12, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "琼海抢庄 8倍 特殊牌型全开放", mode_desc = "2018.2.16 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 13, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "战斗牛-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "2018.2.17 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 14, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "2018.2.18 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 15, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "琼海抢庄 8倍 特殊牌型全开放", mode_desc = "2018.2.19 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 16, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "战斗牛-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "2018.2.20 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 17, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "2018.2.21 20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
	{ displayIndex=1, tid = 18, title = "限时大奖比赛", desc = "第一名奖励iphoneX", rule_desc = "牛元帅-明牌抢庄 5/10分 特殊牌型全开放", mode_desc = "每日20:00开始", icon = "iphone.png",
		result_desc = "您在限时大奖赛，%s的比赛中获得了第%d名。",
		reward_desc = "获得奖品兑换码：%s。请联系客服兑换奖励。",
		maskIcon="",
		detail = "1.比赛采用单回合淘汰制，取积分前10名参加决赛。\n"..
		"2.大奖赛报名后，比赛前10分钟禁止创建房间及加入游戏，若玩家进入其他房间进行游戏时大奖赛开始则视为弃权，入场券不会退还。\n"..
		"3.随时可以退赛，退赛会退还入场券\n"..
		"4.本项比赛前10名可获得奖励：\n"..
		"   第一名奖励iphoneX一部\n"..
		"   第二名奖励100张房卡\n"..
		"   第三名奖励80张房卡\n"..
		"   第四名奖励70张房卡\n"..
		"   第五名奖励60张房卡\n"..
		"   第六名奖励50张房卡\n"..
		"   第七名奖励40张房卡\n"..
		"   第八名奖励20张房卡\n"..
		"   第九名奖励10张房卡\n"..
		"   第十名奖励5张房卡\n"
	},
}

return sportConfig