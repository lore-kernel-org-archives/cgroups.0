From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 10:03:08 +0200
Message-ID: <20200504080308.GI22838@dhcp22.suse.cz>
References: <20200430182712.237526-1-shakeelb@google.com>
 <CALOAHbC4WY00yQ46b8CFqVQ3S=JSJxE2HR00TtMqXOWLRPRZ8w@mail.gmail.com>
 <20200504070301.GC22838@dhcp22.suse.cz>
 <CALOAHbCJBaa26m2cUkE0evwDnSFvUPrdBg9=WMjC7Yt_33-BJQ@mail.gmail.com>
 <20200504073549.GE22838@dhcp22.suse.cz>
 <CALOAHbDd8hjURSi9jAdjQTbSLDvu9vkOkjS1hZNn04G8Yj7WdQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbDd8hjURSi9jAdjQTbSLDvu9vkOkjS1hZNn04G8Yj7WdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 04-05-20 15:40:18, Yafang Shao wrote:
> On Mon, May 4, 2020 at 3:35 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon 04-05-20 15:26:52, Yafang Shao wrote:
[...]
> > > As explianed above, no eligible task is different from no task.
> > > If there are some candidates but no one is eligible, the system will panic.
> > > While if there's no task, it is definitely no OOM, because that's an
> > > improssible thing for the system.
> >
> > This is very much possible situation when all eligible tasks have been
> > already killed but they didn't really help to resolve the oom situation
> > - e.g. in kernel memory leak or unbounded shmem consumption etc...
> >
> 
> That's still an impossible thing, because many tasks are invisible to
> the oom killer.
> See oom_unkillable_task().

I do not follow, really. oom_unkillable_task only says that global init
cannot be killed and that it doesn't make any sense to kill kernel
threads as they do not own any mm normally.

-- 
Michal Hocko
SUSE Labs
