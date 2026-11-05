Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793908779;
	b=u1lwjFyBQb/ZtMosfElxrrh3DFt+YsWfmF0uoeRks+cQYn1vApGyHH+r0qGwamElP/gZ
	 A3WMx6apKcU4EZHg8iFvwAJNlZoCxWYtDzAZ33EWMJ6BK1VyHwhzNGp50Edah1krIHmmf
	 eBi0A/lBy9eamlxiEe94pquFozAr6eiBVbUvlzbpnsvJTaKfITZFYwZiFMiuXjVKvMUsx
	 hUrwpnxgUFD6Skfvf+YNZ4Sl6q/eajI2kPwiyuVqfpPH0cm94c7MMKch41cACua2/sc9m
	 6uHaYoJKq27XvelXNpdeuWGISwoNrLG8GgXM3upFUs+dVHsFMtooT88uMXRqwlrezIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908779;
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
	bh=/cFdn1mj72YHkfK5RI6WBaxcWTfO7XpK3ID50uaKFGY=;
	b=TbBSjGmrkCcawzriFJe/1i9Jf4Dp+z+SzvYhaeMCBTncBWnSuJ6+IaTO3sgh1sJGov4B
	 3eXFG12muZ/zPuTwSsRg/l4Vop5jMlEkS4IX6xdFHapZcNkrSL1ndeXyRXnfg7YGtxvdx
	 Gdu9vtLTc02/BcqnKNq2nM78FaxNjkKCD5FvK+AF1NqvVt8glQsOm6RVdwOS/G4yBgFyh
	 lLNkYy1MufvvL9QqSfwYHl3a7zom8GNdotp1Z3tWoNyBClCxqo4CAvCOeF/rmKVXFI/OW
	 w6u2xY0JQg7T52IQyRC2G0wOMIlRSILQJqGqIdQxBZnhn7Sf9qFAMi97kn3REFWHIZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Z5lHfTFJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.83
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020083.outbound.protection.outlook.com [52.101.189.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750EC606A32C;
	Thu,  5 Nov 2026 19:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 750EC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Z5lHfTFJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUL0nwZ1I5YrW1gRNl9xnfeSRNo5c/mziUC29JKb3lCkRExKPu06HBSSlIoeNgdawSdF7dQ7MuppdzzVWRTf1V4WVNvwN3iCEyl89LrJdbAN3pdeCD5v5pX+gpx8zznCdznismtv4+oFyzQkpRWvFrPQKL19PooF/PQT+Mp+oBMVMGo32j2XQc20EZZECWk3JXmcl4YacHnxYcAZ7t6Nn3eCKC0O20lJ4x7tSGO9NFgqubJF7QIOaftjpd/Ng4i0C+F91TFteMyRWbu1gzEz2XGBr7ZKgTMTRze4d8qLjULVbBpQ3kFTi+YtE0azqGNunR7xsq/kgbVz8iawL07s2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cFdn1mj72YHkfK5RI6WBaxcWTfO7XpK3ID50uaKFGY=;
 b=F+NxrN+A4JhHwHCUiYA1ExZfMwZcaFjwCJiIGVcFnnDb/qbv7lRinDLvVkr18ocI4ww5ERzv0Aq3t39/TaY4xC1f0SdCdDXsGCiC/Od3TbI8kgjq25h7sk1Job5wOM1UHDCFK7Q4fV26+VB73LidEs9YGT0VpB1PjaUDA49vCnaUqQOAiWdNFeIk59D8IDqA1eZ6z1+yMvE6JGNxXVEWlscGK4lUdK8Eg4BoL35tsrl97JZ1FqieMDEQDfOcLFG43/ITTA2EyGowoHdW++LCCB6nQ1c7aXjVdOPwT+ruov34Q/HfXcKDreWaLp0bO68lSaHMhHJ2J/OBgbHHdJ/fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cFdn1mj72YHkfK5RI6WBaxcWTfO7XpK3ID50uaKFGY=;
 b=Z5lHfTFJxxOrPg8au8O4eFUpSsX4H1L6kOwbfzOYWKwhu6HqZRiV2S1DknyFDQ8PuQLP3rK/wt4Xd92or5Z+/PMosIdXlA8UvGAI07pjcrr9vH4+T9a53Qp9RfCTnGQO1OMuPflYpzaZEG573f1dtF4/VdmfDmdVHSIZw5SsHAiiO496U0gvcyJlHewAIdZUTV66uLDNMZBbYjZJiFe0SfEqSW7swiS2l5iYabwDV6u2co8JCFtAVv07+uy5udvtTaDKA9w4Q77xreTm9vPG4e5pW2YrTWDnr4cFm5orbR6kJujWfN4D9cYmAaqTLrIW6jsMu4fPxuBgaFybGavrZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQ1PR01MB11773.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:be::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 19:59:35 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 19:59:35 +0000
Message-ID: <9dc16f18-a387-4d76-8a20-e2e61b848781@efficios.com>
Date: Thu, 5 Nov 2026 14:59:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/24] sched: Fix cpuset_mutex double unlock in
 __sched_setscheduler()
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
 <9307bef8-80bb-4b27-b7e8-9a63fe98326a@efficios.com>
Content-Language: en-US
In-Reply-To: <9307bef8-80bb-4b27-b7e8-9a63fe98326a@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0260.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::34) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQ1PR01MB11773:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b28820-c0ac-420a-6024-08df3b7750cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|261022105027099003|261028144727099003|261021121427099003|261026121527099003|261009223027099003|261026140227099003|261102123227099003|4143699003|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	UhwCKx5ZhC2dNbHq91/MAKsfO0IGyQqAsJpmwCjdxNb+gGCux8WbjFRPVOh2cd6BcOLyBgIIhwBpfSnC8CB9eH0U7sndDsCpgB7dfVRd+WU6+CnHMf6VatEa8/iVD60E1US35P4c/+3PhKnVKZaCEhGBzoKa2uX/KiWqpRv6BuwWat75WOxsdGp6syPnnvPmhjuikAwQiV17wh2SWckQGncRP7180gbeQH4kbNs/FDyQCpdJN//GpmMFRUyovvRZR7LY+os7yysJUpDLYRQIFLXJpz2wADr4OFSASVE+nXi2eMD2PR6Z5XJZmBlUwdOPb6JS46pplX2gun3XDh7cmyoB0nYZNZ6WOraibgZaZ1l06ghtVch7k/PaQ58YGul5OOfFB5YoSnGovxQgSZDg53v8vfYr+L0/cLdf//+sz4cAT2fIjTBNHJIfQbcktmAfPUknFtRN3jlp/vKbxHRFVsTF2d7UzctZkeaMSVF0yPKxrJdG7xzTypWWkLIg/N1EJy6OIHS++m3LiiexNR/d8zzhyQt4Db2+0gfHg5ASP27lKlunsg0ovQ7jgQ0jdZpXOepJuDb7witPkHSRLzoeNLwJbJ944CNpu78T9inCNWw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(261022105027099003)(261028144727099003)(261021121427099003)(261026121527099003)(261009223027099003)(261026140227099003)(261102123227099003)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEdPUVZ2SGNaYlMvbW9scUVjWmZmaUd6aWRmbUJYRjNkWm0ranJnWE9weU1P?=
 =?utf-8?B?cmhwYXowTTRQSWJhcXNLaU9UVTVxc2l3S1RBUTNUL1JqeGQ0Zy9RbjJ3dFk5?=
 =?utf-8?B?VGdncDlWdmFQLzJNMHpmYnNaVjNzMmN4WjZRdkhVcUxrSXNXUm11THFuWnRT?=
 =?utf-8?B?azljUkhRREY5c3lsOUsrRlhwMW9QUkthR2EyaGxxa3JVd1Z6dXV3WTBJNkpt?=
 =?utf-8?B?eHhWVjdGenhmKy8xRlBlbm5KZTJWNjRFUGNMd3ZuQUwreTFHV3lJQW5sSzRL?=
 =?utf-8?B?MURPZWhUZWxqQmxBTDNVWGRrWEhFSGtsaEpPV1R6QzVLT1pLelg4WnpPc00r?=
 =?utf-8?B?NzF6T0R3MGdobXk1cisrNy9RZDBibVhXMFg0SWpZVFRSakhpd3AyNmwzdVRZ?=
 =?utf-8?B?ODE0ZVZVZlJ1SzNCckFZc2FvWDJVTHBxWFc5Ly9ORWJvdVY4Q2k2M1lNMHd0?=
 =?utf-8?B?TU9SU3pGLzJyU3AxRldQZWxjblJITHR3a1V1cm4xdFo2bUppTU5oUGltYVFI?=
 =?utf-8?B?TFhvcko3SnMybHZmVGpIemlqamlEZzc2OGRmU3FKYmhrMXFXU1B2c2ZPeVNM?=
 =?utf-8?B?VlpSTGFWTHpXODJJZk5ZRHhURFRWaXlYeFRiMUNTWm5ES1dkZnRHdGNMcU1X?=
 =?utf-8?B?TXd5d3plcUt0UTAya3Qyb3B6bG1iZU9WRktXZllvcWg0Uy9YWk9jU2dGbGFp?=
 =?utf-8?B?Mml2YlJEellYaDdVTW1BVCtGQlZuMG8wdmNtSUlUSmxOanVjLzJkZnVtRjRI?=
 =?utf-8?B?MUkxZ3UzcmRscEN3R29tOStjcjM3b1lKQXNUdnd4TnNwQVlRQStwSFQ1aFRk?=
 =?utf-8?B?VEsxMkhWWjk4YmRGK0hPOCtuRjM1VXMzd0JrcVl3b20vUGpEQnc3M0NHQXlS?=
 =?utf-8?B?SlltQXZ4Tm9rc0lYQTVjOEZyY3BHRWYxWXpTanJXZkZ4Nm95K2ovSm4zQTFi?=
 =?utf-8?B?bUF2Nyt3TmFxS3pxWkIrcWd0d3pXdm1JaW95TUZjM2lDZ2ZlUXhxMVQ0TEhq?=
 =?utf-8?B?V05YSUtUVjBBaUp4bEpCQnlkU0NuVmJJUXFoOEFxeTI4Z1F5MCtvQVpWbXZ5?=
 =?utf-8?B?L3YwTUdKUnU4bmNoZlJ3WDlPdkxJQ0F5bS93bXdVbmRqcW5PQ1dpK2NzTUlJ?=
 =?utf-8?B?Yzk5Kys2VDFrblBkMTFqY0Q4ZGNienZjMGFRZXArMDM3cHlqY0hxaTZpV01k?=
 =?utf-8?B?dVQra1BYVGo2bkVydjVwbVFSQS9Fci9VZjhOdWhLRzNDZ2RWdllCTjdxUnFP?=
 =?utf-8?B?Ni9MU1MzclBldmthVys4UEhtNHhOUkFmc3NKSDhkd0JvdlcyVThUYzVhNE5h?=
 =?utf-8?B?KzFNL0w3c083d2ZEeTVzMHlJWmZMWXBxUWdMY0d2T3orSXlSUGM1Y2I5TGVS?=
 =?utf-8?B?aFdkWDgvdnAwdUhLZm1BN3Zab0NTZTQ0eUVxbFcwa0xUWkdjNjNiRXJWV3lY?=
 =?utf-8?B?cDRMdEhyL1U1K1BPR2EvNFAvSzh2TnMvUzBHNHJ1RUprbUNDbWk3MnRrZDlJ?=
 =?utf-8?B?V0E3RzJLOWlTZDY2QnNVOUJvNmw1NFRHMGFtNjNRbHZKSVdISmtGR3ZyRnQy?=
 =?utf-8?B?MFlSUDlJYXJ2dlRhWXcybjhQVGtSNVhCZjM4UXhTSVFabmZTYjRSRW9SeW1W?=
 =?utf-8?B?cis4M0UyVEkreW0zejNUOU44bFJjelNRT093WlhjZmtjMDFBT1NSZ1VtVHpz?=
 =?utf-8?B?OUpmQUduSjJPYlF3ejIzR2dRRWJ5eFBzWVRQWTRSV3JKdWlKY2MrQTVUZ3NX?=
 =?utf-8?B?cHIwNkU3NXczVkw0T1pEWjNjWkdObXhhbnIxNFFhN2FJT3RBdExPVCttWldw?=
 =?utf-8?B?RHpWVS9EYXl3OHh0dERNcWNLbUVPeDE0T1FFblJCcVVySGR5Z0JqUjhlcnl5?=
 =?utf-8?B?aGUyYVpUaHJjekVueGNiUFEyZCs2MUpsUnhKVDcyOVV3QU1LZzBVdG5WUDkw?=
 =?utf-8?B?bXpFV1NSVVFLcnJTc0dUZFV2TUFmWWJqUXJaRC9UNXJJclVPKzJpRVMybjg0?=
 =?utf-8?B?b3lGUTIwS054S1lRRXV4MXo3MXhpNDRzZ1JlOGhLYWxIZHFTWUV4UFpzWUw1?=
 =?utf-8?B?cDZjVm85ME5ZOG5XY0ZuSWlsOWlXYjhxNjlPRXNZdExVSjZtRUlqd0F6L0o1?=
 =?utf-8?B?RXhoL1hlQlRndEJna3IyL0lqTWkxd2tyZmNRNGxoZXdRc3hERWhxMEdFci9i?=
 =?utf-8?B?Wi8wSW1QVFhDbTNFRmpaZVBZTHNBYmNCSWFLSkVoa3ovMGx3V3ltOEdCS3RM?=
 =?utf-8?B?V09OK2hsalMvalJDTVA5a3JTbVVGaVc2UTlJTzUwdStwdkhtQTdqcjRQa1U4?=
 =?utf-8?B?TG9wVjEyUVZjdS85Rkh5bHMyMDAwc2hSSkRwSmxXM0dRaWlzbWZHM3VCZWU2?=
 =?utf-8?Q?QuWGTtVZ4dGYSvDiAJqEsQCOLvB9GN23eF/NO?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b28820-c0ac-420a-6024-08df3b7750cf
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 19:59:35.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EFAnl2iKHNP/QrZ+D3D3dB4aB9s5VNR/yEhO1jNEsxMP0QrnbsOjF6QRS3lfqK4Iz2G9HonhJryjwunaIu0CGmUUK/CujGXmQ54BY1c4Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB11773

On 2026-11-05 14:54, Mathieu Desnoyers wrote:
> On 2026-11-05 14:51, Kayra Cizmeci wrote:
>> On Thu, Nov 05, 2026 at 02:33:36PM -0500, Mathieu Desnoyers wrote:
>>> From: Andrea Parri <parri.andrea@gmail.com>
>>
>>> Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Link: https://sashiko.dev/#/patchset/20261016062629.2102883-1- 
>>> sh_def%40163.com
>>> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
>>> Cc: stable@vger.kernel.org
>>> Reviewed-by: Waiman Long <longman@redhat.com>
>>> Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
>>> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
>>
>> You gotta add your own SoB, no?
> I'm just relaying the patch and did not touch it, I'm really unsure.
> In any case it can be picked up by the maintainers through their
> preferred route.
> 
> What's the process for this scenario ?
> 
After review of the DCO documentation, I indeed should have added
my SoB in this case:

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks for the heads up!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
