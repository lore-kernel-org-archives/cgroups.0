Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.130
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794237767;
	b=HaElK0bZIWzlyHtjb93M6qgHY5/ofLD0eAEWBbEe3esfJAilM/dxrvQqzQHc0h0TwFsH
	 rLGymo+HMLJYIeN/REodXZep9mN2D68AcOn6AtwMjh7a+s+Hpkd1/N6wW7S+0tG9oGs9j
	 idxdRcE6bO2s23M0fh3aqRikP50I7F+9+rcfepVn0A4ODcUGT6OwuHKJwDrqOkVBbTfJI
	 9oLOeme1SBbyhFHlEZo2CeBl5lPk2KYdM7l/ZBLQVzysMXIaGPrrylsq9yjigAdpDw+NZ
	 28w8Gouu+7O7gY5yOZKlIrVyS9GkNpr9dl6yaBGwdQWSser202A2RHF+cbmULeYN/Kw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237767;
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
	bh=G1yoewr/9CPx/JGAMturxtdo98+WrvpEr7/CI6dVWkY=;
	b=thRTnOtQQY3Qr1AS9Tun3XYmcwazyE3aETbTsDvk0JL4kI2K6/aUAJFkvZEw0gvjrQXp
	 qQhUHkXzUjUKqwrzQPamT/y58Mm0WWUPhIoH/12VghgwnnlH1ncBdU4/yveojahUFr7mF
	 DzYkOP/g9AX08jRIXgjzWudDmCHYYujTupCMu4s4ugqfkhn49fpOZF6BnxzWbDwdYN0rT
	 Xo0U5xcZQeLiBjQH/UXw5rBhfB0bwMkYgqjL2y2Dz7tXZFbFoie6Fp/0CpCgPoxugkJTC
	 gKC4UG3NmA8GwbYXwgzFPPjE3dXCG5AFAP79DRU/59+oNb+g9W/80U0NPFfp8MEAhdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=VmMc1tlB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.130
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020130.outbound.protection.outlook.com [52.101.189.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D55606A321;
	Mon,  9 Nov 2026 15:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15D55606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=VmMc1tlB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTeQldQ7KXVFuPiwfW2r5hU0ClhXdN/4gyv6QgJo980+ddYvp3mhyDJk1jV7LFpMJYlHG5zVBqamZq7pU6OSG6zq1aF8pu+AFimhLz0amPrVoXznhoYgAWwmMg61c8n+/alRH7psBWhtjstj+HvMOuwnTs7Wn7JutrR3F9ciRW6cXGu5Ca0dgOuX1eE4Habj4t3t+zLqclfaDdp8RN3QTr9MuEMpQzv1JP0vsCbbK8YmkTF7VU2h+nOS9wwd4tuKk1D2dsrvBxGxE/cQoTezq9+sJpyJOm08fLdAt9xFnOis2ywmMxif6WS94L3c+Red+lh9tV+JdjPfboKgG6kzHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1yoewr/9CPx/JGAMturxtdo98+WrvpEr7/CI6dVWkY=;
 b=XDmPahZ+5AgK4RDi3JuJlQWLMR/dSCpo0YNTx8Omffchq2yn/uK6QMI6uV0MeC89tJGFRgCRESgAAJC+WdH6TEcLoQ3IAgIx0mXQSiChoj3KJMs19m4VFNfWGw3v44j38ppf6QEBNE5aS4/PJk4/F15bY0k74kkCcWH4vZoZjIjjFVmRM20q/PG7aYUUwPJIJL4EL5syNgdfMTn1gdtnB+vp6LLNibcUPliamm/SmM4hW7E4frjhR83Yuq77MPOVSpiv1ZFwepr0uJVhRviY6Qrkk9ERIBgoXgnajJMVbL8p+cEvd9l839hOKje6ZAzZ9Emp33g/I13pyecfg0AF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1yoewr/9CPx/JGAMturxtdo98+WrvpEr7/CI6dVWkY=;
 b=VmMc1tlBax0RPk/5JbmdfkW8U4jpEoX3y5A0Rb3icLbT1TdpY76yUrjJpJf7GznVkW9hlzSXCEVBVkiD5XwHsl0xBTeYnxg0vU7TBgNZAby5myoEhbMdcr+aRk8YfhomA1q9yY/x6BcoZtTKm28BF+D+N/yZmgu1YqBq+hILRIE+J+yjNvgoX5ljxNuIbWYP3+OFN27j0PiMnP61FUiiTqgLW9GaYJYMrfw1odruQzAu5UDPvZLyclnh5nMsxDRQcq/2RJXX13BbAMRz00xsOx9xjfAzwurorWNGCs/q4EmiDChRXxT83bFrgMLx3JyzvIzdtVVD2TVrwwudsNc5Qw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB9330.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:a3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 15:22:42 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 15:22:42 +0000
Message-ID: <981331fa-6b0b-4e0a-b20c-770db2706f0d@efficios.com>
Date: Mon, 9 Nov 2026 10:22:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/29] sched: Take cpuset_mutex for a deadline policy
 change only with pi
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
 <20261108185406.1549770-7-mathieu.desnoyers@efficios.com>
 <avHhdDqeMpe7wAay@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avHhdDqeMpe7wAay@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::13) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB9330:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b6994f2-9b6c-4202-69fb-08df3e754c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	/Pxa/1ROrn9sR/jtnGcp+kxCvOE6QyN6kJirWmQUEv8BuQ7u7b+lDVPQsdZiwqE8TUkXvN/z43u9KAwI1cHAhMeV2fbItdxqE/4gg+B7mJ32Lh6nwy48XU7w0/VcKZkiIpfyivRmVJUDARQ9Cy7ziv1FTB3mRs32KVlEwweXAUVrT5gMeWU7DSf2Z2cJigvxi/+LNDk8PthVtP2SVF95VfF3k6vK5gYwQO5Q35KpyMh3oEEn1R/vo+TD8T8xxHDxahUCxApUx95NQwl50TS5kTHVoMaGZjPf0ITcJpirGpkTa06mvkyUHHBSapUKMXYWh7wpw/k2IASKuDfYugZxna6btWm/ZGDGaiQWlPtkyFuo6NSp+7YNEubkghdDSUyLfo1nOhYdoaDAaWXuE5ruAxJHfP/zRcCpbvqG4BvoU9n8r/AhPBdONtPoOvyuCQ0DtXOw9RhtSvZjThAyJHKESVJXk1z7lKXDsMDz9QAObGNxVW+du0236vHIxonKB/+4VqsILKCBLfTXsWuii78ZK0EXqJOIFyfs5aJ2UsqrFLUUZl1hcJWhexZlAU39SelOYj4Jg0XtZDv4hyNnaysITpJar8XFZtZx6MTng/Oe7jQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OW5sT2lMeEM0NlVGcks5SnBrTzBBV0ZhQ0p5TnlxdmYvR2JHOTZBN1R5elVw?=
 =?utf-8?B?c2xOSTFJWUpKR3BPMEVwTzZ0anJick45eTJ0VGE2MGg4VmQvakIraGt5eVlr?=
 =?utf-8?B?OVUxUyswN0pvYVBlMGtacXo1SjZRaFptQmZyUzNxSldSWnk0VDhVNmwvWmdy?=
 =?utf-8?B?SktuSjhsTnJ1RFpPdFVlN20yUU5YdG9nbTI0UmFJMXliNFQ1V1kvdHo2bHBl?=
 =?utf-8?B?UGdXZFdOU2R3UFl0UWtVZGpZVHIxQXpDSWd5MHArNHNDU1RiaFNqbnZFVXVs?=
 =?utf-8?B?YkJzRmI1SE9HRzNibHlaTElpSENIQ1NUdHVjeU5kTlN1ZXd2WXRQZ3ZWYXZl?=
 =?utf-8?B?akxKWlJJUmdCdkxlYUk0S1VyNjdwR282eVRYQm01MWVvanpBK0p1SGR2YXdY?=
 =?utf-8?B?Q2VxalJmcXRxbWtsdk9NY2NOU0h0Sjc5OVdDbjIzbGlYTEVwaytqajRvOFRw?=
 =?utf-8?B?MEpmalBtaHA1b3FYZ1VPcFNQR3QxdmJHUjlzVnBROWZ0TUEvcEMrUG5CY3Z5?=
 =?utf-8?B?SzI0L25DckU3djl4WGhqdXFjL0RwNm5rMjhNam42NzdFT0NMbUwrdFNhVCtK?=
 =?utf-8?B?N2ZkSE5FOUFpbnh2ZmIzbGkrQjZkRGdjcEU0YlM4VGRUaWxyUDRxSSsvbTR4?=
 =?utf-8?B?U2pJRDNYTDE1MjJRd1VvKzQ0K0ZTK0lCbEtwLzBEbSswL25EdXg2WENQN1Zr?=
 =?utf-8?B?RVZ5NFc5bExZNGtQSi8yVnRKQ1Y0U2N1Rm5COHk5ak9MdGphdGJWbmVPVWp6?=
 =?utf-8?B?SGxDaEx4c1Zmd2t6U2daRTY3TjUrYWJsMVV4WTJqS0dlWkhRbHB4SHh0Y3hX?=
 =?utf-8?B?TzZobU9UWXE0bTBPRGNPVlk1a3YwcE1VMHk4YWtDOFJJaGQyVW04UmQ1a3k0?=
 =?utf-8?B?amVWcHdnN2k0dGNqN3pmU0lXWFprb0FwY0ZuTDByTzlkU3A5VS9IdWxSN3Jn?=
 =?utf-8?B?TXR0am9QZ3grNTJ5QkpmZHNyOUR1bysyN2pIZ3RzMnl6cDI2T0wyRm1yL3Ry?=
 =?utf-8?B?Y3F1d3hvK0JWR2J1LzNPL0grLzNQQ1oyeXVMd1Z0U2FLUndtYXZxVGYrYXRN?=
 =?utf-8?B?WllFLzIzUmpWazVtVGJydXd2SnYrUlh6N2dVMG4rbHNubERjYkZPZUFQVEFL?=
 =?utf-8?B?OTRsc2t4OEEvUnFuTlJWYjlndjY0c3BSR1pJTG45cmhWd1hHa05uc1BlUlBm?=
 =?utf-8?B?eHFucldCeTdGS1F6dndnVTRiTyt0SElLMVBzYlhpbFNyN3JwSlJOejNzc01z?=
 =?utf-8?B?WUZENExpWW54ZEp3L2JodmVSM1dobDV4eWlGUXFOSjJVN040c2xUbFFmaFBj?=
 =?utf-8?B?dlZ2SEdzMTBmK0FYUEQwSmlMSmFHMTdoZHhiNWh0VkhDMmtvaU1aaU4zdDZk?=
 =?utf-8?B?c1R0bUZ0K28zcHFiSUZJUVQ0bjNJbEFWSVcvL1JMY0psdWZObm5lMlg0WmFN?=
 =?utf-8?B?a2FaK3JUb05iQ3RVYlNVOFQ3d3VIY3dGR1pjN1FjRWY2M2pJc3A0NjBJczBw?=
 =?utf-8?B?WFp6ZHI0VlNUSmVUZkFMSHVEaERsV0VpL2ZkdlUycndWWklSQmVSbTVlQmNv?=
 =?utf-8?B?VVRBMUdoY0RZYTlwZmFDem5lcXB2MmJrc3JlV1Y5ZitWR2pCenBDTi9JN3hw?=
 =?utf-8?B?bGFCaUVUanhTZFFGODJRR2E5UmFFTTlKT1kyQU81ejk5MGg1SGI0eEN5b2FV?=
 =?utf-8?B?dTMvS2ZxaGpkQXl0ZnRtcFBSUEFrM05DVkozb0djYXRkQU83dXA2U0hGMW5I?=
 =?utf-8?B?MEV5ZWhsa1RJRGFhT0E0RmFqMm1vaGhJeTVTUW5Hd1lscTQ3K3RkYkI2cmFx?=
 =?utf-8?B?djROUTQ5WWNQZ2pJdlZaekxvTnBkRHk4L215SEFoNTFzazdwaUJBb1JDUkU4?=
 =?utf-8?B?TWlWK1d2MEZJWGlYc3ZxSnE1dVhtL0R5NWVVZGMyLzVJalhWbkNuTDZtS1Ir?=
 =?utf-8?B?ckNQVzRSL0oxWktOTWFvSFMvM3dSV3RRamg3M2FFZjZXLzMxTEdFQ1Bac3RY?=
 =?utf-8?B?K1ZiNHVXbGZncDRzcFVWcVMrVll2ekNMamlsM3BKdndXTUFXaHpWM2tPSUZC?=
 =?utf-8?B?VitIbmFwRzN6bEM3Y0NRSThqNmVkRGZBZWh5QVUvcVJtUUhhMGE2cVowVTI2?=
 =?utf-8?B?c050b05nOXYyKzBXSFN1eFhrdCthVGhBYWhZWmlZWXh5VG1BOVUvZjIvLzJm?=
 =?utf-8?B?L3FHSmpZNXdYSjNINkVEMUZ4d3h1KzEzdFd5YzF3Zi9va096bW0xbmlJTDlo?=
 =?utf-8?B?RUhiMVB3alNRUGtscGordThvd0lvN0RBYW5JMFNHRjFZMVExOXdGeUtVL3g5?=
 =?utf-8?B?eEk4VmlWQTBEK1F1Q20rL0FmcjFJZ3gyNmdMTFJtMkNzdU1uRjFsVVF1bDJR?=
 =?utf-8?Q?ofro1+sdfUuW+T3A=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6994f2-9b6c-4202-69fb-08df3e754c75
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 15:22:42.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlhZAEPPsWZbrY7lFLWrJOPl7I7tNdBf9fY9yQPHcP6dvQ32HMGKDBvRZKuMZLLFNjG/rVwssjeeAhyhjB2MxxNYBpytaBV8XJDeduExncU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9330

On 2026-11-09 10:06, Juri Lelli wrote:
[...]
 > Also, maybe add an unlikely() to the second check as well?

Thanks for the review! I will take both comments as you wrote them,
and add unlikely() to the second check, in the next version.

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
