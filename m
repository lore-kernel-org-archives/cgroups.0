Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACAD423E94;
	Mon, 19 Oct 2026 07:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792394666; cv=none; b=OVrpE615LRWqXfV1ybAexcz6jirk4l/9T5rIB3DFy20KHTPlvXnD1vRhFZOE4LmLcHV3Y44fghUe7WtgTjrCpbCs6cSD9MlSZiUkvWhx5o/WcooYPQrxgivdGwkoEJ9vmi5iTLtWLSNWErfTED8NocyjXcQ1goIk8z3n63JeimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792394666; c=relaxed/simple;
	bh=PJMNtFZdCxAkfXpCGh9gdP0M/bJtvasByqnTtI9idOs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=gHso7JPoCKRxiEcHQbQNDUH+LrRZ5Uy/91hmylVSiZ6+lI7BQYY9uvdNrHWUTX+hjyTz1I6HdGCXm7uIGrJwCPeDSHN4RtzQ41jSvBZTNbwllZO6hh0C7uWRXurFOwYYKZrJ6BGLqsM8xl3QSv6sSdQgGDs2InVNncCJmKcNHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggHitl0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggHitl0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8571F000C4;
	Mon, 19 Oct 2026 07:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792394665;
	bh=kq41aEXGRIjZiDj+Lf2TBzLa687IIXYS/7guQvFIns4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ggHitl0rXZyzCQCjN2UknQ40BhlbBcTxZG09AcCzpp5wAsA5ho/FiflIfIJ4mEK1y
	 6VS8S7ervff50xPjQk0fgrN1ptCCJzqUQb4SZ4i1g906kHxhuHIKQ40rN8IeTQzjwf
	 MVsTmyF8Y2vfLeUwNqOkpOBkRcpRdwDzG2bgEIZLscXgMxX/uh0/ewXONSUWspaa1t
	 Y259/Soj7mZdinOjIz1my6RleMtKjL0AXnVhlFaUJOBxiJtF8sqhvu+sXCqx2KT7xt
	 8scp6w5vFlgHfAXGfA+HaNLEHeqMJJhjwO+euGG3MNxBR7C2+seS6e2BmGsvdZMBe/
	 fLyvPT46WqT0Q==
Content-Type: multipart/mixed; boundary="===============4963888778798225134=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <737a8f07246a2cd31950ffcdb2a98b9ee81824c27a362dd17e0ba94e2281b00e@mail.kernel.org>
In-Reply-To: <20261019064157.29885-5-laoar.shao@gmail.com>
References: <20261019064157.29885-5-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 4/5] sched: add BPF-based per-cgroup NUMA balancing mode selection
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,akpm@linux-foundation.org,david@kernel.org,gourry@gourry.net,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,yu.c.chen@intel.com,zhao1.liu@intel.com,tim.c.chen@linux.intel.com,lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 19 Oct 2026 07:24:24 +0000 (UTC)

--===============4963888778798225134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched: add BPF-based per-cgroup NUMA balancing mode selection

TL;DR: Comment only: the comment on task_numab_in_tiering_mode() may describe
the return value backwards, since task_numa_fault() skips non-top-tier
statistics when it returns true.

> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
> index 36de57f7fb06..d63891a8be01 100644
> --- a/include/linux/sched/numa_balancing.h
> +++ b/include/linux/sched/numa_balancing.h

[ ... ]

> @@ -53,6 +95,68 @@ static inline bool numab_in_normal_mode(void)
>  {
>  	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
>  }
> +
> +/*
> + * Whether @p runs in tiering mode, i.e. whether faults on non-top-tier
> + * memory still feed its NUMA statistics. The requests of the task's
> + * cgroup and of every ancestor are combined; an opt-out wins, otherwise
> + * the bits are read independently, as the sysctl reads them. Without
> + * any request, the global sysctl decides.
> + */
> +static inline bool task_numab_in_tiering_mode(struct task_struct *p)
> +{
> +#ifdef CONFIG_BPF_NUMAB
> +	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
> +		int mode = task_numab_mode(p);
> +
> +		if (mode != NUMAB_FOLLOW_SYSTEM)
> +			return mode & NUMA_BALANCING_MEMORY_TIERING;
> +	}
> +#endif
> +	return numab_in_tiering_mode();
> +}

The comment above task_numab_in_tiering_mode() says it reports "whether
faults on non-top-tier memory still feed its NUMA statistics".  Is that
the right way around?

The only caller, task_numa_fault() in kernel/sched/fair.c, uses it like
this:

	if (!node_is_toptier(mem_node) &&
	    (task_numab_in_tiering_mode(p) || !cpupid_valid(last_cpupid)))
		return;

so a true return makes task_numa_fault() bail out before recording any
statistics for non-top-tier memory.  Should the comment say that faults on
non-top-tier memory are kept out of the task's NUMA statistics instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39213018427
--===============4963888778798225134==--
