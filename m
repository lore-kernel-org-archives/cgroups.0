Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608FE3C09E0;
	Wed, 19 Aug 2026 05:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787118573; cv=fail; b=SKjFZOJtVutGJi4ztZQ+xoJs5+K9OmDtXkPD76YgfK69a36sXPYWdHitN7fRCOdyRXY4bq2mZJW+3FIMuFFIV/JcXPDPVkoaxqhpw4SL3QpGxd62aj0YWt3ji1o4t7cgBDBA1WHuBbx+QcI+bqpsfLONqQwIDe/IeCSQeNX3BEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787118573; c=relaxed/simple;
	bh=9W5lLY5al+uRfAf/UKWxRVbjrNF9XS/8bXbHTieAVxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jhGdJoO+4ver9V/Swv19engjbzG9Ol2SnTEdUB7A6z7xQH9vN0jguug7QZ+8yzJbQSXYwqw+N6Uq9JqHAT/1l7DTtenmJ1N/5iawz5Javf8lwDoEvKZqkAlo+ii+6ltMiEN7BkX5ggQ2kB9wkL3PyJznVaddZX8oiFIji/9KYiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Nz0ini5j; arc=fail smtp.client-ip=40.93.196.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Nz0ini5j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTMcxSSPyCCcG/K1tFPUzlz0NVDBAe5R7hetDkw4YPCIf8iH+4H+5q22LlwZMbOsHO2QemXAV41t+heFCroE6J0sAFI/jWLYNR6sSiDmuiipDDsNHAVj1MkAKuXLT86et1UckQZlI7Ie/CcvW7IoRJ0ZaRpj2cZSXDq4IEsWmNWvTSyQEO3/ztQirCDJNxg/ePcstSO+MgJ+X6Doy8tDkMLB9PnGXDeVfm3Dh6t2KFBCBis5EDZ5L091wEEaVpKLjeK7Gjn40mswtMk0px706iQK2cDtZmDRep9JhshcJJ6XQGE1BPzLxx/uC8aUf9AYRIz7RLR2F98zERQg6B/lCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMYvKorHiY4fYdhmS1QCO7XFZx0OaQ10ZXIkHvRX9BY=;
 b=IWpZTEijgekiQJRt3qBg6EmP41fMrVm3lYLkKPsowxKxWg7xBldaLLUVTlHZtlIextw0SD4RpLdsy5X+CzbNhvC8IMVjY9f8YyKFN1K9Fdn9CWmIXzD01drwVddLqz5U1dLO0F/BSEfaDj5pqu+Qe4kIjSSqljTrH7hllVfceI3wL6Aet2U7vFDgxz8Lz6Qt5Bfbwciq5SDcg4gHqEni2BUgJ9rXZ7c3lPH8s66jR9gV0u7ehCcFwDScZTqNVGkhnzKyU9KSxWzVinPq7XWYRNWBSSAooXN38U1xyYLrw3bKvcYBk/RNfNmdYDHSJYGPMP8P9xhMXSRdN3m5jYl6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=metarealtyinc.ca smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMYvKorHiY4fYdhmS1QCO7XFZx0OaQ10ZXIkHvRX9BY=;
 b=Nz0ini5j72MwTq5KMBcMd1tCDlQDAH5NVZUM2aBUdktECC1bsaTzKcp7SJpGwIgVr46jPwjnxPIyqhKI6Tv+B1bhxp+GiNA1Kq++xg3qm4cmNRDwNJfahTiGuWZxvM8WG4YleBLxSgEMAfwFGQR27rKCzko13dlnNPzImEUjnFk=
Received: from BY3PR03CA0021.namprd03.prod.outlook.com (2603:10b6:a03:39a::26)
 by CH8PR12MB9840.namprd12.prod.outlook.com (2603:10b6:610:271::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 05:49:25 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:a03:39a:cafe::2c) by BY3PR03CA0021.outlook.office365.com
 (2603:10b6:a03:39a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 05:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 05:49:24 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 00:49:23 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 00:49:23 -0500
Received: from [10.136.39.179] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Wed, 19 Aug 2026 00:49:16 -0500
Message-ID: <dc72965d-b6d6-409f-a96a-c841eec5e16c@amd.com>
Date: Wed, 19 Aug 2026 11:19:10 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the
 enqueue path (flat-hierarchy series)
To: Jake S <j@metarealtyinc.ca>, Ingo Molnar <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	"Vincent Guittot" <vincent.guittot@linaro.org>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Waiman Long
	<longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	<linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260818231333.1441757-1-j@metarealtyinc.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|CH8PR12MB9840:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f087c55-fe46-403d-ef64-08defdb59fec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|7416014|82310400026|23010399003|10067099003|56012099006|6133799003|22082099003|11063799006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	pmUpC5q2i5h9tf5bL2TBHAV/djPmMAzgOrA7sKcqJ2Rp3Fo5Jxw3dYcHWd+5+x4VmHh5/Kv6BAfDUieBNzB2gVY9tw3nYuKc84Ng+sP0Cior6R7kkas7lbWoRQSZ7UQic0uvCg1g1i6FCFBKCDcQ4YOoqnsRVlHA0fWJVBv/BczcYCkudsDKqGbCyRNSzsT5PElYnXqFTOO0HGiFtwBjUMqj4MEbgDv9GXEUtwuSBPPQ4uxJUkO1vaQu9DC6299bIabwNSKH7AfNWomyakYDp6Y1vRzOSSQ1AffmHeX6EhNdv/U9LFCRzGLGSiZ3X8JfTkICKVLRlS204Wg/ip0KZJ4JfTmDeha/EcGSYwH6Le0SkwxmkZ1DohxofQu1jdbfNhCGB2pWGiUkaw6CJcRKt28W+tlqJvNx0l/808mgRXi8rRX38nhLsUNFa/Cf+2mLz3iTg+bh4fBVprWTC4bqdB7j6UU1KZ1R6Uaq7lvxP6Y+TiObhC3nYAOqM1uYHxzo5Q/k0xDfoAd6+jFQBMoPSMasviY1aaEIUMmoRHisCaD628HZlHZCFy9vYgSc39zB1P4ehyOcj4Z4cc1vb+f3D+0nTtDSFhSV2BIMkgHt2fnakxTmLHeIbMz0eYMHHpMes09vXrRLx5Yu6/VmUI/bQGiHTqaep/JFdBqXiN5b5+S8yKSuM1l27zOInNKPabincTof8mfeZpTFZ83NKZ6adg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(7416014)(82310400026)(23010399003)(10067099003)(56012099006)(6133799003)(22082099003)(11063799006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wqeWKxIqT/2CKjAdI8+rgXcFwavb0oHssWcRly6dDEOypj1a0JUsTrejzjvnsBPOXkzui1kzZRuS3swIZK6QU8UyeDcZ7mN+o3Q0xvtLeK222AANs1X4lmvrF5qa6TZX5e/0HEZdJfg625V4bbeBeTBRDFEagx/qIt7GvdEBbChjO2NvJ5qz7VK9deZPUet/6vAWg0RWxpyhHyXDANPxPd0GKomhjYG4CRHIFBdIWqh2RT0PIC6Z2YRsZJ4MHr2YLV9uzOuTV7gQI2IbghNW9jANlKD+pdsooYHov2yAuAwjyaVR65knl4clQ8/r91+t2VDDVmskBFtUU31YdGgoR2m57jr4DHJb3r+CAQ5rJyfcE2dJsB0qi2RjD6Z8aqoLrd0p+Nc8mi5/JIewMRGVWTCEpBlUsj7VIlK+gfsKdnZ0TiTYGgfLnLeylebGajQ2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 05:49:24.5843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f087c55-fe46-403d-ef64-08defdb59fec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9840

Hello Jake,

Thank you for the report.

On 8/19/2026 4:43 AM, Jake S wrote:
> [You don't often get email from j@metarealtyinc.ca. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Hi,
> 
> I hit a divide-by-zero panic in __calc_prop_weight(), reached from
> enqueue_hierarchy() inside enqueue_task_fair(). This is the *enqueue*
> path, not the task_tick_fair() variant reported in May and addressed by
> the se->on_rq guard folded into 85570f10a4c6 -- enqueue_hierarchy() and
> dequeue_hierarchy() carry no equivalent check.
> 
> The code is from the tip sched/core flat-hierarchy rework; it is not in
> Linus' tree. I am running it via a distro kernel (CachyOS) that carries
> the series, on 7.2-rc7 and 7.2.0.
> 
> I have separated what I verified from what I am guessing. The last link
> in the causal chain is unexplained and I am asking about it rather than
> asserting it.
> 
> === The oops ===
> 
>   Oops: divide error: 0000 [#1] SMP NOPTI
>   CPU: 12 UID: 1000 PID: 312907 Comm: bash
>   Tainted: G     U   C OE       7.2.0-rc7-2-cachyos-rc #1 PREEMPT(full)
>   Hardware name: Dell Inc. XPS 16 DA16260/0RMV2Y, BIOS 1.5.1 04/01/2026
>   RIP: 0010:enqueue_task_fair.llvm.6536700009857788019+0x422/0x950
>   Code: 0f 84 74 01 00 00 83 bd 68 01 00 00 00 45 0f 4f f4 48 8b 4d 00
>         4c 89 e8 48 09 c8 48 c1 e8 20 0f 85 53 fd ff ff 44 89 e8 31 d2
>         <f7> f1 41 89 c5 e9 4f fd ff ff 0f 0b e9 1d fe ff ff 4c 89 e6
>   RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: fffff46fbf98e680 RDI: fffff46fbf98ffc0
>   RBP: fffff46fbf98ffc0 R08: ffff8ee25f9b2a80 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000110 R12: 0000000000000001
>   R13: 0000000000000000 R14: 0000000000000001 R15: fffff46fbf9901c0
>   Call Trace:
>    <TASK>
>    enqueue_task+0x8e/0x250
>    wake_up_new_task+0x148/0x2e0
>    kernel_clone+0x1c6/0x390
>    __x64_sys_clone+0xcc/0x100
>    do_syscall_64+0x147/0x3c0
>    asm_fred_entrypoint_user+0x41/0x41
>    </TASK>
> 
> Machine was idle, lid closed, 11.66 h into the boot. bash forked, the
> new task was enqueued, div trapped.

Was your laptop suspended at that point?

> 
> It is not survivable in practice. panic_on_oops was 0, so the kernel
> took the first #DE, printed the oops and continued for 476 ms. It then
> faulted at the same RIP with byte-identical registers and an identical
> RSP (ffffd46fff53bbb0):
> 
>   Kernel panic - not syncing: Fatal exception
>   Shutting down cpus with NMI
> 
> i.e. the oops-recovery path (kill task -> schedule()) re-entered the
> same enqueue with the rq lock already held mid-enqueue.
> 
> === Where it divides (confirmed) ===
> 
> kernel/sched/fair.c, __calc_prop_weight(), inlined into
> enqueue_hierarchy() -> enqueue_task_fair():
> 
>         weight *= se->load.weight;
>         if (parent_entity(se))
>                 weight /= cfs_rq->load.weight;  /* <-- #DE */
> 
> RCX = cfs_rq->load.weight = 0. R13 = 0 means se->load.weight was 0 as
> well, i.e. a group sched_entity carrying zero weight.
> 
> Not a miscompile: this is clang 22.1.8 + ThinLTO, hence the .llvm.<hash>
> suffix. The 32-bit "div %ecx" against 64-bit C operands is clang's
> BypassSlowDivision -- the preceding "or %rcx,%rax; shr $32,%rax; jne"
> is its guard. The 64-bit slow path is present in the same function.
> 
> === How the weight can reach zero (mechanism, partly inferred) ===
> 
> __calc_smp_shares() ends:
> 
>         return clamp_t(long, shares, MIN_SHARES, shares_max);
> 
> clamp() yields hi when hi < lo, so shares_max == 0 silently defeats the
> MIN_SHARES floor and returns 0 -- exactly the case the comment directly
> above it says must yield MIN_SHARES instead of 0. Note __clamp_once()
> already carries
> 
>         BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...)
> 
> so lo > hi is considered a bug upstream; it just cannot fire on a
> runtime-computed shares_max.
> 
> shares_max arrives from calc_concur_shares() as nr * tg_shares, where
> nr = min(tg_tasks(tg), tg_cpus(tg)). tg_cpus() returns
> cpuset_num_cpus(cgrp) unfloored, while its sibling tg_tasks() already
> floors at 1. That asymmetry is the hole.
> 
> concur is the live mode here:
> 
>   $ cat /sys/kernel/debug/sched/cgroup_mode
>   up smp (concur) max tasks
> 
> What I could NOT establish: that tg_cpus() actually returned 0, or what
> would produce an empty effective cpuset. update_cpumasks_hier()
> substitutes the parent's effective_cpus before storing; on this machine
> no cgroup has an empty cpuset.cpus.effective and every
> cpuset.cpus.partition reads "member". Twelve cgroups here have an empty
> cpuset.cpus and all report effective = 0-15. I suspected a power daemon
> that rewrites AllowedCPUs on the top-level systemd slices using an
> empty-then-set idiom, but I could not make that yield an empty effective
> mask, so I am not claiming it.
> 
> The missing floor looks like a hole regardless of what trips it, and I
> would rather ask than guess: is there a path where cpuset_num_cpus() can
> legitimately return 0, or should tg_cpus() simply floor at 1 the way
> tg_tasks() does?

Since you mentioned idle + lid closed, and
pm_sleep_disable_secondary_cpus() -> freeze_secondary_cpus() on the
suspend path, I'm wondering if that path can have any effect here but
afaict, sc->effective_cpus should be unaffected on that path and I'm
not sure if we can even get a fork() + wakeup before we thaw all the
process.

That said I do see a bunch of cpumask_empty(cs->effective_cpus) in
kernel/cgroup/cpuset.c so I'm not sure if that might be at play here.
I'll defer to folks who understand cpusets better.

> 
> === Proposed guard ===
> 
> Running locally on 7.2.0 for the past day. The WARN_ONCE in tg_cpus() is
> deliberately diagnostic -- it confirms or refutes the cpuset route the
> moment anyone reproduces this.
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ __calc_prop_weight
> +       unsigned long div;
> +
>         weight *= se->load.weight;
> -       if (parent_entity(se))
> -               weight /= cfs_rq->load.weight;
> -       else
> +       if (parent_entity(se)) {
> +               div = cfs_rq->load.weight;
> +               if (unlikely(!div)) {
> +                       WARN_ONCE(1, "sched: cfs_rq->load.weight == 0 (se->load.weight=%lu)\n",
> +                                 se->load.weight);
> +                       return MIN_SHARES;
> +               }
> +               weight /= div;
> +       } else {
>                 weight /= NICE_0_LOAD;
> +       }
> 
>         return max(weight, MIN_SHARES);
> 
> @@ __calc_smp_shares
> -       return clamp_t(long, shares, MIN_SHARES, shares_max);
> +       /* clamp() yields hi when hi < lo, defeating the MIN_SHARES floor. */
> +       return clamp_t(long, shares, MIN_SHARES,
> +                      max_t(long, shares_max, MIN_SHARES));
> 
> @@ tg_cpus
> +       if (WARN_ONCE(nr < 1, "sched: tg_cpus() == 0, empty cpuset\n"))
> +               nr = 1;
>         return nr;
> 
> === Reproducer / caveats ===
> 
> Not reliably reproducible: one occurrence in ~11.7 h of idle uptime, and
> none since. I have no better trigger than "leave it running".
> 
> The kernel is tainted G U C OE -- out-of-tree camera drivers are loaded
> on this machine. I cannot categorically exclude memory corruption from
> those. Against that: no prior WARNs, no slab or list corruption, no DMAR
> faults, no EDAC events, and the two oopses 476 ms apart had byte-identical
> register state, which a wild write would not reproduce exactly. I mention
> it so nobody wastes time on a report I cannot fully vouch for.
> 
> Happy to test patches or run instrumented builds on the affected machine.

I think your current instrumentation from "Proposed guard" is good
enough to tell where the problem is if it reproduces. Are you running
with it on your setup currently?

> 
> Config: CONFIG_FAIR_GROUP_SCHED=y, CONFIG_SCHED_AUTOGROUP=y,
> CONFIG_SCHED_CLASS_EXT=y (sched_ext disabled, not in use),
> CONFIG_X86_NATIVE_CPU=y, no CONFIG_SCHED_BORE, no SCHED_ALT.
> Hardware: Intel Core Ultra X7 358H (Panther Lake), 16 CPUs.
> 
> Thanks,
> Jake

-- 
Thanks and Regards,
Prateek

