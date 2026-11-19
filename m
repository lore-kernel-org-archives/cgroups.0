Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795097665;
	b=KV7Hb0KPpCKHY/ZZbDWXhU8flGf0AL+e6oT/kowLlCoxlxXcdjDJyOzhOmsdVMl0MKcZ
	 bBruFNZvcRKiDfQ0J84wPMoI2ZM38jd5Bd21kvMVIttJO8APm9t4n1KE9Ek5FXIGgse8H
	 Px3sRTGOdC7xgqbZFtK0b1NscDytDQilAwtlL6XIhtO6uANwWOiQPUoTEre3AEpypVCD9
	 gszjswWm0kGMC7o5PVqyCL59FyXWFpV985JhrlUgUYwfFqOKv/ZQ+p9ZTFuz1CQspBgsh
	 7/50Ezoi7LLJ/eiogFDxVLoSsXjPeJGcJDFk9nrcNiF987Omw4YQ+bp9wg+XLJH5Tfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097665;
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
	bh=RdlBmIv0LXeViljOvVWVfuc6ynyF3zLrMnTok5rpWYE=;
	b=hYQV9MnyHuF102M8ZeDs8K9r6pZz3f54OCB8xtZlNxGWW8WHUVPzTI++BWwXN7H0azNf
	 IX5LrhF68WwctZWA3F4Kp9wkT7R9VOSDMHT+H9HkrQ0drqyPJEflNdYwR+OpQ3vETVYJu
	 oDRCZ4nRxu82bdP1XN243FH/WXnAzAkzh7vp62nsL4wabOWyfT4ct9oERNyXkBIKiFEhD
	 aT1PcUHfbgBQGIEJYUjoa7kICMoJRhcDnnz0K0G0w/6SvSQKQgmRPKKw44Cp+8tbjTOtp
	 eP40ySHKxQ1WjU/NvU355XLrWDLpVIJl49XJQJikFhOKeGDlCsxWpz55yhARWLexHlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=VYDPHIVp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.83
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022083.outbound.protection.outlook.com [52.101.66.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE778606A320;
	Thu, 19 Nov 2026 14:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE778606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=VYDPHIVp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNQuRC3MI4pFizNOwfx4EtLXxq1OVQceAQm2+832stMCqJF7Q/UzA+8laxJRFQQR8ai1RdlSRcmZmNTPohH2DUsHsMGTzzmua7eGOUZd1daP+kOPGpwlu6FFnf90R6xO6L20DCHNjJ0ivAummvTzjlkqnw97ApmUe1+sfxilnhRdwbNo5skB8GVb+Mdcw1NRlxZWu+fbHRMDulYOWaYyVnwZ2ECTwsjydQ4r8trdRaQxPR/JDjYAxx8w6mVtimYW9NHx2MCWv8G0hJqfG79+LqqzIajjxAy7m1LBDoOs8EByrViZb6yFBMY4EECei473zWOD6aY42SiPkundstRuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdlBmIv0LXeViljOvVWVfuc6ynyF3zLrMnTok5rpWYE=;
 b=abT7VB27PRCF1u4EbbOwL0zjQn6WGQ4BIfur9Snbb5X9qfUVJ45BnaeDr/DE0b6RdModagvQ4MSQUubqrwaSDte4YczX2MhNwe0hIr6Oyx5SLHAeqbinO+n2ojoR+bb5VFsgytmspfUazsoZZVThsYMi3Z4HU4HPv4wXRtoLFhTa51JfirkavN2aEYW0L1xQ5bufqLCGIJMKlWDMzyenl3luBINDRiAoKg6V1PpVeOpkKusURzyYbQiEfG7DZ67ltDPtQGbcQ1y1HK/XOdxrJaWaUbyEUcHENTK9+td8icoS/3XXD6F5JHNJxpePJ6JNaYYu+asGadw7U4zb/1sadg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdlBmIv0LXeViljOvVWVfuc6ynyF3zLrMnTok5rpWYE=;
 b=VYDPHIVpif0jeRxT6+fhXEdUzK0dGC59+3dW9Yr6Yc20pEBXrZfVDwB2YBJC+/6qX5Ud4HecJP2mFj3I3Zmxs+EE1b+sTXGBYBbJY/bByvQTnnrW4KrtjYd0ClIV0AGUgkZvrLd65cHH0X5ZeheYoYxM4MZhbCVYvHR+vb+0opc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by AMDPR03MB911423.eurprd03.prod.outlook.com (2603:10a6:20b:712::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 14:14:19 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 14:14:19 +0000
Date: Thu, 19 Nov 2026 15:14:16 +0100
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
Message-ID: <20261119151416.33f90a64@linux.fritz.box>
In-Reply-To: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0449.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::9) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|AMDPR03MB911423:EE_
X-MS-Office365-Filtering-Correlation-Id: ae463943-765e-4711-1d00-08df464766f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|10070799003|376014|7416014|786006|1800799024|261028144727099003|10067099003|4143699003|11063799006|56012099006|261021135927099003|261021123027099003|261102123227099003|261009223027099003|261026121527099003|261022105027099003|261022075727099003|261021121427099003|261026140227099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Cs7vjaBFNnwY5B4ed1NzOBqSRMHHy2xEe8WYlabE5YA3orvMxzHJ8LNSsu4I+/UQakAG3QWCtoL2EnwKNFBrTSb0yLLQi12KctDDjVOqGjViDrHsLR7JcoN7tSR+P2aFpYADx9wDobSPEPMy0EOY56zEhJc5UHBSiq37F5JhkTEY1kKhFT5CclF2++AiPpzd7NFwDoQzuXHfXbjV4tyugolELqT2q27TUHTO57tW8eg0ExOYL+qJqf5TshzDGOW9TXxw//5HcXnJQbbmpc/js8RQ9MYWBNwPvT2daSwXasnVnmG97Los/IWUyRas45n4MfnNj1L20/9GGT9cromGpD61l63kVI7WuVuGvLZub40SrVvl1+nCZbnSig2L7ry1XPutO2d80infNlVjx/NJS9FlKGbmqhc8vxKY5ATd39neWOpg7POjydBiQX0YSPGHjsJ5QXYbcB3zU9YEaYag95LuiLWzboBwhRYQCJWq7/AQtQvwK2S5iWjDQD9txf6G+ps0sx7Q/WeToNBIeE7PVvQIy3jmTsDbpGjTerZA25mW2LRV6xjh7Who00TVfJKMaPYY8XCHRf1qZ7/XtuLwFslkEbj60UuNoZICW1jzDJ/r4yPRd82bLozKS491rDs4bFMGlP+P5a3U1RdcpOEstg8iJ9V/WQGLotrcpD1YAVM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(10070799003)(376014)(7416014)(786006)(1800799024)(261028144727099003)(10067099003)(4143699003)(11063799006)(56012099006)(261021135927099003)(261021123027099003)(261102123227099003)(261009223027099003)(261026121527099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QavPW1YSuy6+3rTxjB3HJeBSPg9vLtEshN45ykx8HL133OlMEqGA2n2kfwN6?=
 =?us-ascii?Q?AkvcxKfiVBUwPtNfk7IN6GS51p8F3ylINIW3IplVknlRwzCj7/RG/UxpOBWV?=
 =?us-ascii?Q?bsUYHarrwCwwUyY4GeSKkeunlAz8fpRb+sO+QvC1lNt6Morr5yPawb2qkZ8l?=
 =?us-ascii?Q?tubFcZHSAae5AWzP+6HQG6jpeIkc5UVe5pQRbgzcbFaNxSb+CrlknFLgJ5CY?=
 =?us-ascii?Q?P9BRzS/BJtQqda7lHIbhGwXXrGdmopMg5i1todg2i+G6I8TW2D9OmzHeEfIi?=
 =?us-ascii?Q?HcYOxqGTaCcREya2+IeTGHd5CSvhrzzlf5P3q9JyEaNX5IZYFhUfAhJQmIZk?=
 =?us-ascii?Q?I7y9Te2a8f+5/3tKgHDcdgKwxs3cn4nXbJof5/yYal0fKbQaqML+ai7dpMTp?=
 =?us-ascii?Q?T6jeXVaVzxDWtPG/NZvCFUHMwBQalP24t8jN09qqR4YIvjE5hZZXCF1glFyB?=
 =?us-ascii?Q?aIB9e7yN+aDfRdnxxLll12H6rVFUmdS9bmdS4QTltK89xpzyQc+10Or2BbdT?=
 =?us-ascii?Q?7nDxDSHtUpXEQP9oR23RoZV9SQ9ZbVIQmA5MCaaRkO6ji18QbCxuMj8jJSeM?=
 =?us-ascii?Q?+dBBeEJCJqqv+l7EE8eawto0j0URJMXHUiCrqN4gUZEml7ZNm6sD+16ZHWDN?=
 =?us-ascii?Q?tSGIBTxo+11C6VnY0cnYBqUX9intNZm7w3jEQxY/E2c5oY4+Nn7JysbcDysq?=
 =?us-ascii?Q?aghNNG8+OsjXoPOdJOkmJ28pSlc0ZKRHaK2CDAEt/KMqU83I9h3SQn9vjH27?=
 =?us-ascii?Q?LnvZMkpl3LGDKnK0hrJFUeaFoCa8QWw4BUJExPWmkOThAV7AzgNDnkUJIYT2?=
 =?us-ascii?Q?a5yqeHPMlvgJ2cmr1RmdqNgW0nYX/to2PpyG7+GMkYWAPT8UqvcwF675f6tR?=
 =?us-ascii?Q?riWNtTwuqDCW791hiAuN7akYGgPCWdSAXg3h+IoBviSsF9TP3AbgE/+FCvx7?=
 =?us-ascii?Q?/mO6nCk++kEZqrq1dyanpN986JjNiWo1VKTHbBnCLdBOE8xuVXjC3hpnCcha?=
 =?us-ascii?Q?dUI5x4efGmT+94z0SETaATDWGLBnAG+MhhOGJ4yiMnemzSRuTm0dia54qBgA?=
 =?us-ascii?Q?jauH81PoJa/f+yXv+fjHeOecIqW37yU1i6R73Xw/MpXoIxfjon6s+T7eU6Ux?=
 =?us-ascii?Q?v4pbd5lt4HgzJhHE2U+SZvAFxtQqbe32gVejJj4SLkzQqtlRlE001u4SHfLS?=
 =?us-ascii?Q?9VU7VMyszfx7mOsjHrxC5pOi9DqF2IUYAt2yUcINRLtM5+C5m9CpMb4rvu9+?=
 =?us-ascii?Q?dGH/O1uNBp3p64ybmkl8irZyFz05yELmGSGGB3EjeLn/v+8ilpC6LP+tH9bV?=
 =?us-ascii?Q?Pn6np0N4GTENT87x7aqz6cqLSngPWJnhNTtBRFDLCYmfVrX5BZSImBGIZzXR?=
 =?us-ascii?Q?ym7I81kOQykkvFB/U4ySgqinH+aXx3tVKNGMdpJnFHWPr41qsbbY/rRz+pvI?=
 =?us-ascii?Q?ElMbkPJEI7RQyf6npwT8Kv/uP2/MjnSlCbzbVfJFhI3WYo0QTUBovT0aPbBP?=
 =?us-ascii?Q?b9ebdJ+PM96EmeQE8w782IFnl20NDgtfKUICZiaBQhojZq0t8Af/QL1EmqHv?=
 =?us-ascii?Q?Na5Li0DAQT3F4UD10kO46WH6gUv3x8E8s+a6bKld2q/uwXpCTgIkdRTgdDRm?=
 =?us-ascii?Q?Tf1BQBWqAH7kmCq6bccBBprD0Fwr+BDqCajN8UEYivqD/ZL8M4TRtA4EOit+?=
 =?us-ascii?Q?oanhQYiDG34lDVK8hlI4zIwmlQLiraGuMG/0E8MyG1v5OHDV52L8dHOfHXTQ?=
 =?us-ascii?Q?Qma5iFo7yJjwu62cfh9Ou1aFw2FEahNp5ZDnktm94kf9PbdhTeYJr5+FcLol?=
X-MS-Exchange-AntiSpam-MessageData-1: frcmZMvPyT3tpR2mSntWOziWwYgSJOxm2Xc=
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: ae463943-765e-4711-1d00-08df464766f8
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:14:19.6722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9zLBBpiYMHknad4T8ywj5Xptf9ZCljThfLWtwiaNhrhWoWVtc6bQVPcPDkaSZDPSq9cxJVQae0Tyf1Vv9xZpixaCXco7TGzab6XLoVIGnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR03MB911423

Hi all,

first of all, sorry about the delay, Yuri and I have been discussing
these issues for some time before replying. See our conclusions below.

On Tue, 17 Nov 2026 22:07:04 -1000
Tejun Heo <tj@kernel.org> wrote:
[...]
> On Wed, Nov 11, 2026 at 06:56:57PM +0100, Yuri Andriaccio wrote:
> > - `cpu.rt.max` only accepts per-CPU settings, so the global
> > "default" is removed. Removing all overrides means the cgroup is a
> > "max" cgroup, while just a single override means that the cgroup
> > has its own budget.
> >   + This new interface disallows zero-runtime overrides, as a zero
> > override is equal to an empty override when there is at least one
> > non-zero override. As an example: [<CPU0 10ms 100ms>, <CPU1 0ms
> > 100ms>] is equal to just having [<CPU0 10ms 100ms>]. This seems a
> > 100ms>bit odd, how to make this better?  
> 
> It's odd because a missing entry means "max" when there are no entries
> and zero when there are some.

Yes, we agree this behaviour looks wrong, and should be removed,
however...


> Can a missing entry always mean "max",
> per CPU? On a CPU that a cgroup has no entry for, its tasks would be
> served by the nearest ancestor which has one.

... We believe that mixing "max" cores and cores configured with
(runtime, period) in the same cgroup is problematic, for various
reason. From the theoretical point of view, this would mean that when
migrating between cores a task can "move" from one reservation to a
different one, creating issues for schedulability analysis. All the
(runtime, period) deadline entities in a cgroup form a multi-core
reservation, as in MPR
(https://repository.upenn.edu/entities/publication/5cd778fe-4d0b-45a9-ae9e-cef48209bd8a)
if some cores are "max" and some are attached to (runtime, period)
deadline entities, the tasks move between two different multi-core
reservations, without control.

So, what about a different idea: a cgroup can be "max" or have
(runtime,period); when we set (runtime,period), this is set for all the
CPU cores, but then we can override (with runtime 0, or different
runtime/period) some cores (but we cannot override with "max").
This way, "0" still has one single meaning (no real-time tasks on this
core), but we do not mix "max" and "(runtime,period)" in the same
cgroup... Would this be acceptable?


> Zero then becomes a
> regular value which is shown on read, and the two configs in your
> example are different. The former can't run RT tasks on CPU1. The
> latter runs them on the ancestor's budget there.

We believe this property can be valid with the proposal above, too.


[...]
> The root has no ancestor to fall back to, so a missing entry can't
> mean anything there. It has to always carry an entry for every
> possible CPU, which defaults to zero, and reject "max":
> 
>   0-127 runtime=0 period=1000000

We think 0 as a default would be problematic, as it means "no real-time
tasks", and 0 in the root means "no real-time tasks in all the
cgroups"... Or am I missing your point?


> > - `cpu` and `cpuset` controllers are decoupled, as it was before
> > the `cpuset` integration patch. The user/admin is responsible for
> > inconsistencies between the two controllers (i.e. empty
> > intersection between active server in the rt-cgroup and the allowed
> > cpuset just disallows executing RT tasks entirely).  
> 
> Yes, let's decouple them. With that, can the CPU offline lockout go
> away too? An entry for an offline CPU can stay configured and take
> effect again when the CPU comes back.

Let's decouple them, then. I am not sure about offline CPUs.


> One more thing on the unprivileged FIFO/RR tasks in cgroups. No other
> cgroup resource config grants privileges that way. e.g. If an rlimit
> is set on memory, memory.low doesn't do anything to work around it. I
> think who can use RT policies should be left to system configuration,
> i.e. RLIMIT_RTPRIO and CAP_SYS_NICE. Can you drop that patch?

OK, let's drop this patch.


			Thanks,
				Luca
