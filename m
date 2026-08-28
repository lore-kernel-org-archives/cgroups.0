Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42443DA7C2
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787923046; cv=none; b=mtQMDpk1jmZ5lrqFvwp5ylcOGnR+kLE7qiqEGxgyWBmf6OiuKtnmJ05eoRY9ftp4if3OeEkIPd4I1mETsdU4YwOtI7+cGeO9WHuZSD8NaTtpm56NGjGd3wfC5vUX75aX52Nfcs+dJzJTBC2XTO0qbzFDu7X5dij325A2HKNIBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787923046; c=relaxed/simple;
	bh=mvGL/Z6C0Re6DrFrYesxk/Q4uufXmrCFIKM47XXYy2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EWeMap7Zn8OVBZohRp3DwLrZfGdOg96Jlm+Te4f+6VIInnReNx7F/5ASH+dk6ww3cZfkSfrLJiknDG+XRrEwPuj9nHMIzBNlCkriIQ18rCqGCcRa5DJjDO8GO4ThPg5QSa2n5LGOht2WBeQN2u2CZUBclmrhajaDoFbdn77Ubqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyvuhnKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyvuhnKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D791F00A3A
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787923042;
	bh=LXWsySxCAhI2eKubAnh1Qok8EJGkZG2y63EPSSYhj5I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UyvuhnKPSnuQrqsbE0ARAQuwBiMkIN3fyqBNebM7kEVUZIU+wqErq/AqQZfMk8SzO
	 m4MqzXjL80cjVyZgIrb2uo3znrd3Mg6bYTMnTr2vzEvoA+6cJeBS6qL6ZJ03i8u7zc
	 g6H5KCKAlmiqdPt8gsGB/01eFfOHrbctWP6cB+0YZzV7uYwD9lMBTJMm/nI2ui2B1X
	 F+sUj8UzR+Hv+Th48BEHmpe+NccUbhoinPDmu3EMYkqmGHKkTZfDPPfzUf9nWYsZOm
	 PrummRw8x6PeVhNHqxEvZsOUS8R0NDAVMziEKWNneSuSjpNV0dM0sTRGYhMMtLAugh
	 kEl9ZyrXNW3iQ==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso1380058a12.3
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 06:17:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpi4VtT/TIftbYi2qJYNrkN2PiTyYfKDz44tRbzeB3xcD5lgZC6AOiZNAfZ4WAEoj8KD7C5jcTK@vger.kernel.org
X-Gm-Message-State: AFuF++mFzQTfl0tb8CPG1a0zHE9Kh4rzcgq9tumh9hUZDhmLk8jatDEh
	nRPqK21V5OIKfLWOiRp+b+5ff7dVWvKa3GoXzWSX43aSjCVF8Q/3OKrWmEaL9fAlroWtiLj5Rlv
	TszUZQZFvihhRH/3U7QOA9yYr35BYb3w=
X-Received: by 2002:a17:907:9813:b0:c24:e1e9:69c with SMTP id
 a640c23a62f3a-c255667b63dmr416435066b.0.1787923040778; Fri, 28 Aug 2026
 06:17:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1b5asARJ_g176DsoNCvf+iFqzPbOtVveeuPxTPZDmnuKw@mail.gmail.com>
 <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com> <CAJnrk1YO5E6ETxn9RmM-LWRQSRxwF9iEakAPz6veMPjaKMAEOQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YO5E6ETxn9RmM-LWRQSRxwF9iEakAPz6veMPjaKMAEOQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 28 Aug 2026 06:17:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPErbULcVTzk8GGS8w=6d-Qn10rLSkSOEzrO++Vhx7+Dw@mail.gmail.com>
X-Gm-Features: AcwNN1VqPOz4jQ794_KmrH9eGNa1-pCCTewSGBGtIJmecacOEyoNdreux6MHngs
Message-ID: <CAO9r8zPErbULcVTzk8GGS8w=6d-Qn10rLSkSOEzrO++Vhx7+Dw@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"

> > > These are the results I'm seeing from the benchmarks. I'm comparing
> > > non-ratelimited rstat vs (a) vs (b). I'm comparing non-ratelimited
> > > rstat instead of ratelimited rstat, because ratelimited rstat relies
> > > on the 2s flusher and doesn't incur any additional flushing when
> > > called.
> > >
> > > ~On the update side~
> > > ns per update (measured by having a kthread pinned to each CPU and all
> > > threads updating the same cgroup for a 200ms window, run on 80 CPUs,
> > > computed as total CPU time / # updates)
> > > depth      rstat      (a)         (b)
> > >     1        22.34       32.49      60.10
> > >     8        22.46       47.12      140.72
> > >     16      22.49       70.96      206.39
> > >     32      22.51       139.16    305.40
> >
> > There goes my dream if an rstat-free world :')
> >
> > I am very surprised though that you care about hierarchies this deep.
> > I don't think we have anything close to even 8 at Google, and in all
> > my previous testing I usually test up to 4 or 5 levels. I suspect at
>
> At Meta, we often see depths 8 to 16.

Interesting :)

> > that level the difference might be acceptable. But aren't other
> > operations also really expensive at that depth? I imagine the charging
> > path is really slow if it has to do atomic updates for 32 parents. Is
>
> I agree. This aligns with what I saw when running the page counter
> approach for zwap on depth 32. For the writeback path though, the
> dirtying / writeback folio lifecycle is just stat updates. There's a
> charge, but that happens only once, when the folio enters the page
> cache.

FWIW, when I added the per-memcg thresholding for flush (i.e.
stats_updates), there were some regressions in some microbenchmarks on
the update side due to the parent iteration in deep hierarchies.
However, we decided the regressions were acceptable because they were
of low significance compared to the extra of charging/uncharging in
those deep hierarchies. As you said, charges are not 1:1 to stat
updates, but it was considered a general indicator of acceptable
performance for the workload at that depth. That is all obviously very
hand wavy :)

> > the update path really a problem given everything else?
> >
> > Given the constant cost of rstat updates, it also seems like
> > memcg_vmstats_needs_flush() is mostly evaluating to true and skipping
> > the parent walk. I wonder how much this remains true in practice, I
> > think Shakeel mentioned that it does help in production.
>
> I think for the writeback path, this is probably often encountered in
> practice, since the threshold is 64 * nr_cpus and any sustained write
> would cross that quickly. It would matter most with order-0 folios
> since there's 4 updates incurred per folio independent of folio size.

Makes sense.

> > > (a) and (b) perform worse on higher memcg depths, whereas rstat is
> > > unaffected by depth level, which makes sense given that (a) and (b)
> > > can't break early if the flushable threshold has already been
> > > exceeded.
> > >
> > > ~On the flush side~
> > > ns per flush call (measured at leaf of memcg chain, ie best scenario
> > > for rstat, # CPUs on the system is 80)
> > >   rstat                      10165.60 ns   (min 9924)
> > >     (a)                       734.10 ns
> > >     (b)                        4.79 ns
> > >
> > > (a) is around 14x cheaper than an rstat flush, which I think is
> > > because the rstat flush goes through every stat, even ones that are
> > > not directly relevant.
> >
> > I think that's only part of the story. rstat iterates all children
> > cgroups as well. I think reading multiple contiguous stats may
> > actually be really cheap since they are likely in the same cacheline.
>
> In that benchmark, the flush cost was measured at the leaf of the
> memcg chain, so I don't think there were any children to iterate here.
> Maybe some of it is attributed to the rstat locking? I'm not too sure.
>
> >
> > >
> > > Using some napkin math, I think the breakeven point for (a) is around:
> > >                       updates per read
> > > depth 1             ~900
> > > depth 8             ~380
> > > depth 32           ~80
> > >
> > > eg for depth 1:  (10165.60 - 734.10) / (32.49 -  22.34)
> > >
> > > This is assuming one read per flush, which is what (a) and (b) would
> > > necessarily have to pay, whereas rstat only needs to flush when the #
> > > of stats updates exceeds the MEMCG_CHARGE_BATCH * nr_cpus threshold,
> > > so the updates per read numbers above are in reality lower.
> > >
> > > Running a fio write job and using tracepoints to count # of stat
> > > updates, # of reads of those stats, and how many of those reads flush,
> > > I'm seeing:
> > >                      updates/s              reads/s
> > > flushes/s         updates per read
> > > bs=1M            643                           119                 45
> > >                        5
> > > bs=4k            156,415                     123                 58
> > >                      1267
> > >
> > > For larger folio sizes, (a) is cheaper for writeback (since there are
> > > 4 update events *per folio* in the dirtying/writeback lifecycle) but
> > > for smaller folio sizes (eg order 0 folios), (a) is worse, as a lot
> > > more updates are incurred, and the performance is worse the deeper the
> > > memcg is nested.
> >
> > Hmm interesting analysis, but I actually think a more interesting one
> > is the effect of the update latency in respective update paths. For
> > example, in the zswap_store() case you analyzed earlier, it ends up
> > being in the noise. I would check what the hottest update paths are
> > (probably networking?) and check what the update paths are, to check
> > if they are really sensitive to the increased update cost. It could be
> > the case that at least stats that are used by in-kernel flushers do
> > not really care about the extra update cost.
>
> Extrapolating a bit from the synthetic benchmarks, at depth 8, I think
> the extra overhead incurred on an update comes out to roughly around
> 25ns, and at depth 16, around 48ns. I haven't looked at the networking
> path, but the lru path (__update_lru_size()) looks concerning, as it
> would have that extra overhead while holding the lru lock, which "is
> already a heavy contention point on memory-heavy workloads" [1]. As I
> understand it, reclaim, compaction, and the page cache path all
> serialize on that lock.

Yeah it could be a problem, but I think we won't know for sure until
we run a reclaim-heavy workload (e.g. build the kernel in a constraint
cgroup) and check for actual regressions. I am often surprised by what
actually shows up (or doesn't) in higher-level workloads.

>
> If we were to move all the callers off rstat, I think this also would
> unfortunately make the walk more expensive. As I understand it, each
> stat would be a per-cpu counter which would be added to the
> memcg_vmstats_percpu struct, and that would have to spill onto
> multiple cachelines. Or maybe I'm missing something here and there
> would be a better way to do it.

Yeah. I count 54 stats, with 8 bytes per counter that's ~7 cachelines
(on x86_64). I can see that being really expensive, but I can also see
it disappear into the noise if the stats updated together live in
close cachelines and the CPU prefetches surrounding cachelines.

> > > I also ran some experiments with Jan's suggestion of scaling the flush
> > > threshold to the memcg's limit rather than to the number of cpus. It
> > > helps the overshoot we saw and slightly outperforms doing a plain
> > > non-ratelimited flush (100% of dirty limit vs 101% on a 1G memcg, 103%
> > > vs 107% on a 256M memcg) but led to ~2.4x more flushes.
> > >
> > > The initial reason we switched to the ratelimited version of the flush
> > > was because flushing was expensive, but I'm not sure if flushing is as
> > > expensive as it used to be. Testing the non-ratelimited version, the
> > > flushes account for about 0.9% of the system CPU the write path
> > > already spends, and I didn't see any throughput difference between the
> > > two (249-252 MB/s either way), on a 32G memcg. With the
> > > non-ratelimited version, it's also not a flush per read - it's still
> > > "ratelimited" by number of updates that have elapsed since the last
> > > flush (only flushing if stats_updates >= MEMCG_CHARGE_BATCH * nr_cpus)
> > > which means concurrent writers writing back at the same time will
> > > "share" flushes rather than triggering their own.
> >
> > Yup, this is exactly what I mean. This is a good analysis for the cost
> > of the flush: how much it matters end-to-end. Even though the full
> > flush is 14x more expensive according to your numbers, it seems like
> > it ultimately doesn't affect performance much. I would do the same for
> > the update paths, see if the extra cost really matters. WDYT?
>
> imo ideally it would be great to minimize any overhead we can where if
> we don't need the precision for a certain stat, then it would be
> preferable to not incur any extra overhead for it on updates if the
> overhead saved on reads doesn't justify it. In the grand scheme of
> things though, I think in most cases, the extra overhead/latency isn't
> really discernible except at high depths and except for the lock
> contention issue mentioned above.

Right. I am just trying to avoid the complexity of having two update
schemes if we can help it. If we can move everything to a new "better"
scheme, that would be great. But it might be the case that we have to
have a different scheme just for stats where the current update/read
tradeoff doesn't make sense.

> I don't really have an issue with rstat for cases like writeback where
> we're not doing a lot of reads compared to updates,

I don't remember why ratelimiting was added, but I suspect for cases
with large trees, high number of CPUs, and/or high cgroup lock
contention -- the cost of a normal flush could get really high. Back
in the day when we used to always flush the entire tree (before
per-memcg thresholding), we ran into hard lockups for flushes taking
>10s with irqs off (we had atomic flushing back then).

>  but I think we do
> need to get rid of the rstat rate-limiting, as it seems so arbitrary
> to rely on two seconds for stats being updated. Bounding it by time
> and not stats_updates feels wrong. Even in the cases where precision
> doesn't matter, it seems better to give those callers a higher stats
> updates threshold depending on how much error they can tolerate, than
> to rely on a blanket 2 seconds.

100% agreed. I never liked the ratelimited flush tbh. I think we
practically end up just not flushing in most cases (but I never really
checked), so it's just a way to feel good about skipping a flush :P

> > > In light of the above, imo it seems to make the most sense to just do
> > > the plain non-ratelimited flush for mem_cgroup_wb_stats() and make the
> > > flushing magnitude bound again, wh ich also aligns with what the
> > > global non-memcg domain does. The question is whether the extra flush
> > > cost is acceptable, but the numbers above make me think it is.
> >
> > If we can eat the cost of the flush here that's great, but I think we
> > can't say the same for the vmscan and zswap paths (at least)? :/
>
> I haven't tried out the vmscan repro or run any benchmarks on that
> path, but the logic in vmscan seems weird to me, as it will always
> conclude that there were no refaults whenever reclaim scans faster
> than the refaults counter advances (which I think would be most of the
> time under memory pressure). I'm thinking maybe we could do something
> similar to what Usama did in [1] where we fold the refault delta into
> a per-lruvec accumulator and let it decay. I'm planning to look more
> into this and will follow up then.

Looking forward to it.

> For the zswap path, it's still a bit unclear to me whether exactness
> is necessary or whether the 64 * nr_cpus error tolerance is
> acceptable. If that error tolerance is acceptable, I think it makes
> sense to use the non-ratelimited version of rstat with no forced
> flushing, given that reads are supposed to be rare since rarely
> anybody (from what I understand) in practice sets zswap.max. Quick
> benchmarks at depth=4 with zswap.max set at every level, 20 workers on
> 80 cpus:  rstat forced = ~7,600 stores/s, rstat unforced = ~300k
> stores/s, and hierarchical per-cpu counters = ~440k stores/s. The
> hierarchical per-cpu counters outperforms rstat unforced on the stores
> given that it removes the flush, but we already see massive
> improvements from using rstat unforced over rstat forced.

I would like to avoid the ratelimited flush for the limit checking for
the same reasons discussed above. I think we were all under the
assumption that the limit is rarely set in practice (other than 0 or
max), until we saw [*].

[*]https://lore.kernel.org/linux-mm/20260817131843.45121-1-husong@kylinos.cn/.

>
> Thanks,
> Joanne
>
> [1] https://lore.kernel.org/linux-mm/20260727162550.2032-4-usama.arif@linux.dev/
>
> >
> > >
> > > Thanks,
> > > Joanne
