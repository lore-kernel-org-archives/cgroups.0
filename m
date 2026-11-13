Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.106
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794576723;
	b=5D2eX+d5PpwHhcvfmYK7A6s05gUN+TA2ryOG+dPUarcr2cHV9kUzEY9vfN0/tywRySKl
	 WJELUe0+aJluUioik5st+/Ygp2ZVD2b8L/DCqCYfTFCX7baTP1Gw+AlOhO6LZKSIiNnw0
	 BogjXoOkThY1NuhScl2adM9u/oSKif6NcPHyUSv7TyOTEWBzMZWXX7Zr+gNvGHpSfhqBH
	 nzPGZgsNF1zPQ44OR6S85EUrYTlwZpQ0M3SXBMPRI0oevI7ONszLOskf55lNu/fpdShD4
	 wacM5i/Th6CcJBP/21ckWwCGaMOb3nnNDiC3/Fgg0oPhlZOnZTVkrnpcrlKCC+kxhbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794576723;
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
	bh=6ey04CRDOBDBiM+CEkBWGNJ1jBopZXpl9SjVmQkFVno=;
	b=o8v4INzJa/Pvr/S6fZsuTX5tCeGU2oZrNqg9ao7JRaoKvEedFSW3+8+xH7/KXZKGvtaz
	 0BhHwOwyKrYbyVBUsBQ+WEQJpExsYvgzsDOnY1EueUaZqHIvqvX6++L9C02yfhN9K+UlN
	 Ka66Jagu42JOBXMEz87OwN1qVEqsSYoPcvkMU5cl3DgiMdf68JBKYVfQ6nyxiJpZoY9jF
	 xvMUhVudkVJkWn4MUo9Do0pm+PT2VKLfmDp+bqWRNTOWApWXbs0mizllvnzrZ/gLKhX+z
	 qhXT3l09HHxRPvTdJa3ignqGI50UVrKJzB7yD/P3iht80ehPtPWGcZVufTMFWGHAguw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Y5mouyoQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.106
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020106.outbound.protection.outlook.com [52.101.189.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158BE606A323;
	Fri, 13 Nov 2026 13:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 158BE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Y5mouyoQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nX/1zKFAeYtYrOCcNEzccsHbHJmnE6lGUVPgq6IEDQOFQsmNV4WRogZD+D9P3h/HXO0nYqreSGBIk/c5RQ/+NTBywR0D3wCaxScN5MvvEqc/otAAK/+w6GaNKOpyt/Ph+jfeNSyb1fAFFz/AuHjKH/ib/CecgMT87ZitAKDh1xNgkdeW/3MpWHfoAg1Q1LEcqBshr1njyMsrcfE5px+bMXNKAJbT9coNTRCUqETAazaYYHqnhwEIW4TWQtSpX3nN5gY9o4oCwWBkCAa+nD5ev4J5DpACaZH2oPULZE5rf/yCsK7CZvd2yscwGYRTKBrXNz4kclIkPbSA4OX56ASZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ey04CRDOBDBiM+CEkBWGNJ1jBopZXpl9SjVmQkFVno=;
 b=eysT9b70ElI0wqIL4HKhDX8oN4OSrEPgs1u3xSMcCDtyTx8/6gQvRo9gHM75UiF0MbLpNnRXKjQ75+BNagvsBhq9tQCtOd9K76XB689TbNfieQVluuIgJ4fNrBLRKyEsEYKm0V2X2XXaRrupsYPaE/FqEoXk0j0kH3d/Q05W9ERQFqrAMjNseiu+yefyHz8HChgiwdbg+GyS9lmYrpUlg/fH9mfFNRF6ikFZy5nB1MHxIGJjkCn+B+Fk7HXqmr2gc475vqGS8kuFPEJvCBVa9+0rKtBdHRP65xNNeAJcFBa+O7ekZFb1eNk5hbB8I6ilvJ8EMDOm4BWB7XHiqMf20A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ey04CRDOBDBiM+CEkBWGNJ1jBopZXpl9SjVmQkFVno=;
 b=Y5mouyoQId9cdBrIu0+2WicwpIAssxXCQzteNhAoVPKdVMofXhewc6MOy9OgSvpt5pi6p4RAe0vpoDnKKBNeG6zuXa3jZmtEQpasdbHAH3I4NUBFNZaGIBy+pp43ZRv3C1h6oHOPphZ4k1A5XzuAdwnKkhGtQCGI3Ff5YGOUhZ8bhb8DCHDPubM6OgK6cRDPWcBx2PYV2ylp+5juefMkoRj3e+H5T2Wr53kqYTs6BX14v1ND99CewWdN2kw7nGn7z2ePidqi+gLF5oJLkD708FC0KyRVOiWt/2NfAoZv/QcbX8aH2KBV8i5wsQ7PPM6AmfCAsI+BydkNJ7IuGMOXGA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQ1PR01MB967408.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:b3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:31:58 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:31:58 +0000
Message-ID: <3cb19d75-4269-467c-9d58-6c3ec26abc3f@efficios.com>
Date: Fri, 13 Nov 2026 08:31:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/29] sched/deadline: Rebuild the root domains'
 accounting from the task list
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
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org,
 Qais Yousef <qyousef@google.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-16-mathieu.desnoyers@efficios.com>
 <avR6g-ndjl8Xdo1y@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avR6g-ndjl8Xdo1y@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0086.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::25) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQ1PR01MB967408:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a4d2174-806f-4af8-5ed2-08df418a7dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|18002099003|22082099003|6133799003|4143699003|56012099006|10067099003|261102123227099003|261022105027099003|261026121527099003|261022075727099003|261028144727099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	jCqbnzTefe0syRAaBPl0Qc3uYwUtoKXlJfkNAq3HaoiVRTKBHCH3vo9Jcgqqi9oDdPcKrWI0Amz87yG6JO2SjZ2QANae0Yh6A3FQ5ISoNUMOhg5PPL9OrQOSeRxgsRB+hXSfFrjzOagsjU3pZgv9Ht0wPFjjAvCwhYy6lufTAsNyJseesOVXBVXJfAOdb+WfZ58L7B0LFW9rklSc/biWbQE6I3YAkgRas9/pGA3SCK75Bvqi4DIRmPjC6bYxBhRRpneOSo+Q1N/93WbHEojuLw0Vgkvzb/GmeNI1AC9DZ56wapDRESsgz6BiyaJmC2WriTbAa9NUwTjT1ObuEjjghOgcTA/2Kqr6TFD0KVwWhjeiHbZt59ZZ6097dAiJ9u7dM3UtRYBJKy1uFEwtjMzRBk0cI9sUFmOu4pnTY6NVddCGD/qR8iasAgSq4SLK8/abDEtuU0SpZVTJ5cQdFX7w3HgGvR03Zi0jcD2AW5WVZydNOfm2Yc8Qq0gRETtV3MEhZVwG7Lh5QQio+QM8v0iMcTplm2hSM/2L8S1sB7gjteteqCdv8/t7+b6m09iAjzyioGrlfzq/wl9vacgOJfK6VAojH9ArhZ1PuzL9rBdPjuY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(6133799003)(4143699003)(56012099006)(10067099003)(261102123227099003)(261022105027099003)(261026121527099003)(261022075727099003)(261028144727099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0hpY1d1U09tRzV2ekFSOVhPbHhxWFVOZzB1d2xSYlFIcjlpenRXcnFuQUZq?=
 =?utf-8?B?aUxhcjNXbW1NVUMybDgyWTY3SW1OY0ZiYXR3ejd0RGlHYUpCWWJ4Q091WDZo?=
 =?utf-8?B?UkRTYXQ3elo0NVNMUGZPM3NqT3pDZnQ1YlZrS0F1S2NoT3BwY0J5ZG1EaGZN?=
 =?utf-8?B?R2RGc2pOcFcvQUg0T0laOUtvdldpWlVGL1J2MDJaRi96eDh2d1ZvK0Z0dlN6?=
 =?utf-8?B?NC9yNjkwNzBkYVc2L0FLOXFoeDJNYTN3MTZpVEp0T2Z3UzUyOWJZWEF3WXAw?=
 =?utf-8?B?Y1JYRkJlcG8vT1lnSzUzK3JadTl3OEl4eGJpeHBuZTA4VzA4cXBoWmU3TWhE?=
 =?utf-8?B?d2llR2tDRWVmMmlkQ0VWQnMvVUFZc0FTOGZncWJFZUEvUUJKU0E3TjVmQmFz?=
 =?utf-8?B?cTBDc3Y0SGl2L1dSOHovd1dyMkpFTDZyblFxbDdnb25GOFpRRVFSWGtnQyta?=
 =?utf-8?B?a1MzUE5ZdTJITmFXcmR2QUNUdlUwY3RlMHVqTjFGK1ZGRmd1ZUpsZHBoSHFB?=
 =?utf-8?B?SU1vcHlCOHg3SERPbmx4R2lUaGZkMlJGN3AzUHhmMjc3S0VLMzFESExmYm9O?=
 =?utf-8?B?TldMa3hsZ2h3bm4rN3NHTXlsTUtlUGVoM2FvMU9GVHF4OE8vTUhaUDBJL1J6?=
 =?utf-8?B?QnVtRTB2dUlJWlZEakw2enVrYTQ2bDJLQXZrQU5kME5IdkVVWUNybk9SN0hp?=
 =?utf-8?B?WXVrVElnaWFudFlncVhNTWlVWjd0OWlqdEY4RDU3bnc5UTl4S28wcmpRVEkx?=
 =?utf-8?B?bXVXS0ZIbUZqdzkwSnFaS3IyaWhZdkwvRmx1bE9URWxSaGJBdzByZG5mK2U0?=
 =?utf-8?B?MkxhQUhlU0NaRDRCdHVzUlRyaU83K0RaOWtYSHhzeXRqMDJxbk44NjVqRDFN?=
 =?utf-8?B?U2hzV3F4dVVsdXFEWDQyQVR6Zllvbk1JVkJ0UTNxa3J0OVVua1ZxaWdtMjEx?=
 =?utf-8?B?QU5iVXd0VWVlRVNrbUVjUkI1N21hQklFNDI5Q05XM29HMDBiYVdRblA0NWN5?=
 =?utf-8?B?dlZKdmxNOXRQVDZOYm5QNkF0SUZiQWs2MkVPN05UNHpQbmtGamRhMWI1VEp4?=
 =?utf-8?B?dThtdFlrbko1YnBsY1VqNmxUYmRlRlVjSFZ4cXVRRGJhc0V3bXdiVVYzRmwr?=
 =?utf-8?B?Y0dhdHZlaFd4NndWb2Yyb3RYNnNBZzJ6b2FXK1hCTExTeTlFL0JFaytXV1Ri?=
 =?utf-8?B?NTI1aHRGcSsxWmNiQVlaN296Yzl1RDlSSW5TU0t4dVF2S0lzeVViV2ljQmNE?=
 =?utf-8?B?T2JCZkszT1dNQXZ0d0paWHdISldPeGlUeisvRU9UbFZpSGtGZWZjWHZ1OUYx?=
 =?utf-8?B?LzFqM1ZNQnhwOWczOHB6UzRkOTlLU2w4L0p3NWVSMmkyY1ZkYmxkendBS1l1?=
 =?utf-8?B?ZHJIRDdWcmZYb2g4anRnbHJmbG45MEY4cXJwNmU5TGpQdEFOR004NmZubWFm?=
 =?utf-8?B?MEpCVTlYWENmdEpuZ1VzRkJuZ21TeGx3ZHpyUkdQcEFXSG9CYjR6YTZDOTdI?=
 =?utf-8?B?ZjBVOXgwRSs1U0txUFRpU0VKMEE0MFNhcTdoRDBOU0lQN0NWSmliYU9STUI5?=
 =?utf-8?B?eEVHQ05xSy9COWsxaElRbzR1K0FEcHppV3V1TGc0Q1ROTlJMMXdwM2ZBSzNr?=
 =?utf-8?B?MUVEem1hSjJEVEtXQ1hXYW9DOUQ1dlFwc2ZzUGN4Y3dZQVdrQ2RGU2pINGhJ?=
 =?utf-8?B?Q09NbVJ1SUgzSUpTczYwZitWY0Q4YnRZcjk0cE5vOFUxdUdtVW1wVnJtN3cz?=
 =?utf-8?B?U1hMaHo0aERZRmNKcXVUdlRVN1VyR0cxc1hYUjBDV25ZNEVrdndaTE1nTGRh?=
 =?utf-8?B?TUUwZE9YcW1YZUhqdURxTy9BazJHVXBZSTdYQklienEzMFpTYm1VWTZrVU5s?=
 =?utf-8?B?VkpLaU01UnJIbm5FM1ZTcU9POXNtRkJlRGZXb2FYQUlSOEtYcUgzZy8zYXlm?=
 =?utf-8?B?bzBkOXh5Umg4cTVCbnkzZ2pma1pIemdpeW1QNUJDdDJSQVprbFhVWVRFcE1i?=
 =?utf-8?B?R3JVWGoxdHU1T1BZTVVwUkJ5akZIc2ZpL3B0YXA2WllSNzFIdTl4VE54OWY2?=
 =?utf-8?B?cUpvZ0syN1FMNkpmZm1ReFRCeUlDekEwYVhubVpNT0pramNxWVYyZkRTQU9X?=
 =?utf-8?B?Zmh1aENXcUNldEN2eE9jWmdEbzBaSnVZWmZjVXNWZXJjaTBBbWF3YllmNXF6?=
 =?utf-8?B?TjZnb0tick84aVQ2RHlEck9mSFJyVTlNWm53c3hDQjB6Tk5xUEFNTFprT2pt?=
 =?utf-8?B?OTV6UWJrbEVnLytrT1I0YzI2MU82dmRweGxOVGVxZzBWSmtGdlNjNnYxd1d2?=
 =?utf-8?B?ZHpXY2ZLNzlocFJhYis1d0NoaXdCWEEwUmRRVHp3K1I2YjlhbjAyQmlVTEx6?=
 =?utf-8?Q?4g3zx6TYXAU0JKSo=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4d2174-806f-4af8-5ed2-08df418a7dc7
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:31:58.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK6G0zONSNqnDegR+U+ix1IuUySZNR5BfvB/e4KnU8Ctea1NaLhilQyt8C0klYf+OvKYx2m76a6unREUXaru8JgXycLkjmiAAFZgKcsmOYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB967408

Hi Juri,

> The new walk drops the per-task pi_lock that dominated the old cost, so
> the approach might be OK, but since this is Cc: stable and will
> eventually reach Android, maybe someone from there can confirm before we
> pull the trigger?
>
> Alternatively, a single global "any deadline task exist" bail would keep
> suspend/resume free for the no-DL case without reintroducing any
> per-cpuset bookkeeping to drift?

You are right: the walk costs too much with no deadline task. I
measured it.

The test runs in a 64-vCPU guest with no debug options and no deadline
task. A process holds N sleeping threads. A partition root is made and
removed, and each change rebuilds the accounting. The time of one
rebuild with this patch, in testing:

   threads    one rebuild
         0    0.04 to 0.08 ms
      1000    0.12 to 0.17 ms
     10000    0.7 to 1.2 ms
     30000    2.3 ms

The first three lines are from three runs, the last from one. Upstream
returns early for a cpuset with no deadline task, so its rebuild does
not grow with the number of threads. I did not measure it.

 From reading, a suspend runs one rebuild for each CPU it takes offline,
and a resume one for each CPU it brings back. With 8 CPUs and 10000
threads that is 14 rebuilds: 10 to 16 ms on this host, and more on a
phone.

So the planned next version skips the walk when no task holds a
deadline bandwidth, as you suggest. It keeps one count for the whole
system, and none per cpuset: the number of tasks whose dl_bw is not 0.
__setparam_dl() and __dl_clear_params() are the only places that change
the dl_bw of a task, and they keep it.

In the same test, a rebuild then takes 0.03 ms whatever the number of
threads. With a deadline task in the system, the walk runs as before. A
test on an Android device would still be welcome.

For comparison, the single list of accounted tasks you suggested on
patch 13 takes 0.03 ms in this test, whatever the number of threads. I
left it out because the rebuild then runs with interrupts disabled for
its whole length, which grows with the number of deadline tasks.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
