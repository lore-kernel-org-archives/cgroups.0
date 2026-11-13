Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.104
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794575555;
	b=HQ8Q+fJnYjFxCjSt0iDHnHDjlTMWEThi8bCxr9c2SKlTbhwRPYX6OG09iZGbI5UDLKJI
	 lMTzXIp8K5s/fYuGykPsdxhuPRr+FrjCAmqU12ElokgD0WyA6iibcY397JATYu1o80Zi3
	 eXyBPdddKFXpwC9W12J2YACH+Z0m0/VdtO6Z9a7aflg7M1Dait4BPFXGhARfDapODJApf
	 WHPIutt1sXvhxl8F96mpgbB6YmzxYExkTWUW2imqu2tjBJ7dqvCYOwF1BHaBCuOkQtdN4
	 pTZenWe0kT62V5gr1QgcaElXWuWYT+JnofsJQV5aO0+s+dtwJfR/3phG1Jh0c0UiaWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575555;
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
	bh=kOYPVzY+ftwPti6ydLo/MdoI9ouwgF62XzSQ7DnQ+eE=;
	b=ad2n2GR9zevtzCdpiaVC8SjqHDzWsba8g+Pdkpp/XOqG3FPGdz7NK5vDMyNKIQwmwxh2
	 MYjBGXZvYmv4CKEUdkH61kUcR9uMn8THZeaIOD/KpohIYxqI4qzq0jQP44Wl2VIP6OXWY
	 nd/QFbeo2L7gnQuBHvB914ivYnIOM5rUEi/u4UL5haRDd3/Q8CgmsMDjIBgDABmGCZug2
	 RuvQf0PVSbtYaanX0pafUbsPA5Xm2HKTCnIeBPe3bqyiBWAc/J41iQwRWj9XxCAZM3Hgx
	 T+YhYSyhR7O5kLLEUTOhcAE6z0OTa2Knq3n4ibPVNm5LbIKZ1jBcOmRpbTFuIjR7sJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=IiY6y7Pg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.192.104
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021104.outbound.protection.outlook.com [40.107.192.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173CC606A8B4;
	Fri, 13 Nov 2026 13:12:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 173CC606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=IiY6y7Pg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0JX4e7UvZA8Q+pAzAv8afKYFTmfnM0T3FS+bxb/DtiP3m1ARJ7V/oiaBbD+0tmomckvQvfWCRXe48+MyDW7whXyra2rng2shqDHKo7Va1lDcqWUQJs5U7cvSO9SCKoTtosj3nxhS7R2rfoKxEJr0H08iuVLPOngk5xDXSB1aQQ9iKSp03EoIyMDXNEUOMtWWx6gYpYsGHCsuDQxX43pOJJcVB7sEyueTdoUjDylpp94XE3WuDzjzX8pcTMhjLJzQqHMR8R+9zXFsDzyutO3usc6mehvcUx1dmUpFVtxlSYsOG1HSSZG5sEb1JMr8Cp6NyDioAx70txaoEHDPdlLsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOYPVzY+ftwPti6ydLo/MdoI9ouwgF62XzSQ7DnQ+eE=;
 b=E+nHA/CVeFtqK8VZTJQH2bkxtkxeyN/atRggqpf/z/ouQj+6r/CwkaMmsP5mdUFwUVyUCJXNsheN5kBPqMs/EiipIzajpLEXySI7W07CmJfy+dOCb3imKhSZfWdPTi22u/7v3bGJJ+XMnM25SUNPUQ4csl+YwQdvd8POXg6zS0X+6k8ARd/D0puFsegFuscaPYTWUASh+HgtOCBJSGVP0akODsC9cAdoJCctPwEfHfPFqwfAaCGn2hNLFEOyeWMOm7PFRivRaPztUEnC5IJFXmLbuJ2OVTf5771sMHWW3DsEdpO+fLPCJYhB0o0z5a/b0F+Z0tPfdMzWyfxCewX6Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOYPVzY+ftwPti6ydLo/MdoI9ouwgF62XzSQ7DnQ+eE=;
 b=IiY6y7PgLoOMZgTlj9MKUUy/80C8b8+/QecP6gVtoDTTrYGuymeddHYCVhG8DNdsc3agLUBAXi8nIWvAp5Tizyt2GBY4qGje3iPuDXGxubdiN24Zm5CCEHLosS4D+LU1HSOPUu1d2ukN2/c6xALLnpKHkBJl1WNQfsMlSSqtvlynTGAcyTCIUUxmSYEwQdwixesYv976oi9CWUrUNvh8k8/RKfOdkLpdeY3QB3MqhdMKC/8QMKwhBEVGmdXmE3G7iIZ60UTAi+KzGyJ1/Jgak+5R9O4c5YjThEa/w+8TyVX7zpSCVkpaNE8/zacHJ0cu3napf4YsSA+pl7vqt9z5DQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB11059.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:13e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:12:33 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:12:33 +0000
Message-ID: <e21aaf40-b929-444c-b707-3200e21d7301@efficios.com>
Date: Fri, 13 Nov 2026 08:12:32 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an attach
 did not move
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
 <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
 <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avWEta7b9X4K6hF7@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0191.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::24) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB11059:EE_
X-MS-Office365-Filtering-Correlation-Id: 89ac109c-b461-4f52-0a0e-08df4187c734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|18002099003|22082099003|4143699003|5023799004|56012099006|10067099003|261102123227099003|261022105027099003|261026121527099003|261022075727099003|261028144727099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	T6jc88PLo3In0XA/he5g+TmRHjepRFZkkQ3B32jL4Jp6n8VjKuw56CmPUSAEcofnK7kwf23CORUJ/5P5G4E/FGBIp36FMn7lmqx6ERqz7nLK2xUB3yeV/QnK3hRUYT2S/nO3cJyUd+xpK1xoKGPXC2AFpV0ViWG2rU9vzv0JHADzWQtTi/f6168IOHoCUiepqwhlMkTaWAZnucnrEnQpoOjjUWu8Vs125t+REfm/sRwGyp77S/rXWfb14NgEzOwMTfuuKZqRSxgQI8NkYRnDDMT/stSKDWeLMCfgoNOwVT+VNWbFJnhszpZuo9jAJcU9n6/2/DjSqVdIIGPBhnuQYbBS58qoM5WB1BWJvJ1QmyZ4mdWm3BbXRrPUKryrdJR0Td0OU6R5dFJajbRpkLj4GIDiMLwdHsr82fj06PvsNuySUniHZGb/BieZLQEmWUF2tSWwxAOl23tmp+4X31x3RvOnuoMKRyLeuycaOJRSigfgi2MM2Bkt4ZegktLjgTNA3uSc97JzTIOvav/vyFP1ZcRtLbb8HSW08qlq1MEIDxSF1CLmN58PgMzNEVsuWMYu+OKXXZtvB+vpXFiJcWEnJQ/EhrNs2FrfU51KeJ7wxOI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(4143699003)(5023799004)(56012099006)(10067099003)(261102123227099003)(261022105027099003)(261026121527099003)(261022075727099003)(261028144727099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXRUdjVDajlMUll1bjNrREhnZ3h2aEE1WW9NOVZaQ0pNRmRBUkhLOXF0ZzJR?=
 =?utf-8?B?VE5sRGl2Wjg3TkY0cmlzS21TbzEzSk5WTURYdG1Bamh4SjRXWktCcFY3S3Ns?=
 =?utf-8?B?VVRsaFhPelNmMjZqR0tCaWs0YUI5QWJ5cWkzSTV3SThkYzRGRVR2WnJodi82?=
 =?utf-8?B?TldyakFMZGVjbXo2R1VEUktRZ3VDUHpERllwdGtNcUdoT2tObVRIenptOVJD?=
 =?utf-8?B?c01jRGc4YytGSi91QWdhT0hPVkl1bElKeEowcUxLOGY1VWkvR1NOWFk3aTlU?=
 =?utf-8?B?Qi8yeXJXditPdnVGYW5SYkVWYU4vU0d3T2RoQm84cGFoYVVlengvQ0o1eG1W?=
 =?utf-8?B?ZnVBMVYwUEFEUGpHejJMMUlKQlVVNlA5UFYrUDlRUXorNVpoWW14UE8xTkx1?=
 =?utf-8?B?QzhIOFdQY0xZZkpxaHFQa3J6ZDhHQ3dRWkd0R21hbFdKczdDeHY5clZVMU9a?=
 =?utf-8?B?VkVHek9aTStpN1RsWXFRQlY3aFZNVThaRGE2NDBLOXVXZ3NTVjRZVFpHWlRB?=
 =?utf-8?B?dnFWSjJTRjd0QjAvMEQxZjRjUzVYT0l6OU04a2wwL1JBNlVLU0tJc1Nkdi9F?=
 =?utf-8?B?QlhXMnlQb1hyci9FVmlLU2xpR0FiUVl6YnNvbHc0NXg1bGRtQzVWTDRSVndO?=
 =?utf-8?B?MFhTRUtmODJWVFcvM3VwaXNFbzR3RXdSUkdOaXRBZDErWllFS2diUWpXZVk5?=
 =?utf-8?B?S3pHaGZzNmd3MVgvM2lDYjlzR250cWNRSXM1WFJIb2p0aWxubVc3YzVmemdU?=
 =?utf-8?B?VXJSZ3IrVDJxZjJ6L1MxdEFXclVlMnFsbVJDeWtwOGpCQUtxVGVkVkgwTFVJ?=
 =?utf-8?B?eEVranBOcUd2dWRZWmc2NkRqdG5oMk84UVVQUDdDenZFU2JwNm54dktRZGtB?=
 =?utf-8?B?SGJheFg2aXpLd1RvTUN6eVRrWWhlWWlBd253US9IWTlJNWpvRC9VU0U3b1Nm?=
 =?utf-8?B?cTZ5TkRwUG1KaGFSUFlVWjBxcWdkUXRpcVJmeGpKakkrME1SY3VJRVQ5Qldl?=
 =?utf-8?B?SnB0MWd2SVR3QkJId0U1UHNqM3RCUFVvcER3Umtscm4wc1FlRW1QTUg3Uzdj?=
 =?utf-8?B?NGIxOXpyM3ZYdlhpK3Q2ZGdBbS9GTnU0OEhlMjMrR0JSZmZHV2lNNUdzWVps?=
 =?utf-8?B?Nndjc2F1bFZSeFZBUHZvWUw5K3VwaHB1WXNwUDgyemFBRkNOMEpMaGFqaEp1?=
 =?utf-8?B?b0J6cVJwdXhScEo4d3RjcU5FU3dYTERPaVhaUGV0T2VOQVZ6dUlqOCsvMXly?=
 =?utf-8?B?a2hzWmtLcmJlbDV3QndvTTZRZHoxN2J3Q2dHdUgrZmoxWElPOWZnVjZmUkVX?=
 =?utf-8?B?NXpTcm9hbkp0cGxzTDZwWExnZkhwVnlMbUw3YUd6eWpYd0FkRnp0UE9CSzNH?=
 =?utf-8?B?SFJEcWJpVWorcmdRTVFtNzUveDEvUkFZUGJtOGt3SThreEgrNm0zOVo0TTVP?=
 =?utf-8?B?MkxjR2lLZjZWdDVsU28zSEkzYmw2L21BY0ZWZTRoaURHVks4M0xwcEdNMFRU?=
 =?utf-8?B?Zktwd0hwSlVDY1NVWDFnVlozL3FZUkoxODVBNzNkMWxacThKVFFacDU2NWhx?=
 =?utf-8?B?Y2NYZzc3Zk9lczFNVXJCRFdJaEpBY3BSUTVhS1kyMzM5YVlSeFpqUkx4UE9B?=
 =?utf-8?B?WkFRL0p3NTlGU0ZtZUZuaXFRQkNYRGhwZkxZYlZxTTJ5OTVhWGpJRzlYOGlZ?=
 =?utf-8?B?RTJNR1VCbFhEdE1UQ0k0VTFjTzFEaEdoNzFxditjcU43cFVLRE8yQllaNFo5?=
 =?utf-8?B?VXRxM0hwM3UwTXVqeGh0Wk5XR0N0T2F1L0doT1hjbkNhQzlaS0xaVjh0UnMz?=
 =?utf-8?B?WEs0Mk1LaXVpdTNVK2JRcmp5UFNiSld3cyt0RENNNzNRRk9FeWNEVDRvekVn?=
 =?utf-8?B?Y3NtUWNTSXpIdnZHamZaUmxuMzNpYXR2TmkyMXJxcGFEdGZieGhuWGpBLzNi?=
 =?utf-8?B?N05Dd293RTVyK3MvYW5kYmNIN01XeUZJL3lIRlc4aStKY1ZNTGdLZlNuTURS?=
 =?utf-8?B?RXBNVm9IelNwcEdVdVh0aHh2c3hIemd1eDNhTTJVc1g4YXRMNkJrcWkyOTVj?=
 =?utf-8?B?bzhDaW9zaks5ZlkzQVJqT2VNeHpCOWZrb2dLdVVXTU5JYnRaNlMyMUplVkhW?=
 =?utf-8?B?QUQxb2hCaHYvK3dsOEhSWDMxSXgzWmxLYUN3MkNKK2pjSTNLamtTeTVtU3RY?=
 =?utf-8?B?RjFvRi95UTd6a3VydjVaME8xSjNqQjRacDdpUlBKdVJhUGVxclhuaVNEdkVY?=
 =?utf-8?B?TXZKY00wWVV6akV6V3RLTU8rRlB4R1locFkwamc5MTgvUEo4bEV0MU5pSE4w?=
 =?utf-8?B?aGxIYjU1OXhLa2dNSDdYMFliUXRQSXNrWGgzVXl4TnRINkJFSjNNRmxCQm9V?=
 =?utf-8?Q?qKu28KxANKpyhgh0=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ac109c-b461-4f52-0a0e-08df4187c734
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:12:32.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwg1skxYx78ahSo9A/kTXHRjhs9ZEOQf5X641uqVRSjq27tOK3rcOZIft0xeGuUqnEikwjnFA3m3a1Wg1TmR8pywPG+dFkb8ScF5sNHY7E4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB11059

Hi Juri,

> Humm, this is identity-blind: it cannot tell a task that can_attach()
> counted (its bandwidth really is inside sum_migrate_dl_bw) from one that
> became a deadline task in the can_attach() -> attach() gap, for which
> nothing was reserved, can it?

It cannot, and your example happens. There was no test for it.

I wrote a reproducer for it, in a 4-CPU guest. P is a one-CPU partition
root, which admits 95%. A process starts in the root cgroup, in the
root domain of the three other CPUs. One write to cgroup.procs moves
the process and all its threads into P. The process has:
- a main thread, the thread group leader. It is SCHED_OTHER and asleep.
- two sleeping deadline threads of 30% each.
- 2048 other sleeping threads, to make the move long.

During the move, another process calls sched_setattr() on the leader
and makes it a deadline task of 40%. cpuset_attach() handles the
leader first.

Without the changes below, each sched_setattr() that landed between
cpuset_can_attach() and cpuset_attach() gave the same result:
- P counts 40%, for the leader.
- The root domain the process left still counts the 60% of the two
   threads.
- When the two threads run, their bandwidth follows them, with no
   admission test. P then counts 100%.

> Not sure if we can consider tracking the counted tasks per task? The
> taskset is pinned between can_attach() and attach(), so we could build a
> list of (task, bw) pairs at can_attach() and let the gate check
> membership?

Yes. The planned next version does that, with a field in the task
instead of a list. It needs no allocation in cpuset_can_attach(), and
no lookup. Three things change:

1. This patch. cpuset_can_attach() records, with each task it counts,
    that room was made for it. cpuset_attach_task() moves the bandwidth
    of a task only if the task has that record. In the test above, P
    then counts the 60% of the two threads. The leader's 40% stays in
    the root domain it was admitted in. The patch has your Suggested-by.

2. Patch 21 of v5. The record is then the CPU the room was reserved on.
    cpuset_attach_task() moves the bandwidth to that CPU, and does not
    compute the CPU again. cpuset_can_attach() picks that CPU from the
    one the task is on. This matters for a sleeping task that wakes up
    during the attach and runs on another CPU. Computed again, the CPU
    differs, and the task misses its reservation.

    A wakeup cannot wait for the attach, and cannot fail. It does not
    need to. Between cpuset_can_attach() and cpuset_attach(), the
    bandwidth of each counted task is held in two places, as it is
    today. The root domain it leaves still counts it, and the
    destination has room reserved for it. A task that wakes up in
    between still has its old mask, so it runs in the root domain it
    leaves, which counts it. cpuset_attach_task() then moves the
    bandwidth to the reserved CPU and releases it in the root domain the
    task left.

3. A new patch. With 1 and 2 alone, the leader is in P after the move,
    and its bandwidth is still counted in the root domain it left. The
    cause is that sched_setattr() lands between the two steps at all.
    __sched_setscheduler() takes cpuset_mutex for a change that involves
    SCHED_DEADLINE, but the attach drops that mutex between
    cpuset_can_attach() and cpuset_attach(). So such a sched_setattr()
    now waits for an attach in progress, and so does sched_setaffinity()
    of a deadline task.

With the three, the move and the sched_setattr() never both succeed in
the test:
- If the sched_setattr() comes first, the move counts the three tasks
   and is refused with EBUSY.
- If it comes after, the leader has its new CPU and has not run on it.
   The call is refused with EPERM, as for any sleeping task moved to
   another partition.

A thread can still die during an attach. This patch already gives back
its part of the reservation.

Your finding led to one more change. In the test above, the bandwidth
of the two threads reached P with no admission test. Patch 23 of v5
does that on purpose: it moves the bandwidth of a task to the root
domain the task runs in. With isolcpus="domain", a cpuset that is not a
partition root can hold CPUs of two root domains. A deadline task in it
could then change root domain with no cpuset attach at all, and patch 23
moved its bandwidth unchecked.

Three new patches keep a deadline task in the root domain that counts
its bandwidth:
- Where a CPU is picked for the task, a CPU of that root domain is
   tried first. This covers a CPU offline, a mask change, a wakeup and
   a rebuild.
- A CPU offline fails with EBUSY if it takes the last CPU the task has
   in that root domain.
- A write to cpuset.cpus fails with EBUSY if it leaves the task no CPU
   in that root domain. cpuset makes a partition root that would do the
   same invalid.

The bandwidth of a task then goes to another root domain only by a
cpuset attach, which asks for room.

With admission control off, nothing is refused, and patch 23 still
moves the bandwidth. So an administrator gets past a refusal by writing
-1 to sched_rt_runtime_us. The two refusals are new behaviour for
user-space. I would like your opinion on them, and on whether that knob
is enough or a dedicated one is wanted.

The planned next version adds cases to deadline_bw_test for the changes
to the attach. Each is about a move between cpusets:
- a policy change during the move, with and without room in P;
- an affinity change during the move;
- a wakeup during the move, with and without room to spare;
- a thread that dies during the move;
- a move that another controller refuses;
- a move of a frozen task.
Four more cases cover the two refusals and the choice of a CPU.

About your sched-deadline-tests: I went through the branch you pointed
to. Four reproducers had no equivalent in deadline_bw_test, so I added
cases for them:
- a task stopped by SIGSTOP that leaves the class;
- a sleeping task that leaves the class after its CPU went offline;
- admission control off, with a task pinned to a CPU that goes offline;
- a deadline waiter that boosts two SCHED_OTHER owners through a chain
   of two mutexes.

They pass with the series. On v7.4-rc1, the first fails, and the third
failed in 6 guests of 8. The patch that was 11 in v5 fixes the first.
The one that was 13 fixes the third.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
