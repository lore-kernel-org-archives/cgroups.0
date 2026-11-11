Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794384538;
	b=bWwDOkqCO8yQKauMgbSozJKt5UDYgznrovM2H5Bj8tFg38fNdkVmXOi1uHl9RTGYe7Dd
	 iCJBKH/3AjVdGrEiBg4K+V0R6MXp807alBciaL0J0CkgpsuxhYjEMaketzcb1R3m7oLlw
	 NLpyqAkuDCcx1b9Q6qExwgudeF+7O/9yJ+0Io9s2sjW4N2Zi5qHwdemUb0JdFEyvrYpgA
	 5MfFKJ3fjShyLBA2E+3C0twC+YHkA7P0KkQlvgar1lMKGoMFfiAJDjWc6TNY5MM8CfWnt
	 s3DIeaj21xMvtpzxo5gnQX2CTCHaDplEQrvMMp+r2kgSVp0IPsDwBHoSYfnNq3cb/cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794384538;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=OMx8DURBi1HKQNsNSde4ObBuj2cCKjyxSIgE906Z6wU=;
	b=kGoVRNrOz9zjp0XyRR/p8sbFK5B3je+jGAsAO09eJ7qGvr9YD0EaeQx0fBZ+r9urdyxk
	 OJoZm9/5ZfIF4I623HTxZvhzVlT6UHfpOobrkfIhjiDfGebJ8d6NLTQShhNJoKnf4ROHH
	 MOX7uGokDETWNgHGrYLATrB7/7WbKhjKOQWBvzLdysD0zz3Zumc+nqXMhPXz9ECkGJtX6
	 TcYn6MAQURAARJC2E+xuBHix2T9qlT37cfiNaS/ybrfFQtfQ21Q1j+y4Wv7dNYuTkLxRx
	 nw8OOfxwI83iHryIMDDKj4IORz5D+F0RxKLBvE93+0e0AKRqw3jOUmmeXyt+DUq+SQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vj5n5e0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE3606A8D3;
	Wed, 11 Nov 2026 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vj5n5e0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA231F00A05;
	Wed, 11 Nov 2026 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384538;
	bh=OMx8DURBi1HKQNsNSde4ObBuj2cCKjyxSIgE906Z6wU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Vj5n5e0SBFA1j4z0Z15SdCzc4M3OrCLsWJXqhvLQqGwHQKanl350MBfbSz8ARxnFD
	 jOWJ3MA9OMnNp4iJ2t22+M/1LUETLN++x1e4PQAlu084/gezb1EGPHwXX4AkHLZ9Xe
	 amH9gwOhhyHIrBsWhaeeuFm8XCfe57IygtxfcZNX6YATAJkMKLeLNvpsUuq2Oa7MeQ
	 QfAyTDiSl0sVpXOH6ghIFl1wmICmjoaLePNWKQw8Q0Vjkc0RW7jhiS4QEeokPdTnbz
	 M7Y9tkPjkPDpcplzDhf60pYRsJkFGU8yEqUlPEN3t39trYPzNLA7pz1bc5Spos97Dn
	 XKUhumL8wOfGA==
Content-Type: multipart/mixed; boundary="===============5888328363070956270=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <ab530d93c7383ec9cd5d9fbedc531e933d4b812ddb367bb85c940b870d34c247@mail.kernel.org>
In-Reply-To: <a07b9717684d5e20d8ff7a778a5f031d1092f18a.1794303670.git.sieberf@amazon.com>
References: <a07b9717684d5e20d8ff7a778a5f031d1092f18a.1794303670.git.sieberf@amazon.com>
Subject: Re: [PATCH v2 3/4] sched_ext: add cgroup_set_runtime ops callback
From: bot+bpf-ci@kernel.org
To: sieberf@amazon.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,tj@kernel.org
Cc: bsegall@google.com,dietmar.eggemann@arm.com,rostedt@goodmis.org,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,mkoutny@suse.com,void@manifault.com,arighi@nvidia.com,changwoo@igalia.com,skhan@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,cgroups@vger.kernel.org,sched-ext@lists.linux.dev,linux-doc@vger.kernel.org,linux-kselftest@vger.kernel.org,bpf@vger.kernel.org,linux-kernel@vger.kernel.org,nh-open-source@amazon.com,hborghor@amazon.de,fmubeen@amazon.de,dwmw@amazon.co.uk,karataev@amazon.com,sieberf@amazon.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 11 Nov 2026 08:08:56 +0000 (UTC)

--===============5888328363070956270==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched_ext: add cgroup_set_runtime ops callback

TL;DR: The documented guarantee that cgroup_set_runtime never exceeds the
quota the scheduler was last given may not hold for schedulers lacking
cgroup_init or cgroup_set_bandwidth; comment and commit message may need
qualifying, or validation tightened.

> diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
> --- a/kernel/sched/ext/internal.h
> +++ b/kernel/sched/ext/internal.h

[ ... ]

> @@ -863,6 +863,26 @@ struct sched_ext_ops {
>  	 */
>  	void (*cgroup_set_idle)(struct cgroup *cgrp, bool idle);
>  
> +	/**
> +	 * @cgroup_set_runtime: A cgroup's runtime is being set
> +	 * @cgrp: cgroup whose runtime is being set
> +	 * @runtime_us: runtime in microseconds

[ ... ]

> +	 * @cgrp has a quota, and @runtime_us is at most the quota + burst the
> +	 * scheduler was last given, by @cgroup_init or @cgroup_set_bandwidth:
> +	 * cpu.max and cpu.max.runtime writes reach the scheduler in the order
> +	 * the fair class applied them.
> +	 *
> +	 * Delivery follows the same rule as cgroup_set_weight().
> +	 */
> +	void (*cgroup_set_runtime)(struct cgroup *cgrp, u64 runtime_us);

Does this guarantee hold for a scheduler that implements
cgroup_set_runtime but not cgroup_init or cgroup_set_bandwidth?  The
commit message makes the same claim: "The runtime passed is then at most
the quota + burst the scheduler was last given".

scx_group_set_bandwidth() still updates tg->scx.bw_* when the op is
missing:

    if (scx_cgroup_enabled && sch && SCX_HAS_OP(sch, cgroup_set_bandwidth) && ...)
            SCX_CALL_OP(sch, cgroup_set_bandwidth, ...);
    tg->scx.bw_period_us = period_us;
    tg->scx.bw_quota_us = quota_us;
    tg->scx.bw_burst_us = burst_us;

while scx_group_set_runtime() calls the op whenever
SCX_HAS_OP(sch, cgroup_set_runtime) is true, and the fair class only
checks the runtime against its own cfs_b->quota + cfs_b->burst in
cfs_bandwidth_set_runtime().

For example, take a scheduler with cgroup_init and cgroup_set_runtime but
no cgroup_set_bandwidth.  Cgroup C has cpu.max "10000 100000" at load, so
ops.cgroup_init() sees bw_quota_us=10000.  Userspace then writes cpu.max
"50000 100000", which the fair class applies but the scheduler is never
told about.  A following write of 40000 to cpu.max.runtime passes
cfs_bandwidth_set_runtime() since 40000 <= 50000, and
ops.cgroup_set_runtime(C, 40000) runs, four times the quota the scheduler
was last given.

Similarly, a scheduler without cgroup_init that loads after C's quota was
set is never given a quota, yet still receives cgroup_set_runtime for that
cgroup.

Should the comment (and commit message) make the guarantee conditional on
the scheduler implementing @cgroup_init and @cgroup_set_bandwidth, or
should validation reject cgroup_set_runtime without cgroup_set_bandwidth?
The later commit eb360e17b06e ("sched_ext: charge BPF scheduler tasks to
cpu.max bandwidth") does not change this text.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42982707042
--===============5888328363070956270==--
