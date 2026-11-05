Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793898537;
	b=B/r0VkkMn+z7mJ0Lh38+cythVfqMWd2eEsYSCEPqPIJJ46tYXsymrKpvzdCpPNyu5VFg
	 HuirdITJvxLbE2Ib8cTFvUcuZY8lka0XZ6TMIGbYOgWmnFtQBxHwLcV8MPJe3SukIKThN
	 1Ji/bhuSY8OJgu3vYiGJ0BPXj5Qx6bFhevZBf+abXjPA1I1AD76AW4z2Y+R8w0qihQKUK
	 DG/0niQn4pv1zegPtJafIXpoNX9rjy291thEDWZ1NDYgchYPZREWUzlxtZKRiJoqsPmn0
	 kkC3wABwTW2u8CY+RO4DIMmxA7e0IHPdznfk4PTACkGTV+1rIR2u6Az7Nz5y189q+YQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898537;
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
	bh=x8/hXsDnxgKObn2Q6O87HYkWJh5oPs3+RGFUERKtet4=;
	b=ojqy48cw8ItBbxWPxgv9PEWtt0iYoOQcP4m6nvyjZJZ8/uOr0agoBQ1UjpU/+K0+2HTp
	 TpCzIKYS3OTCG0gUhlhSuRw5TrwZ9/0JCDbBTqhsqJAZx0d+URLUrwv78VMn4YlrXmWZm
	 mr3MUWAGRgKgV4GZDof1V36jDzR+Aw34fIQhPkZyuxs+qdXm+Db+D4RcCRyZ+2AB4uQqo
	 lNx8Eez2DRiWy3udcQtMy38o5I7z8dez2EnWI034E54rQ17W5uEGLD3PnxdkUNvCdOept
	 Ucl3B1b1CiY1Mzmz+adbFWxEq7G0ZRaXLsETMt1BIsdD/6U2GAns1sFloU0kAyDuo0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=aP5PRGoC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.74
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020074.outbound.protection.outlook.com [52.101.191.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D988606A31B;
	Thu,  5 Nov 2026 17:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D988606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=aP5PRGoC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtfokXw7RlB0Kpd3aKaOzliJwWbCW/4DXnc+GFYFF5gAYuMgAPHcY0g/7D+EgvQ8RWdIEU5DGHzaWqy4EZ8jIkUjo0Y/40SF8pV2ZyzrJ222L5LKzprzyEe5NWAIzrJYDW1uw+d1nj4qCh52eVdi/1a0aRKUjdGjkw3sWUi6eWnxCjRqyuKt4AUPFMshHUK9r9PwbQWbJQvnj0KVCnpMTeR+lst8lKLYRn13kc0+lKo7uoG6O4rgBWD/U0T6a7THpd1xyISL2DBfpUj/8sXQQutn6ZA9Q3NWYS1WujqZYzFZNo7NJGQOzvn0+CBOv1C7NOhoz1eMOoo7b5Scsscnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8/hXsDnxgKObn2Q6O87HYkWJh5oPs3+RGFUERKtet4=;
 b=wyzcwWCuKiCqNnJRe6hyiX6vp3nFkNT35xpWpDqZEAuBVxMVrLE8BbLwReejiUciipVnZKi5XiIaYRjYLf/1rq0+7vGO0psrN4Vq+zcgDqbVF+hsBjPQSSCdq6EbUBSBCuYG+LcWN7MCQHTbKsBNqdATOZ4EwG4zVghDDITmKcRFK8LQeZg8WWtygNDmevJ2yAyYS9SfNT1w/GYPC8pV2Fiuf1ETIzSZYd/7bb6tmveainJaT2eksu8U3a9/XIY4XBHoKQZuqDrbKziBt6eHsqm2JxQ/GtH5qTVHEE7d77tLoZOlTxbAVzz0QrPu/4b8w95EiHoZcs782mYOs74adg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8/hXsDnxgKObn2Q6O87HYkWJh5oPs3+RGFUERKtet4=;
 b=aP5PRGoCQvrxKaBab+BJJqxT62VSw7por4GSlJq/JtBCMJ1YwiCxOmX3nRBGUEdFLJHsO4MlummlVKUZ48vb9hykLITDSYz59rCAob8hk89mUhSNfD9odxGrE+mzQr6soWKErap3e6Fh9CewiWPLs0aGp7e0pvAiRzGkJmTP9NsC0ZpyK1+EZ6kwoNfMyksn2uUTN7QqRT1d1l3dT1f1Q/zBj0yFix7t5bQuy7/buEO7oy8iCRyg6cxkLLlH23fyI3wDew70AgbIMGvXmKZuJsHT8aT4W/iangoV7KUryp9YDGgEDonKs1yVZC3huGrH4axRSa4sHEMADinxQ5/0dg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB6339.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:67::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:08:51 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 17:08:51 +0000
Message-ID: <a63396b0-9b0c-4d4b-9754-f503cdb84098@efficios.com>
Date: Thu, 5 Nov 2026 12:08:50 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/21] sched: Clear cpuset_locked where the policy
 check retries
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Luca Abeni <luca.abeni@santannapisa.it>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Kayra Cizmeci
 <kayracizmeci@gmail.com>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-20-mathieu.desnoyers@efficios.com>
 <20261105164356.28913-1-parri.andrea@gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20261105164356.28913-1-parri.andrea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0173.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::16) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: 091c211f-50e5-4b3a-0c19-08df3b5f76ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|22082099003|18002099003|4143699003|261028144727099003|261022105027099003|261026140227099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	FJcLt/FoxTijC6aZKcnYhHVF5XpCDggVJZV1izMosi/+n1MTS4N8h5wSSWSkp+GiNJCLf8SzuFYCgHlpMshR/CW2GDrOyQkhPCNAgBA+yHLMRaJ1tcjirtVyWPXr9AWUxgrubTYBPwuURDMZ25XnyChj0NxDyxhAZAn7tBA/ZbSMH/CouQl0DnUr50U8z3L7t6PoNfu4by5+o5lmIj9Oo5V6oiuQulZCKI9KA7Xps1wVnJ+Uplj3ca8x8GlpBa8hOG2pHQXVF9svlSs1xtcbNCVL1DpkWKqQOjKyTVwfYSgPKOKzDPSR9TrEORmW5FdxCDkq2gr0MMGqVkcUEb3vX5wH+K2hkV3NiVX54SVkvUqaabW7YPbkxti8tzW4UNFOU6VcVXJTs6R4gWg6zjou8liAlq5lzFLaB8bolxU7Pl1pY8XQkJkyeksksER5H6zZ3uwEbFudK0YXNtRMO3PT+cv27nyQIj1cUaT+KeEc5358wrfaoDQv0hQhJclKV56SnXunEExGjav0TAu8rFLqI01HyrHCR2pQRF45ARPy1KVzrRKakrPd8eRH9w5o8Mt9AUKj5bi4YR8VzfR4nIK+bhdyKsFiYJUiLTNoj35CG7M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(22082099003)(18002099003)(4143699003)(261028144727099003)(261022105027099003)(261026140227099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0k5UWh3dkNtT0JUcENtOFVxSERxNWVmN3lqV0FjOU0yK1FCdktOTHdycmFm?=
 =?utf-8?B?U0pNb1ZqSEl1WlRtTnM1WE41YVZYa2dLWWtmRThLdWdzNVBvejZsZDB5bllS?=
 =?utf-8?B?S3Q4VkR2NnIvVC9CK2UvYVpmV3dEQndzMzNYcnh1OWRnVzY3YWJZQXRDT3JY?=
 =?utf-8?B?UEg0MnRaQ2dPNW9OL0pGWE9QeFlxUzNZOWIwNTIxcVYzK1R1UTdKTmZubGtp?=
 =?utf-8?B?R3orRE1pU0ZZVEVMb1hEYXFyNTJZNXpYaFFRd2JNTTZPOUQ1UngzSUdSWEZk?=
 =?utf-8?B?THltelJubm1kWjVnbVRINDNYMVJEaFovUXJWS01aSHhQbldsdWhUcmRvTXdt?=
 =?utf-8?B?ajNaakU0MWdTUERoQ01aWnprLzB1dWhXSVZ6UTE5WkhtZnFLVGg4SS9EYmVs?=
 =?utf-8?B?Z1p6REN4UFRlb3NHUGkzdWtycXZhTlVVekdPMjEzSmUyM1ZsQ0U1azFON2d4?=
 =?utf-8?B?ZkpFTEQyTFZrZURSVE9CTWNyb2gxekphWXZWQ2kwTDdqZXM5Qkg5RXFnb3V6?=
 =?utf-8?B?QVBobzd5bWpZamVkYXdhQ2xpbmxTZ3dWcGIxeUlpaVI1TDVqcXhmSzFPRkp3?=
 =?utf-8?B?clJTSXNwY3lFZnF4RW93MEw4S1BWeDVGQ1lhbThiN01ESW16ZlYyZStpSzEz?=
 =?utf-8?B?L1NqNnFxUHNId3E1OHQxbTNMNWlEdWJ4dDVhdXRrenB0dHZ4NVhmNHdJUzky?=
 =?utf-8?B?S1ZxODZmZkp3RE1mZDkyY28yM0lRL1ZWcmVFU0NGa0N0a1lSbWU3TWxkUlJV?=
 =?utf-8?B?dkExZGFXZmowSm05TVV1d05pbmJvM01uWU9RYTM5MysyUUdUcWJhVEY1RlJa?=
 =?utf-8?B?RFhYbjRzSDlDZmhXOGhGbk9ybDZaMGY0Nm94OVVibHp1cmdyUmd6SEkrNmJt?=
 =?utf-8?B?VW9PU0VJT3ExQzgwaUVhMnhLcnNKSTRIK3NDSVV3M0lhZWtnNjlEcks4MmtE?=
 =?utf-8?B?dTNYeXVaaDNkR0grbFdRZW9BWVIwU3E3L09sUWhBQlpXZzRjWUV0Z1F0K2Iz?=
 =?utf-8?B?aDlVNUc1MlBGc1c4ME5DRjdkbnNlV1lnYmhuWDY2bnhsbkRVWGI3U0g3WFVF?=
 =?utf-8?B?dVBIdGcxTVdaUmgzdzdxbmJpcmY3d1FkMFFnaTBRdGxSbVlpc1VoRjFESGwv?=
 =?utf-8?B?ck43VmQ5ZGRmeVVVNGpPUHZaV1NHRmdvZUhoaDB4cnc0elZnb0xpOGdkQ1Zr?=
 =?utf-8?B?Rzc3TFVwMFQ1a3NGMVZITTBDRnp4T3RlYzJPWGtTOG95bFU5ZkNiOWxyc0J0?=
 =?utf-8?B?S2JSdjVCanowdXh2dklHNzRIUkQrdWY3UXlqMmlyRWQ5OVN1S1ozSmlUSXoy?=
 =?utf-8?B?dmUvM0FrZ2FaelZNTFVSVHNuY2lQVVIyMFBGTy9UUmJndlF2bVlyNFViOVAz?=
 =?utf-8?B?MG56TEZzbEpjUjRqSndIMW1EcTV0VEtEMWhsN2htaFZFR1hHZ1NHeHNaUjhY?=
 =?utf-8?B?WnVXRFR4VnhWVS9PT1EvdXpSb29CNnN6SVI4V1VuZVNRNXFnZmdIY2l6SHBY?=
 =?utf-8?B?WmhabHBXYzg0aU9oeFZVNEo2YXhOTjBXcGhTY0VnZWlSWWlhUVVYaGNlVnRC?=
 =?utf-8?B?eGV4aFRXT1dwK0xFRVBZWE43dENmcGl5eEF2a1FXc3Q2NUpLVkpYMnhKYVBh?=
 =?utf-8?B?a1VYenNRYWFBL1hhMDRkeFEvNm9MQ1lGNWY5a2NSRFAxelk1Qllzb0dGTDhF?=
 =?utf-8?B?WVNjTVVmY0Z2S24yZDVjaFV3cEVBbVhKbjc3RXM3QkhBZkVnWlNRa0pJR2xW?=
 =?utf-8?B?UWJqSnhzTmlFU1ZPTFcxQ1owZ2pPVi9YTHFVSmFMUWljRm5kOE5XRFRZKzZ1?=
 =?utf-8?B?ZGdKTndLWVhuRGVCSzk1ZXE0M0xSSElMcFNSdlk1K1pSZXRkNGRUNitqQ2pK?=
 =?utf-8?B?Um9pTGVqbG1PU2NmR1lLd1NNRlFjK2M5UTVWb2l6SnVwR1NqSFFUN085MWR2?=
 =?utf-8?B?M1E3dDgwQlBDU05FdUdOcWZWVmJ5V2FFajczamxnOVMyMHBLMWJJdGp0RmM5?=
 =?utf-8?B?cWdRYmJ2U2tpaG9lZ2laSzJqRmJScE1uRnBlUnRPMGIzd3VMbHNMbGVybXZT?=
 =?utf-8?B?aWlCcTkwSzgrZVJPZk5USDd4QlV3d3hxbjczRFBWdTFkN3dwTkFYdU85LzJX?=
 =?utf-8?B?RHp1NXJvejZySzFiZGhyNmdCRHBDdUlLZE5WNytVZjEyRXEzNWhXMFRNMExO?=
 =?utf-8?B?NjRCaVQ5emZEcmx0MCtTTzE0Z1Jld0FBd09Bc2NlVkNyOGtpSEhpc0puZkpJ?=
 =?utf-8?B?UjlzS3o1TEV4dnBJQWNwWlk0bXlselNLZWcvZG1pZEVCWUg5MWJqSnNCNGxz?=
 =?utf-8?B?OFNXSDBZSjRsaExRdGlCQkx6eDAvYzNjc1NNMDdZK25FTWtNWHh4TzVuVXB5?=
 =?utf-8?Q?5bgxz0KDpZJCKp+ra0LPMeKlR64GzM4ZYiB9W?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091c211f-50e5-4b3a-0c19-08df3b5f76ff
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:08:51.5385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye4qYy9c7PfQ2fxWZkvYUw7QE7Fme3TY29QW5xXv1uqxn9Ei4qtjxFSvd8HK4/wMKmvKe05YfOUND05pwp3Z2cmStFM1AZkxzfLuOXC787A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6339

On 2026-11-05 11:43, Andrea Parri wrote:
> On Wed, Nov 04, 2026 at 04:12:05PM -0500, Mathieu Desnoyers wrote:
>> The retry of the policy check in __sched_setscheduler() drops
>> cpuset_mutex and leaves cpuset_locked saying it is held:
> 
> [...]
> 
>> Clear the flag with the lock.
>>
>> Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Hi Mathieu,
> 
> This is the same fix as [1], posted on Nov 2 and reviewed by Waiman,
> Kayra and Juri.  If [1] goes in first, this patch can be dropped when
> rebasing.
> 
> [1] https://lore.kernel.org/20261102134606.242743-1-parri.andrea@gmail.com/
> 
> Thanks,
>    Andrea

Hi Andrea,

Thanks for pointing this out! I'll pick the preexisting patch into my
series instead for v3 if that's OK. Then maintainers can feel free to
pick it up from whatever route they prefer.

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
