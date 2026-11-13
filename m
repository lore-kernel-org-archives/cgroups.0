Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.99
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794576851;
	b=nepE5E0nzq6GzNZKTt5Um+YHV2JaygGsVceoqiXkw9mcJjn+DNaM29yh1QkFbCqNV7+h
	 0Qw0VBHOF0BPxMrCN7YLwHZbhZMOmevu9tQwZwJCJRupuntd0V91pHkT4qUwlGTmngiLp
	 xHB+G3sEKeKKUwGpQVH7hcMuKnaeomQJ3Fz1Xl2l+K5tHCZuM0Lp/z/PCBVjE47GwoyMP
	 0z5r/i9o88pETwRupDB2fpx2O5sb0HBStPQdVdvpII/bFoz49MKseCCBcm2LmbuzLw//W
	 tWyNT0g5QKN5I0eTZPFlAcBu9air7JvMVIR1a03IHsIv5EvA/QQUbJeKeVuUu7zDSjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794576851;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=w3Na8itZGF4h5+Rp9nMnh1FApU1Hef/g86eaeFEMqA4=;
	b=zgWqy4IiXVKkYZS7Qa0HE777qAXG7CNe42l/xKYU/nCRRAlcy/C7uM7q9Nn2MGXTfm5Y
	 ure70I6AuZNbWMaiV03dD7BvoYZyNH3sO9RQRCbXBqWNtDqFe0JOs9LGGu2cL+tC4LFfD
	 6gSuG9KtQISEHA7Pd8mjGBlgCE1cPHeesw0X1j6Lwje8U54e/xBr0j47VWKz3jol/BvPd
	 nPjK4BwmxJEUgaUyOUh107F7d2Otz4W9FetkCaCagK0IZ/AtjXUezTAgIFA3GwT0MCQJi
	 Ws1byznT8QDXWOpkvBs+g/Ps5Uq4CR+IvuWO0iJl0vt5qsmgwasAYU+5inQZkLq7teQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=lxSyufcc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.99
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021099.outbound.protection.outlook.com [40.107.192.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B70606AB83;
	Fri, 13 Nov 2026 13:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1B70606AB83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=lxSyufcc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXUJcS1xruTaY6rpbcSXMmrmulzZlvj23R6dqAeZwvoRGeNICZEF4mI1c9YnEiTYXSLVFL3O7JDLLywwIsszcVL/xKHlvnvmdi9dnfgo+ulDSx6o9x9rvjaRtTf1ccVe75f/YMicxfGYQYj87U/YxCXLIsVXzynjI01uqiAZbkiXFURz8AR7UqJDK31FcFOfCYLabp7/ATkc5ceh09FsFRUNJWTwtSeqNb6F8V5aufkHbPDA9dB882t41JULi9OjJ6MYAcNxH0hA3M7JAF2ofPg2VOjgsJID2aPcjJ3aQfuSEb5yCVnlDnhNPGmeKzeI0FUkj4NciS6yVQ2ConqLQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3Na8itZGF4h5+Rp9nMnh1FApU1Hef/g86eaeFEMqA4=;
 b=PnXT2HrY+BjSDjRMud0W1fYZ0MMmrZ+Fe4wkJqezW2QbWzzE3lQqfK4D3UvU7Xp3NdGd9aUqgb/FrZCckzEatNctwPMs0BZcHfKg+paiiJC07L1Ma/SLoITNQUa5phxpQ2pjjGBIsJ+cfDty361kLmeo187L2VXE8+MBsQhF1O7dtptxxkfNn+X4aaOziwj0XXSj3ytVpkVqIHE7Oge7flGfiQDXkpbpz7pHa6qyq9rTH3bv+/7q+RpPrl8B9IFLPlti4TCza6CX4Gw7fcUzpEhcRNy660hxbXQUHPngUbw0r+2GtiPhV987BaFAMvgEkJdvJmlY354qxjIJQHLZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3Na8itZGF4h5+Rp9nMnh1FApU1Hef/g86eaeFEMqA4=;
 b=lxSyufccxtfG6Oe+tCMpe/K85qh5hJ2fy8CROPuyTspl3x3ewIucxE9hm8ZCwHQ6Axk9/GxUxfO31kdeZFp99n642VVYwhwalQhqes//oZtxWjh/qrV9oe61jJXe0XPaoV8cTGy+XUVBrsGPSXWViHqJGyBSp3+cQ/JAfwY+/6vp1vGTOHp23xeSPBC3Zc8GezNDXnGkmWDB+iLsmebTjXRKRdWsZU3e18+KA2mxPkvI3+UvD2cSvuRWHZ69g44lkiym2YBB2Fh0IiC/r4qBza4O6hSpHyzRNcSbE3OYHnskd8L6nittsvQFWafncGZdN0SDrrgThtDay8mbqOtXPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR0101MB5750.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:39::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:34:09 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:34:08 +0000
Message-ID: <89615b79-515f-41d8-9819-a8f16301574e@efficios.com>
Date: Fri, 13 Nov 2026 08:34:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/29] sched/deadline: Leave a dying task out of a
 rebuild of the accounting
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
 linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
 boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, longman@redhat.com, ridong.chen@linux.dev,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-18-mathieu.desnoyers@efficios.com>
 <avVfdI8NRaLN0ZHH@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avVfdI8NRaLN0ZHH@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::8) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR0101MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: a38fd167-0b22-49d0-7118-08df418acbab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|56012099006|10067099003|4143699003|261022105027099003|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	CJ5eGJSkf4rCLSCPxA/tW0Aox7CEU6kHGSHR49JkNkJN9biY9ZeBuZMHSydsIhG+H5Va1cZ0g741TRh10jZ7nxRL2EZnrEhJFGqJP70WMEsBCELuiS+V2t1UtxfJP8BXcY7tAygNuNMTUWIlVxCKeUSj834++3WrnY30XYRK2kolQc/xXhpvYgFPDbn5m9xaOrY9cydnE5guL4AkRn0SpN0KKpqop0ksN6w/0Ax8E4Ar5ryy2TntTQ6BKmEAJGJ+ItI6NT4jK73T8qEvBJy9Uhu5g4UPqj/P2s2w8o6DrFagxq7Jxp/qE2XEkb0IuPG7QFHnzgFv/tg0kUOE+tNPr4jeiWy+x64YsM5VhpIejteu242bV+iJg6MExDiVVYhKLZgBDzUkroiY7n/tA/LIJNoplaUEdLasJUwOTN5ZGlWK9Iv9aZ2P/SULVAqWwC9I9HGj/SadnGQqxpCf5E/C6YrBqS6WRj4rKWsifEeamrQxM9OecG3lbml+x36/vHbMo+wIdRbJcxORuxqAjpcX7apmT89Uxe8QO3VKhCC+JtChsOnbtS0vjhiTNvfLP699ohllnTnAiLT0Dqw7OmvoBsBsldS5Vq+PpSAOEXT/SI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3Y5ZnVVL0dmL04zU1BXamdSb05RWGRwdTh1cGIyK2FxQ0M1Y3puZHZFd1oz?=
 =?utf-8?B?UEphZ0d0N0UybUxtK0t2Mmx4L0k0VDI2MnRzcVRxMHdnbVVycGdNUjArS1M5?=
 =?utf-8?B?ZzY0Um9aaW5GNHh2akQ4ZnJjcU10RXRMc2NRUHZNZ01ZZkg1YXFBdW00RmEy?=
 =?utf-8?B?Z0hNNkY3K0hnRXBnRDF1Y2VzVUZGNGVYZ2tLSUY1N0MveGpxQTVCNzdaeW9v?=
 =?utf-8?B?MGxEUWptdEp3MTByVXZ0dHVuMXFaeFdpbkhpVHNNWmxRV21JOSthOVlPL3Av?=
 =?utf-8?B?d3dHUVM5UjZkRWhuZmdySmVlQUJKdW11Z1ZTR2JWS2N5UHZ6cWp3VUpBQ2J4?=
 =?utf-8?B?WjJoS2JhZUFkMUR4OFVGdFIxVDRaVHlZZjYyZlVWZTZ1UXVXYVVuU0RSNUZz?=
 =?utf-8?B?VDYxWUJrSU5mWXluOU9xZUl0azhIVWVFOS83eTY1eUhoYkZETExDK2dwejdO?=
 =?utf-8?B?aVUzM04zOUoxS2lVMlc5MGI1cGp0VFFZR0U4RkNsOGJ6eUtQY0FCbVByZEdF?=
 =?utf-8?B?ekhPd1hTdVdKV3hKMVlEZFh5NGR0VUlBRlFtcTdyRS9WMHBZUzA2SUhqUVdC?=
 =?utf-8?B?M2xlVWhaaFpPZ0FoRVpVVC9qZzA3MVlCRmNvbnl2cWVmR3R2U2RoV1NaeWFs?=
 =?utf-8?B?dlVma0VvZlF1anpyUTlwSHR1VXBpMk1CbDMvd1BMTGJWWkJMcUFDY0RTSUU1?=
 =?utf-8?B?Q0YxMWJsWUVTR2Z6TGRPWGV3OHA4NHYzVFVHSS8rRmJOdjBpT1VDSVdIblQz?=
 =?utf-8?B?S3VOUGVvZmhseENIUUNOeWtkNFg0VFZRRk1xREN2anZDRERPdmtEWUdGaWd4?=
 =?utf-8?B?NVFFOEpkVnJNZStZeXd5WHFzYU9LSzNNYUgrMTJNT0FXS0lEU1BadnV6cFBa?=
 =?utf-8?B?b1FLQ2lYbHlmREZNUmFXcGtxMy95TjEyRU5OV2tyWkdaVVdyanhIMHdKeVRJ?=
 =?utf-8?B?eFlraHhIdUZjZDFQMUlMQUJXcStJTmkza1pOWnF5ampwalJ1ajMrSFBrV25t?=
 =?utf-8?B?LzJKcWlUdGlRNmlaYzAxSnpwZTdwOHZVM2VOaTV4L28yZUtpYkZUUEg0WnNN?=
 =?utf-8?B?RzdRN015cDc3KzR5M20xN2RZMlNtMEg2Z2ozejlFeDZPNU9SOWtZRGpEOWZT?=
 =?utf-8?B?NEFQY0dHQzI3WEhTWFJIbXZTT2dHQnlCSklsWTJUMzBLVkJmNkw0RTlKNkNL?=
 =?utf-8?B?MTN1MktPQzlRZTQ2a3B0N1NjYkE4MEFrb1BiSDNyYzhEUjZVU3pKN0NkNmJX?=
 =?utf-8?B?bEJGRUJKd0ROVE44amcwN0MzS255d0kxRnppZlRZZG56d0NpaElsdjROT21Q?=
 =?utf-8?B?TVBYYzNIWmpmRGRJVFRoNGhlZEt1dzYvaWNvT0JQWDFkNFc3U1czMnVZaDdu?=
 =?utf-8?B?Sk9mcHdHc2NFR3E2ME15dWJadFNPU3dKc0JQdjlRVG5sdWw5SVFqTzdmTTdF?=
 =?utf-8?B?Z1RWenU5RXVSbWJMNXNTdGE0dEdmNzBsTFd1d2FxbDVDZWZDUC9kL0s3MmZ5?=
 =?utf-8?B?WjgwcFMyTHMrQW90d3FZckxYTTZNNWpoeFlOd2lwNmRQWk1pblhlL1BTM0RB?=
 =?utf-8?B?THlNc2I3UFVLd2lyVFZHSzJxYUpiUWhRV2x4cFNUVWRzRFlRU0ZPdUVIQXNU?=
 =?utf-8?B?WXlkc1A2M2xKSE1EWDFTcHBaalgzSmxVTzl2WjNRaTBUU3VTaE5RZ09uejM2?=
 =?utf-8?B?ZmFXamJteDNyUkdkeWJmMkNKSlF6Kzc3QVZVaVVWUDBPVUhhSThGQkdqQk14?=
 =?utf-8?B?d3VkUXhERm41TXd3aVlZREZTNU9SbTBlVFR6WEQ0Y0xqSWJzQ2ZBQjZWUmRX?=
 =?utf-8?B?QmNaU1NiWGYzTjBTQktjdXM1RmNtc245ZGQvRTJicm12OUpBUWJUNHI1RWh1?=
 =?utf-8?B?NDdsclBXamFHUThZMURxd1NsSXc2c3NVRzlxNEJWOWZ0RWwxZzVUL1VoRE1S?=
 =?utf-8?B?ZytheFh6SG5RcEZxVHlvdUxZZGRIbmo0eWd4WjNGa2M2Wm56d0o0VllMUTU4?=
 =?utf-8?B?TE04UERzSXhEajg1Vk9pT05XS0hxR0U3UU9uL0M4SkxtNUJPeXIvM1JsbjdR?=
 =?utf-8?B?OU1MWGQxZlFCcWFGNG03N2hwUnc3b1VlSndjZUNHRG5sd2gvL1ZVOHVXYmUz?=
 =?utf-8?B?eGhtQUJqU1MzV08waU9hL2FYcmIrbjRVZHFjeGwySVBFM2xDV3BzdUZ2M2Nw?=
 =?utf-8?B?T2ZTU0E3Y3g3ME92U0tkOWtUczF2U3VOMHd4QjdIOXBQdVc3SG43Si9HYWlr?=
 =?utf-8?B?TUZUNnBLNUdKQlB4Mjgva1QxU1AzSGpJRXl5a2QyLzk2R0QrZFFZNXVxd29n?=
 =?utf-8?B?TFFQUVY1N3N6VzZrbWhuTUZJamlwSjl4OTRGTkxCSVdYWXBjK1hEZGMyelhl?=
 =?utf-8?Q?FtJzlRPh2n9U7kcc=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38fd167-0b22-49d0-7118-08df418acbab
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:34:08.9028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4o22ooSRA5aojB12OjiaBTDewphO2p3lGUbAE/wuiowmDfylfsim9JrpTtMWC3c1eYhBTBFJUQLLuXY9bLkiVY/9mVRMukZ2zkUGODOwn7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5750

Hi Juri,

> > Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
>
> It's kind of minor, but I'm not sure the above Fixes is right. This
> patch alone can't be applied to fix the referenced commit, it needs the
> (at least 2?) preceeding patches.

You are right, it needs the two patches before it:
- Patch 15 opens the window. Its walk of the task list finds exiting
   tasks. Upstream, the cpuset iterator skips them.
- Patch 16 adds the record that the fix tests.

I gave it the tag of patch 15 so that stable takes the three together.
The planned next version keeps the tag, and its message says that the
patch completes patch 15 and needs patch 16. Tell me if you would
rather see the tag dropped.

> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks, added.

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
