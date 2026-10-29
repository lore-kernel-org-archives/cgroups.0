Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305298;
	b=wZendkL04XsiBiOF/akIWTrthUvhnOTJWjl3M5GvqxwxoICnHRt5qE17wVAb4Lb7qrLO
	 tv9pElGxwy4HFl+c0IU+1DgeQBDPAhPbb9/6loxltp7S36okjNVyoQYRwGm2fGo607Sy2
	 FcjDnbfRs1c9zH6qbiEnr8JTMkxDtZEHSA9ZmCGaUNKWCyff7JizrP1xAe1/azL7RSnm7
	 OOAXMPVU3LuCooXtufB6AEc+pIx7xvBxx0uwROVk2Xds2waIFm26mK2Dxd/JEF2D69zn3
	 KTa3awEBTz2nSfbfRNYIhkPUe91CzTsHhEG4aD01+AEfqem87ybhZ0LdVFksRT0D97Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305298;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sxeoRDyZbXsp21/9MeO6A2aaiq2+hlIXpRLxI4zLeDQ=;
	b=peRHr+SiVmLJhKmIYZhf62ESI8ZSWTFxRmdB/2nZvS4KtUNllKAcMS5foAAhP4+NcHVw
	 0hVDzzNgHhDOj4a12nyyKmf8dHTrrLYhiXCFbM91i16did523wq7LiDCUIEQ1TDsWjAgo
	 OgdaJ1Amr384oGlzP2G9INuG0V8O5H4m/1x81NmEe6RUTGBFLsi8CDuOCvip+VaaVjzxx
	 OP8uIQFkW5pZAmKU9YiaKsNzn6YNcKRyDr8ztMCkWUUy6hfkhvfDmGhQG7F46uhjyIyu8
	 sTOBAyre6AAEmLaV+BoSWGKMgFS/5PYE40pP0kGwfLsKPAR/Bf6iPJt8X1eioknysXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.240
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56503606A31E
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 20:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56503606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FJhtU1xpH0NBjch92Ltx/yhaAPmDS8a/U1CLjsXM7/s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793305295; v=1; x=1793910095;
 b=ssV03S9kgAXb1E4HdWgJ7iMY4bFad++jClMYusrwwCiIQZZwu1OZSPegc/+GZFjjT51I99hy
 5DykCLZbFWFB6zCieW/Tsqa1l0XzkJZdHiBSJvOFFSKA4h8FgRFCCoeFDNehFl5mbDfu3e+WGmC
 ytkXA9qhujcR0xzsY4ZSF4vw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6ce485be16b92af5;
	Thu, 29 Oct 2026 20:21:34 +0000
X-Mizu-Trace-ID: 6ce485be16b92af5
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 13:21:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, jp.kobryn@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memcontrol: fix NULL pointer deref and UAF from
 high_work_func() on dying memcg
Message-ID: <auOqqI6SxvpzUNI7@linux.dev>
References: <20261029201858.2932905-1-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029201858.2932905-1-tjmercier@google.com>

On Thu, Oct 29, 2026 at 01:18:58PM -0700, T.J. Mercier wrote:
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, and
> high_work_func() invokes reclaim_high() without pinning the memcg.
> 
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of holding
> a reference on the child until uncharged. Subsequent uncharges of those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work. This was later widened
> from kernel memory to LRU folios when commit f1cf8d2f36dc ("mm:
> memcontrol: eliminate the problem of dying memory cgroup for LRU
> folios") converted LRU folios to use obj_cgroup reparenting.
> 
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> mem_cgroup_css_free(), so high_work_func() can start or still be running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> NULL pprev pointer. This issue is specific to MGLRU and was introduced
> with the memcg LRU in commit e4dde56cd208 ("mm: multi-gen LRU: per-node
> lru_gen_folio lists").
> 
> With either traditional LRU or MGLRU, css_free_rwork_fn() calls
> css_rstat_exit() which frees per-CPU rstat data before calling
> mem_cgroup_css_free(). If reclaim_high() is still running, rstat updates
> via mod_lruvec_state() -> __css_rstat_updated() cause a use-after-free
> on the per-CPU rstat data. This was introduced when commit 5da3bfa029d6
> ("cgroup: use separate rstat trees for each subsystem") moved
> css_rstat_exit() ahead of ss->css_free().
> 
> Fix both problems by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child and skip checking live
> ancestors in try_charge_memcg().
> 
> Acquiring the reference in high_work_func() rather than before
> scheduling high_work is safe because mem_cgroup_css_free() calls
> irq_work_sync() and cancel_work_sync() which cancels pending work and
> waits for an already running high_work_func() to complete before
> mem_cgroup_free() frees the memcg. css_tryget_online() uses
> percpu_ref_tryget_live() and is safe to call after percpu_ref_exit()
> before the cgroup is freed unlike css_tryget().
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=BAD_PAGE, [W]=WARN  <-- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Call Trace:
>  <TASK>
>  ? read_ctrl_pos+0x22f/0x3f0
>  shrink_lruvec+0x16cb/0x1b80
>  ? ret_from_fork_asm+0x1a/0x30
>  ? lapic_next_event+0x15/0x20
>  ? clockevents_program_event+0x2bb/0x6f0
>  ? lapic_next_event+0x15/0x20
>  ? __pfx_shrink_lruvec+0x10/0x10
>  ? __pfx_clockevents_program_event+0x10/0x10
>  ? _raw_spin_lock+0x84/0xe0
>  ? __pfx__raw_spin_lock+0x10/0x10
>  ? kasan_save_stack+0x30/0x50
>  ? psi_group_change+0x381/0x740
>  ? __pfx_sched_clock_cpu+0x10/0x10
>  ? save_fpregs_to_fpstate+0xc4/0x2c0
>  ? finish_task_switch.isra.0+0x1de/0xac0
>  ? __schedule+0xf62/0x42c0
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx___irq_work_queue_local+0x10/0x10
>  ? shrink_node+0x626/0x31e0
>  shrink_node+0x626/0x31e0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? kswapd_clear_hopeless+0xa0/0x150
>  ? __pfx_shrink_node+0x10/0x10
>  ? 0xffffffffc0000095
>  do_try_to_free_pages+0x255/0x13b0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? reclaim_high+0x10a/0x1b0
>  try_to_free_mem_cgroup_pages+0x1f9/0x5a0
>  ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
>  ? irqentry_exit+0xc6/0x670
>  reclaim_high+0x10a/0x1b0
>  ? __pfx_reclaim_high+0x10/0x10
>  ? process_one_work+0x5ff/0x1030
>  ? __pfx_high_work_func+0x10/0x10
>  process_one_work+0x6e2/0x1030
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx_process_one_work+0x10/0x10
>  worker_thread+0x422/0xbb0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x2cd/0x3a0
>  ? recalc_sigpending+0x15c/0x200
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x368/0x590
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0x588/0xf50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Fixes: 5da3bfa029d6 ("cgroup: use separate rstat trees for each subsystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

