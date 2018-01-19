From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] mm/memcontrol.c: Reduce reclaim retries in
 mem_cgroup_resize_limit()
Date: Fri, 19 Jan 2018 16:11:18 +0100
Message-ID: <20180119151118.GE6584@dhcp22.suse.cz>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-2-aryabinin@virtuozzo.com>
 <20180119133510.GD6584@dhcp22.suse.cz>
 <CALvZod7HS6P0OU6Rps8JeMJycaPd4dF5NjxV8k1y2-yosF2bdA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7HS6P0OU6Rps8JeMJycaPd4dF5NjxV8k1y2-yosF2bdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 19-01-18 06:49:29, Shakeel Butt wrote:
> On Fri, Jan 19, 2018 at 5:35 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Fri 19-01-18 16:25:44, Andrey Ryabinin wrote:
> >> Currently mem_cgroup_resize_limit() retries to set limit after reclaiming
> >> 32 pages. It makes more sense to reclaim needed amount of pages right away.
> >>
> >> This works noticeably faster, especially if 'usage - limit' big.
> >> E.g. bringing down limit from 4G to 50M:
> >>
> >> Before:
> >>  # perf stat echo 50M > memory.limit_in_bytes
> >>
> >>      Performance counter stats for 'echo 50M':
> >>
> >>             386.582382      task-clock (msec)         #    0.835 CPUs utilized
> >>                  2,502      context-switches          #    0.006 M/sec
> >>
> >>            0.463244382 seconds time elapsed
> >>
> >> After:
> >>  # perf stat echo 50M > memory.limit_in_bytes
> >>
> >>      Performance counter stats for 'echo 50M':
> >>
> >>             169.403906      task-clock (msec)         #    0.849 CPUs utilized
> >>                     14      context-switches          #    0.083 K/sec
> >>
> >>            0.199536900 seconds time elapsed
> >
> > But I am not going ack this one. As already stated this has a risk
> > of over-reclaim if there a lot of charges are freed along with this
> > shrinking. This is more of a theoretical concern so I am _not_ going to
> 
> If you don't mind, can you explain why over-reclaim is a concern at
> all? The only side effect of over reclaim I can think of is the job
> might suffer a bit over (more swapins & pageins). Shouldn't this be
> within the expectation of the user decreasing the limits?

It is not a disaster. But it is an unexpected side effect of the
implementation. If you have limit 1GB and want to reduce it 500MB
then it would be quite surprising to land at 200M just because somebody
was freeing 300MB in parallel. Is this likely? Probably not but the more
is the limit touched and the larger are the differences the more likely
it is. Keep retrying in the smaller amounts and you will not see the
above happening.

And to be honest, I do not really see why keeping retrying from
mem_cgroup_resize_limit should be so much faster than keep retrying from
the direct reclaim path. We are doing SWAP_CLUSTER_MAX batches anyway.
mem_cgroup_resize_limit loop adds _some_ overhead but I am not really
sure why it should be that large.
-- 
Michal Hocko
SUSE Labs
