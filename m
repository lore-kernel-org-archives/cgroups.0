From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: periodically flush the memcg stats
Date: Thu, 24 Jun 2021 13:46:27 -0400
Message-ID: <YNTE88wHs4Ac/DKp@cmpxchg.org>
References: <20210615174435.4174364-1-shakeelb@google.com>
 <20210615174435.4174364-2-shakeelb@google.com>
 <YMj/s26uF+cQOB2D@cmpxchg.org>
 <CALvZod6Hpema0uMcnMGPS+_2iZuxc8JqkjHRVBeEGp-vdcpPYA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=znmbspe43gdGgRV/upQrZxOnaNJ/GmfYqjXiwM9oleo=;
        b=ELA+YbvkUh75ll+mDif4Kq+XgYyX0/XvX6qHn5DIZ3JSdG7TIpCzYTJ7CNH0KRs3JQ
         Qgkx5zASyU7ccV7yFcYLKO98UIOlSU5t+3oC08J51aQ6VDKmSsmosrLP5mK5XKZH4DOB
         rc3sA+6PfyO7SBkqCTHaxwRQ27zE+saKJVPSYZHYjWq2lEfUYOLFqXc2sZ2Ik+iPfLd1
         +PNPOaXQeDUQOdkgYW1f99+LpTjBPMyir979HxcahAH9czGxYic2o+kRWVQPLdp7iHiA
         dkMXuOkUP8YzBUGP5HW3nSC2tU3ODM4u6gwHL+4RLZB1cqymZxwwHxcn0u5rX2uf3IqK
         neKg==
Content-Disposition: inline
In-Reply-To: <CALvZod6Hpema0uMcnMGPS+_2iZuxc8JqkjHRVBeEGp-vdcpPYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey Shakeel,

Sorry about the delay.

On Tue, Jun 15, 2021 at 02:52:37PM -0700, Shakeel Butt wrote:
> On Tue, Jun 15, 2021 at 12:29 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > The way the global vmstat implementation manages error is doing both:
> > ratelimiting and timelimiting. It uses percpu batching to limit the
> > error when it gets busy, and periodic flushing to limit the length of
> > time consumers of those stats could be stuck trying to reach a state
> > that the batching would otherwise prevent from being reflected.
> >
> > Maybe we can use a combination of ratelimiting and timelimiting too?
> >
> > We shouldn't flush on every fault, but what about a percpu ratelimit
> > that would at least bound the error to NR_CPU instead of nr_cgroups?
> >
> 
> Couple questions here:
> 
> First, to convert the error bound to NR_CPU from nr_cgroups, I think
> we have to move from (delta > threshold) comparison to
> (num_update_events > threshold). Previously an increment event
> followed by decrement would keep the delta to 0 (or same) but after
> this change num_update_events would be 2. Is that ok?

Yeah, I think that's fine. Or at least I can't think of a real-world
application that would inc and dec the same counter over and over and
so would do much better with delta spilling over event ratelimiting.

And the ratelimiting should already ensure by itself that the cost is
at least acceptable when continuously updating and reading counters.

> Second, do we want to synchronously flush the stats when we cross the
> threshold on update or asynchronously by queuing the flush with zero
> delay?

I think flushing by worker is better because we can see updates from
all sorts of contexts with all sorts of locks held. That could make
for some difficult dependencies and latency sources when serializing
those on cgroup_rstat_lock.
