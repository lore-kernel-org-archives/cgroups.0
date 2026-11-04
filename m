Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.77
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793823880;
	b=NyctYR3LSt8Vobl2siUGUzfkzY0Fnrf/x6hwuvWG+YUUuw7Aj93Wt7LVlOGP7jJtt7Nc
	 i7E2xR3Pv6OurEZDmmymEOMq2ghUdcfibvrva9n09dhsQGMzF6oLRyD5X3BcWmH/9xtms
	 pGa4uw8tY+mTGUhSYxvg9APLuDoIdrW0eAllBit7k6aSqJxWXLPcy3gCbsJQPUHUN84Rg
	 3aDXbZFEuNrqkZqEr6XOIwKrtxrxVjQf8AjkWUYNlX/g3yn5narg5mDTTfBsnnO4gdVgb
	 qVwJ0/WLEj7WEIoSG4XRjq8scYj6/uSLPlTBcm+qlk9tPGetb2FhSYZr283WBJ1Dk2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823880;
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
	bh=0H/vkr1QIIVFGm6wA+u77NSKYBFbLOovJyYs+oqgtDw=;
	b=Y+f0DK+uZwVVBJvyymxdfsF83JID+ocyf+64KlQ2fZ4kRcbsAF0CD4CDUIVM/k19VQC1
	 noqpNLDyUc5ox8n2QdN3fs2EpTNKJMOuId1I9UhD7t/zyAJeHRaVHo8LBv4ALNaWQNJU0
	 aLWF9FfSy//uIHJLtTZKeem9MxYJrvCuZcQqjTQKZFJVovvADUS1nTi/tEPskS73TexNU
	 X3kuqidzHCgWbBVh8P5aXeGNfV3JVKaPUlYGaJSQnb9Ule2juNu4RMom+PqFcVTy+zl2s
	 67WmBFLlKO8uqEkS1q2NK5vFLNpeEt7vXL2b+712CKiNuuVi0+u1PwZRBzEHzj4sWyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=dGM4dceA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.77
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022077.outbound.protection.outlook.com [40.107.193.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2577B607030B;
	Wed,  4 Nov 2026 20:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2577B607030B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=dGM4dceA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJUbDWcYYDPnUluRxwX5BaQ3WieIeVJPIB/rVkhukO9Hg5r87+b+d9m1SddiQ2OZWhnR+9PaaktElidNY2cmIdIwLxlRHMFfsQuoeMSqHndvsWFkG7j9MqEuACjOiDA3bIUr7HsxfqhSb+5y60LG8/xGh3UgigK2quQ7Arp1/2yAqGa8gbc4AejzX4dd10WBJzVapHSILHsszfjCd2+dnVo4p5+MwCLhfOq3pBcYZ2tUcDT2ls3DssFi2ePruEPEZZmGK1QadmbM3ebfbHaLiQgZj1/PI3o8NTUpYvDZHCGJ6ej+HAcXPPxfFTwiBlQ0q5vUHmNuxXiqJmwYNyjgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0H/vkr1QIIVFGm6wA+u77NSKYBFbLOovJyYs+oqgtDw=;
 b=rpDxRNj9XJDiP/gDWCeU8Ba2ladolLX0+vWDiGD8k4O6AE/t0y+uRDOgeSRlqcz3unRXAOhYsD6G/ZMgZvFyarK5gVTChuY7gPNzsrqAUzidnijPwYPgO6FDdl9mOxlOKZTgKj3UMZqZMppzcRJur87YDNo5Q7vbME6i4dykylk5svjXT6UlxyX/C7WLqoSK6UCBwetNHqLag0gxGpNPovYlkX3f8s6p1R375sgnsRTMdlXPmo5MGa6rfpJjUBlGlygaDqj/Im22U+Y8F2UfMYiddDjm/EI0XkHrmt9Q42hW6bVOeFpaZngj8cVHB7FF3tZGWi/uWr979TuRLSWvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0H/vkr1QIIVFGm6wA+u77NSKYBFbLOovJyYs+oqgtDw=;
 b=dGM4dceA6A0IMUAntpdBbe8Ta2rsv5f6/GgmprXfMbuha9yFLJAEcJiKmZcKHTearGlEdGyMlDCdVHA7DQ9+GlzZ4mu0yfegVpvCA5utfRJcdD65HPTiPy2XR1Tu49gPjoDUL0ySIpBlesVsdaDh0m6letnwUgmQJzDVLeKVvQOiLMCnHVIwtLMSvrMCwOYePCHwJnafWt3GbjxtC7ZNZEcFAE6pA0KGZWrBuW2HCek69XGnq23/WGw+SBO33ZK61XBurIdWf26rFmp8gx1eNAfNdPniSji8qVld7Q+Ns1l1EQrU2SuSDcQdlT+bl9YZ+SpbgFDKc6IrmZuZf50M5Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB9493.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:a5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 20:24:34 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 20:24:34 +0000
Message-ID: <e37fd4f5-4422-4f04-bcb3-cb640e67697d@efficios.com>
Date: Wed, 4 Nov 2026 15:24:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] sched/deadline: bandwidth accounting fixes and
 selftests
To: Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Luca Abeni <luca.abeni@santannapisa.it>,
 Claudio Scordino <claudio@evidence.eu.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0082.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::15) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: aad52cba-8b66-4da8-808e-08df3ab1a41c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|22082099003|18002099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	lst81HHEgBtGD9QyEOqlU1/pWf+vrkiIEE3ohekAUXfdiMvH9FJsfaRVSyCjpFWg8H7agCwGrv2SMkLg7/EZBZnBIbVTR84GuwbufDgNPMRryWM6ZAK53DUN2Z8jU51oR1vOREmrCupytCYuXe/Vi/wUV3uNFVccXtJw7Li6Bwh5+IlqDVxBp86LuxCvXx8mYEJw+89jV2sWqU4EwX0r6qfCB6ll3BjwJG+jciYM+oBQH2Y3+XXpkQdOV3pPvobwnDGB1E7Gi68SFf0WDpgZDEZxG11AKvPX1ZGY1WsSquBYM0wN1FTTmCvZekMrh/AxD71I9LH0OOh27JuIfaB3rhOjkDMh89v9o7foC6mDbnjHn/zNlsdDCrCmeCPGFWjiHd3MQ39XVVd2ov15E/MmbtEdoamIOGOn2mnZdf1J6bWagq0M+2y5O0CSJ446JIJ5DVfpwiUgOYQzYsbHVCuRk9yayqxwrF/FK4NwQhfaoWE+SzHe8ncV6GL9vTOAoFluSvr4gg2ZPR/5Qg4G5RvIc+o9+8Q4R9FIA6RYXI2yQqa4DK6qPQPJCP66S7MSSgdPT8dzIMtXlIem9sX1iSJT64doLiFUnrsi2i0PtsY4gUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(22082099003)(18002099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azc4QVdSL2VhUEo5T3B0ODJLbUllR3dueTRhWXF2bURjNEp0L0FtVGJBUUE3?=
 =?utf-8?B?Vlh3TTk0eFNVcWZXRmkxU2kvY1lYYTI1ejRZT1hOUUlpMjRuZ1ZlOFpZU3Fo?=
 =?utf-8?B?NG1NalIxN1AwenFaYXladnRjY3hkdWFoaEtzdE8wZ2lhYStoK2VibkpBa3RB?=
 =?utf-8?B?NGNyM0xiVmVFVVhhY1NYSzFFNkRDVnJORWtSbXA5cUdjTlh4TDVBZy9WaU1T?=
 =?utf-8?B?bHNkNWhma3BQL2NuOHR5VkZwSkFma0wyRjJFQThEdzRQZnlVK2xzWDE3U296?=
 =?utf-8?B?bWorS0dBOHhvMWpDR3JaWUdPWDU3WVE3cEFTM2Jmck9xQmYrUEZhbTNzcWJO?=
 =?utf-8?B?YzVhQU1hZyt2dEtkdWRjdHFQa21RbnF1b2FmdE9yY3c1UDVVUnNha0ZEdHNQ?=
 =?utf-8?B?aW5OSURFR09ndzdabHZYaUlpWVRJQ1ZiYWlSTnNWc2QvUGZjNnZNSHVDSjlG?=
 =?utf-8?B?aWwzN3FWZEM4SzBvMVFRbEZ2U3hqVjUybDFJMk5tRFoxQWhDVW43VzVDR2pU?=
 =?utf-8?B?ZGZFVUtyRWFabVMwdTdKYmgxampsQTFmdHV3K2hRcVp6cWNaMkdQWXJheGNK?=
 =?utf-8?B?ZW9oSHFzYkZKaS8wSEVTVEI0ZmxYNXArd2pTNmJrOXhFMHEyWlM4S2ZWUEZU?=
 =?utf-8?B?enpkM3RQYVpwV21Ld29XT0xrQUtFRWgrbjV5cExobnVtU2ZGclZvdS9aL3RP?=
 =?utf-8?B?Tzg3MVZHbGJZTFJteFJFMlQvSG5aaUxiK3FkUkozZ0p5cVp2ZTJDSEczTkNB?=
 =?utf-8?B?eWJmQzJJNURIZ3orTC9xOVpGMXlJNlRCNTMwZ3NZakpjRzFFUzlRd1Ntdm41?=
 =?utf-8?B?MEVOdEZKVTVETm80MjFYMUIrbFIrN2dMd1ZWZ1VxVVh2MXpYbG9WeWlGMEdC?=
 =?utf-8?B?ZkdSSU9Mc0VqVkM0cXVEbHUzMlEvbC9OZzRwOFdBNnMyVUdCRXg4U2E5TE1p?=
 =?utf-8?B?TU1nTTFrT2w1TzN2d04rZ3VPR01vWW5sdjhUcm8wcDdKbW5pWGx2cXhIUFZB?=
 =?utf-8?B?TE1haEhiQ1lIRE9lVi9ubUYzbmtpMlVTMDZPZlhIb1FiQkw1TjRsN2hWWXd6?=
 =?utf-8?B?c3BZbVBlTjZTdFJ1YjZnb1dwVk9jeWhlZ3Irb0UwdG94TDJpTWJnZXcvRHlE?=
 =?utf-8?B?azFGNGNSSWpqSmNDcm45NVJLQkdOWUE0S2ZhQjlvRVFOd1N0amdVMkN4WmlV?=
 =?utf-8?B?RVo4NEt3RXV5eEhFZDlXeXF2TnRXaEFPZVZ5MFU0cjJzbTJEOU9sKzlBL1Vw?=
 =?utf-8?B?WFEzOW1ZNys5UHFlWjlIU1Vja3lYZzZzV3kxMGpXY0JJeUY3VEQyUXlta3Np?=
 =?utf-8?B?N1hjU2llOWNkSXhpVFJCTlhobzFNdnlQRUljNTlPcWNKUmFPbWxUa2YyeTkw?=
 =?utf-8?B?QkI3Yi9BV0liUGQ3M1MzclVqbmJQVkxNM3BJZ0RLT25jRUZneXMyZGszU3Iz?=
 =?utf-8?B?eStpYlVuNTJGMHVUUFVLbVNZcmdlUDBpcVJJMEFFb1N0cDFZWk5NSVVlVDl3?=
 =?utf-8?B?S0VmbEhoNnhpeXM5ZFduQ1VpZkt6U3NBZ3JXRXpKUzdFREJrc21ZaXR3clNr?=
 =?utf-8?B?RktFYW45NWVBeGlDQlBLcW1yaXk1bklUaDBhMUZsV2d1WXJ1aTQ3czdiU3N3?=
 =?utf-8?B?dWNML3VLbUNuZFROZUlGOEJuQ0cvY0t3SXcrUkdKeXFXbzM0anZVT2FzbWdt?=
 =?utf-8?B?czRKV2g4a0RhV2FIZmF6WFlQcmM0ZDExTVRsN09ZNytFSVhNNzFpV2NvT2xt?=
 =?utf-8?B?aCtvUXNwVGJ2bkxERWxYYmNuNTFOMnRaUzJ3ODVKNmREdFI4QUIwbGp4ZlhC?=
 =?utf-8?B?MjlQRG9iWkY4dUYrd1dYaHJLV2IyeEh1T3pDUHdUU0Jtb1ZJdTZqZitlVVlI?=
 =?utf-8?B?SExFb2NMNzBwdE9pTUxLV3dKU0tCcEI2WXlpYU0yUlJjU0NCaWNRNXdyQkV2?=
 =?utf-8?B?ME4yMWFYYnhTUEFnUlJNSTNEZ1oreEZWT0Mxd1hoZ2QycmVGOGptMDN5U1Qy?=
 =?utf-8?B?ZkN0cUgrcm0wbVkxWng0RmZmTHNEbEpGV01rTzdQVGVacXViT1FhZlRhK1Ft?=
 =?utf-8?B?Mzkyc0NOemdCcWszc0pDUWl5dm1ocTZvSkZUQTh5TmNZKy9CSDdmS1hrdTU3?=
 =?utf-8?B?ZnhDdUdVMVdiTDc2TEY5RXB1SzBOR3RWYkplWEhOUTJzK1B3bnZOSnd5SHlY?=
 =?utf-8?B?WG9lSnBoYTNiaWdwWlRFWlhYUmpISkFXbTBBNGRudmJsVUd4TThvN0JVOHZV?=
 =?utf-8?B?RlV1aXNMaXRsTFFZbGZzMjk5SU1iZUNoN3NKSGdCZW5HVVNhSkpnR2ozeGtR?=
 =?utf-8?B?ZmwrVHJkUE5KUnZTVytEODJvZjhIV08yckt2NTlGZ05yRE13K0pzdG9NNHh0?=
 =?utf-8?Q?lV/HSec8+MZaOx9Y=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad52cba-8b66-4da8-808e-08df3ab1a41c
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 20:24:34.7864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2mTX76HYBpWuK88xzs+N1WoCjoluWhMuMPLyZrsuo8lJThfsijBHIo9ue73kt+qGq34rUSv40AUdXtXO2Dzvr/yREgjikycDAJAH/5+mL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB9493

On 2026-11-04 10:10, Mathieu Desnoyers wrote:
> Hi Juri,
> 
> Please find in this series eight fixes to SCHED_DEADLINE bandwidth
> accounting, on top of your four in sched/urgent, with the selftests that
> catch them.
I'm taking care of issues found by Sashiko, including additional
preexisting bugs. I'm also taking care of yet more preexisting
sched deadline bugs identified by a round of Fable review
over my updated series.

v2 will include fixes for 17 sched deadline bugs, most of which have
reproducers.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
