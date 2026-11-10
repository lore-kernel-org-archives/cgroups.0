Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.87
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318074;
	b=k0JiNOs78pjlPXQCwgb+xczIdF3psaBToq+qWZXpTs4236eO74/jyv1GJE8JGIp6q3wN
	 tpJXoKZHZdOzFxkaMpXwNOVJh4Cs0aNOUufmKxw1uCdovf1RiSHZE33oop+FbXyEVF9Y3
	 toztYGaZE6aQLOg3en60pr0Ch+SyH9vsBpT0v/LrhLvKk5cC29mp84ec/vV6i5SnPRxmn
	 395yPalNWOYxpj6/Ap8UnD/UFq7O+TMY31GdZeTG6Y5BO+s/KKlLzAHMll8JeXvSvnUIh
	 5yuJz9rpsuq/RRwgQ3aMgwAdvSnxvKS6D6uoQ9uBBSzPBimX53bIjNK0kk3oT/2zobw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318074;
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
	bh=HGDMXE+d5D8lVIZsA2mJeMgP2VFVsZbVUDF9v6qfVYU=;
	b=SeSizE4bI/zJeFXKV4yL9Zk9AZ3s24gIzMMBfd3gGldEBvEpO87kI2WDzDsFOT1lqSAG
	 uNiD592Ye7bvC0s+JtPLqxQmBlziQ9PesIKMlCbhMbkpkPi8kDqjzJyrcBRPCVStyP5M9
	 SgANd+vAFe5rikPcvyrK/FHnVWx1thwPU6dZw2h34SfGZhP35a+PuZ7yP7VKrUuWhGRvb
	 aQszu0WYFvjdfaPP4aFI3LQU9YLDfR19vcBMPelkSW9E2+iRU+2yGH9X1NjqxN1EnSNUf
	 uAkw16yTeVohQsDVWbtZV/XW40MF1r1gLv02vCgRW42yae4Pzo7jZSNMkP53gVjYENQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=sT7VLQem;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.189.87
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020087.outbound.protection.outlook.com [52.101.189.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A7606A330;
	Tue, 10 Nov 2026 13:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 893A7606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=sT7VLQem
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eypw9q/sxultSbH76QYJWJodvGj6kOrS6eUXIKrRa5BLl/skjU7UNbapCUTCUf5Ijuf5LNe6uzSzcBo173xoQ1jZ+QPNrCEQXc8wUFZhNxxdkmSS7rQ4UBAz5f3MIv1YCD+e786lYHt8v1PwfUBGcGgKTt3/Qvrzb7zFeixSN7Wd9K0SG1+mIIj3coPq+MowKrQ8UcWHSw1F58oSp9bsln/T8J/F9R6bQfd3OxbZawOZecv1j0zOSxtjmTCsXGWjGxEggzs0Vbtt71Xi0eFe75Dx3RZHFQh95QuImVrLg8gpJwl97zL11efw1IUItGNeS3CE4Ln5WLuK4r3Gl008Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGDMXE+d5D8lVIZsA2mJeMgP2VFVsZbVUDF9v6qfVYU=;
 b=yrwJZJtJ29kq9+5ed0ehIOd8XScNBrhNBQT+LSS+erUgbpCMoq8yBe/fRgbG1xGyA1BVMq4x42GVhOvQgjN7bGl6eaI5ODP7ruQFck1qVeRcP7Ub0RmH9u/mocl81g5EFA04TiP/kkqTWITPpRJut7V2JXhBR8zCtepZwIUb8+z9Rcx4WPK9LIYA3CsZ6ridcm0u9sFPVyMhBm8y5vAVdICuOfeDKUQ/53V5LK1MdwfKvzmDE3PPWMO4nu5WdAAcWp4KvncMJhTKuHc6ngtsFPvzleuNFNKmuv2BmlHJ9/8WNSGh5s3qtCAcfMSIialnSvTvtDhmpbvxSxfvDbVbfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGDMXE+d5D8lVIZsA2mJeMgP2VFVsZbVUDF9v6qfVYU=;
 b=sT7VLQeml+2XW1z/395q8F6iJ5VPKy5i9iUeOloNSHKo7m6wOLoU5s2LeQKWpCS8DPX7DuyMdUkbJMZgRzZ10aYdUa5fQcbatLin9r8YpAOZ+ItnPHwcbCMAgT/w2v/eiJdiuHwGwR1xDZ2MiMVhnirVylu9/4QnaAsz7STU9vJxf0PQpHPS7OGzwuk5dE9A40f82ALUZJSCY4JQjUpR9AaNTO2rxczfuO+s9dwrC96Mmrd+9rTXjJ0TbfSSI0fTD1m/EDgATZuzQkbgvSRvo13BOrTTGte2Yq6VnJNjcBokXu7+16kdVQQfMIUBpiybS1yXuBqnxq3z563Vk1hzqg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQ1PR01MB994322.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:103::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:41:09 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 13:41:09 +0000
Message-ID: <2b872bff-0907-4a65-8347-85194eb457dd@efficios.com>
Date: Tue, 10 Nov 2026 08:41:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/29] sched/deadline: Reset the deadline and the
 runtime with the parameters
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
 <20261108185406.1549770-10-mathieu.desnoyers@efficios.com>
 <avMZvuEdV8ua36jy@jlelli-thinkpadt14gen4.remote.csb>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <avMZvuEdV8ua36jy@jlelli-thinkpadt14gen4.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::13) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQ1PR01MB994322:EE_
X-MS-Office365-Filtering-Correlation-Id: 653fd9a0-37fd-42bf-0ee3-08df3f30470c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|4143699003|56012099006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	t2ZldUn8DQ12x+WuFEjwssDlHP9eofvxo7z+/eQ8z4eOrGCk73HBAVv2Kv3HZ8MapH9fUNpm4wHkGC0FvxY5vl6wSMhhyJwHZ/Z4wK5AtEJI3tacK2kpKw7BNv0KzYtQE7nyRphixsipUwJVEgsFoEruSDq4bEUfAkgoXoSf6BfxIhZEAtcExen/yGe6SDfZh9PB3kpDU9V5AYXyT97AzjzaFw/T1yJRfHQgcvJsT2EEhW2varv1Uv3iscM5uXfUcoG+v3I19H/kLge3lDTnRYMLjtJu9cvay1p82T1fWrFpxJ90WByvwbnqYqypKaRQHFH69UrmJfRbohKIBBst2VtL/KNc1RbYaXw0xhpcn3mr+m6xypi7WOmnwhdZ2Jt3PsyroOyf4O7JILBKl2rr/NTkZYvKpMZEr81L/G07zXcfuevYxSSDlhLkx8QstvdhnDNuW8iHwjml2Jb2llOS/kKAmxgNoyn3BlJ0yd/ZN6ErcnlkH3xtZU9dim3U4J1WxXW+CqjOfHhsmSeGY+tobV6QWS42VFZ2WATI2Wz+aM33wgwLfzomUfD58VXcnitZOpflqKYnMG2y6VuAFZTr+ShwQq8paPCZ2jejigIJRb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGRxLzh4OHJoUzF5aXovYUlpcVpNOGYxVTFxL3g3UmxYb1dVVVhoWWRPcHhS?=
 =?utf-8?B?M3RCcHR6ZEppWndxVEQvMlgxcHFyM05pditsMmN0SlRDL2kxTzZPMVZzV1hs?=
 =?utf-8?B?NWU1UjVGeWRHeGY2SkVkb3hYYlpMRUNFY3FQNkNjQ0VtRlRnL0RTUnhtRWZh?=
 =?utf-8?B?L05oQkNQTFc1aFBKQy95ZU1QcHRWVDM1bHJySmJKNHF1VlBlNjhLeWRodXVz?=
 =?utf-8?B?cFVPbXVHSDE3WDFUSHhXNkh6R0VNTFEwL1JXRjdaYVdtYTNRcWZFWWVqdXBo?=
 =?utf-8?B?aGNCaWs3eExZeXdPS3FsNUU2V3FoOWlZTmNnVXVyeUFsaWdoRHFNaHJmbnQx?=
 =?utf-8?B?a2tZbE5FckpsaGFZUjNIYWMwek5oY0NjZElZMmVKT0l0bnZHSFVlblYxRmhl?=
 =?utf-8?B?SjhFelozM0xzenBEMC9YZXpGUDlBY0JsWmtSN0lYT2crUzN6eTRTR2l3TnBE?=
 =?utf-8?B?THh5K1ZhZGlnRUVyMkNlWDJOYVF2bURnTWh3N0VlTWFBUHh2N1RSc21hdGds?=
 =?utf-8?B?VWFZL2JFL0piRkc4eGJJb1l3MFJqSmlsT0FGdEU3OWNhc3Z2aTNhOFd4UGoy?=
 =?utf-8?B?QVhqQU94VDl1UUJyMCt5K01sL3NxeUIydlA4Y1ZhQm9MTElmdUllVlRqaGJM?=
 =?utf-8?B?SStFRkVmN3RYdU0zdmMxWllWNUl1TEw2SDkyVFJpVVg4YXBGZEpkUXNWVGw2?=
 =?utf-8?B?MGtJaWk5c3FSRktIVHZ2TUhidEJHRDRhZXZTaUpoTEFkZDFVOXg1SWpzQkRV?=
 =?utf-8?B?SThvQnI0aWVlcjV1S2J0eE5pREpCVkw5bFBlUGhiVW5XZVpqSUhYT1pkbW9K?=
 =?utf-8?B?eHpGMis3N3pLQkk4NjZ4d3piZnRmbmMrS1p0QUozZ2JCV0Y4VDF5QjZ5Q1N2?=
 =?utf-8?B?a01WMWNYZjQra0V1V1loMVBURTQweUVkR1ZlK0dFcUdIN3JvaFlodDhwOVNl?=
 =?utf-8?B?Q3lsM2k3akdCdjUzcmlEWEEvenpzQXkzK3ovM1pqQ0ZDN2lNdHRhSjVGbFJQ?=
 =?utf-8?B?UTFEaTFIcTA0UUsrTFFxMXdzU0FVT0hMeXF0MGtJZWl0WmVxZUVEQk0rRXAr?=
 =?utf-8?B?RFM1VGlTM0dpYTZhRU44RGFRcGo1aEpaUktxYnR2SndyTUJpU3BmdDVROTdF?=
 =?utf-8?B?MUhZaTNienQ4UU8xQUJuVklYM09DdU1oUTlTQ0pJeERDbVdtOWJOUURSaENv?=
 =?utf-8?B?VGdSaHJrRGVBVm16bDB5dU9RUEFkMUNSU2xHaWNUWGIrZ05SOGtPMXR4eERN?=
 =?utf-8?B?YUUrM0ZCVFl0VC9lanFzUENrcHM0Zzh0NXNhVE9xR04yZEIwbWRaV2hTZXEx?=
 =?utf-8?B?ZFlwZzhGd3NOS1hheHJsd1l4MkVDMkc4TVI3S2poV0FOYXh0RFFIUmRheFFs?=
 =?utf-8?B?Y1lWL1lyeVNNdWo2T2hlWmdYU1JKZTdIcTNEek9Jc3JGelhNNnp6Qk1VZHE0?=
 =?utf-8?B?ZnZ2YVFpWVQ5d0VUYWNuSzF4N0dqWGFkd3dwUlNSM0x0U0E5OG9BNlhvZk5X?=
 =?utf-8?B?Mkh5WWpCR3hkbHdKRVZMejlycXZtR2g1US9aOGZtN2FvVkVhemZDR1FSL1JP?=
 =?utf-8?B?Ty9FZlJpSytua1MyQ2RFYjFTMjBkalZrRk9ESWw2ODMwK1B2U1l2bkl0dkxr?=
 =?utf-8?B?Mkg1TGtab1YySTBZYzdQd2xOcVY1bGpQUERyd2diT01JWFBJUmJLQk5TS2lM?=
 =?utf-8?B?d2ZHdG0rUis5NDZPcEVnUFFRNVpnNndrd1l1RXZyYXRXdEU5VlNOK1oxZXNG?=
 =?utf-8?B?d2t2K28vYVhFWE5yT0RaNmVNbzVYbit0Q1Q4UTJCVzRNdk5YZ0x2a0RjLytk?=
 =?utf-8?B?c3RzbmJYVmIvTHBXYm56NGxNR0RNbSthcnFLQmVBaUVqbnFRSndhSU5QZzR6?=
 =?utf-8?B?SkZHQk8zRnpzUk5CWVN5alFOQTU3L0RIVWxyVmhhV0V0UU1rRm5HUDNDVHZC?=
 =?utf-8?B?UlBoaGsrWmZUczVCYVYzRVg2UFBzdUtvN2VOTGFobWpYUFVnY01iR2VWYjg2?=
 =?utf-8?B?eWVtWURTdSsyaGlpcXhxZU1mRzBxS1JVUER0YTNpYjdlQ2p5Z3E1ZkJ4UmlC?=
 =?utf-8?B?TGIvbjRsVXdBSWhZMmc0YjMxdXo1QWdQNnZSK2lPN0pJTmxZdVhsbjJ5bUZp?=
 =?utf-8?B?STFrYkN3TXdUN053NTZaeWRzLzl0MWtKZDV5V3NmSnZrVHkyQnQ3aXpxL0tX?=
 =?utf-8?B?cU55MnpTOU5qZkVDL2xxTDltZEJQR1ZRNWpVOVowdmNhYjVPdXJFeTk4ajJU?=
 =?utf-8?B?ekMzMEFJVENwdVpUNkNGdk0xbGw0NzRQWlNkSHJjKzJ5bFdoQmxLK2tpc2hT?=
 =?utf-8?B?MnJZNndrL1BjZTBva0RUa3FMMDltOVdVbVN4OGcrMnhFdlpWVzFFSnh5TEhl?=
 =?utf-8?Q?XuqqJgKmilnZaziYAg1NXNLHqohigD8/Xpt9q?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653fd9a0-37fd-42bf-0ee3-08df3f30470c
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:41:09.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NADg0mdiCkOmH+Vp6I39AZMB0Jo1lod1AKmiTnPMgTYVnGqFbM+oPOtNapePw+ntQZ/YEa50JrBqsGoncAhVG/GeQ+orcek5ichOydIMn8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQ1PR01MB994322

On 2026-11-10 08:18, Juri Lelli wrote:
[...]
> Nit below, other than that
>
> Acked-by: Juri Lelli <juri.lelli@redhat.com>
[...]
>> @@ -3999,6 +4009,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
>
> Think we want to update the comment that comes with this function (as it
> now clears also dynamic parameters).

Good point. v6 will say that it also resets the deadline and the runtime.

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com
