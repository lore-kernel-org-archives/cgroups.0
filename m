From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 20:20:46 +0100
Message-ID: <Y9LSjnNEEUiF/70R@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9LAf4pRyClZ1vfx@tpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674760847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZdMVCCJMvU9M4O/mfRN6zr0JYO93D/H3jiZOXlAsN8=;
        b=DIGdmxISieQdRrwLNw3LlmeoAc//xicN6OWmYLUZSAy1U8+3WkjnxB83NPHNFst2UfNqhQ
        5EYS9kT+98gjXX87triED/Wqc+H8qGXxSN1jr90JCBibCPVTVGzR4e8BH6ebDd1Jr+XS3x
        Y1bxrYJh5ZL81p0/pPGxcAnxW/peDNw=
Content-Disposition: inline
In-Reply-To: <Y9LAf4pRyClZ1vfx@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu 26-01-23 15:03:43, Marcelo Tosatti wrote:
> On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> > On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > > Disclaimer:
> > > > > > > a - The cover letter got bigger than expected, so I had to sp=
lit it in
> > > > > > >     sections to better organize myself. I am not very confort=
able with it.
> > > > > > > b - Performance numbers below did not include patch 5/5 (Remo=
ve flags
> > > > > > >     from memcg_stock_pcp), which could further improve perfor=
mance for
> > > > > > >     drain_all_stock(), but I could only notice the optimizati=
on at the
> > > > > > >     last minute.
> > > > > > >=20
> > > > > > >=20
> > > > > > > 0 - Motivation:
> > > > > > > On current codebase, when drain_all_stock() is ran, it will s=
chedule a
> > > > > > > drain_local_stock() for each cpu that has a percpu stock asso=
ciated with a
> > > > > > > descendant of a given root_memcg.
> > >=20
> > > Do you know what caused those drain_all_stock() calls? I wonder if we=
 should look
> > > into why we have many of them and whether we really need them?
> > >=20
> > > It's either some user's actions (e.g. reducing memory.max), either so=
me memcg
> > > is entering pre-oom conditions. In the latter case a lot of drain cal=
ls can be
> > > scheduled without a good reason (assuming the cgroup contain multiple=
 tasks running
> > > on multiple cpus).
> >=20
> > I believe I've never got a specific answer to that. We
> > have discussed that in the previous version submission
> > (20221102020243.522358-1-leobras@redhat.com and specifically
> > Y2TQLavnLVd4qHMT@dhcp22.suse.cz). Leonardo has mentioned a mix of RT and
> > isolcpus. I was wondering about using memcgs in RT workloads because
> > that just sounds weird but let's say this is the case indeed.=20
>=20
> This could be the case. You can consider an "edge device" where it is
> necessary to run a RT workload. It might also be useful to run=20
> non realtime applications on the same system.
>=20
> > Then an RT task or whatever task that is running on an isolated
> > cpu can have pcp charges.
>=20
> Usually the RT task (or more specifically the realtime sensitive loop
> of the application) runs entirely on userspace. But i suppose there
> could be charges on application startup.

What is the role of memcg then? If the memory limit is in place and the
workload doesn't fit in then it will get reclaimed during start up and
memory would need to be refaulted if not mlocked. If it is mlocked then
the limit cannot be enforced and the start up would likely fail as a
result of the memcg oom killer.

[...]
> > > Overall I'm somewhat resistant to an idea of making generic allocatio=
n & free paths slower
> > > for an improvement of stock draining. It's not a strong objection, bu=
t IMO we should avoid
> > > doing this without a really strong reason.
> >=20
> > Are you OK with a simple opt out on isolated CPUs? That would make
> > charges slightly slower (atomic on the hierarchy counters vs. a single
> > pcp adjustment) but it would guarantee that the isolated workload is
> > predictable which is the primary objective AFAICS.
>=20
> This would make isolated CPUs "second class citizens": it would be nice
> to be able to execute non realtime apps on isolated CPUs as well
> (think of different periods of time during a day, one where=20
> more realtime apps are required, another where less=20
> realtime apps are required).

An alternative requires to make the current implementation that is
lockless to use locks and introduce potential lock contention. This
could be harmful to regular workloads. Not using pcp caching would make
a fast path using few atomics rather than local pcp update. That is not
a terrible cost to pay for special cased workloads which use isolcpus.
Really we are not talking about a massive cost to be payed. At least
nobody has shown that in any numbers.

> Concrete example: think of a computer handling vRAN traffic near a=20
> cell tower. The traffic (therefore amount of processing required
> by realtime applications) might vary during the day.
>=20
> User might want to run containers that depend on good memcg charging
> performance on isolated CPUs.

What kind of role would memcg play here? Do you want to memory constrain
that workload?
--=20
Michal Hocko
SUSE Labs
