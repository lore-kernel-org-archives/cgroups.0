Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B563EC2EF
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787078440; cv=none; b=Da/5ZiatUOZ3IdU8vxSOv6S77oXibpztE8SsbRSeAp1HColjOgAA8FeBklVpEIYZMOEPAqpzRpew8DyYcJoIKCR4lRoUde7soWoUCcXYFDKOo4OrC25XZ+qgf1fNeVqp3gCPMh7aN5IyHce8y0K2fmAhEs4I5u6tLsaPnqx1LjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787078440; c=relaxed/simple;
	bh=ZE5+6QrhQgi0WQlXf807LxaLxRdPddcD5KNpfJRWiCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GXOA2kZNjlShJUWRb6KXynRAsfoywjYS/OCfea5g/cknwZVfctp1MWPamg0jTEHelYVDOkvi9DPN2V+in4y3X8DzFJz+Vq0hZcPwnj0JY61rjnA2Vj7B/vWGXhoOyGDGLeLe5f1nJv4Ai/iZ6ZQj4wnb69XLHERw+SUBtYDLXYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gxo2dy9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gxo2dy9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859BA1F00A3A
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787078437;
	bh=ny3XfJw5AppvIZCDXFSTRJl6zICfUFbpvldeep36UPQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Gxo2dy9i+r9hMkx4kXWc3gktO/h6sygr3MqxCShm2PUAKqgro78w65IZ9rJErhTDd
	 mTJnTV362z9LZ+RA85FOQ2zL0HMWfeS/e10WuK2U0u3Z7ldKsHiPfTiXArsChaLbp6
	 sTl8V/iaCsF8lD+dI7XbReDvP/kjO624/3Bo7wGBKgr3uU09fWxJweFTcuFn07Xad6
	 lsgZoZFBYA5lAkMWNkdsSE3seXNWMpQkooUQlA2M3SmGoxYzCV5oQlQLm78YCEvZcb
	 kctcvvms/EzCQo3PEnajZYc3dcDMOnr20bCVWu1ZyBof57sh99gqp0tU0HMrL5gGSN
	 bgw7TuI0U44AQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15c42a45adso199363266b.0
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 11:40:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrS+ml3TLc0YunVRTyuA/rst+d4noSUVUs5UfqG9nlnac7Qfkt4ZHlVU1pG9i9TUaglRjDqvFPj@vger.kernel.org
X-Gm-Message-State: AOJu0YwLuxRJRbqz1tn7rXQwJdoFC2OsMhYKnjJyjeOlnDhqSBepkyRy
	zZbnsm39vUALEjnFNUeQxi9IXdi1X8moQ3A3b2pcq/GUG6kkAWRuojmA0OI19FD6Th01ClKvzfQ
	qmgjMstsN+dPpDEspgdjGtWReOHp5zhU=
X-Received: by 2002:a17:907:a68a:b0:c21:4698:ee9e with SMTP id
 a640c23a62f3a-c22297f3440mr23803966b.7.1787078436420; Tue, 18 Aug 2026
 11:40:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
In-Reply-To: <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 18 Aug 2026 11:40:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
X-Gm-Features: AcwNN1X1aov6WUElnPNE-Id7S1ebr1jq7bpiqptm-nHaxscbWcI6WEioZMaqF7I
Message-ID: <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 1:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > >
> > > > On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@g=
mail.com> wrote:
> > > > >
> > > > > I'm not too familiar with memcg or vmstat so apologies if this is=
 a
> > > > > naive question, but does it make sense for memcg to just do a sim=
ilar
> > > > > approach to what vmstat does? As I understand it, mod_lruvec_stat=
e()
> > > > > updates the node counter and the memcg counter (if memcg applies)=
,
> > > > > where for updating the node counter, mod_node_state() does some
> > > > > batching where it updates the global counter for that stat only o=
nce
> > > > > it crosses some threshold (pcp->stat_threshold). Could memcg keep=
 its
> > > > > per-CPU counter as the accumulator but once it reaches some thres=
hold,
> > > > > it then propagates it up the parent/ancestors into a per-memcg at=
omic
> > > > > global counter? The atomic would then only have to be touched onc=
e per
> > > > > batch than on every update, which might eliminate the overhead of=
 the
> > > > > per-memcg atomic you saw previously? It seems like this would get=
 rid
> > > > > of needing to do any flushing altogether, as we could just read t=
hat
> > > > > global counter directly.
> > > >
> > > > The memcg stats perform similar per-CPU counting and thresholding. =
The
> > > > main difference from vmstat AFAICT is the cgroup hierarchy. In vmst=
at
> > > > we have per-CPU counters and a global atomic counter for each stat.
> > > > For memcg, we have the same for each cgroup, then we also have a
> > > > cgroup tree. When we read the stats of a cgroup, we usually want th=
e
> > > > hierarchical stats including all of its children, so we can't just
> > > > read the global counter.
> > > >
> > > > We use rstat, a cgroup framework that keeps track of which cgroups
> > > > have updates on which CPUs, and then memcg has thresholding logic o=
n
> > > > top to only flush if the number of pending updates exceeds a
> > > > threshold. Essentially, if the magnitude updates on a CPU exceeds
> > > > MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We onl=
y
> > > > flush if that global per-memcg counter has > NR_CPUS *
> > > > MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to =
2 *
> > > > NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
> > > > stats).
> > > >
> > > > See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this =
logic.
> > > >
> > > > Looking at this code again, it made me realize that we already iter=
ate
> > > > the per-CPU stats_updates on every update to increment the number o=
f
> > > > pending stats on this CPU. I wonder if we can replace this with
> > > > actually updating the stat on each parent, then the flush path only
> > > > needs to accumulate CPU counters. Or maybe as you mention, we updat=
e
> > > > the global per-memcg counter when updates on a CPU exceed a thresho=
ld,
> > > > and forgo the rstat flushing logic completely.
> > > >
> > >
> > > I can run some experiments and see if updating the global per-memcg
> > > counter per batch and forgoing flushing could be a viable solution.
> > > I can use my setup to test it for writeback, but for the zswap use
> > > case, what's the best way to test if the changes are too expensive? I=
s
> > > there a benchmark program you're running?
> >
> > I was running stress-ng and measuring the latency of zswap_load() and
> > zswap_store() with bpftrace. But I suspect whatever works for writeback
> > should work for zswap :)
> >
> > >
> > > For updating the stat on each parent and having the flush path only
> > > accumulate CPU counters, I think this means we would have to
> > > unconditionally walk the ancestors + update its counters on every
> > > update, as we wouldn't be able to early break if the flushable
> > > threshold was already exceeded. I don't think we could replace the
> > > stats_update update, as it seems like readers still need some way of
> > > knowing when to flush. It seems like this could be a nontrivial
> > > performance hit, but maybe it's a non-factor in reality. If you think
> > > this would be useful to get benchmark numbers on, I can run some
> > > experiments on this too.
> >
> > I think we need to experiment with how much work we can shift around
> > between the update and reader sides.
> >
> > Right now, on the update side, we call __css_rstat_updated(), which
> > iterates the parents and puts them on the per-CPU rstat tree, then we
> > iterate the parents again in memcg_rstat_updated() and:
> > - Check if flushing threshold is already met.
> > - Update per-CPU counter for stats_updates.
> > - If per-CPU update exceeds (another) threshold, we update an atomic fo=
r
> >   stats_updates.
> >
> > The flush side checks the flushing threshold and does an rstat flush,
> > which will walk the update trees on all CPUs and iterates all child
> > cgroups on it. Pretty expensive when the threshold is met.
> >
> > I think we discussed two different options:
> >
> > (a) On stats updates, iterate the parents and update the per-CPU
> > counters of the stat directly.
> >
> > In this case, we can't keep using rstat, as we would still need to add
> > the cgroup and all its ancestors to the update tree anyway and the flus=
h
> > cost will remain similar. So on the flush path we'll need to iterate al=
l
> > CPUs and add the counters. We can explore if use a cpumask can help
> > here, but perhaps not since we'll need to update it atomically on all
> > stat updates.
> >
> > I imagine that if we do this we'll drop the stats_updates optimization
> > to avoid adding more cost to the update side. We'll be replacing parent
> > stats_updates modification with parent stat counter modification. But
> > maybe it's feasible to keep both to limit the cost of flusing.
> >
> > This only works if the cost of iterate the CPUs on the flush side ends
> > up being cheaper than the current flush. I imagine the average cost wil=
l
> > be higher but the cost should be much more consistent vs the current
> > flush, so the tail should be better.
> >
> > (b) On stats updates, iterate the parents and update the per-CPU
> > counters of the stat directly AND update a global atomic if the per-CPU
> > counter exceeds a threshold. I think updates may get too expensive as w=
e
> > may need to update multiple atomics, especially when updating the root
> > counter as it will be contended by all cgroups.
> >
> > The flush side becomes an atomic read, so should be very cheap, and we
> > can drop other heuristics and optimizations.
> >
> > ---
> >
> > I think ultimately we need to experiment with these approachs (and
> > perhaps others) to check what actually works in practice. You'll
> > probably want some benchmarks or synthetic tests with many cgroups to
> > exercise the worst case scenarios.
> >
> > For the zswap stats, I used to run stress-ng with a bunch of workers
> > (20, 50, 100, ..) in cgroups of different levels. Since all workers are
> > in the same cgroups, all the parents are common and all threads end up
> > competing on the same atomics, so worst case scenario. I was also
> > testing in a VM that has more CPUs than stress-ng workers, to exercise
> > the full extent of the concurrency and contention.
> >
> > This could be a lot of work, so I am not really asking you to do it, bu=
t
> > just brainstorming and sharing ideas :)
>
> Thanks for your guidance and insights on this, Yosry! Your responses
> have been very helpful.
>
> I'll do some experimentation with this and try to get a sense of what
> the update costs are.

Looking forward to that!

>
> One thing I was unclear about and have been looking at is how
> pervasive/important this issue is outside of the writeback case. It
> looks like there are roughly 4 other categories of users that rely on
> stats that can be 2s stale: zswap, cachestat(), working set, and
> vmscan.
>
> Of these, vmscan is the only one that looks troublesome. Some armchair
> analysis below:
>
> a) zswap (zswap_shrinker_count()): 2s of staleness looks fine. the
> stats are only used to calculate the compression ratio and the ratio
> scales a count that comes from a list_lru and *isn't* stale. The ratio
> is an average over the whole pool, so it seems like that should be
> fairly steady across 2s. A stale result doesn't seem too bad - afaict,
> it is a heuristic of how zswap should get weighed against the other
> shrinkers.

There is also the zswap limits calculation, which Song sent a patch to
change to using ratelimited flushing. I think that case is more
problematic as it can cause OOM kills if we use stale stats (e.g.
after a burst of writeback frees up space in zswap). Adding Song here.

The shrinker case is more benign.

>
> b) cachestat() syscall (filemap_cachestat()): seems preferable to just
> rely on the 2s flusher worker. The results are returned back to
> userspace and not used for any internal kernel decision-making, seems
> ok to have one field in it (nr_recently_evicted) potentially be stale.
> Seems better to err on the side of less frequent flushing anyways, as
> the call path is invoked from unprivileged userspace and flushes the
> root memcg.

I am not sure how the cachestat() syscall is used, but my preference
would be to treat it like memory.stat and do a full flush on userspace
read, unless it's a syscall that is invoked frequently for some
reason.

>
> c) workingset: looking at the original commits, the calculations are
> estimates that don't require exact stats -
>
> refaulting (workingset_test_recent()): commit 9b3016154c91 ("memcg:
> sync flush only if periodic flush is delayed")
>     Now the question: what are the side-effects of this change? The worst
>     that can happen is the refault codepath will see 4sec old lruvec stat=
s
>     and may cause false (or missed) activations of the refaulted page whi=
ch
>     may under-or-overestimate the workingset size.  Though that is not ve=
ry
>     concerning as the kernel can already miss or do false activations.

Incorrect activations can lead to thrashing in some cases, but I am
not sure how practical the concern is.

>
> shadow-node shrinker (count_shadow_nodes()): commit d4a5b369ad6d ("mm:
> ratelimit stat flush from workingset shrinker")
>     On further inspection it seems like we don't really need
>     accurate stats in this function as it was already approximating the a=
mount
>     of appropriate shadow entries to keep for maintaining the refault
>     information.
>
> d) vmscan (prepare_scan_control()): for determining whether reclaim
> can deactivate, there's this logic
>
>                 /*
>                  * When refaults are being observed, it means a new
>                  * workingset is being established. Deactivate to get
>                  * rid of any stale active pages quickly.
>                  */
>                 refaults =3D lruvec_page_state(target_lruvec,
>                                 WORKINGSET_ACTIVATE_ANON);
>                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_ANON=
] ||
>                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANON)=
)
>                         sc->may_deactivate |=3D DEACTIVATE_ANON;
>                 else
>                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
>
> (and same for DEACTIVATE_FILE for file-backed folios)
>
> target_lruvec->refaults[] gets set at the end of the reclaim pass. It
> stores the same lruvec_page_state() value that prepare_scan_control()
> will read at the start of the next reclaim pass, which means if
> reclaim passes happen more frequently than the 2s flushes (eg under
> sustained/heavy memory pressure), this logic will incorrectly assume
> no refaults occurred and deactivation is disabled, which afaict means
> folios won't be moved from the active -> inactive list, and reclaim
> will start evicting pages from the inactive list that are hot (eg more
> refaults).
>
> This is from reading the code rather than a reproducer though, so I
> don't know how much this matters in practice. Unlike for the writeback
> case, I don't think flushign more frequently solves the problem. It
> would shrink the staleness window but not eliminate it. Maybe one
> solution is to keep the deactivation state for a period of time if
> refaults were observed.

We do have an internal test that runs a VM under memory pressure and
we started observing OOM kills after the ratelimited flush was added
in vmscan, so I think it's more problematic than just reclaiming hot
memory, but I didn't look too closely.

>
> If it turns out iterating the parents and updating the per-CPU
> counters of the stat on updates is too expensive, perhaps it makes
> sense to keep the existing rstat logic as is and have caller-side
> workarounds, as only writeback and vmscan would require them.

Also zswap limits calculation. I am not sure how benign the workingset
case is, but it has been ratelimited for a while now AFAICT, so maybe
it's fine.

>
> Thanks,
> Joanne
