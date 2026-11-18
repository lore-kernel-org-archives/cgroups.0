Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.100
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795009492;
	b=ijD8TDBniJOa3JAG6ejo7I9aCgh2HzB1lGdaE6lLZSwS6FUCeqbcit+gMrXPEiM5jQYS
	 0YcTspPS4sVYA5b74ncbf0ooCxrWF+RiovIARoKKp3eFxJVvmrA3C4Zx1f+rKVF0zQWen
	 rAEuGsxCUOyjlShThzLCZzfAznSauj/T219rwhf1dn7aA1nFZFJH7G2YfrrVq6klsusoC
	 nadII2OmsGyx0b5Owgfqp0AEZrfjgckOh3bndV4gEhpKy831uO+xWMJQmViwiAhkzw6Dr
	 3+iSDwsIRtIlraSTYmf2Ot8L3obSbxkuBuSBZk4/3CX1y4oo6yBioFSQKds4T29cWSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009492;
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
	bh=x/D5GLCdkWoucjtSiDwdb0e+0Tl2CDlfFJNe6ZUHRxA=;
	b=cFDez2hzwcOi3aRwX4aLfPhZt8Qmt80q01qe2nXjH4zhOGPLYmkt8KCxvFjEIXxEkqDm
	 83I6WGelc8XTLVqP86nPO6wXvTdT2Jtd+UEJemAvsd5NzU1tIZ4PsBqfW1IEmDOdoHW1J
	 CMjL0wyfudPRtcasBDZMVSdL6W4bSUKtaJLFMbW5cdu0Ek1RpHQL+wPhVn6ASb2XQ4yW/
	 OMxEZlMt5OfA4enCabzBnuspRNhHMKPKAdRajRrAc2+juFSICFB3fMTLqZRoQZyGhb8SH
	 CspAAIxP36Pqld6fhBtVq9PKx0iynsmtpqqZL9ulq2P8n6prZ7Wl/cuuMMk2r1KYRhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Aus4pigh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.100
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020100.outbound.protection.outlook.com [52.101.189.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA523606A31C;
	Wed, 18 Nov 2026 13:44:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA523606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Aus4pigh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8ckg9LtPxEyRYRHJ9l5dXd5w8y5l8qf7tyFqJ1WiNhNly253PRvYt0q313OpClDQaykiMbIKyW2OfRZA/eTfeESaZ8SuF1YefGlbDu3CbjyHa+7jRhufR68iKHox6b3KV+fIIL3D99BYt8WCMTz942SzZZMoWi7vL/yUKi0WXKMCMcgfsIPRZDJVRqTMb4SJtgYg11E3AsoXg94T+DP+ve91rcEZZoXweGOMhJhZEUt0QNO81E7yrEpN3KSP2nZn4YmAZr1w2GG4K5KLSq4jnosI8maBeVRuq83NZU3FCtLhrmOJ2z3V4lEQultvxzp8W6pyoH98Qe81QUFfpwdpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/D5GLCdkWoucjtSiDwdb0e+0Tl2CDlfFJNe6ZUHRxA=;
 b=jTuhigXcs2zEdWB6eT7C6g7dAp1o9A0p3I6duZPE46SBw7NNnLLShSMV/+BSnUouZH4OTNCjLZowtrNisqshu+ZddrDtJr+4cw8KhbqCBgVqUaX7+h1H4ub7emxmlE/kUXVtSAxr/Wf0rUvmNBZN86WTyezJn9Kj+hnlJ88x0uRy8QoK64PHPukdORHlzEQ9VXnEPsa7q/byQI6Rqgx3iXy488KSj7DburN/OiEeooZJStj5k6iaIWiQS4dTwShs1u7FF/rL7vy8MCiL6TBTGdk6nyXADcq8Qrahnv28t/iPkOZ69A6NECg8jIkPeojQFwHtq2MhiQS1ILb0afaWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/D5GLCdkWoucjtSiDwdb0e+0Tl2CDlfFJNe6ZUHRxA=;
 b=Aus4pighJ//eoLQLi6dp0ZQsEj/os/xTYTbAbSb64x9er4E5mrdzxeQ/oy4XI7t9qM0PR0sQYFzd+WnFjsQKMoluGEI6O5Yh78VviD9/EB4MxjEtWdnCSz79jGOeuz12KhzYXSYUlAd8uNjWeYZGdny25mhnJHRuaitnoP0NIQ9k2u9S3187h1QSNuwU7RrKFxGVDSFnzUVzhy6a+PDkjB6vxb8+tKPTPHytB1rLNODFsTEDeEV+9iOMKYFR0P16dpUt3N3N9LZ+uOZBloiGvicA9y3DMv06+3YL65uDSN+hAqeVyXNCeyX6PhW/+ak3HDNpMoWwuQCnpLcqd5wmTw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB619307.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1b0::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 13:44:50 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:44:50 +0000
Message-ID: <ddd215ff-d6de-4dea-b12a-80948a9b5ea6@efficios.com>
Date: Wed, 18 Nov 2026 08:44:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/40] sched/deadline: Do not replenish a boost from
 cleared parameters
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
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
 <cefacab5f1c0e7617f17e050af4ef5f6db01700a.1794922146.git.mathieu.desnoyers@efficios.com>
 <av2k8JlLvUcBBOhn@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <av2k8JlLvUcBBOhn@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::25) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB619307:EE_
X-MS-Office365-Filtering-Correlation-Id: 7904f9c4-5833-4481-a9cf-08df457a1e03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|4143699003|56012099006|10067099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MzC/1X6Ac77QKlJcRFbNrBN7eL4nAhI4TkPLwy4wh7T239HMI9zKsz3hxPIkaMJj8dFVSvKRuPVtX9XhaDlW4PuO5uXhwArsO8rJUGbC82bAq5NldgC/dJaF6gIcfrgUkmLays5wQdyofJvyTzESSF5769n6KUhk4QpIfLO48K4/h847qR83CXtKexB17cpUOfQOcHYK72M5Zd0t6n0iWlfihP++0ZEgwzG8GZKmShw1jxtkagBmCz2kgfC470+bwadMfvkLjJeeI0nYQSCdqonoj5zSMQW2p1JL2C0IAu66m5wWoV/sm8Ro3g6wGcnOf900cnf2IY3n5/WoMuwkqEh1Lih+oIvcSjwoA4xi/Ku4geoK6jHKrkPt7QvvcAPOyJjxyisJNxBi5tM6VdHCDjt1jiGPuya/3irbzH/GY1x+oq+Bpx2gzkWbhlEiezrZOPavfCEaalcbF7ZstkwovqfNzE7k9R2CJckg4KXd28ey2FICXuCaLEd0uKAgRTvDY9pPaQqCquBWHktmPR2wi+rA+qrljnZgWNuwGrq4sGfdNNPJxsEc0xT2xIuZ8SD/3uqvTHM2rS8oRsBj9QQvq69VYS+h6SUteji0p+/Itao=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(4143699003)(56012099006)(10067099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVpwNFZjL3kyWmZCT3htcjl0U0JJdHZwdHBsbExzRGJRWG44WE1YcTJpeDd3?=
 =?utf-8?B?WEN6N3NGMWo2c3JNM2hTTlpjMGRSSElsMVBVZjFPbWg2RUE1ZXV0WEM2UG9N?=
 =?utf-8?B?dFRoQnpXQjBkNndEL3B6N0Q1SnNicHNpNXJSdUc5cFRmQ2dHODhnT3hQS1NU?=
 =?utf-8?B?YlNNWlRIbVFuQ245aXR2amNadXl2VmFaS09FbjlMOUp0bVpWblVZd1RPRnJ6?=
 =?utf-8?B?ODRzUEVjN29PR3B0bENPcnlad3hZaVFaYU1lZEEyMVZvUmhxMTI5c3FmZTBh?=
 =?utf-8?B?d1plK09rVnBjc2Nnb0xiL3JiaGJzU0xMdkRMVXVyc0VhbHVRMFFQUlZtRVV1?=
 =?utf-8?B?RElmRzFRbVhKUEJWeVdORXpQNkNESmQ1bzRCSWJxSDVrdTBWT3Z5OWVmMmln?=
 =?utf-8?B?Z2Q3KzI3VVVHNW5kWlpnRk02b0xycjBSeGdRYlFJdEEwLy9EQmdvbWNOU2gy?=
 =?utf-8?B?NVlVT0F1ZS9WT1lRZVdueEU4RHY1a0Y2TjlSZ2pkVG1aYzlVaVdJUS85eWFN?=
 =?utf-8?B?QllPMjNnTTNGMDd1V1ArTllYVDE2Yi9VS3YvZXZyazNGWEw2TlFWYUY5T2Nk?=
 =?utf-8?B?NVZqNWwrRUpadktxZzBaMkVISzFBQTZ2QmJDeVE5Uk5VRVk3NjBRWVBxOTFi?=
 =?utf-8?B?ZjRpUHpQZHlOWndLMXhETHVPRm5uTVVab3MvaHZRTmF0T3pOWVo2cEl6cStn?=
 =?utf-8?B?a2xaemZoU2ZPR2dCUXZLSndYeVNvc2t0ZXVSRDI0VWs0WVA5YllORkdabnRv?=
 =?utf-8?B?UE5FOFhTSUJTQWlndllCUlU5RE1PdVZmSmh0cFJMSnpjZ1M3ZGV1UGN6YVlO?=
 =?utf-8?B?UzJVaHUvTk1Na01RcVUwYVBPZHQrTGdXcDRNcmZ5R3ZPQ0xMSTJTSTMyRG9Q?=
 =?utf-8?B?QU9UbVVYcGRRM3dKclo2MHlWZVpZT3lHSnF1dEZDb01qRHp1dkVzQVZtVWJ6?=
 =?utf-8?B?QmxVZHcraVcvVDF2WHlQTG9rekhibjdzbkpRMnVNVVp0b0VWUExYWGx6RXpI?=
 =?utf-8?B?WDYxdEI1cmZzQ2w5dGVXSjcvM2tMYXlTb1NOck1hL2h5UWllSVVjM3hSQmdO?=
 =?utf-8?B?elBUSkVmeGluQWR2NjFOMW1DZ2hBaERSL3FuZXNtM2lQb21mZW05TVIrZHUz?=
 =?utf-8?B?UlR1Q2NJcXE4N3VZbDlGSDdjTW8rSVY2ZzNxaHFBTXZjYVc2eElNb3pIUnoy?=
 =?utf-8?B?dTRJdWR0Rk9yeW50YkpSYmpGaDVreWNiRTEwQUNVZE0xVUlRTFRCUXgweStV?=
 =?utf-8?B?ZkRWaTJtRE1ZaVlHZFJyRDBlUGJIZFFtRkFRbDhFYzR5R3I3WFBNaUUzQXNo?=
 =?utf-8?B?VUFyYlFTbUN5VmdLSVA0TjVrRk1GYU41akFVYTl6emhIMVZmTkJEREppWHFq?=
 =?utf-8?B?YjJwdU9nVDFGR1lTY0NUUS8waElNNnFKelFLczQ5ZHNxSzUxTXZyMlkxY2x2?=
 =?utf-8?B?M2RSOVh1ZDNHNTBhSDRRS0pFZnNZU21Ua2lQOStaa2grWlZNdlljRnVQRWp0?=
 =?utf-8?B?aTJheEpZcndiZUsralVWdTVqVW5RYVVRaEVkUXh2b1JQbGVxQ2U5NzBOK2FL?=
 =?utf-8?B?SWRqeStXZmxJaFM3SzltSnFRMzl1NVVvZ1JhTklLcnRYRUZFV25uZ1BQeUNO?=
 =?utf-8?B?eTF1RHplcmdad1J3aHNib2hrWWk2WVVXOWlVa0twVnM5dDJickVtSWVPTG92?=
 =?utf-8?B?b2R4Y2NSQUFTMVVXcVRqQXFyeFk2VTN4c3FPVTlHcU1RWSs0VEFoSmk0Wm9I?=
 =?utf-8?B?U3JFSDlYQUdHZC9qaGNWQm1hYllaOEJ4L2xxazZBK1liYUNyR3N4TTFnYlFY?=
 =?utf-8?B?KzBENDFLNytjZUNLVXpST2JpUFBjaTBBaklYOFhJb1I0TzExRDc1TUlEaXRy?=
 =?utf-8?B?VFpnOFNhQmllOUVPamZjbXBhN3Z4REtxNjJDM1VRVlZoVFNSdVdXbVVtWFVV?=
 =?utf-8?B?a1JMaStTdDQ2WDZDT0hPQmtVb3VWVEpBSGR1cm1ITU1yd0VjNURzWjVMUVpu?=
 =?utf-8?B?TStaWFEydWZ0Q0dnVlFYMmhkRlpYZUc5VFQvb09wSTc4djVkc1k0b1FVeitH?=
 =?utf-8?B?L1ZvVU5CM0FQVWR0V0hFSC9BaTA3aW9QV0hMeERUZTZUQzg2TEhBbERGV1kv?=
 =?utf-8?B?TmRqVlFKblo4M0VEcUw4YUNpRzBESENWcGJWcjlIYVRab202ZkZhUDBmN0p1?=
 =?utf-8?B?VHV2QUdaZGdoVE85dVp4YUQwSmlpN3VobTNiOUZRUk5McnExTHdwNmxaYm9W?=
 =?utf-8?B?ajA1N1k4bk51OHFPVEs4dEJwTEVIT1o4d1FjbVUybFBMNnpYSWczTml4ZHlW?=
 =?utf-8?B?aUxHbld3VHE0QlIvdDRURk0yY1JaVmo1SzZiRXVlQmViTlpzdnNkR09ZQmNQ?=
 =?utf-8?Q?Yrg/YXNgEKh+IPSMRDAeR01mamQpFF5oAclT2?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7904f9c4-5833-4481-a9cf-08df457a1e03
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:44:50.2542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSBlirgqyzReNu1ELI/qqdbK04lJyM0eC+/uZ9ZlslDW3sb6qvImtfRL0KRt1AdU7pc3ZkbJwht+6FNrFc3NAtx/BJVB9TmW5wc5kAvKuoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB619307

On 18/11/26 14:15, Juri Lelli wrote:
> The above paragraph is a bit hard to decipher. :)
>
> Maybe something like the below?

Yes, thanks. The next version takes your text as is.

> Also for other changelogs, I am not sure this kind of info adds much, as
> I fear it will be hard to track down in history anyway.

Agreed. The next version drops the sentences that name the review that
found a bug, in all the changelogs. The credits to people stay.

> For the implementation,
>
> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
