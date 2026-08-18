Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1393876BE;
	Tue, 18 Aug 2026 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787016533; cv=none; b=Bc+K62NmX2o7uxWwLx7Dnwag2f6CDO74tRAlSE4qmo4waHYKbVsp3tAWMELMWsMkF/stNUToihWtGxhiUVVg5sn5gu0vwsYU8nXoLGNl9Cfm73IQvtSWBiex7MTtMrtADZihTUgFW2TakXnhNRj5IZwggVTR7YCDYXFz1Us+qSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787016533; c=relaxed/simple;
	bh=MIYe/tBxJTutFbmxvaLWQOWz4uI5KD2EMGTQhS4BWeo=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=UdwtwTzZvLpAmSS71q325bc401sP6UVQimQP+4TMua/fCjWFYxjvB1JACq2DHwvbkCV5g86DePNjDaMtY1bUEq0fM0HLmc5eY4UFn3NwV2F2ZbVw5sIU4sNURkRFD3pvl8xSOLZt+bhmBkLT6Ac31xuTxSlDao0F3nBUFgVmQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1Czu4MR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1Czu4MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299941F00A3D;
	Tue, 18 Aug 2026 01:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787016531;
	bh=UvB2gcyD4YS68Qm6x4+zUnkUl5DDVmDfH9NQiYl9404=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=H1Czu4MRxO62iz9Vpt3yaVgqsOjgbfe7udGY8MH4XGjji8UKuBSSkzEElyBtZvuZs
	 O1eye0IeGVnvFvKkXZArt7Ka750snGflMR+aQcXgTBpZKEqBSEHXSruj03Z4UKcioM
	 9TH3JC8Vju+QBQLgIC7JW/YcIclM3D8VWo0XyBizCVWZcjBmVC2uVoBcYt8//6RqPS
	 mLJSF6nkuoAoHANElLYqCIWc6/rray6MPxAmiFCzqcHoBwDwxwQIgHA2hgEZ4e/rzf
	 IkhxQ5XxCvNAyTkit1XuussgqqJ2uWEiheaq3hFFvtVpVzGQK9taNKg73p3LLRwvLN
	 M5+nGBL8i7GZA==
Content-Type: multipart/mixed; boundary="===============5761274082629541537=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <893500b01a50d5fde5c0c79562e4429472e86ef0a88635b3f60ac608974a6dcf@mail.kernel.org>
In-Reply-To: <20260818002450.3071325-2-ziyang.meme@gmail.com>
References: <20260818002450.3071325-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 1/2] cgroup: add BPF kfuncs to read a cpu cgroup's stats
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,shuah@kernel.org,kernel-team@meta.com
Cc: mingo@redhat.com,peterz@infradead.org,vincent.guittot@linaro.org,bsegall@google.com,dietmar.eggemann@arm.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,ziyang.meme@gmail.com,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 18 Aug 2026 01:28:50 +0000 (UTC)

--===============5761274082629541537==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

>     cgroup: add BPF kfuncs to read a cpu cgroup's stats
>
>     Collecting cgroup statistics is expensive: the existing
>     method is to open and parse a cgroup file. memcg already has an
>     efficient alternative through BPF; this series extends that idea to cpu.
>
>     Expose the CPU controller's per-cgroup statistics to BPF, following
>     the memory controller kfuncs in mm/bpf_memcontrol.c.
>
>     Design:
>     - Add bpf_css_flush_rstat() and bpf_cgroup_base_stat() to cgroup rstat.
>       The second kfunc returns the raw cgroup_base_stat after the
>       same cputime adjustment used by cpu.stat.
>     - Leave reading the CFS bandwidth counters to the BPF program. They are
>       plain fields of tg->cfs_bandwidth, so they need no kernel code.
>     - Add bpf_css_to_task_group(), which returns a checked RCU pointer of
>       the task_group*. This is usefule to compute the throttled time in bpf
>       side since the bpf_per_cpu_ptr() requires a verifier-known struct
>       task_group * and a pointer carrying the MEM_PERCPU property.
>       This use the convention that task_group embeds its css at offset zero,
>       so no scheduler helper or scheduler source change is needed.

This isn't a bug, but there are language errors in the third Design
bullet: "usefule" should be "useful", and "This use" should be "This
uses". Also "in bpf side" is typically written as "on the BPF side" in
kernel documentation.

> diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
> index ede31601a363..0ba59b7eef48 100644
> --- a/kernel/cgroup/Makefile
> +++ b/kernel/cgroup/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o freezer.o
>
> +obj-$(CONFIG_BPF_SYSCALL) += bpf_cpu.o
> +
>  obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
>  obj-$(CONFIG_CGROUP_PIDS) += pids.o
>  obj-$(CONFIG_CGROUP_RDMA) += rdma.o

[ ... ]

> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index de816a43db9f..46c322c4858b 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -752,6 +752,54 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
>  	cgroup_force_idle_show(seq, &bstat);
>  }
>
> +#ifdef CONFIG_BPF_SYSCALL
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_css_flush_rstat - Flush a cgroup subsystem's rstat data
> + * @css: cgroup subsystem state to flush
> + */
> +__bpf_kfunc void bpf_css_flush_rstat(struct cgroup_subsys_state *css)
> +{
> +	css_rstat_flush(css);
> +}

This isn't a bug, but is bpf_css_flush_rstat() needed?

css_rstat_flush() is already marked __bpf_kfunc and registered with
KF_SLEEPABLE at rstat.c:409 and :806. Adding
'BTF_ID_FLAGS(func, css_rstat_flush, KF_SLEEPABLE)' to
bpf_rstat_common_kfunc_ids below would expose the same operation to BPF
without introducing a second name for it and without needing a wrapper.

> +
> +/**
> + * bpf_cgroup_base_stat - Read a cgroup's base statistics
> + * @cgrp: cgroup to read from
> + * @out: zero-initialized output in nanoseconds
> + *
> + * CPU time is adjusted as for cpu.stat.
> + */
> +__bpf_kfunc void bpf_cgroup_base_stat(struct cgroup *cgrp,
> +				      struct cgroup_base_stat *out)
> +{
> +	if (cgroup_parent(cgrp)) {
> +		__css_rstat_lock(&cgrp->self, -1);
> +		*out = cgrp->bstat;
> +		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
> +			       &out->cputime.utime, &out->cputime.stime);
> +		__css_rstat_unlock(&cgrp->self, -1);
> +	} else {
> +		root_cgroup_cputime(out);
> +	}
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_rstat_common_kfunc_ids)
> +BTF_ID_FLAGS(func, bpf_css_flush_rstat, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_cgroup_base_stat, KF_SLEEPABLE)
> +BTF_KFUNCS_END(bpf_rstat_common_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set bpf_rstat_common_kfunc_set = {
> +	.owner		= THIS_MODULE,
> +	.set		= &bpf_rstat_common_kfunc_ids,
> +};
> +
> +#endif /* CONFIG_BPF_SYSCALL */
> +

[ ... ]

>  static int __init bpf_rstat_kfunc_init(void)
>  {
> -	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> -					 &bpf_rstat_kfunc_set);
> +	int ret;
> +
> +	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> +					&bpf_rstat_kfunc_set);
> +#ifdef CONFIG_BPF_SYSCALL
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> +					       &bpf_rstat_common_kfunc_set);
> +#endif
> +	return ret;
>  }
>  late_initcall(bpf_rstat_kfunc_init);

This isn't a bug, but are these #ifdef CONFIG_BPF_SYSCALL guards
necessary?

The existing kfuncs in this file (css_rstat_flush at line 409,
BTF_KFUNCS_START at 804, register_btf_kfunc_id_set at 818) have no
guards, and rstat.o is obj-y, so they compile fine with
CONFIG_BPF_SYSCALL=n via the no-op stubs in include/linux/btf.h:652.
The cited precedent mm/bpf_memcontrol.c uses 'obj-$(CONFIG_MEMCG) +=
bpf_memcontrol.o' with no preprocessor conditionals anywhere in the .c
file. Documentation/process/coding-style.rst:1166-1175 asks to avoid
preprocessor conditionals in .c files and prefer compiling out entire
functions via header stubs. Would dropping the guards and using
'obj-$(CONFIG_CGROUP_SCHED) += bpf_cpu.o' in the Makefile work here?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32085852351
--===============5761274082629541537==--
