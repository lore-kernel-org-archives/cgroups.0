Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793155543;
	b=j2H5qJUg5VRwgfE/fYNJMqdE8XLl01FRaVoZLG3mU3Kx3dvu7E8kEJWI8R/RBWhAwfX4
	 3pbQWKgATyLO84ydkIcgqiCRejnrLFN7xcW1+N92A5Z6Gw8emltt5gYRJQa3Hjzx6Kdo9
	 NH719BcPjwaOrIajboOfqhltHzYOoxXy12J5S4W4TlQof4cx/2St3nsbeYz7fmL8im5Bv
	 QqpwH0yeEbbDJ9MALEQUTGQz9WWIGa5En+O3CYghwc7lVmhfr4LhWM/PLtu8dTua16qKU
	 2Kw79Z8CseBVGu35wQvjYEwLZxjvBWAlxfv3mliQakkYylKfP6Ep3ix7es/e6rKmB3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793155543;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=Pzifb9DGH5oVeEHmO9xeHY8G1nYs/tTXaM3a6nLgoI8=;
	b=mXoAiGScRREhtmecIpNpPvtIXCT9fCct6FR42D4zp5CxSviMiTT9RXxV/I7uNcQE8vFn
	 c1xVtUt9YeGc3O4U+cY8c3wo+hqoRHojQB1u7OhEiTJaR9mLWJ1tU/U1P4U8uwShj/P6h
	 xjds6Z2Z7cCFkS6NcoXw9Q935NOIUDEMVPtTTQqHlrmvb2MZwjvOQpRH/ug9XPdSuUyMf
	 hhFRtToQ9lkp68lttQeMxU0tdgjGtaob/J91nohbb6ppWGjEdbdf/tKxkOjwmSUw8FllN
	 tHkeOeY7mEUPtf+ZzWsvU/h3BmaCCwVMKWN7qCg1KFdAj9a5GHfEwlydd3FE/NTfDpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WLtaUbKc;
	arc=none smtp.remote-ip=95.215.58.219
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E64606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 02:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74E64606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WLtaUbKc
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mXTPaQxw8eOvyMaMU78vJQsektczjVENB5s0wOZjHaY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793155540; v=1; x=1793760340;
 b=WLtaUbKcMFSmR/V9Fk87tany1r9QjVrIyZSXVsOlVC3F3qJkpZhxXLhiVmdTC2R32g/U3nF2
 vNklbotP3azN9kEIbOpfE3MI9VWafagRqvy8aftAVjg/1/PFhBJvILVs9pQsqAgzadOD5e/1dE3
 w5vf2GuM+4kgq5IA3AXVA24Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 91429c3f323fe2c4;
	Wed, 28 Oct 2026 02:45:30 +0000
X-Mizu-Trace-ID: 91429c3f323fe2c4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
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
In-Reply-To: <CABdmKX3DEDwgO_wj3JDYvx15FYPKGCav8HKvHC-u_EHdGhWwLg@mail.gmail.com>
Date: Wed, 28 Oct 2026 10:45:11 +0800
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
Message-Id: <47089233-E973-4F25-B64F-DBBBE0F31FC0@linux.dev>
References: <20261023222313.3979455-1-tjmercier@google.com>
 <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev>
 <CABdmKX3-XKWXwZe5f=VwZeSuKH6xM0dsK7TvY7u9B1hgaPOm4g@mail.gmail.com>
 <CABdmKX3DEDwgO_wj3JDYvx15FYPKGCav8HKvHC-u_EHdGhWwLg@mail.gmail.com>
To: "T.J. Mercier" <tjmercier@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 28, 2026, at 07:11, T.J. Mercier <tjmercier@google.com> wrote:
>=20
> On Tue, Oct 27, 2026 at 10:42=E2=80=AFAM T.J. Mercier =
<tjmercier@google.com> wrote:
>>=20
>> On Mon, Oct 26, 2026 at 7:42=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>>=20
>>>=20
>>>=20
>>>> On Oct 24, 2026, at 06:23, T.J. Mercier <tjmercier@google.com> =
wrote:
>>>>=20
>>>> When memory.high is exceeded in non-task context, =
try_charge_memcg()
>>>> schedules memcg->high_work without taking a CSS reference on the =
memcg,
>>>> and high_work_func() invokes reclaim_high() without pinning the =
memcg.
>>>>=20
>>>> Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem =
of
>>>> dying memory cgroup for LRU folios"), memory usage above =
memory.high
>>>> kept the memcg's refcount non-zero. With reparenting, folios and =
objcgs
>>>> charged to a child memcg are reparented to its parent in
>>>> mem_cgroup_css_offline(), leaving the offlined child's memory usage
>>>> permanently above its memory.high even after its last reference is
>>>> dropped.
>>>>=20
>>>> cancel_work_sync(&memcg->high_work) only runs at the end of =
teardown in
>>>> mem_cgroup_css_free(), so high_work_func() can start or still be =
running
>>>> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
>>>> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. =
This
>>>> causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.
>>>>=20
>>>> Fix this by acquiring a reference with css_tryget_online() in
>>>> high_work_func() before calling reclaim_high(), and by resetting
>>>> memory.high and swap.high to PAGE_COUNTER_MAX in
>>>> mem_cgroup_css_offline() so that charges via references on an =
offlined
>>>> memcg do not trigger high_work on the dead child or skip checking =
live
>>>> ancestors in try_charge_memcg().
>>>>=20
>>>> Oops: general protection fault, probably for non-canonical address =
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>>>> KASAN: null-ptr-deref in range =
[0x0000000000000000-0x0000000000000007]
>>>> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W         =
  7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from =
lru_gen_rotate_memcg() VM_WARN_ON_ONCE
>>>> Tainted: [B]=3DBAD_PAGE, [W]=3DWARN
>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-debian-1.17.0-1 04/01/2014
>>>> Workqueue: events high_work_func
>>>> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
>>>> Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 =
00 00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> =
3c 07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
>>>> RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
>>>> RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
>>>> RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
>>>> RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
>>>> R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
>>>> R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
>>>> FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) =
knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
>>>> PKRU: 55555554
>>>> Call Trace:
>>>> <TASK>
>>>> ? read_ctrl_pos+0x22f/0x3f0
>>>> shrink_lruvec+0x16cb/0x1b80
>>>> ? ret_from_fork_asm+0x1a/0x30
>>>> ? lapic_next_event+0x15/0x20
>>>> ? clockevents_program_event+0x2bb/0x6f0
>>>> ? lapic_next_event+0x15/0x20
>>>> ? __pfx_shrink_lruvec+0x10/0x10
>>>> ? __pfx_clockevents_program_event+0x10/0x10
>>>> ? _raw_spin_lock+0x84/0xe0
>>>> ? __pfx__raw_spin_lock+0x10/0x10
>>>> ? kasan_save_stack+0x30/0x50
>>>> ? psi_group_change+0x381/0x740
>>>> ? __pfx_sched_clock_cpu+0x10/0x10
>>>> ? save_fpregs_to_fpstate+0xc4/0x2c0
>>>> ? finish_task_switch.isra.0+0x1de/0xac0
>>>> ? __schedule+0xf62/0x42c0
>>>> ? __pfx___schedule+0x10/0x10
>>>> ? __pfx___irq_work_queue_local+0x10/0x10
>>>> ? shrink_node+0x626/0x31e0
>>>> shrink_node+0x626/0x31e0
>>>> ? ring_buffer_unlock_commit+0x11d/0x5c0
>>>> ? kswapd_clear_hopeless+0xa0/0x150
>>>> ? __pfx_shrink_node+0x10/0x10
>>>> ? 0xffffffffc0000095
>>>> do_try_to_free_pages+0x255/0x13b0
>>>> ? ring_buffer_unlock_commit+0x11d/0x5c0
>>>> ? reclaim_high+0x10a/0x1b0
>>>> try_to_free_mem_cgroup_pages+0x1f9/0x5a0
>>>> ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
>>>> ? irqentry_exit+0xc6/0x670
>>>> reclaim_high+0x10a/0x1b0
>>>> ? __pfx_reclaim_high+0x10/0x10
>>>> ? process_one_work+0x5ff/0x1030
>>>> ? __pfx_high_work_func+0x10/0x10
>>>> process_one_work+0x6e2/0x1030
>>>> ? __pfx___schedule+0x10/0x10
>>>> ? __pfx_process_one_work+0x10/0x10
>>>> worker_thread+0x422/0xbb0
>>>> ? __pfx_worker_thread+0x10/0x10
>>>> kthread+0x2cd/0x3a0
>>>> ? recalc_sigpending+0x15c/0x200
>>>> ? __pfx_kthread+0x10/0x10
>>>> ret_from_fork+0x368/0x590
>>>> ? __pfx_ret_from_fork+0x10/0x10
>>>> ? __switch_to+0x588/0xf50
>>>> ? __pfx_kthread+0x10/0x10
>>>> ret_from_fork_asm+0x1a/0x30
>>>> </TASK>
>>>>=20
>>>> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of =
dying memory cgroup for LRU folios")
>>>=20
>>> Hi T.J.,
>>>=20
>>> Thanks for fixing this.
>>>=20
>>> I have one question about the Fixes tag.
>>>=20
>>> The changelog says that, before f1cf8d2f36dc, memory usage above
>>> memory.high kept the memcg reference count non-zero. This is true =
for
>>> LRU folios: before that commit, each charged LRU folio held a CSS
>>> reference until it was uncharged.
>>>=20
>>> However, I wonder whether objcg-based kmem already provided a =
reachable
>>> path before f1cf8d2f36dc.
>>>=20
>>> In particular, BPF alloc_bulk() mostly runs from irq_work. It =
obtains a
>>> temporary memcg reference from a persistent objcg, uses =
set_active_memcg()
>>> while performing __GFP_ACCOUNT allocations, and drops the temporary
>>> reference after the allocation. The charge can therefore queue
>>> memcg->high_work in non-task context without transferring a CSS
>>> reference to the work item.
>>>=20
>>> If this races with memcg offlining, objcg reparenting can redirect =
the
>>> objcg to the parent while the old child's page-counter usage remains
>>> above memory.high. Once the temporary CSS reference is dropped,
>>> mem_cgroup_css_released() can call lru_gen_release_memcg() before =
the
>>> queued high_work runs. The worker can then enter reclaim_high() and
>>> rotate an already removed lrugen.list.
>>>=20
>>> This path appears to have all the required pieces after:
>>>=20
>>>  e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>>>=20
>>> Commit 6867c7a33206 later changed the release operation to
>>> hlist_nulls_del_init_rcu(), which explains the exact NULL pprev seen =
in
>>> the reported crash. Before that, the same invalid second deletion =
would
>>> instead encounter LIST_POISON2.
>>>=20
>>> So f1cf8d2f36dc clearly broadens the problem to ordinary LRU folios, =
but
>>> I am not very sure it is the first commit after which the underlying =
race is
>>> reachable.
>>>=20
>>> Is there an additional lifetime guarantee that prevents the pre-f1cf
>>> objcg/kmem path above? If no, would the following be more =
appropriate?
>>>=20
>>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio =
lists")
>>>=20
>>> Thanks,
>>> Muchun
>>=20
>> Hi Muchun,
>>=20
>> Everything you said sounds correct to me. I don't think there's
>> anything preventing kmem from keeping the memcg above high while the
>> refcount hits 0, and hitting the same problem in
>> lru_gen_rotate_memcg() from lru_gen_shrink_lruvec().
>>=20
>> So using Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node
>> lru_gen_folio lists") sounds good to me.
>>=20
>> Thanks,
>> T.J.
>=20
> I was able to get a reproduction on e4dde56cd208. Fortunately this
> patch applies cleanly on e4dde56cd208, so I expect the stable
> backports to be straightforward.

Excellent job. Yeah, we need this backported.

Thanks,
Muchun

>=20
> general protection fault, probably for non-canonical address
> 0xfbd59c0000000024: 0000 [#1] PREEMPT SMP KASAN NOPTI
> KASAN: maybe wild-memory-access in range =
[0xdead000000000120-0xdead000000000127]
> CPU: 1 PID: 37 Comm: kworker/1:1 Not tainted =
6.2.0-rc4-00108-ge4dde56cd208 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x147/0xef0
> Code: 49 c1 ea 03 41 80 3c 3a 00 0f 85 a5 09 00 00 48 89 f7 4c 8b 93
> 08 07 00 00 48 c1 ef 03 48 89 fa 48 bf 00 00 00 00 00 fc ff df <80> 3c
> 3a 00 0f 85 2a 07 00 00 4c 89 16 41 f6 c2 01 0f 85 72 00
> RSP: 0018:ffa00000002a75e0 EFLAGS: 00010206
> RAX: ff11000008d46701 RBX: ff11000008d46000 RCX: 0000000000000000
> RDX: 1bd5a00000000024 RSI: dead000000000122 RDI: dffffc0000000000
> RBP: ff110000bfe54000 R08: ff11000008d46708 R09: ff11000008d46710
> R10: ff11000009a5a708 R11: 0000000000000000 R12: 0000000000000006
> R13: 0000000000000004 R14: 1ff4000000054ee4 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ff110000a3480000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000007d5c000 CR4: 0000000000751ee0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? reset_ctrl_pos+0x10f/0x460
> shrink_lruvec+0x19e0/0x2000
> ? kasan_set_track+0x25/0x30
> ? __kasan_slab_alloc+0x66/0x80
> ? kmem_cache_alloc+0x165/0x310
> ? __kernfs_new_node+0xd3/0x590
> ? __kernfs_create_file+0x2d/0x280
> ? sysfs_add_file_mode_ns+0x12b/0x3a0
> ? internal_create_group+0x286/0x940
> ? internal_create_groups+0x84/0x110
> ? really_probe+0x223/0x690
> ? unwind_next_frame+0xa9a/0x2040
> ? arch_stack_walk+0x7a/0x110
> ? unwind_next_frame+0xa9a/0x2040
> ? arch_stack_walk+0x7a/0x110
> ? __pfx_shrink_lruvec+0x10/0x10
> ? preempt_count_add+0x83/0x180
> ? unwind_next_frame+0xb2/0x2040
> ? unwind_next_frame+0x212/0x2040
> ? ret_from_fork+0x2c/0x50
> ? __pfx_stack_trace_consume_entry+0x10/0x10
> ? arch_stack_walk+0xa2/0x110
> ? sched_clock_local+0x132/0x210
> ? __pfx_sched_clock_local+0x10/0x10
> ? unwind_next_frame+0x212/0x2040
> ? __pfx_shrink_slab+0x10/0x10
> ? sched_clock_cpu+0x232/0x2c0
> ? __pfx_sched_clock_local+0x10/0x10
> ? __pfx_sched_clock_cpu+0x10/0x10
> ? mem_cgroup_iter+0x269/0x600
> ? vmpressure+0x30/0x3b0
> shrink_node+0xb39/0x26a0
> ? __pfx_shrink_node+0x10/0x10
> ? kasan_save_stack+0x42/0x60
> ? ring_buffer_lock_reserve+0x2fb/0xe30
> do_try_to_free_pages+0x31a/0x1880
> ? __pfx_do_try_to_free_pages+0x10/0x10
> try_to_free_mem_cgroup_pages+0x282/0x5f0
> ? try_to_free_mem_cgroup_pages+0x4/0x5f0
> ? reclaim_high.constprop.0+0x191/0x250
> ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> ? try_to_free_mem_cgroup_pages+0x9/0x5f0
> reclaim_high.constprop.0+0x191/0x250
> ? __pfx_reclaim_high.constprop.0+0x10/0x10
> ? __pfx_high_work_func+0x10/0x10
> process_one_work+0x641/0x1010
> worker_thread+0x424/0xec0
> ? __kthread_parkme+0x89/0x160
> ? __pfx_worker_thread+0x10/0x10
> kthread+0x26c/0x300
> ? __pfx_kthread+0x10/0x10
> ret_from_fork+0x2c/0x50
> </TASK>

