From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Fri, 4 Nov 2022 09:41:17 +0100
Message-ID: <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
References: <20221102020243.522358-1-leobras@redhat.com>
 <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
 <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
 <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
 <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667551278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4eYXI+v91C6UMV4JDFYPXhsb0OglU6TPm28ARvvnQc0=;
        b=ignxq6jJhyE/tP3iqNKVyIiU2gyTbpXAnLQ+1lHoEkIuWks2akbLfofAqjF2DaKV8sA1Kx
        FYeeJibPxdNJ1SNhKyCHXBpg/Xc3DoyVSssg1TULNGwebyqN90bDOIaITJRFBBxGDGkhXs
        f/8b3x8DoQCzaDnzbi9VGaVO1Uz+WIo=
Content-Disposition: inline
In-Reply-To: <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 03-11-22 13:53:41, Leonardo Br=E1s wrote:
> On Thu, 2022-11-03 at 16:31 +0100, Michal Hocko wrote:
> > On Thu 03-11-22 11:59:20, Leonardo Br=E1s wrote:
[...]
> > > I understand there will be a locking cost being paid in the isolated =
CPUs when:
> > > a) The isolated CPU is requesting the stock drain,
> > > b) When the isolated CPUs do a syscall and end up using the protected=
 structure
> > > the first time after a remote drain.
> >=20
> > And anytime the charging path (consume_stock resp. refill_stock)
> > contends with the remote draining which is out of control of the RT
> > task. It is true that the RT kernel will turn that spin lock into a
> > sleeping RT lock and that could help with potential priority inversions
> > but still quite costly thing I would expect.
> >=20
> > > Both (a) and (b) should happen during a syscall, and IIUC the a rt wo=
rkload
> > > should not expect the syscalls to be have a predictable time, so it s=
hould be
> > > fine.
> >=20
> > Now I am not sure I understand. If you do not consider charging path to
> > be RT sensitive then why is this needed in the first place? What else
> > would be populating the pcp cache on the isolated cpu? IRQs?
>=20
> I am mostly trying to deal with drain_all_stock() calling schedule_work_o=
n() at
> isolated_cpus. Since the scheduled drain_local_stock() will be competing =
for cpu
> time with the RT workload, we can have preemption of the RT workload, whi=
ch is a
> problem for meeting the deadlines.

Yes, this is understood. But it is not really clear to me why would any
draining be necessary for such an isolated CPU if no workload other than
the RT (which pressumably doesn't charge any memory?) is running on that
CPU? Is that the RT task during the initialization phase that leaves
that cache behind or something else? Sorry for being so focused on this
but I would like to understand on whether this is avoidable by a
different startup scheme or it really needs to be addressed in some way.

> One way I thought to solve that was introducing a remote drain, which wou=
ld
> require a different strategy for locking, since not all accesses to the p=
cp
> caches would happen on a local CPU.=20

Yeah, I am not supper happy about additional spin lock TBH. One
potential way to go would be to completely avoid pcp cache for isolated
CPUs. That would have some performance impact of course but on the other
hand it would give a more predictable behavior for those CPUs which
sounds like a reasonable compromise to me. What do you think?
--=20
Michal Hocko
SUSE Labs
