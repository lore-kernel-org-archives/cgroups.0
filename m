Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD84473463;
	Mon, 20 Jul 2026 06:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529750; cv=fail; b=FKNKz2PfsKBO6mKS86cVJCj76TMlyuUBNsrXYupsL4VthBiFwlx2/dlROdLz+JdidsB/ry32MhVKSh2di/+Wft4dVd6pqOv6p4AwymecdSZvRyO2etAOmD7PbklBsfb/SDoimie3kWpSEI9EVC4HJ1DvjJ2e1CerYjo1ulRvXw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529750; c=relaxed/simple;
	bh=826gfcPypoUYb+3IsiSvt2rItlNZtFTIdj0e/ZddyYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TjyDtYuaHrgSWVNBc8lY0+zk7pXMgQNnq7Dtd7yfh5UjTlqqmG88wLEyFfm5DE1zxXhAovDGPExsmW4BwrrOKrCT5W//A1jOgq4HPyP2hxJMB9uQjdmhjiwdOC+MNiutwzKOMoi4rFPemtaKIzq4F5+yLjyUSkRoPNAFnLQIfxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VMhzljk4; arc=fail smtp.client-ip=52.101.53.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VMhzljk4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4ACK2+GnRmYtarQW/aku2dHX30K7qiKJ1eMR0fFYrxKXI1xPxXoAhQLOm8++ZQJVzvwF80M/dQMq+nsi7K6ihAJuaEmd3MpVx17ZnYTNWuCPEW6fCJp+p5bBg1glQ6MKPC66iGYmRHjJWCB1VG4segaIae6zl9laFRvILG83QQnpIdFLSgU4MCF7jh+hV+t5QOX7m/GCC1DruEg2sHwGvOe+dPINkJIzEB/Oe6H+yMWbv5RyBe0p0kvPNN7/p506+6kYDUyMT5agc12Kxj/Eob+8Q553pOFiG6vu3Wz6QOuc4KbK+XPMi3pffqLROdNozYnfm6HKf3tjgl4zWZ4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQiot40FXYF1wFY0SrKE570KBthgRSLsuJH+6VQSdDI=;
 b=q0UgoBdakKHyYC3c0w2reHDvYzZ45DbL3Up3kEWR5wmekZvZfQ8xSDGmQTFsuvFlQydR7NEuFk2oDRAPjA1Diq/2OUn6ILXx24GjGOmxcBVlmq6eZqQHQkuILh4beMW9+s8NoaPpZwhZEYcBmhqXkeYyqlT9xYvwZjlLsuFP7Fba+A23ZkH4ZiV4feUEH6F4I8YsaP+UaSGLrmvXTLX8izwIvx7vk8NPghiCwpEU97r0Ixfo7+8UpKZcp3C+eoc13+3GyX9h4vnWh5zLbF3+Tzj0LQrS+97DlKtDzv8X6nx9ZZbEyLCcQb3SZnaJqiiFLM5EQRQMTXAFFlERmV85QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQiot40FXYF1wFY0SrKE570KBthgRSLsuJH+6VQSdDI=;
 b=VMhzljk4WUTz5UGS8IOsFNk8g6dfjOmJ48fmKv0Tad5CBqdK74Rq5OodXx4BbaX4Nv4GI4Vv3fVpeHs/zw8YtCVnUj+KhTjOV+ALpqxe1JyZaKFHovqF/C0xg8Y9qDFB1UiOJeQbEW8kR0+IzUQl6FZ1vku9Rnb2bDH6B2ln0shS1H2Eks6sAzDu0VIP6kksx3JBlZKsZ3lK7ExNt0MeEwX+UETQVCfYBKUbSHdlu8BQVS6Kwh3HNlbPpBA2JNcPtYxiY5C8LgdSqEYqwVfIFv13YGdVxLDd2gja25AvzeZtK+VBsv4k2v3Iw9vH4gH3ze9ALaeQatjVlPSueoc5NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by SJ2PR12MB8034.namprd12.prod.outlook.com (2603:10b6:a03:4cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 06:42:24 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%5]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 06:42:24 +0000
Date: Mon, 20 Jul 2026 08:42:16 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
	sched-ext@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched_ext/for-7.3] sched_ext: Cgroup migration and op
 delivery for sub-schedulers
Message-ID: <al3DSNiAviqdkqZS@gpd4>
References: <20260718081727.582037-1-tj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
X-ClientProxiedBy: ZR1PEPF000077F0.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:918::455) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: e538dffe-9f34-418e-f3c7-08dee62a0e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|18002099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qt8oiy5BV8v/GtoPCHZnl/+MAW8jdR97Fyb/lehaewBdpfOF8oeVlyDgnM99ans2Q2DYIPaEDHbbYO81W4r2JR05tK9IkcmBcpd+BvIYFVTFpjxOX3PFD+5ggINsDFsrquiwZVvMTcpRFRhYDo19wp86e7NOlaK+0CiYUE43HVzBRR5yVNNZch89lGgHXJHFxgBa0fsoDsvGUR6XLI/rDcsnaEx7RsZU0mIJBeEh+jv9x12uz6wRMsHab7z8or6IZacyWOF15X2d/sUcGXvatuLwND/ytrnjuO51MJB1od56qQIPLtJG7lnESzcXifc+RX2Yl2+viXjff90O2zS4UTEE4VrWqxAVdcrnv7WTjooLhhHXeaxVAwQFxFNDQFrUwY7XrTrp/zWdI8YPTL4Mh7bZdOtr/bwtB1chwL4bCJAbSJ+kOQtvubeWPxk2gIyZmqXtGqRcuUhvDrclFV0Lr+uvpNT2SRnI+Eieyi0jOZYQyb+nTHUtZwHBn2BCRjWPHb32rzCWKSlVbVhu4EzF8XKtPPgYWmNKMMcyj4fIyY3tiTMe7ay5246k76fHOf5h4qxjrTIq3yxEUBZOo1JPs7rUGgpxHUtq+MBfkZTIDSJKCwfkEy0FwvPvIAH57Zx1b1If4LWqPyVGlqsRlItuXKbJcVYTneoBNyg57ziKYhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nkP1/tjksEpLZ6in+D41lwRA26XExdOik3YOzIg81+RXTdcLIzHGnfZXYQ1P?=
 =?us-ascii?Q?7Te04Cp8Zuq96y2lRs1oy+gghvMb7t0+9GcPfQckw/cKqn1ln4JvqCohsow9?=
 =?us-ascii?Q?UdRo++QpZQJWpBQvh2oVjeT2TzljLRJyPtQYGKNeAJ2m7UWpcgM4R70nQquI?=
 =?us-ascii?Q?ra4SiSpsxuhbKQQUfRVsHpyp3E8x+Aq4rR8UkYhu5aYoUp+CDdQbXgniRuBY?=
 =?us-ascii?Q?ZGHaokBBY+K0JUHaR9PsjQf9/Ls15rfMTsUK4r3W1XtidST5jmpJZ0gaiSrz?=
 =?us-ascii?Q?ZNwA/WMc65aQ6NPh2rBfXnsKgbSLSi31YN2dpTKdg3eleqhyjnP80UcChbpF?=
 =?us-ascii?Q?2upx3UUcL8VbDHq4OdUsWFfhxRSaZlu0LhBR1DufgdM2k6o8e/Xd1utTBjhN?=
 =?us-ascii?Q?vVCpRce89+O7SRZ6bLbDB2q0t7SkdR5nMk6iL1/vEEDvS7seJnKhwrsVCFuh?=
 =?us-ascii?Q?7BLrV4dyc3spQCOwxI4h5GJ0eO9bjWbTEViE+NVLi8fZPTc3fuvOHl3t1rO1?=
 =?us-ascii?Q?Y48oWKANvwbmKWnWJzQwwJ0cpNLESXt+zKiVFVFB780q8BJkW7e/u7x7HfEd?=
 =?us-ascii?Q?CvJgpi3MSDaD/u5OwoknuH4NqwHQ8Iih6I8FmIBQ3UwImoATgD0Gxm8zPySy?=
 =?us-ascii?Q?kDXa1WK2Uvt1PyDWpm7nOjmp1Eg5slsLcILLMpG4bZkWfFJ7EOYFaIY+8McR?=
 =?us-ascii?Q?uTR4wKlx7UPVy2VclCZ+vKA1TkawwnjCXpbjlOIv0FlX/6Ydp5zRHLZdHpog?=
 =?us-ascii?Q?imZkN37NsOWs95Y6UILIzJcSEHgP94GsBu/waWnLt808fzkct6A+pKly+X3D?=
 =?us-ascii?Q?NYKvgDWvFVnO9fhj96MNFxsTKHR3CEN7TQGlf/UlIadU0iLRtzN9vqyQjSUr?=
 =?us-ascii?Q?pobpC6qXZ3F+FWLJjBcSmyQUOnuzq/gs+KGawusZanvMpb6JbQEb9Qf40eWF?=
 =?us-ascii?Q?b1DOLHKKWY06Kxwoz7sTrV/f6L9nP0g8Av16dlydUFwFxbFaJs1u7nf1xxOl?=
 =?us-ascii?Q?BnZXU2KZ9SVGW2PGZXLEZPgEVbUAABAtp8KlkP9k13OCca891GFGSOEq4yEi?=
 =?us-ascii?Q?4igqrazNITljc0KGQXzGOKeoE0r9npB6dPxod3etUdvOpxzGJJoz/QRMfaub?=
 =?us-ascii?Q?RrLMEAwOCjIiuitgC1FUtJYNWLnFSBqb9dOoJuwv0gItLESGuT+gYcWtqrN+?=
 =?us-ascii?Q?hn9bf9FqXd6xaw27UKKB6rWG2NaGGe85xQh+sXveG1nlux4SgR7MX9wkCFTp?=
 =?us-ascii?Q?yRb0Bxgp1jqjxOes0AIxDr+1bv/NP2qCEND/dlw5Bi6lsN3zyVePk7yRFepd?=
 =?us-ascii?Q?i0l8oOIhAdSuyCkPtm/EJfsEWVGIY23WSa5RtpPrDCY2ItzldJcWgAb22pTF?=
 =?us-ascii?Q?TCt3xixMc0l3sclPECtbi4WuutHlY30Q+WYFcqX6TI8Ozp4oDpcWeZsazUPd?=
 =?us-ascii?Q?nKAMrAjO/YlP97p1KD880Ai2EIubzWDJRNbhKy8hZ3ga7o9TStL3XD3/2vXM?=
 =?us-ascii?Q?DtWp7VLL/4pr923GgIKq+2OhoGhfZ4f4/P2SZFOpwjyFoAPVdwRHc8Tt2O/H?=
 =?us-ascii?Q?UXUqVxdrCvBXUw8xXrjaIH7tc9/EcAGLFr7AMvpOZASvPOzAAFNB1NxSC4r8?=
 =?us-ascii?Q?7QA6ddkJtBbrtf1XcVDA9MlhWn2Ww16zQ/4zC1P+SWpce9JGXKxRgdyLcu7L?=
 =?us-ascii?Q?hyPH8FvPp9AnmMfcMzJo76OiwRyNEYjhVgXKMhkJ0hXJu9TZOxmZPF7IjAt6?=
 =?us-ascii?Q?91/XcUMO2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e538dffe-9f34-418e-f3c7-08dee62a0e77
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 06:42:24.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TYeT9365okS08g+QW7ZCeM7Ai49Lgq7F6wtEj0oYhqqNdu8JfzTUGiWoSb53eV0x5juZE2CKPo5b4cyCyVwCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

Hi Tejun,

On Fri, Jul 17, 2026 at 10:17:19PM -1000, Tejun Heo wrote:
> Hello,
> 
> A task's sched must match its cgroup's: each sub-scheduler serves the
> cgroup2 subtree it is attached to and the root scheduler serves the rest.
> Cgroup migration currently breaks this. A task moved across a
> sub-scheduler boundary keeps its old sched, leading to wrong-sched
> scheduling and, once the stale sched is freed, a use-after-free. Cgroup
> ops are also always delivered to the root scheduler no matter which sched
> serves the cgroup.
> 
> This patchset makes both follow the sub-scheduler topology:
> 
> - cgroup gains a task migration notifier (0001). sched_ext uses it to
>   re-home tasks whose migration crosses a sched boundary: the destination
>   sched runs the fallible ops.init_task() before the migration commits,
>   so a rejection fails the cgroup.procs write (0002-0004).
> 
> - cgroup_init/exit and the knob ops are delivered to the sched each
>   task_group is on. The move ops go to the task's sched, only for
>   migrations that don't re-home it (0005).
> 
> - Sub-scheduler enable claims the subtree's cgroups from the parent and
>   disable returns them. A parent that fails to re-init a returned cgroup
>   fails in turn and the cgroups move up the chain, ending at the root
>   scheduler (0006).
> 
> - scx_qmap consumes cgroup weights through ops.cgroup_set_weight() and
>   gains fault injection modes to exercise the failure paths (0007-0008).
> 
> Verified with a trace-based suite on the demo scheduler covering op
> delivery and routing, handover failures, multi-level punt chains, cgroup1
> and stress.

I left a comment on PATCH 4/8, but overall the series looks good to me.

I also confirm that, with this applied, I can no longer reproduce the
use-after-free triggered by moving a task out of a sub-scheduler's cgroup and
then terminating the sub-scheduler.

Reviewed-by: Andrea Righi <arighi@nvidia.com>

Thanks,
-Andrea

> 
> Based on sched_ext/for-7.3 (7c2cd767705d).
> 
> Tejun Heo (8):
>   cgroup: Add cgroup_task_notifier and task migration events
>   sched_ext: Factor out scx_rehome_task() and scx_punt_task()
>   sched_ext: Relocate scx_cgroup_enabled
>   sched_ext: Re-home tasks on cgroup migration
>   sched_ext: Deliver cgroup ops to each task_group's sched
>   sched_ext: Hand over cgroups at sub-scheduler enable/disable
>   tools/sched_ext: scx_qmap - Consume cgroup weights through set_weight
>   tools/sched_ext: scx_qmap - Add init fault injection modes
> 
> Git tree: git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git scx-cgroup-migration
> 
>  include/linux/cgroup.h         |  26 +++
>  include/linux/sched/ext.h      |  15 ++
>  kernel/cgroup/cgroup.c         |  93 ++++++++-
>  kernel/sched/ext/ext.c         | 247 +++++++++++++++++-------
>  kernel/sched/ext/internal.h    |  44 ++++-
>  kernel/sched/ext/sub.c         | 418 +++++++++++++++++++++++++++++++++++++----
>  tools/sched_ext/scx_qmap.bpf.c |  95 ++++++++--
>  tools/sched_ext/scx_qmap.c     | 110 +----------
>  tools/sched_ext/scx_qmap.h     |   5 +-
>  9 files changed, 819 insertions(+), 234 deletions(-)
> 
> --
> tejun
