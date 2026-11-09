Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794237729;
	b=3X2+BaEQVev104LNcEWjSf557DSsH2c64NtOsKCq+jLw7rYMVDd0QiXbBP3ZaM60nbFv
	 7ZOy2gQpCLaieA9yy6ck7tGwOM8RWQl3EpjI9SVgKoJUJWJsZPBq2cTWDLO/Oep3ZeW0t
	 qwComp5Fr/9ClnUC+WeCNR9tgzWAsr+j8mIKf+0oKQKJ1nK2nbzR3hEkbrh0byxwaippT
	 u7Jw5C/YV6cG9USOFOuxbqdnq/XxyrIXyGai9Fwm/VY8e1Cbz5U5nRdTQpvZx8Pe5s+QK
	 Q5KHyzGOqWLXmkUafKDlVpu7rVT6JumkCNocPBxSN7pdgLaxxYwtwh8sSv8ClzBBabw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237729;
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
	bh=2KfVnvk4DH29ak7JSGJjqNdP8YYeqxLAbyUmtvzxDcg=;
	b=njgeGE74R5UQ3Ndls+wyBm3B9OPQ+Yago+h5f5KsQ/3CCQE7KBxpxBpWB8/zVvKCckc3
	 ndg+CBlmnDG0ThjJfQSpifr/5HG1ps5rxJbKm8LuyDFa3W5BECYp9jupE/+bTRVKyJBdk
	 N0msb8nPFm3X/dxIDyOZTRilfVucytmnfVFZ136f9KnYN5rzHJxhttqzHVg/O4Mz8t3Sy
	 P/CHBAR2Qf6Fzwufu+3aoi7pLMBh026QKVc6V2D7Si97GYTMuXvvbmPYBAIVQFBrSJjfx
	 9OMrdK3PAdu2TdRGvSNTbHD1cHdCxulQHahuw8Dbmz1sc+rLUfbn8GLg58ltCsmQvgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=oUabQ4Pt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.95
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020095.outbound.protection.outlook.com [52.101.189.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B646606A31C;
	Mon,  9 Nov 2026 15:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B646606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=oUabQ4Pt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wCeBLVSks8WfePCJLfQ53G/VS1LdrAOPgcyHIdffXFxOOx42ZIJ92DkP1QYwMDVCc/wJ1KXAPKKW7hZKNdg8Wn96qIjQbxoGgi2ALpBQCWTeld8KqEdMESHlvTJ40qPeDgIlvWVq3lWDzje7sHbP8rfOHJe38jOOZZA3Xv6/07It7tkkZOSz4t7YqRWGQiHiXVPph+MwqQDf8onShgiIAPAq0BcYLxgNZ195lOTwPxdbJMagUHSYFAmd8EzWbA2LH9URhHFnSmPDvtnOdAApdy+soh/KyPdg6PhPxvPeHw4Ndp4C43luCZv5jgq0Wl6kUGwgdsSKSH2N8+a9wWA1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KfVnvk4DH29ak7JSGJjqNdP8YYeqxLAbyUmtvzxDcg=;
 b=sPDs/Bs1pOEsXIwJpnXxzrkdO6Zb0Xbr0Km/iXzKmBzBnXQZjkLEAflW77RoNKrXArJku6QF1vV74iGEMKsavEP6SU+74FmbJHmTk+nZSbWSpcOFp4J4iiezHTNjIy9jC+ZQ//Pu6ZCQUA/V+9aJzWlFScXncORiCCUJVSBrnlQ+9219MObdpDatPrZ4TDkIwSN3Y2bbB/b2gHPH0Jo1ictBFKYJW16I7EQKUwv62ezMbyvkb/2nZL5ofD7CBeKsC19tGqHEjZevQW5u67AlhaFDwbsI1LN7OSrjsutZgxtr89oknE8L44o5Ad6RQ/WKFyTTn9VdNaeybEMd2z8ZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KfVnvk4DH29ak7JSGJjqNdP8YYeqxLAbyUmtvzxDcg=;
 b=oUabQ4Pt7JKrQOSnCmN2PlXuKrWmxJRdgIaJNGw44AkzJUwQ5cmibBFmbKCj3yWOLdcKxdvKQaaGoCeTz2/i3x8McwMowsnju98fkU1U50QPbwz1Y7IlY1/dv5R7/64m3v15YwvtZvA/lJe/a4O0t7MwJCheglNi81TSr/1TobC+pZ5wiT95/ZCuR1G4okwB6xerPo/bdeItps6Ha5P0hwsQeTXaigsSpaIBVsm3d4cWG0OcYFhrPhxb6zTmuWRSh1uBUrqYAcwYjFx5u6gTJclRwnmp5Sh1EMMrX7SmQsxa7dOZ++33Y7ZoQLCRh2OXA2vNLRp2CmB/auB7CzI7pA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT4PR01MB11964.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:169::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 15:22:05 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 15:22:05 +0000
Message-ID: <8c2b5e3c-0087-41fe-bcfe-d70c01059e5d@efficios.com>
Date: Mon, 9 Nov 2026 10:22:04 -0500
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
 <3e6677a8-b972-4081-a080-e925fe1df3b0@efficios.com>
 <avHiGH_4WBizEaBJ@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avHiGH_4WBizEaBJ@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0081.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::8) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT4PR01MB11964:EE_
X-MS-Office365-Filtering-Correlation-Id: bacfe6ae-e2ce-4d6c-dfb9-08df3e753671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|10067099003|4143699003|261028144727099003|261022105027099003|56012099006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	/13nxGbkjDgW/PCDIxNVWTV6lmRU1Cn2a5CfdiN26Ahqq0n+byw6KjGP1c2Y9H0r60aTodks6KGF9RMv5QdJgO//DMn/4sFlU03vwqLXwWp4qOVrAzklvXVgUHXZQXvdIEdaAtZ7gjUgBExFqj/8abqwuhLY1dLq+77kxWecC+wXNkR+WrpCLMTPtIfoem+8gljd9PTFLnJsGc+od10drQBxZX7Gk9CCtGOPEyoSWhev+v68nfT2fQ7S7QLNSVqoClI6gaF0NOQToFjH5Dauh2ovvGKKCAKbuxTYxcove9Qev3MQAX51PqskevL7qCkJSyPBD8zwOoEAofDFaiP2z+UgWO1KIbAm+ZVaJFODZ7ILq/38DFVbCUpQvQVAd+5UIsru006jaZiPJc2Df9RY0xr1ghZUzdR2TU6iLn5smgKDWpvt03IQJagrhF0rWFhu4SGpZdrmzIaRrxBlbJTLYVxMyXroT6fqG7tT2bgYdIBROfokKOoFAGL4pQJE29ilnHuhS4VEIWrFQAD2uVR57HQCufOO3hcmEHMhOKjsREm283sAl8LgQ2e38SCbMkhqYU1p4g96d0GBe/PHgtgauHxYxIflPJl983f6HwU9qGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(10067099003)(4143699003)(261028144727099003)(261022105027099003)(56012099006)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1MrMG92Y1VrdTNZanVqZExkZTFEOXg1Z0VkeWw2cDJFNnVCakgxQnZDbW1O?=
 =?utf-8?B?WlltY2tuR3loWG42Uit0V0VNNDRiQ1krc0k4ZCtZNTJXYThFTXgxTGJDUFZp?=
 =?utf-8?B?OVI2OTJMMHY2M0pMcVgvb3B1K2pvRnFsQU1xRFg1QjgxT2g5UUNWSWpTYndv?=
 =?utf-8?B?dVQrRElxQkI4OHZJL2dEZTF3anhOd1hERlVMWW41bWhibVF1eG1ybFJVdVlW?=
 =?utf-8?B?YlI4NzlDUXJZVnBZQTNFN0JJRC9XRFZpZXkxR1NrNkQvY2FTMlBHblZXOTho?=
 =?utf-8?B?VlRBZTJoWFRSQlZ1QmQvZWJaSkg0bzA2QUdDcnE5bG5xc3c3cDFvTUtnNUZH?=
 =?utf-8?B?NkxYY0YySk9yQm5ReFFuR2phTjRiK2xJM2RHQ3Zza1pralRqeUE3Zy8xSncx?=
 =?utf-8?B?OVhRQTRLYnFHVU80dXJTbyt4RVNJRGJ0YTR3ZVhMNUNjREYzYmtzVTMxK2RS?=
 =?utf-8?B?b1lKTFVvbW1SMjFZaTJiMkRaQWo1OWxBN2JrZStTZmtFcjc2OEtlNElNOE9i?=
 =?utf-8?B?d1V0bFVKdkJ6UlZmbzVpeEI1Z3FnZFhoRVlSZDNlWlZxQ09SRGNWbmlSM0hU?=
 =?utf-8?B?cDNvdVE4bkFxYUZvdm9LRnJTdkttUU5QOUVZYk1tSE5SWXp0bDY5citRNmgy?=
 =?utf-8?B?QVNjVkFJZzNXYlBBc1hkajVlQURRM1pKNFd0U1ZKQlZXYlBjT1BKaEVWeFBx?=
 =?utf-8?B?bjdRRjFRcnJ3QjE5UHcxYURrTDdNNENCNTNUVGpWL2ZuV3dHMGkzdW5XRjlm?=
 =?utf-8?B?NTlYcHVVZk41emdHc1h4NVJ4QVNiMWJaNE5HMVFXbGMybUQzR25rUUliZE1q?=
 =?utf-8?B?WVRtODlnVnZGWENqYVpJVFJ3a2NiblE2a01nQy9yaEg1cndmT1VTQkI4V1lj?=
 =?utf-8?B?VDJYR1VrY0VVVlB6ODI0V1dnZ3JvV3c0TkY0ZVRHb1hhOHlEVXNDaWI3d2Zr?=
 =?utf-8?B?a3dTcU5tWmpBVTVFdVZBcWRpajhFWTk3ZVk2b003UXM3dWNtZ0xrdmh4Mytt?=
 =?utf-8?B?UnFoMk84cEpTOGp6S05JNkFkdkxKZGpwbHpUWnc3dnBJeGN4VVJpRU5qVklr?=
 =?utf-8?B?dXgrSnM5ZXd4RjN3MmJJcEU0akhMZU1NRVkwdFZiODU4V2MwU1BjckFOZDhH?=
 =?utf-8?B?OVg4em1CRHl1Zkc3dDRNV09VenNCOEphQjdkQ3d1dWo1NDZER21Ec3RsRWhH?=
 =?utf-8?B?QUJxMmtQejNqSUYrbC8xbC9YWFZ1akx0bmVBaW1UQ05pT05QeFhKQXBybXBz?=
 =?utf-8?B?VGhKdW11S0Rwek1wVTZHV1d6b1lGdmhzQUpqYnV1TWYrNVVFdlJDMGc0VHZ1?=
 =?utf-8?B?VkFJT0RCSVgzS2l0Rm9VKzhqRDhiVmtzaDF0Um0vRmU1RDVncUM1K005ME5M?=
 =?utf-8?B?STlBQys4bEY4aW55UkJtbkpJZFdYVVI0ZGJ5VHBNbDJkblRQVEVjaU1INUpz?=
 =?utf-8?B?UzhydjlNWDAvZDRzbXlNck5OeXV3N1dGWmdqTDNxV3prRTU4VVVpa0Y4MCtu?=
 =?utf-8?B?cmFlQTVuVHhEem9JMjJwK1BhbUlobEZseXRNeFI5aXN6REFLbWJKS1RscUJ1?=
 =?utf-8?B?Um8zbXI1RDhGQW01ZmVTalB2KzdsTmRidklTTnVCQXJ5U2J4cXA2dm1HMFJi?=
 =?utf-8?B?aUdHK0JPRUg5eE80cnhqZDVBb25zWXNRbGtWM3BrTWhuT2NDczREdEYzQXJi?=
 =?utf-8?B?NDVYeE9UZzREaUFCbmpVZnJKVnJUbHZGVEpoRVdia0FtNGxoSmdqS0dmNktZ?=
 =?utf-8?B?YWwwZXRyb3QrMXYwNHd5d2sySk92V1hIQUlNRUlKS2MvenFvYnUzQUJQQy9Y?=
 =?utf-8?B?MlN3eVJGWnNrT3hCMUxIS3hNM1U0OXdva2Nra3JXV0hvN1luSGxnRzBsZWdC?=
 =?utf-8?B?Zy93VHAxaGZEeHVLczhJTGN4QXdQZ0lYaXpMbU1XTURCUEtlb1pDZ2RXQjN0?=
 =?utf-8?B?L201RmloZGYrWDJYbElzZDZnMHZOL2xyMWF2akhFeU5XTi9SN2FqVHdTS29N?=
 =?utf-8?B?Q3p5WGo2Tk4xeDVBelJ2c2k1dzMvejN4VEJ4U1BIQWlvaXFTdFA1VlZ2M1pB?=
 =?utf-8?B?dHdYdmNCeVBYeXpqalJxQUpvdnJlbzU0NjllS0thOGVTaXVxNUlaT2xCUzdZ?=
 =?utf-8?B?eDl2NEJrendPOXN6UnpkRmxZNUp1bCtGQnFpeHJpdUJINVo4UVZMOHozai9l?=
 =?utf-8?B?cUgvNjFOQTZkMEhBWjVYTEZZWDVocGdLVFlHcVBid1FTdzNyK3BIRG13Y1FY?=
 =?utf-8?B?S2c0TGI3REF3UEZiNTVadXhHSFY0SE9YWTdCSEcyc2tuY0NRenJsOTk2T3du?=
 =?utf-8?B?RlFSeU1kL241MWNpVThOa2JNZ1M3QXlMeWR2aFRHVzA1d1A5THdjYWNEQXY2?=
 =?utf-8?Q?h2rvSXpeGlRghcLs=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bacfe6ae-e2ce-4d6c-dfb9-08df3e753671
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 15:22:05.6539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WRo03JDHauUzGnr9fu2cqXjrn5r26XaC9Nc3gmBIgPTqDSsfiASHiaCc2j815kO28eAndsh5Zt2bJlkOiNrJFLzq+v+rL3K/XHWLe7I9JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB11964

On 2026-11-09 10:09, Juri Lelli wrote:
 > Hummm, I'm not sure we can say it fixes 4043f5498416, which was a
 > correct, but only incomplete, fix for d741f297bcea (which the second
 > hunk fixes properly).

Agreed. The debugfs patch will carry:

Fixes: d741f297bcea ("sched/fair: Fair server interface")

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
