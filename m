From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 21:32:18 -0300
Message-ID: <Y9MbkuBDI+08AtgN@tpad>
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
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674794293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CP3YQJy/1BqI0NOeozKEh6zQUilSGJ56jPhvOdxgCg=;
        b=WkUjKQ0TOKG6Ayu8Csy4oLzrPAc76BS3zy8eIJBaab7Ffx7FVFmBRdnkJT/nPEmVwubue/
        OtNZVftjzSYyWUL3Oep5OODYzNFbldAi4EKxIQiNcy+d0FKAyPJfseolxJ925k2vsxB5nO
        ANBBEJym0EV5cnGWvcHsKbmBBmLhHSY=
Content-Disposition: inline
In-Reply-To: <Y9LSjnNEEUiF/70R-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
> > > (20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.=
org and specifically
> > > Y2TQLavnLVd4qHMT-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org). Leonardo h=
as mentioned a mix of RT and
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

1) Application which is not time sensitive executes on isolated CPU,
with memcg control enabled. Per-CPU stock is created.

2) App with memcg control enabled exits, per-CPU stock is not drained.

3) Latency sensitive application starts, isolated per-CPU has stock to
be drained, and:

/*
 * Drains all per-CPU charge caches for given root_memcg resp. subtree
 * of the hierarchy under it.
 */
static void drain_all_stock(struct mem_cgroup *root_memcg)
{
        int cpu, curcpu;

        /* If someone's already draining, avoid adding running more workers=
. */
        if (!mutex_trylock(&percpu_charge_mutex))
                return;
        /*
         * Notify other cpus that system-wide "drain" is running
         * We do not care about races with the cpu hotplug because cpu down
         * as well as workers from this path always operate on the local
         * per-cpu data. CPU up doesn't touch memcg_stock at all.
         */
        migrate_disable();
        curcpu =3D smp_processor_id();
        for_each_online_cpu(cpu) {
                struct memcg_stock_pcp *stock =3D &per_cpu(memcg_stock, cpu=
);
                struct mem_cgroup *memcg;
                bool flush =3D false;

                rcu_read_lock();
                memcg =3D stock->cached;
                if (memcg && stock->nr_pages &&
                    mem_cgroup_is_descendant(memcg, root_memcg))
                        flush =3D true;
                else if (obj_stock_flush_required(stock, root_memcg))
                        flush =3D true;
                rcu_read_unlock();

                if (flush &&
                    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags=
)) {
                        if (cpu =3D=3D curcpu)
                                drain_local_stock(&stock->work);
                        else
                                schedule_work_on(cpu, &stock->work);
                }
        }
        migrate_enable();
        mutex_unlock(&percpu_charge_mutex);
}

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
>=20
> > Concrete example: think of a computer handling vRAN traffic near a=20
> > cell tower. The traffic (therefore amount of processing required
> > by realtime applications) might vary during the day.
> >=20
> > User might want to run containers that depend on good memcg charging
> > performance on isolated CPUs.
>=20
> What kind of role would memcg play here? Do you want to memory constrain
> that workload?

See example above.

> --=20
> Michal Hocko
> SUSE Labs
>=20
>=20

