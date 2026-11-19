Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.138
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795095708;
	b=n2pCIIu0a7UT8HTcKuI/PI1iydQsltjhOmYskKBgB7i3jDS5kdz6+mUlzEnZ2ngJsRon
	 Za/KQUyxqVKUuSQs1f+7ONLlMixEHrwdhYkXMueoo5/99gv/jDW/D/VFxhnD3nR0fKd78
	 OSGRkiKU8jaxeZNBgKBw0hsaj4a3Tkgl7E/rzaw4R80SX461vQAQdhG9uztUDlLQXRRWK
	 ZfLbJHM1bMLOmrZ/EHzGcfk+tTCCu4t9Ic+8wGFXkaKslpG0ahcNexmOieL6/5QWzOoT/
	 Tihv9Zyp1V7oF6KbwkuzYTibddVXQ1brq53neZf2qLCxS+4qgWOVlO24fm1I6syL9aQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795095708;
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
	bh=6AE4M6moirRgB77ql4ZD+cuRU7DQwngSG/SBbk97Nf4=;
	b=SMyErisBd6EvxbwvM5fEydUJ2vPbvqITKgpM4E5h05J4nCXLx93IYT4VAe8IgoEcym7I
	 uhqa/CPxlhv3ssMuQvxTEb9ITNyA7wDk5cirrtX+3TjrTJeafFK74LEn7zRWYMqs+WpUU
	 2SP92ZLaq9MuRdzU1ITmIpkXtf2u6lJIl7DMf9iR6dPf9qcijXDi4cCAyq1Bb72XRmHTx
	 esdkFQI9r4YYHvg27q9bR72CeTyea3ddQ57T65v9u3oOjqTx4ZaPC8jHf5tTPUL0OM1gJ
	 A8Ua43UoUyG4kTELLijZxEi5dWjZMQd0am4DNeDEA6s5+jUs6m6uldRZRNDvKrQMNxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=HnubEp8r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.138
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022138.outbound.protection.outlook.com [40.107.193.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234C1606A324;
	Thu, 19 Nov 2026 13:41:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 234C1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=HnubEp8r
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtWapx5+J6W44SxNoJASiEXJnYZIkV7VYkkFU6OdfWt1bWm1np28m41nhPDgULuQKpU6Ngti+QaR4pq/55pJnsczb0VK4kAZ6Pyf0Cg23ulHLvuODJ8APmLpmz1OyYQLiaYb/yPNUMupfYGK/lhGHmnGdz8aDy8r7FpjP3+nz6Y/BiCzwFvjWKN+k2rqCzUJzEtDCqQ5TNP5V71KFYQWPktI0+6X6VzHj142znItD5K2fzp7/L6naJlbicgfpFz+OZHgVhOK4a/BUNyP1dWlUJrFVRaMoAdIzFPAARihT+KDBlHQbGUNL1dsz1qAsKZRj++4byVFuVH166V3FgeqBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AE4M6moirRgB77ql4ZD+cuRU7DQwngSG/SBbk97Nf4=;
 b=TGDiDi23fg0N7a4ZNZoOqMnwN5qII1XEolCH5agL/rXxOBs1dKDusjFmivrK0MZ9loHEGH4cGF9QN+FHXL8iC9ljhzSBgaG4zeD1MUPBYAPi7jLJwuO+MzaOBjW52G7RJkt+djDq+y9LrbtwHvhkybAD6VGxUrsYJ0xWJeQ5nmpQoQaGoK6jO63Cg3GpklDXkRCxoMrf+7UBc70W0nH/F7F/wFW6oPzBr0WYhuk/rWknGqTz8IOwfX7rFSVjHdaylpJhZOj9THzOc/eUNeS2f7vYoRg8s244XaU1c2f1UqDOcfTBihs4tE/lFlL/PdXM+a1BxKOXy7t2fsFT1oAByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AE4M6moirRgB77ql4ZD+cuRU7DQwngSG/SBbk97Nf4=;
 b=HnubEp8re9iY30Tx3mKDnHADip0iTL9WPrkygl9mMY9BGI97D5a1vyMfq1n0llkU8iAtq0ZKGZKAoAil/BCH1KkaqsupVIQaWr4JqA+D+4AR0r7z1J92yVGsNpqX/wW+WzHKK+vylyiMt9KedWysOtPmiyOk5vKH42VL0QPboBqfn+3I/oa/1OPahULGC1JarPTW9G+wW+T40nqedajJZFszyRTqur28nN7zbDrcpOpm+1DaCACAZ6HoWUs3xt7dL6yvITNZMSAymHERRx6ENZF8yT93zDvpZsk/X7rsdqgG583TtFPQtTH4zyms1eo+ZcgAWoLa6W+GLX8AVrMDdw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT3PR01MB5329.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:61::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 13:41:46 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0639.011; Thu, 19 Nov 2026
 13:41:46 +0000
Message-ID: <f71f21c6-55bd-4d4d-b9ce-6bdf1aeb6d32@efficios.com>
Date: Thu, 19 Nov 2026 08:41:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] sched/deadline: first bandwidth accounting fixes
 and selftests
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
 linux-rt-devel@lists.linux.dev
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
 <av7NchMg0wnyzjcd@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <av7NchMg0wnyzjcd@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::34) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT3PR01MB5329:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0be0c9-1853-415c-225e-08df4642dabd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|56012099006|4143699003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VIb0eKX7+57MypJ07joUCYovyBQrkXSP/GdwXhsKBne9cXSAUAc1oAAlgW2twI9NCL7523b4uDaBmFNf1QbcTorVT5vmot9/o8hY5D8J7uFVNW6+09poenl7e5hj8XefnCDfGiLKtRE8Q+WHFyuAJB7vIsOmKmxzUGXj75zhKPXGuPoLFQhwupYjdjpQDzB7oL4Zg3mjy2yqx3P2Yo+CPF5FDJP2w4UZpNbkZGzD3d99ny0pcoiTxp8ptjmlqsQnbVRmC+3Lf1WkRhIz69/hjVEGFkMzaM4ntV2UzlBg6co4c3Ew9wA46GgO737mNN5I4CulSqjL+e35h7lzOz1jgVW5yyL81Hm696HtIXx3y3m1QfJs/Y4t8TplmA9AWt2i50xWBpamSif4yVxDoUY/LVm/CtXyV4AZmbucVe6Yzc5pEhSWhk6QnURs56JbqRcXNXI+trim9PbdMLXE42dVEhmrUw4yLei9wbJJkNw0bTT9vVSbVK8Y5CIPOZZIXmY1VEdxEoCUgYNr/Tc53S6itPZnh7JBS8bl3rTo2aA1IBSQVz8wQrghUJrX4RQl0Jwfwu3feE5ElmLOXC0Mh4nLkP5E8VAvNS6H1aoM+vjotU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWNCQzlPMy9DMUlvL2F4WE9STUVMWE91UExMTFBqbjFBc29zNkp4WGRTQWMv?=
 =?utf-8?B?VjJHN3Zuc1hka1B5NWNIaXk1ekQwMTNNcXRuRjY3Z1JrZmZjb3V1K2tPazJN?=
 =?utf-8?B?dndsWkxkMy9CNktpSkhjd0tBc2wxcE43YWw4aG92UVhabWlOYVp4aG1IZ2tL?=
 =?utf-8?B?Y0NsQmlaN2o5b2VXcmY1OEY3dlZZaEhYV05LS2h0cm4rVVFObFFKeFM2MDRK?=
 =?utf-8?B?K3RxMU1jRmZCMG1vajBqQjIrRmw1TThwa0NBSDdiZSt6T1RJOGtQeXU1TFQ4?=
 =?utf-8?B?Z1hFUk5uY04wVmYzRGhzK0pCblNBZ0JMb3J6NmdJWjZyNUkrUkZZNGpIaGZB?=
 =?utf-8?B?YjJjYnE0ME9vNng3UmMveXBZbVg2d3ZrSW5KWkNHc0Z2elArRzRuS1p4SjFj?=
 =?utf-8?B?WWpiWU1lQndBeFdadFJQLzJVQUhLMnJpT3U3ZU5oN2ZkWUJ0d2NlLzV5WFho?=
 =?utf-8?B?Ry9DMUJCTmFoaUhrTHBBY2lkdlphTGFZbkJVTDNBQVZLa3BNeHc3REp6Rm1L?=
 =?utf-8?B?YlJuMGwybEROaW9SallMb216NTMwek5HdWl4OFVxbEw4RVFwdmdhZnNrUk9Z?=
 =?utf-8?B?dkpjdnZmTFBONmo0L3JmaFdPdGlKYnBLRVRUZEg1WFZBTURvb2dZdlFhdVFM?=
 =?utf-8?B?ekRqK2NvYVlHNFQ1eGV0aElmQi85c2d0MU44aEpHOGUrZnNNdHRDTnViYitF?=
 =?utf-8?B?SjZmbnIwTm1lMm5FZWtxYWZJa2N5c0cxVXpUeTZLMzhyRkgxRnJ4bGlsLy9I?=
 =?utf-8?B?T2dNK2YzcFFPTFpJeURSR21LbnVyTTdFL25WZWJLMjQzK1BPamw1WXhKa0cv?=
 =?utf-8?B?LytQNlRlRkRvTHdraVJ5RU9pekJ3RmdjS0piS0xEeUhWN0w0MnVka2QrNzNi?=
 =?utf-8?B?c3BaRlY5MW1haVYzTFJjVk9DV0JvWnljcU9mcDhucERqOCt3VTJzWXA1S1k1?=
 =?utf-8?B?MkpTTDg4bzMveXB0cVJDVG9zWjk2eEk5b29IS2RjN0tlSmU1ZW1QL1FKWTVZ?=
 =?utf-8?B?S2Zaa2wzQlB0MTZKcGMya2xQbElaa3FYRDhjOUFvc2RqYmY1N0FYeGRDTXRn?=
 =?utf-8?B?aldsNXZxWXhlWEdBQ3FoMUFOYXY2SGMvQnhQZWhHQTExa2x1U05HNDdTRVRV?=
 =?utf-8?B?dnlXTXU0ZWtZM0JPOWV5RUhSazlvRU5oc0d6alRGNk9rSi9YVHAwK1lDNVBq?=
 =?utf-8?B?ZzZFZjVTRlNnaHgrRjNBTkg0TkdRbGt6TXB6MHBMOTRVbmx4V3l6T2doZDhC?=
 =?utf-8?B?QkYvZ2xNd2Z6K2F3WTdmSXNsWi9ibFJ0Q1UxZXVzK2JyNHAyZHZHcjVsMVNm?=
 =?utf-8?B?YXNkUHo0OWthVFFFd1VqMkxHSjRzdlF2eU1wU1Z3WVdXc1VPUkJLMXFlRlNH?=
 =?utf-8?B?cUdBYkxqdXZWSmx3Ri9Xa1FITXFTeTF2R1pMaEJtbGNuZ0lnNHF2VmsvZFBs?=
 =?utf-8?B?c0ZTUWFxOUxFTUZHNDEzTDFXcUZkNnpDRUJVT3RSOUkzNUpsUDJlRy9XUGpo?=
 =?utf-8?B?Z1VMRGUzTUZaamxablZVcjFHSzA3SU1JWlhoZ2pHMTQ3bnNvdlAzejNFYWlx?=
 =?utf-8?B?OHNEUWRTYkM0TlRhdlg5UVNxY1lEZjByMHA0YUE1bVBTZWE1dmdhTzZMVFBR?=
 =?utf-8?B?N1FmU0xJU1hMY0RyaHBaU1NVbGNOY1Z3VVhZQ1lERGE3K0syaFlZcWNCdkQ1?=
 =?utf-8?B?TkJ6RjIzRmk1SXZhc2xHYmFZVklxNVJOMUlLNUVpOEZEWWtsWUZyK1dGZkwx?=
 =?utf-8?B?Unk3bE1PYTBaaWYrMk1qb2hYdHNiSnBGYWlKWlRmcG1USFgrQ1FKd1hReFB2?=
 =?utf-8?B?VEhQQkVQekdiRS9sTmJIdDh4RmVFVVV0Ryt5dFBGdUpxMHJJQmpxN2ZpYnN1?=
 =?utf-8?B?czJYZnhUUzFLdnk5d1hNRS9sV1NkWEpaNkVpL3UzUXhFWm1pc1R2bEpNaE95?=
 =?utf-8?B?amtBclEycWpmNDk1a05kRzlXSUh3MUlnN2NNNHF1MFM1b2J0YzBsNlZBdmlt?=
 =?utf-8?B?c2xCQStpa3Y3Y2VZcmJEc3VXTWdhTHBiL3JYNExta3RsVG5MK3VTcytnL29a?=
 =?utf-8?B?Z0ZCY3FFNlJCS2xuUlFWRWpVOFlEV2xrcTV3Uzc0MEtjemZkREZaOHF5Ty8w?=
 =?utf-8?B?QnZVYkgzeFJvbmFGMW1xNWpYbWNiYm5EWGNZWVVFUmxMeVhRb1NvUEhFdWla?=
 =?utf-8?B?YTVBREF1SFhFa3BoeUNTd3ZBbkdMcDlPVmJiMGVrR3Jqdjc3aWl1azBKL1Rv?=
 =?utf-8?B?Z2ZMbjdyelFEU21iMGlZYmJCNW9pTjdEdzY2bE52VTRjTjFjUENmdUlEd0Nu?=
 =?utf-8?B?TnV4ZHpvQ1RRbkhJNHN1MzdEbHdvOXB1V1pSa1FnOWkyUU1mRW9LRXZyY1Vm?=
 =?utf-8?Q?z5NtHMmYDLboj4qPjkszGxCOQZtgQOOtfJsF6?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0be0c9-1853-415c-225e-08df4642dabd
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 13:41:46.2288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G417AvdXrPPszD+fCnwiYHmrQDJFdu42J22SKEwzXo4bpmiSBkKc7p7s5HammPD9IyiO70JNUJtSPFJOabBdavjeXMJJ0DIP3wURvGdvz3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5329

Hi Juri,

On 2026-11-19 05:20, Juri Lelli wrote:
> Thanks for splitting this out. I ran v2 in 8-CPU guests with lockdep and
> proxy exec on.
[...]
> I also covered two of the "not tested" items:

Thanks for these runs. In v3, I will drop cgroup v1 and sched_ext from
"Not tested", and say that you tested them.

> - cgroup v1 cpusets (two exclusive cpusets, root load balancing off):
>   admission, affinity, refused moves and hotplug all behave as on v2.
>   On both v1 and v2, moving a task A -> B -> A leaves its bandwidth
>   in B, so A is under-counted once the task dies. The leak is on rc2
>   too and the full v7 fixes it, so it is not a regression.

OK. The second series keeps that fix.

> Pointed at ext_server, server_params,
>   server_rebuilds, server_states and server_reclaim pass. hotplug_server
>   still fails there, as scx_simple gets ejected when the CPU goes
>   offline (I haven't dug further). Could the test pick the server that
>   is active?

Yes. The server cases will use ext_server while a sched_ext scheduler
is loaded. hotplug_server will skip then.

> Please move this into the changelog of patch 10 itself, as the cover
> won't end up in git. IIUC, the owner then sits in the patch 8 bail-out
> with a deadline of "now" until it unlocks. Other deadline tasks keep
> their bandwidth, but lose latency, and RT/fair tasks on that CPU get
> possibly starved.

Yes, that is what the test sees: each refill gives the owner no runtime
and a deadline of about now. I will move the paragraph into patch 10,
with your impact.

> Doesn't your separate "Fix an overflow of the 0-lag time with long
> periods" also fits here, right before patch 10, which adds a caller of
> that computation?

Yes. I will move it before patch 10 in v3.

> Patch 5: yes, keep my Reviewed-by on the version with the cpu_active()
> check.

Thanks.

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
