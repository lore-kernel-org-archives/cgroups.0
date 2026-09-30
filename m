Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D575F30C147;
	Wed, 30 Sep 2026 05:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790746746; cv=fail; b=CLuoqbVFrbms1PPKe/nQ2A5J2JLrZtMLvVcv6+s5puofMw4H1HT6Hnmm7yJyPsBLb4kUkYsvZ6bwcrHP3MA7H8CQZN+I59wkSMo4t5f2ayc5b9fYdWkYOqv/6awC7iqRpMMX2UX+MgGZANKrshdMaiU2Gg+FzCpfMuBnLRGLxq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790746746; c=relaxed/simple;
	bh=ZU1mzj8jTyPXRt6osW9UBy0t6C1MLxHS+mriSIths9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TWO2z83ndjaIPd4q3p+qDq3VIeN5DJQ+ifuAvWB66TCOe4VrhG3TVqorGpeDtXHjlgoFr5WwfoBkUmkdcnL6x3j+UoVZSX+ZElOyZherzvnhei+kH1dAbsa2QWhHjIxMdldeqfrcMI42sgHNquyvOTHKC/PnO3ByD3d7qVW8iOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n3vrbbfn; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n3vrbbfn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBbkP43sRD7ElAcwmFd8bhowfMw8uK4GP/5jqntPBxTq8RpF67hjSKiRByJ6ienHa4YOANcAOZC/XLsaY5axoxPFyk4we6XCIuTRb69F98cLASFllXhoS9Wa00rqjAkjj32xvwHQDdESkq92KTKh8fDed+eXTWr2VuzeSU5QLPF87YSDnorBaoIZWuqacJPJVOBHd3yazUw/L6ahdCKYolrjRLpk+n+U37ZAgVgsJkc+kzr1Y/9C4Wm71aHYEajZ9dgrW4ELzXMoSyMoo64XilyemuUY0IDKP1FpjmQZPVDcddWHON2tp61e5vH4A14HgyVgbmQ/MO8EhaZdxHqnQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXSXrRY55bYTEE4Mhxd72otojqjKelUyD19Kjrq7C6A=;
 b=LbxvaCJJ/6Z3jcQ4HsHg9AS2PRcLR1+YDWoPjSWLDMUowlboDa9Br9Ghsls0xqnuzygI5SQuW5riGMlrdfP0pdUqpRUWRH3M3f31m0GcF3ume0FKe+VeYV5NWsvTt3KORYTPY/CrZUCRtYPbdjJDe2LxpRO2caLx63WI/KnPF8uOy1G4cE71jne51/bUPhqHz88Y0RgDSG2qr8g46hlmNMeNf39ou8VHzAuKijWbb5xumFAupgkk0629NLXIGhdlmUimJqwe1oLmBreVO1x18JYtCBJq+c3nG5clYxZvuYJDeSsUD6F1V/jAAhkXGArv1uiXE4Z5N5a1Tv84Giqtkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXSXrRY55bYTEE4Mhxd72otojqjKelUyD19Kjrq7C6A=;
 b=n3vrbbfnKgwTfA1F7TJgVHfbdsOTPLhwCIpxUR670GOCqYaS+zaD85Z+MlceX9zVjzHq2hOgdcVqueitd283//HkQB2xlXvrpViNRhWu0zW+e164A/twwXMxGUgo+aY7miMvhy3lVgZNiDkDusvaC1MN0Hb1J2vYhrYOoiwr/b6aWGjh9+dJLx/GZ0jYStBd7yRFC1JIu0WqQSQoYiK+5tUKD/yF4exF9QaztuCdq+m/ODRV9uNAyOKQuB608vnxfVOrngte/v8MNjEHMTZdEeLMjFi4MJoXACZV1/lf9vC+3itBS8eMegaiqZWIYQMaC4K3CmdA/ZGquw8PaofaRA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by PH9PR12MB409658.namprd12.prod.outlook.com (2603:10b6:510:412::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 05:38:59 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 05:38:59 +0000
Date: Wed, 30 Sep 2026 07:38:48 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root
 in is_in_v2_mode()
Message-ID: <arygaJCJv27q_dUP@gpd4>
References: <20260930031833.660267-1-longman@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930031833.660267-1-longman@redhat.com>
X-ClientProxiedBy: MI1P293CA0030.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::17) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|PH9PR12MB409658:EE_
X-MS-Office365-Filtering-Correlation-Id: 42bb6e0b-ad26-45a0-b0ae-08df1eb52057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oOySIcZhIeowdc1QuEStq0WcCE8GBaE/s3/0MOkYwbHIGPtn7SQx3XfsHE+PvJAkTpVKBIR1miimHffDEk7ZSpM/QJHSUR5+y5hTTaGVLJT9CRD1y7bGssyCPv1D6o/TMY7OmR+aZP6icxmOGuQzuxVsbZ2WHZE2//mNUZjhTGWHNhjTbPMnsch8uMRUQHdXOrVvuMFTXUVFvAWcelsp/rsZQK0uO1E+FxJ2O/B897xXnVJoYKy16ur8LKA3vzzyX2aM1INn7VRGqdpk2lAu6CL6VvPLjIj1nHAxA6EZzkc+/NsIYmCbLXFVpMwfpT6sNVLb80Ouz8lB9UdvoaTYhbNlIIOdxt5tK+fzKeco88LPi3SgYaPnneQTcTgeLpreiwubXiHVn3w99PRTojILl0NBzDJQ+n7svK0N3X/y7Hk2xOZYjjw4ok6E3xFgWdCZXLh8OlUTw/nlImHqhXndolKvuxew0QMF/R6AEgwIAm3FL6vjdJFUMPf68JBcmXXzwkPBtpk5Q5xZvXkGSzJB1tA0EWqeileclPBw8KAHDIkuPi/cf207E2V388QT82FidfnDnDbYoxMaXLa3hWDpU9WN5Joo8n6JfTEZPLgxlD1euH0QKRPL6pM7rJLEueVI7c6q0BjAYYcOkroQqXXYrgRKYsuNh2Be9ZQu/Xi7tzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mR6BmfJ7D+3Y6a91rPZHNHAyOKRM+aFdxbEUpqOa81ZSfPVdlMJgReAwcOMI?=
 =?us-ascii?Q?JCJUkXJiGcq+/mVbdFSoUwVKKrJMWRd85eYwoaQVXS0ZFfDASVkBAyBrVhTh?=
 =?us-ascii?Q?GPtXeMB4Ib5HpBJ9Bwk0WmyGJxOg4cYiAfS1MHqIz7Mpt5uP3se1qikxzpkZ?=
 =?us-ascii?Q?z05HxW+cl2Tx1oBNlXf/GFB1Gxps3UB3J4MtxcmxdbFzspr2imSMDELY5pUl?=
 =?us-ascii?Q?yBHW9WzanGRjCcIyNpwtx8n5m27ZkYyxytEiC8+eaXBrg2NeCGdld0B5a5y8?=
 =?us-ascii?Q?5Hl8jei2/Q+qrF9gZm/3WXpDQVPHzkPrkK4MElkgQFXhpypnkRdhWFOQ04iK?=
 =?us-ascii?Q?P2Io0FKsgbKgnKzJCbN9DDtQI6oqEEFwOLERb2hzja6dO0ZawzzO8OBJOS9A?=
 =?us-ascii?Q?NsDIjYhZbU7Mhd97ywqIwnU7wZI4I9M4TAm+bYOB42v22k95NTAPeP6MDMpo?=
 =?us-ascii?Q?okzSUEBX4Y7rqV0nvuD353D09WLoyHc2Qf0bveTKpSb/tyk/42zMzEcbHulg?=
 =?us-ascii?Q?IWLXit3tv/9DuhaqMLNG9W9/+3Nt2LcfEZvCZRduU07DFklc1Mu8uawW/DvV?=
 =?us-ascii?Q?2kQCfE7OfEZViSqxwmojFjNlMFW2ZWR1t75Q4MdPh3LyAX+5BKlhMugSPPvb?=
 =?us-ascii?Q?x0bS9hV5hkfQnqADHUZcSI15amkIaNqtQe7rB3bQV2dL2QbbZ1HDZmgOhSK1?=
 =?us-ascii?Q?VYDGnNVMd7wsaPYI8yJyHpNVNW+4VRqzErVcJjdO3+NNAYF9h4wSGEeDIfv4?=
 =?us-ascii?Q?UM3qTY9ebHBZMNcW4QWjTuX5iTeQ4Jl3AAtfWng8/HuV9w+KdUK3dOGxrTDi?=
 =?us-ascii?Q?XkEtf9ysh6boAmHxmV1byyMTRPuf5q+pkDv0ZpRZqVYSJf+qEIMRjooeJkbD?=
 =?us-ascii?Q?/9wzgEq1pXqwTN3OMl6rcWvyzaSAaxzSCfhK5VZ5AYNjiXZqUXo1Wb36c+H+?=
 =?us-ascii?Q?xiwdm2GDX5x4W3kFJEgGVIXFngOnRSKtP0KcEstjhaNgEwGZxUFZ1AAOvvmK?=
 =?us-ascii?Q?aMN+cOZ8gjrgpX9F68VrnKf5O10klZpZjimJSotvN+OXh0CmBgldD127gg0y?=
 =?us-ascii?Q?B9gVMrWl7m2WYcb6AvjrMiDKi9XUpq13OARs/7FA45G4Y27rVLQGHN49AyWa?=
 =?us-ascii?Q?ntSuSKriDupxksX9iXxtr+oWINb60C6azLfWlUmKouy7asWG4Ac4S2fQNSjX?=
 =?us-ascii?Q?2zGo+zThwnfY4oVBDDQ00vw+mRiMgsxhcj86rxsktR7VwhjY10G32o1nu+Np?=
 =?us-ascii?Q?AK+QCANQEOvDpyYp9aOlD331fHLhlYHNHZiNNoA42m8EjzCFZO65VNh5sXY8?=
 =?us-ascii?Q?FIYUTOZq3V593M7Da3St3lfdIHvwJuk5PTFCa/NQAgyWXsaia+bs0uQoSaPq?=
 =?us-ascii?Q?nVddinuttWA08zQlMB4ECjDR8PmBE39r966LrZXA6ccx+PAnbX4vtWbGUVwe?=
 =?us-ascii?Q?phqeTIFrYZ77ERyQTRKV3xCRZ1rm1+YUNite/hS1PSHe+trLnuv7P7gu6DOW?=
 =?us-ascii?Q?6fYapWODthAN2ovfbqymkE6wbATqFd6LjNE1YA2Dw+TAXOMHawIeyRbFtQ1e?=
 =?us-ascii?Q?nhm73GorrwoMstDH4KdUDyo9E4EHoxMSgBR7S+QTYOKlMobshuiag3Uapnlw?=
 =?us-ascii?Q?i1XpWYbRWpzuLVJsfzTqBV/t1+SD/zx3l2OSMOmW/DMr7zV8RSFpS/ikRO1U?=
 =?us-ascii?Q?ix52xFlWaBnQrFF5LfjKOXn2p4lqqLcXNF1K999QVzNKzjQYsaX8sIqRQZ+j?=
 =?us-ascii?Q?Mk1rBUD2aQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42bb6e0b-ad26-45a0-b0ae-08df1eb52057
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 05:38:59.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBZEV6JVWy8nDIuNDTqGIbj/7HSpVKqw/nqoKp/ZAOgViF08ABaKH38d3h9a54p2n+oITWfqBNfYsN3I8zyt9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB409658

Hi Waiman,

On Tue, Sep 29, 2026 at 11:18:33PM -0400, Waiman Long wrote:
> After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
> me realize that is_in_v2_mode() may be called in a context where a new
> cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
> pointer. Avoid this potential UaF situation by adding a new cpuset_v2_mode
> flag which is set when the cpuset_v2_mode mount option is used. This
> flag is written into only when cpuset_bind() is being called with a
> stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
> modified to read the new cpuset_v2_mode flag instead of accessing
> cpuset_cgrp_subsys.root directly.
> 
> [1] https://lore.kernel.org/lkml/20260929084124.626693-2-arighi@nvidia.com
> 
> Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
> Signed-off-by: Waiman Long <longman@redhat.com>

This works for me.

Reviewed-by: Andrea Righi <arighi@nvidia.com>

Thanks,
-Andrea

> ---
>  kernel/cgroup/cpuset.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> [v2] Update the comment as suggested by Ridong
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 19661df6244f..4a2b6f154609 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -152,6 +152,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
>   */
>  static bool		update_housekeeping;	/* RWCS */
>  
> +/*
> + * Set if "cpuset_v2_mode" mount option is used
> + * Cached at bind time and not lock protected; accessed via {READ,WRITE}_ONCE
> + */
> +static bool		cpuset_v2_mode;
> +
>  /*
>   * Copy of isolated_cpus to be passed to housekeeping_update()
>   */
> @@ -439,8 +445,7 @@ static inline bool cpuset_v2(void)
>   */
>  static inline bool is_in_v2_mode(void)
>  {
> -	return cpuset_v2() ||
> -	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
> +	return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
>  }
>  
>  /**
> @@ -3664,6 +3669,8 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
>  	mutex_lock(&cpuset_mutex);
>  	spin_lock_irq(&callback_lock);
>  
> +	WRITE_ONCE(cpuset_v2_mode,
> +		   !!(cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE));
>  	if (is_in_v2_mode()) {
>  		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
>  		cpumask_copy(top_cpuset.effective_xcpus, cpu_possible_mask);
> -- 
> 2.55.0
> 
