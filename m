Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.90
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795009530;
	b=XRC9mk3cx5Pe9gQutVgWhRbO2iIw230IG1mZhz8leWIVyhuvOLl1SE5rNTMffSRcS1hO
	 N00nFlE26fMfRdHY97LflNOccMTHCQp881YgO6WWLBREOq5H35oumYjCqPMqRwH4jppMh
	 ajj9X21JSPHuItUQpyenVimhSPFxED5e2XX2USmSOB0P0Wk57KWYguedE3v9LAtO7oJGQ
	 TEInOc0vebjTS+s0Yrrp3X/blh9bhTLQ4EFp5Fw5EZ4iowP5CYgvmsmjkrkFk1M/Lc7C8
	 7UHlrzYreaieq6UUFVfy3BfFhYdXsFRZlI11pZDK0WyuA/Vk9Sb69qg3w/krCzXjaZQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009530;
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
	bh=78Dn0Bv4KX1COOOxX6voIv2qi9lABxlG/Hdu53wsRRY=;
	b=tvBfXGn9MK/hp7upKcANRzFEfer7o5m2i7qj/iGHElZB0ahE52pSwTrzJnDbVwG/XXhS
	 lqkAjxcqMhZ5R8+d/aOOiC0r2eegZKlSgaMsMzg1lR/GDU9DkltIoiD10AHLw0Z4dnjsU
	 3ijKEKwRyNEjQa4+mQkNqc6jgsB2wJk2uLh/BL3amLXMy7txaJrIxEu4O9VyhGboCoP+5
	 jN8imdOSHXumKrZtCDsVK7lTjaByYq5KiHYaJfZRNDl2fwpv4yunASxMMKsf/1ezjmkfB
	 ZBjnqu+3rAsRT35H3xE6hq5GpI3IDg8Nr5sy07i0fva7gRyeVbpbWu2ZJs/24pU8fHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=b1AW0gfV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.90
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020090.outbound.protection.outlook.com [52.101.189.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D91F606A320;
	Wed, 18 Nov 2026 13:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D91F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=b1AW0gfV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bxvEq9KbxtrTC9YwLBY6bwtoAB1c5iueQJCwuQM0rwmZspVfl0jF/1W/xUWVDnhFiYUHV6FR6T6sEeMXjAfB3sVM+6ryuFAvfZ73+CwgT48RaDsDDic1rdgxVXYphxY5gA09x7CMkAOluH8dU42R9W0d3IKNTKlFKGPK3CUgy8lNa7kcGnzQH5g+5ceVSAZQTaLyUv78eb/k9aapN0VKe40uHJ/L8H7ZGgH2EqsNM1316msnoq251scT1VMbuepK2XhHJBtOGRoOa+in+T0iq75+IXa4LoUMNN1Aaiukxyw1lNv/YUy0TXyvW0VLtsXrqRwTFXLHCyjRo+v3m9hOIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78Dn0Bv4KX1COOOxX6voIv2qi9lABxlG/Hdu53wsRRY=;
 b=r1Aayydo4S/rE3VR9/aNi8W71nFYi/qnlztEZIj1ZvOqYHYicmAz05iP4qIBU1L2zpEaCziWl2/FaHhw3Zn9uEvsTPfW4f8/KkJCJ7TXCVuKKVO4W4FZBd+x3GAHtBoU6Ezf03pQrTG+IgSTYClmwt0cl5lTEDRrI4KMRF4wPk9zE/QkQ2kv8uj9MPm+iT+kNmPGE+w4B60cF5k43SmIftaFBnaAZdCPko98tjpT0NwRtWFSVW4TkvYx2p7m4x1bUouip4oX3PLd2wJecvelKG9gT9CMzWWwrppy6j19PAhib1A2LaVZqLj7aAmK2mcqldvQFvkm0CTkYyhEBkHxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78Dn0Bv4KX1COOOxX6voIv2qi9lABxlG/Hdu53wsRRY=;
 b=b1AW0gfVtd7HfQMNEaKfT0BcSTwQxIMOWZTo1V4YvHE7ddt4sxnOLXEgkhXdoq36Wy3e+FIsJsip5u2DGcii8UbyAFiqkRR/94Jhspdnyc08Oeg5spLDlbKZOtDxmdzpgnaz5YrUfRUcBwCJkYeyvSItlWdC0M3wtMzq4wckUQ2gingWWZY4UEs7R/CUYAqzcmEkAraDBN5ebkDczITLdJssmzTfDCQbBpKZIgL2GwrYEu6FbWqGfkrWz444lGz3/M0KQJ9VYb/hKJVXrkzttgbEH30vWvqgp5bX9Ed6AMSX1RhTMXvI6yd0tSaiqW2K0wYjuhNtLCj48sxfYzo4dA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB619307.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1b0::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 13:45:29 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:45:29 +0000
Message-ID: <f4c80cfc-fd98-4010-acaa-042c1a0b1cd9@efficios.com>
Date: Wed, 18 Nov 2026 08:45:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/40] sched/deadline: Refuse dl_server debugfs writes
 while the rq is offline
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
 <2bee6a143319301f082855a15274f0563e99b8a5.1794922146.git.mathieu.desnoyers@efficios.com>
 <av2LcczdGk37WJLm@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <av2LcczdGk37WJLm@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0234.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::10) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 9dccba8f-5eb1-4bf1-0194-08df457a3513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|4143699003|56012099006|10067099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qxSh9Tmr3eUoRVoRSASYIwtOo4flbwvyTOewY0psYJ2czdPJDjz5AmB2gJ33SZb8lD0ykOUVSyg31VUb0Wj7ZL6MuKiEegc+f136sak3CeUodD7l3P8mzjx40Cz1vUSr09bjcR+VZPcLWY2+wf2V/iO1EUit36UVM01Z9dtb2vDemFqNo8tPUVQasiMGNhC/grBug3xGZPB/9412YeOrNFac6WQ6A4+P6wAkDMJkK6jeG2twQ2h4VeKvDM1bq0Z8tMQI6AsWvZCG1nywlMrazJRtnZcE01pdAjxZ/A5fmTYMk4c18E/ZzhzHxYD0JTcDkb/6ku+tTE8yhBsYdSdN/KbnpQIlSBpoFZVa87xoUQL1UjoonKhDppw8/0xtcIEQRykvPaKqo3qTNSorBRaYvckM8DaRBW8eJs2flWp8ziamcjE9S5GmRcX/mmJWOB11J0B5VF7AmRRZZscMdj2R8e38AblOZYqEfSVSXhrx6rM1j5U4Lt/Deg2k3XlfUJgCZs0LagbzBOi9PiisIc/ZIgpYLKtiiU0RG52/gvOfd36ZOvyqLBUbkPB4gvuaYgz9ETK6lM0jDcuYMAC5YxL1+C2GQIB8uxWLYE9bPzEZZq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(4143699003)(56012099006)(10067099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVc1Y0FWT1FTbDY1UGxVNjFYVVFGVkVDaUFKWVBtRXJFMnh0Q2VaUzk0dTZP?=
 =?utf-8?B?RGNXM0JFQW95WkdNN2JjVkROeFVOd3hhbjJQK0l3SGhBR0JMeDV4R3dWTXNW?=
 =?utf-8?B?M2NxUnNEQ1hKNzY2OXVYSE5yd0VLY3Y5c1JCbk5YTmx3VWlPQlBKUE5ORko3?=
 =?utf-8?B?b1NwdzNoUG9Fd2pHY0MvYVBaYmR4WHYvOXJlRUNDbHBsbXVEWmxEQWZSOUtu?=
 =?utf-8?B?SHlvczBSUUFZbDE1RmNiOC9iUlZEb0RnbG9CL0dKVGRUSjY0RDl0Q2lyN3NG?=
 =?utf-8?B?Ym9XYmdPdml6Vnk3dmdvQmxZd1B1dWdJV0kxNzJhV0MrRkhpeFF4aUVlTmE0?=
 =?utf-8?B?dWQ0d3A2Z1hmS2dkd2V3cTVodm5ldmhYRk1wM3oxSGZQVFpIcXVLK25QVjIy?=
 =?utf-8?B?b0k1bEFRWXBiazkyQ0NoUTc3MG1XSXVadHdpa1FLYzlBNGQySTBwUlc1VEpw?=
 =?utf-8?B?NDJZSFpOZEdTU1diOU9Bc3V2dVpnT2VVSEJhd1FlS2gzaExFOS8zd3E5WFdE?=
 =?utf-8?B?QkRyMm1xZFVrcDRsV0xrL1pZbk9rdjFYa3Vqc0ExMVZibDBMUVJMMjhIM3ZL?=
 =?utf-8?B?eEVlbFo4eDloTTZVbjhHVnpmcEl3cG9oczBuK3BzL3Q1UldOeElPMk1Gdnk5?=
 =?utf-8?B?S1NHOE1zMjNLM1VaeDc5Y2g0clVoYkh1Z3NoemsyZHIzbVIwSVB6b2x3RGkr?=
 =?utf-8?B?SnIzczUwUEp0eTJQYlV5REZnSVIydTRLU1NHeUVRR3RBWHFCUW5jbTErNjlv?=
 =?utf-8?B?d0FZVVZUdmlMYzBtTDh6M01pUHpLWFNqSzJJKzc0cGtySjNNcjlXNks5Qjdw?=
 =?utf-8?B?d2ZpR0svL1VWRWp4dDFkbytpd09zWTdxeXF4RnpOK3lBR3RIMWxDbmtkaU9X?=
 =?utf-8?B?clVtMFVKTE51eHN4T3pmVnJpazNwc3FLNjFpMXN1ekt3UVNqRzhtYXd4eXBo?=
 =?utf-8?B?YStub2hZOFpOMTcza1Q4VkEvbUJ2V0kyNFdSRGNKOXFPN1U5VURwdlV6YmFN?=
 =?utf-8?B?UUMzNUdnZVF4c29VSDd3eE9pMXJ0bkFCQUNaYzJCTDVweFRiNWZGeFh1dzdi?=
 =?utf-8?B?VXFqYXJma1NEVnlSQXJ0OUsxNW55SUViSkI0L0NkOGZXVzFSc240M2Vkd2c3?=
 =?utf-8?B?dUx4V2xyYjhnaVZUZmFBa3lmZ1c2dytYNFhNVDJJSytPUDNlZXpMMzlicGlo?=
 =?utf-8?B?enV0a1FhRGxXd05qdkFQVzhBRWNzdHMrd0lPQ3BEdFp2cmVJd2tTamFMbEtJ?=
 =?utf-8?B?a0Q4aU45WFpieVIrV1F3L3hFUEwzcGdEMnZOQTdabVdJcVRzWC9zWkxjL094?=
 =?utf-8?B?aUg4NkxodXNMSFBlUVZZYTBGRTgvWVc1MkdOZEJER2VrZE1acGNwWTR5Vnoy?=
 =?utf-8?B?WkR1MFZIbVZYV2s5TlFaNlZuQ2VYa0lwY0JSVjhDSXRaK2M2Y0tBdXNoQzhS?=
 =?utf-8?B?ZytLbU81dThBeWMxRm5SNUtmQ2xrSDNyVlo3QlkzQXRpMHVlbDlzL0M2SU5Q?=
 =?utf-8?B?WUV4cmU1dTd1U3dwdDlVZHMrQWVUSTQ0WGV3L3NrTW1vcXQ0WHQ0cys1ZjQ4?=
 =?utf-8?B?TDRWYngyRG8yOVpyNy9KNEE3K05GOVpleERIenFCdUVnV1k1NGJKbjRLMk1T?=
 =?utf-8?B?NTIveWwwdTRMTHhJL1A4dmo4MnRKR3FMOVpKaGU0VlUxTzBVeFhyRzFGR0tD?=
 =?utf-8?B?KzRHWEJoTXpHK2lyT1R2dlkwSSs2Q0FLdy90WHZweTRrZ1pHeFlOZDZiVGdO?=
 =?utf-8?B?NDBYai9QUWM0Q2FXazVETG5RcmYrWC9RdFlITVNTOXAyVitYMGlsb1NvSURZ?=
 =?utf-8?B?ZWNWdzFlSEs2YTJkZjA4R05qeGFlbXJZdys1dXZxNUFJU2JQbmhlcFdLSno4?=
 =?utf-8?B?OFRWVFFNOTQ2SGNFSi9nRE5UU1FCdkYybk9nb2hBbUtMbC9KQkpOb21EOEJW?=
 =?utf-8?B?TlFlU2JudXo3ektXRnJlRE5yYzk2UXhTaEh4SUNHNlI3R3VoTUdmQmNpQ05R?=
 =?utf-8?B?eUV5WWZ2N1dTTTVGWFlVS2o5WE9CeW9ZUU1QaFRtTjljSmt1dk9qS2lwcExp?=
 =?utf-8?B?OWdVYzJXYlFiayt5U0dxNG1MYmhMUXkrNityU3Qwd2Yyb2hBa1FEendzeUVU?=
 =?utf-8?B?MS96MDZKM1VnZlRuejdNaDl2Tm92Umg0QXBUZzJsa3k1WFY1M2w3N3c4aHJa?=
 =?utf-8?B?ZmZ1YTM3b0c1cGE0bTNNR0x2K1NzbnN0TUNncjhUTWI1RU5lSEMrU1BlUFQ4?=
 =?utf-8?B?ZlV4SlZSSmtSN3F0ays0ZzZFTFNMR3R0a25rcUJMQ2duWkkwcjRaeDNqUXZh?=
 =?utf-8?B?bzZNZEZVNG5iKzVhNG1IRWRkQ2VpNWIweGR3WSttV1VZYmY2cTBWanMrTURU?=
 =?utf-8?Q?9vf0KOcMS2kgHZcWC3/6c2TcfTSw713SaKgHV?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dccba8f-5eb1-4bf1-0194-08df457a3513
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:45:28.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXOJ9iIz02fUG7wwP1MHrxEGoB6+9L26rAI8KT55hRQnE3JNZR/HKo8OboQYRomq3gOjkkWHRrSMAG0uwQPP6j5HJM5EKYTtn3QE3mgDT38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB619307

On 18/11/26 12:26, Juri Lelli wrote:
> Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks! The next version adds one test here. The Sashiko review of v7
noted that cpu_active() is cleared before rq->online on the way down.
So the patch now refuses a write if either is off:

        if (!rq->online || !cpu_active(cpu_of(rq)))
                return -EBUSY;

I kept your tag, with a note below the --- that it was on the v7 code.
Tell me if you would rather I drop it.

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
