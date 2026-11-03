Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717679;
	b=YmOLEX1v/J8kjFmwgHlaBy8QHudXFg448Za9G7t0wtsgK6YycQ77LkEDTUuquJlszHFv
	 2eESLNJMbv7duSJGVdRu29cGdtdnzd4PN3GkjHRzF4InKo1iMwxBx4M2VBzCIGcP70g6O
	 OmARd1gCIm2IC8l0UgYBytWJDN8TtFFhZwm1VMo4ZDKBCEj0TrfXTWe6oqGIBztAKdSGD
	 jYQaysQ55QmqBFhg2pI/oyOzfqgr7ojjhWGU7yj08nxX7LFx9qoatB4iCQw53P7KHFV7G
	 c4JkX8XANUSEWFYlGEUSEOMozuKK6u8un2Emchm2adGNFrb7pNZ6r+5tkYXpJviHERg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717679;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qOY8crhkUmo/P2M0E7e/arrqNxJQQuOOJdNxg87jljQ=;
	b=p7PrcGtk8n6QwtotQr0CnCRmQmfe8oOpoegHP8fWP+alhYXQJ0dnFNCCE+SeAiE2XKVo
	 sRGIqeQI3HO9Gw8Qt9Q29/UDnUmF34Ot/OD0Ubn+kLgxhxFirljbnFjc0AVMG9t5aB5jJ
	 bKTaTFAh9QOCc1vQ7R/agaTOmyx5iJezdX1YtPmymtvfu6V2MDPyFNSQFv415ADJet0xV
	 MZaP6MPm45qbNvo/gVdJeRiC76xKN+hRLB5r43yNXdBDW2mFGbqE0fDV5iOnhQqVmJ3P3
	 CzCklpJCUkd3VPi7ZefrtCRW6Xv/TaSCSflQcSLvG3TNBOFhkSiN2QWhcQDbTvSpVTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oyWNj3a1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00F606A324;
	Tue,  3 Nov 2026 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oyWNj3a1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8FD1F000C1;
	Tue,  3 Nov 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717678;
	bh=qOY8crhkUmo/P2M0E7e/arrqNxJQQuOOJdNxg87jljQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oyWNj3a1vVxuIaAVTUBnHRDIMKYpXa1HPYC0kYU52fKugBKYDBoEpGgu1FOg5S2nE
	 HknINThy2NsIwEGZPkkcQaxa8AurBfZBaio4B6QqlNwqmjH6yX9jgEPE0+N6GF22I1
	 OqQpcPNmz8/GNuFd+bwEB37DAzcA7IbFNo2r24XMQ8/ZCkeWrXUcUaiyeDAtnoKiG/
	 vy+O0FeEBAsB3znZI35TWlV2rOmHRbhqOWgP8dKJcoEfsh10aNP2CbaR2BSz3+0pFA
	 jN7p/RDuVIz41iQVj/ZjD0jKh4uUA5hg1ZYjK2XDuScMiXZjWzFX8Jx/QtzX/DcDK+
	 KzrG84uQHXIrw==
Date: Tue, 3 Nov 2026 14:54:36 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] mm/memcontrol: do not drain objcg stock when
 spinning is not allowed
Message-ID: <aun1FofGFtjPjQHy@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-1-fdf4d17351dd@kernel.org>
 <104794ff-9f04-48be-91e8-89d5d2269f95@kernel.org>
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
In-Reply-To: <104794ff-9f04-48be-91e8-89d5d2269f95@kernel.org>

On Fri, Jun 26, 2026 at 04:30:48PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > When kmalloc_nolock() drains objcg stock, the stock might be holding
> > the last reference to the objcg. Since obj_cgroup_release() is a
> > callback for percpu refcount and does not know whether spinning is
> > allowed, it is not safe to invoke obj_cgroup_put().
> > 
> > This was caught by lockdep on PREEMPT_RT because acquiring
> > a sleeping lock (objcg_lock) violates lock nesting rules:
> > 
> >   kernel: BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
> >   kernel: in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1267, name: systemd-resolve
> >   preempt_count: 1, expected: 0
> >   RCU nest depth: 3, expected: 3
> >   6 locks held by systemd-resolve/1267:
> >    #0: ffff888a8165fa20 ((&pcs->lock)){+.+.}-{3:3}, at: kmem_cache_alloc_noprof+0x185/0xa20
> >    #1: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
> >    #2: ffff888a81648598 ((lock)#4){+.+.}-{3:3}, at: trylock_stock+0x118/0x380
> >    #3: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
> >    #4: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: percpu_ref_put_many.constprop.0+0x40/0x270
> >    #5: ffffffff96af11d8 (objcg_lock){+.+.}-{3:3}, at: obj_cgroup_release+0x8a/0x410
> >   [...]
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x8a/0xe0
> >    dump_stack+0x14/0x1c
> >    __might_resched.cold+0x233/0x2bb
> >    rt_spin_lock+0xd3/0x410
> >    obj_cgroup_release+0x8a/0x410
> >    percpu_ref_put_many.constprop.0+0x226/0x270
> >    drain_obj_stock_slot+0x27e/0x8d0
> >    __refill_obj_stock+0x409/0x6d0
> >    __memcg_slab_post_alloc_hook+0xa45/0x1500
> >    __kmalloc_nolock_noprof+0x988/0xc40
> >    [...]
> > 
> > However, this is illegal in !RT kernels too because the objcg release
> > callback acquires a spinlock even when spinning is not allowed.
> > 
> > To fix this issue, fall back to atomics when the cached objcg doesn't
> > match, but it is unsafe to drain because spinning is not allowed.
> > 
> > This is expected to affect performance of kmalloc_nolock() since
> > it can no longer drain and refill the stock and falls back to a
> > per-objcg atomic counter (objcg->nr_charged_bytes).
> 
> Maybe it's not bad that the constrained operation will not do a drain? Could
> we say it's likely that both _nolock() and normal operations will likely be
> happening on the same cpu for the same memcg, so a normal one will soon
> handle it?

I ended up making obj_cgroup_put() and obj_cgroup_release()
safe to call from any context as in RFC it's easy to overlook that
obj_cgroup_put() is not allowed if !allow_spin.

-- 
Cheers,
Harry / Hyeonggon
