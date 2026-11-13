Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.81
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794586570;
	b=QC4wDsRa7GFA49LGBnRNgI2dn5GVOK1Ecom4JGWDsnmDCWeSekwobQUnrN5C/iPmxcs4
	 7ok7vaXS3Arx52rMJd5yn88pgrScOCulp4qPhm+Dik0u8q1ERgtf40ZOVRu06bbFTgXnc
	 LYm1RHsz9V6E3cW9coAQ/iPIPO715kgm6ODtekzoMNdSuPi5CW4phMD2GQKBTLMXVAVOr
	 Wf9ZmgdX+JyWjgfXbly4nRc0EE3gyEUNkgbk8LNFyLlD864mI1e0hfGAfkgfJ3Fdp+HtY
	 5xgis8+o+nAago1yXgXzwi1/ylEeFwgfid1Loi78fioYqDZ+BdRK3hYOf2AVLNRBHpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586570;
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
	bh=3N2WmhG8KxSrZt0Iba4WEygFxOvKmnHFAdgM0m8IUoY=;
	b=2h4ZBqE++hjbGXWR5feZlz7Y4bEfDCmaeDKoEAy4ccht1VqN4tko1tCiD3i+Zk3C+bXS
	 Owmt/joLgBYkCwdgieennZ0u7h5I/gSktmjElu7Y2A/FngboF5VZ5EnDWZbCJ7HmWj61n
	 cnfb2qZhYtbVC1EWAQrVvs/JS380GIzY54SGAlO1nGbx7ZjQX7xTA+MXPAfyek5madpiG
	 1w1GO3KRznigm7fpPsPZwNu/PO8BRnlGZXrtkpwvjS0qbYwpcRw0aVE6JtKCQxzKOC+Qb
	 +2F0buCMBzvWy+hlXEaxHt92hOacTciyASjcGZG25u1Xfyccp7EJcp5ldi9Z2wvL+Lw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b="L/ER6hfl";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.81
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020081.outbound.protection.outlook.com [52.101.191.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F747606A332;
	Fri, 13 Nov 2026 16:16:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F747606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=L/ER6hfl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJZcgwv8DUeypCP0GDMA5WmvArYUHgdL+DXxaxwbZ23WGhXgae0PkyP0LaQQjkF9mByyIvm5OT1c0VFzl6ABHaqtkEylSzoj5w31Ikw2GLlIWqegra7hv4Z9+JSU/eKMeiCpixsPiUMeDOn4RYxz6IPwI4CWI042kNGH/MD1C65giX6ssMjJfr20DBcFPXo5gd54b1W4PO03aqg9bXvogUUa1W9dOWVqrd5CL+sc5FDz3Aux+zIh35ZolDvs6L9QNFGpjkiyHEiChCmiWQ214UCgrJRC2tx1igoHX8mtYeSYZ5qvdhJmdvvUAMMWzUrdm7jThAjHdVE1pjybiBSwcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3N2WmhG8KxSrZt0Iba4WEygFxOvKmnHFAdgM0m8IUoY=;
 b=wBrQF8VD4Uze1iSvMzluB4fJZanPqyszl4BBuZnENJK0P21ZxuABlbAai756+NyAPQglI0gDcHo7euoBt92DAs4DcvD1Oh61Amuf91lHIdUgTrrnpMYiSMwLz56T45NETEB1V7MwWSJKnyqHsyNjnSBx2un3aOG3NFBR6zg8mmKGvgv4j9x9TimwWysc53Lbsmzgooosg24a+MW14Kbi/4FYSayL165xaYLB++kKw76/z8HT4S6o5bBZ2MpWpog9nUrEOyl0dIKVTVdOYIWl1xKUhN1SkIpFSIGcl7iJRaJM2pXvFFtgwu4UfEpgVG4q8xNz2DDE22l/2QuefxZd1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N2WmhG8KxSrZt0Iba4WEygFxOvKmnHFAdgM0m8IUoY=;
 b=L/ER6hfl6AI00wL8Tuc1QPub5afAkS+kwByePrqcmzQWdDO3Dt0Cd+EvyTEvoA7YhocGbEsyO6WAYLSEWu++sm9z5QvjXpEyYhk3ARI3ljlGupAfmPR2vDGVfFaRC8HtVtsSLngNEBdkmYnsdVE3iV83J693cLIPhs62/cYo68N1C2r9ajWwkmMY1A4FvCwDkWBjuV8+tELBsUdNi+8LLku0qQEwJJNydnavajOaZqRRG4s1Fb92LM6tIsPlWOBhorxLmNeP/mP0Yzd0ElpUMzMto7soPfk26rJix4zUNVyP14wLUMHmHpRHzBRHFqhCBeANZTWiJElKHAAdobOg5g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by TO1PPF90822B598.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b08::66a) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 16:16:02 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 16:16:01 +0000
Message-ID: <eb08fd7e-38de-4888-a112-f4ae5b100441@efficios.com>
Date: Fri, 13 Nov 2026 11:16:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/29] cgroup/cpuset: Wait for an attach before
 rebuilding the sched domains
To: Waiman Long <longman@redhat.com>, juri.lelli@redhat.com,
 peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
 boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, ridong.chen@linux.dev, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-20-mathieu.desnoyers@efficios.com>
 <4cdb4452-f11f-4e56-b03a-6d751dcfb62b@redhat.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <4cdb4452-f11f-4e56-b03a-6d751dcfb62b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0323.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::29) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|TO1PPF90822B598:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b2174c-aca2-4d95-75df-08df41a168fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|7416014|261102123227099003|10067099003|4143699003|261021121427099003|261022075727099003|261022105027099003|261028144727099003|261009223027099003|56012099006|261026140227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	piRMEBUDkHkfz91R1PXrs4B+ByNnPWElsdyPv3OiurQjpmOb7GZ/FN3VWZE8KQYpHyW7IMJNncaWegQ0e48d6NA/XRKeeQL39IxBR5GiNl6AYhamOgG3rHir1b5Zbn8OMqWk8tB++Ymote50S6gGVImMMinHcMBSrexQBNOGzD14QnC3CaX8e3+XDrRdRLsyHuzKr3mlAVpHOwUDCZh4PUj66ca+F+ZIFdWioT2HMYZKEh9rRFXd0pjoNXUgvtHiSei6H+mXt8usIieKD17I5Ub5A5Ph4M3vy40fKgyDfzLQq1Up+naI0VuZzZlzBFmbLno2ikl0HyV8NI/E49mq+c4/PEcmoxECOaCnSgfi4DPymfMarwI/ijfCCXD2Sd9Fze22OdUGFS2RZDUTLJqiDCHOiSUe0h+2SXEVmWEvTvSJxIL1qli9xcLKqjtkI8GZp8iJyE5sktevxNlaU+ro88f0wTKr8AUmJsaBkSheu2wUYLJ7rzh+zV5wiFI6pxILAcLnHZaVdrO6I8jJdN9T2NrEfPfaLdY29KfgnPuPpicswDUIy65F4IWGZFWpvrYSYMd4JwiFAIQW4/3Cpmzo/PAgSpJXm8J7wT79YalcmjQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(7416014)(261102123227099003)(10067099003)(4143699003)(261021121427099003)(261022075727099003)(261022105027099003)(261028144727099003)(261009223027099003)(56012099006)(261026140227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1drRmw5anlUY0M5RzcvV2RMU1lNSUxPWDRTWENiajVwSTNHUFVMQ1N5MVhh?=
 =?utf-8?B?UTM3L1pXN1pYYjhRUEJvZ3BhdGNnQjFPditUYnJqK2VlQ1pUK3Irelh1cU9V?=
 =?utf-8?B?d0lsQlpnbjVwNW5lSkkrT2FpRURGYlptVUVEMTR0eFp5VU5oU0hXWEVkTTB6?=
 =?utf-8?B?eWk2VWhXYit2M3R5RW0zZndVZldpR2t4OFVMM3JpZUh2UmRLT3VwR3BDbDFh?=
 =?utf-8?B?aVdCRnpZdUdPYXZkd3JINjFaM3NrWmxQQnIyQ0lTYjVHcUtDK0d3MDZLV3FO?=
 =?utf-8?B?ZVZmbllDS3pEUmljZ2M1VWo4WXJ6Rkg4WmhjTWpTTWhPY3pDelJ4cloxT1N2?=
 =?utf-8?B?VVhhVGFtM2dsMjEzZ1p0ckNnNktDQXNteVNmNGZSVXY3Q0hNSXhFV1ZEazhN?=
 =?utf-8?B?Ym1oendoU0JCMk1GL0xxWmllZmk5M2owdlJUTmQySlRUTklQd3dVbmVOTkpB?=
 =?utf-8?B?V1c2NW5Jc0ZtVGdCVmEya1dWVG1ibTFodGhPUExyV3Fma1RBaElLU1p3Q09m?=
 =?utf-8?B?OUpPL29KQ3Zpd1VUYlBsZUJlN09nV2dneWJoWFA1MXVDNVdteHB6VWhhbVdL?=
 =?utf-8?B?SEQrV2xhWkZCbkZ4WDhRVllZelMrZS9veDZZWFlGcUVYQm5YSzd5bmxYc1RE?=
 =?utf-8?B?WVpOejZOaEZhWDFYcElocEVnZjBRYVJxakJUY2VqSURyaURYUGxHUTZabXhC?=
 =?utf-8?B?QmpjRURQN3dJaUp3RmVibjBPdnRDR09welBHV2NsbFM1MUJtZjFVaFUyVHJk?=
 =?utf-8?B?VFRQVWdTM3F5NDJiaUkvSW5hSWdlQlY0blRBY29TbXM0eVpJNHNsd2VQdFlI?=
 =?utf-8?B?MHd1YkJoeU9EVE1zNkY2ZEh3NTAwNjRITkhhRFFHdDlDRTlWbklKY090MzdF?=
 =?utf-8?B?N25DTURLYk53UTZJRElLUHhxZzlaNTBjTEorZnh6UUxpejYxOHBVWTFZa0lG?=
 =?utf-8?B?ei95VW5lN1ZUbjEyNXZMVGJKVTl1UUE0RUcrTm5iZ2JJeTRsQXlXdkQ1Mk1x?=
 =?utf-8?B?aGNOMVFlQmxUSXNqczcxcDJqWHltZVlWUkFpQUY0ZXZDaHZ6dG9zSjcvcWZD?=
 =?utf-8?B?Vlh0Q29mKzlWc3VObWkyZ29KZWt3bG5jS1RJQnpIdVN4Yk1Sd29QVWJvR201?=
 =?utf-8?B?Z3pPelg5NFVaZytNY1hjM1N4RTR2UitPNjhveXIrZDJwbi83MUliRkR4aWdn?=
 =?utf-8?B?cVVsREV3UnYvSTd2b0plejR4YjExV2dScXUyVU9jZkxhamdib2tzU0d5MkFX?=
 =?utf-8?B?ZnhVQzNVcFoxZjdVS0JnOXljeFRzZyswQjBqK2Q5cGxiRmJqTHN4emRPWmxv?=
 =?utf-8?B?cDRwUkQxaHFqQ3hydmRnSFBmalZqWVVhd3dPTUtnWm5YeGhacjgzaW5qd0Jw?=
 =?utf-8?B?aXd2M09SVkJCWGlFSXNVS2hjYVhtRml4elY2dUhoSDFnYTVJbytwbXU0VnA5?=
 =?utf-8?B?OTlUM2RrTHdkb1ZYVkdBUjE5RThkRzlSQzl5Nk4xTEJsYmhhV3R1d2l0UHNF?=
 =?utf-8?B?ZVJnbGhDM0xLQUgyQkU1bzJ4OVU1TC8vWlVFUDdvL2dmZENxRk8zMndFZkIx?=
 =?utf-8?B?TlRpQkZTM1BXL2VORDJBMzh2T0l5Mm5tdHFDN2tEY1VkelA1UklyN29wRUI4?=
 =?utf-8?B?bTJ3blh0UjNRczNlNitNM1MvcEJyMEhERnZnU1FnekFpc1JXTHRkWldqKzZM?=
 =?utf-8?B?Mk1Ia0RsZzN4MUFHdEpxeEhqOTdGZnR3Vlc1cm43ajVoeVB4cDVZUTJTQlJk?=
 =?utf-8?B?RjVZaDRhT3QxaktRMGMrZ0JPWGNhVWpKQjJnMWI4YnVHSnB6S0l2MGhIclRl?=
 =?utf-8?B?NWhFUUszcUVHK0ltSU4xMS96NURkVkVHN2dqTGljckRrTnFrN2hUa1hBa3VC?=
 =?utf-8?B?MWU4a04wektWMmlUSXF3aGZ5akxVNExseFQ2bzVoK1k1OWhkTS9GOXIwc0lp?=
 =?utf-8?B?cVFjeWJSSURBZ3VQWmJ2MFY3eHk4bkRQWjYyK3V3cldUc0FqNkVuMGc2RXR3?=
 =?utf-8?B?VTRHY05CaWNBZlNFb2d0dXFybGVKdUZtYnNUQnUrc212NGhlZXRUUzV3UFp5?=
 =?utf-8?B?VWFGQmN1Y2hrSndtbnJLY3B5NWt0LzE4SnVyc29kamprVk5sVzUrZlFrNjJs?=
 =?utf-8?B?dml3dnFISDd5eng1Y3hxeEJHRkpkMzdRK1oxYlBKMHpaNjIxR3FHZ1BhQXEz?=
 =?utf-8?B?dnpuV2lMdmxweUNnL3F6bjJIS29HblhzeWhPOXovTHFRZkkzQVFDVlBVZEVr?=
 =?utf-8?B?SFNSSEJaRnlhQ2UyK256Nm1aNlJYYmNOOXEzbEU5LzVXTnI2bEhoU0MyRWxD?=
 =?utf-8?B?S2pqdHEzRFBGRndROFpnY0RqOFVHVE9xMlRCNEhpV2JRczRzSVBkdkVidkZ0?=
 =?utf-8?Q?nh/NTIkYTP8eE7VYXmnFdNgkuArBOqtb5CD6s?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b2174c-aca2-4d95-75df-08df41a168fa
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 16:16:01.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAhIKTHmABvYy6HHkgnr8cGbzlbGKevSnedsaIn+RHOZGve7flLFPJaFNM6xIJcuwGHwpFRB1VaQMPWUzklxQxDJrtkxXH90QkiWHcpv0Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TO1PPF90822B598

Hi Waiman,

> I agree that rebuild_sched_domains() should wait for an in-progress
> attach operation. The change to cpuset_full_lock(), however, is not
> really necessary. This cpuset_full_lock() is now mainly used for
> operations like cpuset_css_online() that are initiated from the cgroup
> side where cgroup_mutex should have been held. IOW, an attach operation
> which requires holding cgroup_mutex cannot happen in parallel. The only
> exception is hk_sd_workfn() which is a work item for updating the
> housekeeping cpumasks from hotplug which has no dependency on an attach
> operation.

I agree for cpuset_css_online(), cpuset_css_offline() and
cpuset_css_killed(). They hold cgroup_mutex, so they never wait there.

 From reading, three other callers of cpuset_full_lock() can rebuild the
sched domains without cgroup_mutex:

- cpuset_write_u64(), for the cgroup v1 file sched_load_balance. It
   calls cpuset_update_flag(), which calls
   rebuild_sched_domains_locked() when the flag changes.
- cpuset_write_s64(), for the cgroup v1 file sched_relax_domain_level.
   update_relax_domain_level() calls rebuild_sched_domains_locked().
- hk_sd_workfn(). cpuset_update_sd_hk_unlock() calls
   rebuild_sched_domains_locked() when force_sd_rebuild is set.

The two write handlers are called from cgroup_file_write(), which does
not take cgroup_mutex. The work item does not take it either.

The dependency on the attach is in the rebuild, not in what these
callers change. rebuild_sched_domains_locked() ends in
dl_rebuild_rd_accounting(). That clears total_bw of every root domain
and counts the deadline tasks again, each where it is now. A
reservation that cpuset_can_attach() made for a task that has not moved
yet is lost. That is the diagram of the changelog, with one of these
three in the place of thread B.

I did not reproduce it through these three callers. The test of this
patch goes through sched_rt_runtime_us, and my test kernels have no
cgroup v1 cpuset.

If you prefer cpuset_full_lock() unchanged, I can make these three
callers wait instead, and leave the css callbacks alone. Tell me which
you prefer.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
