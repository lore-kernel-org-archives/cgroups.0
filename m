Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.127
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794250563;
	b=ICe/ozRj5PzmXTFvh5V7Bu3diqwo1f+wUfmrQXeXcpytv/r7IBYpfyWTWmy0L1zIxt7q
	 1jbgLVJk/LxM6lVBN7Y0mpmBIDgIc6wXTsgwcAfsOeFZv8KU+8tsuZPUxr2DYPvzkSQ8e
	 7h5a3LflFcEfvW0mcgHc/OSqAFGP75hAVNWePVOzvzaKq8ja0MRNsG+DKBgHUOAyu67H1
	 l42MgjGMl1zF3FSMprcEiWnJ6veWTNz3WwTs4FLm6NSMo4RBIRqZDxZ8FoY1Q7GEOXsrt
	 pIzBnXKhNhC1t+pYmg/4ezXv9SWdMv7IIJQKhrQogqutcxvCP2L+P473xeTXbHSgRAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250563;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:From:To:Cc:References:Content-Language:In-Reply-To:
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
	bh=s0tk+k6veTGxTgDsZF9uG7roBgJrqasWzy81nv+LlEU=;
	b=XuSXNXf3u6RGJnT3vOUgm20l5YuIsIfdnPfRKtsqH/zByiZacMhunKVCCsLIrhkMFL7F
	 m349N0l0yfhDq5ZWvHtZX4Q13ukMFs4+YluKAUUYwJtVFSjEvmTQp28sUNCHyMN8WAQaG
	 naerwT9Cymh+PT72dQcUzoPWNj4BwcTfdrva2AsyOBU1i57qpFVbvV0Grj58mySx9i/Ii
	 0pyLRzG/nHeOI5AdX5ws0aNEQ2OYKKJBPeoRjZ5GEqFegXm/fkb/cxEjSk2sQaCTij4Yh
	 xhz92n6eDO+M35pPcr8zmDDdu6Crn5+pRQ7HdUzeuyGGL9oTDePnwOK+fBFqmnW3vhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=ezwHfReA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.127
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020127.outbound.protection.outlook.com [52.101.191.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27200606A31C;
	Mon,  9 Nov 2026 18:56:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27200606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=ezwHfReA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ox/9M2vPXM5MULttUX3MpL8Ss2OI7DTjCe/Fd9cegYkwyynzXEvx94GITfLoTRArvO2jCCmeAtONRkY8AJ58pixQcAGnPvPHbTUlD+MJK0t6Rpfr/HHHuRVjQ3W12K5XzWLdlT7jUT1iPKOQrMer5mjgeqh2W1+5cTYmLyMmkbbfNebJyC1vlIzdoTMNVUIRuD2wOYpjiip4Tkv00khZXmpd8Y3EEnIzfay/S+N6dWSugL86DsSRCobyqUUFbPGr9LWhwq9YeihN0UuV+ld+npxUnYkSzSSOfOTryF/OeThILXuyyWCRom1w44YbP5lX1Qo8fEcmXqQNyf1IvUNgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0tk+k6veTGxTgDsZF9uG7roBgJrqasWzy81nv+LlEU=;
 b=KEn0qvPhxTiRRGan4PhXeaN5o58bQGRVhlCYXE0/SSe1dYDZLu6LJK/ajbS7Fo6WnSdSVZdbkv8a9Ke2lx8nyxaLRWJZQoQBypM4Qb3maLlhww1+tnxWaeEmUjJNRFyXLpRAL+F7yevL/cCDLozDxfP8e198KLWgXy0BeTORarSaynhLGQbUsxPWDypjbt966oBLHsFV6q9ROsz4X2QwxgJ2hqTjJB9FR9PKHGev7n3yT5lWakGwYmZrQvg+ktRYOEx+xt7xkVWwVNS+uJS3ExTPAIU4kCVnXbXtGvNa+YZ1gJMFDLZzHPSeT7xQJhm4YOAYxtRuIoH1JJIC1cHHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0tk+k6veTGxTgDsZF9uG7roBgJrqasWzy81nv+LlEU=;
 b=ezwHfReAQkkXzTu4tF3TledB4FvYsZJeVp3Xm3BIliA8rHl/QqP3XNTOl7pAG2fEWIgQYqat6T4XE9g0hcDZ3pCqkEcOHgE1F6b9BT4LVNNeq9J7FSgYSuftLfxPrpxipNxF/x25DZ205Vf6LTa7DRRCdY6B08F4z1f0DiM70oWfDG0tl9gAIU7keux6juo8+yTOyRQW9H3adaqqCvYNRhYfioMBK4vRf0e1BIliejzmvyzKE8P/KDbUNmV6eSBPMkuubmNOOKr//t4W8TBBLlmTorsVmHLp7VgSIsIOXfa+31n0Pn3Y2aG2dempHtRo44kx0HC2a2Q9J8upvwCHXg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PPF8EE490D48.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b08::462) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:55:58 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 18:55:58 +0000
Message-ID: <1ee6d971-b48a-4f7e-b0d4-b500a6fe1f5c@efficios.com>
Date: Mon, 9 Nov 2026 13:55:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/29] sched/deadline: Do not lose a throttled task
 switched out and back
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
 <20261108185406.1549770-8-mathieu.desnoyers@efficios.com>
 <avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb>
 <c5a408b8-1388-4dcf-bfa6-bc987ce83fae@efficios.com>
Content-Language: en-US
In-Reply-To: <c5a408b8-1388-4dcf-bfa6-bc987ce83fae@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0332.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::18) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PPF8EE490D48:EE_
X-MS-Office365-Filtering-Correlation-Id: c23dfea0-305b-4f6b-d179-08df3e93172d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|5023799004|4143699003|261021121427099003|261022105027099003|56012099006|261021123027099003|261026140227099003|261028144727099003|261026121527099003|261009223027099003|261102123227099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	JeEOM/Nz7X5WGAdusui83fU5VILy8w1UxOO7yBuF8WKNWGVlWX1PcCOcMR8mGGUsLd5z+tXPCzg3eJwat1C2RH58llZ89leXg4MktkU1P39gEGPO7hSDLfRvjAPVkdULeSOWNz/N9bo03PBjDkFLHd6Vs+QHwK/wqSDEj03GjFpoqCW1GR+bv32Rwe2aJk1dzm8Vgfen23eYaN7j7qKxZ1zUXsBwN05DgxhyfR0ekykYRrfyxiq185O2YCP/LkV8rdMdMZSOTWID64Nk74AwNALmxuIDcKtEznqb1k3AYVkSHWJ+g5DBJrjsPzgxia6ivd+scQsxjxxlA/u5hyV+hU/55eiypzNZ3ebPOeegyqqleqOCheKvIDGUEq9YvWWTLmA4pUYDXlx454lKmYYeUMEpE73AQ2zpRVHlGSTUAxh+ol7CHZlQkXtcpbly32zEiGNf6bA2A08AB1Fle43bJNdbEd/9HsVjtkkorNeWyLmH3nf+27IH5H8iMXa3SQpiGK3fXtcPda6DSViSl1wUe4Ec+BsOAkb6EyMdVJ8lc5QEfrfQLe6Awxx4rGT/NEp3n8TTL1+1TtJ50c+gxBfJE6hwUypUY7aykdIxT716VzE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(5023799004)(4143699003)(261021121427099003)(261022105027099003)(56012099006)(261021123027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261009223027099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3VBcWd2THlFRkk5NzVqcjdYTlhZL1NWT0Flbkp5ZFF6eGEyQ0hlT2EzQkxk?=
 =?utf-8?B?TG4rNFFhSnVpZTdpa1lvbElFRVg4WnMwdjJ1SitPYkZtanlrZTdHQzhpREdn?=
 =?utf-8?B?MUphQ2VodUsvVDh1cFgvUzhQclR1K1JaQTJDTGtaVHdOZ3UvQ1ZpZnU4M2ND?=
 =?utf-8?B?R21TTm55akNWRHYxWHo1MmdFaU9Va2x4OFhUbmk5c0pjWWtmM3g0UGpldkF6?=
 =?utf-8?B?Wm1QcUFoRmFrVlN3MVVzMWlEZElFY21qcUxhcGVuYU1JRko4cHRQdjN2RzhV?=
 =?utf-8?B?WjJZbi9HZFJpRzhSRE9xR2JDK1E5SDBaK21jTWVTTTZTRC9nOGhuVHg2VmRX?=
 =?utf-8?B?V3ZnR3RnYm4rUFpxR3N3dU8vZDcyTDcyeXNCdy9hLzNtcG5QSnJoRzhRaVhJ?=
 =?utf-8?B?NjZuZUpxbGwybkJkWmRiZzlmSzFzell5clpyckN6SnVweUxRV1hKbmxBeDBG?=
 =?utf-8?B?UGovTERQVmdjV3NMUWI4Tkhyak8ySWJETnZFSURkU1JiYXkrT29LNWxPV2lR?=
 =?utf-8?B?YWZ4VHpudnU0d1BCRVM3TGRmbDBUUEw4UFZxYUlkS2FPVER0bk4vbCs1bWRD?=
 =?utf-8?B?L0dLTEhJU2pxQ3lVQ3BTUUlNTk14c0xYU01tQ2t5ZVBvRi9wQVYvNlprQWZH?=
 =?utf-8?B?NDBQUTgwcjNjVEpnQUFZbjhrS2VUSnJ1Nk1XYmcwejdDaWhqSEFuTW5aNHZE?=
 =?utf-8?B?WVNIQ2JkdXhvcldzZkRLTTNDNkZZT05SZWxzRFQ4Y2hyMnJHbEJnQVd5bndr?=
 =?utf-8?B?MzRWc2I3YjdMVnhZRE5pbHY3dkNyYUlDSTFxZUx2cWJFaG9xdWtVSllvOXMx?=
 =?utf-8?B?eDdwKzh0amh3cU9uQURxU1NGaEpoMjRVUzdjWTVqUGlrRVVlTEZ2S2grVnpr?=
 =?utf-8?B?MmM1UkpVajExMzZoMEVBMCtRcDJRSEpIS2hxSGliWXFMUlRjYncyL2VqV3U5?=
 =?utf-8?B?Z2ZlZ204bXZ1ZkY2SzdsTGRKbk5DUGVOUTdRZEU5dXhRVDNDZGdkcG9IaHRq?=
 =?utf-8?B?akx5T0RmTkg1ME5kTCtXSTYvMnFjS2xFbHVOOW40Ty9VTU9YcHNxYUQrUThr?=
 =?utf-8?B?VVQ5ZkFma2JqZXZ4K0FtTDQ2MjVHUnZLbC9oYktmWWw3QVl0Mmhnbzh3Ujl4?=
 =?utf-8?B?UUJ1VVRFa3FDandBM0hDNWZqVTgvZHEzUVEwaVpwS3hWQTlyb25jMlJoMCtq?=
 =?utf-8?B?RWVEQmw0S05Cb0NyRU56eEpHV3JYajJuYy9BN0tiRGhOSzh5cU56QkVUSUds?=
 =?utf-8?B?QUVEQ29OaHdFUk8vWSs2VzBMaVNoRTk3QWZzR3FsWEk4R09Ia1NQRzlSek9F?=
 =?utf-8?B?UkdmcTQvWDg4SXhPZFVKTkJkUXVwTzljMVVrM25Xek9LMENHcG5KKzVmNk5S?=
 =?utf-8?B?cXVPMGNoNVB2ZHpXWllmTkZhNkpwMGhiRVlEUWJrN2FDU1NWcmFheEJHeURa?=
 =?utf-8?B?WmRucG9yTlBvTk1SSXg3bU52T09aaUVZeUNhbVBSY0NIQ1FOeklMUk9kR1lN?=
 =?utf-8?B?UkkzSVBDN1NDcW9MRC9NY3k4Y1J1cXlieDdOd1VzaDBwQlZkMVFwMldaVWli?=
 =?utf-8?B?RDdFUTBFMExEZ1p2TThjNmlBaVBtQUgzZm05Q1hicWlYQ1pzNkFKSEZKbU5K?=
 =?utf-8?B?b1B3bTgxOFRuM0hoOU90eTdmclhHcU5zZlhMbDZCaHg3bXBIL3VlTlI5T05w?=
 =?utf-8?B?QWdMSytOMUhCU3JQSXdyZTJKUlRzdHlJY0JjN0ZyTzBYNUZibE9PQjRjQjlv?=
 =?utf-8?B?a2hBU2NiLytiVDNuY3lBaHV5ZmhZZnJ0YzQvZ1hEWU5TM1BBK2svSnBIalRG?=
 =?utf-8?B?QlozWGNzcnFyUTBLUjFaTTlxdjFPc084TExVZmFmeDhyK1YvQ0VkVTdNS0pz?=
 =?utf-8?B?d2luK0VvRVgwb3JsMFFDRzdmTWdUQ3hRMlM3NUI0MTZMcXpzS0xIV0FnYUlx?=
 =?utf-8?B?Q0M2WGMwWGRnUFV6WS9hWVpPWXdXUXMwRkt3TWVGVUFUN3owTk1OaFMvZjM1?=
 =?utf-8?B?VXJxdmcvMW83c1hYYUdBVlVIei92MlBHTFFELzF6cFNDWlZ2QzNwK0UwUmZm?=
 =?utf-8?B?RzBZQTBBbGFKanhoWFM3ZG9iOHI4RHdjNHErNSt3VWZTbm1VNFpqOFg3c0Ry?=
 =?utf-8?B?ZGJNSzlxYnlMQ1pXL0VPb2dtclpWVnRTK0hDYTNzWGY4SFFSREFnNzRjMWQx?=
 =?utf-8?B?Qkp4a1dmNHNsL0RkM2w0TkdaajVoWXBla25ybCtlQ202WG1XazFFelBwcTI5?=
 =?utf-8?B?VktIenJUUHFGMHZWUlZEYktQcGVkM2Yvd0tTTHFiWkxrazFzTHR2aHRyQVRu?=
 =?utf-8?B?K3BMT2JhNkd2Mnp0cjZVTjh3VnlDejhtZlNaMlZyUGdPVXFOM0FoZzFpNlFy?=
 =?utf-8?Q?Vt6xuff8GzxIyuUtZCSbpzIdyGJiJikaKHZz2?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23dfea0-305b-4f6b-d179-08df3e93172d
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:55:58.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvNyHc75JrPw1BhApeihA/bFUBVOGNNj4yBQbZFw7yIMQMe+Z8OT6PJZxLOX4TdqJbzMk+vLfk8mCPK+TRAYS+XGG0apP8XVwZSouRTZSKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PPF8EE490D48

On 2026-11-09 11:29, Mathieu Desnoyers wrote:
> On 2026-11-09 11:05, Juri Lelli wrote:
[...]
> 
>>
>> Still have to review them properly, but between 09/29 and 24/29 I
>> believe every return at or after the 0-lag time is now covered, that was
>> the bulk of what I was "seeing more of" in my v2 review.
>>
>> What I think is still open is the other half: a return before the 0-lag
>> time, with different parameters, where the budget carried over from the
>> old reservation is never validated against the new one. IIUC that can
>> only buy a task one instance past its new admission (it converges at the
>> next replenishment), so it should not block this series and we can
>> discuss separately/later on. Just mentioning here so that I hopefully
>> don't forget.
> 
> Your insight points to a coverage hole in my proposed test cases (last
> patches of the series). Let's see if I can improve coverage there.
Hi Juri,

A heads-up on the case you pointed out: a return before the 0-lag
time, with different parameters.

It is real, and older than this series. On v7.4-rc1, a task of 50ms
every 100ms came back through SCHED_OTHER with 10ms. It then ran 39ms
of the next 100ms. If the task is asleep when it comes back, its wakeup
checks the runtime left with dl_entity_overflow(). If it is runnable,
nothing checks it.

The same happens without leaving the class. A runnable task that
shrinks its parameters keeps the runtime left from the old ones. Since
40767b0dc768, new parameters take effect at the next period. But the
old bandwidth is released at once, as the XXX comment in
sched_dl_overflow() says.

For v6, I plan two fixes, after the current patch 27:
- 28: a task that enters the class runnable gets the wakeup rule,
   update_dl_entity(). Fixes: a649f237db18.
- 29: the same after sched_setattr() changes the runtime, deadline or
   period of a runnable task. __setparam_dl() sets a dl_new_params bit
   for the next enqueue. The enqueue flags cannot tell this case: a
   cgroup move also uses ENQUEUE_MOVE. Fixes: 40767b0dc768.

A task whose runtime left fits the new parameters keeps it. So it
never gets more than a wakeup would give it.

I also plan three deadline_bw_test cases. return_running_new_params
and change_running_new_params fail on v7.4-rc1, and pass with the
planned fixes. return_asleep_new_params passes everywhere: it covers
the wakeup path.

Patch 29 changes the choice of 40767b0dc768 for a task that shrinks.
You may prefer to keep it, and delay the bandwidth release as the XXX
comment suggests. Then I would leave 29 out of v6.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
