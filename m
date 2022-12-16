From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Fri, 16 Dec 2022 09:40:34 +0100
Message-ID: <Y5wvAnroJHaWQbCV@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <CAHS8izM-XdLgFrQ1k13X-4YrK=JGayRXV_G3c3Qh4NLKP7cH_g@mail.gmail.com>
 <87k02volwe.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y5h+gHBneexFQcR3@cmpxchg.org>
 <Y5iGJ/9PMmSCwqLj@dhcp22.suse.cz>
 <CAHS8izOuT_-p-N1xPApi+BPJQ+P--2YVSUeiWBROGvGinN0vcg@mail.gmail.com>
 <Y5mkJL6I5Zlc1k97@dhcp22.suse.cz>
 <CAAPL-u_KFTScyd1hxDGb-nHf6hW5_pCsh5a0NDZCr5v5AGq88A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671180034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3nvimj2ZFEx9YlSQKEbscjAQshU+naWh0RT6szJpxbY=;
        b=Bw8en1xmr0xlc033t59Fmd9xvJ/ey7A/H7JtocX065COY8g9zeA9OnNx20n2Ecsfjj43n/
        FWc+JP9gV724C3PypNeuOfBOmHNZKslYtZkGj1Kg9xqrZxwikmlBC/Kr73SRMVPlE6A53h
        68JY5QsKr1zGoq1BIgq+jwbjwvzffq0=
Content-Disposition: inline
In-Reply-To: <CAAPL-u_KFTScyd1hxDGb-nHf6hW5_pCsh5a0NDZCr5v5AGq88A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Mina Almasry <almasrymina@google.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huang, Ying" <ying.huang@intel.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu 15-12-22 09:58:12, Wei Xu wrote:
> On Wed, Dec 14, 2022 at 2:23 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Tue 13-12-22 11:29:45, Mina Almasry wrote:
> > > On Tue, Dec 13, 2022 at 6:03 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Tue 13-12-22 14:30:40, Johannes Weiner wrote:
> > > > > On Tue, Dec 13, 2022 at 02:30:57PM +0800, Huang, Ying wrote:
> > > > [...]
> > > > > > After these discussion, I think the solution maybe use different
> > > > > > interfaces for "proactive demote" and "proactive reclaim".  That is,
> > > > > > reconsider "memory.demote".  In this way, we will always uncharge the
> > > > > > cgroup for "memory.reclaim".  This avoid the possible confusion there.
> > > > > > And, because demotion is considered aging, we don't need to disable
> > > > > > demotion for "memory.reclaim", just don't count it.
> > > > >
> > > > > Hm, so in summary:
> > > > >
> > > > > 1) memory.reclaim would demote and reclaim like today, but it would
> > > > >    change to only count reclaimed pages against the goal.
> > > > >
> > > > > 2) memory.demote would only demote.
> > > > >
> > >
> > > If the above 2 points are agreeable then yes, this sounds good to me
> > > and does address our use case.
> > >
> > > > >    a) What if the demotion targets are full? Would it reclaim or fail?
> > > > >
> > >
> > > Wei will chime in if he disagrees, but I think we _require_ that it
> > > fails, not falls back to reclaim. The interface is asking for
> > > demotion, and is called memory.demote. For such an interface to fall
> > > back to reclaim would be very confusing to userspace and may trigger
> > > reclaim on a high priority job that we want to shield from proactive
> > > reclaim.
> >
> > But what should happen if the immediate demotion target is full but
> > lower tiers are still usable. Should the first one demote before
> > allowing to demote from the top tier?
> 
> In that case, the demotion will fall back to the lower tiers.  See
> node_get_allowed_targets() and establish_demotion_targets()..

I am not talking about an implicit behavior that we do not want to cast
into interface. If we want to allow a fine grained control over demotion
then the implementation shouldn't rely on the current behavior.

[...]
> > Is there any strong reason for that? We do not have any interface to
> > control NUMA balancing from userspace. Why cannot we use the interface
> > for that purpose?
> 
> A demotion interface such as memory.demote will trigger the demotion
> code path in the kernel, which depends on multiple memory tiers.

Demotion is just a fancy name of a directed migration. There is no realy
dependency on the HW nor the technology.

> I think what you are getting is a more general page migration
> interface for memcg, which will need both source and target nodes as
> arguments. I think this can be a great idea.  It should be able to
> support our demotion use cases as well.

yes.

-- 
Michal Hocko
SUSE Labs
