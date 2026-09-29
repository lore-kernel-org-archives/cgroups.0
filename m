Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E753E54B1AA;
	Tue, 29 Sep 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703375; cv=fail; b=JgLEcpYK3o0ODbSh2ngMPEFgGtsZbpagPjG5x6xeqJWY+IzjZDlVpZil/7Qbff5lHUH+X+ktUepv8MbQ4K0qBPlcpjNFfCHjDBSh6gIeund6g9mAFoDGL1PEOhh9aAv5BMGIN5KFSFcdQ8BYQc19s9Q6w/2jrlfi/rS6qkGJ5BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703375; c=relaxed/simple;
	bh=XWh8y0YyinBWDiStNXhPkErwoDqMYtsO8li9myJ2vpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BE5aQtKQ6ujLFWSkCSm5p9HDEzmGDflGXRYRr0nqfTiY2VKZOQEp/8MV6UV/sPN2nl1Av5YAUhIl9ytkLJCy3wzg6O6JUpplYl9q3h3PkTZz8StRGWkFHASQ7qrNiDh82aEQ7/bKBpJg7+q84ZOHIIgkuLWRjAJE4vpHWUmgfMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d5ugpvmV reason="signature verification failed"; arc=fail smtp.client-ip=52.101.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d5ugpvmV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=td+1/yQlk4VjYKrfHXjZZ7v7vDDSGnwJE+uL3ohT+iMTv4L9LsxnX2+eQi+AQq9QoO4QoaoVQbMeWFK+8xAOmX9JF6gpbZk4Nv1ZQQJHlg1P4V5oPYP1fA8Zc4t258MN3DUWbXiol+BtMnVEEuFSBHnLbOXgPy7mDnbgA15PqJFXacZ7gdLQ9gjcbLj4HwxVEKcYn4FsWsOupXeQ7Syin0utnZbveIqYgL0cS6NZO7Qunuqg0Rv3wbV0XMiD8L6skK+c1bO2bThdEsgdGyDYcHd+qbxZKNxZ27oV/W5vanIaI9VT7XzFV1KJEsacAZ8ofXoKig+hROHxOXbQKP2AnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7T80J5U2+Qrjb0qePczu5/5S+RVz8/RukSA/r362eTI=;
 b=wBZQd7ZSCvK28aRbkJDfUL3CKLftmhiOyUw6uXm0mL9ajCIIJeU2hIh8BGteYnwATVu5fM5bK5Qih2655nbkqqfTkQSpD+Bw5jJnRPqgVn4EAefP48ixr+jMg/+XSMOXhptabpTZIg267NzKP3sbLa+SW45eRXO8zsZ1F4i/Xvxoi4efvr7WPsgaeRFzdFsVohsf+Ranz2crQRUPRY/HoiHRheu01FJg6ppkvc1+Tsz74beWI5fqRp6w32PT52Qa9xQt0TyBg4vAkiBYnNEOzprtWyQs7C2ATH9xrkR4EejFZpXhqWyZJtagOB6pdbRdE3h7/qMBGG71gy6pMU75Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7T80J5U2+Qrjb0qePczu5/5S+RVz8/RukSA/r362eTI=;
 b=d5ugpvmVp/8j7PjstXXLya6XwjUmQR0Cm005lskrNkLWyeJ/mKlBR/BElB0mjg8+ba1LDcftof/9n9AxIHWoWNa/GwsxKQ5VRd9qSFSGsH2eOiISI13hC5hS3oxAlBOsE3V0AGQcB9rbEFaCcIKSXzsquWrTb/vWrbn0vkCLic718f/4X6wdksliLqMDXm2Bv3fowRt3RIZyF7oVkMs2C100ti/K7LMrpoOv6qH7YQDkEl/e/rVzw/MxLQGG9BOtAM4ODsXCjoTwq7z1DAUk+RAEDpX8o7vb6jx2m2jXhI+Ah+XesXEf+ry4G34nHW3VqSS5dNqsVdwpl00aGP0Q4w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by MN0PR12MB6342.namprd12.prod.outlook.com (2603:10b6:208:3c1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 17:36:04 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 17:36:04 +0000
Date: Tue, 29 Sep 2026 19:35:55 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Waiman Long <longman@redhat.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
Message-ID: <arv2-3-6-Ewv0gpb@gpd4>
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
 <20260929-making-language-254d9c6a6605@there>
 <af938567-01d2-4518-8f7e-974828e25d3e@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af938567-01d2-4518-8f7e-974828e25d3e@redhat.com>
X-ClientProxiedBy: MI1PEPF000008CC.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::43a) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|MN0PR12MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b0e1a7-7de2-4020-fdb0-08df1e50229a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|4143699003|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R0o6Stx3ZXuvuhU8k1bOx7W00mSMAceFPRzua8qOgskB+6fddu1yYRVLMZm2zhX3zgTZHgyJzZ/dFbcX91ncNr8th7MO3SNyvHxxLOV1mhQHm7lGxwB5E43oiwWjMIt8TaQslVlnSu+zXXaFvJ3Llbl07QY631hA/jRJFBeQA0jfPQlOXXueLTfYZL9e0EAB0/m9ZnfDAxXEMlxX29xnDDw1Q4xZE2rFwVKOj58WSdB98mfXNhRYKLWknXZ3U3USfCHjQ02CTUZK820DyripHdT4Bu1C7p9eQuoWzPcoR8s/BUx/7nFEM4XVFEbgRLrsVnGYHp38aSrgwBMuM/qir6TZygS/2xyxLULYaMvB/l3CSF9bW50S1S+9nHPl43Tyzdy8V9Y6dvmWFMt1X6Fqcq+dAvz9jHQvBHPe6DrspYNCXwUsBgXWbdu3tDObJVLTeMEFvARRzROOnXtcrsRvWkgk+Y1mr1XeuV3wbBX3X9Lo1wUoz0B636rq0BKfvZf+agVYBL4f4WemRFdNOpu/c+Tq86s5LjeNluXT7r6+UmUQJ5Jzny00R0cNBQU926pHWiBgVVRn0pt4No6ejzimccvUdma+/QopKXsM6cxGt8udqrIsnkTETRgAurZO01JKm4lxkqSPkvMPiYNBvk4DzEgS6jG4FkKEOVH3IjrRnG8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(4143699003)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Kil3auTm6qnS118SClrCtRmco4irlFK1xhtiTE+hhHJbesNPM2SG9KMQ6H?=
 =?iso-8859-1?Q?nSjqNwFvgSetJVD1xyQcMfJiBYSn4l13LUUTl7+GHjpoaZiOApWIbNaGyU?=
 =?iso-8859-1?Q?U6JvrF1UPDyGBUk/5aH/0ESTsdU1eqk7HegB/LB3CE+syfshhqybGD5X/t?=
 =?iso-8859-1?Q?TdynpT4PYYdZ1dTe9HRtLu8gyr5jANHFo4uf7eGTSD2Y8gszYculNJ08QK?=
 =?iso-8859-1?Q?lYAOSA+iNTRjHj6oqvfF3o+SUBieSwQZOIeJGBqNMo8TqdzvJEGga/KzjH?=
 =?iso-8859-1?Q?mb7DtpsAWPa4nKAe9vAz4GEX1dkucMzOyAXOVqBZPBxGsjXcXsJrwbvX6k?=
 =?iso-8859-1?Q?nNRkAkgMtRqtSWs63L5ihx/zDw9IGCYbLhFqcs/5qSI0ZnCqCaXvP2fCnT?=
 =?iso-8859-1?Q?YVFsoro0W4ArsPre7/I9l64wsWPIxQUDnKXXaGcu//TLZKrM9Zn5daDZ9W?=
 =?iso-8859-1?Q?0O826V1SS1w9+r+GlDBuQrx2Mp1hkjBRIY3z0ZmwWPJdmKYNs2v+J2ujqk?=
 =?iso-8859-1?Q?pj5reo3IyEUKcrbXN2F/4CzJQmR3uDZ2/CLjRMWA4LAwfu4sLR/J5FiqDG?=
 =?iso-8859-1?Q?mnBU2Kt/mqrKoOuMWzpQvVYdRgKin0UESU2O+P+7tSLoEXOsZDBcOlZ6e6?=
 =?iso-8859-1?Q?nygHtsvUsTmUFrQLyVfgmeGQC3ZfC4JvAjq6/0FdxWJh+H9Ndqm1r9uP/H?=
 =?iso-8859-1?Q?VOrTezRCqzHhhJm430hbmw8E8BgvnjlN1a0tQhCeywENczjy5qsS7k49Sk?=
 =?iso-8859-1?Q?DKp/MXYo0wuNmDUPpQpQyxLT5zu4pOoWO6unR3zJP3OHshkiTukK3q0fz/?=
 =?iso-8859-1?Q?QKehwTDzG+6WxhI1BSwElupnRrB8HNF8wg3Ok71gcXw8sVMI83g3jBjZDp?=
 =?iso-8859-1?Q?6amZWIK6IrVifM5kEAZI6effDbEym3pKyW+vdepGtrVqcnKs/fu9K0Czqc?=
 =?iso-8859-1?Q?IJCky95bUUgB7bwJDvbz5AQ6pcBhsj1b0sz7gSVVV8cQiso78wtBdQB5CJ?=
 =?iso-8859-1?Q?rFNKXRUuDq8WzEZ2G/bi9eG0Et6kwoeTY/9j7XFse89dd2m+ihD+4+wRSn?=
 =?iso-8859-1?Q?YTxLMa9LVTK6DWhZxvSJY7Jib3KPoju9woDnrtZ3kWjTMr5EA0SCcpCm3c?=
 =?iso-8859-1?Q?2OXp+NAa4bSLKW2fo/T0seSl5D/Y2ocpabHVIg9njwumU6UZ5n5KHJ0iAC?=
 =?iso-8859-1?Q?we7R9Apk2l4jzKfkHau2QKjBcjniZRQHvzxcGKFoWbLc1B4xbf2Z+Q+9S6?=
 =?iso-8859-1?Q?zApK1jL+7OckcaGq2cP/PTfrORWtVgmW3JOGjoftna3d+uqCvDPd+sZr4C?=
 =?iso-8859-1?Q?Q4LULFLC1FAOyWpypGLybNaMvgn/znbh6p9BmuUBZoeS1eYcNrxi1SFEvs?=
 =?iso-8859-1?Q?/P3iBVbq/mR5Y6N8dnYI5Wr2Rk4LxzvpkBFMe98h4lBandsuk33VaeE82Q?=
 =?iso-8859-1?Q?V5JC+w6s32gDajIHIUm17RBhnUhBDSkxl0D9Dt89JS8T3ZiRQ6nu7dK5Gy?=
 =?iso-8859-1?Q?8FNqzXihsBb//2tz/vlfTPCCvOyyV75mgZkzSRcLzo0Tv+xzLW1vs+V0mb?=
 =?iso-8859-1?Q?HhZVDQjWL9fbOHi+jyJEpFmfQhcB8/4mcWXg4FA3WHJQrsaiISkwMog5VR?=
 =?iso-8859-1?Q?sztFaXGczhWfx48TyS1T6Z2gRbpq6XollXdveV1Bq2+RrLAd0MjztCKRv0?=
 =?iso-8859-1?Q?T6tCyeg546XksHUXrOQ1rqWWegZUVL1rtTdaWoKA2Lf5LSTTab0/7sdnOT?=
 =?iso-8859-1?Q?WIog9x25QO2eq52++oDeF3lUD6nUikIbE8LzqXfCGctLu4VF8V1QSAvHB/?=
 =?iso-8859-1?Q?9dgsr0TRkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b0e1a7-7de2-4020-fdb0-08df1e50229a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 17:36:04.0472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBISDN3MAVuilL36YtoVLVqambnIrfI3dWEmU2TiqaS27gZuyydtCvjNJLlMOwOqblbNSFoeDTuIyjNa8m0lHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6342

Hi Michal and Waiman,

On Tue, Sep 29, 2026 at 11:32:33AM -0400, Waiman Long wrote:
> On 9/29/26 9:47 AM, Michal Koutný wrote:
> > Hi.
> > 
> > On Tue, Sep 29, 2026 at 10:37:38AM +0200, Andrea Righi <arighi@nvidia.com> wrote:
> > > cpuset_num_cpus() enters its RCU read-side section only after checking
> > > is_in_v2_mode(). When cpuset is bound to a v1 hierarchy, is_in_v2_mode()
> > > dereferences cpuset_cgrp_subsys.root, which is freed via kfree_rcu()
> > > once that hierarchy is destroyed and cpuset is rebound to the default
> > > hierarchy. A preemptible caller outside RCU can therefore read the flags
> > > of a freed root.
> > > 
> > > The only current caller, fair's group share calculation, runs under the
> > > rq lock with preemption disabled, so it can't hit this. However, the
> > > helper already means to protect itself with RCU, and upcoming sched_ext
> > > support exposes it to sleepable BPF programs.
> > > 
> > > Take the RCU read lock before is_in_v2_mode() so that the whole lookup
> > > is protected regardless of the caller's context.
> > This feels like mere querying of the mode shouldn't require such
> > constraints (despite it's needed anyway later down). But it could truly
> > happen with the novel usage (CONFIG_CPUSET_V1 && unmounting cpuset
> > hierarchy for some reason, I wonder how you noticed :)).
> > 
> > Then I'd welcome more structured approach with at least:
> > 
> > diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> > index 3754d697854b3..7f4d346cfb119 100644
> > --- a/include/linux/cgroup-defs.h
> > +++ b/include/linux/cgroup-defs.h
> > @@ -841,7 +841,7 @@ struct cgroup_subsys {
> >          const char *legacy_name;
> > 
> >          /* link to parent, protected by cgroup_lock() */
> > -       struct cgroup_root *root;
> > +       struct cgroup_root __rcu *root;
> > 
> >          /* idr for css->id */
> >          struct idr css_idr;
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 227d09704ca59..a718b5f521fb2 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -1909,7 +1909,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u32 ss_mask)
> >                  /* rebind */
> >                  RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
> >                  rcu_assign_pointer(dcgrp->subsys[ssid], css);
> > -               ss->root = dst_root;
> > +               rcu_assign_pointer(ss->root, dst_root);
> > 
> >                  spin_lock_irq(&css_set_lock);
> >                  css->cgroup = dcgrp;
> > 
> > 
> > However, if I zoom out, I see that the intention of reading cpuset's
> > nr_cpus from the scheduler is meant for setups where cpuset tree ~ cpu
> > tree:
> > 
> > | * This only really works for cgroup-v2 where all the controllers are mounted
> > | * in the same hierarchy. If not cgroup-v2 or no cpuset controller is
> > | * configured it reverts to num_online_cpus().
> > 
> > Hence it may be just OK to do:
> > 
> >          int nr = num_online_cpus();
> >          struct cpuset *cs;
> > 
> > -       if (is_in_v2_mode()) {
> > +       if (cpuset_v2()) {
> >                  guard(rcu)();
> >                  cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
> >                  if (cs)
> > 
> > I hope Waiman seconds this -- if a feature depends on shared tree,
> > there's only so much that 'cpuset_v2_mode' can guarantee.
> 
> I think it is simpler to just change is_in_v2_mode() to cpuset_v2(). Almost
> all the cpuset functions should either take the callback_lock with interrupt
> disabled (which is a RCU read-side critical section) or with rcu_read_lock()
> and cpuset_mutex() acquired. This cpuset_num_cpus() function is an
> exception. Given what is said in the comment, this function is not supposed
> to be used with v1 mounted. We should change it to cpuset_v2().

The comment says that, outside cgroup v2, cpuset_num_cpus() falls back to
num_online_cpus(). However, on v1 with cpu and cpuset mounted together using
cpuset_v2_mode, it returns the group's effective cpuset count and fair.c uses
that count in the default "concur" group share calculation and in "max" mode.

So replacing is_in_v2_mode() with cpuset_v2() would change scheduler behavior
for that setup. I guess we could either preserve the current behavior, fix the
comment and protect the root lookup with RCU; or make the code follow the
documented v2-only behavior. Which one would you prefer?

Thanks,
-Andrea
