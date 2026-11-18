Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.73
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795028977;
	b=HazFezEcaJWHUPzHlJQsmpwrskGAOKM1he+NLpx3/je4VkFbqVjops5oMtbT21tz3o/W
	 eZv5Wm/W6/bGyGL3EJmb4qIGeUg3cJiDj/IZ7BhZwwdWHYq1Yrkh2vd0KCfRQgP4TkAMQ
	 7UVXJDD2WB2G6zCvu1+HXgA5lHgj4hEccisI7oRDZZDlb1visoPEEX9gYHdToptJQ5Fwn
	 KUOtko+xRGfjgvEHR2Tz0ZQDDBIXVvFZdCZO6UbfNZjs31/+4j/YDXWRMZzNvNjJtriQE
	 6mTdHGXOC9jvkj0PomnBH5yN7TPARs2K7Bv2lS+pqPSqOQcO7ko3vbjY5VK8Atx3Ahg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028977;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
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
	bh=j+6BFDJVqijqkorcu/BiWX7uYW60HKefDzkV+ISVtfQ=;
	b=gwaKVyiZpB5/KVRGn4i2rZ8UcYBEjd5RtnTGap73+MIcCq8XN9JawZgOSwMaO+fROor+
	 WUu4t4spK8auhyMS4jZLb0zfSpcVGNpRqrbih4AZbHV570rMUcJXDcxRn7vUOnNNXYc2v
	 8+qHmRO2Lwgt1kO9u+TJb6lk/GPPd/akY1nxEBdCDy44OqZlwUr0LZzJRDQo+glorfjhE
	 JoJ6qqEWud7rY2BELteOwu18UkQDv8fQXl2RXR0ipC79OfL7IGjRwO02+c4leXN21+2QC
	 2FfrTC1i6ImepDWqg8Ra93KGb0BqhqlrXxgT4MSg+XI1kKlkNtz8Bz40Ow1MQBwkqiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b="GBfDZ/FG";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.73
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022073.outbound.protection.outlook.com [40.107.193.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C19606A31C;
	Wed, 18 Nov 2026 19:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18C19606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=GBfDZ/FG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IH/QVf13uHbpLlpohIRox484frwuXX4nErgBmKnUaJ1W9tFARxEHuIQ1Po7rWexgBzqAO97Z0rpnO/78l+uJ5R69zqa22CDrPlg+COkH7B9xgF5M/Ar34rVnxagxSOt2kQKuOjvEqYjtLEOncG3xZqVDnhedOsUyf1Aj7Zx0HsyrzF5IasQqQEkW5XCckstUHvDKn/MdutoCKhWNJ0hiXueK0/O504z0gE9iZdTVbEwYH5k6oM99NQVFoCB7v3eg89OAmR0brFT22CeTYiubJNrLyHi1Mdd5amu5lTxqJD5xPNqi23ICEZsHTquZxJ3p+0ECArWf3Toz+T4mhBspHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+6BFDJVqijqkorcu/BiWX7uYW60HKefDzkV+ISVtfQ=;
 b=IdxoueMIbtKWjisRLthC+YasWvdyeUy5witdgsVK9J24odn53/4joG9OgXxBdxvh1bIdRz8GtWTRsCgscR2zFryulhX0R3VRmObAbR5iihIvgAlJryREq5ILeJUu/eluo/gFd1Gm9gVhX8IXrNrwOQaY0BdLZqBP1kEJiYEeH1nkEJ1LeHOrCi55paPy6MCobpaTU/jh0drH1UflCQAuZh5elUSd8CXbuxvi+WvZhKZu43fCF1mcRjrdT6XZ03z5mUAzTgrUh1T6YOdfdo7NIMuK1wMgcG14GEU8hOKaIVstPq7XWnvaJiO46jLR1cNDRAQYuq6TVy/aCkU6SjcPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+6BFDJVqijqkorcu/BiWX7uYW60HKefDzkV+ISVtfQ=;
 b=GBfDZ/FGdIwyyNEIHPbkQzGr1ZdtGsxLeaUCc5tnt4iT21+yzgndAzsymAQoHDpRxhbtMpvYC4KkRhGChtz+DZ8letQvbyJZ4B3nWt+qydioGzT59TcWNc0yOIqaISwyu7xC99HgpuNJOOvymcWmc4f/TS3DHmFtpxeFE/wlcotXZVYiHFcOtzbU7jpKI3WacfftScmsLEDi/BpAXTGsnmI47cnVHSN2ONBZhgA55VpQDrRqHYoXKeJUGXxxYg4PcbaP+3EtIu0NPgxa57SSJLWBlDbZd9WJPTl4hCpkJdlRnqUeRrFfJsXiNaUajuHkxoXdw2WwFPieOQGO3UcQZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT4PR01MB883432.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:18e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 19:09:33 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 19:09:33 +0000
Message-ID: <1035b351-81be-4371-94f1-25279349de1b@efficios.com>
Date: Wed, 18 Nov 2026 14:09:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/40] sched/deadline: bandwidth accounting fixes and
 selftests
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
 linux-rt-devel@lists.linux.dev
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <av3J3zMfkRplg-N4@jlelli-thinkpadt14gen4.remote.csb>
Content-Language: en-US
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <av3J3zMfkRplg-N4@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::28) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT4PR01MB883432:EE_
X-MS-Office365-Filtering-Correlation-Id: e3ff567e-c1a4-4a24-6285-08df45a77ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|5023799004|261021135927099003|261022075727099003|4143699003|56012099006|261026140227099003|10067099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SsbjUTAQ77SFF7SbUL0DXzz3sAKmJAf/HlhGIyr9hTl5i/9Fg5drPw2DgpK4fkl9jIXSxBQ5aRApY6wYbUbVgBXHBVjb8hj75SPsmdh1dm/Jwb+EFp6LrWSXMQmURKwDLguhb5OHZdsONvEFBP2t96XZ3FMLiqu11uAKyLcty/chzCcgOVYA0AvuLopuNlE9o+Mm1c19ptXvsdq9s3SfnxcrLwbDFLLZIi4hTy/jgPlbiQ4ieiD1yJ2Fbw/ZlO5QmKLBMGGbk/OJPaSbKltODcskdINwXkPRzGSdPwIRKPE7V5KZPPneTYCxxen/4YkW8BteNIdesFqDtXZk8co11fZDlWFfOtP+Bx+lNkNU/MySOa7AyiYfiAI4SEVy4syUxvaaXKmFOX2Q3RF65pGh9ZCNgWDa1a5BsUHIGvZZkGF1BjLvWMVeSdAH9/JgAMx1TRjjiRaxcKjG5gZl7ketRpjGUV3G1icneWBpzzj5qIrScux3+pG4pSmfc09+mTsUIjm+zAg8i/ahXcdEyyHmqqE/wg36eTd0olfO1PHGBgx6q0OytTaU3Llq3tBUPe3SbgogDedeuD5vU34eTWCmFXu/37bSdmA/T8iTwMZT8Xg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(5023799004)(261021135927099003)(261022075727099003)(4143699003)(56012099006)(261026140227099003)(10067099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UC9BNDFBUXZELzhUa1RwYTZzdUFTUTNmQjlQbGxROHd2SzhOWjdLTkNUYUl1?=
 =?utf-8?B?U2ZwbFpRUjNHK05XWnNXMmhtZGw1VkhVWTdNWTVoOXBLRnZmR3AvZ29iellQ?=
 =?utf-8?B?bEV5M2dPbjgwUmJtM0M1VzNnNVFzUmlxN1pZRXFGNkZzRHovdUNML3FkR0ZE?=
 =?utf-8?B?QXJIc0lrZTczSzlZUDFnMFRZZ2V1NitsNTNHRjRBRzVhU2kxRkVjMFZsb1lE?=
 =?utf-8?B?Z2xEWjZTOGNtOUhwU1VkZDlSUU02YzA0ZFVTZTdDM3pEQzFNajlWcHhkVHpX?=
 =?utf-8?B?dUFjZjIrL0NyTytHaEJHTnJ0VG9IZkIyTFFyUHhJVDlsOXkyaXhIcytMY2ov?=
 =?utf-8?B?b0k2aEg1VnpUcWhUTS9TSm5tSlhEYzYvUnBSdmE4Nm1SUTdOYmNja0xpalZp?=
 =?utf-8?B?MXNBSzg3TlhYQ1NGNGlWYklGZTFJREppT1FOVUlxUlUzYlJiRW0zMmFEemh5?=
 =?utf-8?B?bk1jc3BrQkYrQmRLNGZrMG9IUmFUMjFJeVdJSzVWNytqeExBRUpZTTR2VG9o?=
 =?utf-8?B?RFZoL1ZzU2NXVmtnak1QWTlMRmFGKzhWeHM4ZXdDQzlPUzBKVHlRQW9ST29w?=
 =?utf-8?B?T3d5cGZSMzNVTDBVWHp6RGM0RzdTYTZodjdJZlREOHZEaTFjMWZtNUc4bVJT?=
 =?utf-8?B?YVhDazFyVS9yV1l4VEpxQ2ZmY3BEUEhicU9qMlE5RnZ3MFFlRXdWVHBKV3Z0?=
 =?utf-8?B?WVB5OHVlVG5SRHlsRGZIUGlqWm9qYy90S2s5YTlTQlVyMUR4aC9ZZFVBSi8y?=
 =?utf-8?B?REF4VjdkaEtwKzQwcVBTckUvL2F4SDF5ektWeXhHUnJ3NlAwUmt2OXphWEVN?=
 =?utf-8?B?U3pBVmdOR3VxVXZyMGg0WFNWQ3B3ajlvNlo2d01qaVV5OWZ2anAzUlkrLzMr?=
 =?utf-8?B?WWdabTRKYkFrRUFObFF4ekRJNU9yemRxM3RSR1loOVZZVGcyZTRFV1JLaTE4?=
 =?utf-8?B?Zi9uSHNWTUdNeFpIWm9DRVIwSU1MOU8vamlVNlhla092WVpOdVBVeG5LdTlt?=
 =?utf-8?B?ekhacUNhbW9WZlhQWkVVMkt6SkNNbkhpL21KQWJFTHlSNG9HdUFNdkZ4cHNs?=
 =?utf-8?B?clhKSTl5SGlobmxmTnBJcXZaalRHc01pc3hCNGxZOTBwWXFmTVhkOUdZbFdM?=
 =?utf-8?B?RjZnVG95bVV4VUNmWlpXZEJlMlcyallFRmw4K2xVV1dPUmFYbDBCMk12SkZY?=
 =?utf-8?B?WitFU2RPUWFod1VnWHk1aXJob3FqcVBncDBTRVZCaE1uc0lsWjBqd2xuTFkr?=
 =?utf-8?B?SHNad0h6aXA5djZzYWpTM2lvQ3dnZ05TRmJGZGFZR0lYYnAyVFlEM2tScW9L?=
 =?utf-8?B?QldNK3p6aFE1MnJ0U01rZ1hMSHk0WGJxMGtUUUlKZHk3Tm4vN1dFS1M4Vld0?=
 =?utf-8?B?enRXR3EyL2prTHQrOWVLSFcvQ096cWxhQWpSSzdRb1RaN2oraVdaWk1halpr?=
 =?utf-8?B?aWpsYVFGRlhseDhQblBBYnlIdW9VbVJNUnlBNFNXbkdlWWtDVDU0ZVlVSTd3?=
 =?utf-8?B?UWN4QXE1VThaOEVKcitDRTBOR09DSG1TbkQyRkRaZXZDQ3VUZFFlTlNNeURh?=
 =?utf-8?B?VmJISzRwRFdRTGJDcHUxK0lRVVE0cnFjZ2Z1QzJWNHY2OE11c1VqRkJUNHFo?=
 =?utf-8?B?ckNlQkxCWW9YYytWY2p5cXNYd011L1Eya0JuY3MzQWFkUXA4dDVPckJvTzlh?=
 =?utf-8?B?UDNEOHB2b09aK3pSUVREVXVucDB4dVlvREE0WFRIanFEdzdWZXc1Y3pFV0Rx?=
 =?utf-8?B?bDRwTHlIbE1uUEh2dHEzUU4rMVdIT3BhV2pKeDhTNHBzNFVkWkdlc0luaUEr?=
 =?utf-8?B?N1JobW5oTlBuTHJvN0RJNUw4VnZuNEZ4TlRUa2tDbXQ5Z3JJOXVuTDV0elli?=
 =?utf-8?B?REQ0a1hiVEJpSWQ2MUpWUkxaWVRtem8vZlhzc3B6bExja2hSVlVUOU1VMFlK?=
 =?utf-8?B?TkwxL1JJeEtia2dtdEtoUFNTWEc1WVpndkY5cWllZ0RFdFhZK2JVWTdUaS9R?=
 =?utf-8?B?ZmNhVWtucTYwRXBPUGQwaHdsZlhHYVFKVFZ3K1FBdTcvU0svOG42bk95ekZo?=
 =?utf-8?B?U3U4bDhnMUg3N2ptZ2hBb1VBSmdhY1ozNTcxNGs1eC96OFFXV2o0Z0JyZHdR?=
 =?utf-8?B?QlBPNVIzS1Arem1NUGM1Y3JTZklVQWJNY09uZVhDWUpGWElxMm1oS0NGS0FL?=
 =?utf-8?B?b1ZNYStpRmdwemt1NGJXWXo2UmJ6ZFhTaS9Ga0N1TVRHS2ptTXFEKzVsWGQw?=
 =?utf-8?B?QjU0YXBUaE9mNmpMNDZmK0ZQb1o1dUhoTmpLbXl3SEh4ekJOWUZhWkxZcGw4?=
 =?utf-8?B?Q2JxTXQ2emIxR3RKaEpLNHpOM0ZOTXA3WHB1TGJpVUtQRWhyYWxieTM5c1ZI?=
 =?utf-8?Q?HbAWPtWZya7dWetMzx2mttmPsmgTYr+PiGUWZ?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ff567e-c1a4-4a24-6285-08df45a77ada
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 19:09:33.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDkmRqnskIFKI1aDgb/knKNdk4a+fmHoq3Ut/LyTUN3P7dvjGJ/VC3Kz/Aa7asvbZjUij7NRNZWZ1LSk3P5o0wK2lhHLNM2hPBbLxeRxkfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB883432

On 18/11/26 16:53, Juri Lelli wrote:
> While we spend more time on the "upper half" of it, would it maybe make
> sense to split the lowest part so that foundation fixes can start to be
> merged. I'm thinking 1-8, 10, 13, 14, 16, 20, 37 (37 is not a fix but
> harmless). Not all associated test will pass of course, which is not
> super nice, but we know they pass with the complete set and can maybe
> come later.

Good idea. As we discussed on IRC, I am taking these 14 patches as
they are.

They apply on tip sched/urgent as they are. Each one builds alone. The
kernel builds without warnings with PREEMPT_RT, without cpusets, and
with RT group scheduling.

I would rather not leave failing tests in the tree. So I split the
tests too. The first series adds deadline_switch_test with its 5 cases,
and deadline_bw_test with 47 of its 112 cases. They pass in every one
of 25 VMs, PREEMPT_RT included, with no kernel warning. On v7.4-rc2, 10
of them fail, one of them in part of the runs only.

The other cases test the fixes left out. They come with them in the
second series. As you suggested, the two PI cases of 13 move there too:
pi_former_owner_asleep and deboost_released_resets_period.
asleep_round_trip tests 13 without PI.

One case gets worse with these patches. pi_chain_top_moves passes on
v7.4-rc2, and fails with them in every run. A bisect points at 13. The
owner keeps a deadline task that left the class as its donor, and
another deadline task gets too little CPU time. The case passes again
with 9 and a new rtmutex fix of the next version. So it moves to the
second series with them. Until they land, the cover letter of the first
series lists this as a known limit.

One more result on v7.4-rc2. In one VM, hotplug_server crashed the
kernel with a divide error in inactive_task_timer(). The message of 4
gives that path as found by reading. 4 fixes it.

I will post these 14 patches with the split tests as their own series.
The rest will follow as the next version of this series, on top of it.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
