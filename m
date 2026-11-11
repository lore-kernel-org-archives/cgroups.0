Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794411324;
	b=5YBcieH3tMjKX0UNY09YlXxnlkJCPW8YdhQUk7/MNm5tpD8tWbwuY+7FhGzdmqKYgB/e
	 2ZzeJuPFzwDbtNONX1JGUrb/cguidisR+5yeBdT5oumIzS3u0D13msBoPwxMwZoqRTR+9
	 PIWxVB1KxRAyNgPssZQ/EiTYxQ+eIOIaF2v7RjUNGIVfQGkgB/wwKmSlDNAh2o1h8PjOG
	 I/jrP/vULNIw66BzgoUdIoRzdUOyVF3utBW72KXI5v0RGByLO1DLjA60XKuBAX04hv40P
	 sF/6rzzW3kx4rdyf4KcG8lKQ980+SKE6jnPXBH10TQuUC5vstl/6/exsP5PDEAYNvEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411324;
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
	bh=oCY7BZnYiToD6/ATqromLaznfVaKf+BX/Aui8Rih9MU=;
	b=271OveRm392cxVgdfYfiBccmv/5zbdjjgQNLRZsnghcyY3WeJUNppGZhVa9I1mP3XB5H
	 nlqU1fNOCk9i9VXbuVrBM98GfGk2WIDy4wIG8Sc/8rbAH+ZrPD1iMIQkVg/4H11rG/Dxi
	 UTy4dZEScmSXN0M0m6zg2FhzyXVbuU2j1is0AonwqRjut3d2CO5L0TBLkyNkWppodu+2X
	 Tzud93GasfCqu8B72iw/ATb7an5t1mFQuZ/z+LKk3bOVHcYUDJKI7sy4Tp+/GJk/Xbhsk
	 j2paqiHRFEdwFXqrnSQQ9bQfZSQRrnND0tVGPtyyUh0D2d6Zr37Ljl6WLNJIBLIrqjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b="NKUmCoa/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.191.128
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020128.outbound.protection.outlook.com [52.101.191.128])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA79C606A324;
	Wed, 11 Nov 2026 15:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA79C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=NKUmCoa/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxZoyLAJu5+510jqxNE4liAuEbL3/WIQaUPB1g68wkdzV0WqxTuRl0i8b8BRugfdgjTyUaulce43uAVcMVbR9swd6iXiGo2lUw/swUnP8+/FOg5uN10EglZv0PbreZwMZlMt/blydzhVo5Vu/9qWQYdv3Y/F0YntJFO3CJJIalyULphMULk/0Wl7CpKsYxIReS0e4REGZy8QB7/Ky9xAHi/VHDK8ILwrPzoWFyi5kW+5Natz/CGKQW8tZhTuIFvGXzmUCSnbXwS9ZW+1UrBme6Jg3ZApn/HepoY7B/sQmvz8iOsFkQ6ytWoest4IukzyRPSRw8IdAuR1CjYxX5KN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCY7BZnYiToD6/ATqromLaznfVaKf+BX/Aui8Rih9MU=;
 b=cx28mr81yjN7KoFPQW0aavWH7VMGIF3rV1DC0tzqECSydxyhS2q/HHDO0ClFuDrE5ikuT4QwmlJWnGO1EZLvfYiY0LSc0rxaltcN6sgn71FMJon2vHRg0slxEgWaGzbC8NZmSC6PvtkuQSOZ2IFSMNxHuMJ48riZWcFzZvaarwWYufWLIoVAb+0E52qb8qIediIOB+ShSidTOWnVrxClr/s/+2SO4zbg1oPWSwVtX70OxkwGhWhKkg8LFgoalK2DCKTuS+qcd4LeQHrcT9R5QRuACIsX8M9LmvDS1L3TGSjzmr/zkZ+z4Nq7UMSM2xFvIL/bHHCNArMjd6+sKJIMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCY7BZnYiToD6/ATqromLaznfVaKf+BX/Aui8Rih9MU=;
 b=NKUmCoa/qw6T9Gusja1tAmjKY9xb0m5fS45IW5yrsGW92ZzgJD1qlnct57HipzlaBUCa6FNrz9EW2/YX6HHUWGvc66CAp06UD+M+SsZrprP1XTIt5KiFd7vG0q2FD2xJJB0jjojHkW9bQAWbuCbHmiJgSEqovfWwmfbQjfnL1BYej4ZOR17DjTj+EN7l2wxOOYKX8wSYuwVxsyJzQzirZmP1gbigMd9HKnIBGHJ8uBJI9GN4oghTL9Qo/57rCfAQMxT/suzFf/JaHbeNQY582U2Is4Ih17gDy7gxg1rMvDMq8aNW9L+7XGAgf2TRfusEHVJPoJao7kxQksoKFNruxA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQ1PR01MB976392.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:113::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 15:35:20 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 15:35:19 +0000
Message-ID: <c3e7054a-486c-4e5a-a646-eee42e815ce4@efficios.com>
Date: Wed, 11 Nov 2026 10:35:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/29] sched/deadline: Keep departing bandwidth across
 a root domain rebuild
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
 <20261108185406.1549770-14-mathieu.desnoyers@efficios.com>
 <avRmoK08LoIeySBL@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avRmoK08LoIeySBL@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::10) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQ1PR01MB976392:EE_
X-MS-Office365-Filtering-Correlation-Id: e65dbb6e-a769-4a6e-ae45-08df40096493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261028144727099003|261026140227099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AQ70+EqQO8kOUE+CB5M/f8BwPrDA5mcejtI3uS/h4J1kXjWrTqb3S9JNBIsVkzgisA3ER6veZ7viyVRX1+LvUoJzZ7XZpirRR5r70SN+hXTJp/sntqpptXuyChuxmJCB2JoStTF+1xWhLyscWrUr2fWcbKO6axAbplZX6FxQKs50PgsyTiJHIWsjnddI06EpwojbwY/W8spXX1vLJPdIECldVFPPuA7XBF7wYZj8mnJEshBXwaC5c9coJ5ymachyYawXEL3a+t6BtXoOuLD0N33rGLHjlgpNqNeoTIH0rURlReulgpawf/EybrKfonoOk1yda8Ct/oSFV0obd1wbTQ+9x44T0+Ibe+oDBuUi/JLia8tnUiueqHVt88gyuu2/lokjJi8ebhO+j7F5cakqn+2TWuvfWfmBdo4MrT5XVlk9M2UYhbkCQYt1cL9W6uIoKZ4x18upHIlxRD+nH6yiHOWelD+FBMBeIDt+XCL2xHkFG7OgBOqn9CymF+0z8ooTMqHDzNQwMuMFTLoyJ+hZpvT3Hy/fVRd7tt8lmioqvbY5GU0wi+3ugHeOHaLmMcYZQvJhu5GVl2paWtn6lLwvTKYuQ17iCtjWtL8xKQrtsZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261028144727099003)(261026140227099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWc5ZHZyRS9rK2JYakRsRm1jN3B6VSt1dFpUWUlkb1BHWGF0MVpMdnZwZXBz?=
 =?utf-8?B?aWhtaEk0bElkNi8vcDlsMmwwSER2azlnNkNjVTBJaTZMWkExRm9IWEtiRktn?=
 =?utf-8?B?dm9EVlBqU3U0c0ltWkVuck9QQUQ5czJDejIxYi9oWVlQdW9ZM29YeVdiSWJk?=
 =?utf-8?B?SXJNYUJzbHRaRDM5VjdKSS93eTlQZWdnZExYVEtiNkF1R00zUzBhckc4NzRV?=
 =?utf-8?B?d0djMHBhcTBpMmhGeXI5WW9SanBXdXhkWUQwTDZPTi9BVWdsWjZBM0p6V1pB?=
 =?utf-8?B?TjVVbk0yRk9GWkdnd3M0UHRSdlljZDA3M0FidXhienRkV1lpN1FvZHRFNFpy?=
 =?utf-8?B?QXAxWkQrTERLeENMWS9jb0dtT0J4TnJCUmJKZG8wWk9iay85WGQwSk1WanFM?=
 =?utf-8?B?djBZZXNORGhGdU9Bclh3eWtVcTh4KzRZV1V5OG9PMExmYzNmK2NrWU1vQzgv?=
 =?utf-8?B?VGZyUytYVEk0SUluZjBWaHo5S0hmZklQdlFWK3ptNU9iSGZnc0huaWVMOW44?=
 =?utf-8?B?U1l2L2h4eDhBaVRLMmgrWEFVZmZOOVR3alJRQ2VmYXJWK2xGRUk0SDVYOFVK?=
 =?utf-8?B?VFVBMnR4ZnBhajFnSU9lbUNQbnBXN1Fpc0RrYzM3SjdwcU9jbDBMa1haRTRm?=
 =?utf-8?B?YjQvQUZXTzlKZFBxam1TL25mUGxUQnYydWRVK0V1ejlzbFMzck5UaE5tWHBB?=
 =?utf-8?B?VGV3Zm5aZk9kY21Fdk4vY0xJVStKVk9yNmMrMUJOeW5nYmt6YkJmd1RsSVhQ?=
 =?utf-8?B?NTNRVnJ4VWg1eFVvb0ROcWpwNlVXdWJ4NlVIMERpejhOOTMzZUhFdG5Rb21h?=
 =?utf-8?B?NlArVkdHRXFJd0JZRXR0cFhtK1UyTVBCcWNWWVlrQ1cwd2xBNVErcjFEc0oy?=
 =?utf-8?B?djhCQjk5NTIyTFBmbnRJUVhmL2FoMEsyakVCSzFmMVdKMzJFUE5LS0dwaGVE?=
 =?utf-8?B?RDljOUpOa0NHWlNxb0pJTzFDVENDbWt2dHFwTmMwYXowNkk1TklsbXhXalB3?=
 =?utf-8?B?VkJXbHppYUZtK3Nlc29WczhmNlFsZk1lMFhHdHhRc1d6eFc0MDcxRncvMDRV?=
 =?utf-8?B?UURMQUJBZlhqcTRCVTd6K1hURGRTdG1ERCtGMUFRYjFSUGZUbjZTbXRNYzd4?=
 =?utf-8?B?eE1laTUyOVQySCtDLzZWa3FVVHlSejBjV3F2cVp2RTlKTzJWcEVEclVWSGtD?=
 =?utf-8?B?NEJyZkk3MnlPSC9aeXBnZFFvNEtqM25oa1RrQng4SzdaKzJLaE4ybStHY3JM?=
 =?utf-8?B?a01iZDM3dkg0aTNXR2grL2VVU21pN2xzRWNOTHp2TDFxM01yejJpblNwSDhp?=
 =?utf-8?B?MEpEaDVJbG5TV0FwR3JTcmlsMStCMzBDVTZwSXB4bDlsZnZCdFNpaUlvSVZN?=
 =?utf-8?B?T3hYc04rV1Y3NkFtVzc5UDZVemdUNHYwWVlDU0NWTXNzOVdpaC9YOVMrQnpm?=
 =?utf-8?B?TTFvd20rR3BrYldHTzdkL1BtdVJXalRvcGpxaDZJRWdXK2xreW4xSjZJc1A3?=
 =?utf-8?B?WTZRaVIwdDRXRTBweGl2dlRRb0N4QldMQWNhMUdsakVKa2NkVmVPSWU1MDBX?=
 =?utf-8?B?bUFEOGY2OGdCb2p6SDZZL0tUTUkvSG9WSXFiT0RVc3pLTWc1Z3ZpaW5UWGVq?=
 =?utf-8?B?eWEzTjNxVHYxMzdKZjN2WjczZTlnT25wK05XL1pMcVF6OXBTdVRPWjJ1TWd4?=
 =?utf-8?B?aUlFTk83MVNWVkNKeVpmU0pYa3l6U08xRG81Nm9RWDNCbkhtTTBVZ3Bhc1hF?=
 =?utf-8?B?b0ZCcVZmRURNWVhBUVJxZ2lLYkRkazhuclBjblpVaUhweFdRYXBwOUV2dTly?=
 =?utf-8?B?dEtqL2tBb2Jxd29uRXg5TnJlTXYreEJ1aTJZWWtibGo2T3FoMkdld2hsVVVo?=
 =?utf-8?B?WW9kaDh6K014MWRwZ2w1azJ5eGhkTTZIWlREelR5VjhEU2hHR3B1Vm9melNj?=
 =?utf-8?B?VFhRZWMwYnI1TVkrU3VtaCsxcGFUWkR2bEVJSVVWMXp6bUNVU1QrbFYxRUdM?=
 =?utf-8?B?d2hYckNxVXZNM3ZKcHdwTUViUVgrWWFWU2xyS01wbml4VnRHK2l4RUp2Ykly?=
 =?utf-8?B?RHBycGkxZzc5YktLUHJWbStXYms0NkhrdkhYdHY4b0s1VHFFZUhmK1VNdUx6?=
 =?utf-8?B?QWdwbFhQRTVSNGMrVGl1NmNWMk5TUkI3aGhCdEFrMDRwcUdpcXpWbXdseVov?=
 =?utf-8?B?UkdtQ2VjMDlZNzZqQkFXSjZURDJ4RWF1b05zdnFNc3JHdzVXQm1ldlBKZkpQ?=
 =?utf-8?B?Z0JDaEdTMG4vN0JJZU9Ka1N3dXVkZnZpV1QxK1ZGQlVOT2NRa2lQcXRpaFI4?=
 =?utf-8?B?U1lrSWRaY0NURmFzNmQ1R1RYNG9reEIrTktjV3VEUVBsU2pDaUdHZXhuSWhI?=
 =?utf-8?Q?UPRx+YPNpYjm5nhc0Kssw53Bs5Gckq4Q/b/4k?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65dbb6e-a769-4a6e-ae45-08df40096493
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 15:35:19.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50CnFNJkYN2fnyHEJiiAuvQlUDbz0q300T90YPSc4UoZAmN2pi1IOSL07awQlLhVbw3Huv/Vgl9rQhdz9mMfbssnFE+TaD4IeJBpTn+r65I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB976392

On 2026-11-11 07:59, Juri Lelli wrote:
Hi Juri,

> It took me a bit of staring to (hopefully) understand better how
> dl_bw_gen works, maybe the following can help others?

It does, thanks. v6 takes your comment as is. I only changed the name
of the function that increments the count: it is
dl_clear_root_domains().

> Maybe additional info can again help (before the above)?

Taken as well.

> Can something like the following happen? And do we actually have a test
> for it?

Yes, it happens at this patch, and there was no test.

dl_task_undepart() forgets the CPU recorded. The end of the boost then
takes X from rd(B). In my run the deboost armed the timer again, and
the timer took X from rd(B) at the 0-lag time. total_bw of rd(B) went
negative, and rd(A) kept X.

The end of the series hides it. Patch 16 replaces dl_departed_cpu with
dl_bw_cpu, and the record survives the boost. So only a kernel stopped
between patches 13 and 15 shows it.

Planned for v6:
- This patch keeps the CPU recorded when a boost takes the task off the
   list. The series then bisects.
- deadline_bw_test gets a case for your scenario, pi_departed_moved.
   It fails on v5 at this patch, and passes on v6 at this patch and at
   the end.

> Wouldn't it be better to move to a single list of accounted tasks
> (current and departed alike), keyed by their recorded home CPU, which
> turns the rebuild from a reconstruction into a re-partition? The
> dl_bw_gen machinery and the cpuset walk would both go away.

I tried it. It works, and the code gets simpler. But it costs
interrupt latency, so I left it out of v6.

What I tried:
- Every task whose bandwidth is accounted is on one list. It joins at
   admission and leaves at the release. A departed task is marked.
- A rebuild clears the root domains and counts the list again under one
   lock. A release or a move sees the accounting before or after it.
- dl_bw_gen goes away, with the walk of the task list (which replaced
   the cpuset walk in patch 15) and dl_add_task_root_domain().

The 75 selftest cases pass with it. One point differs from your
description. The rebuild is not a pure re-partition by the recorded
CPU. A cpuset change sets the masks of the tasks, then rebuilds. A
sleeping task must then be counted where its new mask puts it. So the
rebuild still picks the CPU of a deadline task from its mask, as patch
22 does.

The problem is the lock. A release takes it under the rq lock, so it is
a raw spinlock taken with interrupts disabled. The rebuild has to hold
it from the clear to the last task. Otherwise a release sees a
half-rebuilt accounting, and needs dl_bw_gen again.

Measured in a 64-vCPU guest with sleeping deadline tasks:

   tasks    today: rebuild, longest irqs-off    single list, all irqs-off
   1000     0.75ms, under 0.1ms                 0.12ms (0.19ms worst)
   10000    7.4ms, under 0.1ms (0.3ms once)     0.9ms (1.2ms worst)

The rebuild itself is 8 times shorter. That comes from updating the
extra_bw of the CPUs once per root domain, not once per task. But the
longest section with interrupts disabled grows with the number of
deadline tasks. I do not think that is a step forward for a real-time
class.

The patch is on a branch. I can post it as an RFC after this series if
you want to look at it. A walk that drops the lock every N tasks would
bound the latency, but it needs a per-task marker again.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
