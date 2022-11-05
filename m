From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Fri, 04 Nov 2022 22:45:58 -0300
Message-ID: <3c4ae3bb70d92340d9aaaa1856928476641a8533.camel@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
         <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
         <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
         <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
         <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
         <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667612770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/vEmjXbFu8njlGuJecpg9SySWjZKX34Yfb/SdTSRfo=;
        b=VrEozZwgxQPFEvmkXghz/W0V9J2V4NibnFadX8Xc4w5F7SFUgE0taRpZo/zUUlU1GlVrfF
        7CRZX3zSDJrrFfFH4AtUGug2PbcX0sRyE3+WhgyXJRQ4CjPd4sjS+FRzzTEIskiFdTKPBf
        GIVtE2v3CkJCDGosLCgzTTkROztGMbA=
In-Reply-To: <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Frederic Weisbecker <frederic@kernel.org>, Phil Auld <pauld@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 2022-11-04 at 09:41 +0100, Michal Hocko wrote:
> On Thu 03-11-22 13:53:41, Leonardo Br=C3=A1s wrote:
> > On Thu, 2022-11-03 at 16:31 +0100, Michal Hocko wrote:
> > > On Thu 03-11-22 11:59:20, Leonardo Br=C3=A1s wrote:
> [...]
> > > > I understand there will be a locking cost being paid in the isolate=
d CPUs when:
> > > > a) The isolated CPU is requesting the stock drain,
> > > > b) When the isolated CPUs do a syscall and end up using the protect=
ed structure
> > > > the first time after a remote drain.
> > >=20
> > > And anytime the charging path (consume_stock resp. refill_stock)
> > > contends with the remote draining which is out of control of the RT
> > > task. It is true that the RT kernel will turn that spin lock into a
> > > sleeping RT lock and that could help with potential priority inversio=
ns
> > > but still quite costly thing I would expect.
> > >=20
> > > > Both (a) and (b) should happen during a syscall, and IIUC the a rt =
workload
> > > > should not expect the syscalls to be have a predictable time, so it=
 should be
> > > > fine.
> > >=20
> > > Now I am not sure I understand. If you do not consider charging path =
to
> > > be RT sensitive then why is this needed in the first place? What else
> > > would be populating the pcp cache on the isolated cpu? IRQs?
> >=20
> > I am mostly trying to deal with drain_all_stock() calling schedule_work=
_on() at
> > isolated_cpus. Since the scheduled drain_local_stock() will be competin=
g for cpu
> > time with the RT workload, we can have preemption of the RT workload, w=
hich is a
> > problem for meeting the deadlines.
>=20
> Yes, this is understood. But it is not really clear to me why would any
> draining be necessary for such an isolated CPU if no workload other than
> the RT (which pressumably doesn't charge any memory?) is running on that
> CPU? Is that the RT task during the initialization phase that leaves
> that cache behind or something else?

(I am new to this part of the code, so please correct me when I miss someth=
ing.)

IIUC,=C2=A0if a process belongs to a control group with memory control, the=
 'charge'
will happen when a memory page starts getting used by it.

So, if we assume a RT load in a isolated CPU will not charge any memory, we=
 are
assuming it will never be part of a memory-controlled cgroup.

I mean, can we just assume this?=20

If I got that right, would not that be considered a limitation? like
"If you don't want your workload to be interrupted by perCPU cache draining=
,
don't put it in a cgroup with memory control".

> Sorry for being so focused on this
> but I would like to understand on whether this is avoidable by a
> different startup scheme or it really needs to be addressed in some way.

No worries, I am in fact happy you are giving it this much attention :)

I also understand this is a considerable change in the locking strategy, an=
d
avoiding that is the first thing that should be tried.

>=20
> > One way I thought to solve that was introducing a remote drain, which w=
ould
> > require a different strategy for locking, since not all accesses to the=
 pcp
> > caches would happen on a local CPU.=20
>=20
> Yeah, I am not supper happy about additional spin lock TBH. One
> potential way to go would be to completely avoid pcp cache for isolated
> CPUs.=C2=A0That would have some performance impact of course but on the o=
ther
> hand it would give a more predictable behavior for those CPUs which
> sounds like a reasonable compromise to me. What do you think?

You mean not having a perCPU stock, then?=20
So consume_stock() for isolated CPUs would always return false, causing
try_charge_memcg() always walking the slow path?

IIUC, both my proposal and yours would degrade performance only when we use
isolated CPUs + memcg. Is that correct?

If so, it looks like the impact would be even bigger without perCPU stock ,
compared to introducing a spinlock.

Unless, we are counting to this case where a remote CPU is draining an isol=
ated
CPU, and the isolated CPU faults a page, and has to wait for the spinlock t=
o be
released in the remote CPU. Well, this seems possible to happen, but I woul=
d
have to analyze how often would it happen, and how much would it impact the
deadlines. I *guess* most of the RT workload's memory pages are pre-faulted
before its starts, so it can avoid the faulting latency, but I need to conf=
irm
that.

On the other hand, compared to how it works now now, this should be a more
controllable way of introducing latency than a scheduled cache drain.

Your suggestion on no-stocks/caches in isolated CPUs would be great for
predictability, but I am almost sure the cost in overall performance would =
not
be fine.

With the possibility of prefaulting pages, do you see any scenario that wou=
ld
introduce some undesirable latency in the workload?

Thanks a lot for the discussion!
Leo

