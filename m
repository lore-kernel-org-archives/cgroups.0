From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 15:03:43 -0300
Message-ID: <Y9LAf4pRyClZ1vfx@tpad>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674758237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8a5V2BYq9UP1RYMhw23cgt6o5VR9Kg9O+b7IjGs+oHs=;
        b=Xf9I4wHJC1gUUtMapRknsH4efL6SHhaamgscG7tM8Aiq+ogEHWOEie0QbmH6JZRYdGV6te
        j7VbUxq+N10u3ALrzQEQe4giqc/aDGBHtm2l2tAlRjaM+wadVf8hG1TyIkW8h/V1GZzqNf
        Ir+ksHaw26qabbF+ETU0b4oK3v888tI=
Content-Disposition: inline
In-Reply-To: <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> On Wed 25-01-23 15:14:48, Roman Gushchin wrote:
> > On Wed, Jan 25, 2023 at 03:22:00PM -0300, Marcelo Tosatti wrote:
> > > On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
> > > > On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > > > > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > > > > Disclaimer:
> > > > > > a - The cover letter got bigger than expected, so I had to spli=
t it in
> > > > > >     sections to better organize myself. I am not very confortab=
le with it.
> > > > > > b - Performance numbers below did not include patch 5/5 (Remove=
 flags
> > > > > >     from memcg_stock_pcp), which could further improve performa=
nce for
> > > > > >     drain_all_stock(), but I could only notice the optimization=
 at the
> > > > > >     last minute.
> > > > > >=20
> > > > > >=20
> > > > > > 0 - Motivation:
> > > > > > On current codebase, when drain_all_stock() is ran, it will sch=
edule a
> > > > > > drain_local_stock() for each cpu that has a percpu stock associ=
ated with a
> > > > > > descendant of a given root_memcg.
> >=20
> > Do you know what caused those drain_all_stock() calls? I wonder if we s=
hould look
> > into why we have many of them and whether we really need them?
> >=20
> > It's either some user's actions (e.g. reducing memory.max), either some=
 memcg
> > is entering pre-oom conditions. In the latter case a lot of drain calls=
 can be
> > scheduled without a good reason (assuming the cgroup contain multiple t=
asks running
> > on multiple cpus).
>=20
> I believe I've never got a specific answer to that. We
> have discussed that in the previous version submission
> (20221102020243.522358-1-leobras@redhat.com and specifically
> Y2TQLavnLVd4qHMT@dhcp22.suse.cz). Leonardo has mentioned a mix of RT and
> isolcpus. I was wondering about using memcgs in RT workloads because
> that just sounds weird but let's say this is the case indeed.=20

This could be the case. You can consider an "edge device" where it is
necessary to run a RT workload. It might also be useful to run=20
non realtime applications on the same system.

> Then an RT task or whatever task that is running on an isolated
> cpu can have pcp charges.

Usually the RT task (or more specifically the realtime sensitive loop
of the application) runs entirely on userspace. But i suppose there
could be charges on application startup.

> > Essentially each cpu will try to grab the remains of the memory quota
> > and move it locally. I wonder in such circumstances if we need to disab=
le the pcp-caching
> > on per-cgroup basis.
>=20
> I think it would be more than sufficient to disable pcp charging on an
> isolated cpu. This is not a per memcg property. I can imagine that
> different tasks running in the same memcg can run on a mix of CPUs (e.g.
> only part of it on isolated CPUs). It is a recipe for all sorts of
> priority inversions but well, memcg and RT is there already.

I suppose the more general the solution, the better.

> > Generally speaking, draining of pcpu stocks is useful only if an idle c=
pu is holding some
> > charges/memcg references (it might be not completely idle, but running =
some very special
> > workload which is not doing any kernel allocations or a process belongi=
ng to the root memcg).
> > In all other cases pcpu stock will be either drained naturally by an al=
location from another
> > memcg or an allocation from the same memcg will "restore" it, making dr=
aining useless.
> >=20
> > We also can into drain_all_pages() opportunistically, without waiting f=
or the result.
> > On a busy system it's most likely useless, we might oom before schedule=
d works will be executed.
>=20
> I think the primary objective is that no userspace unintended execution
> happens on isolated cpus.

No interruptions to the userspace code (time sensitive code) running on
isolated CPUs: no IPIs, no task switches.

> > I admit I planned to do some work around and even started, but then nev=
er had enough time to
> > finish it.
> >=20
> > Overall I'm somewhat resistant to an idea of making generic allocation =
& free paths slower
> > for an improvement of stock draining. It's not a strong objection, but =
IMO we should avoid
> > doing this without a really strong reason.
>=20
> Are you OK with a simple opt out on isolated CPUs? That would make
> charges slightly slower (atomic on the hierarchy counters vs. a single
> pcp adjustment) but it would guarantee that the isolated workload is
> predictable which is the primary objective AFAICS.

This would make isolated CPUs "second class citizens": it would be nice
to be able to execute non realtime apps on isolated CPUs as well
(think of different periods of time during a day, one where=20
more realtime apps are required, another where less=20
realtime apps are required).

Concrete example: think of a computer handling vRAN traffic near a=20
cell tower. The traffic (therefore amount of processing required
by realtime applications) might vary during the day.

User might want to run containers that depend on good memcg charging
performance on isolated CPUs.

