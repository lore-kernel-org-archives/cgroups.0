Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC3429011;
	Thu, 13 Aug 2026 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786652643; cv=none; b=U1AtXe7Klo3deSFE457CfSatj2rB8n6lrWQqUZtf6vAe+9gKGbZRuRZGFag/bT1qS4uoFiPGS4Ug/eN07Hq50oCfBkxdPNUgq1+MTe58he7rA1nc3255oTepE3/grXGaDobB+prq34Jm6UHcBi7NeVcddhP9wVFU4qLuMZBLcmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786652643; c=relaxed/simple;
	bh=/0F5vv2gi3Yr+cf8BPibyQmWTnL+RMZ1jMZmX2aTu30=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=rOiXOzBIN10QXOilJPHLeLLwS7w9/Scd09NcLva1CU823EWRJGe7mW9WFrKjyPRYuk/SUiMElagU0p4wSTAc9bZ2XHhL2YwjLLR8U8JpKMB7yiGRFjqA2l9WID7IFsn3YJkluY8ofuWDVq3ENvH/7m8m+PPwMTcfhOgtcWash1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF8XL9sP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF8XL9sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC2D1F00A3A;
	Thu, 13 Aug 2026 20:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786652642;
	bh=ZyFsXYcP3kh+4oqZHUEBNRkaoLiqPnNmCkgiWlURKlo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=aF8XL9sPKE1QF3QxqRu+yc9wzEMiPD6XM1jBPoiKay+9sgV962B9iGWdXz7pFp7AE
	 EDYPSJxFU1D0xK/uyIbDtJ3exkRtkx0mJ4jBtLNt5QK+MXJIJaut0Qtl0uOuMsc1sz
	 cLgIReNagdz4UFc2lrVTcD3YxmblkKrySZhB63lSSCahQgVrzGSB5f5XDrtsdCDauk
	 d78GpQRhAUTTMkDFeay/HlZCpSPr1JGMLkhg+Gyt6x3xMTwbv/xqi/CEatdJsoo9Hs
	 LUXwOFMSqpkYXULp6tcaP9s0mYavojIHLgnri2ZcSgjtBW6HwFJUH4P0NFH1JDrkxw
	 9HZlftZ2S+pYQ==
Content-Type: multipart/mixed; boundary="===============1084245792064651521=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <7d093c8c6747cdcf227ce7b7384e79012bc04c52b1fc1464f170c85dd20dc6f8@mail.kernel.org>
In-Reply-To: <20260813185846.1216892-2-ziyang.meme@gmail.com>
References: <20260813185846.1216892-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH 1/2] cgroup, sched: add BPF kfuncs to read a cpu cgroup's stats
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,mingo@redhat.com,peterz@infradead.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: bsegall@google.com,juri.lelli@redhat.com,vincent.guittot@linaro.org,dietmar.eggemann@arm.com,rostedt@goodmis.org,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,kernel-team@meta.com,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 13 Aug 2026 20:24:00 +0000 (UTC)

--===============1084245792064651521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -923,4 +923,19 @@ static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
>
>  struct cgroup_of_peak *of_peak(struct kernfs_open_file *of);
>
> +/* A cgroup's base CPU-time counters in microseconds, as cpu.stat prints them */
> +struct cpu_cgroup_cputime {
> +	u64 usage_usec;
> +	u64 user_usec;
> +	u64 system_usec;
> +	u64 nice_usec;
> +	u64 forceidle_usec;	/* 0 without CONFIG_SCHED_CORE */
> +};
> +
> +/* A task_group's own throttled time in nanoseconds; see cpu.stat.local */
> +struct task_group;
> +#ifdef CONFIG_CFS_BANDWIDTH
> +u64 throttled_time_self(struct task_group *tg);
> +#endif
> +
>  #endif /* _LINUX_CGROUP_H */

Should this scheduler interface be in include/linux/cgroup.h? The header
now forward-declares struct task_group and declares a CFS-bandwidth
function, although task_group and its accessors live in
kernel/sched/sched.h.

Nothing else in include/linux/cgroup.h references scheduler-internal
types. The only consumer is kernel/cgroup/bpf_cpu.c, which could get it
from kernel/cgroup/cgroup-internal.h instead (where the patch already
puts bpf_cpu_cgroup_cputime()).

Also, throttled_time_self() becomes a global, unprefixed symbol when it
was previously file-local to kernel/sched/core.c. Would a name like
sched_cgroup_throttled_time_self() avoid polluting the global namespace,
or could a small prefixed wrapper keep the original function static?

> diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
> --- a/kernel/cgroup/Makefile
> +++ b/kernel/cgroup/Makefile

[ ... ]

> diff --git a/kernel/cgroup/bpf_cpu.c b/kernel/cgroup/bpf_cpu.c
> --- /dev/null
> +++ b/kernel/cgroup/bpf_cpu.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * CPU Controller-related BPF kfuncs
> + *
> + * bpf_cpu_cgroup_cputime() is defined in rstat.c, which owns the locking it
> + * needs, and only registered here.
> + *
> + * Author: Ziyang Men <ziyang.meme@gmail.com>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/cgroup.h>
> +
> +#include "cgroup-internal.h"
> +
> +__bpf_kfunc_start_defs();

[ ... ]

> +/**
> + * bpf_cpu_cgroup_throttled_self - Read a cgroup's own throttled time
> + * @cgrp: cgroup to read from
> + *
> + * Return: The throttled time in microseconds, or 0 if config is off.
> + */
> +__bpf_kfunc u64 bpf_cpu_cgroup_throttled_self(struct cgroup *cgrp)
> +{
> +/* cpu_cgrp_id needs the cpu controller, which CFS bandwidth depends on */
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	struct cgroup_subsys_state *css;
> +
> +	guard(rcu)();
> +
> +	css = rcu_dereference(cgrp->subsys[cpu_cgrp_id]);
> +	if (!css)
> +		return 0;
> +
> +	return div_u64(throttled_time_self((struct task_group *)css),
> +		       NSEC_PER_USEC);

Is the raw cast to struct task_group * safe here? This works because
struct cgroup_subsys_state css is the first member of struct task_group,
but struct task_group is an incomplete type in this translation unit.

kernel/cgroup/bpf_cpu.c includes only <linux/bpf.h>, <linux/btf.h>,
<linux/cgroup.h> and "cgroup-internal.h", so the compiler cannot verify
the cast.

Every existing css->task_group conversion in the tree uses css_tg() from
kernel/sched/sched.h, which is container_of() and stays correct if the
member ever moves. The scheduler helpers cpu_cfs_local_stat_show() and
cpu_local_stat_show() do the same conversion with css_tg().

Would moving the cpu-controller kfunc to kernel/sched/core.c (where
struct task_group is complete and css_tg() is available) avoid hard-
coding a struct-layout invariant that this file cannot check?

> +#else
> +	return 0;
> +#endif
> +}

[ ... ]

> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c

[ ... ]

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -10027,7 +10027,7 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
>  	return 0;
>  }
>
> -static u64 throttled_time_self(struct task_group *tg)
> +u64 throttled_time_self(struct task_group *tg)
>  {
>  	int i;
>  	u64 total = 0;


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31735302699
--===============1084245792064651521==--
