From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Sat, 04 Feb 2023 01:55:10 -0300
Message-ID: <28e08669302ad1e7a41bdf8b9988de6a352b5fe1.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
         <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
         <Y9FzSBw10MGXm2TK@tpad> <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
         <Y9LDAZmApLeffrT8@tpad> <Y9LQ615H13RmG7wL@dhcp22.suse.cz>
         <0122005439ffb7895efda7a1a67992cbe41392fe.camel@redhat.com>
         <Y9j9BnMwfm4TJks7@tpad> <Y9pd7AxAILUSHrpe@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675486520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQ4uha3PJgX8OHjyXh+WN0eX5F0h2aTsXeAPONLwqFE=;
        b=doVlUpZKxsaV8oJSqURQbXInQRusPJXHV5MdJ9RUPe2jpLq9ukRm2Js+c1twoyLsjNcVdW
        WMgfFggZbgnj5/bWy26wTbpj1wGdytuGWPRGb4SiSe70fBnYR7DrH75R3RRkBc8WYkr5D/
        T5jZFA87Mx+A9dKudVsxbzZwuEfqFk8=
In-Reply-To: <Y9pd7AxAILUSHrpe-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal, Roman,

I understand you have far more experience in this codebase than myself, so
please help me understand what am I missing in my argument for the spinlock
approach.=C2=A0

I honestly want to improve, and your help is really appreciated.

On Wed, 2023-02-01 at 13:41 +0100, Michal Hocko wrote:
> On Tue 31-01-23 08:35:34, Marcelo Tosatti wrote:
> [...]
> > So it would be good to point out a specific problematic=20
> > testcase/scenario with using the spinlock in this particular case?
>=20
> Please think about it some more. The sole purpose of the pcp charge
> caching is to avoid atomics because the normal fast path (i.e. no limit
> hit) is a page counter which is an atomic counter. If you go with a spin
> lock for the pcp cache you are just losing some of the advantage of the
> caching. Sure that would be a smaller atomics use than a deeper memcg
> hierarchy but still.

I could read the code that calls consume_stock(), and noticed that you are
probably referencing the atomic operations on memcg->memory->usage (and oth=
ers)
used in page_counter_try_charge(). It is a single atomic variable per memcg=
 that
is potentially accessed by every cpu. Is that correct?

I understand the cost of an atomic operation such as this is high because o=
f the
inherent high cost of bouncing the variable's cacheline between those cpus.

The difference between 'usage' atomic variable and the spinlock we are prop=
osing
is the scope of the variable: spinlock is defined on a per-cpu structure,=
=C2=A0and
most of the accesses will come from the local cpu.=C2=A0

According to=C2=A0Intel=C2=AE 64 and IA-32 Architectures Software Developer=
=E2=80=99s Manual, at
Vol. 3A page 9-5:

###
9.1.4 Effects of a LOCK Operation on Internal Processor Caches
[...]
For the P6 and more recent processor families, if the area of memory being
locked during a LOCK operation is cached in the processor that is performin=
g the
LOCK operation as write-back memory and is completely contained in a cache =
line,
the processor may not assert the LOCK# signal on the bus. Instead, it will
modify the memory location internally and allow it=E2=80=99s cache coherenc=
y mechanism
to ensure that the operation is carried out atomically. This operation is c=
alled
=E2=80=9Ccache locking.=E2=80=9D The cache coherency mechanism automaticall=
y prevents two or
more processors that have cached the same area of memory from simultaneousl=
y
modifying data in that area.
###

So locking on a percpu spinlock which is cached in the current cpu (happens=
 most
of time) is as cheap as modifying the local cacheline. Since the cachelines=
 are
already modified in the local cpu functions, so the write to memory is batc=
hed.

For reference, this is the pahole output for memcg_stock_pcp after my patch=
. The
spinlock fits in the same cacheline as the changed variables.

struct memcg_stock_pcp {
	spinlock_t                 stock_lock;           /*     0     4 */
	unsigned int               nr_pages;             /*     4     4 */
	struct mem_cgroup *        cached;               /*     8     8 */
	struct obj_cgroup *        cached_objcg;         /*    16     8 */
	struct pglist_data *       cached_pgdat;         /*    24     8 */
	unsigned int               nr_bytes;             /*    32     4 */
	int                        nr_slab_reclaimable_b; /*    36     4 */
	int                        nr_slab_unreclaimable_b; /*    40     4 */

	/* size: 48, cachelines: 1, members: 8 */
	/* padding: 4 */
	/* last cacheline: 48 bytes */
};

The only accesses that will come from a remote cpu, and thus cause the cach=
eline
to bounce and the lock to be more expensive, are the ones from
drain_all_stock(). OTOH, on upstream, those accesses already modify the rem=
ote
cacheline with an atomic variable (memcg_stock_pcp.flags), so we are only
dealing with potential contention costs.

>=20
> Not to mention a potential contention which is hard to predict and it
> will depend on the specific runtime very much. So not something that
> would be easy to test for other than artificial testcases. Full cpu
> pcp draining is not a very common operation and one could argue that
> the problem will be limited=C2=A0
>=20

Yes, but we are exchanging an "always schedule_work_on()", which is a kind =
of
contention, for a "sometimes we hit spinlock contention".

For the spinlock proposal, on the local cpu side, the *worst case* contenti=
on
is:
1 - wait the spin_unlock() for a complete <percpu cache drain process>,
2 - wait a cache hit for local per-cpu cacheline=C2=A0

What is current implemented (schedule_work_on() approach), for the local
cpu=C2=A0side there is *always* this contention:
1 - wait for a context switch,
2 - wait a cache hit from it's local per-cpu cacheline,
3 - wait a complete <percpu cache drain process>,=C2=A0
4 - then for a new context switch to the current thread.

So moving from schedule_work_on() to spinlocks will save 2 context switches=
 per
cpu every time drain_all_stock() is called.

On the remote cpu side, my tests point that doing the remote draining is fa=
ster
than scheduling a local draining, so it's also a gain.

Also, IIUC the possible contention in the spinlock approach happens only on
page-faulting and syscalls, versus the schedule_work_on() approach that can
interrupt user workload at any time.=C2=A0

In fact, not interrupting the user workload in isolated cpus is just a bonu=
s of
using spinlocks.

> but so far I haven't really heard any strong
> arguments against the proposal to avoid scheduling the work on isolated
> cpus which is a much more simpler solution and achieves the same
> effect.

I understand the 'not scheduling work on isolated cpus' appeal: it's a much
simpler change, and will only affect cases with isolated cpus, so it is saf=
er
than changing the whole locking structure.=C2=A0

I am not against it. I already have a patch implementing it for testing, an=
d I
could gladly send it if you see fit.

But if nothing else, it introduces another specific case, and now it have t=
o
deal differently with local cpu, remote cpus, and isolated cpus.

With spinlocks, there is a much simpler solution:
- All cpus are dealt with the same way, which is faster in the local cpu (a=
s=C2=A0
  in upstream implementation).
- We don't have to avoid draining on isolated cpus.
- We get rid of the "work_struct", and scheduling costs
- We get rid of "flag", as we don't need to take care of multi-scheduling l=
ocal=C2=A0
  draining.
- When drain_all_stock() returns, all stock have already been drained, so=
=C2=A0
  retrying=C2=A0consume_stock() may have immediate results on pre-OOM cases=
.

On Wed, 2023-02-01 at 13:52 +0100, Michal Hocko wrote:
[...]
> Let me be clear here. Unless there are some real concerns about not
> flushing remotely on isolated cpus then the spin lock approach is just
> much less preferable. So I would much rather focus on the trivial patch
> and investigates whether there are no new corner cases to be created by
> that.

I understand 'not scheduling work on isolated cpus' approach should work wi=
th
low impact on current behavior, and I also understand that as Maintainers y=
ou
have to consider many more factors than a regular developer like me, and al=
so
that the spinlock approach is a big change on how pcp memcg caches work.=
=20

On that topic, if there is any comparison test you find important running, =
or
any topic you think could be better discussed, please let me know.

Thank you for reviewing,
Leo


