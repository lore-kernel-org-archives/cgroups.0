From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Mon, 7 Nov 2022 09:10:47 +0100
Message-ID: <Y2i9h+TRdX9EOs0T@dhcp22.suse.cz>
References: <20221102020243.522358-1-leobras@redhat.com>
 <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
 <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
 <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
 <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
 <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
 <3c4ae3bb70d92340d9aaaa1856928476641a8533.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667808648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wn3C4j2tq7Ric7uA1MiKmrtd6ucRBH8DGKc7HC5CU8o=;
        b=rDQ0tXHzYEcdlM3iWOS0EHADYuBi7DO5PHDgE5TyXP1fjjQNDPFBRe40t/zcDzPbLvqaPF
        2s6I7xtIEfoHIkCa5kAy7ZgQd3/FDdVOYSDEduOuOH0Fvg1I5oALqj608NhgfgLopujlTT
        /8jE+fvvInBhTN1O/i1aYp8wYC3J7Nw=
Content-Disposition: inline
In-Reply-To: <3c4ae3bb70d92340d9aaaa1856928476641a8533.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 04-11-22 22:45:58, Leonardo Br=E1s wrote:
> On Fri, 2022-11-04 at 09:41 +0100, Michal Hocko wrote:
> > On Thu 03-11-22 13:53:41, Leonardo Br=E1s wrote:
> > > On Thu, 2022-11-03 at 16:31 +0100, Michal Hocko wrote:
> > > > On Thu 03-11-22 11:59:20, Leonardo Br=E1s wrote:
> > [...]
> > > > > I understand there will be a locking cost being paid in the isola=
ted CPUs when:
> > > > > a) The isolated CPU is requesting the stock drain,
> > > > > b) When the isolated CPUs do a syscall and end up using the prote=
cted structure
> > > > > the first time after a remote drain.
> > > >=20
> > > > And anytime the charging path (consume_stock resp. refill_stock)
> > > > contends with the remote draining which is out of control of the RT
> > > > task. It is true that the RT kernel will turn that spin lock into a
> > > > sleeping RT lock and that could help with potential priority invers=
ions
> > > > but still quite costly thing I would expect.
> > > >=20
> > > > > Both (a) and (b) should happen during a syscall, and IIUC the a r=
t workload
> > > > > should not expect the syscalls to be have a predictable time, so =
it should be
> > > > > fine.
> > > >=20
> > > > Now I am not sure I understand. If you do not consider charging pat=
h to
> > > > be RT sensitive then why is this needed in the first place? What el=
se
> > > > would be populating the pcp cache on the isolated cpu? IRQs?
> > >=20
> > > I am mostly trying to deal with drain_all_stock() calling schedule_wo=
rk_on() at
> > > isolated_cpus. Since the scheduled drain_local_stock() will be compet=
ing for cpu
> > > time with the RT workload, we can have preemption of the RT workload,=
 which is a
> > > problem for meeting the deadlines.
> >=20
> > Yes, this is understood. But it is not really clear to me why would any
> > draining be necessary for such an isolated CPU if no workload other than
> > the RT (which pressumably doesn't charge any memory?) is running on that
> > CPU? Is that the RT task during the initialization phase that leaves
> > that cache behind or something else?
>=20
> (I am new to this part of the code, so please correct me when I miss some=
thing.)
>=20
> IIUC,=A0if a process belongs to a control group with memory control, the =
'charge'
> will happen when a memory page starts getting used by it.

Yes, very broadly speaking.

> So, if we assume a RT load in a isolated CPU will not charge any memory, =
we are
> assuming it will never be part of a memory-controlled cgroup.

If the memory cgroup controler is enabled then each user space process
is a part of some memcg. If there is no specific memcg assigned then it
will be a root cgroup and that is skipped during most charges except for
kmem.

> I mean, can we just assume this?=20
>=20
> If I got that right, would not that be considered a limitation? like
> "If you don't want your workload to be interrupted by perCPU cache draini=
ng,
> don't put it in a cgroup with memory control".

We definitely do not want userspace make any assumptions on internal
implementation details like caches.

> > Sorry for being so focused on this
> > but I would like to understand on whether this is avoidable by a
> > different startup scheme or it really needs to be addressed in some way.
>=20
> No worries, I am in fact happy you are giving it this much attention :)
>=20
> I also understand this is a considerable change in the locking strategy, =
and
> avoiding that is the first thing that should be tried.
>=20
> >=20
> > > One way I thought to solve that was introducing a remote drain, which=
 would
> > > require a different strategy for locking, since not all accesses to t=
he pcp
> > > caches would happen on a local CPU.=20
> >=20
> > Yeah, I am not supper happy about additional spin lock TBH. One
> > potential way to go would be to completely avoid pcp cache for isolated
> > CPUs.=A0That would have some performance impact of course but on the ot=
her
> > hand it would give a more predictable behavior for those CPUs which
> > sounds like a reasonable compromise to me. What do you think?
>=20
> You mean not having a perCPU stock, then?=20
> So consume_stock() for isolated CPUs would always return false, causing
> try_charge_memcg() always walking the slow path?

Exactly.

> IIUC, both my proposal and yours would degrade performance only when we u=
se
> isolated CPUs + memcg. Is that correct?

Yes, with a notable difference that with your spin lock option there is
still a chance that the remote draining could influence the isolated CPU
workload throug that said spinlock. If there is no pcp cache for that
cpu being used then there is no potential interaction at all.

> If so, it looks like the impact would be even bigger without perCPU stock=
 ,
> compared to introducing a spinlock.
>=20
> Unless, we are counting to this case where a remote CPU is draining an is=
olated
> CPU, and the isolated CPU faults a page, and has to wait for the spinlock=
 to be
> released in the remote CPU. Well, this seems possible to happen, but I wo=
uld
> have to analyze how often would it happen, and how much would it impact t=
he
> deadlines. I *guess* most of the RT workload's memory pages are pre-fault=
ed
> before its starts, so it can avoid the faulting latency, but I need to co=
nfirm
> that.

Yes, that is a general practice and the reason why I was asking how real
of a problem that is in practice. It is true true that appart from user
space memory which can be under full control of the userspace there are
kernel allocations which can be done on behalf of the process and those
could be charged to memcg as well. So I can imagine the pcp cache could
be populated even if the process is not faulting anything in during RT
sensitive phase.

> On the other hand, compared to how it works now now, this should be a more
> controllable way of introducing latency than a scheduled cache drain.
>=20
> Your suggestion on no-stocks/caches in isolated CPUs would be great for
> predictability, but I am almost sure the cost in overall performance woul=
d not
> be fine.

It is hard to estimate the overhead without measuring that. Do you think
you can give it a try? If the performance is not really acceptable
(which I would be really surprised) then we can think of a more complex
solution.

> With the possibility of prefaulting pages, do you see any scenario that w=
ould
> introduce some undesirable latency in the workload?

My primary concern would be spin lock contention which is hard to
predict with something like remote draining.
--=20
Michal Hocko
SUSE Labs
