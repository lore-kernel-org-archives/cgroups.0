From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: use rstat for non-hierarchical stats
Date: Tue, 25 Jul 2023 16:18:11 -0400
Message-ID: <20230725201811.GA1231514@cmpxchg.org>
References: <20230719174613.3062124-1-yosryahmed@google.com>
 <20230725140435.GB1146582@cmpxchg.org>
 <CAJD7tkaYHvaX6SL=A6TsCQHT+rOTp-WhOiQ1XSN+ywOVN=-QBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1690316292; x=1690921092;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GPWJuz8CAEYamZihAR0z0R2Kk0EYNWObLkeGgE8Dn0I=;
        b=4NE+YvybWo/g6VcPhh2fy5ZBIK2nXfKjbHIrelje0rqNy4LW0kZXKWbe7Y2Hh0eV/+
         +29ZM018tyUHpbJ4C4PuCBigcTNasPOzQHAnf04mtPxhxxg6kZ0gJiDnhivJEwankALK
         Uovby1CLPABNOOd4W4KiaeQFPHLCgi3Gpiw906LZwfCzGIdW1NApq0YZi+a20oDjVXjo
         e0L44dr1itRsFRxkSm9aFcTI6KXhxJgoxLav3p6wpGjpgrSRmF/B/8GWhfn5iB6LDyS0
         LE5qridIH3lSWZ8zIzT48HV1vyaKIVKi+EwTw1xThMN4P53tGMwX6Z1N7miPOfUZsntY
         M2zw==
Content-Disposition: inline
In-Reply-To: <CAJD7tkaYHvaX6SL=A6TsCQHT+rOTp-WhOiQ1XSN+ywOVN=-QBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jul 25, 2023 at 12:24:19PM -0700, Yosry Ahmed wrote:
> On Tue, Jul 25, 2023 at 7:04=E2=80=AFAM Johannes Weiner <hannes-druUgvl0L=
CNAfugRpC6u6w@public.gmane.org> wrote:
> > We used to maintain *all* stats in per-cpu counters at the local
> > level. memory.stat reads would have to iterate and aggregate the
> > entire subtree every time. This was obviously very costly, so we added
> > batched upward propagation during stat updates to simplify reads:
> >
> > commit 42a300353577ccc17ecc627b8570a89fa1678bec
> > Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date:   Tue May 14 15:47:12 2019 -0700
> >
> >     mm: memcontrol: fix recursive statistics correctness & scalabilty
> >
> > However, that caused a regression in the stat write path, as the
> > upward propagation would bottleneck on the cachelines in the shared
> > parents. The fix for *that* re-introduced the per-cpu loops in the
> > local stat reads:
> >
> > commit 815744d75152078cde5391fc1e3c2d4424323fb6
> > Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date:   Thu Jun 13 15:55:46 2019 -0700
> >
> >     mm: memcontrol: don't batch updates of local VM stats and events
> >
> > So I wouldn't say it's a regression from rstat. Except for that short
> > period between the two commits above, the read side for local stats
> > was always expensive.
>=20
> I was comparing from an 4.15 kernel, so I assumed the major change was
> from rstat, but that was not accurate. Thanks for the history.
>=20
> However, in that 4.15 kernel the local (non-hierarchical) stats were
> readily available without iterating percpu counters. There is a
> regression that was introduced somewhere.
>=20
> Looking at the history you described, it seems like up until
> 815744d75152 we used to maintain "local" (aka non-hierarchical)
> counters, so reading local stats was reading one counter, and starting
> 815744d75152 we started having to loop percpu counters for that.
>=20
> So it is not a regression of rstat, but seemingly it is a regression
> of 815744d75152. Is my understanding incorrect?

Yes, it actually goes back further. Bear with me.

For the longest time, it used to be local per-cpu counters. Every
memory.stat read had to do nr_memcg * nr_cpu aggregation. You can
imagine that this didn't scale in production.

We added local atomics and turned the per-cpu counters into buffers:

commit a983b5ebee57209c99f68c8327072f25e0e6e3da
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Wed Jan 31 16:16:45 2018 -0800

    mm: memcontrol: fix excessive complexity in memory.stat reporting

Local counts became a simple atomic_read(), but the hierarchy counts
would still have to aggregate nr_memcg counters.

That was of course still too much read-side complexity, so we switched
to batched upward propagation during the stat updates:

commit 42a300353577ccc17ecc627b8570a89fa1678bec
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Tue May 14 15:47:12 2019 -0700

    mm: memcontrol: fix recursive statistics correctness & scalabilty

This gave us two atomics at each level: one for local and one for
hierarchical stats.

However, that went too far the other direction: too many counters
touched during stat updates, and we got a regression report over memcg
cacheline contention during MM workloads. Instead of backing out
42a300353 - since all the previous versions were terrible too - we
dropped write-side aggregation of *only* the local counters:

commit 815744d75152078cde5391fc1e3c2d4424323fb6
Author: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date:   Thu Jun 13 15:55:46 2019 -0700

    mm: memcontrol: don't batch updates of local VM stats and events

In effect, this kept all the stat optimizations for cgroup2 (which
doesn't have local counters), and reverted cgroup1 back to how it was
for the longest time: on-demand aggregated per-cpu counters.

For about a year, cgroup1 didn't have to per-cpu the local stats on
read. But for the recursive stats, it would either still have to do
subtree aggregation on read, or too much upward flushing on write.

So if I had to blame one commit for a cgroup1 regression, it would
probably be 815744d. But it's kind of a stretch to say that it worked
well before that commit.

For the changelog, maybe just say that there was a lot of back and
forth between read-side aggregation and write-side aggregation. Since
with rstat we now have efficient read-side aggregation, attempt a
conceptual revert of 815744d.

> > But I want to be clear: this isn't a regression fix. It's a new
> > performance optimization for the deprecated cgroup1 code. And it comes
> > at the cost of higher memory footprint for both cgroup1 AND cgroup2.
>=20
> I still think it is, but I can easily be wrong. I am hoping that the
> memory footprint is not a problem. There are *roughly* 80 per-memcg
> stats/events (MEMCG_NR_STAT + NR_MEMCG_EVENTS) and 55 per-lruvec stats
> (NR_VM_NODE_STAT_ITEMS). For each stat there is an extra 8 bytes, so
> on a two-node machine that's  8 * (80 + 55 * 2) ~=3D 1.5 KiB per memcg.
>=20
> Given that struct mem_cgroup is already large, and can easily be 100s
> of KiBs on a large machine with many cpus, I hope there won't be a
> noticeable regression.

Yes, the concern wasn't so much the memory consumption but the
cachelines touched during hot paths.

However, that was mostly because we either had a) write-side flushing,
which is extremely hot during MM stress, or b) read-side flushing with
huuuge cgroup subtrees due to zombie cgroups. A small cacheline
difference would be enormously amplified by these factors.

Rstat is very good at doing selective subtree flushing on reads, so
the big coefficients from a) and b) are no longer such a big concern.
A slightly bigger cache footprint is probably going to be okay.
