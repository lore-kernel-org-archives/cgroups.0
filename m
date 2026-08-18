Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C93A3E7A;
	Tue, 18 Aug 2026 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787073386; cv=none; b=bIDsvuStgGB5SJ5w0jNOkTuih/sr2zdAjMEhhLcrNMT6vAKeF4WU8aoSYzJGgvJbbD9pn8X3up/PMXjoGU/zKKYjG33o6OyxTT258tpZz357HYXPdqTkno68YI8QW6BKOrC5Uie68MA+YKRAtYAnKbaXglCWv5wxCnjWWRG3iMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787073386; c=relaxed/simple;
	bh=VuZPMpnS8NPFkrTAMXBBESwpuMUlXCj215pqsSFrG/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxMre0Y35mjHWmhbRzzFI2RelMPK7yB6BVg419dCZ5OK94gLQmM+ETossZPFEa41iPG7Ysrer8BUSs8ee5vtyQ8D4UKC4fLNxEV/z+/3LlvBkiuE2/OtgS4J1C2hMyHSWtsjxq5ErSIno+PBppTKliwfKHGjr5zJfGFt8dhpu0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dwj9K7Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dwj9K7Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5F71F000E9;
	Tue, 18 Aug 2026 17:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073385;
	bh=WH4WPT0ROVvQC1ncoMRSxYGxqkEaGEutzNvZ3MuoB50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dwj9K7GrS7h3gJoBG73WZViEQ1tJMFfDLxokVxyhIUHAoPvnjzThLYQPoyPJA+C4q
	 lfIpTtwR5kHHouT5f3OKvmikf72y13sh1gc+XIlnC2xFPI6hCyMEx8+KqN5xgq5lwT
	 cmWmc4/elKc5xervIkDqxvqAxck9NekHjLna/oIqYri83CapDJcXrtxWOZY88awGsl
	 5XKR5lBlQ3xu3PfU2mZssA4Em5cwSP65MbuLdpz9zrJEOQRZUp4qrpjFdlUL/EHouo
	 LipwY564W/lHwnUdavXMuJ5RLaXXENjrJi9uljd09c67s1uVYGaS+cBJFcYagB2dbo
	 eQSU7RsMdBWkg==
Date: Tue, 18 Aug 2026 07:16:24 -1000
From: Tejun Heo <tj@kernel.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>, kernel-team@meta.com,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cgroup: add BPF kfuncs to read a cpu cgroup's
 stats
Message-ID: <aoSTaFwsVEoNW01D@slm.duckdns.org>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818002450.3071325-2-ziyang.meme@gmail.com>

On Mon, Aug 17, 2026 at 05:24:49PM -0700, Ziyang Men wrote:
> +++ b/kernel/cgroup/bpf_cpu.c

Probably not the best file name. bpf_cgroup.c or maybe just put it in
cgroup.c?

> +/**
> + * bpf_css_to_task_group - Cast a CPU controller css to its task group
> + * @css: CPU controller css
> + *
> + * Must be called under RCU.
> + * A C cast does not give the verifier a task_group pointer. This kfunc
> + * preserves the task_group and per-CPU types needed to read cfs_rq.

The fact that this is used for per-CPU types now probably won't age well if
this grows more usages in the future.

> + *
> + * Return: The task group, or NULL if @css belongs to another controller.
> + */
> +__bpf_kfunc struct task_group *
> +bpf_css_to_task_group(struct cgroup_subsys_state *css)
> +{
> +	if (css->ss != &cpu_cgrp_subsys)

unlikely()?

> +		return NULL;
> +
> +	/* task_group embeds css at offset zero. */
> +	return (struct task_group *)css;

container_of()?

> +/**
> + * bpf_css_flush_rstat - Flush a cgroup subsystem's rstat data
> + * @css: cgroup subsystem state to flush
> + */
> +__bpf_kfunc void bpf_css_flush_rstat(struct cgroup_subsys_state *css)
> +{
> +	css_rstat_flush(css);
> +}

Why is this necessary? Isn't css_rstat_flush() already exposed as a kfunc?

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

Why are these SLEEPABLE?

Thanks.

-- 
tejun
