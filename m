From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Tue, 31 Jan 2023 08:35:34 -0300
Message-ID: <Y9j9BnMwfm4TJks7@tpad>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
 <Y9LDAZmApLeffrT8@tpad>
 <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
 <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675167263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZI6TznWrCUh+xycNx8ZosQqJbANhtpTUAwz/zUSHIhs=;
        b=ClB6+t231VWVALVehqCX4f1gmd6bmjdcBi4YVoCkAL5e4ED7vtCovSO1X9t/7jteBm96ep
        llo7VdxxqcB0sBaWILoXgW92rIx7nYnfspeELbCjtLTIQJtSbTuEqmv4mqlgtSoQGzdSaM
        /noD+0a9JWqNbLILsKOSghDjB6mBwi4=
Content-Disposition: inline
In-Reply-To: <0122005439ffb7895efda7a1a67992cbe41392fe.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 27, 2023 at 03:55:39AM -0300, Leonardo Br=E1s wrote:
> On Thu, 2023-01-26 at 20:13 +0100, Michal Hocko wrote:
> > On Thu 26-01-23 15:14:25, Marcelo Tosatti wrote:
> > > On Thu, Jan 26, 2023 at 08:45:36AM +0100, Michal Hocko wrote:
> > > > On Wed 25-01-23 15:22:00, Marcelo Tosatti wrote:
> > > > [...]
> > > > > Remote draining reduces interruptions whether CPU=20
> > > > > is marked as isolated or not:
> > > > >=20
> > > > > - Allows isolated CPUs from benefiting of pcp caching.
> > > > > - Removes the interruption to non isolated CPUs. See for example =

> > > > >=20
> > > > > https://lkml.org/lkml/2022/6/13/2769
> > > >=20
> > > > This is talking about page allocato per cpu caches, right? In this =
patch
> > > > we are talking about memcg pcp caches. Are you sure the same applies
> > > > here?
> > >=20
> > > Both can stall the users of the drain operation.
> >=20
> > Yes. But it is important to consider who those users are. We are
> > draining when
> > 	- we are charging and the limit is hit so that memory reclaim
> > 	  has to be triggered.
> > 	- hard, high limits are set and require memory reclaim.
> > 	- force_empty - full memory reclaim for a memcg
> > 	- memcg offlining - cgroup removel - quite a heavy operation as
> > 	  well.
> > all those could be really costly kernel operations and they affect
> > isolated cpu only if the same memcg is used by both isolated and non-is=
olated
> > cpus. In other words those costly operations would have to be triggered
> > from non-isolated cpus and those are to be expected to be stalled. It is
> > the side effect of the local cpu draining that is scheduled that affects
> > the isolated cpu as well.
> >=20
> > Is that more clear?
>=20
> I think so, please help me check:
>=20
> IIUC, we can approach this by dividing the problem in two working modes:
> 1 - Normal, meaning no drain_all_stock() running.
> 2 - Draining, grouping together pre-OOM and userspace 'config' : changing,
> destroying, reconfiguring a memcg.
>=20
> For (1), we will have (ideally) only local cpu working on the percpu stru=
ct.
> This mode will not have any kind of contention, because each CPU will hol=
d it's
> own spinlock only.=20
>=20
> For (2), we will have a lot of drain_all_stock() running. This will mean =
a lot
> of schedule_work_on() running (on upstream) or possibly causing contentio=
n, i.e.
> local cpus having to wait for a lock to get their cache, on the patch pro=
posal.
>=20
> Ok, given the above is correct:
>=20
> # Some arguments point that (1) becomes slower with this patch.
>=20
> This is partially true: while test 2.2 pointed that local cpu functions r=
unning
> time had became slower by a few cycles, test 2.4 points that the userspace
> perception of it was that the syscalls and pagefaulting actually became f=
aster:
>=20
> During some debugging tests before getting the performance on test 2.4, I
> noticed that the 'syscall + write' test would call all those functions th=
at
> became slower on test 2.2. Those functions were called multiple millions =
of
> times during a single test, and still the patched version performance test
> returned faster for test 2.4 than upstream version. Maybe the functions b=
ecame
> slower, but overall the usage of them in the usual context became faster.
>=20
> Is not that a small improvement?
>=20
> # Regarding (2), I notice that we fear contention=20
>=20
> While this seems to be the harder part of the discussion, I think we have=
 enough
> data to deal with it.=20
>=20
> In which case contention would be a big problem here?=A0
> IIUC it would be when a lot of drain_all_stock() get running because the =
memory
> limit is getting near.=A0I mean, having the user to create / modify a mem=
cg
> multiple times a second for a while is not something that is expected, IM=
HO.

Considering that the use of spinlocks with remote draining is the more gene=
ral solution,
what would be a test-case to demonstrate a contention problem?

> Now, if I assumed correctly and the case where contention could be a prob=
lem is
> on a memcg with high memory pressure, then we have the argument that Marc=
elo
> Tosatti brought to the discussion[P1]: using spinlocks on percpu caches f=
or page
> allocation brought better results than local_locks + schedule_work_on().
>=20
> I mean, while contention would cause the cpu to wait for a while before g=
etting
> the lock for allocating a page from cache, something similar would happen=
 with
> schedule_work_on(), which would force the current task to wait while the
> draining happens locally.=A0
>=20
> What I am able to see is that, for each drain_all_stock(), for each cpu g=
etting
> drained we have the option to (a) (sometimes) wait for a lock to be freed=
, or
> (b) wait for a whole context switch to happen.
> And IIUC, (b) is much slower than (a) on average, and this is what causes=
 the
> improved performance seen in [P1].

Moreover, there is a delay for the remote CPU to execute a work item=20
(there could be high priority tasks, IRQ handling on the remote CPU,
which delays execution of the work item even further).

Also, the other point is that the spinlock already exists for
PREEMPT_RT (which means that any potential contention issue=20
with the spinlock today is limited to PREEMPT_RT users).

So it would be good to point out a specific problematic=20
testcase/scenario with using the spinlock in this particular case?

> (I mean, waiting while drain_local_stock() runs in the local CPU vs waiti=
ng for
> it to run on the remote CPU may not be that different, since the cachelin=
e is
> already writen to by the remote cpu on Upstream)
>=20
> Also according to test 2.2, for the patched version, drain_local_stock() =
have
> gotten faster (much faster for 128 cpus), even though it does all the dra=
ining
> instead of just scheduling it on the other cpus.=A0
> I mean, summing that to the brief nature of local cpu functions, we may n=
ot hit
> contention as much as we are expected.
>=20
> ##
>=20
> Sorry for the long text.
> I may be missing some point, please let me know if that's the case.
>=20
> Thanks a lot for reviewing!
> Leo
>=20
> [P1]: https://lkml.org/lkml/2022/6/13/2769
>=20
>=20

