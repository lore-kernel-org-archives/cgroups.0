Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737172;
	b=FooYi3Iiend43cSsEEsUm0f21GMCJCE++nyZMP0HgjXavYyqSa/jYMLA6906Uo/JQZod
	 h5cMOkwws01LXLLjXQ9Ji7I2bqaU64jGCImvfqpETD7fIkKyPHfh6Dn1QOKeQHFx4Bbeq
	 ByskjkYzdPgHo7gIZSMiUxR2rVIIkF2fLwwyvP8aMGB62uIYc3bpJX+cVe0U3yw2+1q1B
	 7n+y8/IMZ6MdLdwDFZWI9KfYOiTfVG1SyVGJMkUk2+HOZzUvXswo8IYvQiosaDtxFkr8b
	 m+tfK4TVGnwQuX1/osTHiaeDrKID5z1aeflPjlsMM8f8kpdiaqkEtSAHk4uITzdYg5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737172;
	h=DMARC-Filter:DKIM-Signature:Subject:User-Agent:In-Reply-To:
	 Message-Id:Mime-Version:Content-Transfer-Encoding:To:Date:Cc:From:
	 Content-Type:X-Lms-Return-Path:References:X-Original-From;
	bh=A/KkeSW0iJwwqF3dTal22x/IVE71KQpeS559w4ryEuE=;
	b=hrmD+7/6DVCvIITU8BVpt9F5XyCTq3KImXc1QlTFpddVOkIP37+tVjgskf3XCY1YGB8D
	 M1SBISpZQEpMk5in3YRsS7yFv6YL5PjpfMbqytmkKRnwyNP9d/O83A8d3yspv8sNZyWIK
	 YoFrZc4xQC/Ro4OqU2vYbFEcjdSMwyStyCYevX9W99oyhW9/tAeIRceDe2lYTsuvR+gwL
	 CmblDoQ34NtkcXoJOj8YbIexEHYIUrko6OdygDer/nU1Ak/Srb9BRbiV3T/RoV5nm9Jdv
	 HR7PPNWTvBJBNaC3GBPiEQL4CppUU9BLfoq/3FyoXZEsm+a+CvhJMYgvgwKPKXXFnJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZunCuudQ;
	arc=none smtp.remote-ip=209.127.230.111
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C08F606A31A
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 06:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C08F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZunCuudQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792737158; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=A/KkeSW0iJwwqF3dTal22x/IVE71KQpeS559w4ryEuE=;
 b=ZunCuudQz4sc9UuX1ESe/ATn26vRhp++gXavBXjrKaHnJU56X9Rlw4VohHcBtmWcla3Hln
 3Y6ph4OaBoN2Kvv19x6ZuQIlcqiA91Ekf5U315QjVc0Jy8TFADK+rx42J4kh2/hE5IQ6hX
 cLQt+QIUK1/x8wfJEpCt7XApTdjGJGjbtnXBMLqs7nfoZ7DyHYpSIetABw2PR3OwO+Hmt3
 RqkGcDfCbcQW+SpelP/ZMADf4Kfh64E6uuJ9rG7nKMuCFTfsMUPJczP/biADXu1nAYpT/J
 Cm7MCVlga+ealsDvcK5JvolBOmGANKCnBoKiyfi3sYoiLs96LdRtVu6L64XaBQ==
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
User-Agent: Mozilla Thunderbird
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
Message-Id: <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: "Yafang Shao" <laoar.shao@gmail.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <eddyz87@gmail.com>, 
	<memxor@gmail.com>, <mingo@redhat.com>, <peterz@infradead.org>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<shakeel.butt@linux.dev>, <roman.gushchin@linux.dev>, 
	<yu.c.chen@intel.com>, <zhao1.liu@intel.com>, 
	<tim.c.chen@linux.intel.com>
Date: Fri, 23 Oct 2026 14:32:08 +0800
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26adaff84+45ab06+vger.kernel.org+lizhe.67@bytedance.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>

On 10/19/26 2:41 PM, Yafang Shao wrote:
> The Problem
> ===========
>
> In our large fleet of Kubernetes-managed servers, NUMA balancing has
> been historically disabled globally on each server. With the increasing
> deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> become a critical performance issue, which made us reconsider enabling NUMA
> balancing to address it.
>
> Enabling NUMA balancing globally is still not acceptable since it can
> introduce latency spikes for latency-sensitive workloads. What we need is
> to choose per workload whether NUMA balancing runs at all, and which mode
> it runs in. A latency-sensitive service wants NUMA balancing disabled,
> while a batch service wants its PMEM-resident memory promoted when hot
> without paying for scheduler-driven migration. No single global setting
> serves both.
>
> The Design
> ==========
>
> This series introduces the fine-grained per-cgroup NUMA balancing
> control. It grows out of Tejun's suggestion to store the existing
> NUMA_BALANCING_* bitmask per cgroup and expose it through BPF kfuncs.
> cgroup::numab_mode holds the request: NUMAB_FOLLOW_SYSTEM (-1) defers
> to the global sysctl state, anything else is a bitmask.
> bpf_numab_set_mode() writes a request, bpf_numab_get_mode() reads the
> combined request of the cgroup and of every ancestor back. The hot
> paths walk the same chain at read time behind a static key, so while no
> cgroup makes a request the overhead is one patched-out branch.
>
> An opt-out wins and binds the subtree: a DISABLED request anywhere in
> the chain opts the cgroup's tasks out entirely. Otherwise the requested
> bits OR together and the kernel reads them independently, the way
> kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> both modes. A DISABLED request only speaks for the cgroup's tasks,
> never for its memory, which follows the remaining requests of its
> ancestors.
>
> The cost of the additive combination is that an ancestor cannot cap
> tiering short of a full opt-out: a descendant's TIERING request
> re-engages promotion for its own memory, and promotion is the mode that
> consumes the shared fast tier.


I am not sure that this matches the usual cgroup hierarchy semantics.
If promotion consumes the shared fast tier, why is a descendant allowed
to re-enable TIERING when an ancestor cannot cap it short of a full
opt-out?

Thanks,
Zhe

>
> The readback contract is worth spelling out: bpf_numab_get_mode()
> returns the combined request of the cgroup and its ancestors, and the
> kernel reads it the same way it reads a single request, each bit
> independently as kernel.numa_balancing does, so a combined
> NORMAL|TIERING engages both modes. When any cgroup in the chain makes a
> request, the value read back is the mode in effect for the cgroup's tasks;
> when none does, the readback is NUMAB_FOLLOW_SYSTEM (-1) and the sysctl
> decides. The answer speaks for the cgroup's tasks only: its memory follows
> the remaining requests of its chain when it opts out, and that folio-side
> view is not exposed by the kfuncs. These are deliberate simplifications;
> both can be revisited if callers turn out to need them.
>
> The sysctl's own documentation is untouched; the override is documented
> where it lives, in the CONFIG_BPF_NUMAB Kconfig help and the kfunc docs.
>
> The override was measured with schbench, 384 workers, on a two-node
> 384-core machine. Whatever kernel.numa_balancing is set to, a cgroup
> request puts the cgroup at the throughput of the equivalent
> system-wide setting, within a fraction of a percent: the override
> itself costs nothing measurable, performance follows the effective
> state alone. The two states themselves differ by less than a percent
> under this load.
>
> Changes
> =======
>
> RFC v2->RFC v3:
> - The struct_ops interface is replaced by two kfuncs, following
>    Tejun's suggestion.
> - Improve on the function naming and simplify the code (David)
>
> RFC v2: https://lwn.net/Articles/1099962/
>
> RFC v1->RFC v2:
> v1 keyed the hook on the memory cgroup and temporarily embedded the cgroup
> id into the struct-ops value, because the cgroup struct_ops integration was
> still under development. v2 attaches through the cgroup struct_ops support
> that has since landed in bpf-next, keys the task surface on the task's
> cgroup and the memory surface on the folio's memcg, and adds the
> memory-tiering mode alongside enable and disable.
>
> RFC v1: https://lwn.net/Articles/1054030/
>
> Yafang Shao (5):
>    sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
>    sched: use static_branch_likely() for the NUMA balancing tick check
>    sched: add helpers for numa balancing
>    sched: add BPF-based per-cgroup NUMA balancing mode selection
>    selftests/bpf: add tests for the numab kfuncs
>
>   include/linux/cgroup-defs.h                   |  10 +
>   include/linux/sched/numa_balancing.h          | 149 ++++++++++++
>   init/Kconfig                                  |  20 ++
>   kernel/cgroup/cgroup.c                        |  14 ++
>   kernel/sched/bpf_numab.c                      | 195 +++++++++++++++
>   kernel/sched/build_policy.c                   |   4 +
>   kernel/sched/fair.c                           |  33 +--
>   kernel/sched/sched.h                          |   1 -
>   mm/memory-tiers.c                             |   9 +-
>   mm/mempolicy.c                                |   3 +-
>   mm/migrate.c                                  |   7 +-
>   mm/vmscan.c                                   |   6 +-
>   .../selftests/bpf/prog_tests/bpf_numab.c      | 227 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/bpf_numab.c |  32 +++
>   14 files changed, 681 insertions(+), 29 deletions(-)
>   create mode 100644 kernel/sched/bpf_numab.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c
