From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Mon, 4 May 2020 17:00:52 +0200
Message-ID: <20200504150052.GT22838@dhcp22.suse.cz>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz>
 <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 04-05-20 07:53:01, Shakeel Butt wrote:
> On Mon, May 4, 2020 at 7:11 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 04-05-20 06:54:40, Shakeel Butt wrote:
> > > On Sun, May 3, 2020 at 11:56 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Thu 30-04-20 11:27:12, Shakeel Butt wrote:
> > > > > Lowering memory.max can trigger an oom-kill if the reclaim does not
> > > > > succeed. However if oom-killer does not find a process for killing, it
> > > > > dumps a lot of warnings.
> > > >
> > > > It shouldn't dump much more than the regular OOM report AFAICS. Sure
> > > > there is "Out of memory and no killable processes..." message printed as
> > > > well but is that a real problem?
> > > >
> > > > > Deleting a memcg does not reclaim memory from it and the memory can
> > > > > linger till there is a memory pressure. One normal way to proactively
> > > > > reclaim such memory is to set memory.max to 0 just before deleting the
> > > > > memcg. However if some of the memcg's memory is pinned by others, this
> > > > > operation can trigger an oom-kill without any process and thus can log a
> > > > > lot un-needed warnings. So, ignore all such warnings from memory.max.
> > > >
> > > > OK, I can see why you might want to use memory.max for that purpose but
> > > > I do not really understand why the oom report is a problem here.
> > >
> > > It may not be a problem for an individual or small scale deployment
> > > but when "sweep before tear down" is the part of the workflow for
> > > thousands of machines cycling through hundreds of thousands of cgroups
> > > then we can potentially flood the logs with not useful dumps and may
> > > hide (or overflow) any useful information in the logs.
> >
> > If you are doing this in a large scale and the oom report is really a
> > problem then you shouldn't be resetting hard limit to 0 in the first
> > place.
> >
> 
> I think I have pretty clearly described why we want to reset the hard
> limit to 0, so, unless there is an alternative I don't see why we
> should not be doing this.

I am not saying you shouldn't be doing that. I am just saying that if
you do then you have to live with oom reports.

> > > > memory.max can trigger the oom kill and user should be expecting the oom
> > > > report under that condition. Why is "no eligible task" so special? Is it
> > > > because you know that there won't be any tasks for your particular case?
> > > > What about other use cases where memory.max is not used as a "sweep
> > > > before tear down"?
> > >
> > > What other such use-cases would be? The only use-case I can envision
> > > of adjusting limits dynamically of a live cgroup are resource
> > > managers. However for cgroup v2, memory.high is the recommended way to
> > > limit the usage, so, why would resource managers be changing
> > > memory.max instead of memory.high? I am not sure. What do you think?
> >
> > There are different reasons to use the hard limit. Mostly to contain
> > potential runaways. While high limit might be a sufficient measure to
> > achieve that as well the hard limit is the last resort. And it clearly
> > has the oom killer semantic so I am not really sure why you are
> > comparing the two.
> >
> 
> I am trying to see if "no eligible task" is really an issue and should
> be warned for the "other use cases". The only real use-case I can
> think of are resource managers adjusting the limit dynamically. I
> don't see "no eligible task" a concerning reason for such use-case.

It is very much a concerning reason to notify about like any other OOM
situation due to hard limit breach. In this case it is worse in some
sense because the limit cannot be trimmed down because there is no
directly reclaimable memory at all. Such an oom situation is
effectivelly conserved.
-- 
Michal Hocko
SUSE Labs
