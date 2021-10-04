From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: optimize flush through speculative test
Date: Mon, 4 Oct 2021 11:07:45 -0700
Message-ID: <CALvZod47r=9j_MhZz9ngWv_JE4oqF1CrXTOQ2GpSSNFftZAsVA@mail.gmail.com>
References: <20210929235936.2859271-1-shakeelb@google.com> <YVszNI97NAAYpHpm@slm.duckdns.org>
 <CALvZod5OKz=7pFpxCt1CONPyJO4wR5t+PH0nzdbFBT1SYpjrsg@mail.gmail.com> <YVs9eJnNJYwF/3f3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wD6uuf3ru6YVNe7+4jEAmC2naccUsJPrRjEclRtsE7k=;
        b=ay567YeX+xvQosVRiRU+umrEP8Dfr/v0GOPuimkdV+SH13Kr5erX7ASGE7cibqmECp
         ey6exYQnFbUcRE1FQYpqaATUQPWZ8lOCy8w2kg2OznxoEVJUociUrntfZqHwTYXRjfk3
         ztjnw7OKKSOhPVODNyjj6gwan7EqdlVeXHgBUwMiMIGhjI/jXl/ZV31Y8Xh5TMJDyTa4
         eG7amjqFkoL3vGXo5P/UoueH7Mhhov2pn0NMg0MLjxEP8lAy98+ZjFJ/N9z2G7ytAKVL
         w/D48MG83NvxCGzXK6TtUUdXRDKy8ieLL/unqgmBFCFBVVG8LoKWdA9H1tXcEwOcQYQD
         ZPKQ==
In-Reply-To: <YVs9eJnNJYwF/3f3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Oct 4, 2021 at 10:44 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Oct 04, 2021 at 10:25:12AM -0700, Shakeel Butt wrote:
> > > > To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
> > > > a system with swap-on-zram and the file was pushed to swap through
> > > > memory.force_empty interface. On reading the whole file, the memcg stat
> > > > flush in the refault code path is triggered. With this patch, we
> > > > observed 38% reduction in the read time of 8 GiB file.
> > >
> > > The patch looks fine to me but that's a lot of reduction in read time. Can
> > > you elaborate a bit on why this makes such a huge difference? Who's hitting
> > > on that lock so hard?
> >
> > It was actually due to machine size. I ran a single threaded workload
> > without any interference on a 112 cpus machine. So, most of the time
> > the flush was acquiring and releasing the per-cpu rstat lock for empty
> > trees.
>
> Sorry for being so slow but can you point to the exact call path which gets
> slowed down so significantly?

This is the mem_cgroup_flush_stats() inside workingset_refault() in
mm/workingset.c.

> I'm mostly wondering whether we need some sort
> of time-batched flushes because even with lock avoidance the flush path
> really isn't great when called frequently. We can mitigate it further if
> necessary - e.g. by adding an "updated" bitmap so that the flusher doesn't
> have to go around touching the cachelines for all the cpus.

For the memcg stats, I already proposed a batched flush at [1].

I actually did perform the same experiment with the proposed patch
along with [1] and it improves around just 1%. More specifically for
memcg stats [1] is good enough but that is memcg specific and this
patch has merits on its own.

[1] https://lkml.kernel.org/r/20210930044711.2892660-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

>
> Thanks.

>
> --
> tejun
