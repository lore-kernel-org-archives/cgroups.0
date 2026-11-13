Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.103
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794583222;
	b=pUSXRAa3x6zF26VDBux2Yl5tiRvO13d+kNVGiW1ZC+ZHIc2Slifj7xenQkQcuB05N5yg
	 IoOAKQWDYg4r41RTfHBNLmhia3O0NCISHJFsRE0bAM752YflHTkIdeemYxv+vrAOH0Byx
	 6WVoOkdYKcwfbeBn2DCF0qIhhk+9ty5DDWA9uMeT9uIWoqPHG6gHiTAK+i99wOT6Hx3e2
	 0ixcIlLQbBASXZWlOTSgwUJZknGOF6+U2mzl8Vt++1IMKeZOL0hYqDqUVJ2LJb3eZKxgi
	 +rxzMh0JPKr2ykAtIrhKbC6L6RfvjXIlH/Eg6GQaYZsIpfNNDRQEcobxn2G8xWRhL0g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583222;
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
	bh=+DT+XPft0eQLuzza28qIVDEAzr6XKSrWkCpSVpH2ZKw=;
	b=0aAJ+JIl230T1wSGiUwWYY+oVWterLuDi2h/pcVZVmTHz/gC78rhKEL/k6ULobNN4Xxw
	 GXuuBIh2f8rwSgvXl65HusvaDzNn7+VrRFx565/KKlLdc2JVQlTOvbOdYZgn9zVUd0kWb
	 pQ9eRgb2dHwqwSR2Jvcwtna7hRmBns+vaNA4ZX8cqsLNRRIixRwZWrym5NNJFyMfMJfiS
	 ExIkugJ7ucQbsfSMzYG/RNgxwTaj/p/tz0VUQCEuyT+bJkrGfzzJS2QO9yNoGolpHIadC
	 nxhZpEbxsSae5kVXMWVIDt/vDgnadQ7EvPSJgkLpbBUgnMoOqJ9BKfa21fZx91zU5zQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b="c/6UlgfT";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.103
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022103.outbound.protection.outlook.com [40.107.193.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238E606A327;
	Fri, 13 Nov 2026 15:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4238E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=c/6UlgfT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2K74G3fKiW/qQVm70FsGBsAqbamexEqsM290IQfH3HGj8tAkpRTe8N2Fp3EHxvJmKKHzwc3fuEc+VNDkPpU8HgYQOG3hgwhQVTOpjs9IFoWmWzC7K5dDkq/zzcsmRWmThw7tNcJufdDqqtBMicpKJjoI4O/SHBQaq2mi4AN5lTEsFRGWwhTr3ahtohmMPTqOcCufJjuTRa1iwNrNqpIbrUogF8bdGYrJ3/mI0RJiWxOwuCHYkfCGQDhFMfbYHpCqux/R/JkDWDtibc9w0qsChunRUPeuEkGfxLLZ4C6GljRji506fztJSeNcFihmQHIw7bDg2M6VxdxbCzCLk1Uww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DT+XPft0eQLuzza28qIVDEAzr6XKSrWkCpSVpH2ZKw=;
 b=dLblFNBAc2KnaElJMGipRi3em20fDMMG8x9sv8BmGdmgBFBbCeWgHHMOT8h5rE62vdWOql43y2+1hT8+owjvc6tHwgNuFw6Nlufn/UkpfA4e1PJhaP9lSB/Jw3TeI6PDp3XPiP636+borj2NyegEs9JACj27ixK1maZccfRIKM2YfnpKVSdt2dAA8xjsB5S34PVxRNh/fz3U4I3QVC1Ay6pKNzaic/ViVgvSM/nfW15g6GCkoBR27cYYB628nvlpIAxuyO5jbUIOxMG4koHGCCBQZJvhcjxORGSTx8NFY73RBYmT84LGpa071gt9omEmkHzcE66Wtk042s8zn9JhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DT+XPft0eQLuzza28qIVDEAzr6XKSrWkCpSVpH2ZKw=;
 b=c/6UlgfTG+HJoLUfxKztw/bQHs1IOXXCLghGSKAUW++ozTzXshlxI9DayQCFTjQBFD6pJ+Mh21TDsRRHIEb5QpzTVWHnbXlqs6awlTfyAAcHSmTkZqq1Fj8QU+fMlq512FKsUJCVJfOJhh63egHkX0DmS3bsbPhEo0RX2TxF6NnZaVHhHJio8DZAzz/JhJAupDJ4V61iNod17+rmnjoshWw+g+cmGGAtkYXGigO7HaEkPChdZ7hHpjzWpJP+S1nKLT8Djf+13W/hXw95OiV6blcc9WvQjU5huf3vBcgnldhbRDDZkVfV3qnWlLUz6LmCht0ZDuIed6jnfX+Y1/63jw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT1PR01MB8780.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:cb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:20:17 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 15:20:17 +0000
Message-ID: <818f0461-4635-464c-be20-461cd4cd8341@efficios.com>
Date: Fri, 13 Nov 2026 10:20:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>, peterz@infradead.org,
 mingo@redhat.com, vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
 tglx@kernel.org, will@kernel.org, boqun@kernel.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 luca.abeni@santannapisa.it, mathieu.poirier@linaro.org, longman@redhat.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 shuah@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
 <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb>
 <d58e067d-05ae-4e4d-9d34-b0ac2741b211@efficios.com>
 <20261113150438.9119-1-parri.andrea@gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20261113150438.9119-1-parri.andrea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0170.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::10) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT1PR01MB8780:EE_
X-MS-Office365-Filtering-Correlation-Id: a4c531ab-f52e-4ff6-eb5b-08df41999f47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|56012099006|261022105027099003|261028144727099003|261026140227099003|261026121527099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zo2/lo8M7GLWESHgZAYa5r/P9NNRRwsqL8MaoaHWADvmzyfHMiyyvUw/Fqdab49OC7vQqVEqetJD35JO9FVCtdPkO3XWHuohxxtOucswBIDn5kxkQP8sKn8dM1a7HuWnViwazp4RRpvA7NUeJa7kQXDnIPdG5zITs4FBPcnJ5+jnW5T1GW1Ug/14tVt4/jlD9IU8GAAotRv+kxdQpuAxlNHSMpwM8004X0tUmk49dDFVBDaW7j41Q97TdHZ3W5+UDK+iWeArSB3JZlaS/A5CMqAk/qX8xNlF3R/IaYdG1YbYpMWNuAhhvPQ8dyAyYH9u4ibcazBkqc0XkdKsP5zqRJTa6PB7sV5gW4HqS2sopbaSt/tuMeVul3mt3Kx1MFeoghIUT4oLVh+HLO60BjDSmwD9Fqo00eW32jY2GXq9ZZvfVt3ADo1EEhrryvuZh9kB+Ofhr1ULsFmQ5LjjYuTrDIp6PFrOV/9HqEc4b+aczLImc/mR//VZa8PZmeq7QJBXA5YrF9ecuyvDSfJ+/OinO8bOfL1DaGGV0hlNtiMNAMdzPIqMa4gnWYmiKEP3cLBeRA7WiI/2O0N+pjlbpzii0PQj5xdaQpCzn9A7Blfawsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(56012099006)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnZSbTBoMnFnRUNUNjVEcVF3REpaODNyVC9mUlEwTEZCaW1YbmRNejBiM2RD?=
 =?utf-8?B?WTVJVGdmNWhDWGNSb2xxY3Y2b3Nmc1NnT0NEY3d0T3lLWDJudGhONWpWVHh5?=
 =?utf-8?B?NE5sdysxMEIycXZCcmM2WEtrVHViYWNpVmVIZk1YR28xeEk3bHJwOWtyNmZH?=
 =?utf-8?B?c2szckJUQ0VEQ2xiTUNobFhMOUVGb1dqT1ZzUytWRGNyS3ZIMWlHVEtEM2VX?=
 =?utf-8?B?ZXorU1R1czNUazhaZVRHODE4K2d0WFVOR0JmSW1zemkxcnh0WFBMSEdmUm5L?=
 =?utf-8?B?V0hKUVpxMlJTM3E3Zmg4ODdvTm00YTJUamlyL09sZEkzd29VcDlUMytodVNw?=
 =?utf-8?B?cFdEcHB4eUNWOTFhd1hyb0JjT3JNVmJUQXpHSGJoNncrL0ZBcStRUTRVU2NT?=
 =?utf-8?B?d1dES3gvdlJNSlM4YWk2N3ErTU9JTlpkRjM4U3F6eEhYM0IrMGpmeHk0TktT?=
 =?utf-8?B?d1RRWmp2UEdZc3M4NHNYcHJmcTFKTEZyM1hXcUJhbTAvOUROekNwWGhmb3A2?=
 =?utf-8?B?ZzRRUjB1SlFIQkxad1Npa3I4TU1OL1prNE5xZzZabXpFNHJCUzRMNmZqN0hB?=
 =?utf-8?B?TXVIa2V5UzFWbFhGajd0ZE5OUk8vSnVkbEFyTmZGSi91bGo0Qmc0NFlZVnlR?=
 =?utf-8?B?bGZQdEVQUXNtTzNNVjdHQ0RTUTBEcDF6TURGUkRIcGQ3SzVzR2w0Q3NHUWl2?=
 =?utf-8?B?MEJZK2diWnFpazM3elE3YkNWbUhJQ1hld0IreTBOM04rV3dCdUVPQVQvUmF1?=
 =?utf-8?B?TkhiU1NQVFdiMVpINFk3TVhZd2VtSkJSSzZDR3I3SVFIOStVU0t3OWdweElU?=
 =?utf-8?B?UUdSS1NSZVFWTXg4RU96V2U2ZlBlUTFxVDYwbVlUN0ZyN0lFMjVJRVFIbm5p?=
 =?utf-8?B?NW93TkIzWWVtd3VXY0NocjVEMm44MGVwRXQxM1R5RCtSZHB3NWsrR3E0STFG?=
 =?utf-8?B?MmVkeGsydGphMjkzM0tYMEdpSjdSU1dOeHJLRFFlRk5HQXdGbFBJUS9PWjlR?=
 =?utf-8?B?UjZaVURnVnU1NnpkaS9DWHh4VTV0Mk9jT21TMCs3N0JQSWdJakp5clFyamY1?=
 =?utf-8?B?RUszVE1PQmg4eHNHTVhxR2VzdE1aMGdRSWNCdGpzWjEyVlJHYjJDMWVCeStM?=
 =?utf-8?B?aWlSRGM4cGd1dlhCT1IxWmhCbjlPTmtzMEpOM1VwQklMdlNWc2dkbWRQM3ZJ?=
 =?utf-8?B?RFpvSkx1RDBncUMvRHltU0lYaHloRnRQY01sSXd5cm51VXlvV05Pd3BtQVg0?=
 =?utf-8?B?WnRwck94aU1nSmE5eDFqVkNHRlFlcDhxQjhLSE1EOC9NNWpJQzFBSlVsK25h?=
 =?utf-8?B?bEMxaGxPWFVnQnJDTGhTVk53RzdyR2pKYUJabnMvdkkwNkhjcFluTzJtZkZ0?=
 =?utf-8?B?elhKM3JFVHZUZHlYcTA3TVNxWmNEcFQ5QkR5akYrY0NtcHcwd0p4RE9IL0FJ?=
 =?utf-8?B?bkkrRkJPWlhCallzQks5eThUWFoyZXhJcGN3UTBWSDNrbWJqZDBRZkZXZFkw?=
 =?utf-8?B?aVo2aGprYzZiRzhBVXZBYlh0cEVNYVUyQzlob3BWcS9aY0lPcmpsa29xQXk0?=
 =?utf-8?B?YVRJYTlPUit1L0R5M08yNGFvZElSakM3Mi9yMzlVcTNuUTZpZE5jL041dC9r?=
 =?utf-8?B?ekNNQ0t6NjQrRGtwOWpxZnVPdFUyVXE0T2F3emdBSytYa0pNNUtaR1Uza2VC?=
 =?utf-8?B?d1cxOVlOZlBFS0VXazdjd1hYTjd0TlFwL1A1c1gyeG9jWFRjeHJsdVI4VFEz?=
 =?utf-8?B?eEJYakg0RUdTRWRlRUorN1EyMXJPblA4Z0RxOHpZKzBLYXR4cjBHTTZkYVQ4?=
 =?utf-8?B?bjh3VHdHVEtOZzg0aCs3U3V2VjR6dFVMZXpiNmhFQm9DUTFZL0ZXdHo1S3B0?=
 =?utf-8?B?blNjRHRPZERoS0JORG5lQkNUbGlFOTVJS1BXRjFOREt5bm85akRTNkp5aW9q?=
 =?utf-8?B?U3Yva05tZlJQWSs2Y2YzRjdXYlRXMDVZenVPbXJlSzdhbFh6WXUvUFJWdDYv?=
 =?utf-8?B?Nmd2VkZDRC9OMFU3RFVpeXhQczdzZVpnSExESGwrQi8zY0poNmFPWU5WOW1o?=
 =?utf-8?B?RzYyREx2ekhPcUN4Tm5tbk84T05FTUlKNkV2UFhvVWJjOXVJVlZuS1JFNk9I?=
 =?utf-8?B?aFk0dnQvL2x5YzI1NEs3eGFzeU5Pd0drR1FpNnBtbThOZ0t6TXlpM1VsL0ph?=
 =?utf-8?B?MW1NQ21HL1k3a29ZdlN2T2pVZmcxbVV4cDFFNGI0YmpLOUk5QXY3a3h4OG1h?=
 =?utf-8?B?WXVsSlpONXlWY1FTbFRnNnFMODY5dHVrSStyNlM4WEF3S24wdmk1MzlaR2NU?=
 =?utf-8?B?b2dUcG1sZ0JpT0JEMzRMamxSQTB6dTVjL2crT1JQNGZYR3E4QnlQbjJBc3pO?=
 =?utf-8?Q?A+R6AB1ho+Q4fKmontNszRYNKctKteZ/SkloD?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c531ab-f52e-4ff6-eb5b-08df41999f47
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:20:16.8921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMLE4OdjkhCMyOOl03YpzAE3bf47GHkiTpZ2MMx2XlEL/rKkV0xjQDe3cRVKfvchqO54p+mIvFoFNGggW74OI8GBYRInnYiKb6cJBTzrWGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8780

Hi Andrea,

> A heads-up, since both are under review: [1] adds SCA_DL_CHECK as
> 0x10, so if your next version also takes 0x10 and both get merged,
> the result would build with the two flags silently sharing a bit.

Thanks for catching this. Your patch was posted first, so it keeps
0x10. SCA_DL_BW_RESERVED goes back to 0x20 in the planned next version.
Juri, that is the reason it will not be 0x10 after all.

> Your plan in [2] to change the affinity check and the early exit also
> overlaps [1], which moves dl_task_check_affinity() into
> __set_cpus_allowed_ptr_locked(), right above that early exit.

Yes. I tried your patch on the planned next version:
- It applies as is on the patches before this one (1 to 17 of v5).
- It conflicts with this patch in two places. Both are textual. One is
   the early exit in __set_cpus_allowed_ptr_locked(). The other is the
   line after SCA_USER in sched.h.

 From reading, the two changes do not contradict each other. The
planned next version also makes sched_setaffinity() of a deadline task
wait for a cpuset attach in progress. That is in sched_setaffinity()
itself, and does not touch the check you move.

> I'm happy to rebase [1] on your series, or the other way around,
> whichever is easier.

Neither is needed. I propose to carry your patch in the next version,
unchanged, right before this one. I already carry your cpuset_mutex
fix that way. I rebase my patches on top of it. Then one series fixes
the order of the two, and the selftests run on both.

Tell me if you agree, or if you prefer to keep it separate. If your
patch is picked up on its own first, I rebase on it instead.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
