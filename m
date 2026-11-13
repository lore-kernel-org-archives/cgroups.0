Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.138
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794576908;
	b=WxYgGRvl042pnuutLS99x8nCg+piL3Eq0x1hPedGxufNN1LtsbQr6FUJ1NxpVZbFG1JD
	 7CgKapRVHcdWydypc+rADBiCc6ZXgzwSVDWy96LGWJu5/4drFpU0vapwaZEsS+vGp0Jy2
	 tVsfwuUq9G7gLIKqkMhmrQ/MLoSoQzZaSkTFixtR9Y4p93dmceLgRjMCvDJ5nD1XmPt1D
	 JF4yZlL0rzmjJLv25JWdg2X890CAUAYEsRWAj2qnACn6n5/zMqFzPGklC7OSw3L1W1MOJ
	 yJo/j+WRD8uzwcfuiFNybtiOMPT6PkdVupSjeSpi7JfPs/PE2BZZSPqKeJYxUZkeQGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794576908;
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
	bh=Nm5coykfNY7V8Iddv5XaeP0NNH2xzhGeEZyhDrKL0B8=;
	b=YOEyl8IlDXeFErAIfxS5D62cGtW3flnuFmLSy3XRsqZVTKXHqBnHA0M7txKD5xvqqIlU
	 xyOJOk1+pjLhNRZ+zqV4y5YfeVoP5orotwZ4PA3r4YQG56TZpPsSkaO1dFRgGbThkYyTk
	 CitgNAY3WlHxjE4t2OzQetX+Yns/BzMk91n+3G10CVr0mXIfjPYIGrfSkkyIrW2+1CzEc
	 CNsLr4XbF99pZcXLKiljrfQWZrgUM74dp35PiCilxRrnY5lsKb6vdfca8FRBeVoNazFiS
	 tZHFEPOTEr3cV8Lli401AVjM+ixXHbCebBwDGUVaF5pvd52LlEua7ejBVvjY0Q1Wjdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=PUnr3Tzh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.193.138
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022138.outbound.protection.outlook.com [40.107.193.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A31606A33D;
	Fri, 13 Nov 2026 13:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A31606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=PUnr3Tzh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbR+CXWsan43jRUU7otdi49tNprZl8k+uFkuFnhCtSq4Fw1w+61jAZJ4t8rBDIiW79X7APvOO9S6Yy1cWghXu2MkvM6jbM4aI8FIUjLTE6C4cVMjUZj33NDaxoLZ4I/cVE4B/43j9OALcjBqRScUI25+3UYoXxA+acGLAXyv5yOufoD1vpe5mB7RsgGYxPaCd73BOsHvQY7p77Q608nAwHbyaqA0PMj6YhPr2NtpOrHrFiGUYMByf7dkOKrYqc+zRxNgquUZgfmb76lSZTXrFAb0AVnVsIcu4gt2Tztk3tHp4GA2EBCPjATLHKa8Yi9NfvKQoQ21b0EzrWfIhRrggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm5coykfNY7V8Iddv5XaeP0NNH2xzhGeEZyhDrKL0B8=;
 b=srBrVIUV5GZOlJ+YghOS2S7dbVDRLbXzGJZikzYnlDlwC3T29odkz8B1SRvtUd16WcIDReGaRzsmeU2CTQmTUvPWBqbF4YpXuTJA+1xwOhkkGnc70sbuBL4V+ppEUon5VZpXj7SbPdPEmVkdgYEi1tpaGQuJlqpY3d0ahU3dz8imkYYmW2PperYArUNOzMkVyZxGG/NV/gYUJtng2JbeH4hdLgglKqWZUBID8p7QHauYzEApt9jP4592WAwKnzkNbWhtF8CoWW15lyfPoTlOhz2ROMowldMqwKbpBEgX1IqbGMcoGHYbKVdhXsF08CSJAgyWVufQfW+tYiLdqQYbyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm5coykfNY7V8Iddv5XaeP0NNH2xzhGeEZyhDrKL0B8=;
 b=PUnr3Tzh5Rg83peqGKv3lwIbCiuAzFm4oekM5ZIusES4MvsZ8m5MB930qp/XDMuiE80NyCoUT/ljKDLXUCw4vBTBUwHPxlhhXPeDD1qwPn26bC+y0MeOQG9MBpWeYb+0GYQtN+bJ2FyKW02Oq+CRQedo/4/zpRZLut6OcX0wm9mcaoDUsONTX86WF9A1yb8F3phueqojcVy5+vnaLVTbf0hMVm8blrCn4rxscqSdLj7ZEc+xmZBX2MAWGUkb3irPv64BA0r9ii+laY8wMRzCBy9b4EiFSLmX2FIeR0joKk7P43n36JUBRi1no8OwCSyIK47S2T+q/p2N52EvEH17RQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR0101MB5750.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:39::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 13:35:04 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 13:35:04 +0000
Message-ID: <d58e067d-05ae-4e4d-9d34-b0ac2741b211@efficios.com>
Date: Fri, 13 Nov 2026 08:35:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only
 where room was made
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
 <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
 <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avVk0UU8IRGoo77v@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::22) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR0101MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: cd4dc169-ebea-4647-60e2-08df418aecf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|56012099006|10067099003|4143699003|261022105027099003|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	HAZS4p2yLuS6DGL+JnJNrN+ynp/V9Qti9Ymw45ZrdzdeZvyYn8qcY+kxMdRQ7KcsYOtkBbbSDSM7ezAZhLNky++xrpMksjVzWgTXx/EqzPsn0pVtugCDSn50ExKFVPXBVn9Pcqr85gLGxh2li0Xa44OKOjSUqk2yCSsbMoam2U50+O7x3dt5nYRRLkPusag/W9Vc6Ji21PJmMLNgED0gBD9/8QqeZQta08zoYR6OUoVXg9eZrgNO8iGLBa10Bz46i/vvhM3M9bDrwAxthOFf8YfxoVZiWbqjdVTzb/GBTSBlwZjYV6SK+FsKGZAW7dvJW/fq83UbQ3ghCzv5K3bSKyNEMuI0bk1JY0DFHJLQwju50/N7vrcEc0BmBaLS/KMYMTTmDZLvfAgT8Jx90Ht99ooN1qSrl7tdZp0EcBpsDWh1Jg8BrQWat2oLJbU9IU4AVDfuyvxuWa56y3Cwa2teqp37ZmQqGRQijLSVhO8sPBOSpWufeUo5O3dMk1CEiIf4CQ8EeMXcY3lNtKJwQij5nmpHDjrdgZzdfqcMWgR68usRWWNzPryr+EYoMPw36j7Ih/czAIappasAWg9m8uvjcgyVG98FHYskxX5WDyuKjUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WW0xRCtNSHBFOW9NdjRNRWIyeU4xYVhBMmFheFVKeUk0Uzl3UEJrbXNCcS8x?=
 =?utf-8?B?anlJTEdGb0ZldHJrZjhrVmJVSzE4dFdoazA4K2NDRFRuUXByZVloU2JMZzFP?=
 =?utf-8?B?ZDNmSEZUbW5BSGNyVjJHTFVVK3dieVpLQXBVd0lUU3Fqbys1aHRaWGxNZERx?=
 =?utf-8?B?WDZ5Vm1rTFdBN2ZwYWtWQWhER2huTUp3NXBkVVI2RzRaNzlWRURxUDRqSEJ4?=
 =?utf-8?B?R1dMTTBzSytmNkNidThmSU1DNktnRi9PWS9DUkx2K2lMTG8zZ3NXekVnaEtk?=
 =?utf-8?B?MTR3WnQ2SDN0Q3FxaUNGRG1FMkVuc1JOV0lDL2RycGErZXEyVUFDNmlxN2M0?=
 =?utf-8?B?V21nTnhMejNZSHcveU9ieDYweEJ5YUIybFRmbjg0bUlHZ1ZwNjVtUmoxelRP?=
 =?utf-8?B?dXRXMmt0OEhOT0FtZ25MelFweEhuWkhuS2E3Ykg5S1JXNkJMbUUrTGlaS1BE?=
 =?utf-8?B?L255MGg2UGMwRzJxUW11OUwvUktqdHBLdi9DTk5lR1RqVUNaeFdTT2dVWTNF?=
 =?utf-8?B?OFJROHVOcmxtZUdrZjZzNnZwMlowVlArWlNCcm1TcE9aUTBId3V2bGlZcytP?=
 =?utf-8?B?RFJ3K1JKdWZOVEo4VjZPZ0dndzBFVVU4OEJFNisvUG1pTkZFSXlUVU9MOU5E?=
 =?utf-8?B?MkJXeXN2K1F1THJrbGhFM253a3pqUk5hZ1E2ZUF4ekk0L2t3ZkRtbklvRUN3?=
 =?utf-8?B?dWNQSUJuWDRYeklGQTkrRlhZb3RieU81SnJuL1pMTE5hZUFyWlEzWWo3Mjk2?=
 =?utf-8?B?WXA0TkZUZnRIT3ovd1habW12TGEvcXVDQ1Y0ZVpDQm1HemJUQTM2WEZZbDRy?=
 =?utf-8?B?dGhVakIyVHI4RW9veXYxNjdkN3c4K29wVisySzZ6Y0h1NlkreTNYb2xzY1Zn?=
 =?utf-8?B?K3MzbDNpWm5hbTNxWWVRSmVvNFdicnJ5K2xXanJyOWRlakRmM1JKTFpQd3B1?=
 =?utf-8?B?a2xpK1Vwb3hSMEZqSmx1TFZscWQ0WnBscE1yVlVkNUJZT3FJcElRcDUwRHhB?=
 =?utf-8?B?QnZSSDZ2emZmeFVQcCtZdkR0UWdtY2VlNFMyWHZydlpmamYxcTg2dmQvUHNR?=
 =?utf-8?B?K0ZwajZpUnFINHNqWVNwcmpSNEp4d3JjTFEwdm1qOTlJTkt6aHpsQ3IyRjBr?=
 =?utf-8?B?YklENW5VS2RmRFFBTlJpSFFPa0tSMWZZR0x2RDQ4OXo1aVVZWkFDWXEwM3NG?=
 =?utf-8?B?cFVpWFhBQ1BrTHVWQjJYb25jRWswY0dzZ2Z1OFdYNG5KdkZZUlRvRzRGeHlU?=
 =?utf-8?B?cEo4NHVadmlONHl1QWlHak0rN0IxajlLbkxzVFEwSHB5MklYUWNReUx1ZnVS?=
 =?utf-8?B?Z25nR21ENzN6STkrMVFSczBrRWJ4WUNvWmZNbnhqZHNmZkl2aWtSZDlvdGhS?=
 =?utf-8?B?eGQ3SXAva3h6alFyN3Joa202dlZsM2VDalVrdHZ1RUYrb0pacFBiZWlGbDhZ?=
 =?utf-8?B?bURMaEVLZE90dC9Wb1hSd3Y1TUlWcVZXeUUzcmx4UENWWGFZTnM1elpuUjVE?=
 =?utf-8?B?dk5PTTlTSkd0OS9UbVZSZTV0WVNvUmVhT1RhMXl5bHlPb1RMeDN5MDZxbXoy?=
 =?utf-8?B?cWtsd2JHQ1hyL0VQNzdveUxmVXRjNjFHWk9jRmhNbEVBaVNOTGRWZEl0bFlC?=
 =?utf-8?B?STZpK00xSUxQSjVkRzd4Rm5md25hOG50RjVvVnVtS1BXeGEybEpRbVhUTzV3?=
 =?utf-8?B?dTJZOEpQNldyY0QvMjdCUDFkdis4MlFIUWZxcG9vN3VOYkptYmh3cVFSWGMv?=
 =?utf-8?B?VktkN1Nyc3NSZCtaNGFYbUJKWVZvK1FiQk1TSmc1d3F0VER3TDNkcUdncHQx?=
 =?utf-8?B?RVY3TUlyc2RoS2NpVkgrTVkrUE15dEMxWWhERmZtNndReXRvVlU1OFhkS1gz?=
 =?utf-8?B?UWNsczdLeDZRbXZjMUFkaGp6eUNDWmdHQ3JGNURLMkxwSnpqc3N3cC9TTkJK?=
 =?utf-8?B?T0JBTE5POWg1QTIxSnVWM0VGSVVPVGdzb2ZzMFpOVDBQK2xRVmlJbGFyQ2xC?=
 =?utf-8?B?QWsyT1Vmd1RpSlBmNHB3U2hjYXpHeHNEWDZHZFV2a0lmSEh1RUlNME1xVlVl?=
 =?utf-8?B?NnFvdzdsRDBOUXRIWkhxUTA5MWN2SXBTYmI2dzB4ZEJLV0RNbW42dTM1Q2JN?=
 =?utf-8?B?V3B2RnoyNDFiSzhodjA2azRmZXplKzdtN0p2RG12eVkzakZoaEVWSkh1K2pS?=
 =?utf-8?B?M3EvZC9nZjVoYmRxMFFEU1NzUnZmK2FGWXZLeVV4cUJpelFocnM4MTdwY2hk?=
 =?utf-8?B?U0dWUGo5NUJ6SE56VGpRQXJleVphZC9LZVlFbGkwYmo1Vk5rS0tpWU9FdDVk?=
 =?utf-8?B?TVNFdXFnVE4xNWNobHpaV0ZIVURYZ2tpS1BPVHN2eFpYY2h1TlpVVlFWWG5L?=
 =?utf-8?Q?W4ksL8xNocfoy4P4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4dc169-ebea-4647-60e2-08df418aecf6
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 13:35:04.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZjyw9/94vUAYiNVzIzfWU/dDSKVKbpuY2hVGSu6CfwQnpqcQPhCBxZ4b0dWi0VidBBW/Er5MnkwnQQeaqWo8VsQU8poe5AY+lna2gl3W7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5750

Hi Juri,

> > +/* The caller made room for the deadline bandwidth in the new root domain. */
> > +#define SCA_DL_BW_RESERVED 0x20
>
> Why not 0x10?

No reason. 0x10 is free. The planned next version uses it.

> Also, nit, the comment looks off compared to the other flags w/o
> comments. But maybe they just need to gain comments (I keep forgetting
> what SCA stands for - Set CPUs Allowed, maybe? :).

I would keep the comment: the name alone does not say who reserved
what. I left the other flags alone, since this series does not touch
them.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
