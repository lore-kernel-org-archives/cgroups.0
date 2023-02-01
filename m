From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 1 Feb 2023 13:52:02 +0100
Message-ID: <Y9pgcu0uNOHR6DtR@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
 <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
 <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
 <Y9j9BnMwfm4TJks7@tpad>
 <5ba79c4feb829ed75cfd98cf5c8042dcb2ddea91.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675255923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahdHEkL6cjj6jcOVThTdJ4/WM1AMyhpAQrlh1KA5/0o=;
        b=q+fnl7ogJjUTPNIHkdGClmlCT9ItWknSniWMYQh0SGW3jPjXK78Ua+YG0+KvM573mOv6jK
        sCGunPe5GGmeSesvLWg0ova+4WsytcXXKTMnFtxjkHfAwH4I3ccP+1UgWnQFqEb/CbSlLf
        DW7KBcRoMlRSRdZTCehZxHeZ0dEXESI=
Content-Disposition: inline
In-Reply-To: <5ba79c4feb829ed75cfd98cf5c8042dcb2ddea91.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 01-02-23 01:36:07, Leonardo Br=E1s wrote:
[...]
> Michal, Roman: Could you please review my argumentation below, so I can
> understand what exactly is wrong ?
>=20
> > >=20
> > > IIUC, we can approach this by dividing the problem in two working mod=
es:
> > > 1 - Normal, meaning no drain_all_stock() running.
> > > 2 - Draining, grouping together pre-OOM and userspace 'config' : chan=
ging,
> > > destroying, reconfiguring a memcg.
> > >=20
> > > For (1), we will have (ideally) only local cpu working on the percpu =
struct.
> > > This mode will not have any kind of contention, because each CPU will=
 hold it's
> > > own spinlock only.=20

You are still hitting locked atomic operations which is not the case for
a simple pcp access. As already mentioned page counter (which would be
taken in case of no pcp cache) is also about atomics (elbeit more of
them with a deeper cgroup hierarchy).

> > > For (2), we will have a lot of drain_all_stock() running. This will m=
ean a lot
> > > of schedule_work_on() running (on upstream) or possibly causing conte=
ntion, i.e.
> > > local cpus having to wait for a lock to get their cache, on the patch=
 proposal.

Yes.

> > > Ok, given the above is correct:
> > >=20
> > > # Some arguments point that (1) becomes slower with this patch.
> > >=20
> > > This is partially true: while test 2.2 pointed that local cpu functio=
ns running
> > > time had became slower by a few cycles, test 2.4 points that the user=
space
> > > perception of it was that the syscalls and pagefaulting actually beca=
me faster:
> > >=20
> > > During some debugging tests before getting the performance on test 2.=
4, I
> > > noticed that the 'syscall + write' test would call all those function=
s that
> > > became slower on test 2.2. Those functions were called multiple milli=
ons of
> > > times during a single test, and still the patched version performance=
 test
> > > returned faster for test 2.4 than upstream version. Maybe the functio=
ns became
> > > slower, but overall the usage of them in the usual context became fas=
ter.

It is hard to tell anything without proper analysis of those numbers.

> > > Is not that a small improvement?
> > >=20
> > > # Regarding (2), I notice that we fear contention=20
> > >=20
> > > While this seems to be the harder part of the discussion, I think we =
have enough
> > > data to deal with it.=20
> > >=20
> > > In which case contention would be a big problem here?=A0
> > > IIUC it would be when a lot of drain_all_stock() get running because =
the memory
> > > limit is getting near.=A0I mean, having the user to create / modify a=
 memcg
> > > multiple times a second for a while is not something that is expected=
, IMHO.

We have already explained when that happens. You are right this is not
happening all that much in most workloads. But this is a user triggered
operation so you cannot really many assumptions. It will really depend
on the workload.

> > Considering that the use of spinlocks with remote draining is the more =
general solution,
> > what would be a test-case to demonstrate a contention problem?
>=20
> IIUC we could try to reproduce a memory tight workload that keeps allocat=
ing /
> freeing from different cpus (without hitting OOM).
>=20
> Michal, Roman: Is that correct? You have any workload like that so we can=
 test?

It would be easy to create artificial workload that would hit this. All
you need is to trigger any of the code paths that have already been
mentioned elsewhere from the userspace.

Let me be clear here. Unless there are some real concerns about not
flushing remotely on isolated cpus then the spin lock approach is just
much less preferable. So I would much rather focus on the trivial patch
and investigates whether there are no new corner cases to be created by
that.
--=20
Michal Hocko
SUSE Labs
