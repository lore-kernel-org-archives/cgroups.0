From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 09:35:49 +0200
Message-ID: <20200504073549.GE22838@dhcp22.suse.cz>
References: <20200430182712.237526-1-shakeelb@google.com>
 <CALOAHbC4WY00yQ46b8CFqVQ3S=JSJxE2HR00TtMqXOWLRPRZ8w@mail.gmail.com>
 <20200504070301.GC22838@dhcp22.suse.cz>
 <CALOAHbCJBaa26m2cUkE0evwDnSFvUPrdBg9=WMjC7Yt_33-BJQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbCJBaa26m2cUkE0evwDnSFvUPrdBg9=WMjC7Yt_33-BJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 04-05-20 15:26:52, Yafang Shao wrote:
> On Mon, May 4, 2020 at 3:03 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 01-05-20 09:39:24, Yafang Shao wrote:
> > > On Fri, May 1, 2020 at 2:27 AM Shakeel Butt <shakeelb@google.com> wrote:
> > > >
> > > > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > > > succeed. However if oom-killer does not find a process for killing, it
> > > > dumps a lot of warnings.
> > > >
> > >
> > > I have been confused by this behavior for several months and I think
> > > it will confuse more memcg users.
> >
> > Could you be more specific what has caused the confusion?
> >
> 
> No task is different from no eligible task.
> No eligible task means there are some candidates but no one is eligible.
> Whille no task means there is no candidate.

I really fail to see a difference. It is clear the one is subset of the
other but in practical life tasks might come and go at any time and if
you try to reduce the hard limit and there are no tasks that could be
reclaimed then I believe we should complain whether it is only oom
disabled tasks or no tasks at all. It is certainly unexpected situation
in some cases because there are resources which are bound to the memcg
without any task we can act on.

> > > We should keep the memcg oom behavior consistent with system oom - no
> > > oom kill if no process.
> >
> > This is not the global mmemcg behavior. We do complain loud on no
> > eligible tasks and actually panic the system. Memcg cannot simply
> > do the same by default for obvious reasons.
> >
> 
> As explianed above, no eligible task is different from no task.
> If there are some candidates but no one is eligible, the system will panic.
> While if there's no task, it is definitely no OOM, because that's an
> improssible thing for the system.

This is very much possible situation when all eligible tasks have been
already killed but they didn't really help to resolve the oom situation
- e.g. in kernel memory leak or unbounded shmem consumption etc...

-- 
Michal Hocko
SUSE Labs
