Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4951597B;
	Wed, 30 Sep 2026 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784830; cv=fail; b=ZLb1jz0+c4SMmKRqra1YWhRannFP/hWQ0boVfQAtVYkIHxwC/zrBS0WmM2Tdk69jOlmF7Fau3DfIP7UC3Sb6HhD0KRrZw8GGTpqgbOG/XqJwKAk4GTCRCIN7cpc800OlOxZraxBCRD1QkHWOuStzg3amFlgvtLU7rjIMy4CxuWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784830; c=relaxed/simple;
	bh=CwsSAtVx4tJ2UhZMlfpCD+KTS2Oy/FmMovw+mgqp8BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HmtWKyBdPmfiII+ujSQR09s5ikxdrsHCwAdHCxRFE8pcTSVOemOyelvnREOTaDltxn/rK0r2cP3GUl7J5/XBhySE/61VJf/8xCyUnkdbUHCob5BMVym4H1Jebql4fgkptAp/BF9kQOsijYNdS16wfiiRgMloOkwvTocNKiECSKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=joB02AXV; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="joB02AXV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4vMCRBU4PDkkSGfBkF2lQJEAQEd9zRlCV7jkWYEonvcwFdeVyRlIssrP/9GX0xdEjG6MZu5ebnmiKkZnxTpkgiK5L0DkMS/o16a9FbkN4yAb7fQM0qLGr83McOo8o6eIlfXDfX9Z++QqrG65l9nQEbcaLJlmkS36YwrqUs+KcLeDWDFuMz1SV0cApMwO5++FWwa3S8i+l17JV6lPU4iBn1D/tN0zjt/h+MeOlGGTdh6wiKc5MkTw1Q9mxwObt9OXIG1HVR0Fwn11LD4W7JX/YmWcrdSJeF+BkFB6zZ3ZsKNFuCOJAuQykg93jYCAno8aaftUuCK389Cguj34Mzblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilhNjnpQeFpOXhpp9BNCYNmOYNtwta63tlPyhigHwoA=;
 b=uf3jn2iMgP4Jv/av9ad7+ckpWTg4wQ9/cBvtpL5VYLt2pttmeAzVGPlgc4ja8titONHoT4qP1zksN+3KT9e9DYqr2ywjKFpUqgH2x+xEFRX3m7ewzHBvnhqA2d2ijCHqtdpl6hS5toktoiPL9qh3PRspIzlDnrPAm5eqYhu1unYUmPjrZWT1JF7T8KZ//KAfbJUNgmrGCr0NdPi1MEx4ePrM2lTGwH/60KQ50zSc62LZYo8mEFl+X1Wl4aOxrwyPCk79aEwWqJ9ttEA2J4dfWL9nMtTZuMLT/jFoQKxhns/k58SuZCyqy4tquQ2OYh1Nk8mROeDfgPYmL82W7k2HAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilhNjnpQeFpOXhpp9BNCYNmOYNtwta63tlPyhigHwoA=;
 b=joB02AXVi5oAgwCCfTpqpN1RBt1eZKewjdBkUpFnFRMhU0xmKo3D33RnphPPYONq9IPPDwYWU60J88mMzurduk+B8ckDEnARdWkYFLapwLODSCMUAhq3HqXF7XQ0L+Ob4jyUgdtKpCSIiXl6S34ofjY4uEsdzp5eCsKMwk0NL2vANGMkxxYKmjtjhX7jlC9zjZN2Apcg612zRtg3nleL1a3/9WBsYVGY6h9mAGCXZNfjA2Xq71Vq+zXz5jOvrwAafXDQ/J4oGyhyQ5x16vhtdUSYUK1+rQFr9ir4q0NoGnUBNpPyxvT6K03Jf7ExjT0xOhngxdulfCTTr3k6xi6pLg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by CH3PR12MB9455.namprd12.prod.outlook.com (2603:10b6:610:1c1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 30 Sep
 2026 16:13:41 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 16:13:40 +0000
Date: Wed, 30 Sep 2026 18:13:32 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()
Message-ID: <ar01LHxhCZLo9Xf4@gpd4>
References: <20260930154800.698360-1-longman@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930154800.698360-1-longman@redhat.com>
X-ClientProxiedBy: MI0P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::18) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|CH3PR12MB9455:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9ab785-514b-4588-f0c4-08df1f0dcaa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	H382ffdNszHax8PSFtOIgcdTvHb6p7/w2iLipdV9EN2pQlw3zyUeyk2eKuUxbkLDqzUtlkZWdyOchxqQ7NdyqXYVLWTrZ7X0uNUhppgSLVg5qorVEN2S72M8q/uTTlt4RwRJIy/3Zr2L1YZBmrj+W/QJbA3N/XQfw8ClYMkz0f5Ix7KWB9pjCEQjdEjS1wCNj9glNtLMeTtRZvp1FaiAsUPtATM12EBLF1fte1r7cun7OcTSQ/scytZ2h9Ep8iDewiwDW7mzPFHrkmYP3D3Vjidq950V1l3XVMR6+xZRhYdaoM2y76k86E9Zm2UjGMTcG6GhF1jOWKlWDCh2hpqbLPwo0afDuOPgn0Nq9URixIPT+JKfMqSxAVZNnJao8MVWSWAlqCwFNDXc+yTKTsoArkMzK6Zy9wq9M0hhKNiU0LUf1rHRW+/gxC4X4hSiZcUv0vaDZjvbfQfpoFNtInaVu0DwKGQb2iqjnQXUrkPJXRDeJaq5Kh8JdlaD4AHDs0xkAp74B9U3KFoAPA8ZLzfPygUsfJgHAqvRb4d9IQsdHFiePOJM++b/nW3tmd4S1thEwKv6RATGFPY3buwhC+lBwDhe8klCSCfLdlWyskB9tkhiz0oebvJHGRXN+leFeqslBVGmPRxWDUfItaxssfdDq7dUmvA82hi/r+wuPY894tM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6P5UpBc1dr71s/4cbddN1ELEG32LUrAxfB+hWemfBU2/mIYXsYUVenl79boa?=
 =?us-ascii?Q?P/I9MLSLO5oGBC0M4kQVwTj2QQCdEyq1xXW/RrDffIjqSSvXbzoUg/dWQvZd?=
 =?us-ascii?Q?sjeYG5NU21nuivLq9dQhk+F5PDmQIWzogeybct/v67oHoPbLpoXkuNe1YpiQ?=
 =?us-ascii?Q?z9/FmuQIBUQYXYivXChu3Kc+RwiPMJBrSfdipE/+Kd8C09sWFw9mbo0riRtQ?=
 =?us-ascii?Q?DgiErQ2/acLwcRzBlsbku/jvr6CesdzabhN6vM/dKvMU1W9VYsRtMXm2wrqB?=
 =?us-ascii?Q?bgY/fMsDEt78ofvrHZvtuwDquzDmbFMCtbHlBLj4YN2mgRtNTV3rQ2+MTwkm?=
 =?us-ascii?Q?CklV3ea4N8ECyazqVZfzBMgl0jnLsZ1sulEoioaH7//GX8ZQMvjr4k13YYqN?=
 =?us-ascii?Q?hXnF5yvxDKafwecU+ecluVD5bkT3+bSnTe8AYEQkcaTI20Di6PzllXdk3zvr?=
 =?us-ascii?Q?QrBWsKSHR+2s6dgYkEESnKf499wTYjh3+7Q9XfOtlMbFULSUd5mj4CvSqWM8?=
 =?us-ascii?Q?n0hjWNQQLHLuc0RyQDCF4C2Y2AaoRypkIS2rYxRECiIBJH1qhy7KLwVk3ixw?=
 =?us-ascii?Q?5C8Y/V9KIebvAmoN/zGU0glAXZ/doV/+byI0y9N5dWl5vYAwF1UnNvd5I9UE?=
 =?us-ascii?Q?THYeQsZHrFtlID76J88OC7Twk65oepxaNuYv0H3FUD6Y1vqSbY0geWT+hwE6?=
 =?us-ascii?Q?1Up64+ZC2gDht8O6md6ehG1omGcyof1FYVokTbWw9hTrSZMesUi+ZA4l/+vn?=
 =?us-ascii?Q?fzJT3W8yjSc63fezhhJ8uYwhlmpa+wIzom5PTFScIdc5UJpcxwrv85Fh+t2e?=
 =?us-ascii?Q?5f+/295YN36DgeDovLQbQVSSUYagao08Ma0wsksOV5UxNkq9KlqHQG5oi73L?=
 =?us-ascii?Q?q/6w5Bg52aNeW6djJVFqbFYGk1O2KCGTKUot4BKhmcX+ym/WVPvolJOqIJcC?=
 =?us-ascii?Q?QU8cI7Gv4VrRBnhuZXOcSQ+aU6ql3+NWDv1/dmYbmxI/+qq2P3l7SFK6ULL/?=
 =?us-ascii?Q?wGPz3/ehNqhDRsCV83DD01G/9ufL7gMl5TiyasguxLs/vhqDIGWo6f7qSiaf?=
 =?us-ascii?Q?CMBGhLcbZQaH/fiTXhGHlfLFrkp9JS0GMynB38B8mii38/VEaZzhPd/y5M6M?=
 =?us-ascii?Q?zcv8YTtPmHxOfJPAEworr5CYhoqtzgyD6uiZ0h3mS4qN0scK2R5pHuzM8ZmJ?=
 =?us-ascii?Q?WkUKXTmfLMvnYiQhvYLOjmDwf3IOIUt3Hy8Lub8EC8KgZVWjBrMTC2V7iM1u?=
 =?us-ascii?Q?c9W/1eKoecKpzsTs4N9vnzRY2IOPvwuPigqhVTIFGtU1x6TyMBKJEe4rXlEi?=
 =?us-ascii?Q?b3jR4zpxYVKT7G2jT6t16GcWjVmGpBUOsCmkbF7N4v+Eqipb5Y+ihhOaIl+z?=
 =?us-ascii?Q?mc+6HhP4M2k3s9gEk2LP7L2tEFWhWPZkOqIvxRYUmbydkucfmiAId1t9T+J5?=
 =?us-ascii?Q?QFIqPqcpz4Tq4c87eHYr0N5MINzxTSJ+T+BvtSHi0Jk8rZ7k7JSY4bsn8Gmu?=
 =?us-ascii?Q?swn8jvpKmMurMQmm5c5IK5RrzmGBd4PqBCfMi+PPHg3N8eEq0xOZEKOvACmL?=
 =?us-ascii?Q?0qGJhGalFD+43pfmMLmtDelgCnguY8slwDJV/agnaCkcShz3lbg9yk4hyijz?=
 =?us-ascii?Q?3Kc9A5MGdhfn7XD992WDVoBK0fKKOUE7VlkD6T7PzlN0XhrzAk7nQWQykSBr?=
 =?us-ascii?Q?KLTuutVoPg7ZjLIhugdxts9qWQ0c8ApsLU/HfJZ/7giIWWOF4hK3HI2loBe4?=
 =?us-ascii?Q?T26sosKe4w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9ab785-514b-4588-f0c4-08df1f0dcaa7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 16:13:40.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbasNHwEi9pyA8aDaiMv0WuVKS3lUk2IWNqHky4DxqsLRy6frgS1Er776o6kk66Zfj6wAw66vALQu3PuTgbK8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9455

Hi Waiman,

On Wed, Sep 30, 2026 at 11:48:00AM -0400, Waiman Long wrote:
> The cpuset code has 2 different helpers for determining if it is in a
> v1 or v2 working environment - cpuset_v2() and is_in_v2_mode().
> 
> cpuset_v2() checks the binding of the cpuset subsystem is on a v1
> or v2 hierarchy. It can also help to optimize out v1 specific code
> if CONFIG_CPUSETS_V1 isn't defined.
> 
> is_in_v2_mode() layers on top of cpuset_v2() and returns true if it is in
> a v2 hierarchy or in a v1 hierarchy with "cpuset_v2_mode" mount option
> enabled to make "cpuset.cpus" and "cpuset.mems" behave in a way similar
> to their v2 counterparts. However the cpuset hierarchy may still be a
> standalone one separated from the other cgroup hierarchies.
> 
> Commit 90ac22ffef48 ("sched/fair: Add cgroup_mode: max") adds a new
> cpuset_num_cpus() helper to return the number of effective CPUs in a given
> cgroup. It is part of the "sched: Flatten the pick" patch series to help
> flatten the cpu cgroup runqueue hierachies. cpuset_num_cpus() currently
> uses is_in_v2_mode() to determine if it is in a v2 environment. However
> is_in_v2_mode() can be true in a v1 environment where the cpuset and cpu
> cgroup subsystems can be in two separate hierachies. The current use
> case [1] for cpuset_num_cpus() assumes that it can return the number
> of effective CPUs present in the current cpu cgroup which may not be
> the case.
> 
> Fix that by switching to use cpuset_v2() which signifies that it is in
> a unified hierarchy where both cpuset and cpu cgroup subsystems share
> the same cgroup hierarchy if it returns true.
> 
> [1] https://lore.kernel.org/lkml/20260930081125.GF88198@noisy.programming.kicks-ass.net
> 
> Fixes: 90ac22ffef48 ("sched/fair: Add cgroup_mode: max")
> Signed-off-by: Waiman Long <longman@redhat.com>

Works for my particular sched_ext use case.

Reviewed-by: Andrea Righi <arighi@nvidia.com>

Thanks,
-Andrea

> ---
>  kernel/cgroup/cpuset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 4a2b6f154609..cbf67ad13874 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4251,7 +4251,7 @@ int cpuset_num_cpus(struct cgroup *cgrp)
>  	int nr = num_online_cpus();
>  	struct cpuset *cs;
>  
> -	if (is_in_v2_mode()) {
> +	if (cpuset_v2()) {
>  		guard(rcu)();
>  		cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
>  		if (cs)
> -- 
> 2.55.0
> 
