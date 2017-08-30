From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Wed, 30 Aug 2017 11:57:19 +0100
Message-ID: <20170830105719.GB2852@castle.dhcp.TheFacebook.com>
References: <20170829100150.4580-1-guro@fb.com>
 <20170829192621.GA5447@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=CmlVoInciiMzK0r0dqOeBS0lkmAHM6WzBomWgaCShOU=;
 b=hh2HAjj0aI0bg1QfjfnVe5CaMl2dDvz/aXF43jAoUX3a+UHg7rNl4pJgoFpQxTS0WCio
 tqmGAhkOicei8jBdZ4OhelS8BRExH4tzN6XNnXNQm35sttNOBkEUJXguOUJodg0/tYf+
 mj8Fs0i6UyNtI8iB/NdY6G+HAUyaxMBpVxU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CmlVoInciiMzK0r0dqOeBS0lkmAHM6WzBomWgaCShOU=;
 b=bWCI+/DTvrr6itsNJapXjFvfu/snD06YfYAX6Y54PM7clKoZZeRi0pZWKyAvGWYmWf4YNGH49fxdv92OWBc+SBYgtFzhnG+3l/xO6J+z6DYRsLPNp1cS0zgmfn77DpWW4FFgIb47vRpks9FG1MaN5SDPwVdv+/TsTAWKVRvYc3E=
Content-Disposition: inline
In-Reply-To: <20170829192621.GA5447-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Hi, Andrew!

Can you, please, pull this patch?

Thank you!

Roman
