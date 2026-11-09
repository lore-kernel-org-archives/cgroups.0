Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.136
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794236260;
	b=cAETi+kwPxSTYAY/wEepg8Do0ZW2MzjwVnqGvGLlxnOmLVhY2xv4VPN1cF9h/dVeD2rr
	 N0pbxewB/nSK22fYx+gP5lWNfsgLw+m4YXFh7qHTKg2wokVXD3lkBUAZQpvV321q0nwmN
	 Vh0P2aWLUeVAHCBkbKdM7Bd/y1Dzd9Ptmk1DqoX5CMG4hJkzFRH4cuaTi/3ZsF3MyvixY
	 6UxCBM6QITjQWMGjhGGSZXydZaQ+fUZFQQlI87p/wZG2FDYzzxzHSJocAB8LPI7LHvKEv
	 YDn/uQRrYKX2IeQakdIBK91UZ6TsNBqmM0IVAO8NAUYnSXpuULVg8J6G0/PDqjyzlQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236260;
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
	bh=OyyFReT5N8UocIVCCCGsAeyZZyWd4EPzbzk5M2E6UGI=;
	b=Pl1RYAgmxBMnG6gbTcELtpLuiWHEAgaeDwjBZbylSj9uFTb52cxKcL0EKEVBHFAmKQ3L
	 5gzc0K99glPYRzYhAMnza3hdmZN3rRWtcGD/s87ypsFtPnb0uffgLGcGAkmpE8eorCJEJ
	 S63lKnFvthovMFlU5BYQ3bBJi/mQRjueuLaRSGctBCfcX6ngPNiWRMORO53YfFHabGN22
	 4URcWgsVwNKlGOKqD7iAyDIr1ffTX9kBkIg7A2t947DsJRqcE1NHITw/d2357hJeIr1y1
	 kbMVQBFxvRaeEGbgGoJFZ6EJevHnRhP4BQ/Po9mwM20yx+5p39FqLgmJCQ1ybJzAUNw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=QgjOiPTE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.136
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020136.outbound.protection.outlook.com [52.101.189.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5489D606A31C;
	Mon,  9 Nov 2026 14:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5489D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=QgjOiPTE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWkokMvSetqMd3IY52Z8ClYvIOcxVhUJDAptvizwMR0T5iBEjibA2DDSz0W81pI8XQtaK3P9ZKMhmqJTeBXgPwhPM0wuxyTpsJF+PtfJhcB8NVuMqtTCLapBYJAztc/cdqIzCEZ2tyxNhWMskGLNt0sc2Ad0I8g5wy+cvbWePzsrXSiz7GuLq7d196oR4vABAGBsfbd6Oz9jYi6d7Tb5KHOKrIUMMNilLTl0YslEdyL3FYp3Y63tLMgSk8O4S5OsTcAFFD5aaDekkGrkdTPyVEnEzLoCRaRMiW+f2N9Jp+SvLKgXh3gtx24zpcc+KI4Sd3snA22sOEfvUk1LdagAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyyFReT5N8UocIVCCCGsAeyZZyWd4EPzbzk5M2E6UGI=;
 b=ReUfVo9uqBfP/eT+YzeGMsYEP0P/9ZpTT/1MR7MITacqfQHl74wgyDTucSn9MwnD1eBKVUrOPfrWstIteWKNx95AdEyzfK8D6gC0Jp/y8xcOU/R5yDXPWmXvdwkA9pL69fz2yNkwEyooKLTu2vq12T7rzXkozPeuXkmdYTnQMPo3NKnqwa2rHmVFje2Ni+KST4LtYOUSqfro9irU/OFVpEglNtmLoB8tPI7g5+Cu2IboN8BFWmJzcVgL9s/aUabmOAWjP7TFEQIWTZDoeJ7YNicWHpEGXk8B5chcPFzuCluzwLVohys+RDfPxMbSzmsfTJpuYGV5eevBDhC24jSokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyyFReT5N8UocIVCCCGsAeyZZyWd4EPzbzk5M2E6UGI=;
 b=QgjOiPTE4J3JM/CJo7IipdRR4H7+paxdiabI3RAUtJuAYiY5ITixdHcAXACThWOt0m+q6CuKT+BloCtI9QugE89/AuNkoRz7Y5vHqp2pleaLyijkPUSaZxjSXn7MJDF2Nz146fQwGIM9R6CDHTXOCPinnvjBubSTNlQs9j3t15GUbzPPIADMhcAeckoaS+UN2sTTydcfukIKSVUmWZNSTzwlFUNk/JBj9dCNsHK/h9L3vLoCPMDzM4mhj18WAHT16gzVhDpXIpXj65NwjvDicVsESF+LyVnmi+gZoNIpl+kkVmmVl8UWASMTMXwW+93Hhpmk4UBCLZhEZO+qGTegXw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT6PR01MB134462.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1c3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 14:57:35 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 14:57:35 +0000
Message-ID: <3e6677a8-b972-4081-a080-e925fe1df3b0@efficios.com>
Date: Mon, 9 Nov 2026 09:57:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/29] sched/deadline: Do not divide by zero active
 CPUs of a root domain
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
 <20261108185406.1549770-6-mathieu.desnoyers@efficios.com>
 <avHY7oNeuvjsLT4I@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avHY7oNeuvjsLT4I@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0117.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::20) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT6PR01MB134462:EE_
X-MS-Office365-Filtering-Correlation-Id: 002df278-64c0-42e7-09ba-08df3e71ca41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|10067099003|4143699003|261028144727099003|261022105027099003|56012099006|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	g7/aO+9CGi609Hjb6ITcZqCF9rSXAbNwx5bXd21ihSDNuTtvaMcDe4ReyN2FFhGgncN8zQmqcE9Drymm99sgvGa8HL1D7+Bded4pGJxsu3N0NjzeURS62IUoMJoEw+mEW246vURXh+YZJS9zLOde40RNjJS6Tw0R0hGdhR9FaZ+jTWYyUAwnH2YCD6gS9mHghzGaFnmLTdDG6RAATcz0czpdqEZtfVwCxuARvSyjvqu5w5zeg8LcjgZPGcr3gm7Z62EMZOjBIpeDztjCtVmHp550BO9Lci6TPjkizeikNa6KDZiJzY22gH+lJgn4WH5mBO9qOX1KNLmrpqRsBDJkuqfRxRhpZWT3P/zyioYq/D/s9iTncczDKOLZEbM0yaR0imfIvmutjGhCBW8xgqBZVu2Aq/CNok/6H0fOXoWv1xp0kzDqGvXbNJcI31Rd/e/zIunue/g9ibQkJnymEy7MSfHD7Vbc4m4GEWzUo0inNEzegiRFVorOJu2ttSaHxVQxxI0/tae4DFgn+dG0nFAGlsn5FXobs9UXGTTsisxZZIJAofB5+m7LaadqnITuP52c6kF+6eCGBDrV1cM7sInIKpCjlDEQXIMSGObFbViGt7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(261028144727099003)(261022105027099003)(56012099006)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEVibHdLakFGazN0NmYzSHBJMDAzeENNMTNGbnNwcm1nOGg1TU5LeVJNcUdM?=
 =?utf-8?B?UFVVcXFFQW1lZmdtUDVRTmJMSE92bzd5RHE2TmRoVFNMY2xyYkVGRmkvUXZt?=
 =?utf-8?B?VEZESkF4T25qZnhhZFp3c3RrUEVvemlWNElCUnhoZWJsYW9sN0VvdEVIbFcv?=
 =?utf-8?B?T3cvUTJFb3p6TzlxTG9RYysyV1VVM2NvQ01XQWw4WWdtcHUxWWtac0FqZW85?=
 =?utf-8?B?MUFjSGx5Rk5jKzcvV3Y4TFFaOVgrVEtEMlJ6a2FyaC9OQ2Exa1hWaCtEa3Jq?=
 =?utf-8?B?R2VSL2FuT2FrS1RhS3BIUEVwZTM1bjQ4N0c5R3VBRFBCVlJQUEdlb2RqdU40?=
 =?utf-8?B?aEdaNVUxQmV5MW8wZVJaOTFxNUZCeXJvckFzdE1DZVdOWGI0ckx2dnVkdmI5?=
 =?utf-8?B?Ui9qSXdGc0JWeW5VWCtvK2lYUDA0ODJuSE92aDMzTGY0Uk96ZkVYL0ZmRnF1?=
 =?utf-8?B?Mmc5MmpoeGdFTnhSdFBmcWpqTEZCaEV4UDZ0VlV1cXRLbVIrZjJsdVZJSWpY?=
 =?utf-8?B?aG1mTWJ4dk1ieHNTaHF1TUdKdkdYS1NvcVlWSlBHSnpxdnd2cEp5aGZJTmtr?=
 =?utf-8?B?Z0wvTTRLVkhXY2x5Q3RQRWRMc0tnT3VXVzY2TC83OGk0T0x0d1VUb2RVNjVU?=
 =?utf-8?B?L0xTeW01MGRsV1ZpcCtXNTdoc0RIUExNRUMrdTZtRnNpZDFXcXg2RDZUM2dH?=
 =?utf-8?B?dVFMYVhDMEhGSDVsakNkVzVBa09TY0p6YUp5NWlUa2ZsdXJSVE1xMnZEd0pT?=
 =?utf-8?B?ZytjQUJmRVVCWDVsTE0ySTBHVFBFUytobVU0cU81a1JSMTV6WFNtOHNnU2pH?=
 =?utf-8?B?Z2s5VnVqRU5lRXpkK0Vuemh1RG1vWERuTlF4eUFJa3paRm5kT0Y1ZDdlbmN0?=
 =?utf-8?B?Um9udW9JQUp0UFpIbDkxUk1MYS81Q09iSG9kakNyOVVYUnZwaG5LZnpGNUVM?=
 =?utf-8?B?eis5UU9raWpCS09LWFpNeHZGL09QeGprTDY3L2hrNzltQk1scUVHcjNQa0Qr?=
 =?utf-8?B?c1N3bjFSNDk0eC9sOExkeWVxQlBHbXpsUkVnaVFITDcwMUdoWlJkNytJN1NZ?=
 =?utf-8?B?MHpSVkgwU1pjUVBMNmtTa3VJZ093OTRHSnpscXlUaUhIbjNkb3RLalNNU2FN?=
 =?utf-8?B?RnJ5NFB2c1JMSmZhUVRxaE1Bb1lYMUU4MENzNlp0ak1FK1RvUXV2TitHTGFJ?=
 =?utf-8?B?aHZlRVBzMzZOckd3bGdoRDNTWmQ5aEdQVk14VkxqYldERngrNTBnK1E4b0VE?=
 =?utf-8?B?bkM0dGRHNkhRL2tnQXRzcTVYRGJPYWEyNitzZmFCbWovSWV1cjlidmtkb0hU?=
 =?utf-8?B?VDdYTGp5bFpRZnd1Mnhwc0Y0K1JGdWZielQ5T1BuZitvQTVxY2JIMU41eHdv?=
 =?utf-8?B?NzVSZjN2clhqQU9GMU90ZGVpZE85Z3U5SkNoUHgvRVpRMGFpaklkUHIxaWM0?=
 =?utf-8?B?NGF5OWF3ZUhWWGp1UnF4ZnJKQXdVa2NsZzlKbGsxTVUwb2V2bGFZSUpmT1Ez?=
 =?utf-8?B?RUwydnJab2VzcGVycWM0bHpySnNGUzNKRXdxdUdSUmdoOG1veGQ4SGg1OWRx?=
 =?utf-8?B?aHN1bEx0cmFTRVl2ZUVYUStHTFR4NDhyVVRaWi8xUHdrUy91dEFLRVI1N2tB?=
 =?utf-8?B?VlVZeXFOcFZvNmJVWHY5dU15bmsyZ3RTbVBxRFhJNGpmeDRCcjJxbnRrTE4x?=
 =?utf-8?B?emM5WWtZZG5WbXNLOVlMcG9hTjNKa0hGVlJwTkxzT3FadVlLTDI4dlRqSDAr?=
 =?utf-8?B?Si9OZ2NZaGJkMXZNL3hIV05pRVB1cVp1Z2JVQmw0ZGJTRjcyK05TWTRMZGVL?=
 =?utf-8?B?ZE1XYWFrV1FCYmNEeGdjVm5EUlhHVkhYRzdsakxqQkw2TUpVaE5aME5md2pL?=
 =?utf-8?B?ekNNWlhPbGNxL0c2UWF5a0lPRUg3c3BUUHl6VjBtL09BaGMvMmxxdGpWTVdM?=
 =?utf-8?B?OFYwZXcwTnRWTkkxeXJqTjZuelZwWmxYOTZMcnRrUS9HSEtzT1ZjcWo3aWt2?=
 =?utf-8?B?ZDFNdVlJSDY3ZDVDK3E2ZkNwOUpVSEdhMWVnOFBleHdIVnUxSnNlZGE0NEM0?=
 =?utf-8?B?c2tYQjZkVUhURTRUaFg2aTVOMllObmROZHFMaVQ2VkgyZ0VuYnQyakVkY1FD?=
 =?utf-8?B?bUgxZ1RabFhFRDVyajNheFVXRkFHNHhOS3k0dE5XTlppa0tFZVpUY0h0ektH?=
 =?utf-8?B?TUFBZkRPNE1DOE9SNXdwSkJISmlwdVdrYlJ4K1NNSUpBQmhiZ2FwUFpNTHg0?=
 =?utf-8?B?QWdtZlhtam95aHY2Ti8rcXp3KzcrLzJ0aDAzalRZYjJzUGt1MnIveFE4YTlx?=
 =?utf-8?B?bkhsSFByMHNlMGV2cHpGenVLemVrWll4eVNFcDd3U3ZsK0xzMXJDV2Z5Nlp0?=
 =?utf-8?Q?j3E47ERA88i+l2MB+q3hVMsk2Ef8HaHm2tSJX?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002df278-64c0-42e7-09ba-08df3e71ca41
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 14:57:35.6286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzEQmhutz7VXHu+vdKS3oBGyozPzVIZ6I9bMMN7b7MZKBStkpUvWZEe7mcqdUdSrIFtAFZloswwtKnBafWlNW5nW6tr1uhU9u1R9XQWEXF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT6PR01MB134462

On 2026-11-09 09:30, Juri Lelli wrote:
[...]
> This 2nd hunk complements and tightens 4043f54984161 ("sched/deadline:
> Reject debugfs dl_server writes for offline CPUs") which has Fixes:
> d741f297bcea ("sched/fair: Fair server interface"). Do we need both
> fixes (if that is allowed) or maybe we need to split this change in two
> (as this second part won't apply to old kernels w/o dl-servers)?

Good point. I will split it in two in the next version:

- __dl_sub() and __dl_add() skip the division when the root domain has
   no active CPU. Fixes: daec57983670. This alone removes the divide
   error, on the debugfs path too.
- The debugfs write is refused while the runqueue is offline. Fixes:
   4043f5498416, which it completes for the hotplug windows. It only
   applies where that commit is.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
