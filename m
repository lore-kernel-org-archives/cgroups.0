From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memcg: performance degradation since v5.9
Date: Fri, 9 Apr 2021 12:35:39 -0400
Message-ID: <20210409163539.5374pde3u6gkbg4a@gabell>
References: <20210408193948.vfktg3azh2wrt56t@gabell>
 <YG9tW1h9VSJcir+Y@carbon.dhcp.thefacebook.com>
 <CALvZod58NBQLvk2m7Mb=_0oGCApcNeisxVuE1b+qh1OKDSy0Ag@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SwI9dKNHih0HBykn7XRhBQf79N/hp0URWoW1yNfnjE4=;
        b=DE/mc8yNoAgpMpKewHbtPdEY8ARocDvubcZmUOwitmZr2vnXvYJNoi9x3vNJ0pTJWe
         0oGx3cblI3UJjauam8ZAXKSTpIObJZyHY89b61/7T03rsZzzwIYTffYwaOmp9/lPmIZ9
         VZT1tnOyi4MPbfVGPyBTEkqY2MaQ++pvmgfWaPPwtqhdAtZS8ChfTP8evEz+UaQ9zO/d
         lg4FDs5KrB11z3lPP8kwqVhnqAIbqC3YITLJ+OseurBcK4K6y8LQrYNy+EOnZlZc8igQ
         o+YdG2wsh+74lvNKESPo0KkSLQ2dLWYEN3N66USB9cxjniHHlZ3njS1rgZC+FziT3ps1
         1DMg==
Content-Disposition: inline
In-Reply-To: <CALvZod58NBQLvk2m7Mb=_0oGCApcNeisxVuE1b+qh1OKDSy0Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Apr 08, 2021 at 02:08:13PM -0700, Shakeel Butt wrote:
> On Thu, Apr 8, 2021 at 1:54 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Thu, Apr 08, 2021 at 03:39:48PM -0400, Masayoshi Mizuma wrote:
> > > Hello,
> > >
> > > I detected a performance degradation issue for a benchmark of PostgresSQL [1],
> > > and the issue seems to be related to object level memory cgroup [2].
> > > I would appreciate it if you could give me some ideas to solve it.
> > >
> > > The benchmark shows the transaction per second (tps) and the tps for v5.9
> > > and later kernel get about 10%-20% smaller than v5.8.
> > >
> > > The benchmark does sendto() and recvfrom() system calls repeatedly,
> > > and the duration of the system calls get longer than v5.8.
> > > The result of perf trace of the benchmark is as follows:
> > >
> > >   - v5.8
> > >
> > >    syscall            calls  errors  total       min       avg       max       stddev
> > >                                      (msec)    (msec)    (msec)    (msec)        (%)
> > >    --------------- --------  ------ -------- --------- --------- ---------     ------
> > >    sendto            699574      0  2595.220     0.001     0.004     0.462      0.03%
> > >    recvfrom         1391089 694427  2163.458     0.001     0.002     0.442      0.04%
> > >
> > >   - v5.9
> > >
> > >    syscall            calls  errors  total       min       avg       max       stddev
> > >                                      (msec)    (msec)    (msec)    (msec)        (%)
> > >    --------------- --------  ------ -------- --------- --------- ---------     ------
> > >    sendto            699187      0  3316.948     0.002     0.005     0.044      0.02%
> > >    recvfrom         1397042 698828  2464.995     0.001     0.002     0.025      0.04%
> > >
> > >   - v5.12-rc6
> > >
> > >    syscall            calls  errors  total       min       avg       max       stddev
> > >                                      (msec)    (msec)    (msec)    (msec)        (%)
> > >    --------------- --------  ------ -------- --------- --------- ---------     ------
> > >    sendto            699445      0  3015.642     0.002     0.004     0.027      0.02%
> > >    recvfrom         1395929 697909  2338.783     0.001     0.002     0.024      0.03%
> > >
> 
> Can you please explain how to read these numbers? Or at least put a %
> regression.

Let me summarize them here.
The total duration ('total' column above) of each system call is as follows
if v5.8 is assumed as 100%:

- sendto:
  - v5.8         100%
  - v5.9         128%
  - v5.12-rc6    116%

- revfrom:
  - v5.8         100%
  - v5.9         114%
  - v5.12-rc6    108%

> 
> > > I bisected the kernel patches, then I found the patch series, which add
> > > object level memory cgroup support, causes the degradation.
> > >
> > > I confirmed the delay with a kernel module which just runs
> > > kmem_cache_alloc/kmem_cache_free as follows. The duration is about
> > > 2-3 times than v5.8.
> > >
> > >    dummy_cache = KMEM_CACHE(dummy, SLAB_ACCOUNT);
> > >    for (i = 0; i < 100000000; i++)
> > >    {
> > >            p = kmem_cache_alloc(dummy_cache, GFP_KERNEL);
> > >            kmem_cache_free(dummy_cache, p);
> > >    }
> > >
> > > It seems that the object accounting work in slab_pre_alloc_hook() and
> > > slab_post_alloc_hook() is the overhead.
> > >
> > > cgroup.nokmem kernel parameter doesn't work for my case because it disables
> > > all of kmem accounting.
> 
> The patch is somewhat doing that i.e. disabling memcg accounting for slab.
> 
> > >
> > > The degradation is gone when I apply a patch (at the bottom of this email)
> > > that adds a kernel parameter that expects to fallback to the page level
> > > accounting, however, I'm not sure it's a good approach though...
> >
> > Hello Masayoshi!
> >
> > Thank you for the report!
> >
> > It's not a secret that per-object accounting is more expensive than a per-page
> > allocation. I had micro-benchmark results similar to yours: accounted
> > allocations are about 2x slower. But in general it tends to not affect real
> > workloads, because the cost of allocations is still low and tends to be only
> > a small fraction of the whole cpu load. And because it brings up significant
> > benefits: 40%+ slab memory savings, less fragmentation, more stable workingset,
> > etc, real workloads tend to perform on pair or better.
> >
> > So my first question is if you see the regression in any real workload
> > or it's only about the benchmark?
> >
> > Second, I'll try to take a look into the benchmark to figure out why it's
> > affected so badly, but I'm not sure we can easily fix it. If you have any
> > ideas what kind of objects the benchmark is allocating in big numbers,
> > please let me know.
> >
> 
> One idea would be to increase MEMCG_CHARGE_BATCH.

Thank you for the idea! It's hard-corded as 32 now, so I'm wondering it may be
a good idea to make MEMCG_CHARGE_BATCH tunable from a kernel parameter or something.

Thanks!
Masa
