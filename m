Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.87
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795206268;
	b=s7qkvylmSJ74/QGvr6yw7NDPv3vYK4wcmhG1+oPiB6OUkT6SJnziF0gfORylUe75ETAg
	 o/PEoM41NEwyMBRgvULj6DT95N9mlZTvXX7cPla00H8EjAAW6DtECWt0ue1lWkFaF13q8
	 lFbGNFjhDRt+9eNp3KhaSmZxtj0oD3SdAWSGIk565Dl0BHamrCOk5/iEvRe958S0QaDFP
	 QwljiLuV6e286SZTefQL0ce50cet5DpcqYD38U5uK666wmN+ZCm1pWUo43uruZcdu6vDD
	 +X7e63SyQJZaw/ikTnVl0zlnZ8XFCD21E//5QQ7fvDLTEC7KjnNkC/gdLt4vJ0/mEtQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206268;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=rejuP5G/7BXNtLkXL5eNFryH3qC5R/36dIdOsD2VEmQ=;
	b=PLmsGHl0GveDajdRgV+vb8WWCjwl+Uext36LKmSL7Pjyv0PmiEHpxszia13EZhUSRhCP
	 Ma+1rahOsLsJxTjPtHbDZ817993AB1MA8+QuM2syrvR8wibTDf6+GMAnKLhjQyQnF1l+8
	 QMynzGJEMT8KrIDsb0S0oxtecVZGCwSbNKDst6cenro5Q3ny1YxWJ/Ps21nwfMZ+m38uf
	 i5L0plH65a7qqfMsQAcEFUTO0I4xOet1j92+FUgRzQf501Z4/alQZPeI4odPXCajLjB+H
	 1SxUnPnFAjCWy7LjveIlexnqbRM9E3qVwjsVvxPQbpsUMufwtYHCfvYSRDttmsykaMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=nRFIFkPV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.87
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021087.outbound.protection.outlook.com [40.107.130.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EF0606A6D6;
	Fri, 20 Nov 2026 20:24:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65EF0606A6D6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=nRFIFkPV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PT44oRyr/jG9eMDCINxUvupTgQT/FBAxp3N8uL/3Ubi+yWHlm7eBmX22JUItJvadQiEBjZQrTTFW0z0HmfH094u+kICFc9R61+s+2TvYgeclEuKKbfr+DaGM0Chz1heZpW0GC/Wq0ePxtFmmzQtoqOeKN8AaUuVK/2fzCGXTLP9bpR6/o7bAjW0X4LiEnIIy+I5iGlyMQEcEFTV1ZYPMNRvuaJZHylFinSX9TQnCjtShEOn9zGojQ236SJgdTEVvdljzZpubJQxy0j311LDHFi2IpOsl7CGXcJD9zb3HIMYYf2m+NO4i6HR+jOV/aLna4KiOvfe4MPtkgB8CzlrW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rejuP5G/7BXNtLkXL5eNFryH3qC5R/36dIdOsD2VEmQ=;
 b=fy3hJCgUBmMgygeB/OcM22NEFLxKuU+Lt+FN1kr5C65B7ZB+odLRhz3FTUpJAM4WKJboP8Bp8CLRbqNObltSk4rlxi7/tEXuvOL8KaVGVCtlMfbgMGngSAO+/zG/BJmh7olTXwH5vTfMxYicLAI5LtzbK6IbRmuegoaPNgMCpS3jh7qCH/KuHww9IQn27jcQ0vYz8qnJ+x+pvXNHO4RSH1pmfBDVuLZzVq/AGOpNQcrQNnuQ6SqCr3wThSyou5RWtIQdf1iKBbnc4dp+EQcQjXJ+PAflUdOdmIAqveQEvJhOtjafpc8BgS30BC2dJDMvbebwCUrPeJKo61BfQx9M6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rejuP5G/7BXNtLkXL5eNFryH3qC5R/36dIdOsD2VEmQ=;
 b=nRFIFkPVEhfnSNPMSE3SWxNEv9MyKQAgKlgzXopbqOBTVxmBQxFBVBqExk1xCmKwUnNZYCsHkfxcPzqXzX6GicDqKShckHgFBYXfFVFPtS+vQbWmcBWfl68qzykFIfbk9CA5u/ASFRo3sLQi9/gCC3t8/aWPWMw1/U2bSivpou4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by DB9PR03MB7644.eurprd03.prod.outlook.com (2603:10a6:10:2c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 20:24:21 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 20:24:21 +0000
Date: Fri, 20 Nov 2026 21:24:18 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Tejun Heo <tj@kernel.org>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
 cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org,
 juri.lelli@redhat.com, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
 mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org,
 vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261120212418.10221f2e@linux.fritz.box>
In-Reply-To: <6fef47e08a37079c08806b3c57994778@kernel.org>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI1P293CA0019.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::16) To PAVPR03MB8969.eurprd03.prod.outlook.com
 (2603:10a6:102:32e::7)
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|DB9PR03MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a4a842-9788-4ea6-f3ac-08df47444272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|786006|1800799024|366016|7416014|10070799003|23010399003|261026121527099003|10067099003|4143699003|5023799004|56012099006|261022105027099003|261021121427099003|261026140227099003|261022075727099003|261102123227099003|261028144727099003|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Qycn+zjGQVhpBP0QoKRQlXcXmMTuEB0eaU68lkHhm+vjY/0R1OYM2dnYYAVVAnlPUC9RrLkIhkgFwYfqlvqlDHDfDMKFR0aieTmR0jrz+mnz/DHgWg3fYfcvFSeIAHNi7+sEKDyk8Ea3OvVGC60LwccwWqCqbxMa5bMIjGqxjLM9GSzbD0rgZ9PB+VmVtyMdIswifh+jcJowQutPjwJYJzqSlx9HC/mwvxjfN4IfIfrHN00hMeKgaW086Zr09PFDgjRvfQwPvpGjp+WUj+JWFgxgZE3SWjDq9XLNjI+qvRBY2/CKoCdrKIuBcoYeHcLbhYbw/ZWsJT3EsYml8B0Sl0aeTrlC4Tim48E3j6smNhm4Ww89KKMKOAhjnmy8WekesHu+Gn6XtQOd4pIid/du+oFoAikKAJAQmq8L9QUbqatiTYBgSmAlOJefHCIH5TTD8IVW7qNloRDfA224TErBjyr82k9/q00w7UyTcBlvq4/e/bGBru5snPLKYTB43YMoU91/fq7/iv/b6dyE9sDcSlQfyc3CG4wjG/VvkUkgWzp9JnxW6Iom54dXlfIuriosqr5kcciy0gPGEzbqULeQ3GtPH/gb/D3hEgrG40GrAudll2853v7zG8AUa6BytZJEwV/EI3yPxyGTCtB8trmY/84mlHXW+vqcRtFIjEUuyLw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(786006)(1800799024)(366016)(7416014)(10070799003)(23010399003)(261026121527099003)(10067099003)(4143699003)(5023799004)(56012099006)(261022105027099003)(261021121427099003)(261026140227099003)(261022075727099003)(261102123227099003)(261028144727099003)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z6cg5Tu+wY8L9Ikvr0A1BdZlCKVKvKoMgpuPxkmwKRbA5WisRx3XyEQLTI+9?=
 =?us-ascii?Q?7VofHibkPIUQzpZu/AKcG+MVJ2ppUI/9YABIK6XnGLa3oJF7vs+tCX6I4LAW?=
 =?us-ascii?Q?T2bnFoXgPBu9Z1VKdZVlAIOZdMdGWOBOKKp+twWjTt1Hdy6ep9+2V+rBaCvP?=
 =?us-ascii?Q?VNjVEzkbPPOfSlW9MdmXQ3hJCK6uUO8W0sTerSSaBpZ6dtCryuKxKHa6AX1b?=
 =?us-ascii?Q?Gylt8gWTA7Mi2HRePnK/flMGfHFVXqQwAtCVVJuTyAqVgaYjsacFO6WgFsDX?=
 =?us-ascii?Q?+ntcP62EkEsf7t76sS0DiYFDcWjqIZqRmDOsoJ5ixGfM9VmTi04usJcxcDhN?=
 =?us-ascii?Q?aNj4MoAPHAb7aSUFBQJAjsORe95WF0Me4iMOc6gnkoXedBkP/lc7ZMkzzHEJ?=
 =?us-ascii?Q?AAWUXudWJaAp/Gjr1cFEObzd9jqMl2z5+YvBrG1juXVh0MKvOL7dtsA66rPj?=
 =?us-ascii?Q?0ncPJCx0A2bEI8JcRMb0N0JP3yynk9Kf3K07MxLrf26zH/CmRH0/zyYNaDxP?=
 =?us-ascii?Q?++rSkFxoCSeMnZD3dZH5iMiJ914FpBO17zlpDBK2cfPVLE/hnM7loux1iHbE?=
 =?us-ascii?Q?3xr88Q0zHl2RtpP07kg1tgCZFGuX/xuQiDeWCKXgtFXKdifHhYiERfagW4ck?=
 =?us-ascii?Q?J3R80X5Gi6B/I3USp5brhWjdeSPiRzBvpTRY8iICNLHfj6s+AAQbnZVl0YB5?=
 =?us-ascii?Q?vFCA8POlY52ssaNlD/9Qg9s6lAvuYGXW0U6jVOS8SfqnbL1hTH8WQ2hEIbuk?=
 =?us-ascii?Q?xhutUbtj9wpvT7aAmceeV3DzrwK5U9PsIk+7cTWZiS6Kk79XVrZ+mOnfbtZs?=
 =?us-ascii?Q?U/Nsb86+aobFgB0Dq4oHh1tckw/92NGVPudcmWpo0DmXn3X7dcqoyPQBgLMT?=
 =?us-ascii?Q?uOP06bZUUCarZpBMiDTb5ZnIwiprwqfip8TLEa/fxGwIX4cRhT0D/Sqr6u94?=
 =?us-ascii?Q?KiLWs+phncKx8tKybZV+WHHI0RxxA9rLkBVVtE4E6pYlcyg3+PGYEWSWmObK?=
 =?us-ascii?Q?NBzOt0VeLIZf5c5CUvnlXBfKo2ETYBjX3AzhyJD+hrkLna6TbpUQjMtwibs5?=
 =?us-ascii?Q?Jp3jgt2ZXF1L68jNRwuqGy+b/dc8euTD3i2IFP3GSeRRx1KwQPv9/GjsF0df?=
 =?us-ascii?Q?qtPqiFogKZCsZZllZMshhG2HAMpAdQirljVyNQ+P4iQ0D/vBae3FMAaN8XET?=
 =?us-ascii?Q?g5dqtFh43gMGY3RetWXDDOgL8n7HKof+X91AB5/y5bB0mZ8wO58y6sR+1Pmp?=
 =?us-ascii?Q?Xe03tGcuSDlF2etdaSAQ4fV3Kj9A0UlLlA8lVCyZDZjcRhqg74rlNVbZgeXn?=
 =?us-ascii?Q?w5ITV3bm6R+fuY4F0l+Kxo+2959TcCs2oWmpfryFrOT4MFDeiPqY9XeUnUM+?=
 =?us-ascii?Q?WT+wOMvQdiIxpilT6U80AT+7NmwQKPKzxCJ3kmvUves0VJKK6hWpIu55W0A+?=
 =?us-ascii?Q?KbdhaLN/vkAzjRPlRTKXP26+AlHfMzOGRaOR9pKP1/nWylUGj/h8J16IJyOx?=
 =?us-ascii?Q?AJ6JbFBSkT1KXYO8tpu6FRJXL8u30Rl6FGb5BOfvafCL/YanRrY0qkZ87A5q?=
 =?us-ascii?Q?scGoQa8RALi6qttrPXKwujN3Y6Qg/nEa9RNOafpfDDiNjzf3FWH5QXFbKOOQ?=
 =?us-ascii?Q?KUebS8xnhFmYqqN4JVwL35LKt28I0S7Z1EQpOTFHsDtLP6N4bLtlM6DMRUvW?=
 =?us-ascii?Q?jFbMZflE8A52ZxAM8f1ftvQRS7z0rYdDBlEx5AuAgB0F6932VYsqEmdV5Sid?=
 =?us-ascii?Q?21bxcAIW/0+/woIIYyAqt4R1jpjKkyKSy6FPxA6gtLSWsXBGbxpwQgIKePoV?=
X-MS-Exchange-AntiSpam-MessageData-1: 9O54dX/jjFPoug==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a4a842-9788-4ea6-f3ac-08df47444272
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 20:24:20.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4a3qaqDbzBPXvU57s1S5+bDgYJ7hb9EjBIJ86V71pYaJl4JpJFafwFH7HzTPdjBvHCy5BpI8deZwbu0iehq4v6eP6F1iqfqhiiI1nGl7SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7644

Hi Tejun,

On Fri, 20 Nov 2026 01:55:31 -1000
Tejun Heo <tj@kernel.org> wrote:
[...]
> > Yes, I think this is OK. It means that hierarchical scheduling is
> > disabled by default, and the administrator has to write something in
> > the root cgroup to enable it.  
> 
> That's not what I meant. With the root at "max", nothing has to be
> written to the root. A cgroup can be given a budget right away and
> the budget is admitted against the DL bandwidth directly. An entry on
> the root is only needed to set aside bandwidth for cgroups up front.

Uhm... I think this might be problematic.
The SCHED_DEADLINE admission control for tasks is based on a "global
scheduling" assumption (tasks are free to migrate on all the CPU cores
of the root domain). Hence, the admission control is something like
	sum_i(runtime_i/period_i) < limit

But the deadline entities serving the real-time tasks in a cgroup are
pinned to cores (one dl entity serves the cgroup's RT rq for a core).
So, they cannot just be added to the sum mentioned above (which works
for dl entities which are free to migrate).
This issue was solved by reserving a fraction of the CPU time (and the
root cgroup parameters indicated this fraction) to RT cgropus, so that
the SCHED_DEADLINE admission control is still the same (we just decrease
"limit" by the fraction reserved to RT cgroups).

I am not sure about how to adapt this admission test to the strategy
you propose above.



			Luca
