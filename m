From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2 3/4] mm/slub: Fix another circular locking dependency
 in slab_attr_store()
Date: Mon, 18 May 2020 22:37:46 -0400
Message-ID: <CAG=TAF78e=71-cUt2jaTgY8QZDmucRO2JRo-rEWALe+dGVxoQw@mail.gmail.com>
References: <20200427235621.7823-4-longman@redhat.com> <F1FA6654-C07C-42FD-B497-61EB635B264C@lca.pw>
 <638f59c0-60f1-2279-fea6-28b2980720f4@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1cHkZoHQXI3aEuEjslUR4plc1ANHqu9wqQB4RG/kOcg=;
        b=Mh9PV2beR8kr3sxrsvtSNBQkdVdaxMDyWEAR2BMrKGoZGEcLEsnHv0wI4lF5m6XERu
         JvelpzFXtcY8ryrfqTkyQEGTQmv4WXI2Dh7AjkIKEytkAabZGXbXoTPk31UF9p6/tjlK
         LQaieh22LBBb9He/v+ecjLB0cQvCZ/TTiegmxZwkYTp7SptjPtEpPVKmYxbwwxGo4j6H
         PXQfoOTEvBRVFcUUkwhkowsJGWpLTkrTc93AG0Dyk2c6Kizmq3BsUbSgXap+UhHnOWfI
         bFuWi+hQxnmLCCP7Fa2oF9mX2/zuzfQTqydfJMT5u9z75zlp+ALwcqCBOeSUIXEUdQG8
         qkvA==
In-Reply-To: <638f59c0-60f1-2279-fea6-28b2980720f4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, May 18, 2020 at 6:05 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 5/16/20 10:19 PM, Qian Cai wrote:
> >
> >> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> It turns out that switching from slab_mutex to memcg_cache_ids_sem in
> >> slab_attr_store() does not completely eliminate circular locking dependency
> >> as shown by the following lockdep splat when the system is shut down:
> >>
> >> [ 2095.079697] Chain exists of:
> >> [ 2095.079697]   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
> >> [ 2095.079697]
> >> [ 2095.090278]  Possible unsafe locking scenario:
> >> [ 2095.090278]
> >> [ 2095.096227]        CPU0                    CPU1
> >> [ 2095.100779]        ----                    ----
> >> [ 2095.105331]   lock(slab_mutex);
> >> [ 2095.108486]                                lock(memcg_cache_ids_sem);
> >> [ 2095.114961]                                lock(slab_mutex);
> >> [ 2095.120649]   lock(kn->count#278);
> >> [ 2095.124068]
> >> [ 2095.124068]  *** DEADLOCK ***
> > Can you show the full splat?
> >
> >> To eliminate this possibility, we have to use trylock to acquire
> >> memcg_cache_ids_sem. Unlikely slab_mutex which can be acquired in
> >> many places, the memcg_cache_ids_sem write lock is only acquired
> >> in memcg_alloc_cache_id() to double the size of memcg_nr_cache_ids.
> >> So the chance of successive calls to memcg_alloc_cache_id() within
> >> a short time is pretty low. As a result, we can retry the read lock
> >> acquisition a few times if the first attempt fails.
> >>
> >> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > The code looks a bit hacky and probably not that robust. Since it is the shutdown path which is not all that important without lockdep, maybe you could drop this single patch for now until there is a better solution?
>
> That is true. Unlike using the slab_mutex, the chance of failing to
> acquire a read lock on memcg_cache_ids_sem is pretty low. Maybe just
> print_once a warning if that happen.

That seems cleaner. If you are going to repost this series, you could
also mention that the series will fix slabinfo triggering a splat as
well.
