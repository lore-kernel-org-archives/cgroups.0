From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Wed, 2 Nov 2022 09:53:49 +0100
Message-ID: <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
References: <20221102020243.522358-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667379230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAyd5hYheJHs7wZ412hApYrbs0qLQ48nSsf9XNgypBM=;
        b=RjV6dnJfhfmC76wKcoNRFCWemxydooK/VGDCWqPhiMz0F/TrV1ZdiW0XKhCBJ8Z7iR628t
        jbGI2t0D0qvdGIrFzIqSqDmp4SOjwQiT0zrCtyvHvOOiv4hyqm+5N/sArHJ9TZeIonaEa1
        LVNRrUQKlBz+NnQeVIaR9H9oNcggfrw=
Content-Disposition: inline
In-Reply-To: <20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 01-11-22 23:02:40, Leonardo Bras wrote:
> Patch #1 expands housekeep=EDng_any_cpu() so we can find housekeeping cpus
> closer (NUMA) to any desired CPU, instead of only the current CPU.
>=20
> ### Performance argument that motivated the change:
> There could be an argument of why would that be needed, since the current
> CPU is probably acessing the current cacheline, and so having a CPU closer
> to the current one is always the best choice since the cache invalidation
> will take less time. OTOH, there could be cases like this which uses
> perCPU variables, and we can have up to 3 different CPUs touching the
> cacheline:
>=20
> C1 - Isolated CPU: The perCPU data 'belongs' to this one
> C2 - Scheduling CPU: Schedule some work to be done elsewhere, current cpu
> C3 - Housekeeping CPU: This one will do the work
>=20
> Most of the times the cacheline is touched, it should be by C1. Some times
> a C2 will schedule work to run on C3, since C1 is isolated.
>=20
> If C1 and C2 are in different NUMA nodes, we could have C3 either in
> C2 NUMA node (housekeeping_any_cpu()) or in C1 NUMA node=20
> (housekeeping_any_cpu_from(C1).=20
>=20
> If C3 is in C2 NUMA node, there will be a faster invalidation when C3
> tries to get cacheline exclusivity, and then a slower invalidation when
> this happens in C1, when it's working in its data.
>=20
> If C3 is in C1 NUMA node, there will be a slower invalidation when C3
> tries to get cacheline exclusivity, and then a faster invalidation when
> this happens in C1.
>=20
> The thing is: it should be better to wait less when doing kernel work
> on an isolated CPU, even at the cost of some housekeeping CPU waiting
> a few more cycles.
> ###
>=20
> Patch #2 changes the locking strategy of memcg_stock_pcp->stock_lock from
> local_lock to spinlocks, so it can be later used to do remote percpu
> cache draining on patch #3. Most performance concerns should be pointed
> in the commit log.
>=20
> Patch #3 implements the remote per-CPU cache drain, making use of both=20
> patches #2 and #3. Performance-wise, in non-isolated scenarios, it should
> introduce an extra function call and a single test to check if the CPU is
> isolated.=20
>=20
> On scenarios with isolation enabled on boot, it will also introduce an
> extra test to check in the cpumask if the CPU is isolated. If it is,
> there will also be an extra read of the cpumask to look for a
> housekeeping CPU.

This is a rather deep dive in the cache line usage but the most
important thing is really missing. Why do we want this change? From the
context it seems that this is an actual fix for isolcpu=3D setup when
remote (aka non isolated activity) interferes with isolated cpus by
scheduling pcp charge caches on those cpus.

Is this understanding correct?

If yes, how big of a problem that is? If you want a remote draining then
you need some sort of locking (currently we rely on local lock). How
come this locking is not going to cause a different form of disturbance?
--=20
Michal Hocko
SUSE Labs
