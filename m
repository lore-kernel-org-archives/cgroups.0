Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068942;
	b=ThOGgukQR34XCfqHxm2qG8Kh+/ugfJsCbbylC5tDtHBCv3Sop5pq7AkXo/uVNCV+6QCU
	 0bnO1PH96PZPyN9N92WMapF17YhpR8pbEhx/Cqu8CDu5O/C+LHR8aW0p0NeabTV04NgAr
	 rBM+VV4Kyghj+pOp2oHMsjBz88ksxv8smiTQbJW6MD4cJr3UZuET4bWfCZZtsxMtcF2f2
	 8fBdafEo/HE2KsyEfaP2BxE4Vt7C8arTAdaWjF7Uzw79Wa/8tw7WDlEU49Vacwfxas/Jj
	 nF/rMHY5dVpUb0u8qAcD/BPTuUi+FmD9AlYT3Tcd5ymAcj+1mBBM0JsSRXvyhuxjtoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068942;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=dxplr2PW9T2cb7PCCoveVu/o9kyEMHS33OhsZEP7yEg=;
	b=XUHziRiCo8Rd5h/4TXVqB7vr+rBGa735M8T9f6iC8DTHLGM4a0haE1n6+yXTqxQzRgem
	 Yl4fpwfX7CKrsErmywXpWPCONK2CllIfEuUwWowg/wp51oggSzewdw2LvMZLf4Svmn/T1
	 xLkwsNEcz412ErWnJR1AtHC7nY3fTZtUnvK4WikSxdyMrTUwGIE0ZoXQyWM/jxprXcqvw
	 Rr5tw4ls5p/Zjdp2Al+0xAX4VSYFmHqaT93nPqAYECtODXxWeCy9A33OcVvwLLLk+muRd
	 fClD3oEr26SisTEZ8G+n05sqrP9VoOhWZ3mvol8k4b8cl5GPMPCLjYqqboKSqXcMKMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tD2mSSSy;
	arc=none smtp.remote-ip=95.215.58.36
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9C606A31D
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 02:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFA9C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tD2mSSSy
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gKD0g/74uU1V+yV//x6cgxOJGY2dkcadxe3i7Wn/Ix4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793068935; v=1; x=1793673735;
 b=tD2mSSSyzXdmuLX6KVdugQFsyw1b7iG7GmOImpN1/itubHqCo1p80PTCavTPLSUPHZlFhx8E
 kdonG6dRagUCPraX8M4Yb1SVGDjKGToZ8Rslf1Vs0kigndQKyOKc/jM9MlYrvazE8cqhbtLsrUr
 jBgU4hUSE2VQlrIcekTskbh0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id a11537fa0e8ad6d7;
	Tue, 27 Oct 2026 02:42:14 +0000
X-Mizu-Trace-ID: a11537fa0e8ad6d7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261023222313.3979455-1-tjmercier@google.com>
Date: Tue, 27 Oct 2026 10:42:00 +0800
Cc: hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 zhengqi.arch@bytedance.com,
 akpm@linux-foundation.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev>
References: <20261023222313.3979455-1-tjmercier@google.com>
To: "T.J. Mercier" <tjmercier@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 24, 2026, at 06:23, T.J. Mercier <tjmercier@google.com> wrote:
>=20
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a CSS reference on the =
memcg,
> and high_work_func() invokes reclaim_high() without pinning the memcg.
>=20
> Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), memory usage above memory.high
> kept the memcg's refcount non-zero. With reparenting, folios and =
objcgs
> charged to a child memcg are reparented to its parent in
> mem_cgroup_css_offline(), leaving the offlined child's memory usage
> permanently above its memory.high even after its last reference is
> dropped.
>=20
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown =
in
> mem_cgroup_css_free(), so high_work_func() can start or still be =
running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
> causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.
>=20
> Fix this by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child or skip checking live
> ancestors in try_charge_memcg().
>=20
> Oops: general protection fault, probably for non-canonical address =
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           =
7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from =
lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Tainted: [B]=3DBAD_PAGE, [W]=3DWARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 =
00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c =
07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
> RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
> RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
> RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
> R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? read_ctrl_pos+0x22f/0x3f0
> shrink_lruvec+0x16cb/0x1b80
> ? ret_from_fork_asm+0x1a/0x30
> ? lapic_next_event+0x15/0x20
> ? clockevents_program_event+0x2bb/0x6f0
> ? lapic_next_event+0x15/0x20
> ? __pfx_shrink_lruvec+0x10/0x10
> ? __pfx_clockevents_program_event+0x10/0x10
> ? _raw_spin_lock+0x84/0xe0
> ? __pfx__raw_spin_lock+0x10/0x10
> ? kasan_save_stack+0x30/0x50
> ? psi_group_change+0x381/0x740
> ? __pfx_sched_clock_cpu+0x10/0x10
> ? save_fpregs_to_fpstate+0xc4/0x2c0
> ? finish_task_switch.isra.0+0x1de/0xac0
> ? __schedule+0xf62/0x42c0
> ? __pfx___schedule+0x10/0x10
> ? __pfx___irq_work_queue_local+0x10/0x10
> ? shrink_node+0x626/0x31e0
> shrink_node+0x626/0x31e0
> ? ring_buffer_unlock_commit+0x11d/0x5c0
> ? kswapd_clear_hopeless+0xa0/0x150
> ? __pfx_shrink_node+0x10/0x10
> ? 0xffffffffc0000095
> do_try_to_free_pages+0x255/0x13b0
> ? ring_buffer_unlock_commit+0x11d/0x5c0
> ? reclaim_high+0x10a/0x1b0
> try_to_free_mem_cgroup_pages+0x1f9/0x5a0
> ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> ? irqentry_exit+0xc6/0x670
> reclaim_high+0x10a/0x1b0
> ? __pfx_reclaim_high+0x10/0x10
> ? process_one_work+0x5ff/0x1030
> ? __pfx_high_work_func+0x10/0x10
> process_one_work+0x6e2/0x1030
> ? __pfx___schedule+0x10/0x10
> ? __pfx_process_one_work+0x10/0x10
> worker_thread+0x422/0xbb0
> ? __pfx_worker_thread+0x10/0x10
> kthread+0x2cd/0x3a0
> ? recalc_sigpending+0x15c/0x200
> ? __pfx_kthread+0x10/0x10
> ret_from_fork+0x368/0x590
> ? __pfx_ret_from_fork+0x10/0x10
> ? __switch_to+0x588/0xf50
> ? __pfx_kthread+0x10/0x10
> ret_from_fork_asm+0x1a/0x30
> </TASK>
>=20
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying =
memory cgroup for LRU folios")

Hi T.J.,

Thanks for fixing this.

I have one question about the Fixes tag.

The changelog says that, before f1cf8d2f36dc, memory usage above
memory.high kept the memcg reference count non-zero. This is true for
LRU folios: before that commit, each charged LRU folio held a CSS
reference until it was uncharged.

However, I wonder whether objcg-based kmem already provided a reachable
path before f1cf8d2f36dc.

In particular, BPF alloc_bulk() mostly runs from irq_work. It obtains a
temporary memcg reference from a persistent objcg, uses =
set_active_memcg()
while performing __GFP_ACCOUNT allocations, and drops the temporary
reference after the allocation. The charge can therefore queue
memcg->high_work in non-task context without transferring a CSS
reference to the work item.

If this races with memcg offlining, objcg reparenting can redirect the
objcg to the parent while the old child's page-counter usage remains
above memory.high. Once the temporary CSS reference is dropped,
mem_cgroup_css_released() can call lru_gen_release_memcg() before the
queued high_work runs. The worker can then enter reclaim_high() and
rotate an already removed lrugen.list.

This path appears to have all the required pieces after:

  e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

Commit 6867c7a33206 later changed the release operation to
hlist_nulls_del_init_rcu(), which explains the exact NULL pprev seen in
the reported crash. Before that, the same invalid second deletion would
instead encounter LIST_POISON2.

So f1cf8d2f36dc clearly broadens the problem to ordinary LRU folios, but
I am not very sure it is the first commit after which the underlying =
race is
reachable.

Is there an additional lifetime guarantee that prevents the pre-f1cf
objcg/kmem path above? If no, would the following be more appropriate?

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

Thanks,
Muchun

