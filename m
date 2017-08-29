From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Tue, 29 Aug 2017 15:26:21 -0400
Message-ID: <20170829192621.GA5447@cmpxchg.org>
References: <20170829100150.4580-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sU5l1qYG950Xbeuo6uGmiG4wPcwER8Fxdlffshp8a4U=; b=CuoRNWssYr7ySEJF8FYaZrctEJ
	GQtxRciQUTj0m7GEB0UEYKjQGhl70lfA6uIIMZClyGJ72e483blYucaLPolRFWlb9Ie7cuGs67fn1
	UZ8RKn4SKfyFXxG8IM+rY5jskfxDX0+rQX8IcEUzjDF9mKjDE5DrZaYXoQLP6tRb/i14=;
Content-Disposition: inline
In-Reply-To: <20170829100150.4580-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Tue, Aug 29, 2017 at 11:01:50AM +0100, Roman Gushchin wrote:
> We've noticed a quite sensible performance overhead on some hosts
> with significant network traffic when socket memory accounting
> is enabled.
> 
> Perf top shows that socket memory uncharging path is hot:
>   2.13%  [kernel]                [k] page_counter_cancel
>   1.14%  [kernel]                [k] __sk_mem_reduce_allocated
>   1.14%  [kernel]                [k] _raw_spin_lock
>   0.87%  [kernel]                [k] _raw_spin_lock_irqsave
>   0.84%  [kernel]                [k] tcp_ack
>   0.84%  [kernel]                [k] ixgbe_poll
>   0.83%  < workload >
>   0.82%  [kernel]                [k] enqueue_entity
>   0.68%  [kernel]                [k] __fget
>   0.68%  [kernel]                [k] tcp_delack_timer_handler
>   0.67%  [kernel]                [k] __schedule
>   0.60%  < workload >
>   0.59%  [kernel]                [k] __inet6_lookup_established
>   0.55%  [kernel]                [k] __switch_to
>   0.55%  [kernel]                [k] menu_select
>   0.54%  libc-2.20.so            [.] __memcpy_avx_unaligned
> 
> To address this issue, the existing per-cpu stock infrastructure
> can be used.
> 
> refill_stock() can be called from mem_cgroup_uncharge_skmem()
> to move charge to a per-cpu stock instead of calling atomic
> page_counter_uncharge().
> 
> To prevent the uncontrolled growth of per-cpu stocks,
> refill_stock() will explicitly drain the cached charge,
> if the cached value exceeds CHARGE_BATCH.
> 
> This allows significantly optimize the load:
>   1.21%  [kernel]                [k] _raw_spin_lock
>   1.01%  [kernel]                [k] ixgbe_poll
>   0.92%  [kernel]                [k] _raw_spin_lock_irqsave
>   0.90%  [kernel]                [k] enqueue_entity
>   0.86%  [kernel]                [k] tcp_ack
>   0.85%  < workload >
>   0.74%  perf-11120.map          [.] 0x000000000061bf24
>   0.73%  [kernel]                [k] __schedule
>   0.67%  [kernel]                [k] __fget
>   0.63%  [kernel]                [k] __inet6_lookup_established
>   0.62%  [kernel]                [k] menu_select
>   0.59%  < workload >
>   0.59%  [kernel]                [k] __switch_to
>   0.57%  libc-2.20.so            [.] __memcpy_avx_unaligned
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: cgroups@vger.kernel.org
> Cc: kernel-team@fb.com
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Neat!

As far as other types of pages go: page cache and anon are already
batched pretty well, but I think kmem might benefit from this
too. Have you considered using the stock in memcg_kmem_uncharge()?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
