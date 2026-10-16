Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD77344781E
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 11:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792149230; cv=none; b=TBuobleixpfxoWC0te+6XwqQdpJVOxvVFCLVeuqJUQnFFkRHHQFE54tFjAyAvsxCxtWsllmiOVsmpMGOaCPqhbcfS6vyUmuxi4sQcJnZgVJFMPGCakPv/op0SlEf3b1vk1f5HQlicR0sfAsup6H2LSJYrX7O4MscNTzvlaIsjWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792149230; c=relaxed/simple;
	bh=X58SwrkFFp3ztvH2Noq/jUoS6DiX16w1TaBG2g1bFV0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Dyu+D7A2KQLsawDeSMb+GCA6PcmWpiedgTvWehdAgICukJb3iP+c0wXBtN4LBw12icq6U4gOtSQ3CW6iBpMj8qmztuGb175hMVyjfuu1CYWTKltOd9cT183fJdSycuj26sqZgNjnk/NxO0fb0cbH5riwhnGENfJo0T1wwuE4hKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j8l9DZUL; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j8l9DZUL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=X58SwrkFFp3ztvH2Noq/jUoS6DiX16w1TaBG2g1bFV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792149224; v=1; x=1792754024;
 b=j8l9DZULwB9djeur/I1AmPN0ZBwnWFxfou4ObN88P7CH5PQvqCaeGVLDmS2ISKDPckMn6JIX
 HfstcaKBYqURkxu7rviasODD9dpFtsUIO37qU9FyhOy8YuUqcHrQ1cS2KAFDGZ4ALd3FdIMkg1W
 hm02yQY5ganOJMV2oETgvIis=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2a6eecbfcbc4b948;
	Fri, 16 Oct 2026 11:13:44 +0000
X-Mizu-Trace-ID: 2a6eecbfcbc4b948
X-Migadu-Flow: FLOW_OUT
Message-ID: <81f61871-6852-4d30-b68a-bb08e56881f2@linux.dev>
Date: Fri, 16 Oct 2026 19:13:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-iocost: publish hweights as one atomic value
To: Kunhai Dai <daikunhai@didiglobal.com>, tj@kernel.org
References: <20261015135919.210740-1-daikunhai@didiglobal.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261015135919.210740-1-daikunhai@didiglobal.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello，Kunhai

在 2026/10/15 21:59, Kunhai Dai 写道:
> current_hweight() uses separate plain stores for the cache generation and
> both weights. The compiler can publish the generation before the weights,
> letting an interrupt accept stale weights as current. Multiple refreshers
> can also interleave their stores. Invalid donation budgets may then lead
> to a divide error in transfer_surpluses().
> 
> Pack the generation and both weights into a single atomic64_t. Hierarchical
> weights are in [1, 65536], so storing each weight minus one preserves its
> full range in 16 bits and leaves 32 bits for the generation. Readers copy
> one complete entry, and refreshers publish one complete entry. Return the
> local snapshot instead of rereading fields another refresher can modify.
> 
> Keep the existing lockless refresh and cache reuse behavior. A late
> refresh may replace a newer entry, but carries its own generation so the
> next reader can detect the mismatch. Preserve the existing barrier paired
> with commit_weights() and the allowance for approximate hierarchy reads.
> 
> Keep the old weight fields solely as donation workspace. Update cache
> initialization, activation invalidation, tracepoints and the drgn monitor
> accordingly. Tracepoints decode one cached snapshot without recalculating
> or refreshing weights. Stop invalid donation calculations before applying
> leaf adjustments, and check donating before subtracting one.
> 
> Validated against commit 24a19b953e2a ("Linux 7.3-rc7"):
> - clean application, whitespace and strict checkpatch checks;
> - W=1 compilation of blk-iocost.o with the existing x86-64 configuration
>   and PREEMPT_RT plus PROVE_LOCKING;
> - extracted production-function checks covering all weight values,
>   generation high bits, publication interleavings, donation cleanup and
>   400000 concurrent refresh calls using C11 atomic test stubs;
> - Python syntax and actual monitor-decoder checks;
> - x86-64 disassembly confirms a single 64-bit cache load and store.
> 
> Runtime kprobe injection on an x86-64 VM with 32 vCPUs completed three
> rounds without WARN or panic. With a 30 ms publication delay, the probe
> reported 23102 publication-point holds, 3234 cache-change observations
> within those windows and 72 matching-generation reader observations. The
> unpatched baseline panicked under the corresponding reproduction load.
> 
> The runtime build predates this revision's tracepoint-only simplification;
> the packed-cache and donation logic are unchanged. The current tracepoint
> change has passed normal and PREEMPT_RT compilation, but has not been
> rerun in the runtime injection test. Performance regression testing has
> not been performed.
> 

Thanks for the thorough patch. We tried your injection protocol on our side
(linux-next 20261014, clang 17, qemu/KVM, nullb0, the rt/s1..C topology with
1 <-> 10000 weight alternation, a 30ms kprobe hold at the publication
stores). The patched kernel came through cleanly -- no WARN or oops even
with a hold on every refresh, and the tracepoint decode of the final
revision worked in all runs, which nicely covers the gap you disclosed in
the commit message. We could not reproduce the divide error on the baseline,
likely because our clang build orders the stores gen-last, so the direct
window from your step 4 does not exist in our binary -- your repro's
precondition is indeed toolchain-dependent.

Two small observations:

1. The goto out in transfer_surpluses() skips the donation tail for all
   donors, so while a degenerate weight configuration persists, donation is
   given up every period (and inuse_transfer tracepoints go quiet). Strictly
   better than the old panic, but it might be worth a sentence in the commit
   message.

2. after == 0 may not be race-only: a boundary rounding in the over_hwa
   rescale can also floor a small over-donor's after value to zero. So the
   guard has some value even independent of the race.

Along the same lines, would you consider splitting the patch? A small
[1/2] with just the div0 guard (Fixes: e08d02aa5fc9, Cc: stable) would
backport easily, while the packed hweight_cache plus tracepoint/monitor
changes could go as [2/2] (Fixes: 7caa47151ab2). Also, the patch is
currently missing Fixes: entirely.

Thanks，
Tao

> Developed with assistance from OpenAI Codex.
> 
> Assisted-by: LLM
> Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
> 
> ---
> Reproduction outline (x86-64, cgroup v2):
> 1. Enable BLK_CGROUP_IOCOST and KPROBES. Enable the io controller at each
>    parent, and configure io.cost.qos and io.cost.model for the test device.
> 2. Create four leaves: rt/s1, rt/K/s2, rt/K/P/s3 and rt/K/P/C. Run continuous
>    direct 1 MiB writes in the first three; issue four direct 4 KiB writes
>    every 200 ms in C, keeping it active with low utilization.
> 3. Every 300 ms, alternate the K/P/C chain weights between 1 and 10000,
>    with the sibling leaves s1/s2/s3 taking the opposite weights. This
>    repeatedly makes C's hierarchical share fall to the minimum of 1.
> 4. On the unpatched build, confirm that the compiler placed the cached
>    generation store before the weight stores. Insert a kprobe delay of
>    30 ms after that generation store and before the weight stores.
>    Derive the instruction offset from the binary being tested.
> 5. On the packed-cache build, delay just before the atomic cache store
>    instead: there is no separate generation-publication window. This
>    stresses concurrent refresh completion and late cache overwrites.
> 
> Unpatched baseline, abbreviated crash and stack excerpt:
> 
>   iocg: invalid donation weights in /rt/K/P:
>         active=1 donating=1 after=0
>   Oops: divide error: 0000 [#1] SMP PTI
>   RIP: 0010:transfer_surpluses+0x43e/0x6b0
>   RAX: ffffffffffffffff  RCX: 0000000000000000
>    <IRQ>
>    ioc_timer_fn+0x1158/0x13b0
>    call_timer_fn+0x1e/0x100
>    __run_timer_base.part.36+0x1f0/0x220
>    [...]
>    handle_softirqs+0xa9/0x2a0
>    irq_exit_rcu+0x48/0xe0
>    sysvec_apic_timer_interrupt+0x6b/0x80
>    </IRQ>
>    [...]
>    win_pre+0x44/0x70 [repro_iocost]
>    [...]
>    ? current_hweight+0xc1/0x110
>    ? adjust_inuse_and_calc_cost+0x44/0x290
>    ? ioc_rqos_throttle+0x13e/0x590
>   Kernel panic - not syncing: Fatal exception in interrupt
> 
>  block/blk-iocost.c             | 65 ++++++++++++++++++++++++++++--------------
>  include/trace/events/iocost.h  |  6 ++--
>  tools/cgroup/iocost_monitor.py |  7 +++--
>  3 files changed, 53 insertions(+), 25 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 2745bffcd..fcc7ae866 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -472,8 +472,8 @@ struct ioc_gq {
>  	 *
>  	 * When an idle cgroup becomes active its `active` goes from 0 to
>  	 * `weight`.  `inuse` is the surplus adjusted active weight.
> -	 * `active` and `inuse` are used to calculate `hweight_active` and
> -	 * `hweight_inuse`.
> +	 * `active` and `inuse` determine the hierarchical weights cached in
> +	 * `hweight_cache`.
>  	 *
>  	 * `last_inuse` remembers `inuse` while an iocg is idle to persist
>  	 * surplus adjustments.
> @@ -520,7 +520,9 @@ struct ioc_gq {
>  	u64				child_active_sum;
>  	u64				child_inuse_sum;
>  	u64				child_adjusted_sum;
> -	int				hweight_gen;
> +	/* Generation in bits 63:32; active - 1 and inuse - 1 in 31:16/15:0. */
> +	atomic64_t			hweight_cache;
> +	/* Donation workspace, protected by ioc->lock. */
>  	u32				hweight_active;
>  	u32				hweight_inuse;
>  	u32				hweight_donating;
> @@ -1154,13 +1156,17 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
>  {
>  	struct ioc *ioc = iocg->ioc;
>  	int lvl;
> -	u32 hwa, hwi;
> -	int ioc_gen;
> -
> -	/* hot path - if uptodate, use cached */
> -	ioc_gen = atomic_read(&ioc->hweight_gen);
> -	if (ioc_gen == iocg->hweight_gen)
> +	u32 hwa, hwi, ioc_gen;
> +	u64 cache;
> +
> +	/* Read the generation and both weights as one atomic snapshot. */
> +	ioc_gen = (u32)atomic_read(&ioc->hweight_gen);
> +	cache = (u64)atomic64_read(&iocg->hweight_cache);
> +	if ((u32)(cache >> 32) == ioc_gen) {
> +		hwa = ((cache >> 16) & (WEIGHT_ONE - 1)) + 1;
> +		hwi = (cache & (WEIGHT_ONE - 1)) + 1;
>  		goto out;
> +	}
>  
>  	/*
>  	 * Paired with wmb in commit_weights(). If we saw the updated
> @@ -1194,14 +1200,22 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
>  		hwi = div64_u64((u64)hwi * inuse, inuse_sum);
>  	}
>  
> -	iocg->hweight_active = max_t(u32, hwa, 1);
> -	iocg->hweight_inuse = max_t(u32, hwi, 1);
> -	iocg->hweight_gen = ioc_gen;
> +	hwa = max_t(u32, hwa, 1);
> +	hwi = max_t(u32, hwi, 1);
> +	/*
> +	 * Each weight is in [1, WEIGHT_ONE]. Subtracting one preserves its
> +	 * full range in 16 bits, leaving 32 bits for the generation. An
> +	 * interrupt or another CPU can only observe a complete snapshot.
> +	 * A late refresher may overwrite a newer cache, but its generation
> +	 * stays paired with its own weights and forces a future refresh.
> +	 */
> +	cache = ((u64)ioc_gen << 32) | ((u64)(hwa - 1) << 16) | (hwi - 1);
> +	atomic64_set(&iocg->hweight_cache, (s64)cache);
>  out:
>  	if (hw_activep)
> -		*hw_activep = iocg->hweight_active;
> +		*hw_activep = hwa;
>  	if (hw_inusep)
> -		*hw_inusep = iocg->hweight_inuse;
> +		*hw_inusep = hwi;
>  }
>  
>  /*
> @@ -1300,10 +1314,12 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
>  
>  	/*
>  	 * Activate, propagate weight and start period timer if not
> -	 * running.  Reset hweight_gen to avoid accidental match from
> -	 * wrapping.
> +	 * running. Invalidate the cached generation to avoid accidental match
> +	 * from wrapping.
>  	 */
> -	iocg->hweight_gen = atomic_read(&ioc->hweight_gen) - 1;
> +	atomic64_set(&iocg->hweight_cache,
> +		     ((u64)(u32)(atomic_read(&ioc->hweight_gen) - 1) << 32) |
> +		     (u32)atomic64_read(&iocg->hweight_cache));
>  	list_add(&iocg->active_list, &ioc->active_iocgs);
>  
>  	propagate_weights(iocg, iocg->weight,
> @@ -1863,7 +1879,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
>  	list_for_each_entry(iocg, surpluses, surplus_list) {
>  		u32 hwa;
>  
> -		current_hweight(iocg, &hwa, NULL);
> +		current_hweight(iocg, &hwa, &iocg->hweight_inuse);
>  		after_sum += iocg->hweight_after_donation;
>  
>  		if (iocg->hweight_after_donation > hwa) {
> @@ -1946,8 +1962,10 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
>  
>  		iocg->hweight_donating = min(iocg->hweight_donating,
>  					     iocg->hweight_active);
> -		iocg->hweight_after_donation = min(iocg->hweight_after_donation,
> -						   iocg->hweight_donating - 1);
> +		if (iocg->hweight_donating > 1)
> +			iocg->hweight_after_donation =
> +				min(iocg->hweight_after_donation,
> +				    iocg->hweight_donating - 1);
>  		if (WARN_ON_ONCE(iocg->hweight_active <= 1 ||
>  				 iocg->hweight_donating <= 1 ||
>  				 iocg->hweight_after_donation == 0)) {
> @@ -1956,6 +1974,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
>  			pr_cont(": active=%u donating=%u after=%u\n",
>  				iocg->hweight_active, iocg->hweight_donating,
>  				iocg->hweight_after_donation);
> +			goto out;
>  		}
>  	}
>  
> @@ -2054,6 +2073,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
>  		__propagate_weights(iocg, iocg->active, inuse, true, now);
>  	}
>  
> +out:
>  	/* walk list should be dissolved after use */
>  	list_for_each_entry_safe(iocg, tiocg, &inner_walk, walk_list)
>  		list_del_init(&iocg->walk_list);
> @@ -2360,7 +2380,7 @@ static void ioc_timer_fn(struct timer_list *timer)
>  				 */
>  				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
>  						iocg->inuse, iocg->active,
> -						iocg->hweight_inuse, new_hwi);
> +						old_hwi, new_hwi);
>  
>  				__propagate_weights(iocg, iocg->active,
>  						    iocg->active, true, &now);
> @@ -3032,6 +3052,9 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
>  	INIT_LIST_HEAD(&iocg->active_list);
>  	INIT_LIST_HEAD(&iocg->walk_list);
>  	INIT_LIST_HEAD(&iocg->surplus_list);
> +	atomic64_set(&iocg->hweight_cache,
> +		     ((u64)(u32)(atomic_read(&ioc->hweight_gen) - 1) << 32) |
> +		     U32_MAX);
>  	iocg->hweight_active = WEIGHT_ONE;
>  	iocg->hweight_inuse = WEIGHT_ONE;
>  
> diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
> index e772b1bc6..aac25edaa 100644
> --- a/include/trace/events/iocost.h
> +++ b/include/trace/events/iocost.h
> @@ -34,6 +34,8 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
>  	),
>  
>  	TP_fast_assign(
> +		u64 cache = (u64)atomic64_read(&iocg->hweight_cache);
> +
>  		__assign_str(devname);
>  		__assign_str(cgroup);
>  		__entry->now = now->now;
> @@ -44,8 +46,8 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
>  		__entry->vtime = vtime;
>  		__entry->weight = iocg->weight;
>  		__entry->inuse = iocg->inuse;
> -		__entry->hweight_active = iocg->hweight_active;
> -		__entry->hweight_inuse = iocg->hweight_inuse;
> +		__entry->hweight_active = ((cache >> 16) & (WEIGHT_ONE - 1)) + 1;
> +		__entry->hweight_inuse = (cache & (WEIGHT_ONE - 1)) + 1;
>  	),
>  
>  	TP_printk("[%s:%s] now=%llu:%llu vrate=%llu "
> diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
> index bdd78ba27..8a4f844c9 100644
> --- a/tools/cgroup/iocost_monitor.py
> +++ b/tools/cgroup/iocost_monitor.py
> @@ -149,8 +149,11 @@ class IocgStat:
>          self.weight = iocg.weight.value_() / WEIGHT_ONE
>          self.active = iocg.active.value_() / WEIGHT_ONE
>          self.inuse = iocg.inuse.value_() / WEIGHT_ONE
> -        self.hwa_pct = iocg.hweight_active.value_() * 100 / WEIGHT_ONE
> -        self.hwi_pct = iocg.hweight_inuse.value_() * 100 / WEIGHT_ONE
> +        hweight_cache = iocg.hweight_cache.counter.value_()
> +        hwa = ((hweight_cache >> 16) & (WEIGHT_ONE - 1)) + 1
> +        hwi = (hweight_cache & (WEIGHT_ONE - 1)) + 1
> +        self.hwa_pct = hwa * 100 / WEIGHT_ONE
> +        self.hwi_pct = hwi * 100 / WEIGHT_ONE
>          self.address = iocg.value_()
>  
>          vdone = iocg.done_vtime.counter.value_()

