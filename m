From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Wed, 25 Jan 2023 04:44:12 -0300
Message-ID: <958969c204e1041dead005d1c801cf3c54ab86f1.camel@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
         <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
         <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
         <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
         <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
         <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
         <3c4ae3bb70d92340d9aaaa1856928476641a8533.camel@redhat.com>
         <Y2i9h+TRdX9EOs0T@dhcp22.suse.cz>
         <4a4a6c73f3776d65f70f7ca92eb26fc90ed3d51a.camel@redhat.com>
         <Y2tfSAgt/lBVcdvf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkeMwblj9hneaBAEGr4WY7HayLEL2jAXC1+f00C91Gc=;
        b=ecETXQha7bGH2bR2B1N0BH8X1pQUXfLZ4I8+4UaPB33qDQsHmssB0pul9kyW1idN8dnSSK
        6DPqAA9X7zf0BqvwgrIOHHWHn8IXbebSkh0nVMrCUejl5UJFFa/f5IeoOkRMPyje9qkpiO
        xxUtIsB0edwvRtVrZQhzNi1SVZImVB4=
In-Reply-To: <Y2tfSAgt/lBVcdvf-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2022-11-09 at 09:05 +0100, Michal Hocko wrote:
> On Tue 08-11-22 20:09:25, Leonardo Br=C3=A1s wrote:
> [...]
> > > Yes, with a notable difference that with your spin lock option there =
is
> > > still a chance that the remote draining could influence the isolated =
CPU
> > > workload throug that said spinlock. If there is no pcp cache for that
> > > cpu being used then there is no potential interaction at all.
> >=20
> > I see.=20
> > But the slow path is slow for some reason, right?
> > Does not it make use of any locks also? So on normal operation there co=
uld be a
> > potentially larger impact than a spinlock, even though there would be n=
o
> > scheduled draining.
>=20
> Well, for the regular (try_charge) path that is essentially page_counter_=
try_charge
> which boils down to atomic_long_add_return of the memcg counter + all
> parents up the hierarchy and high memory limit evaluation (essentially 2
> atomic_reads for the memcg + all parents up the hierchy). That is not
> whole of a lot - especially when the memcg hierarchy is not very deep.
>=20
> Per cpu batch amortizes those per hierarchy updates as well as atomic
> operations + cache lines bouncing on updates.
>=20
> On the other hand spinlock would do the unconditional atomic updates as
> well and even much more on CONFIG_RT. A plus is that the update will be
> mostly local so cache line bouncing shouldn't be terrible. Unless
> somebody heavily triggers pcp cache draining but this shouldn't be all
> that common (e.g. when a memcg triggers its limit.
>=20
> All that being said, I am still not convinced that the pcp cache bypass
> for isolated CPUs would make a dramatic difference. Especially in the
> context of workloads that tend to run on isolated CPUs and rarely enter
> kernel.
> =20
> > > It is true true that appart from user
> > > space memory which can be under full control of the userspace there a=
re
> > > kernel allocations which can be done on behalf of the process and tho=
se
> > > could be charged to memcg as well. So I can imagine the pcp cache cou=
ld
> > > be populated even if the process is not faulting anything in during R=
T
> > > sensitive phase.
> >=20
> > Humm, I think I will apply the change and do a comparative testing with
> > upstream. This should bring good comparison results.
>=20
> That would be certainly appreciated!
>  (
> > > > On the other hand, compared to how it works now now, this should be=
 a more
> > > > controllable way of introducing latency than a scheduled cache drai=
n.
> > > >=20
> > > > Your suggestion on no-stocks/caches in isolated CPUs would be great=
 for
> > > > predictability, but I am almost sure the cost in overall performanc=
e would not
> > > > be fine.
> > >=20
> > > It is hard to estimate the overhead without measuring that. Do you th=
ink
> > > you can give it a try? If the performance is not really acceptable
> > > (which I would be really surprised) then we can think of a more compl=
ex
> > > solution.
> >=20
> > Sure, I can try that.
> > Do you suggest any specific workload that happens to stress the percpu =
cache
> > usage, with usual drains and so? Maybe I will also try with synthetic w=
orloads
> > also.
>=20
> I really think you want to test it on the isolcpu aware workload.
> Artificial benchmark are not all that useful in this context.

Hello Michael,
I just sent a v2 for this patchset with a lot of changes.
https://lore.kernel.org/lkml/20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

I have tried to gather some data on the performance numbers as suggested, b=
ut I
got carried away and the cover letter ended up too big. I hope it's not too=
 much
trouble.

Best regards,
Leo



