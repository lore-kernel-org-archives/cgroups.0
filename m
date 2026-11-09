Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.135
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794250625;
	b=bZrbKsAfgmmn4GwTLT/0HcGRkJaV9nDF4i8STZtPjJT3opcfAOLm7zrq/Yr9FGWrLix4
	 26cRgOlpE7sWdzYPR+kmuu0cskvHYK1TMtmOPLgj2tWmKNPPA3O1gU/VKwZ1NXgaCaspi
	 qq+gxwDd4lck/fuhb73iCv+gbNLn5sSLfx65fFXxF/abjm9SSQjioLvKnsV89bDkfXd2F
	 s0NjewaQuGWwqoEeK0fUWa/QYFVzw8yhT6YW430MmNdmVzlXRDGCA8RKBTjD4ue+4RBXp
	 tN7epv734UcpmG4kfpFMSsNO8PTdookACuDkDStVEXHxdQLJQAd8ZVhhnmbEnowQqOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250625;
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
	b=0na6+IuEWgMZFPUOxDFN68gZahLOgoLrk6OF/nAZGOR8t9PKTUe+7Mf6lc8enYkkgcX+
	 4RBh+vdHjpF0aroogl1XUqAc8DwyYabwNDacj73jrbqejnPR7ehA9dSdsdsnj++IBC5Vx
	 dgCc2Ip69q1dxId3J6Yng2hSyi3U0dQNkDy9Nm70h+CNw+hEF/9d6aA8u2H5RYZ1YR1cr
	 K5LtdaZl0W7I49rInJKuhYnhGQ7034E/eUx3AQ7aygQxHhi0aogfp4pd1cKVs4fsnfrRI
	 i19iwAWlUPPNOpv4VPudPgu6Ngo+myqspS88l+2MFxV4Co6lZTmbs4Ih85QEGx95UvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=kE+KT+sk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.135
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020135.outbound.protection.outlook.com [52.101.189.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6EB606A31C;
	Mon,  9 Nov 2026 18:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB6EB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=kE+KT+sk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpdNje4cBr1mWmRgG5sC7hC8z3gPzi8+09jKky+kAJZMU25QzLfaLS+l0TcS4CFCl+EJmrxR9Qke6420RsixvvKEQQBeZEg0uhv5gvHmwKH6OCQcA/D8kqQ1Dudu6sdghCijmAoldJ2wCUCmy7mZpO2LOl4TCnUxN0pioxXIREmxFsqAMlAI7HDrtxqLYd9zBX6xVJW4BA5YpMCMV9UMYN8wyQIsx2A/mZquHirbdnYwKbi8Pxqrz83gWCTuXaLqKrtOwrfvkBt2FaeutxEDBw8abzKbcy4xZvTLH9XQX0kRkgeIEtEuPTydouqaLxvQtzUD/9ygPQONwcTsOAwlkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0tk+k6veTGxTgDsZF9uG7roBgJrqasWzy81nv+LlEU=;
 b=JdOfydIFhoxs2/JLCBUQoEBghTw6XrXXtCYDHw+POS8jfnATDUJ3Wa4IjKbWUZxWsVilwqAVmoiuMW8s8SLlkFgUJi2eGaj12x0vpCzp6yWXLTVzxioCQbKbj79Ka0i3BRTa84auJOM8rlltWVuL26D8pd130euZjubREHMN4dgmnfqf+MVKAelrdkiQfnm8gzPQais7JwX2DQiMP8G4Qb0nYHGQDr8O1AIxpGzSUsPfj/MYjHgMTLKAO1NDNT3g9fFVGUJLhtIbz/P9QaWTZ63gX8mkUIYbYzQsDSUMtfEifLG1VPvAAPO+ksXUPzTUVl7y49nG4e9tru4uGXTU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0tk+k6veTGxTgDsZF9uG7roBgJrqasWzy81nv+LlEU=;
 b=kE+KT+skTE5MepFjJaAbZAEsaxgCV4QPE6CoIbKd1uedJlnjgXo4ZqB00livnKMhq5ArSC1JqK6+RPIuDCZTOMB/eSIVyWVdb3Wx/9N3ZP0jEw8Hci3vt8LTNrltSuztIiZtoNvdbMhEY//DvsF5cHe1uEHXVLKJJTzAQ+xZzQMt7wAIyERMeaDK6OUdwqQIXZuFvSDpN9djA6pOtebmQ4Yu9kCaNDAZZIvyKIlnjBA1bDrCPxX8gI5ELe6LKtStMaHvmzPg+oJMjDRzxB3HajXJ9OAN+h9ynXLi+YHpmbJRiIirs79YE9eiB4/vrkwbUl/pVSCWKfWVqKw1iupTjQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB9857.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:db::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:57:01 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 18:57:01 +0000
Message-ID: <166d1ae4-3bcd-4153-81f5-a0a5108c3910@efficios.com>
Date: Mon, 9 Nov 2026 13:56:59 -0500
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
X-ClientProxiedBy: YQBPR0101CA0331.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::23) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB9857:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ce6172-06a7-4066-19a6-08df3e933cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|56012099006|5023799004|4143699003|261021121427099003|261021123027099003|261009223027099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|22082099003|18002099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	YdK6GeWwfmmx53PgBVmLwiJCqunpAjyWgPGZ2GHhjwHXqnOR4HqKTrVLCqNlI2wod6bcI/za3Bap3N0T+C0t1W/chj7tZngY8mY9F57W5kl2T9W6uGMiDNQpGwBNREutCsJcXqGgRG2rUEZElMOC5minfkk2OJ9UCBeySPE9XaY1uMBzTYEmTCm1UomwC19UgCfqBBwp2G0gv2UtKYqJwZM9a2/E5NDlmhUzkuTnRWXk2xBqk8NTVy989swg1g/0q4FUCE0aM2IAc6n5WZ6z/xMROg2xlJclBXDQZHYsz6JIhumVasvl0wndbZs/W3jobqbuNfImPkBCjFQPvUjSiUHWxAD/mkcqx4DBGyav0RG2AEBVXVViMnY3MXx8rT2yJ7i4PNwLmFU3SXNT8+uPw1DqpUNrBa6uDkL+YBOrmINp7Jkc76DC+ZfRCr5qiA60QMe0gcbF2EXCNJL/bfxLOLZLWRTM6g7hQj5K6Lq7qs88R0xVkQEg+MG5ItVpbaUWZF2q4oRLkYFokUO1QP6H8VN1JG6w5CtTt4I7Oo3uLySQzhaWImHVXmUuDeaGEVSdaopnJZU53UViLegjy8jyl+MhN+h91L/Bo9ukgKAkGTU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(56012099006)(5023799004)(4143699003)(261021121427099003)(261021123027099003)(261009223027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(10067099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjE0bnZVSVFvcVROUGcrQ1FZWEVxelhNYXZiVXRqSzZaQlJmUms2TVdDcWpW?=
 =?utf-8?B?cWsxQVNwODNFTDVDcGN5a3NUdWg3RWtvRlEyTlg5VFBOaW04NCs0L3p1a2pN?=
 =?utf-8?B?NGpLSkVqUEJHOXMwRDU5azdEL3VLbWlKK0gySUtDWHB0bWZOZ2dxa1lFMWNC?=
 =?utf-8?B?WmY5R1N1OC85cGxhTDNvQ01vaTFjSnFaRnZvV2NQRUFsUmtBMVQ5VWUySkVh?=
 =?utf-8?B?TWlrYzF6TVh4WkpBT3BEdW9ISStrdmxnOW1yTWNRODBXamRoc2RRQ2ZINFl1?=
 =?utf-8?B?MGRtQ1hRVFlSak15aVFGN2grcWx5SWNBT2NxYU96M1A5dnVvR1VzaFdMYXlo?=
 =?utf-8?B?YVhGUWFKZjF5aXFJMk9xcXJXRmJGVUxNZ3BBRTMyZlpUT2dNVmlYZlpqTDdG?=
 =?utf-8?B?dlhQKzFoRktVTENQd3liWUFnZ2IyU051SzNodUxhTlY3WHZDT1ZpOEVyVjRH?=
 =?utf-8?B?eW00a3FmZ0RxU1k2SlNxOUQ5N1FwSHlraldUM01YZTJjT2pwcXp3YnJVNk9I?=
 =?utf-8?B?RUVuVW1QOUlHbHp1WnM2N3JuclNPaU9BM2dXazBnRC9IRXVVT09FTTJUM1Ir?=
 =?utf-8?B?YTJ2Z0x3dDNUbzhGNmdxNHQycFhXZnllbHJidklLaFJSVTBhN0RvUXFPTVpN?=
 =?utf-8?B?MDdaYzNYNmFydFQvdEZTZ0xNeGl6c0ZuakxWOEgyQzJnclZrejdNbkp2R3hy?=
 =?utf-8?B?enpXM2ZZZ2YvaTJaNWpicTlSL0w2WmZiQncxNzZwNENHbU1LQVNFdGxQODBu?=
 =?utf-8?B?UGt6dVVzVzVHeWhyZG1jcEU3NUhRRVdxTmFjUEF1b2lDYWZxN1JYdXhQVW1P?=
 =?utf-8?B?TmxaS09TWnZLY0FXOFgyVDI2YWNpZlVKTHdJc2pOZFM5L2JhYWRwdm8vbnhy?=
 =?utf-8?B?Y0lEb25uazBJREFkY0pQTkxvbGJ6K2h6Um1CVndaYjRrYVJVd3dkOFBncWtP?=
 =?utf-8?B?d2Y1Y1MwNEhTc1czSVp2L1JIN21vbjdHa21wVGx5emt2OVJ2NFNIK01GRnZL?=
 =?utf-8?B?MW5qdFRDOXFCSzV4a0dNN2Z3QnRMOTFOMkZBSHU3eWxleFYxYk0zd2pSSkpK?=
 =?utf-8?B?Q2hraHpSMzdwdXpWSkc5QUdMOThsdjU0Q0lsWlloWFhBRDVoaVpBVlRSZnpQ?=
 =?utf-8?B?a3RWdEZBd1o1NUlvcFpNa0hxRS8zNzY4Q3I5NFBoVCswVVFrc0dNaEhvd1po?=
 =?utf-8?B?VlpMQmFETUd5TEl4cWtPSVp4MXE4cS80OUZOSWVqVVI0dkREVlVzN3BSVmZN?=
 =?utf-8?B?WHNhUDVZckFOVFpOVEN2VjlMVTdaZFFCT3Q1dU93M1BjUFpWeEVyUzNZb0k5?=
 =?utf-8?B?MThSVmhLQ2FCV0ZyTVBUelphaWRwNHFFaEgwWEdwalM3dmRoU3B5cXJEY3o5?=
 =?utf-8?B?ZStlckhIYW9SVE1qbWR1K1BuRzFGdS9MT0RUbEJLeThVVWlhdU1ueDlQaDNS?=
 =?utf-8?B?U0JGZWNvYmdiRDVYMkVTYllzYStkZG9kc1N0REc2bXh3S1JWT3drdkVEMjBi?=
 =?utf-8?B?bGU5Mkg1bXVXNHRFZktjTEFrTi9hVnh3S0V3RFUzbElPb25ZL3c5dXh3Y0V3?=
 =?utf-8?B?K3piRXdlK09KM2NrTlNmNGhIbklIdXZmSFdOWlYzeFBqeXlqbVd0eWtYNlJJ?=
 =?utf-8?B?dTNDdXZlVE1scmRvMmVrV2RrN0JHL1laMjlBVWdjODVveENOT2hsKzJaV2JM?=
 =?utf-8?B?SkUvWnlJanY2QWx6bUMxUDl0Nmk3cmZuanJVWHdYK0xxS1pxNUttaXJIenZI?=
 =?utf-8?B?VjBqSDJyNFN3MllsenZMM1JPSVhNN1NEYzhKUEpnZmxzRGF5WXpjcEY5T21s?=
 =?utf-8?B?N0VHd05EeGFXNnVBVk9hcWdJZWkyVU4xYlN3bndvcE9IRGVaeEMzU3oxRG1X?=
 =?utf-8?B?OWgzdVR1RDUva2QrTVJ4Z1BLM0xQVnZkYXZiZU13MDcxS1FPZi9NaU50dzFX?=
 =?utf-8?B?bml2SVBLWXJZWWxiWStvTGc2OHlRZ09XVHc4a21ydnJvdmZhREhmYUVWRjJr?=
 =?utf-8?B?Y0xFSmhQTE0rSjRpd0hYbzFJVnZJZWxHeDlsTjgvUzJJMTBwRGhxTzNiWTNS?=
 =?utf-8?B?VytVSk5WQ0M4WkVvN0F6WXNZbml3N000c3lGV0N2bmhQV1BKQk9DcWEzMEJJ?=
 =?utf-8?B?MXBMUmRDWHNCUnU0ZFc3RHk2SE50K2FRRjJjS3VkNnk2SE5acFpab0FTMk5l?=
 =?utf-8?B?YjJZN3E3UlFKbEdWWng2ZEV3VHN1dU5QOFREc0F2OWVZODhySXM0K3JYTVpL?=
 =?utf-8?B?SFI4MU8vYnoyRSszdC9mckxTYkdpak12Wk1IOVFNSjdjemltSm56R01YS29r?=
 =?utf-8?B?VUNLQTA3N3hkcFVqbkVoNFZlaEZnNnBQb1dPSnBHbVRqL2tRR3ZlNnFlTlUw?=
 =?utf-8?Q?yY/skR6ppXXjsBPw=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ce6172-06a7-4066-19a6-08df3e933cc7
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:57:01.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //ptr+my3wU6OUbrpGsHOs9BtxnhxuBi/6atlQy6nvTUxDbKs/1W7kO34+DV4+qhsJ4MtY0hXm1CXqaagapHYQiHw66M+yUUTanmhsK+DhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB9857

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
