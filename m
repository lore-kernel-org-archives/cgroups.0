From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 16:29:44 -0400
Message-ID: <20200528202944.GA76514@cmpxchg.org>
References: <20200520143712.GA749486@chrisdown.name>
 <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw@mail.gmail.com>
 <20200528194831.GA2017@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+uuww7KS91z0nXdlfs6K0/JqdQm8qFbzuFZ4bz09+E=;
        b=T4uR5w6goaSmuZxanF5ibEDLR8DFMtolK8czTkUsdCgVU67PtXlnMbDfpVYllqkPdI
         ApaK+UVOxphIh9ZQT/kWCm1zbqNmWRM1ksEGDCHEZCcVLh+z30c3RlIIDNlT7dt2nxK7
         2nkmg9EE4K1ZcS8zZYoUlOYOGI/2pvlmSrk3LIxjTVmqZE27/Fy99p/3ARprz8FNgs2B
         ZsNM2pMLHy64De2YYBpEgborefHSARHN9BYvXsZthJqYuQHlnmYjq2qWw0+nB2cy0Uy6
         FyfRDokq88+4H7WW13zWbxn43F+gkRR01F5iYVcLzpEm4XwU9Oqdv0i9njeXjCFft77e
         Rrug==
Content-Disposition: inline
In-Reply-To: <20200528194831.GA2017-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, May 28, 2020 at 08:48:31PM +0100, Chris Down wrote:
> Shakeel Butt writes:
> > What was the initial reason to have different behavior in the first place?
> 
> This differing behaviour is simply a mistake, it was never intended to be
> this deviate from what happens elsewhere. To that extent this patch is as
> much a bug fix as it is an improvement.

Yes, it was an oversight.

> > >  static void high_work_func(struct work_struct *work)
> > > @@ -2378,16 +2384,20 @@ void mem_cgroup_handle_over_high(void)
> > >  {
> > >         unsigned long penalty_jiffies;
> > >         unsigned long pflags;
> > > +       unsigned long nr_reclaimed;
> > >         unsigned int nr_pages = current->memcg_nr_pages_over_high;
> > 
> > Is there any benefit to keep current->memcg_nr_pages_over_high after
> > this change? Why not just use SWAP_CLUSTER_MAX?

It's there for the same reason why try_to_free_pages() takes a reclaim
argument in the first place: we want to make the thread allocating the
most also do the most reclaim work. Consider a thread allocating THPs
in a loop with another thread allocating regular pages.

Remember that all callers loop. They could theoretically all just ask
for SWAP_CLUSTER_MAX pages over and over again.

The idea is to have fairness in most cases, and avoid allocation
failure, premature OOM, and containment failure in the edge cases that
are caused by the inherent raciness of page reclaim.

> I don't feel strongly either way, but current->memcg_nr_pages_over_high can
> be very large for large allocations.
> 
> That said, maybe we should just reclaim `max(SWAP_CLUSTER_MAX, current -
> high)` for each loop? I agree that with this design it looks like perhaps we
> don't need it any more.
> 
> Johannes, what do you think?

How about this:

Reclaim memcg_nr_pages_over_high in the first iteration, then switch
to SWAP_CLUSTER_MAX in the retries.

This acknowledges that while the page allocator and memory.max reclaim
every time an allocation is made, memory.high is currently batched and
can have larger targets. We want the allocating thread to reclaim at
least the batch size, but beyond that only what's necessary to prevent
premature OOM or failing containment.

Add a comment stating as much.

Once we reclaim memory.high synchronously instead of batched, this
exceptional handling is no longer needed and can be deleted again.

Does that sound reasonable?
