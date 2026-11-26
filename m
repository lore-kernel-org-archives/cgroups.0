Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.105
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795705066;
	b=KQjiklOs7p7ChhJF3NoMQ+oEY2wJ4wcDf6WuN9+nfPy1nCEd8zKl/ekqtFgSYnvAmIwT
	 c/NZSvDHhUYJrsRTmFouJ/FexcNQ9h8gevSK25tl0hz63kg4rPtcyjLWR8EPBb9xlDp7D
	 178gd8gMpCQuIEuylAxg+rTicxcVHDAMsXV4NXX7yoFCur+ojz7wYrkIvfuwmEVQfSgL/
	 ILoXE/jDNRMwqfkcgQfeMu6AR79vUbBCuq9Aq1EMAuewcJv1sNKxBLLQ04P73dUaHmtXv
	 Rw9zBiqkHPBcZTTYGG4tiJEm9wS7eQNXFKFsvemE1QQ9JydnxUlcDl9jOvxhyqhoXUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705066;
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
	bh=NjwBLSXU0HqOuz6Uu/uLZYLJ+DX3ExXcgo6XFMAGuNQ=;
	b=2IifoGRF5othaljUCE6iJneSSoklKyqYhLf9bSYhJ73117PRehjAZex8wiys8+wgxNkx
	 iHh7LCxqBdaNiV+RH2Q7MwcY7cHiCxzi9ubmcKH2Km0Vmw8tmJYpbLjYzidJIP3DpJbhV
	 POkUNZU8oQnUPfG8ivNs4xF4UAptzKvrQuFB734anEhXFweK+bSMaUhzRivgz/BHDibHD
	 5o2xlFCDhX0RRC/jWkPtk5YJLSxryNQo35e43I3+KHTFknVe0DZ67JGtENJkFtPOjgqv1
	 7yxNGNVztjxhjmrt3G5+yoTi2N5ZfzvUlBMDkl6RPTjocJ34CCIEDEtexN9yDxSKoVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b="A8HUOA/m";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.105
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023105.outbound.protection.outlook.com [52.101.72.105])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EC606A6A3;
	Thu, 26 Nov 2026 14:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF8EC606A6A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=A8HUOA/m
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7MX4aspdgtdPDfaS7njvWOusD/WLri8qUKoF0F+tXDdFVS9u35x9Cka8ReqeZAgv1qa/mRVxV9oO1s0u3TZ3uy86t83KvbrdgutZuvf3QcOWhgjAAInJl6Ut+Ff1JCEz9BDp+c4cJviyN+z1TJvDz+tCpYf49brtCYEYDvOGKOK8QHOXNaMmIUGwwoLziebwTITokEql6hAVAt02Reew3lmPylLtP76ZJmd8bMFWT0P3/JZ6k1+qQlMq1IQ3Jrwp5HQRvfixcT7uODTAusp5yhnrnK60TGM84iALUDdfbckQq9ODj/6z9zGRg2RxWy2Ll8xpwCEVx9cXioIapBg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjwBLSXU0HqOuz6Uu/uLZYLJ+DX3ExXcgo6XFMAGuNQ=;
 b=FU5wg0oQiKTn1rjLpd6imoya4mYevMVF2Hxdctzp+Q9Qm3FzWaT+pUbPS7FlBXUYAzcqKxtx2+Z163+y1kUZkepLei8TU577wF30DxGmJA2tg8kMjbWV1m+fdei7mZe92QLKHup5UQvMOSIopHNiRjPB3w/7qU4j4hwdFwc1DwBr90wZ8NIsUVsFbjB7nVC8aGEfuBg863RMXMAKEF+nSdoFXDBVLG8cnhR0VKHFqOgeSxZQIch1GPqXkNOyfwy6MIboiFtocVTB4edyX2+zmc18jruxzOuYHlC5gFLhbZSBrbRutYb3+qjQOOzja8Ab9yfFLCH+8siUg/rthBZG4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjwBLSXU0HqOuz6Uu/uLZYLJ+DX3ExXcgo6XFMAGuNQ=;
 b=A8HUOA/msQMR8AM5O0QAuCzEEa1gf1R7wlsuM9juxV6mRm+SCwn6KOViHl81nnzOC2N1oGX+p+IyL4/NkjIHrxUNHQ5XsLn3buvzS9DD88/KmxEzX6ojthKg2F15soJSFELnp29WaFApJlYdyTpSw+bnLFgHml+iqmODZbKSCuM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by VI1PR03MB6367.eurprd03.prod.outlook.com (2603:10a6:800:19c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.5; Thu, 26 Nov
 2026 14:57:39 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 14:57:39 +0000
Date: Thu, 26 Nov 2026 15:57:36 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261126155736.20e64e65@linux.fritz.box>
In-Reply-To: <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
	<20261123151846.3fdcbf4e@linux.fritz.box>
	<awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0393.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::18) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|VI1PR03MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f0e84fd-0b52-4885-280d-08df4bcd9d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|786006|23010399003|7416014|376014|1800799024|366016|10070799003|18002099003|22082099003|56012099006|4143699003|5023799004|11063799006|261026121527099003|261102123227099003|261021123027099003|10067099003|261026140227099003|261022105027099003|261021121427099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	kWnN/mjbz2Zf28MjdT7OIqlakG28NejkgktdSclHy54iynLw2KhMx+kxYl/sY7N3KL4D2DdlNMawb1xwgi5PNKvPIYOGJkyPXmQRhREMGBR/fSmXYnTlLcOrzJjRYZnH3fQTMIcFhHKBl7sGfhXSn8c4UoRl8bOXHNrbmOXWVttjd/UczWjqDMFjk06GPBS/Ssyqm/cFmqHg/LpjW3oydf25dV1oA8bfWGf/Cw3D+A85sUeMXrRXZELFag2tJfBLTNbvdbL4c+5aPhOuYJ/ijshzIrXbTfOgRn1pMemymKJGfMejYMp/4hCrpjq71iquqKZEJqjc5stsDu/UUuBTlEBi//plbIIMXAgFbXniK3mhCzz6KmcxM70l+aB0nxdaF1IJnsvIpIITZIMzTKrVwiN8OODshkWuPB/sXksp5QWfaeS2dbDd/Y4Dbn8vGPxEUVksUwsu7+igcobRx7SEk0x6+wNkOaMBzo1HwPViPBOgR7GCLeSqtF2WmL1gy7yNaGoPVCERjs9/fKX7/vtQF1hN0RMIrlvShaCk3uHEQbGYSIG5nCuevUF5Q5M7qThs7RQe7kgS2kEQ+7owihT8Y15t00rdKs989mhGEos5+j6W0ypWmkqb9NXVCMcIWQz24QxRLgglq+P9XQnz4uxOiHr2LDIcj67QKtM7JvkGgJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(23010399003)(7416014)(376014)(1800799024)(366016)(10070799003)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(11063799006)(261026121527099003)(261102123227099003)(261021123027099003)(10067099003)(261026140227099003)(261022105027099003)(261021121427099003)(261028144727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8dcKRA/iNvKevtgVJAtO5pDybe1hiW4cuIBrkD/eTNyd1dtg/DsXcT90IXgZ?=
 =?us-ascii?Q?vMP9cWgkObUBtxJuy4oTiWfBgkyES9eh6EoGLNxzz4enZ89HBx2R6ydHtd2t?=
 =?us-ascii?Q?RjQTshq+x6R9Nb7Cj/1a2GASYbmPUcbEI5jk2DFQUZQxf/PI5zIGMRo1pj5n?=
 =?us-ascii?Q?vE60ly2yHcQd6s/Yd5YS6FlZmov7zI4TW2QSHPPq5ubJzyfE4ATJYUHsyKyT?=
 =?us-ascii?Q?fmdlpOTIGu7KSX1dFjGXh6fIVdZXxdyCC4kHv4EKu5d+SSGcQo+TBkFH6nPy?=
 =?us-ascii?Q?aiypyZk0n3pkJbRWoqr1F2MaDsQGOHNHxf0eQlZpDl0M57qOVHM6mgycN0mI?=
 =?us-ascii?Q?VirE++m51g9aojhnckHCwYrVi2vN64qD9QZkSwfUTITHdYE03xuhsO1Qy2zm?=
 =?us-ascii?Q?IvnIEQ4CRLz5dW8na7aLcWDUrfP0hEgx8Zekj8ws071FdXz5wqxEMO5crxiU?=
 =?us-ascii?Q?6WCmpCDZbTJOmCXbwl7eXicEWL9qShGHfZeghZ4fyVcrWupA0k8ZkLtQPYok?=
 =?us-ascii?Q?kcd3wSeN9fhvTNukrb91jRl1MAe3f9cboblxcOAq8fz4T+RNduGeukyzFtEO?=
 =?us-ascii?Q?Ics+pG/Ev/WGIt4qa+//EvcORPE0naJ7xLF394epR3/9HZgg4nRaOBIpr65B?=
 =?us-ascii?Q?20LDMVIGDhxAKQ3R9xBhYhMy7ftY7DKcA7R10nmrZ5m9io7FJN2HEG1wOFoA?=
 =?us-ascii?Q?b1+BpJWjwTHSgjnImQS0iJ1wEy7RLsPgF/FVV8ylCUA7M36KaxsN8Ylkf1VZ?=
 =?us-ascii?Q?3HmWCHrDfnd6AjrqPmJ11jm81vUnH9bkaIGlpGMZh9Rl+48rbQQ46wYglHHd?=
 =?us-ascii?Q?+bIXY57cJQoMy4XUXkJlQgGGAFVUxMkeY7SgZwAlAAtT9w7gnxGpzP69m2/M?=
 =?us-ascii?Q?qwkZoKVfBABYPJBRz1aHRiisAij8VnWBJx1dLTsNDlqfNeAwSCu3FIsJYWfd?=
 =?us-ascii?Q?julrVsysEz0nneEy4KS3jAjflwMYq2O/5k+hqgcJ4ez8C3j1U8ndfLQasxIp?=
 =?us-ascii?Q?FMxh9QZpbI0KQPGnMWDn43GOXL1jnUAY940+fXXNd1/sepnSGowD6KgRNU+V?=
 =?us-ascii?Q?0SWLjRhm0RIfKUyp6jHozVLpJ1m/C8Tyl581Ln6EHfD7YQ75mf25OPD1UVWb?=
 =?us-ascii?Q?OT5iVWepWXhSo9FaAlGyIuBS2vGVlGIKjqWMn5haTWnCvvVXhvbdl0FN4D7E?=
 =?us-ascii?Q?GxFIOwyuPNifObTV11NQgzd/H2xAEgF6N9pzwNtfhDik3eUctyonW+hwLs11?=
 =?us-ascii?Q?Y704k+/1lfHw/weueUJeDqdXaKtQ/wrZE+LJGBPUBRlKekHZUJNx5CGQfGCt?=
 =?us-ascii?Q?vkWzBwNIU61v0lLl4zlY5RJ++X9Wkd0azmVdTpf1mwNE1XOGCs5QVLgb1DRl?=
 =?us-ascii?Q?q5BSUFoiQ78LoOWyGm7jN/vejDH5J4PZuDHrIamNhOCR0gpf7KOl+oQkXymh?=
 =?us-ascii?Q?EBPqfdRszqw9t9nGvxCfKYTeQOy8VuEQ6HTUM3MORXWFk3ZgirQi3Ui3mp0I?=
 =?us-ascii?Q?sIwm+kpDwEkWP25lPKanVSYwR2W0Q3hF2VGC2Brw9L0CZNX/AwWQTatdARyj?=
 =?us-ascii?Q?U81BHHzaZcbvqXMbaDX1cn9De8U3yknPnKHMfIZQ+HW23ZxImkrCE6mz0OY9?=
 =?us-ascii?Q?Is75j0740yJfQgB42oYu+Mbzg/9jpW2u3UIIeUI04ANxaIGkzFGyXIrawdeJ?=
 =?us-ascii?Q?/TG5MJquTgwmjuIeLCrkM66wTjkyrkq/uwqRtwBfnzWlgE7dUiaroR4GX+jj?=
 =?us-ascii?Q?e+avYyenFZE4Y1NJPJYhQjjdT+nOPJwPcTQdQ9dcZyBUMfYnuQz4PmHx2pbl?=
X-MS-Exchange-AntiSpam-MessageData-1: D8FMj4XBe/c+7w==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0e84fd-0b52-4885-280d-08df4bcd9d2f
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 14:57:38.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9xM61fjQdv1XDAAnfb6b1vODxTQE6Bmwu/pCW4eM5FxGFRQiXHsJw7qnT4KnRDZJLKC4Zmh7gjXg6QgJprZmBy9RZ2SiSmjvjxldlIhyZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6367

Hi all again,

sorry about sending the n^th message, I just have an additional
question to check if my understanding is correct.


On Thu, 26 Nov 2026 08:25:50 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:
[...]
>   P/          cpuset.cpus=0-10
>               cpu.rt.max: 4-10 runtime=400 period=1000
>   P/noncrit   cpuset.cpus=0-3   (threaded, no cpu.rt.max entries)
>   P/crit      cpuset.cpus=4-10  (threaded, no cpu.rt.max entries)
> 
> Threads in P/crit are served by P's servers on CPUs 4-10. Threads in
> P/noncrit find no entry up to the root on CPUs 0-3 and run as plain
> FIFO, as they do today. cpuset keeps the two sets apart, so no task
> ever moves between a server and the root runqueue, which I think
> addresses Luca's concern about tasks changing reservation on
> migration, at least for setups that care about the analysis.
> 
> The mixed config ends up on P because of _delegation_. P's cpu.rt.max
> belongs to whoever delegated P, and it's what bounds how much the
> container can reserve. The application only arranges its threads below
> it. If a cgroup had to be "all or nothing", the admin would have to
> give P either zero on CPUs 0-3 (no RT threads there at all, not very
> flexible) or a budget there (reserving DL bandwidth for threads that
> don't need it).

Uhm... In my original "all of nothing" idea, my plan was not to set
cpu.rt.max in P, and to set it only in P/crit. In this way, the RT
threads in P/nocrit should be served by P's parent (up to the root),
while the RT threads in P/crit are directly served by the dl servers
configured in P/crit/cpu.rt.max.

Would this solution address the requirements of this use-case?


			Thanks,
				Luca
