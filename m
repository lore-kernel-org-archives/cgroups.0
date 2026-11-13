Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.132
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794576808;
	b=iAvhrD2dDY3Jjr5aQM+5d276N87LXhnoL9YdH35B9yBeNH4sC+K/wMp0Lt2mX5fV5k09
	 W6QTwKYsXQi5/4pH6P+oi+gTE2RJ59b6QE/+yz9P+3KJ2N/ioTAtLj/8tvL/CpwaNeeRU
	 kKO732HPAdmTYj3oJG3AtmKGbyAdp99f/KN6cWu2Z8Rqf37KLTxogG6SFaQ4FoWo4ugXV
	 jKfSCYsSe65CWVT5V1sUL9Aqm28MsWnZQZUDidDlKb6QHpRFoXtuMH0mm+EO6aOOf31hb
	 /ygO0mGmDDwtFW6+WgAEhqADd6hKpxE+iMA4k86+J1tCsjwZ5rj2j+h5O6hcQcxM1iw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794576808;
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
	bh=RK8Z9H+XxKz2MLh1W+uSKZvn7zjzXpUD6UhVatpeypQ=;
	b=0euP2kVGL8kX6BdfCoSYxCfkX6TPdlow/DrPKZkxgIm2sXmXUTJwpalBfDsvxvJJdbd8
	 38CFmEzSq5ANBOlnIN7/3ciWN8gk8ajX53jKZwbwkkJh5Ijv9Nu5SbcN/M1DmEggfMbvg
	 TQzV5rEC8fIS2fWZgL1rPmGZ87n4N0I9nG04K0bVbSNvdIYyIkUx6gOPSR5jgLvSKK2j0
	 CDtRTaxoFChj0t59AzXQRspF8kcAU4UcV0eEHLHH/vY4crOQavykaBjAH4fwgspGaPYbo
	 SiHXCoEMbe+EF9hM2fOdIIGU0yAXL4Uwj+rni5Ok2vxZupLbDqhZ4uQmz3yB1mJyhqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=rY39pZEq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.132
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020132.outbound.protection.outlook.com [52.101.189.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD3606A32D;
	Fri, 13 Nov 2026 13:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49AD3606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=rY39pZEq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2riWeUOISRVQij+g5InAKzB49IzFd0vX5CQGss/pKMwZrpF5mm8hmBn/1VPzja0YxvCpPP0xeMB6lgbxAhbgygoHRtgI8jDhAMmFAE81VdToCEyvWIAFZN7H0pWbNaqKdgAP0XB4js0LDufAiMCre/cKBkWaTB21o2k3lOh5kO2RRi8C3sLAhpoCRaFWFpsnY54aUxym6KzhoK5OPpeFfycVUYhnHWNmvGQnsThksaKuc+au2HEalJNjw+AjFglVoxtQpr0wYVvoZ+9A9L32gDLHF9wki9k8q4ZpA/cH5jihxWecJ3YCRDhGEjpT+iIS7Rx268ZVJSXitjPPHv6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RK8Z9H+XxKz2MLh1W+uSKZvn7zjzXpUD6UhVatpeypQ=;
 b=J5b7i9jPLUR8LmORRGONKFWO8eEVbX8NGJpTwAD8+StAcd/PmYrWYf1qgpLgrUt2Iil/6cG1lUAdIZE9wOaKPkRulMl4OAnFBe58JIi309WRWqI8jzARpeSQ/H8z8EjuGMZn0iHGwKf7GDWFrN7EH9KSW8BheCpatwmjds4vOddmRwmcDVWUSnKHp1FLSRHx668/dlKIqit7GhSw5WCy4YVr9yr7tQNLEWRyEZQPlUPumxVVTtzQr6jg4UUYE9GRfIxmVp2zp6UojKmUhWTR2LGtvcf6a7bSaUh4WRfDO6y5fprzbtsdkSJ9xnKBlrr6qorQE6pmxopA7gjXMoMthQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RK8Z9H+XxKz2MLh1W+uSKZvn7zjzXpUD6UhVatpeypQ=;
 b=rY39pZEqhpQ+ad95uyK20b7jlAHDLNdUaebj1MXLB2498jkad43ZdY+d2s1fnM+bBU8pswxQOCyB27a7Q8AlR94S9aFDB9gerPq47eGDDhMZMK7j6pYgFUGBWAYoVSL3w9n68JDHWfIb8QZuZ2JQT1Lz8UYrVo6vV0iJa5VjysKvdg/tRhZI7DzqEqRgMsb9DnrFv1uFW5L0EgWZMnSjGqoeOceT6+Yu5O5QYegg2NKbD2arMIIcnpZAdgI2p9ETvThCtmtVEerodNDsCEzxzBqkpJxvT8gNrrSxki7h9LlGJG7ejhbK9ujLPggaqS6aiYJvBaADAVp6QaMK1TNy1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR0101MB5750.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:39::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:33:24 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:33:24 +0000
Message-ID: <7459ff0d-d8e1-4fe4-b2de-4b4f06be9bb9@efficios.com>
Date: Fri, 13 Nov 2026 08:33:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/29] sched/deadline: Record the root domain holding a
 task's bandwidth
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
 <20261108185406.1549770-17-mathieu.desnoyers@efficios.com>
 <avSPoSnNATnwZ8cS@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avSPoSnNATnwZ8cS@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::33) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 7be3ce1d-ccea-498d-f345-08df418ab0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|5023799004|56012099006|10067099003|4143699003|261102123227099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	C3Ho3fuDaV+4Ww/nb7SxAxT0Hga7hqhJwUhS7hyCEE0T/DuvSRyZlDIxD5l1Rl69C+0hXGyMi8cMcEpHr8jTayl1R6zP/YtcqMbMxikQ0NBlkz2uMMbzoGAd1ww38beJFGuz1LRSJmHpnH3eiQ8PpEOZO1MMsJGTSXe2s7xvaPZf/U+gLyp4kJe/sNoClDf6EmXkbDeTXvtyL9xw7bXpq19UUTyBjNthq7j+s4eImF69tMLFhPsapjjYV1IH7VVDVv92hIBbvETQ/xf+6u44zxOA+nrdn/dX/MWnep1kgaB3ojeds909DKMqnpEDFMfED0zTzwes+7eiEEogrMlkXAjYirmgtXbCvUsIeJYv0lKlKCZy0lJuc2+/nEb9zvqqSTUqzeZ95RExu+6AVXMUStkOw+7AX4oz+XFsQt5/Li0ODtbEpj2OpeDZGAWcPdJQRjjZyUiFh4olgb56DKXFK46/vF2YRPsILW5YLbLEEw6vLHI+fr338QMqIhSH9AlqReFKIwFWy0bE1Qp25ijBeTwf8aGYyjiOPORkXQJ4zHBz0vZ4smV+iJ5OMVwTGviNjPSk1BCtii0uT+FcPziOUfMsu0QTdGHnZ/WJcdXixBY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(5023799004)(56012099006)(10067099003)(4143699003)(261102123227099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlhXTmYvZXVOMXpBaGM4YXdtenlqVzduRHc2MEpHYjJHbXlBeXkwemhwNGlQ?=
 =?utf-8?B?Tlg1R2ZYS09EVjJDVFQ3eGJwZ0ZKOUFrdUI3SjlYT1ZvdDJPclRJUTU0VEVW?=
 =?utf-8?B?MldLaUt3U0FaL2tZSm93RE4yaHNuVWJMRjJQOXlLNXljdjR1enA5QUZUU05E?=
 =?utf-8?B?N3BRYUZVakEyamh1MCtwNVJGZkkvREdSbGRTRmpITy9idzRYVUdnL05QK1Zt?=
 =?utf-8?B?OFVCQnVvaGczbkFxV2hwNHkveS9uWUVKVE9LcHA0WmIyOEg4M3RFYnFQdHlL?=
 =?utf-8?B?L1V3ZG85bEhGeWcxT2Y0d3FVM1BhRUsxV3kyUWJmdUR4NmZOSkZBZFBJT1hW?=
 =?utf-8?B?VGxhTHhYQ0hhdDNvZkJHemhKNXpjTTFhYkttN2ZDUUFxRXFFUmpYL2t4SzVS?=
 =?utf-8?B?VWx6aHlONnhMQTdxU1FVa1RtNHRndmVwNGtCRm9TSk1lWmpPMFEvK0xKWnd5?=
 =?utf-8?B?MUp6T2kydm9uYWRySExWWVVVT3ArWHM2NE1mKy9keTNVT0t6SVhLV1dhdHRG?=
 =?utf-8?B?LzJEbFV6TVVqVFV1eFphS0p2MldicFhQWjFyQlNpS3hibjVwZUpQQlFQSTRM?=
 =?utf-8?B?ZkFicnZXREJXRjIrU2hSMUVIT01OOFNZOVRsNk9yejJhaC8wdCt5YWVPMkR6?=
 =?utf-8?B?dVFjY2R2MWl4Nm4rMUlaMExFQWN2RSt5QlhIQkloS0hLTXlSMmZNbERSSFFI?=
 =?utf-8?B?TTBjTFJKMmZpZ2lEQ3dzakZuL3NjSVMxblY3b1gzUW5zaHFJN3BEanRYam1O?=
 =?utf-8?B?NDlwbWN4a21RL01lSWtOaXMrNVFrTHVwK2dBTXhtcU44RGtld1hoZ3d3bC8y?=
 =?utf-8?B?bnFqNnhjTlRDTi9mdk9hdU9FMWlLT1NWQ0dnTWkrNFpTMUdRdHlmNWlCVnhp?=
 =?utf-8?B?VkhVZEFvb1BERmc1TjNkK0l4QnVuajR4bmZiV0JmTTlYQ3d4Q0QzeTVmRWFk?=
 =?utf-8?B?eWxZWEV5ODJZdDJsUFQrM0xDczV1SUdCem1PQzJwdGh2YUlrQkVHVzVWb0pv?=
 =?utf-8?B?UGpqbmJLb3AxODVabVo1SXJaRWFWc2FQejJkVkxjV0NxbFE1QXhBZCtqS1VW?=
 =?utf-8?B?dC8vbnF3d1FicU1wRG0zcXdWaTl4SXkwM3JEdUhqUkNyRkxQcFFNV0JHNXdQ?=
 =?utf-8?B?UVo3aUtvTXBVUjd4Z0Yrbk91cTY3aEFJUkRRYjkvZmVUZ3NwRktoMFdZQmZL?=
 =?utf-8?B?ZWJCanZuNkU4Z211WVRrWW0xaElSL1VEOS9GdzlJQjhnOXRqbFVERXFtV1di?=
 =?utf-8?B?cHAvNitsZm8zYUZ0OGRWcG5rbVpzMDRCTDlzSGJRNU9MeFVwdW1aenB6RHdn?=
 =?utf-8?B?WnkwcjVtK2J3cUhNWUFGcjNzQ0poUHlPakJtKzJMSm8zTElONnVYWWpDRHll?=
 =?utf-8?B?SkFjOXk1c2FSa3pIVUpZMkdpWjFCb2JteXlobjVRZXdRdnN4Q2pZZ1FsUHhK?=
 =?utf-8?B?NytUb3lpTmZvVHpVZCtGakQzWlZTT2dtSitHdDE2UXp4djlBMG51Q0ZnVWpN?=
 =?utf-8?B?UXVMM1FBczRCNXdZMFJYWDVHSnFMNEtLZ3d0ZDAxdVVpVkdMMnhmSzNmNFpi?=
 =?utf-8?B?cUQwVFVvZmFYYkFWZXh1N1Y2MGVaRExLWGRYSUpBN0VTZFlrS2VoTHpDN3hz?=
 =?utf-8?B?VzJOakdoM0RxS3lKZEJ6UnltMXljbHZnZHVFVktVSXFkQ0xzRktudjRuM3BZ?=
 =?utf-8?B?VjlIL05uL3lCRktlRVgwV2JiTFphL2RHWXNBTjF0dnJRUGxoOEtYUy9ndGEy?=
 =?utf-8?B?OCt4bGNyS0x3V3Vac0ttcHVHZ2RtanpCYlNPZGI1WXZoSWpKLzZGYlQ5Rnl6?=
 =?utf-8?B?OUpRVHZXc0J5WVE5Z1crY09IVmM5TzZuQkVuZ2J4NHhxK1Qwdml5Rm1BUTV4?=
 =?utf-8?B?UEo3YUg4MHZmS1A4Um9haDdwVTNYTTM4YnVjZkdyZnFOaFZpcENBa3Nhdm1t?=
 =?utf-8?B?NnRscUFZMy9sZSs4Z1BDTFIyTUQzdm9hekdHbFVOSytPTDhoYms5Mkk3WWtm?=
 =?utf-8?B?bzlKWDJwaXQ4M1JSck9vRDdJMzlJRExFWERJOUtZV29qOTN4enNiSm5pLzhj?=
 =?utf-8?B?bWN2cVpGalc3OHorQ1JCZll4Qjl4TVlyNUJjb2ZINjEwRXBqYUh6bW8yUFoz?=
 =?utf-8?B?SkxoNE9BT0Z6bGdhQ1dMd3dEVVBKRklYTVMyL2Vhc2V1ZGxJZXJwc1BVU1E3?=
 =?utf-8?B?Mjdob1k4UWl0QUFlNXFIdllTUm80cm9FNWdoc2k1QnYxV0NRTm02ZCtDbVVS?=
 =?utf-8?B?dVIwVDlnUjI5RU4zL1EyVU02RkFyRDlFQWlyeGRPWEE4V01GMVdHVmtodWJz?=
 =?utf-8?B?OXFmYnZuaExHV2tLLzl6RzF0bDNsclRWKzN4dU44dXNkWHFrY3U3bWNXc2Rh?=
 =?utf-8?Q?drm1JNqppXIZvP58=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be3ce1d-ccea-498d-f345-08df418ab0ec
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:33:24.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Doc8ZJi8UlNemWOWoYLfdVLS+IBQVweUtO6NzSl3mA5luamvlybjSp2/AWnFUEZ5pED5gaazqP62STUDLTHfXM8SsNW42sxDkMQ/vq9/+IA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5750

Hi Juri,

> > +           if (p->dl.dl_bw_gen == dl_bw_gen) {
>
> So, this is not guarded by dl_departed_lock, but then this gets fixed in
> later patches?

Yes, but only as a side effect, and the patch should not rely on it.

dl_bw_gen changes in a rebuild, which holds cpuset_mutex. From patch 18
on, set_cpus_allowed_dl() reaches this test only from cpuset_attach(),
which holds cpuset_mutex too. At this patch, from reading, other
callers still reach it without cpuset_mutex: select_fallback_rq(), and
sched_setaffinity() with admission control off. A rebuild can then
change dl_bw_gen between the test and the __dl_sub().

The planned next version takes dl_departed_lock around the test and the
update of the record, from this patch on.

> > +    * enters the class. A runtime below about a millionth of the period
> > +    * gives a bandwidth of 0. It counts for nothing, and no move updates
>
> Ah right, quite cryptic corner case buried in this comment. :)
>
> This is the 1024ns/2s of the test. Which indeed gets dl_bw 0. Don't
> think it's a huge deal from a theory/practice pov as to actually make an
> impact we probably need quite a lot of these admitted (fork bomb style).
> But it's still weird :P. Not sure if we want to impose a min of 1 dl_bw
> for these. If it actually complicates the accounting (for no good
> returns) or not.

I agree that it is odd. I left it as it is upstream. The accounting
needs no special case for it beyond this comment: a bandwidth of 0 is
added and removed like any other. The case move_zero_bw of
deadline_bw_test covers it.

A minimum of 1 would change what sched_setattr() admits, by one
millionth of a CPU for each such task. I would rather not do that in a
series of fixes. I can send it as a separate patch afterwards if you
want it.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
