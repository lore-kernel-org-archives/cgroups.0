From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 22 Sep 2020 11:10:17 -0700
Message-ID: <CALvZod7K9g9mi599c5+ayLeC4__kckv155QQGVMVy2rXXOY1Rw@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200921163055.GQ12990@dhcp22.suse.cz>
 <CALvZod43VXKZ3StaGXK_EZG_fKcW3v3=cEYOWFwp4HNJpOOf8g@mail.gmail.com>
 <20200922114908.GZ12990@dhcp22.suse.cz> <CALvZod4FvE12o53BpeH5WB_McTdCkFTFXgc9gcT1CEHXzQLy_A@mail.gmail.com>
 <20200922165527.GD12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxgAr/AiZIGS3F5DA7CiQoFM4Z4cnpWVYbJLZoh9u3A=;
        b=bGUgLennYN/rsSq/6L0ik+O8ExptMS8MyFI1oMlMsKzUz2ja+yAKaydP9CmuTsVufw
         CcanCsWTdDQTDSLh4nrO9Jjp+E+UfQxqeV0RCuX4XZpyYoJh1wcyHLIcbN57kOsLUkC/
         m4dfL9u84lQAEsgavSweIqTiyNqZvLR0hoNs1PMGHXoKJos5UTiWcHvjYTUUyh+Ti6dQ
         H35MzRTwtXYlSKRxARIUA4zP4IQzr9UpSm6QJs89+tpjx4v0ouHMslYZyOGBLtASE6I2
         iSZfu4IJvDTv9Fb1enjrJDq+jY9pTbM3MgZtF8nsiI4gyNFwnwkuv4MN3WAxUMSFbTgS
         YXpA==
In-Reply-To: <20200922165527.GD12990-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Sep 22, 2020 at 9:55 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 22-09-20 08:54:25, Shakeel Butt wrote:
> > On Tue, Sep 22, 2020 at 4:49 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Mon 21-09-20 10:50:14, Shakeel Butt wrote:
> [...]
> > > > Let me add one more point. Even if the high limit reclaim is swift, it
> > > > can still take 100s of usecs. Most of our jobs are anon-only and we
> > > > use zswap. Compressing a page can take a couple usec, so 100s of usecs
> > > > in limit reclaim is normal. For latency sensitive jobs, this amount of
> > > > hiccups do matters.
> > >
> > > Understood. But isn't this an implementation detail of zswap? Can it
> > > offload some of the heavy lifting to a different context and reduce the
> > > general overhead?
> > >
> >
> > Are you saying doing the compression asynchronously? Similar to how
> > the disk-based swap triggers the writeback and puts the page back to
> > LRU, so the next time reclaim sees it, it will be instantly reclaimed?
> > Or send the batch of pages to be compressed to a different CPU and
> > wait for the completion?
>
> Yes.
>

Adding Minchan, if he has more experience/opinion on async swap on zram/zswap.

> [...]
>
> > > You are right that misconfigured limits can result in problems. But such
> > > a configuration should be quite easy to spot which is not the case for
> > > targetted reclaim calls which do not leave any footprints behind.
> > > Existing interfaces are trying to not expose internal implementation
> > > details as much as well. You are proposing a very targeted interface to
> > > fine control the memory reclaim. There is a risk that userspace will
> > > start depending on a specific reclaim implementation/behavior and future
> > > changes would be prone to regressions in workloads relying on that. So
> > > effectively, any user space memory reclaimer would need to be tuned to a
> > > specific implementation of the memory reclaim.
> >
> > I don't see the exposure of internal memory reclaim implementation.
> > The interface is very simple. Reclaim a given amount of memory. Either
> > the kernel will reclaim less memory or it will over reclaim. In case
> > of reclaiming less memory, the user space can retry given there is
> > enough reclaimable memory. For the over reclaim case, the user space
> > will backoff for a longer time. How are the internal reclaim
> > implementation details exposed?
>
> In an ideal world yes. A feedback mechanism will be independent on the
> particular implementation. But the reality tends to disagree quite
> often. Once we provide a tool there will be users using it to the best
> of their knowlege. Very often as a hammer. This is what the history of
> kernel regressions and "we have to revert an obvious fix because
> userspace depends on an undocumented behavior which happened to work for
> some time" has thought us in a hard way.
>
> I really do not want to deal with reports where a new heuristic in the
> memory reclaim will break something just because the reclaim takes
> slightly longer or over/under reclaims differently so the existing
> assumptions break and the overall balancing from userspace breaks.
>
> This might be a shiny exception of course. And please note that I am not
> saying that the interface is completely wrong or unacceptable. I just
> want to be absolutely sure we cannot move forward with the existing API
> space that we have.
>
> So far I have learned that you are primarily working around an
> implementation detail in the zswap which is doing the swapout path
> directly in the pageout path.

Wait how did you reach this conclusion? I have explicitly said that we
are not using uswapd like functionality in production. We are using
this interface for proactive reclaim and proactive reclaim is not a
workaround for implementation detail in the zswap.

> That sounds like a very bad reason to add
> a new interface. You are right that there are likely other usecases to
> like this new interface - mostly to emulate drop_caches - but I believe
> those are quite misguided as well and we should work harder to help
> them out to use the existing APIs.

I am not really understanding your concern specific for the new API.
All of your concerns (user expectation of reclaim time or over/under
reclaim) are still possible with the existing API i.e. memory.high.

> Last but not least the memcg
> background reclaim is something that should be possible without a new
> interface.

So, it comes down to adding more functionality/semantics to
memory.high or introducing a new simple interface. I am fine with
either of one but IMO convoluted memory.high might have a higher
maintenance cost.

I can send the patch to add the functionality in the memory.high but I
would like to get Johannes's opinion first.

Shakeel
