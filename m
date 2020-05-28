From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 14:02:24 -0700
Message-ID: <CALvZod62+Me-n_54W+GiJrXafwFOzd8nfvkLmOBM190sEGJF=g@mail.gmail.com>
References: <20200520143712.GA749486@chrisdown.name> <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw@mail.gmail.com>
 <20200528194831.GA2017@chrisdown.name> <20200528202944.GA76514@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OKXkd/2Goa9jMS89Q94W0ujkvkQZZc4XoblLXbs8npU=;
        b=VfT9vvveDYPm9Ryth8faOYkMaXrBtezGHU2cIz3grKvOlKpU8UUiJtMaij5vwXdW6c
         MdF+q4O4dv+Jcb8D5cFvQ1NJMY+og5fVguE2A9OfoPMqsVw4L0Ys54+bGGMFewoVziYQ
         I19+A4AjOq2Syf5MqR79HZ1F/ONCu86nWMh23r2Mt/ZHnchlc/NfKuw3KtyCBOoeEA2U
         I2ooyEe7iOvV59F5vNcHsuMdRmiaF40OXrPlQxhj1Kx2iO7yklM43zS+UdLMIcuawhef
         6XF7vJbPNkWQmaMi/0UuVksVuaFlAvo7OKkZaNJdBRLauXunE5A0gi7f+t16KjS1/7uU
         eQVA==
In-Reply-To: <20200528202944.GA76514-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, May 28, 2020 at 1:30 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, May 28, 2020 at 08:48:31PM +0100, Chris Down wrote:
> > Shakeel Butt writes:
> > > What was the initial reason to have different behavior in the first place?
> >
> > This differing behaviour is simply a mistake, it was never intended to be
> > this deviate from what happens elsewhere. To that extent this patch is as
> > much a bug fix as it is an improvement.
>
> Yes, it was an oversight.
>
> > > >  static void high_work_func(struct work_struct *work)
> > > > @@ -2378,16 +2384,20 @@ void mem_cgroup_handle_over_high(void)
> > > >  {
> > > >         unsigned long penalty_jiffies;
> > > >         unsigned long pflags;
> > > > +       unsigned long nr_reclaimed;
> > > >         unsigned int nr_pages = current->memcg_nr_pages_over_high;
> > >
> > > Is there any benefit to keep current->memcg_nr_pages_over_high after
> > > this change? Why not just use SWAP_CLUSTER_MAX?
>
> It's there for the same reason why try_to_free_pages() takes a reclaim
> argument in the first place: we want to make the thread allocating the
> most also do the most reclaim work. Consider a thread allocating THPs
> in a loop with another thread allocating regular pages.
>
> Remember that all callers loop. They could theoretically all just ask
> for SWAP_CLUSTER_MAX pages over and over again.
>
> The idea is to have fairness in most cases, and avoid allocation
> failure, premature OOM, and containment failure in the edge cases that
> are caused by the inherent raciness of page reclaim.
>

Thanks for the explanation.

> > I don't feel strongly either way, but current->memcg_nr_pages_over_high can
> > be very large for large allocations.
> >
> > That said, maybe we should just reclaim `max(SWAP_CLUSTER_MAX, current -
> > high)` for each loop? I agree that with this design it looks like perhaps we
> > don't need it any more.
> >
> > Johannes, what do you think?
>
> How about this:
>
> Reclaim memcg_nr_pages_over_high in the first iteration, then switch
> to SWAP_CLUSTER_MAX in the retries.
>
> This acknowledges that while the page allocator and memory.max reclaim
> every time an allocation is made, memory.high is currently batched and
> can have larger targets. We want the allocating thread to reclaim at
> least the batch size, but beyond that only what's necessary to prevent
> premature OOM or failing containment.
>
> Add a comment stating as much.
>
> Once we reclaim memory.high synchronously instead of batched, this
> exceptional handling is no longer needed and can be deleted again.
>
> Does that sound reasonable?

SGTM. It does not seem controversial to me to let the task do the work
to resolve the condition for which it is being throttled.
