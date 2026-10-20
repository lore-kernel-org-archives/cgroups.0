Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486361;
	b=Jm+pi9FCXVNKmruXA5HL7Gm53b3bKKelpqs29wJijVszxBoo2lg62ogAWKknTlAwA7zN
	 ebNM8xnK50vX337jQJ+b+l+a87otHX1k1rGqWeAmMY2VyiOxlZ2DM2sWKRKCCTBSW+yL+
	 TUOARZDxonPGrLaZgkXiG8/meK5MCjoWkwJK0dEBuJXP9mUbKsfjfIxgwKSlUQZXTqDMr
	 hhGG2vOHlkEa7EqsDJ770Xd1kSaOA6jeC+Rtdiv1mCaJJR1dUhF44r6dHiDVIjCH6fXcL
	 vb/FjgYB+SSOkeqIWUqBecZ6HImM3LdESRxkaZgMzWHSm+AOeNPOS7jCCPE22p1sRUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486361;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=60SG9yPxKAKDWYj+IMKT9vxqjHJEKGItNB5I5v16LVY=;
	b=naTr92pZ7wkRxMAXzYcBv0fcuLcINZQfJP8VFY/fxjB93/ReqFeOwDDdKKtYwfMQ+oKU
	 U7Y3W++d49O35ri46/dg/AQQ9IrAiR1vWsi4FiaA0vdlWp3pjo5XZ6zO2UnHQero+5iqn
	 5eAv1pC1DMcgHvQ764E98cv1J//poQECq13B1x+UO/OFeX7sr4IlhP5w+XsaQZsKTO1On
	 Zk/fyE9ka3nW3ZShQuklL+gwCcGfxwjgkWeyIuDDUso6jIBlP1Z5UnTYmbwbvGjTMxM2G
	 gBS/lFeRRg57mmiR1JcAI6QjmBSUMKSAPAnG502ue7CDkLdMveAIOZDdiOsVwtkbQ+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n8uGU4oN;
	arc=none smtp.remote-ip=91.218.175.172
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C67E606A31B
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 08:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C67E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n8uGU4oN
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T28oLKR7Bmt9aigMF3ryHlZCm3wf13JNKWFADPyXE8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792486357; v=1; x=1793091157;
 b=n8uGU4oNLh50LGXaswrwXaoInYwjlO2+BdZQFkJzMQHUNMm00CbFXIaAwTdrNgXAHSwuRreH
 cL5UWGsUWmt3MKBAncKo0rHJjB51dPPUZ2MXHKFWujC6MhYIvgLUgOFXqjLkhbYsoXNC607T8GS
 wytRRIBtB3E7WP2bbYPf0AFw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3400e678eb2d8255;
	Tue, 20 Oct 2026 08:52:36 +0000
X-Mizu-Trace-ID: 3400e678eb2d8255
X-Migadu-Flow: FLOW_OUT
Message-ID: <0ae3790c-ba72-4061-9a2a-81be1279a579@linux.dev>
Date: Tue, 20 Oct 2026 16:52:29 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [RFC PATCH 3/4] memcg_ext: allow BPF to defer memory.high
 enforcement
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Donet Tom <donettom@linux.ibm.com>,
 Greg Thelen <gthelen@google.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <20260921192559.2619635-4-shakeel.butt@linux.dev>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260921192559.2619635-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


2026/9/22 03:25, Shakeel Butt :

Hi Shakeel,

The series looks great to me. I added a prog_tests runner for the sample
on top of it and ran the test:
selftests/bpf: add a prog_tests runner for memcg_ops_lockholder
https://github.com/teawater/linux/commit/d726b0d59081ace49e4e41cb0c91f813fd137d46

I have 2 suggestions for bpf_memcg_high_policy().

> Before it returns, try_charge_memcg() calls __mem_cgroup_handle_over_high(),
> which reclaims and can throttle the task.  That happens wherever the charge
> happens, so a task holding a kernel lock can be stuck there, and everything
> waiting on the lock is stuck behind it.
>
> Let's add high_policy ops through which a program gets a read-only snapshot
> of the charge and returns a request.  There is one so far:
> BPF_MEMCG_HIGH_DEFER_INLINE skips the inline call.
>
> A charge runs the policies of its cgroup and of every ancestor.
> task_struct::in_bpf_memcg stops a program that allocates from re-entering
> the charge path and the dispatcher with it.
>
> A memcg outlives its cgroup while it has charges, and cgroup_bpf_release()
> frees the arrays when the cgroup goes. Take the reference for the walk.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   MAINTAINERS                    |  1 +
>   include/linux/bpf-cgroup.h     |  3 ++
>   include/linux/bpf_memcontrol.h | 53 +++++++++++++++++++++-
>   include/linux/cgroup.h         |  7 +++
>   include/linux/sched.h          |  4 ++
>   mm/bpf_memcontrol.c            | 82 +++++++++++++++++++++++++++++++++-
>   mm/memcontrol.c                | 31 ++++++++++++-
>   7 files changed, 176 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6215fcb07770..0c84beab396f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5032,6 +5032,7 @@ L:	bpf@vger.kernel.org
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   F:	mm/bpf_memcontrol.c
> +F:	include/linux/bpf_memcontrol.h
>   
>   BPF [MISC]
>   L:	bpf@vger.kernel.org
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 4e8150848bd2..e19cf83e58f3 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -517,6 +517,9 @@ static inline int cgroup_bpf_struct_ops_attach(struct bpf_map *map,
>   
>   #define cgroup_bpf_enabled(atype) (0)
>   #define cgroup_bpf_enabled_runtime(atype) (0)
> +/* Nothing can be attached, so the walk has nothing to walk. */
> +#define bpf_cgroup_struct_ops_foreach(var, item, cgrp, atype)		\
> +	for ((void)(cgrp), (item) = NULL, (var) = NULL; 0; )
>   #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) ({ 0; })
>   #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
>   #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
> diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
> index 8204d894761e..76ea5d1c3d32 100644
> --- a/include/linux/bpf_memcontrol.h
> +++ b/include/linux/bpf_memcontrol.h
> @@ -5,13 +5,62 @@
>    * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
>    * that cgroup and of every ancestor, and the kernel combines what they
>    * return.  BPF only picks between things the kernel already does.
> - *
> - * The type has no members yet; they come with the policies that use them.
>    */
>   #ifndef _LINUX_BPF_MEMCONTROL_H
>   #define _LINUX_BPF_MEMCONTROL_H
>   
> +#include <linux/types.h>
> +#include <linux/gfp_types.h>
> +
> +struct mem_cgroup;
> +struct task_struct;
> +
> +/*
> + * What a policy can ask for when a cgroup is over memory.high.  The kernel
> + * ORs them, so one policy cannot undo another.
> + */
> +enum bpf_memcg_high_request {
> +	BPF_MEMCG_HIGH_NO_OPINION	= 0,
> +	/*
> +	 * Skip the inline reclaim and throttle.  The debt is kept and paid on
> +	 * the way back to userspace, where no kernel locks are held.
> +	 */
> +	BPF_MEMCG_HIGH_DEFER_INLINE	= 1U << 0,
> +};
> +
> +#define BPF_MEMCG_HIGH_VALID_MASK	BPF_MEMCG_HIGH_DEFER_INLINE
> +
> +/* Read-only snapshot.  Only values the caller already has. */
> +struct bpf_memcg_ctx {
> +	struct mem_cgroup	*memcg;			/* charged memcg */
> +	struct mem_cgroup	*memcg_over_limit;	/* NULL if none found */
> +	struct task_struct	*task;			/* current */
> +	u64			cgroup_id;
> +	u64			over_limit_cgroup_id;	/* 0 if none */
> +	u64			nr_pages_over_high;
> +	u32			gfp_flags;
> +};
> +
>   struct bpf_memcg_ops {
> +	/**
> +	 * high_policy - say where memory.high should be enforced
> +	 * @ctx: snapshot of the charge
> +	 *
> +	 * Return: bits from enum bpf_memcg_high_request, or 0.  Other bits
> +	 * are dropped.
> +	 */
> +	u32 (*high_policy)(const struct bpf_memcg_ctx *ctx);
>   };
>   
> +/*
> + * Run every high_policy on @memcg's cgroup and its ancestors, and return the
> + * combined request for the caller to act on.
> + *
> + * @memcg:	the memcg being charged, never NULL
> + * @over_limit:	first memcg found over memory.high or swap.high, or NULL
> + * @gfp_mask:	the charge's gfp mask
> + */
> +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> +			  struct mem_cgroup *over_limit, gfp_t gfp_mask);
> +
>   #endif /* _LINUX_BPF_MEMCONTROL_H */
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 5dfa915a630e..cf92b6cec819 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -959,10 +959,17 @@ static inline void cgroup_bpf_put(struct cgroup *cgrp)
>   	percpu_ref_put(&cgrp->bpf.refcnt);
>   }
>   
> +/* Fails once the cgroup is gone and its bpf state has been freed. */
> +static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp)
> +{
> +	return percpu_ref_tryget_live_rcu(&cgrp->bpf.refcnt);
> +}
> +
>   #else /* CONFIG_CGROUP_BPF */
>   
>   static inline void cgroup_bpf_get(struct cgroup *cgrp) {}
>   static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
> +static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp) { return false; }
>   
>   #endif /* CONFIG_CGROUP_BPF */
>   
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8b3d47a325cc..4b20a346aaa8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1031,6 +1031,10 @@ struct task_struct {
>   #ifdef CONFIG_MEMCG_V1
>   	unsigned			in_user_fault:1;
>   #endif
> +#ifdef CONFIG_MEMCG
> +	/* A bpf_memcg_ops program is running; do not recurse into policy */
> +	unsigned			in_bpf_memcg:1;
> +#endif
>   #ifdef CONFIG_LRU_GEN
>   	/* whether the LRU algorithm may apply to this access */
>   	unsigned			in_lru_fault:1;
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index fd6dff150f01..cfd0f1d443c9 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -246,8 +246,17 @@ static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
>    * request and the kernel acts on it.  Nothing here reclaims or sleeps.
>    */
>   
> -/* CFI stubs.  A slot points at these while its policy is being detached. */
> +/*
> + * CFI stubs.  These really run: a slot points at them while its policy is
> + * being detached.  Return 0, the identity for the kernel's OR.
> + */
> +static u32 high_policy_stub(const struct bpf_memcg_ctx *ctx)
> +{
> +	return BPF_MEMCG_HIGH_NO_OPINION;
> +}
> +
>   static struct bpf_memcg_ops __bpf_memcg_ops = {
> +	.high_policy = high_policy_stub,
>   };
>   
>   static const struct bpf_func_proto *
> @@ -326,6 +335,77 @@ static struct bpf_struct_ops bpf_memcg_ops_desc = {
>   	 */
>   };
>   
> +static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
> +			       struct mem_cgroup *memcg,
> +			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
> +{
> +	ctx->memcg = memcg;
> +	ctx->memcg_over_limit = over_limit;
> +	ctx->task = current;
> +	ctx->cgroup_id = cgroup_id(memcg->css.cgroup);
> +	ctx->over_limit_cgroup_id = over_limit ?
> +		cgroup_id(over_limit->css.cgroup) : 0;
> +	ctx->nr_pages_over_high = current->memcg_nr_pages_over_high;
> +	ctx->gfp_flags = (__force u32)gfp_mask;
> +}
> +
> +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> +			  struct mem_cgroup *over_limit, gfp_t gfp_mask)
> +{
> +	const struct bpf_prog_array_item *item;
> +	const struct bpf_memcg_ops *ops;
> +	struct bpf_memcg_ctx ctx;
> +	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
> +	struct cgroup *cgrp;
> +
> +	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
> +		return acc;
> +
> +	/*
> +	 * Only the default hierarchy has a cgroup_bpf, and the static key is
> +	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
> +	 * v1 memcg still cannot get here, because memory.high and swap.high
> +	 * are both v2-only and so it never builds the debt that leads to this
> +	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
> +	 * test: a v1 cgroup has no effective array and an uninitialised
> +	 * cgrp->bpf.refcnt.
> +	 */
> +	cgrp = memcg->css.cgroup;
> +
> +	/*
> +	 * A program can allocate and re-enter the charge path.  Skip the
> +	 * nested call.  This guards the callbacks only.
> +	 */
> +	if (current->in_bpf_memcg)
> +		return acc;
> +	current->in_bpf_memcg = 1;
> +
> +	rcu_read_lock_dont_migrate();
> +

The guard stops nested dispatch, but not the nested charge itself: an
allocation made by a policy program re-enters try_charge_memcg(), the
task's debt is still over MEMCG_CHARGE_BATCH at that point, and if that
allocation's gfp ever allowed blocking, the fallback would run
__mem_cgroup_handle_over_high() — reclaim, and schedule_timeout_killable()
when the penalty is large — inside rcu_read_lock_dont_migrate().

Today this is unreachable: bpf_base_func_proto() helpers only allocate
atomically and check_member() rejects sleepable programs, so the
gfpflags_allow_blocking() gate stays false. So this is not a problem
with the current code — more a worry about how easily a future change
could break it without anyone noticing. The invariant is written down
nowhere, it spans two files, and the planned "kernel reclaims on the
policy's behalf" extension is exactly the kind of change that would
stress it.

If you agree, would you consider making it explicit: a comment on
bpf_memcg_high_policy()/bpf_memcg_get_func_proto() stating that
everything reachable from a policy program must be non-blocking, and a
WARN_ON_ONCE(current->in_bpf_memcg) at the fallback site so a future
violation trips in testing instead of surfacing as an RCU stall? For the
reclaim-on-behalf work itself, keeping the current "BPF picks, the
caller acts after dispatch returns" pattern (or a workqueue) would
sidestep the issue entirely.


> +	/*
> +	 * A memcg outlives its cgroup while it has charges, and
> +	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
> +	 */
> +	if (!cgroup_bpf_tryget_live(cgrp))
> +		goto out;
> +
> +	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
> +
> +	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {

cgroup_bpf_enabled(CGROUP_MEMCG_OPS) is a global static key, so with one
policy attached anywhere, every over-high fallback in the system —
including cgroups whose effective array is empty — pays the tryget/put
plus bpf_memcg_ctx_init() (two cgroup_id() dereferences and the snapshot
stores) before the foreach finds nothing to run.

Could we bail before building the context by peeking at the first
effective item right after cgroup_bpf_tryget_live()? It has to be after
the tryget, since cgroup_bpf_release() frees the effective arrays
without NULLing the slots:

     if (!READ_ONCE(rcu_dereference(cgrp->bpf.effective[CGROUP_MEMCG_OPS])
                ->items[0].kdata)) {
         cgroup_bpf_put(cgrp);
         goto out;
     }

Since attach forces ALLOW_MULTI and compute_effective_progs() folds
ancestors into this cgroup's array, a NULL first item really does mean
"nothing to run" for the whole walk. To keep mm/ config-agnostic, the
test probably wants to be a small inline next to
bpf_cgroup_struct_ops_foreach() in bpf-cgroup.h, with a stub for
!CONFIG_CGROUP_BPF like the foreach macro has.

This is on the slow path that is about to reclaim or throttle, so the
win is small — mainly keeping the unrelated-cgroup case O(1) instead of
building a ctx that gets thrown away. Fine to drop if you prefer the
walk uniform.

Best,
Hui


> +		if (ops->high_policy)
> +			acc |= ops->high_policy(&ctx) &
> +			       BPF_MEMCG_HIGH_VALID_MASK;
> +	}
> +
> +	cgroup_bpf_put(cgrp);
> +out:
> +	rcu_read_unlock_migrate();
> +
> +	current->in_bpf_memcg = 0;
> +
> +	return acc;
> +}
> +
>   static int __init bpf_memcg_ops_register(void)
>   {
>   	/*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..bc283680640b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -28,6 +28,7 @@
>   #include <linux/cgroup-defs.h>
>   #include <linux/page_counter.h>
>   #include <linux/memcontrol.h>
> +#include <linux/bpf_memcontrol.h>
>   #include <linux/cgroup.h>
>   #include <linux/cpuset.h>
>   #include <linux/sched/mm.h>
> @@ -2642,9 +2643,26 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>   	css_put(&memcg->css);
>   }
>   
> +/*
> + * Ask the attached bpf_memcg_ops whether to skip the inline memory.high
> + * reclaim and throttle.
> + *
> + * @memcg:	the memcg being charged
> + * @over_limit:	first memcg found over memory.high or swap.high, starting at
> + *		the charged one, or NULL if the walk found none
> + */
> +static bool bpf_memcg_high_defer(struct mem_cgroup *memcg,
> +				 struct mem_cgroup *over_limit, gfp_t gfp_mask)
> +{
> +	u32 req = bpf_memcg_high_policy(memcg, over_limit, gfp_mask);
> +
> +	return req & BPF_MEMCG_HIGH_DEFER_INLINE;
> +}
> +
>   static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   			    unsigned int nr_pages)
>   {
> +	struct mem_cgroup *leaf_memcg = memcg;
>   	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
>   	int nr_retries = MAX_RECLAIM_RETRIES;
>   	struct mem_cgroup *mem_over_limit;
> @@ -2846,8 +2864,17 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   	 */
>   	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
>   	    !(current->flags & PF_MEMALLOC) &&
> -	    gfpflags_allow_blocking(gfp_mask))
> -		__mem_cgroup_handle_over_high(gfp_mask);
> +	    gfpflags_allow_blocking(gfp_mask)) {
> +		/*
> +		 * The loop above left @memcg as the first memcg it found over
> +		 * memory.high or swap.high -- possibly the charged one itself
> +		 * -- or NULL if it found none.  Note the debt can be left over
> +		 * from an earlier charge, so NULL does not mean no pressure.
> +		 * The policy wants the memcg we charged.
> +		 */
> +		if (!bpf_memcg_high_defer(leaf_memcg, memcg, gfp_mask))
> +			__mem_cgroup_handle_over_high(gfp_mask);
> +	}
>   	return 0;
>   }
>   
