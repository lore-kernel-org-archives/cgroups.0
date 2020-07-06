From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Mon, 6 Jul 2020 14:38:33 -0700
Message-ID: <20200706213404.GA152560@carbon.lan>
References: <20200702152222.2630760-1-shakeelb@google.com>
 <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
 <20200703155021.GB114903@carbon.dhcp.thefacebook.com>
 <CALvZod5Z4=1CijJp0QRnx+pdH=Me6sYPXASCxVATnshU0RW-Qw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lwkY6r4OZaHJitgZp0xrDtujuSGt0l8XV3LwLLwc4HM=;
 b=mhpD1Dbj3kno709ho6TEPhCGrkAw+cWjIjUwPLCeeg3KQ2KMlrh6YrzAvBPXQVmX8I5J
 //dM++JrUH15mZnFrPP6lCqx7xUG5B1zS37xcLtHWQykuy4rakUy825sLXeGu4FzUVQf
 m2qn/0wXU3AyH0g216yOPaokaXXTMV8btVk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwkY6r4OZaHJitgZp0xrDtujuSGt0l8XV3LwLLwc4HM=;
 b=NljN1bmL/MqBvRrNQ9bUoHCu59KXqdO84jje1Ds6YsANgPHMffB7EglrQz1jTopxnRIO+uqCWvLf9rHkBH9jZQbikWcUyj2hi3PP6WcYjSGnMjr4rhXHKmajC0IqybzNOtJrLxMHYmXRIO7SluL7s8/eK9WuMx40pWE3ITtl/xQ=
Content-Disposition: inline
In-Reply-To: <CALvZod5Z4=1CijJp0QRnx+pdH=Me6sYPXASCxVATnshU0RW-Qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <yang.shi@linux.alibaba.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Jul 03, 2020 at 09:27:19AM -0700, Shakeel Butt wrote:
> On Fri, Jul 3, 2020 at 8:50 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Fri, Jul 03, 2020 at 07:23:14AM -0700, Shakeel Butt wrote:
> > > On Thu, Jul 2, 2020 at 11:35 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > >
> > > > On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
> > > > [...]
> > > > > Interface options:
> > > > > ------------------
> > > > >
> > > > > 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> > > > >
> > > > > + simple
> > > > > + can be extended to target specific type of memory (anon, file, kmem).
> > > > > - most probably restricted to cgroup v2.
> > > > >
> > > > > 2) fadvise(PAGEOUT) on cgroup_dir_fd
> > > > >
> > > > > + more general and applicable to other FSes (actually we are using
> > > > > something similar for tmpfs).
> > > > > + can be extended in future to just age the LRUs instead of reclaim or
> > > > > some new use cases.
> > > >
> > > > Could you explain why memory.high as an interface to trigger pro-active
> > > > memory reclaim is not sufficient. Also memory.low limit to protect
> > > > latency sensitve workloads?
> >
> > I initially liked the proposal, but after some thoughts I've realized
> > that I don't know a good use case where memory.high is less useful.
> > Shakeel, what's the typical use case you thinking of?
> > Who and how will use the new interface?
> >
> > >
> > > Yes, we can use memory.high to trigger [proactive] reclaim in a memcg
> > > but note that it can also introduce stalls in the application running
> > > in that memcg. Let's suppose the memory.current of a memcg is 100MiB
> > > and we want to reclaim 20MiB from it, we can set the memory.high to
> > > 80MiB but any allocation attempt from the application running in that
> > > memcg can get stalled/throttled. I want the functionality of the
> > > reclaim without potential stalls.
> >
> > But reclaiming some pagecache/swapping out anon pages can always
> > generate some stalls caused by pagefaults, no?
> >
> 
> Thanks for looking into the proposal. Let me answer both of your
> questions together. I have added the two use-cases but let me explain
> the proactive reclaim a bit more as we actually use that in our
> production.
> 
> We have defined tolerable refault rates for the applications based on
> their type (latency sensitive or not). Proactive reclaim is triggered
> in the application based on their current refault rates and usage. If
> the current refault rate exceeds the tolerable refault rate then
> stop/slowdown the proactive reclaim.
> 
> For the second question, yes, each individual refault can induce the
> stall as well but we have more control on that stall as compared to
> stalls due to reclaim. For us almost all the reclaimable memory is
> anon and we use compression based swap, so, the cost of each refault
> is fixed and a couple of microseconds.
> 
> I think the next question is what about the refaults from disk or
> source with highly variable cost. Usually the latency sensitive
> applications remove such uncertainty by mlocking the pages backed by
> such backends (e.g. mlocking the executable) or at least that is the
> case for us.

Got it.

It feels like you're suggesting something similar to memory.high with
something similar to a different gfp flags. In other words, the
difference is only which pages can be reclaimed and which not. I don't
have a definitive answer here, but I wonder if we can somehow
generalize the existing interface? E.g. if the problem is with artificially
induced delays, we can have a config option/sysctl/sysfs knob/something else
which would disable it. Otherwise we risk ending up with many different kinds
of soft memory limits.

Thanks!
