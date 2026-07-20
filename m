Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE66D3AC0D3;
	Mon, 20 Jul 2026 05:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784526911; cv=fail; b=otzHxGU+RXxK3ALgHRW6HvHACi42jxgQgQOR5+lHE44bu8EyvEusjlAL+L3B3FqWQkKOXVM5vifr9c0Km5o24AXXghrG+iwYitXAUt0W/KFrWkXGjkx2LrYJe+XubGR4ApfZ7ZuHRTuER3Jsn6l2i9jD6WFj5VLf1qxQamIJbGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784526911; c=relaxed/simple;
	bh=vXcBW6woytkXb7505H1ntpTcmDykGYvTR1WFm1kXOgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MQXnyxMsfl2QPtvtqDRD85xFsFjGsSOpAHXNILN53yxP+9zfs02hbsX/3wrCRJ5MXXG2x3T6LNKevpsyUmFK0ywBgROgTGBIR0gpA4gsIjZ6yWrEX1nMVGyJR7CIQZd1NhFxByH/xArDUKPAZhlaLkQ1yaz4/rz8tOC5WmChiP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P8imsSCD; arc=fail smtp.client-ip=52.101.61.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P8imsSCD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMQ9hJipOZJqDNs4EoHqaT8G+Y9YMUGy5N3XLMXfTBMoWWwOd5CGo1jIdXKaHyzsRCqqntTZPCEHoM//DQhcvLuwjtBzAXBDtzNwW6fVXmf0BsYe/6bHCeV3KvXyqIV49F397oFyjqiwjp6XQKrhRUSPo8sbj0II5IicAC23NJObmiBSjP0/BrpL9nMOatv/22WNryPImMEzmpDol+++beOPuPAMK2FbTTWJYFIIzKU1zO2voJSsoR7zK66u6SGQv5XJOqRP0sfvuHn9J8s6EUeBK0DeRsHOMfEB1Bcv7aM+NY+WlQ3eKaBABpRLU0zU7RNrVvZy4dWPIt8WbtJ8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYCVabQA0xJOujhr6ebDtz1Ix/FpOcFMunNhIIkxxdY=;
 b=pLihJhAg1qaJk3JFrY3smuZLAVTajNg6DdZIUW4Z7XnDoiWo/sCeSahxPz9l5wNJ0mfrnPwQXUDLXSfZBDqYrfh04SMrlx9U5DVCTi9fQIrmLAbmzFYhiaS8PNvkdwfhGL2v0LchGXG+OdZs2K50bi4cNQTyMAYkAwn78HuCcP5S976thdxUy1VlfHQLB8dDH2pXQIfJsMcP5bptCLaB53R0pFtvIN0IMhpEgSbQpRuZ7Hrwe200nWlQnG93ReIAIjHus+QM780iEBnxJPpxSh2ORiojVDCD4A8+PoLXBtDRBr2aWHbPQToSPnJVI12QOk0OCP+3zFG5DYg4ouV9hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYCVabQA0xJOujhr6ebDtz1Ix/FpOcFMunNhIIkxxdY=;
 b=P8imsSCDKDW77/OWQPS31HZHXrVmY6opX/Q7si6Da3Qha2bz+KIudGiq4qqmB486hUmwpg1yRpVQ2zEpx37MGQKeFnYPrhUZ04HO0Gu7hE1tSEgQfPTYIO5nQWV/NvJPc65dPJvHyZf1YWue6BqvaypzR23COJewYj7FNT3llZmgnTGrvv2ZzsoejE81Fa1LOqOqtUT83j0mh6awJTNefyXwJSyoOpFw2WD0NBEqfF16uOSxSvm3ps7W0bmwe11kyZlQHbGJIRWgirKT+sU/001wo98njT43tmccKBUrNw8Yxn5891P7DgZ0qN8h1oTJFbWIgQ8+aEt8xDDmNz2n2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by LV3PR12MB9235.namprd12.prod.outlook.com (2603:10b6:408:1a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 05:54:47 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%5]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 05:54:47 +0000
Date: Mon, 20 Jul 2026 07:54:34 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
	sched-ext@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched_ext: Re-home tasks on cgroup migration
Message-ID: <al24GoeqoJhGS4_H@gpd4>
References: <20260718081727.582037-1-tj@kernel.org>
 <20260718081727.582037-5-tj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718081727.582037-5-tj@kernel.org>
X-ClientProxiedBy: MI1P293CA0018.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::12) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|LV3PR12MB9235:EE_
X-MS-Office365-Filtering-Correlation-Id: 588258af-79bb-4515-252c-08dee6236722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gZ6pA6QOY+bkOvYjatVH1NbuKK8GwqgOxDNp8nODCEcSzwD+MM2coXMDaT9Z4+LX1qYeEBqNm85S5EZMkrnyG6cVIXprM4tmfRSWUIhSyXAIwouu8zn4gsjyhH32Ws8IDa+P1PK0oEtgUh4YfHpRT3wo8+vvyJoxwGL03zIdJlwqyxxYl5BCoI/JdqqcF1cSzr8O8toFu/LrcNwgMImy0TWkQQlCV4PDAYieoJHCmSM6xGpFDHzDDFIGLXXYEm/lF1bTjHMhdyDv+Gia22tg6gjK6TZAcGt/6ALwOphpe71gaJejT74O8xdkd19c80HR33Vw073JN62foiGuSkDuypm/PdqO7c9/slcMlK0UjSrLSlAhkEzSbOG2S+P6Od1BUe98tVXUjwWDEFgeAxt1M1qb8ECl3/FRkjYaNU8eFbDBvSJ9YV4U0haTrMa5UXNJzVHd6KEQAEt6MdBTStDg0tZ/vPW0mgcf3di605kLjlCwvyWeBpGzk3GqKeUpOmWBC+oIrEw1ugZt4BDrYnlcpycNhDznoM3W/mnoOwPK8FLp4m4RWd58tdwjoSfRAQc/RAP7v7KhfwGGRDz+51DNSyp/Gan2j5UdNFMoY8GCk2I4HfIneSgR7jh7muqse+/cdZgVFv/IxwBVq0KGHzqJC2TBV67Nw9KGeVFXKQav9Ig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m49fPCReZs/VB6wIr+9PiHTysQvg8J+McLYavnvP4ureOUOUlb4vrZvyboJX?=
 =?us-ascii?Q?BcrjVnTqLgeRdG+fKArw3DM684eKHEEWp7CZTEfF9B7aUKHBHRUbAZsJgieL?=
 =?us-ascii?Q?pOgvJZx8Qedf4WC3fOH3dWy1MewMJtCe7SD6Qz7MmyWl1lDOWLFAOe41KFje?=
 =?us-ascii?Q?t60ywZ2kF1wC2luef/ZnbQuYkVS5dTVJel5M0LIbNna9kxtprAX5M4sYuuNZ?=
 =?us-ascii?Q?5KFEZu4R/wpmvr80GHgz+CLe53jMeKed3ahMioWArZOrSaUXb9hFDJecatSM?=
 =?us-ascii?Q?Zd9tnnhyZKbBOcc4CvZ9GVjn2QMtmaf7/N2QM93f4Qwmrc2JyILA4/v2cGPk?=
 =?us-ascii?Q?ptz8H7WwVNpf2gKh/Cdv5089wpiEcB56lfBq08PO7/J3sGO4R4dEXMbxmwxk?=
 =?us-ascii?Q?Kh2rtGAg13VLZWKaRBiHshU7DRIw+5PN/c2peyL35Rbcwq1HoTOund6O6fqA?=
 =?us-ascii?Q?9qP3XL2n4fMtReyWrE46+almTTbwlhQdmFKBkJ5cI0IEFH38hO2qCBOS8q0d?=
 =?us-ascii?Q?zafwaQi3XRIXeWtIVZ6gc82uu49qYoFjqy2DWVmwAbUCf7BTqOeo8iiJr4qC?=
 =?us-ascii?Q?K87b/kmj5zqNB8bGyfHLV+yUf2SSSiAbjVgo+WM6DKMY2OprLY/4OFbCBuZp?=
 =?us-ascii?Q?mIPTqBqn/Sb1mOMw0sXUL0yAj8Pn4p+LFmfaWWYZVVBX3Mte2szBWV3/r6K8?=
 =?us-ascii?Q?Pg5qYcptPIlDkJuhIr1cT6bIcD18ouGTufBa9kui04ZEg3HIPk/0J490Z3il?=
 =?us-ascii?Q?gvl2MDn4oR73EoZjA9IF6C1A4cFiW4Kvf+mZzoT/Hact3CeSFHQNZMRL8o4S?=
 =?us-ascii?Q?UM6z2BgSq4iOEIY9P/XdOH2Bz+wehnzYh1KDdCJMJSXnak4rW6dFSu4MHQ4H?=
 =?us-ascii?Q?KvyZ7XDYlrxVJWJnmRfmnEYSoYOhEHtScLqXHuHOqqziCIYCWIb4hzhYXJbu?=
 =?us-ascii?Q?otssgGgp1dM4yffOg4zMCtLPA5zj/wq61cxRteYTC4k4Q8F6gjt1Rb5UJ3yV?=
 =?us-ascii?Q?WmKNYuc4LfVjVTVk/GkJg3siAExMpzNxTPD4xh7rrsh3soh8bUJJXk3xTgq0?=
 =?us-ascii?Q?huEvRLUEyDmeKZ67hFPxQqtv4vBsuZ0l12qjJlk/X/3UtZ7kiBBgs7sJ7RB+?=
 =?us-ascii?Q?1iNUq54TYzChBZWBqB3JrUbOvyz3LNNyfbttcsFI1O9dWUJzCXJ/nLyb5Yvm?=
 =?us-ascii?Q?2USiyU4+w76IhpakecxoYHjb6OsG57u+BR13YjtDa0SPc8GmvNAUgr8g2YYf?=
 =?us-ascii?Q?2EEE3MfUH1goUdYrRZpd4lqkdcgCDcHC2GQCS97I5Gf6OIBFAjBXn93zxQtJ?=
 =?us-ascii?Q?vBOkxGiFsmQavqDCDo1iVwjc7Yjl0/V+5ui5FiQGHLOU5xbB+f5FoR0R9OyQ?=
 =?us-ascii?Q?m0m0UvRqGl7ncSZxVNF4pndpI+iS2HWoM3u7mx26hG6A3KIORqw3t/5bTGnh?=
 =?us-ascii?Q?TFJjMeAXil6QTWw+9ithLNVwYJVOcK48LY4xd8Jf3rgKZixFKDxU+x7FnpD4?=
 =?us-ascii?Q?tfiqURo5qSKSr7yQEu3hdTpntYSc57iocS+gfn5t7Y5Q8l5XZfgBAcIfCOL6?=
 =?us-ascii?Q?sqVPsGhG45KDODGmXsYTuVwJgMYHODHNb9A6UwkchzMMkzWrmqC73jzt8eHJ?=
 =?us-ascii?Q?/EughRA5mRGFkiOtYjlo1v0Nqu60kOmL7hur68Xm9DWkfC/WTn+zW6SdxGiL?=
 =?us-ascii?Q?tYZjKUrSkqYy7EQ970Q72DlG28dZntlRVunQVw0wO2l94+VBaLV9F/6YFbTA?=
 =?us-ascii?Q?PPh5Obn1yA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588258af-79bb-4515-252c-08dee6236722
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 05:54:47.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gb4ip5/+a+WrhFwL88s60Lt0ap+Dfzb7A//tviF1rk/BoGlVXEwhFfkWyRsojufseluOytH3/M01FwNBc6WLIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9235

Hi Tejun,

On Fri, Jul 17, 2026 at 10:17:23PM -1000, Tejun Heo wrote:
> A task's sched (p->scx.sched) must match its cgroup's owner
> (cgrp->scx_sched). cgroup migration breaks the invariant:
> scx_cgroup_move_task() only fires root's ops.cgroup_move() and never
> re-homes the task, leading to wrong-sched scheduling and, once the stale
> sched is freed, a use-after-free.
> 
> Hook into the new cgroup task migration events and re-home each task whose
> destination cgroup is owned by a different sched. The events map naturally
> to the transfer: MIGRATING runs the fallible init for the destination sched,
> letting it reject the migration the same way ops.cgroup_prep_move() can,
> MIGRATED does the re-home, which can't fail, and CANCELED undoes the init
> when the migration falls through.
> 
> Pre-commit, the task's task_group still reflects the source, so
> __scx_init_task() grows an explicit cgroup argument for the migration path
> to hand ops.init_task() the destination cgroup.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Should we add:

Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
Closes: https://lore.kernel.org/r/alnxrsexEe_nQwqL@gpd4

Thanks,
-Andrea

> ---
>  kernel/sched/ext/ext.c      |  29 +++++---
>  kernel/sched/ext/internal.h |   3 +-
>  kernel/sched/ext/sub.c      | 135 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 152 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
> index cd99947b4229..6bac68758704 100644
> --- a/kernel/sched/ext/ext.c
> +++ b/kernel/sched/ext/ext.c
> @@ -3485,15 +3485,28 @@ static struct cgroup *tg_cgrp(struct task_group *tg)
>  		return &cgrp_dfl_root.cgrp;
>  }
>  
> -#define SCX_INIT_TASK_ARGS_CGROUP(tg)		.cgroup = tg_cgrp(tg),
> +#define SCX_INIT_TASK_ARGS_CGROUP(cgrp)		.cgroup = (cgrp),
>  
>  #else	/* CONFIG_EXT_GROUP_SCHED */
>  
> -#define SCX_INIT_TASK_ARGS_CGROUP(tg)
> +#define SCX_INIT_TASK_ARGS_CGROUP(cgrp)
>  
>  #endif	/* CONFIG_EXT_GROUP_SCHED */
>  
> -int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork)
> +/**
> + * __scx_init_task - Initialize a task for a sched
> + * @sch: sched to initialize @p for
> + * @p: task of interest
> + * @cgrp: cgroup @p is joining, %NULL for @p's current task_group's cgroup
> + * @fork: %true if @p is being forked
> + *
> + * Pre-commit cgroup migration passes @cgrp explicitly as @p's task_group
> + * still reflects the source.
> + *
> + * Return 0 on success, -errno on failure.
> + */
> +int __scx_init_task(struct scx_sched *sch, struct task_struct *p,
> +		    struct cgroup *cgrp, bool fork)
>  {
>  	int ret;
>  
> @@ -3501,7 +3514,7 @@ int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork)
>  
>  	if (SCX_HAS_OP(sch, init_task)) {
>  		struct scx_init_task_args args = {
> -			SCX_INIT_TASK_ARGS_CGROUP(task_group(p))
> +			SCX_INIT_TASK_ARGS_CGROUP(cgrp ?: tg_cgrp(task_group(p)))
>  			.fork = fork,
>  		};
>  
> @@ -3747,7 +3760,7 @@ int scx_fork(struct task_struct *p, struct kernel_clone_args *kargs)
>  		struct scx_sched *sch = scx_root;
>  #endif
>  		scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
> -		ret = __scx_init_task(sch, p, true);
> +		ret = __scx_init_task(sch, p, NULL, true);
>  		if (unlikely(ret)) {
>  			scx_set_task_state(p, SCX_TASK_NONE);
>  			return ret;
> @@ -5969,8 +5982,8 @@ static void scx_root_disable(struct scx_sched *sch)
>  	WRITE_ONCE(scx_switching_all, false);
>  
>  	/*
> -	 * Shut down cgroup support before tasks so that the cgroup attach path
> -	 * doesn't race against scx_disable_and_exit_task().
> +	 * Shut down cgroup support before tasks so that the cgroup attach and
> +	 * migration paths don't race against scx_disable_and_exit_task().
>  	 */
>  	scx_cgroup_lock();
>  	scx_cgroup_enabled = false;
> @@ -7263,7 +7276,7 @@ static void scx_root_enable_workfn(struct kthread_work *work)
>  		scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
>  		scx_task_iter_unlock(&sti);
>  
> -		ret = __scx_init_task(sch, p, false);
> +		ret = __scx_init_task(sch, p, NULL, false);
>  
>  		scx_task_iter_relock(&sti, p);
>  
> diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
> index d76ac22019af..23fc95502ea6 100644
> --- a/kernel/sched/ext/internal.h
> +++ b/kernel/sched/ext/internal.h
> @@ -1920,7 +1920,8 @@ void scx_flush_dispatch_buf(struct scx_sched *sch, struct rq *rq);
>  void scx_kick_cpu(struct scx_sched *sch, s32 cpu, u64 flags);
>  void schedule_dsq_reenq(struct scx_sched *sch, struct scx_dispatch_q *dsq,
>  			u64 reenq_flags, struct rq *locked_rq);
> -int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork);
> +int __scx_init_task(struct scx_sched *sch, struct task_struct *p,
> +		    struct cgroup *cgrp, bool fork);
>  void scx_enable_task(struct scx_sched *sch, struct task_struct *p);
>  void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p);
>  void scx_sub_init_cancel_task(struct scx_sched *sch, struct task_struct *p);
> diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
> index 5f7ac6696d17..393dbd00d2f7 100644
> --- a/kernel/sched/ext/sub.c
> +++ b/kernel/sched/ext/sub.c
> @@ -906,7 +906,7 @@ void scx_sub_disable(struct scx_sched *sch)
>  		 * parent. A child can't directly affect the parent through its
>  		 * own failures.
>  		 */
> -		ret = __scx_init_task(parent, p, false);
> +		ret = __scx_init_task(parent, p, NULL, false);
>  		if (ret) {
>  			scx_fail_parent(sch, p, ret);
>  			put_task_struct(p);
> @@ -1212,7 +1212,7 @@ void scx_sub_enable_workfn(struct kthread_work *work)
>  		 * As $p is still on $parent, it can't be transitioned to INIT.
>  		 * Let's worry about task state later. Use __scx_init_task().
>  		 */
> -		ret = __scx_init_task(sch, p, false);
> +		ret = __scx_init_task(sch, p, NULL, false);
>  		if (ret)
>  			goto abort;
>  
> @@ -1336,6 +1336,99 @@ void scx_sub_enable_workfn(struct kthread_work *work)
>  	cmd->ret = 0;
>  }
>  
> +/**
> + * scx_cgroup_task_migrating - Prepare a task for a cgroup migration
> + * @ctx: migration being prepared
> + *
> + * A task's sched must match its cgroup's owner, so a migration that crosses a
> + * sched boundary re-homes the task once committed. Run the fallible part here,
> + * before the migration commits: initialize the task for the destination sched.
> + * A rejection fails the cgroup.procs write.
> + */
> +static s32 scx_cgroup_task_migrating(struct cgroup_task_migrate_ctx *ctx)
> +{
> +	struct task_struct *p = ctx->task;
> +	struct scx_sched *to;
> +	int ret;
> +
> +	/*
> +	 * Cleared under scx_cgroup_lock() before root disable starts tearing
> +	 * down tasks. As cgroup_mutex is held, a set flag guarantees that the
> +	 * teardown loop is not running concurrently.
> +	 */
> +	if (!scx_cgroup_enabled)
> +		return NOTIFY_OK;
> +
> +	to = ctx->dst_dcgrp->scx_sched;
> +	if (scx_task_on_sched(to, p))
> +		return NOTIFY_OK;
> +
> +	ret = __scx_init_task(to, p, ctx->dst_dcgrp, false);
> +	if (ret)
> +		return notifier_from_errno(ret);
> +
> +	return NOTIFY_OK;
> +}
> +
> +/**
> + * scx_cgroup_task_migrated - Re-home a task that changed cgroups
> + * @ctx: committed migration
> + *
> + * Move the task to its new cgroup's sched, which scx_cgroup_task_migrating()
> + * already initialized it for. Can't fail.
> + *
> + * This is safe against all phases of the destination sched's destruction. A
> + * disable resets cgroup ownership to the parent and re-homes tasks in one
> + * scx_cgroup_lock() section. If that section already ran, the destination would
> + * be the parent. Otherwise, the re-home loop is still ahead and guaranteed to
> + * visit the task, now in the destination cgroup.
> + */
> +static void scx_cgroup_task_migrated(struct cgroup_task_migrate_ctx *ctx)
> +{
> +	struct task_struct *p = ctx->task;
> +	struct scx_sched *to;
> +	struct rq *rq;
> +	struct rq_flags rf;
> +
> +	if (!scx_cgroup_enabled)
> +		return;
> +
> +	to = ctx->dst_dcgrp->scx_sched;
> +	if (scx_task_on_sched(to, p))
> +		return;
> +
> +	rq = task_rq_lock(p, &rf);
> +	scx_rehome_task(to, p);
> +	task_rq_unlock(rq, p, &rf);
> +}
> +
> +/**
> + * scx_cgroup_task_migrate_canceled - Undo migration preparation
> + * @ctx: canceled migration
> + *
> + * The migration failed after scx_cgroup_task_migrating() initialized the task
> + * for the destination sched. The task stays on its current sched in the source
> + * cgroup. Undo the destination's init.
> + */
> +static void scx_cgroup_task_migrate_canceled(struct cgroup_task_migrate_ctx *ctx)
> +{
> +	struct task_struct *p = ctx->task;
> +	struct scx_sched *to;
> +	struct rq *rq;
> +	struct rq_flags rf;
> +
> +	if (!scx_cgroup_enabled)
> +		return;
> +
> +	to = ctx->dst_dcgrp->scx_sched;
> +	if (scx_task_on_sched(to, p))
> +		return;
> +
> +	rq = task_rq_lock(p, &rf);
> +	scx_sub_init_cancel_task(to, p);
> +	task_rq_unlock(rq, p, &rf);
> +}
> +
>  static s32 scx_cgroup_lifetime_notify(struct notifier_block *nb,
>  				      unsigned long action, void *data)
>  {
> @@ -1367,12 +1460,42 @@ static struct notifier_block scx_cgroup_lifetime_nb = {
>  	.notifier_call = scx_cgroup_lifetime_notify,
>  };
>  
> -static s32 __init scx_cgroup_lifetime_notifier_init(void)
> +static s32 scx_cgroup_task_notify(struct notifier_block *nb,
> +				  unsigned long action, void *data)
> +{
> +	struct cgroup_task_migrate_ctx *ctx = data;
> +
> +	switch (action) {
> +	case CGROUP_TASK_MIGRATING:
> +		return scx_cgroup_task_migrating(ctx);
> +	case CGROUP_TASK_MIGRATED:
> +		scx_cgroup_task_migrated(ctx);
> +		break;
> +	case CGROUP_TASK_MIGRATE_CANCELED:
> +		scx_cgroup_task_migrate_canceled(ctx);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block scx_cgroup_task_nb = {
> +	.notifier_call = scx_cgroup_task_notify,
> +};
> +
> +static s32 __init scx_cgroup_notifier_init(void)
>  {
> -	return blocking_notifier_chain_register(&cgroup_lifetime_notifier,
> -						&scx_cgroup_lifetime_nb);
> +	s32 ret;
> +
> +	ret = blocking_notifier_chain_register(&cgroup_lifetime_notifier,
> +					       &scx_cgroup_lifetime_nb);
> +	if (ret)
> +		return ret;
> +
> +	return blocking_notifier_chain_register(&cgroup_task_notifier,
> +						&scx_cgroup_task_nb);
>  }
> -core_initcall(scx_cgroup_lifetime_notifier_init);
> +core_initcall(scx_cgroup_notifier_init);
>  
>  static void scx_pstack_recursion(struct bpf_prog *prog, const char *op)
>  {
> -- 
> 2.55.0
> 
