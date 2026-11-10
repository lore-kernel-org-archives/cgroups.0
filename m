Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.116
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318489;
	b=QpZdFWL8njybOxdFoycIHc6s0hVJtorIlJm8zHPjFpkO9/CE/N3pC8Wr2HdvzVq/py6V
	 7GPzlgflJ6kn2Z0JRcqOV8WcNu0MdY7ikK0kxYMVZrnKo5hCcruGt6oeLbwhpETYRsO7E
	 I96FcHjnpmThIbZxj4F5Qipvyg34ZwiGBDaknmk08GPvxZy14j3BK7UYM1XcyWXyoERsC
	 Iud2IeJGqp6WL5qMet/Oe/wsVLyDckSvW9neyF1e7yO2litKE1fTiywBqR6dbqAPRraQr
	 wFdO6xK3HUHu2fCTHhU2AFr+6/H4X9AT45Zkigc7q2mgXZk2ixq1qfKCu7SdWY7f4qw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318489;
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
	bh=wyq2U/UrwFQI1L7FHY8jjiO8uHIX4sHCdkEdZ+mQpgg=;
	b=CkTtObH0XYm/YTIDoI1vgAhicQ+a+Ds4HXD7HAoIYF8llMo1QPlxOZDUHH0ir3EPL5ys
	 Zkjl2uAB5LuM+OazgNavp/Y8KNn1DE3BnO+qJO/cYTdZ/5f++Ewvffq2GfdkDwCbpSAnH
	 W4cvJjzAlNuCt414rxAuIx14Bp4ByoDUDAcuemAx/nOkrOFWSErC3+OYO0E8Z+pUZMKHh
	 UvLwnbbD0DQpEM0SmcLJkiDAUy/sjJ0w8RearNFdGY+VaQhN7ybKvrIc5Wik8WwJ0Nnlf
	 ylUyRq2RPYSajC8o0nAWO5UGXrkzarPJw++iTU5/Lm0/mUU9ili14vjmr8qECbMwFuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Y4qkar2o;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.116
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022116.outbound.protection.outlook.com [40.107.193.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DFD606A33D;
	Tue, 10 Nov 2026 13:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12DFD606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Y4qkar2o
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVFVKYQWaxox+UDJizXhcVv2HflTsGa9wkrWozzv0bKmLWplCUifpeLxI+/jO3157V89esvj/19Jv49TqdibUxC+vNVq/CJtVL5mMIOQhos0Je2d3x1Y4xTJ7k4Lfhc2qn0FJUNVwH2WHbxV5+Gixyn/BCeMaFH+4APN1PeDJeNuDax8Ot9z6pc6Izra//NSWVwajSwWqwsZS5DF6HkSw198srM3pSF5N3L7tb0I/Fcb5j866u24JiOp/v+BoHSFDuEWQ+I5RDmKOPOJJxpapRJleAQhAgkXAvju0vYkFbtkkM3P/DdqW6TxA7sGYJfyDQIED9xBL/sGGjhX0/2n2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyq2U/UrwFQI1L7FHY8jjiO8uHIX4sHCdkEdZ+mQpgg=;
 b=UC6qwM83U01oYlwkC6lxOIgXjmDuiyzFMezDaV0QTElicRm0IdI6mWz8sJ0C8i+9CLd40vPxH/fTyx4ACrc1NFSbEZiL0GTX0x8Gbj733V2jJF+QRfdMwRwGpxk9ZwXHPpt6akZJemzJNeewyme/mGpDqJw1VgxBACctFe6pzntBvL21KZTlFPVfqEFmL11jC/8r3mUouHSFz2X8Cl1BP2FLQhpzmCIyX/WGTMTnneHo95vuFkWSJ/k6qH0z4tAo9ivY0yWkWOPWUJNUvyqYnei7No8WK43le6hp6kQQxPE6B+BpWACn6fBR7II5HxIV5G+6BdAjUdIP9CG6fUw59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyq2U/UrwFQI1L7FHY8jjiO8uHIX4sHCdkEdZ+mQpgg=;
 b=Y4qkar2ow+yOvY1cvBz63u+EsaSlZfOP8d844ffu/ZNxDd/Q2KoklcbrUf8t5OaB4/tido7ezpWveAsb6wsLmLycOxFY9dWn7LeeLsolLXJhqi9whsFaBDsmyBJvV6rH4OksvnW58+B3zSj5lZD5hsU6qynWK4ffoc1yeYoCM93kSMxGJcSs/wh70dQEPKGdgstzlR1cHA5LA/aDALspDdhB43JSccVL4s6qLcpJ+sikF7qm7aXQt8IhrDkAJaFGL8YUzgxtpcW7mGAUzTzHS9yp0RGCeAnKZohhAMYkugBVjW1iFl1SyPC6FhIHoNrEP2/Ic9dS+T+P4ptpbvhUtw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB273524.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:19b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:48:05 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 13:48:05 +0000
Message-ID: <f3fafadf-0829-455d-ad85-ca6c46404f35@efficios.com>
Date: Tue, 10 Nov 2026 08:48:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/29] sched/deadline: Take a deadline boost from the
 waiter's rt_mutex node
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
 <20261108185406.1549770-9-mathieu.desnoyers@efficios.com>
 <avL8oOtjKqVNR7-l@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avL8oOtjKqVNR7-l@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0071.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::11) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB273524:EE_
X-MS-Office365-Filtering-Correlation-Id: 1045758e-d11d-44dc-6b54-08df3f313f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|4143699003|56012099006|5023799004|22082099003|18002099003|6133799003|10067099003|261102123227099003|261026121527099003|261026140227099003|261021135927099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261028144727099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	hqcE0QZ6yt8bLOc8121qnG1kz4DZM6luy9mnBruWyvMQZ48GSrhE8JP6z7ifTyfxnDC5Jt3D/ERl+qaNKOgFveO0E50aVmjeCLP1ZX2y/YzRyQFVZyGHUrFMd8V1BAwmHIJMndSLrPB9J/NQoov778q+saqXIrXpzkiafH6yRaKb/I4AspXaYmr4hEOEgrb6Ajy46j738BCv9PYR4Yha4gLwh5DICO5dLt4vGVCpBkAOC4fdlps5juGCIzDbXV6yAxYM7BckTRoO69tqGvjBUzbUxxwJFImAY1U8oAe8fiM26ROCZ6czDbtY1wNQ3WSG1C9D4qaGghju+VfOk3L067wW3nVKv/ThzZ96on6WKc82WWzgeGOODnrDHqUNVZ4myphwYv8yMjd5o09IS35uFWYRd+pIynSXpvrJ+0cFKARG8/mLixzrdN6BKntO4YvnnNvOwOJa3jKWRfAb0xgy4wxb47ec6iBJ7GoFkU1a75HI34zKe4uNcdJl2IIZSUAYq9Q4ew1feVV3uqUFjlF2dSlTAfKv7GjRzaezqRa2jOoTGoTCB5iPZRLBICjJ0oRNh3zldJqEhN/8Sy/UKf5Qau8CTr5OjrZw3xUJyVUiabU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003)(6133799003)(10067099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021135927099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261028144727099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmUyMDh6a1duWk94R3hBWG5SRjVQWHBGcm11YXFoK1dpV256SFJ1cXNXbXBw?=
 =?utf-8?B?Um11NUkyUDF2a0VQUjZVWW54akVCK3JvME5Ta2RRQlNBVDI3VEJjWG13S0ZR?=
 =?utf-8?B?eU0xcDFWNkRhMXU4bDFXSzQ0bkFWWTVsT3NWNytwOW13WkNVYmErZnJaTEx1?=
 =?utf-8?B?bjhPS1NCY0pVNEYzZlVqKzl1SHlEQVdmR2FYOUNPMitCSHBSbXM3eHMxajJk?=
 =?utf-8?B?SDlLK01qUUVHUmhhZGRhTkZsRWtQNzM0eWlsckFvZ00vR3padDhvYlJuVjJY?=
 =?utf-8?B?Y0Iydk1Ta0JldzNWMUdEbm4vM1RGU29wTWNzRWtoV08xZ3dKZXJodGNPWDlG?=
 =?utf-8?B?UFZxY2VwL040c1NCZkZUM0FOaHZjb01SMTV0NVZwMC8xZlp1OXdObmxBb0V5?=
 =?utf-8?B?SVVJVFY2K0tuWWZOVlFYNzlWTWV0aFBURStwVDhUWktVZU5nb21xcmxDUlU0?=
 =?utf-8?B?YmpCN0d0c0IxNXoyd2lHMVVyUFhWVlJ2VW53R0NtaGVNT0JneGRmR0krOGxq?=
 =?utf-8?B?Wld1VnNOenBMTURsQzg0L1hWem1oZ01zWFEyN0tSRmNpY0dtMXpNMnhzMUFq?=
 =?utf-8?B?MXpkSjNYY3BUYVFGVE9FNlZRSk1FRzl3WVNMMG1qUDZkcTFBbGhCTDV3dkF0?=
 =?utf-8?B?elUvR3dHN2ltUVV4V2t3c2UwSWxacHZ5QWI4cDRaeXNSSngwb3RuVVJYUXFz?=
 =?utf-8?B?MngwYzVuNGNYNkxpUmhROGMwN3owbGJ2Ykk4YjNka2NUV0JyYjJJN1llbXVY?=
 =?utf-8?B?NHBMbUZROHNPZmRkd290bUtFR2hEMEdpSk5EMDB4a01IcmpSVHFhUDRWRzNC?=
 =?utf-8?B?UGlzSzRaV3pBR2J6NC9GVWtZbzNjUEo1YXI4R243ZnVKZEVKZXEySEhhdzMv?=
 =?utf-8?B?Ly91eUd0ejF1eTRLdjMrNW0wQWRIZWtjalJtNGpnakxmL2ZZS0kvQmk3Q2Rz?=
 =?utf-8?B?UVI1N2lETXJFeVYweW5heFFpMDFlUzdweHV1MFRLRGdVS2lUeEd2eXJkc0lB?=
 =?utf-8?B?c2VXYkwzejRkRXhxYy95NW5QYVZncHE1S0lXdVJvSjh0M25YTUtIYXh4cmQ5?=
 =?utf-8?B?c3RrMzJOS2lTVk1UWFZ1VGRXZitLNTYweS9xUTcwRFdPWkphTS80RFRSV1dV?=
 =?utf-8?B?L2RmbjhNV1U3MHlkcENxNHhHR2tDY1NEaTBtbnd5aFFUQXkzeHRudEoweFE1?=
 =?utf-8?B?WTV1eUhyOUZNK3ZPamgrblRWTGo2eVBMNDg0bkl1bkFEalFTaXdzL3VESFFJ?=
 =?utf-8?B?WWZtcXlxMlFpQUM4dUsyUG1aUVQ2M0hhSFEveEtXNXc0b1dSbXZMV3lzZXVl?=
 =?utf-8?B?dkN3WHBZVk9SazR1ZGVsVXFVTnhPVkcwaVdaUWJ0b0pwM1N6SnBBYlBoN1FO?=
 =?utf-8?B?d2V4VndSZkNHYXRYWWc3UnZWQ1V2cnQ5NnptdVhMVHBpTjRvTVpnM0Jycldv?=
 =?utf-8?B?NFluWjJ0aGJHYVVlM284YUJPYXdkZm13WERPa1ppZ3RmaVFMcHBYTFNMNTgr?=
 =?utf-8?B?VTdpcEJ3am1oK2s4bDIzTGtyTDYxbDdmYVQzdHJzUGVqeHlIdG80My85aEJs?=
 =?utf-8?B?ZEJjSU9zcm5XRU9XU3Y3Y1dvRzVvZWd6Yi9nbUMxMDU2NVdnaWpTMzc4K0pO?=
 =?utf-8?B?QTBLR3JqNUxDRWhoaGw3a1FnMTlTN3Z0MVFaUWp6SFUxb0xwVVFBNk5EeTNH?=
 =?utf-8?B?djBRaWsyOEV4bkxZd0ZUYmN0ekIyRkJXNWVlZFRSWlBTTVBodHdEaUtBUU1q?=
 =?utf-8?B?MEJlZkF0ZXh6ZDkwKzc4R3pqQzgxWGcvSC9nUSt5SG1NUklEa1JkQU9Db0ht?=
 =?utf-8?B?d1VxN0ZlRDhDMGxIaTdEQ2k1Q2tVRWJNcEJsUG5UZDJlNHV6SXZoRmF0dUd4?=
 =?utf-8?B?YndpKzJUL2lTNDZOU1djYzNmMWdMaStRTERPUkR4enRwZGt3dVo5NE5NSmtG?=
 =?utf-8?B?SnpYbnNxN3A0SnZsYTFHZmw0R2k1MHp3MEVaTUNlNmJBek45K3FpRzBXTmxB?=
 =?utf-8?B?RkdFVE5mVHFEVFR3dlJtaEpjRUx0WVBvQS9PUWo0UjI3Q09DT3VqaXJQa0JO?=
 =?utf-8?B?elVPRUYwMUp0dlVqSWdNNlg1RkpmV0RZbFlFK2FyWjNWV2g1a1dRZTcrUWZW?=
 =?utf-8?B?NDNaYjdoTDFDVnBRSi8rMllyMUQ1bWYxQlVEMFFSOWVsOHdHWjREYnB2UWlD?=
 =?utf-8?B?Vk5OaWFTMjRtWFdYamhiOUU0WmFKY0dSWWRHbjRQYUVIZHFJRGtyOExEYWUx?=
 =?utf-8?B?ZEVsT1o3RS9UQkRSYkY0czMyOTdvQzVSQW1nWFdTMmRVY0tTVTBLOWV1cTdS?=
 =?utf-8?B?L0V0NDNERjl0Q0JXTXZZL2xmZUt1UmxHWEtWbUVKaFJXdHU2ZXhrT3U5dFpy?=
 =?utf-8?Q?rQgohEI7+tmmA9qEyqfImerj/Ec8boau/Az0j?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1045758e-d11d-44dc-6b54-08df3f313f3e
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:48:05.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB7Cn9l0jhjyOajv9K7zloYJgYzC0S3z2fg/ScWmAroaro5DbWW7oe/xEXWH9rttuJRr4Wnqwlh21C7okaIx+yjSUScD5Ub1R79WJURulNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB273524

On 2026-11-10 06:14, Juri Lelli wrote:
[...]
> I am not completely sure that we want the additinal machinery below
> though, if we can find a simpler stop-gap solution until proxy execution
> makes things right.

Agreed. The deadline boost was meant as a temporary scheme. My patch
makes its copy of the donor's parameters correct, at a cost for stable.
A small fix that stops the lockup is the right size there.

> I was thinking 2 alternative potential bandaids:
>
>  1. Don't clear the parameters of a blocked waiter. Every live donor is,
>  by construction, a task blocked on an rt_mutex. Guard the
>  __dl_clear_params() calls in task_non_contending() and
>  inactive_task_timer() with p->pi_blocked_on (both sites hold pi_lock,
>  which is also what pi_blocked_on is written under). The bandwidth
>  release still happens at the 0-lag time; only the parameter wipe waits
>  until the task is no longer blocked.

I see two problems with this one.

First, __dl_clear_params() also clears dl_non_contending. In the timer
case, switched_from_dl() removed the running_bw of the sleeping task,
but left the flag set. If we skip the whole clear and the task comes
back to SCHED_DEADLINE, task_contending() sees the flag and does not add
its running_bw. running_bw would then underflow later. So only the
static parameters can wait.

Second, the wipe must still happen later. A task outside the class with
its old parameters would start its next boost from its old deadline. Its
deboost would then subtract bandwidth that was already given back, in
task_non_contending(). The natural place is where pi_blocked_on goes
back to NULL. But remove_waiter() clears it before it deboosts the
owner. So the wipe has to come after rt_mutex_adjust_prio() of the
owner, or the hang comes back. That puts deadline code and a pending
flag in the rtmutex slow path.

>  2. Even simpler, considering that the above is of course still far from
>  ideal: replenish_dl_entity() already WARNs on pi_of(dl_se)->dl_runtime
>  <= 0, and then hangs. Make the condition bail instead.

I prefer this one. It stays in deadline.c. It covers every way the
inherited parameters can reach 0.

> The deboost is
>  already in flight: the sched_setscheduler() that clears the donor's
>  parameters ends with rt_mutex_adjust_pi(), which walks the chain and
>  deboosts the owner through rt_mutex_setprio() and needs the owner's rq
>  lock to do so, which is exactly what the infinite loop holds. Bailing
>  releases it; the owner then sits throttled until the walk lands
>  (dl_task_timer() is a no-op for boosted entities) and moves it back to
>  fair. The stall is bounded by the walk's latency.

There is one path with no walk. normalize_rt_tasks() (sysrq-n) calls
__sched_setscheduler() with pi set to false. So nothing calls
rt_mutex_adjust_pi() for the donor. A throttled owner would then wait
for good, with the lock held.

As I read the code, the owner does not stay throttled, though.
update_curr_dl_se() enqueues a boosted entity again at once, with
ENQUEUE_REPLENISH. enqueue_task_dl() clears the throttle of a boosted
entity. So after the bail, the owner would stay queued on its old
deadline. It can then release the lock, which deboosts it. The fix
should keep that.

Also, a CAP_SYS_NICE user can trigger the WARN this way. With
panic_on_warn that takes the machine down. I would bail without a
warning when the entity is boosted, and keep the WARN for an entity that
is not.

v6 will replace this patch with that fix. I will test it with:
- the stress test that switches the donor in and out of the class;
- the delay before rt_mutex_adjust_pi() that locks up v7.4-rc1;
- the sysrq-n case of deadline_switch_test.

The deadline series then no longer needs "locking/rtmutex: Clone the
sort keys in rt_mutex_enqueue_pi()". That patch stays a fix of its own.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
