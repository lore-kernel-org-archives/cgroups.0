From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Thu, 03 Nov 2022 13:53:41 -0300
Message-ID: <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
         <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
         <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
         <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667494430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gERfL0EPpR1L5+55Qs7xdMhql2jPX0zv2LAyPLcrgS0=;
        b=NOvzsyTOL9/m03zGpn9TcNxUpu0m6AJ8niIZjyE6F+59k1PrecIeNOlw2mCGnS/YSqibPw
        xffgxMWn+Gm9welz7SO5QRPrSIBDeqLLR71I3fhFctaAwQ/fx6N2rWqkHuaubNIi1P+9UR
        k21uC6jrIFZtZNCQbysK3CcOnR6J074=
In-Reply-To: <Y2Pe45LHANFxxD7B-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2022-11-03 at 16:31 +0100, Michal Hocko wrote:
> On Thu 03-11-22 11:59:20, Leonardo Br=C3=A1s wrote:
> > On Wed, 2022-11-02 at 09:53 +0100, Michal Hocko wrote:
> > > On Tue 01-11-22 23:02:40, Leonardo Bras wrote:
> > > > Patch #1 expands housekeep=C3=ADng_any_cpu() so we can find houseke=
eping cpus
> > > > closer (NUMA) to any desired CPU, instead of only the current CPU.
> > > >=20
> > > > ### Performance argument that motivated the change:
> > > > There could be an argument of why would that be needed, since the c=
urrent
> > > > CPU is probably acessing the current cacheline, and so having a CPU=
 closer
> > > > to the current one is always the best choice since the cache invali=
dation
> > > > will take less time. OTOH, there could be cases like this which use=
s
> > > > perCPU variables, and we can have up to 3 different CPUs touching t=
he
> > > > cacheline:
> > > >=20
> > > > C1 - Isolated CPU: The perCPU data 'belongs' to this one
> > > > C2 - Scheduling CPU: Schedule some work to be done elsewhere, curre=
nt cpu
> > > > C3 - Housekeeping CPU: This one will do the work
> > > >=20
> > > > Most of the times the cacheline is touched, it should be by C1. Som=
e times
> > > > a C2 will schedule work to run on C3, since C1 is isolated.
> > > >=20
> > > > If C1 and C2 are in different NUMA nodes, we could have C3 either i=
n
> > > > C2 NUMA node (housekeeping_any_cpu()) or in C1 NUMA node=20
> > > > (housekeeping_any_cpu_from(C1).=20
> > > >=20
> > > > If C3 is in C2 NUMA node, there will be a faster invalidation when =
C3
> > > > tries to get cacheline exclusivity, and then a slower invalidation =
when
> > > > this happens in C1, when it's working in its data.
> > > >=20
> > > > If C3 is in C1 NUMA node, there will be a slower invalidation when =
C3
> > > > tries to get cacheline exclusivity, and then a faster invalidation =
when
> > > > this happens in C1.
> > > >=20
> > > > The thing is: it should be better to wait less when doing kernel wo=
rk
> > > > on an isolated CPU, even at the cost of some housekeeping CPU waiti=
ng
> > > > a few more cycles.
> > > > ###
> > > >=20
> > > > Patch #2 changes the locking strategy of memcg_stock_pcp->stock_loc=
k from
> > > > local_lock to spinlocks, so it can be later used to do remote percp=
u
> > > > cache draining on patch #3. Most performance concerns should be poi=
nted
> > > > in the commit log.
> > > >=20
> > > > Patch #3 implements the remote per-CPU cache drain, making use of b=
oth=20
> > > > patches #2 and #3. Performance-wise, in non-isolated scenarios, it =
should
> > > > introduce an extra function call and a single test to check if the =
CPU is
> > > > isolated.=20
> > > >=20
> > > > On scenarios with isolation enabled on boot, it will also introduce=
 an
> > > > extra test to check in the cpumask if the CPU is isolated. If it is=
,
> > > > there will also be an extra read of the cpumask to look for a
> > > > housekeeping CPU.
> > >=20
> >=20
> > Hello Michael, thanks for reviewing!
> >=20
> > > This is a rather deep dive in the cache line usage but the most
> > > important thing is really missing. Why do we want this change? From t=
he
> > > context it seems that this is an actual fix for isolcpu=3D setup when
> > > remote (aka non isolated activity) interferes with isolated cpus by
> > > scheduling pcp charge caches on those cpus.
> > >=20
> > > Is this understanding correct?
> >=20
> > That's correct! The idea is to avoid scheduling work to isolated CPUs.
> >=20
> > > If yes, how big of a problem that is?
> >=20
> > The use case I have been following requires both isolcpus=3D and PREEMP=
T_RT, since
> > the isolated CPUs will be running a real-time workload. In this scenari=
o,
> > getting any work done instead of the real-time workload may cause the s=
ystem to
> > miss a deadline, which can be bad.=20
>=20
> OK, I see. But is memcg charging actually a RT friendly operation in the
> first place? Please note that this path can trigger memory reclaim and
> that is when any RT expectations are simply going down the drain.

I understand the spent time for charging is unpredictable as you said, sinc=
e a
lot of slow stuff may or may not happen.=20

>=20
> > >  If you want a remote draining then
> > > you need some sort of locking (currently we rely on local lock). How
> > > come this locking is not going to cause a different form of disturban=
ce?
> >=20
> > If I did everything right, most of the extra work should be done either=
 in non-
> > isolated (housekeeping) CPUs, or during a syscall. I mean, the pcp char=
ge caches
> > will be happening on a housekeeping CPU, and the locking cost should be=
 paid
> > there as we want to avoid doing that in the isolated CPUs.=20

Sorry, I think this caused a misunderstanding: I meant "the pcp charge cach=
e
drain will be happening on a housekeeping CPU, ..."

> >=20
> > I understand there will be a locking cost being paid in the isolated CP=
Us when:
> > a) The isolated CPU is requesting the stock drain,
> > b) When the isolated CPUs do a syscall and end up using the protected s=
tructure
> > the first time after a remote drain.
>=20
> And anytime the charging path (consume_stock resp. refill_stock)
> contends with the remote draining which is out of control of the RT
> task. It is true that the RT kernel will turn that spin lock into a
> sleeping RT lock and that could help with potential priority inversions
> but still quite costly thing I would expect.
>=20
> > Both (a) and (b) should happen during a syscall, and IIUC the a rt work=
load
> > should not expect the syscalls to be have a predictable time, so it sho=
uld be
> > fine.
>=20
> Now I am not sure I understand. If you do not consider charging path to
> be RT sensitive then why is this needed in the first place? What else
> would be populating the pcp cache on the isolated cpu? IRQs?

I am mostly trying to deal with drain_all_stock() calling schedule_work_on(=
) at
isolated_cpus. Since the scheduled drain_local_stock() will be competing fo=
r cpu
time with the RT workload, we can have preemption of the RT workload, which=
 is a
problem for meeting the deadlines.

One way I thought to solve that was introducing a remote drain, which would
require a different strategy for locking, since not all accesses to the pcp
caches would happen on a local CPU.=20

Then I tried to weight the costs of this, so the solution would introduce a=
s
little overhead as possible on no-isolation scenarios. Also, for isolation
scenarios, I tried to put most of the overheads into the housekeeping CPUs,=
 and
the remaining on the syscalls, which are also expected to be non-predictabl=
e.

Not sure if I could answer your question, though. Please let me know in cas=
e I
missed anything.

Thanks for helping me make it more clear!
Best regards,
Leo




