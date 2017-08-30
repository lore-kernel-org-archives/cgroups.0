From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Wed, 30 Aug 2017 11:55:24 +0100
Message-ID: <20170830105524.GA2852@castle.dhcp.TheFacebook.com>
References: <20170829100150.4580-1-guro@fb.com>
 <20170829192621.GA5447@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=NBkUNY16uNSUXEyC00g5pjnAYKnpF+kOqCPXA4dTBU4=;
 b=jSDpf8l9/sEibonfkrsntiqWlFEcH4+W40rqj9NpmVZQ7nh3dsq618Q805OZlIgfXMvp
 Yhbfe4ajrH8i4V0unMu6J96UIkKFI1vfmxRKImlCQC8ZYoPriFndHc5xouTsjd2hCTnR
 /t5Saop4OzurUIWjlJmVoQXWJKxy8o3HQoI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NBkUNY16uNSUXEyC00g5pjnAYKnpF+kOqCPXA4dTBU4=;
 b=QGF8YxVBkJx7j1m5w8HnpwVBeZbQY6Iot3WvaXEFGAxXLSzpcGo/uyh1/u9RhH9J+3T1FYvTagMUpy1TsThM32DOALys+sBoOeCTRO3gQEoHf5GmcLzHpWY/tBuexmDVsF/w/RgMYxmyTUT8W0Nwtvf3G/PRLrBDysTkDQeXF38=
Content-Disposition: inline
In-Reply-To: <20170829192621.GA5447-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 29, 2017 at 03:26:21PM -0400, Johannes Weiner wrote:
> On Tue, Aug 29, 2017 at 11:01:50AM +0100, Roman Gushchin wrote:
> > We've noticed a quite sensible performance overhead on some hosts
> > with significant network traffic when socket memory accounting
> > is enabled.
> > 
> > Perf top shows that socket memory uncharging path is hot:
> >   2.13%  [kernel]                [k] page_counter_cancel
> >   1.14%  [kernel]                [k] __sk_mem_reduce_allocated
> >   1.14%  [kernel]                [k] _raw_spin_lock
> >   0.87%  [kernel]                [k] _raw_spin_lock_irqsave
> >   0.84%  [kernel]                [k] tcp_ack
> >   0.84%  [kernel]                [k] ixgbe_poll
> >   0.83%  < workload >
> >   0.82%  [kernel]                [k] enqueue_entity
> >   0.68%  [kernel]                [k] __fget
> >   0.68%  [kernel]                [k] tcp_delack_timer_handler
> >   0.67%  [kernel]                [k] __schedule
> >   0.60%  < workload >
> >   0.59%  [kernel]                [k] __inet6_lookup_established
> >   0.55%  [kernel]                [k] __switch_to
> >   0.55%  [kernel]                [k] menu_select
> >   0.54%  libc-2.20.so            [.] __memcpy_avx_unaligned
> > 
> > To address this issue, the existing per-cpu stock infrastructure
> > can be used.
> > 
> > refill_stock() can be called from mem_cgroup_uncharge_skmem()
> > to move charge to a per-cpu stock instead of calling atomic
> > page_counter_uncharge().
> > 
> > To prevent the uncontrolled growth of per-cpu stocks,
> > refill_stock() will explicitly drain the cached charge,
> > if the cached value exceeds CHARGE_BATCH.
> > 
> > This allows significantly optimize the load:
> >   1.21%  [kernel]                [k] _raw_spin_lock
> >   1.01%  [kernel]                [k] ixgbe_poll
> >   0.92%  [kernel]                [k] _raw_spin_lock_irqsave
> >   0.90%  [kernel]                [k] enqueue_entity
> >   0.86%  [kernel]                [k] tcp_ack
> >   0.85%  < workload >
> >   0.74%  perf-11120.map          [.] 0x000000000061bf24
> >   0.73%  [kernel]                [k] __schedule
> >   0.67%  [kernel]                [k] __fget
> >   0.63%  [kernel]                [k] __inet6_lookup_established
> >   0.62%  [kernel]                [k] menu_select
> >   0.59%  < workload >
> >   0.59%  [kernel]                [k] __switch_to
> >   0.57%  libc-2.20.so            [.] __memcpy_avx_unaligned
> > 
> > Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Neat!
> 
> As far as other types of pages go: page cache and anon are already
> batched pretty well, but I think kmem might benefit from this
> too. Have you considered using the stock in memcg_kmem_uncharge()?

Good idea!
I'll try to find an appropriate testcase and check if it really
brings any benefits. If so, I'll master a patch.

Thanks!
