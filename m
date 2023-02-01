From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 1 Feb 2023 10:31:40 -0800
Message-ID: <Y9qwDGXZviWdtonc@P9FQF9L96D.corp.robot.car>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9LAf4pRyClZ1vfx@tpad>
 <Y9LSjnNEEUiF/70R@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675276305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2k9RdWKbuchR7Tzph+cOMm2F328+gYOorWNDRphKPTY=;
        b=lmsm5EJw7Ag76Ab2u0I+odcANv0IJvSUVxiwTozoluqHE0itOLpy3pK5ukk3jFQ+0ZbszO
        cTqWApnPoXqtuihkawaz9n7RekvDrLJlvDoGpCOwa9TN/xc5xpQlU5QClV/g0GZuhsQm6f
        dndefcr6GKweZLSl45WWLTr2WF3u46E=
Content-Disposition: inline
In-Reply-To: <Y9LSjnNEEUiF/70R@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Jan 26, 2023 at 08:20:46PM +0100, Michal Hocko wrote:
> On Thu 26-01-23 15:03:43, Marcelo Tosatti wrote:
> > On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> > > On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > > > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > > > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > > > Disclaimer:
> > > > > > > > a - The cover letter got bigger than expected, so I had to =
split it in
> > > > > > > >     sections to better organize myself. I am not very confo=
rtable with it.
> > > > > > > > b - Performance numbers below did not include patch 5/5 (Re=
move flags
> > > > > > > >     from memcg_stock_pcp), which could further improve perf=
ormance for
> > > > > > > >     drain_all_stock(), but I could only notice the optimiza=
tion at the
> > > > > > > >     last minute.
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > > 0 - Motivation:
> > > > > > > > On current codebase, when drain_all_stock() is ran, it will=
 schedule a
> > > > > > > > drain_local_stock() for each cpu that has a percpu stock as=
sociated with a
> > > > > > > > descendant of a given root_memcg.
> > > >=20
> > > > Do you know what caused those drain_all_stock() calls? I wonder if =
we should look
> > > > into why we have many of them and whether we really need them?
> > > >=20
> > > > It's either some user's actions (e.g. reducing memory.max), either =
some memcg
> > > > is entering pre-oom conditions. In the latter case a lot of drain c=
alls can be
> > > > scheduled without a good reason (assuming the cgroup contain multip=
le tasks running
> > > > on multiple cpus).
> > >=20
> > > I believe I've never got a specific answer to that. We
> > > have discussed that in the previous version submission
> > > (20221102020243.522358-1-leobras@redhat.com and specifically
> > > Y2TQLavnLVd4qHMT@dhcp22.suse.cz). Leonardo has mentioned a mix of RT =
and
> > > isolcpus. I was wondering about using memcgs in RT workloads because
> > > that just sounds weird but let's say this is the case indeed.=20
> >=20
> > This could be the case. You can consider an "edge device" where it is
> > necessary to run a RT workload. It might also be useful to run=20
> > non realtime applications on the same system.
> >=20
> > > Then an RT task or whatever task that is running on an isolated
> > > cpu can have pcp charges.
> >=20
> > Usually the RT task (or more specifically the realtime sensitive loop
> > of the application) runs entirely on userspace. But i suppose there
> > could be charges on application startup.
>=20
> What is the role of memcg then? If the memory limit is in place and the
> workload doesn't fit in then it will get reclaimed during start up and
> memory would need to be refaulted if not mlocked. If it is mlocked then
> the limit cannot be enforced and the start up would likely fail as a
> result of the memcg oom killer.
>=20
> [...]
> > > > Overall I'm somewhat resistant to an idea of making generic allocat=
ion & free paths slower
> > > > for an improvement of stock draining. It's not a strong objection, =
but IMO we should avoid
> > > > doing this without a really strong reason.
> > >=20
> > > Are you OK with a simple opt out on isolated CPUs? That would make
> > > charges slightly slower (atomic on the hierarchy counters vs. a single
> > > pcp adjustment) but it would guarantee that the isolated workload is
> > > predictable which is the primary objective AFAICS.
> >=20
> > This would make isolated CPUs "second class citizens": it would be nice
> > to be able to execute non realtime apps on isolated CPUs as well
> > (think of different periods of time during a day, one where=20
> > more realtime apps are required, another where less=20
> > realtime apps are required).
>=20
> An alternative requires to make the current implementation that is
> lockless to use locks and introduce potential lock contention. This
> could be harmful to regular workloads. Not using pcp caching would make
> a fast path using few atomics rather than local pcp update. That is not
> a terrible cost to pay for special cased workloads which use isolcpus.
> Really we are not talking about a massive cost to be payed. At least
> nobody has shown that in any numbers.

Can't agree more.
I also agree that the whole pcpu stock draining code can be enhanced,
but I believe we should go into the direction almost directly opposite
to what's being proposed here.

Can we please return to the original problem which the patchset aims to sol=
ve?
Is it the latency introduced by execution of draining works on isolated cpu=
s?
Maybe schedule these works with a delay and cancel them if the draining
occurred naturally during the delay?

Thanks!
