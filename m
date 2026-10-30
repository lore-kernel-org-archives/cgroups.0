Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377889;
	b=vTDaUzVOglOwXWx/2G/yefmY//hiCSg3yWDjjlBv1iN9syAFDT2L1x5FG4P50iZgDRgK
	 jhGa1lVQnv84GvZjKm70biKCimQjDXDycoKiK4m5Y6ye9jdnzV1BAs5yqAqfW/M2ekUzO
	 4CmzMqxU2PYckTP5r10hU+uB31Qi2eYRG932UxymaP0oemJxj7j0gSvG74sjK1UhayKt+
	 33+ZKSVVRAFUxjyTSDUzd9pvTuaQr0Xo0zTvRBUbRfKvhv1n1bmnSuENbcjHA1IthRRSl
	 H/gWex4KkEV7W0TmATqISSdT8bCX+arw5qjfHNLprkQL2RbM4EDXghn1IsNlAkMZMlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
	b=JQFj3ujAQ6n8fO37T+3b7NjvEpTeLvg9229DbmSbDjGOmeVq2fCbip+9vwPFvDOiv1Gp
	 tAFefSJE8OpqiNd4z8mci3XP6UDiaWKCQSErSW3nAuA2Dij7+lxQj5EUtYe3CPRK3WH1z
	 PSaklftt2liD8g8fkomvat4bukizJSVEmW9+XGBkVSMtf4/sX99eF1O5ZRI3p8BaZok/i
	 pn7Lug2vk2rnSNcGo+Kw44huWAiIENDewyG3AaW4CX+ghviohn6+g16Lsd1Sn6zhSr7Q7
	 G5DevZACcCoZOVxfK/LsuF+tW0ZKKY1ak5Qj1+2vlsHMk/XNnJv9sYwlcxQEpzZEYKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=GEHo4ZEB;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C48606A327
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 16:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C48606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=GEHo4ZEB
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48bbb06e746so469628f8f.3
        for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 09:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793377887; x=1793982687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
        b=GEHo4ZEBbPgIqvKH/esYl4bKEwIgrqYul6cG5ju2hvDLzsBHXTbzLIiQof86MeshRT
         0ccaU+Crjup3egqCgGqPwbBMF/SS5dnC+03U0HRLqdK8p6QCiKO7dEQFBlnPlS0xfXZj
         SbBbAE9WGm2wyHttP9/9yCtzN9YFhBUPOdvJIRMwxZgFLqcwzm8jmeYRExcBIGXaXWwk
         uB6rnPnnxrsmdrLUEg7DRr9LI7bOjPuFmI3t7aMuh6GeX/gg0Fy+aG4w8iHa64aeeDb4
         3y1LRVwrhxbt2pHJ0H8U9bIWcLF8FU3QjUR3HvgyEZMQuQS9JcJoYOOZ7s6gXaykSEdc
         yZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793377887; x=1793982687;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
        b=qBzm1cyh2LC5do/Ua4WqjJIXZVKLHQw7lzKnVY8Nd/BcSyutTCOghYZI2xOPOKte8+
         CTucPB1Po1KmpTMPJ3BV8QbZ3ujZdHQsdWzYPVi88OCYTmqgtoBNTXkuqBnh4tDf1wtz
         NyrcnMsei/Mvc7eT0g5ajplaaedo449hN7KnU6AYM3s5fhJs1JQv4dzjjaNNEYL+RcKv
         vxr4l18wyadUeMkyzLudJcFrpqE6LBJL/QZluXte2dZLrDmeC4VZwBlqYDtCMGUanJ2g
         Xld0MbXrgfLu3MfpffVj5pBx/jWjtwFeQI5j8RVMHiLi54uWm2vHsfb1NEQXYDCtIG6g
         eaGw==
X-Forwarded-Encrypted: i=1; AKwUvBybjQWgH2vcDMnJT0dIR7bm5GMA71L7xOpVhgCxhxJs3Y29oQvaHa3HVcbuIFjMp3/j4bg5qNvY@vger.kernel.org
X-Gm-Message-State: AFq9FYLwUnvZYk7d9ptqd+yttWiZ2CrYOJ0duL6+cZfaBAK/BsNHux14
	DvXtEPRITM9C/djp3RUljZHYcuyEICGZSoICV2q/I1kYO1S4cR+D3eXxdCUgmWVU2g0=
X-Gm-Gg: AYBFou0exMPxIGHYP+aYBLFFBTr8hk2CSdp371tS/m7rVflosvJMmq4HPzTfN+obbsS
	bSdHWB0O2YmesaFkHd8MzO4pIXj8HIeXT08roUX4J0XYKofaYRRvbpZ15uR41aXEnSfgm9E8Gyg
	7V9OQL5aRKEnol7SDA/BHtnj8KVhhqheQJ77jlkHn9IjtzJf+rfmruQDjwQeEuMVoz3Aber2mVO
	oP0zGL84eAB/pSjptBjRDi6ucRaQuqn7suqGI/JbJi5tG+q1Gl9DA+FnDYWJL/kYFMFTJco3s+l
	irecCNhZocbx3rPhOBYWk7zyBvimc7ENBSGJgtM7eOhFbEFAFrFsEY/7PPU6hdmkRdHOt6sHvYV
	Noz22U3OtV7ceZ9FhBE85JZUXAoumY18MiCyrQGZDyKC2hdJwaJLV9Z8hkJme8WR+1GW46xunFs
	DL+NEfGwav8t2jVx4Y4Cw0INnFMhZk8lc5sm7Zx91dFAsatr5RxJU3szQ7s7hjE2lxlfhreLfFA
	gFEmoe/+2YY2zfPC45+f67d0cgionLQRW8geV/f1bZrxuhBT+fZjwxXXsHzj1OB5wl03gkh2oTo
	z3OUFYZbbJSuUHUgvSG5tE2tHotqBNfBE99qTb7gLorYI3xd8se5O1WoUPtTUDAM
X-Received: by 2002:a05:6000:2282:b0:48d:f14a:9188 with SMTP id ffacd0b85a97d-48e73851611mr3804299f8f.17.1793377887133;
        Fri, 30 Oct 2026 09:31:27 -0700 (PDT)
Received: from localhost (109-81-92-234.rct.o2.cz. [109.81.92.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b728ddsm4025629f8f.9.2026.10.30.09.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:31:26 -0700 (PDT)
Date: Fri, 30 Oct 2026 17:31:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	jp.kobryn@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memcontrol: fix NULL pointer deref and UAF from
 high_work_func() on dying memcg
Message-ID: <auTGXWh2uGK_slxF@tiehlicka>
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

On Thu 29-10-26 13:18:58, T.J. Mercier wrote:
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

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

-- 
Michal Hocko
SUSE Labs
