From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Wed, 29 Apr 2020 18:21:20 +0200
Message-ID: <20200429162120.GB12716@quack2.suse.cz>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
 <20200429102540.GA12716@quack2.suse.cz>
 <20200429142230.GE5462@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200429142230.GE5462-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1562vlLw7lfJaRg@public.gmane.org>

On Wed 29-04-20 10:22:30, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 29, 2020 at 12:25:40PM +0200, Jan Kara wrote:
> > Yeah, I was thinking about the same when reading the patch series
> > description. We already have some cgroup workarounds for btrfs kthreads if
> > I remember correctly, we have cgroup handling for flush workers, now we are
> > adding cgroup handling for loopback device workers, and soon I'd expect
> > someone comes with a need for DM/MD worker processes and IMHO it's getting
> > out of hands because the complexity spreads through the kernel with every
> > subsystem comming with slightly different solution to the problem and also
> > the number of kthreads gets multiplied by the number of cgroups. So I
> > agree some generic solution how to approach IO throttling of kthreads /
> > workers would be desirable.
> > 
> > OTOH I don't have a great idea how the generic infrastructure should look
> > like...
> 
> I don't really see a way around that. The only generic solution would be
> letting all IOs through as root and handle everything through backcharging,
> which we already can do as backcharging is already in use to handle metadata
> updates which can't be controlled directly. However, doing that for all IOs
> would make the control quality a lot worse as all control would be based on
> first incurring deficit and then try to punish the issuer after the fact.

Yeah, it will be probably somewhat worse but OTOH given we'd track the IO
balance per cgroup there will deficit only when a cgroup is starting so it
could be bearable. I'm more concerned about issues like that for some IO
controllers (e.g. for blk-iolatency or for the work preserving
controllers), it is not obvious how to sensibly estimate some cost to
charge to a cgroup since these controllers are more about giving priority
to IO of some cgroup in presence of IO from another cgroup rather than some
hard throughput limit or something like that.

> The infrastructure work done to make IO control work for btrfs is generic
> and the changes needed on btrfs side was pretty small. Most of the work was
> identifying non-regular IO pathways (bouncing through different kthreads and
> whatnot) and making sure they're annotating IO ownership and the needed
> mechanism correctly. The biggest challenge probably is ensuring that the
> filesystem doesn't add ordering dependency between separate data IOs, which
> is a nice property to have with or without cgroup support.
> 
> That leaves the nesting drivers, loop and md/dm. Given that they sit in the
> middle of IO stack and proxy a lot of its roles, they'll have to be updated
> to be transparent in terms of cgroup ownership if IO control is gonna work
> through them. Maybe we can have a common infra shared between loop, dm and
> md but they aren't many and may also be sufficiently different. idk

Yeah, as I said, I don't really have a better alternative :-|

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
