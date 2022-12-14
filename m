From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Wed, 14 Dec 2022 11:23:32 +0100
Message-ID: <Y5mkJL6I5Zlc1k97@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y5h+gHBneexFQcR3@cmpxchg.org>
 <Y5iGJ/9PMmSCwqLj@dhcp22.suse.cz>
 <CAHS8izOuT_-p-N1xPApi+BPJQ+P--2YVSUeiWBROGvGinN0vcg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671013413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fxBVCTztKvCx7NZz2W8gthEPH9JUIWAZ4+V+PfsVmzY=;
        b=IojBzwyziVtYiucjSQDvGHnCXVjXg2p/sHVYk80E3xfs7e5jBbeS9JU65R1LNQ8A+RlA3V
        nVZqvAW9UjKHw/QmPgCvEjbeBUhDxCLc2YH+bnaeQwiWi1j0MPSlkXpy3rHQMIUkQMDreQ
        Z/LmeErn8iJyWo5NQRig0Hzxee4+ACc=
Content-Disposition: inline
In-Reply-To: <CAHS8izOuT_-p-N1xPApi+BPJQ+P--2YVSUeiWBROGvGinN0vcg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, "Huang, Ying" <ying.huang@intel.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue 13-12-22 11:29:45, Mina Almasry wrote:
> On Tue, Dec 13, 2022 at 6:03 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Tue 13-12-22 14:30:40, Johannes Weiner wrote:
> > > On Tue, Dec 13, 2022 at 02:30:57PM +0800, Huang, Ying wrote:
> > [...]
> > > > After these discussion, I think the solution maybe use different
> > > > interfaces for "proactive demote" and "proactive reclaim".  That is,
> > > > reconsider "memory.demote".  In this way, we will always uncharge the
> > > > cgroup for "memory.reclaim".  This avoid the possible confusion there.
> > > > And, because demotion is considered aging, we don't need to disable
> > > > demotion for "memory.reclaim", just don't count it.
> > >
> > > Hm, so in summary:
> > >
> > > 1) memory.reclaim would demote and reclaim like today, but it would
> > >    change to only count reclaimed pages against the goal.
> > >
> > > 2) memory.demote would only demote.
> > >
> 
> If the above 2 points are agreeable then yes, this sounds good to me
> and does address our use case.
> 
> > >    a) What if the demotion targets are full? Would it reclaim or fail?
> > >
> 
> Wei will chime in if he disagrees, but I think we _require_ that it
> fails, not falls back to reclaim. The interface is asking for
> demotion, and is called memory.demote. For such an interface to fall
> back to reclaim would be very confusing to userspace and may trigger
> reclaim on a high priority job that we want to shield from proactive
> reclaim.

But what should happen if the immediate demotion target is full but
lower tiers are still usable. Should the first one demote before
allowing to demote from the top tier?
 
> > > 3) Would memory.reclaim and memory.demote still need nodemasks?
> 
> memory.demote will need a nodemask, for sure. Today the nodemask would
> be useful if there is a specific node in the top tier that is
> overloaded and we want to reduce the pressure by demoting. In the
> future there will be N tiers and the nodemask says which tier to
> demote from.

OK, so what is the exact semantic of the node mask. Does it control
where to demote from or to or both?

> I don't think memory.reclaim would need a nodemask anymore? At least I
> no longer see the use for it for us.
> 
> > >    Would
> > >    they return -EINVAL if a) memory.reclaim gets passed only toptier
> > >    nodes or b) memory.demote gets passed any lasttier nodes?
> >
> 
> Honestly it would be great if memory.reclaim can force reclaim from a
> top tier nodes. It breaks the aginig pipeline, yes, but if the user is
> specifically asking for that because they decided in their usecase
> it's a good idea then the kernel should comply IMO. Not a strict
> requirement for us. Wei will chime in if he disagrees.

That would require a nodemask to say which nodes to reclaim, no? The
default behavior should be in line with what standard memory reclaim
does. If the demotion is a part of that process so should be
memory.reclaim part of it. If we want to have a finer control then a
nodemask is really a must and then the nodemaks should constrain both
agining and reclaim.

> memory.demote returning -EINVAL for lasttier nodes makes sense to me.
> 
> > I would also add
> > 4) Do we want to allow to control the demotion path (e.g. which node to
> >    demote from and to) and how to achieve that?
> 
> We care deeply about specifying which node to demote _from_. That
> would be some node that is approaching pressure and we're looking for
> proactive saving from. So far I haven't seen any reason to control
> which nodes to demote _to_. The kernel deciding that based on the
> aging pipeline and the node distances sounds good to me. Obviously
> someone else may find that useful.

Please keep in mind that the interface should be really prepared for
future extensions so try to abstract from your immediate usecases.

> > 5) Is the demotion api restricted to multi-tier systems or any numa
> >    configuration allowed as well?
> >
> 
> demotion will of course not work on single tiered systems. The
> interface may return some failure on such systems or not be available
> at all.

Is there any strong reason for that? We do not have any interface to
control NUMA balancing from userspace. Why cannot we use the interface
for that purpose? 
-- 
Michal Hocko
SUSE Labs
