Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239910;
	b=DpcIIbGZiOblkkajbZG7D6d80hBDbOylBWXZIiGeDMdMsCXeFBtwf+IE0C5a3SVVoR00
	 WZdK2vkceFaS8r+S/SJKsjXrSz3DQ/DZ+aDHIjExbQ16sCekcwMGbvfShBAvXF6OJ6/kS
	 Z8EJYphHubIOoYf34Sa6qJ86zIY/qjuqeu4xJCCpR3UMsIBBheyvTbAfDMhxf/dSFLJE3
	 dZ3lDPdom4RLSnVNOe6KpkSQosfC3ALjP3KgyrhKi0U3w11WPbEvc62kzQdH+Z6bh0uB0
	 hv0F+msREr5yxnUVOwdz8UeQqeXJEjQwcKEnMY2GEj13dl8ctQSCRawnw+Ul51M0nnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239910;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=mVKxjTQ6UG8yet0iVDC28m2Sx/BGphnHT3RcdUiLOnw=;
	b=DQKv/9/BL6ls13DQfVMC8c0HacCKWC9y5IP3y20ukOEp2ZcMkK9oGH55Svt2HLg3COBt
	 swXvQYsjr0KgIY3rpfES9jm/1dGh9pPd+wFgTXOerkpjsNgoOc3XNNd9xvCZ8j+Ft6Yg1
	 j5B2bjvKqpadMmD3jM/fjTamWaNTAKG9SH3jeJvL43T2HW884/Yq+H4uHMu4UEVxXnMsp
	 U8+sQETubU6eUFDcedfnqFBKvdow9pNr+YRZ4II8ipTF6vKyL6qrVAFZ8vmuHZrNTUL6s
	 aVMKVlt4hRvtLzxpaPM/SCyaI6Giu9sfKEs2u8EALFPdVnCIsl+DFkq3y4o+fps2jfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KcoVZ9Ki;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C765606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 02:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C765606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KcoVZ9Ki
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZQDzLzCYKeslFW51nWI96JVuF6FVhrDvErS7kuNB0xE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793239907; v=1; x=1793844707;
 b=KcoVZ9KiO7ifplBtH9vusLY0AzPaM1tqGMNzq0Y6J3apzT4pko9SLT/o6KFyMzGTB/qi5ZID
 Zi48Jpe34rZ644v4xEFbdD6xlpj537RTcNftZtjfP6IIzx2eiQ7UPGWr7iKOoLwsujDy9miu+e3
 zCnO04cDP4696Lg8o1cXz9rg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 252b47a0223e58b7;
	Thu, 29 Oct 2026 02:11:47 +0000
X-Mizu-Trace-ID: 252b47a0223e58b7
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
Subject: Re: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028183537.605854-1-tjmercier@google.com>
Date: Thu, 29 Oct 2026 10:11:26 +0800
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
Message-Id: <13AA7E01-2DAD-49CE-8C59-A99BBA917B99@linux.dev>
References: <20261028183537.605854-1-tjmercier@google.com>
To: "T.J. Mercier" <tjmercier@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 29, 2026, at 02:35, T.J. Mercier <tjmercier@google.com> wrote:
>=20
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, =
and
> high_work_func() invokes reclaim_high() without pinning the memcg.
>=20
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown =
in
> mem_cgroup_css_free(), so high_work_func() can start or still be =
running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences =
a
> NULL pprev pointer.
>=20
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of =
holding
> a reference on the child until uncharged. Subsequent uncharges of =
those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work.
>=20
> This problem was first exposed when commit e4dde56cd208 ("mm: =
multi-gen
> LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
> later widened from kernel memory to LRU folios when
> commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
> memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
> reparenting.
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
7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE, [W]=3DWARN <- Taint from =
lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
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
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio =
lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

