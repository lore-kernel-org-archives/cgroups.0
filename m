Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.125
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793908452;
	b=s79r3CoLF23CsD2KBjXu89dD1YqZsE16Z+7TTGaOgW8vIoyCwTlwQ3hMpsGG7cSDHZQH
	 uSk8l4t8d+Jkq8L3oNQ+TLK52YFKdvksMYPMCW0x4GTiPyBFdO6w+aHOBFnKxyzDX7Cqt
	 eYTYCdNvopyHe2HnZfuBEk5KkJrpthrB+zH5PdGkhBGsWxAsWxaxRvlEvkEE6cKX9df9H
	 TIbUkvGM4scfler/lFTgnoSde/JteI5U1s/XbY+/NoIgBYgfl21l5XJ1SZ5UtqEwnOaJM
	 hBVrh7XJTtQLflgFhWgxbwbDjJb9Qv3rE1igzSGIngedj7RuGXkiLkMGfuNRNersM1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908452;
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
	bh=PX7ujTL79ijaY7XoQzQVRjCTt7csyrkvuYADYf0nA5U=;
	b=021Ns8HPUwx/zzCBdwTk/8CIk/tHkQgPQc0EvblpIDfOdu/s0XFYxOltSx3tBAObzb+n
	 Vi1UavK0tBljCwqden7OUY8+5lqh5csI1Yw/p7ERLyd18kboZO+/LDEwtWlaVma8MenrH
	 j8eDOYU0+TFoYeMovmh88/lf7J2vJ5diHsWCkgC3dHDYqwegVCaeNovyqFrza0IB5lv/4
	 FV1VsgSoMwkf0iK0xytuV7o8s23PfYnoWI2ZT3pc0ODgrJGCz1j5xF8ZmuSXKQERkCzKq
	 exPKWAQGYMsxCJI5Eus02cnb/QmTwnFNBmsRnQ0hq/MNCEXWmY4YYMkZxnG+bbPqeQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=La0SIXPT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.125
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020125.outbound.protection.outlook.com [52.101.189.125])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B45606B9C3;
	Thu,  5 Nov 2026 19:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2B45606B9C3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=La0SIXPT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUfPqWtdSfGBdg/irENBOj4cF+82UU+AakzvRewBqE8DV5KNXe/ZueqA5cgNHVFB9FHfTAuYhWcHLdB9coVkT1wVOGsLKNYl4u43WwB3PYrAyWiUWm91VyGV0F/SUFPkB2pNKnX3H2etkzFUd4WYCtssqexcMSPIT5dnt0MUR6nUSCgSvrXOwDKBVZJOMCgvngU2cYovXXSQRkS8FGKJiOp3hd7qGDWhT5wqJDuqHbHZC1RloUf/Nex6q0j5YW/Ua7ZjXyX+lyYFOzH/EggOXZ/TeUTfhJOcG1yOnLSmc/Sr+lBK8B3fRWrQ50OgGCpxt6rg5vmPHgeMPItlsMb1QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX7ujTL79ijaY7XoQzQVRjCTt7csyrkvuYADYf0nA5U=;
 b=O6N2KP36ZypWkqPsLXGtpMGefVkIMD00JzrXIwqSRGvMXfYpeDs6ywplmkFt0ghiIt7EIo7LPZvzz1amave9K6CT3xPx9qLG7tl37P3oIYQk84LewlVe5ncnWWDiMbH+u43cxJUTgwvrfbnWmnCZh/XeVBxvKBY6FbzgRCCU+GW8HbbTW9T4IPQrbd+Cr1AopATj5GSky+1qiU2E8/NhXC2s6CYc3W/RJnJFb7FeV40IK93WUJpRYTMTazEkgJMAnMsBSJ5Bv+p6vbz99BgcaR1jWIGK22gfsB5Fn7akkT5po0izHg7XJJg+45xUylCUwua6pw38Idn/f7Ly/CS1Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX7ujTL79ijaY7XoQzQVRjCTt7csyrkvuYADYf0nA5U=;
 b=La0SIXPTeqt0AX3ik9VVdjTWKghg6lcM/SIdnZLPbtQY8yFBGkNM/OC3OFoG2UMCAo/J2uWNHZ45+W/ObnpXYyES1pm0nVsDEMXiY7ivTnPhfN1TK8AnvoQct4lFWoMf2K8CrHGkKcTCrXmTgvWKKLB1PFqGvS+vI93O6p8u0pTK/IVnq6K4Z5DPjE9CDUalyDxOL2naQEh+FRIEAKEKFWJ3aX/VgvpRW6Y3Xd74VLnIzfSGPJKgW/Zx+eLPYb9EV+hhKwQVxK60FPNdqMpsDGz/wvPROQtnsmtZ23TiDASBG8dWNsNhB49L3aLIGfKdmYxbLl7XI5rTLabpqsGoxA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB8724.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:7d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 19:54:06 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 19:54:06 +0000
Message-ID: <9307bef8-80bb-4b27-b7e8-9a63fe98326a@efficios.com>
Date: Thu, 5 Nov 2026 14:54:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/24] sched: Fix cpuset_mutex double unlock in
 __sched_setscheduler()
To: Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 luca.abeni@santannapisa.it, mathieu.poirier@linaro.org, longman@redhat.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 shuah@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
 parri.andrea@gmail.com, m.szyprowski@samsung.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
 <20261105193359.1450487-2-mathieu.desnoyers@efficios.com>
 <auzdzi_ZIqmYFV-Z@scheduler.schedules>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <auzdzi_ZIqmYFV-Z@scheduler.schedules>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0263.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::17) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: dd44caad-c6c8-4114-0b78-08df3b768cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|18002099003|22082099003|6133799003|10067099003|4143699003|261026140227099003|261022105027099003|261102123227099003|261028144727099003|56012099006|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	H/Zz8yY521XJIeNNHmdrfDmqOH3T3JMMvjIaAeCQlNEHIy6JdWyC/c9hNnqZirdOzOZLBX2IqF3GAHpor3uhbezlA6ZkK9xEoHIeP98n4TLUm/7CK5Kv2Wb80KWvujSBESySZnFWwUSm3wM8Bt1EEUdTZ8/vz/QUh6XhbEKa7sTIBQAtq7Ev3l31GIJgurU3F5dghIGwf+JhR+Yc41oIJ6zSWtwGzzBFnMODuiZw960vOf6zCf6IZTBSxGQHyixjbai8JD7+gzlFCx8a/hIRbKdWlrhUxqpfGQH+jLKNlq8g0mamK/acmTvKq8XkeOLLtzU3MBM5CIDnjEirYYVcrJlH2AfXa9QLhllUft7UCss50OU/LSbrflHhD0t5VnjyzlM7n2jP8asBXnBJWPgPpFqwrJtseXV/tXPuybhIJuTfuLdsZC+tISrlcjxm7YIy6GtSUkKP4b+k+hogi5e9xvrIPecsnNeBsn+4RBDxfGOjqFUekeky4ADuBeLKjgU9u0Kagey2KP94TG6u3DhMVzU5cmFHdBiO6z8hu5MMNToectcj2twip3nG5GaT8oKAJCPtfonw7lad9axq/zNUZqf3J/wlzNoE2oFgbC3r3OM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(6133799003)(10067099003)(4143699003)(261026140227099003)(261022105027099003)(261102123227099003)(261028144727099003)(56012099006)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEQrNXp6TjgvT3hJbnVQN2JVcjZDbmdidkZFTWFjSm43b3h2ZTI5OWFwQnlt?=
 =?utf-8?B?dHRVckVaMXFCQ1R5MWxSVnM2YUorQjNXdVVFS3JVZW1QVFVSUzZMdklCSzJR?=
 =?utf-8?B?RGRVU3h4VUEyZElmQkdzRE84djlTUi9pS0tPeTNraXRVY3RJaDF4YVp0UmNG?=
 =?utf-8?B?V2diRkVwcW92RjNTb3VGUnB3VnVqRDlWUHJaUlVpMmMzL2FBeHozSHk0amZs?=
 =?utf-8?B?Mi9odk1HaTZCbklKQmhHNGJ5OGZHNm44dVVVbHVZUjlXNDRyc1kyYmVOTEd2?=
 =?utf-8?B?czVPWDRXOFJvL3RuYUViUndhWjJQVXJZeVBaSTFaNzBRemRET0s5RWZCZ1VW?=
 =?utf-8?B?MEx3MytyQm1ZdC8wSGxzT3VIM2txZFVzRlowUit5bVpuWXBIclZ4dFplZGVR?=
 =?utf-8?B?cGFIVnRqdFpGTGZGckt3bW9SMnlCRk81OEpwc2xVL21oeDA0anp5Rk5xWHRp?=
 =?utf-8?B?VzNpYzYyemc0UW83MTAvQmI1TTFKZEJCVG5MdzFDZDVQdUp3dStqY2g3QVRq?=
 =?utf-8?B?cFJObVRIUnN6bzFJQnM3YWZuNGN1cUx0WE5RV2xlNVpKY0tmcTZ2VjRvOWIw?=
 =?utf-8?B?Q1p2SXRHRm85V2lheGlUN1JzT3Naa2M2RndhVUJnM1dOcm1wWDFzUGU2YXcw?=
 =?utf-8?B?cFRwQk4yalV2ZzFrd3hJRTd1T2pmQU85bVpGTnlaWjdIeWVTejZjcDBOT3ln?=
 =?utf-8?B?aEdaRWgyYzNCQ3JQOGVvSFFJRU5XMlA1OTdHelZ4OVRlbGcwWHh4Q0N0c1pZ?=
 =?utf-8?B?WlFkMG9KMTlyZkFWdGNqc3VBVG1iNEF6OStYMjZveVdBWkRqZjdGTmJ0VWFE?=
 =?utf-8?B?aG9vQjFxbjA4MUNPQ09QOW44OGJzQUlydElxRVF4ZklNRlgrNTRmdm1tb01R?=
 =?utf-8?B?MGRnMTQ4NDJZT3dmZndySnhNakhQdGthNm5zQW5BUXN3TllJWThCdmdMbVpT?=
 =?utf-8?B?cHpqMG1Ta2pYdko4NXgwbzJ4bkdpQm81Y2RpWDVTcytTMkJ1dE9nOWg5TTVs?=
 =?utf-8?B?dThEaEJVSW9tSDM1bVJLaFg4WVJXR0tSZUVtTU9Rdk43VXl0Q1hWc0xPdGZ1?=
 =?utf-8?B?R2Y4cjBWbndmT3YrUGtlelJYMmlpL2FOUUxyTUhjR0ZXSDc3VW1zbEJBSzc2?=
 =?utf-8?B?ME1iUjhFQW9QTWU2UVFDZHI3ejkxdWFaRGd5MjlIRDk3R2UxZnJFMnRza3FK?=
 =?utf-8?B?SmtTaDQ2NE4wQ2ovbDREVGFzNHlRZ3Nxbkw0bm9jSjJZNnczVm4zd1o1djV5?=
 =?utf-8?B?WlZGbWRJV1E1S2NHNkFSdFRHWlEzTVk5U285L1diVXpNZmcza3VEdDZlMnhp?=
 =?utf-8?B?QjNBMzdxeTFlb0xXNEtrajdYMmpwN0hvODVtajJsaVhJaCtKNXdZZGcrcGNm?=
 =?utf-8?B?MytjNThYSm5QOEM4VFZFbDhSVk9YU1p3enZPRzdZY1ZIUG1XVmJvUWxzWU1R?=
 =?utf-8?B?bTRhR200dnRFQkhBWGZLNVdySHdJckhUODVvYVpxY0lZSTVNSmw1WXVDc2Vx?=
 =?utf-8?B?T2x5NXR6eE5uUERVTFBmbUdwZm5MV1AyUGxObFg2VmVFdFBQRG8rVEUxQXJX?=
 =?utf-8?B?Uys3KzRYU1pJNUtwejVmVTlWVjQ0bFF3SktIWkFidGlOSytEQnVYeSsrVFho?=
 =?utf-8?B?N2xrMGc0cml1OXV2eXkwUWlNTk5MeGs0V0pKTGc0Sm9Dbi9nWmx6WUE0YWJ3?=
 =?utf-8?B?dGZZTytmL1lPcnBXSGdKN1B2dzIxdGFMRVJzYTh5eXdyaU91NDRrYWN3K2tI?=
 =?utf-8?B?WmJjQmt6UjducjFGeTFteHo0RC83dk1kMG0yYkFQVDgzV0EwOFBGTzVPbll1?=
 =?utf-8?B?M0NWYTBiS3BuRTBsWThWTWgvWDU4Tld5SHFsbldpcTcxaHppbWVNQVYvTTJh?=
 =?utf-8?B?TS9mWXh3WWgrc3dPQVdVRUdIK2xweXVzYnF2Uk83aXlVRlM5L0twbWVLdmdy?=
 =?utf-8?B?eGtxMWFpZXBzOXczSmlnNldHSS9HM3BzYSszNUlUaGFsZ1RRQWM3YVZzUGVo?=
 =?utf-8?B?OUh6M2xJS2pLRVp0cjlnQkRSMUlwUUVSZVVtb2srd2RCbkR6VVJnQUhnUHJo?=
 =?utf-8?B?WmJhMzlUbjBNT1hGR3RYa3ZTQXl5RGZkK2w3ZlgyQnA3S096SFZCeGRhTXV6?=
 =?utf-8?B?dFNUU3M4SmFNNWFKZ21hRVpOTVh0OTRzY0o0MUo2aUJkdGp4MjRONHhvajFx?=
 =?utf-8?B?YmJ1NnZ3ak83NVVpcjBncnFQZnZZRnNCNE9zSGtkMTJFMCs0YWFSZ3pYbXVQ?=
 =?utf-8?B?QmNVamJTODZTS3JGOXcvYTcwaEZEMnI5S2ZqR2pIZHFhdnNua2VjZEx6UE1Q?=
 =?utf-8?B?SUUwNzMzaVI1WWFxQmd3ZHJBaWZ2UE9aTTJFcDJ2QW1QbkVnOE53YVQvNGZV?=
 =?utf-8?Q?k6HR1CdGgxIdUR3SbQYhqS66v7+hj8zb+E+Gg?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd44caad-c6c8-4114-0b78-08df3b768cb7
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 19:54:06.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PVjkxrUk2NsBsz1g/W3MCaRFjBf18Ai9RHhJjA10PPPorqSydIZkQgNAGtczZlryyJJfZN5ve91ZNb0xeo0WRqyj5LJEwDoOUy7aMhOkMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8724

On 2026-11-05 14:51, Kayra Cizmeci wrote:
> On Thu, Nov 05, 2026 at 02:33:36PM -0500, Mathieu Desnoyers wrote:
>> From: Andrea Parri <parri.andrea@gmail.com>
> 
>> Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://sashiko.dev/#/patchset/20261016062629.2102883-1-sh_def%40163.com
>> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Waiman Long <longman@redhat.com>
>> Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
>> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
> 
> You gotta add your own SoB, no?
I'm just relaying the patch and did not touch it, I'm really unsure.
In any case it can be picked up by the maintainers through their
preferred route.

What's the process for this scenario ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
