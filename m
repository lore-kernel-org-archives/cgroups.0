Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BE730675F
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787878289; cv=pass; b=WFN0HRnnmq+Cv5/HM/Mjo9LL1u8nqMPKcGrq5RVp3V7o/30W9H3Fot6oOE7ucsPzLEj3tOtqGCgNoGOE2IuJcobjI4c9yGsuuGGOtYl9GTlyGdXpjK2m1EpHOFnVc2BhRVek+qs31PPJw4RgSeMLBU7MDoxqiebCt8a+zCO3kY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787878289; c=relaxed/simple;
	bh=GvJsJ/eFudJf0eI/X49HSY8V2nlAY10M2MDmFs2ksyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GuSsMzXkxP5JW2Ca6TQHvJ6Dlw8ZCwq0QKYB6hJNPtFC/FtFNqsECVuO8+AZuex93aCqlzWfV6TBuL7zxSFV/M+4lXdEA/vphJ/JQIGP5zak6v5R4QBswYVjKSDWVfSrKADBpWSgW2C9Kge4BExeS5aw2RajJ06CfyRojXEIa/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f30/ysUb; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f30/ysUb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49557167508so3743575e9.1
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 17:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787878285; cv=none;
        d=google.com; s=arc-20260327;
        b=NEa+b9sowEjM+jr3mcANeYEsVx5Crmr/7OgwexRzFF+HCktRixpUYwC388oHL8upmC
         znLoJeXuUW7gm1ePdZjg/dJQ019byscNu0o2USW6jIyPzkZzf9yUcKrbORZgqoTDr8ae
         LyG7CvyhnYKQCC5g9mYDUSgnNlBw7IzFIZAzRb7PyIvfC2pFlUyKuxARVRm2XbWfpRy0
         w7k1JaXIRVhdkQ8/7JLx3j26JRFdIxxosaCTtKpK2NYtSFnvJk5JsQpr41aeO+9CIWk9
         CmEKWwg+Vnk+1pcM/FYh/S0gHfpYK7mWNJolqpMTabqqJMEzgPOZGXOG9e1ikSBi+yxK
         JE+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        fh=97s1VMyuyZ4lZeyTeunbuKwGAFIpDuG9ajisoUkXWTc=;
        b=ewmDScYoO4vZgwxoHoi0N/O6SPXCw3ZCFeYbPltX90xZlkGs4mre4HORP+KH8y4QqF
         7FyrLvYup50olpvqemQk2sWfK2QrA9riLa9KahDgn7LPVvHy3GpjYEQL1FAoX74Q3gUR
         4/ERAz0PNtHEn/LBeelNqrTYExClEZibTkm2X/Mvmt76KStc5sHwz5CehRp7XLcbmAO6
         vDIjzRjY3WV41oN/K6r6dgVI5UQAn2V2zvZKS1cgCAuLU8RmpS030a3hslU3rKmGm+Fu
         e7vuQmuwcZUa9LjhH7rvqJ3N/CSrZh1QlUQksK7Yf8IL8DtXzRH2af901+8zV4pt68uM
         Du1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787878285; x=1788483085; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        b=f30/ysUbAs7AUpw35wll3BQI43omDMTy7tpmkJXD1kTS1+97eWpwM0B/T4bfmYxyx5
         /G/qi8HBPUnfcAL5FMj58qddRlQIoNcUN4jOVy4DI2LKh1Q2brgd5JLoLFN+e7P+4yKE
         8iNYVR3X2J/vjeqXOTEhACp0y/q2LmktEikSnv4B21H9Hrilu2Zkh1JlBJD6mI5Q4gwv
         IbbAaZL23KP/rF1fZHzx5Qv/H0CXZ5M0T85PW9WoSohUCo+j/6oKPxnuN5Ax/BeEe14o
         KHioM8jdNg3ND5bCRlYaZXh3CYNdFtLSszN00vqbejv1SEb4NntgHTYNGMOdw2xVe/jZ
         rhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787878285; x=1788483085;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qU4cMApGQ1ZW0Ii9xuVCvK7JsWk6E/GnsI5UAJcS9yg=;
        b=adPfr9GE7W6SaOF9Pr7F021Kkqmq2uuwdtlGWkZiU+GCeK1zsN9rV/uhI8U66dPWFn
         YekrQUp4MCNtaUnU05p29YBvKuVzJqf1ySiu0pLdxhSvrIbIuC9GPmAbbVW/yK+fBeee
         Ili2eLh/46GjQxcWV+YHh6UUzcMAQRjWn0uqdu7BjOpYrU/wJFLcCKkeA2qRmymY2S42
         3HnfZ7Cv3S4a5a755Ybm86LpMsGY3BgMg0JH1kWyEWLSuJ/L1JXKeO09cFpqIvy/P+jq
         VKAi0olztKnNipmTdOfjGWht5Z3irRc/+H5jV6OReA2U+ngzNcyWo9CCCYv5V+beAETv
         ap3g==
X-Forwarded-Encrypted: i=1; AHgh+RpfDJj506yaA0Io+YUyniqomS6yiqD4N8IRFmMk3IHKzV2YBraSQEpruLFOc8y20B1ulUlfyBsl@vger.kernel.org
X-Gm-Message-State: AFuF++m1H3Neb+f0oXM1F2oWHIQRAuzaJj1UMcxVtTdraHOvCvRZDCBo
	3200Rkk3Sy8Wnx1KLTWKv/ufSRoJrdBL0GCwF9+QVOc+wBoL7uxVcG9outpXKvg5faQbBPl4XjO
	SE1u6AbwzkAkrTwowDf6SHMbWClIVf3k=
X-Gm-Gg: AR+sD13Ad0RSKrqXNGi4dA+mbFvxGKEimIGvh56/JuphlUFxFV+h8FDPu9r9dTp18sS
	E6bbuo0PVQhVnRSml7uNP1wd/D5zancv4APn0MIWAiDFUn/Ta39l5cDLJesWJy59wWhYiO85aKD
	GUf7fcOiIh/Jzeb0Fk4qmkNgNubii1RHysPtE/J/BLtyZTS1gLQLxZ90inA9Hq3Xy54yNWWB0VA
	2ZnqY/KymnUZrBUTSn5OY35Vnegr5uuhl3e0h26s68BxspAa/H1ZQ539glsZYB7NIXRnEDCoxm9
	zkupDGsOVEuWwjsawEjFsVEblM7NWT0PI65+cXXzokRvZzTTDGJjjklsvrbtkSdCdWDwRnoEg09
	1D+iiGq8S2W9vGAJ6AymDRnJmbwKlEsV84VsxJg==
X-Received: by 2002:a05:600c:4594:b0:49b:4d64:bbc4 with SMTP id
 5b1f17b1804b1-49b91c2f990mr34163415e9.8.1787878285359; Thu, 27 Aug 2026
 17:51:25 -0700 (PDT)
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
 <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
In-Reply-To: <CAO9r8zOeh1fFsY5CG1C8CDCJH25eiioY-otRv6Krn1=S21PeaA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 27 Aug 2026 17:51:12 -0700
X-Gm-Features: AcwNN1U84_r1ZsaRjTsQYeTnIouvwcCd5NXWhuiWrqoKKgqvoIXZeqezPE43G0Y
Message-ID: <CAJnrk1YO5E6ETxn9RmM-LWRQSRxwF9iEakAPz6veMPjaKMAEOQ@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 11:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Wed, Aug 26, 2026 at 5:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > > > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > For updating the stat on each parent and having the flush path only
> > > > accumulate CPU counters, I think this means we would have to
> > > > unconditionally walk the ancestors + update its counters on every
> > > > update, as we wouldn't be able to early break if the flushable
> > > > threshold was already exceeded. I don't think we could replace the
> > > > stats_update update, as it seems like readers still need some way o=
f
> > > > knowing when to flush. It seems like this could be a nontrivial
> > > > performance hit, but maybe it's a non-factor in reality. If you thi=
nk
> > > > this would be useful to get benchmark numbers on, I can run some
> > > > experiments on this too.
> > >
> > > I think we need to experiment with how much work we can shift around
> > > between the update and reader sides.
> > >
> > > Right now, on the update side, we call __css_rstat_updated(), which
> > > iterates the parents and puts them on the per-CPU rstat tree, then we
> > > iterate the parents again in memcg_rstat_updated() and:
> > > - Check if flushing threshold is already met.
> > > - Update per-CPU counter for stats_updates.
> > > - If per-CPU update exceeds (another) threshold, we update an atomic =
for
> > >   stats_updates.
> > >
> > > The flush side checks the flushing threshold and does an rstat flush,
> > > which will walk the update trees on all CPUs and iterates all child
> > > cgroups on it. Pretty expensive when the threshold is met.
> > >
> > > I think we discussed two different options:
> > >
> > > (a) On stats updates, iterate the parents and update the per-CPU
> > > counters of the stat directly.
> > >
> > > In this case, we can't keep using rstat, as we would still need to ad=
d
> > > the cgroup and all its ancestors to the update tree anyway and the fl=
ush
> > > cost will remain similar. So on the flush path we'll need to iterate =
all
> > > CPUs and add the counters. We can explore if use a cpumask can help
> > > here, but perhaps not since we'll need to update it atomically on all
> > > stat updates.
> > >
> > > I imagine that if we do this we'll drop the stats_updates optimizatio=
n
> > > to avoid adding more cost to the update side. We'll be replacing pare=
nt
> > > stats_updates modification with parent stat counter modification. But
> > > maybe it's feasible to keep both to limit the cost of flusing.
> > >
> > > This only works if the cost of iterate the CPUs on the flush side end=
s
> > > up being cheaper than the current flush. I imagine the average cost w=
ill
> > > be higher but the cost should be much more consistent vs the current
> > > flush, so the tail should be better.
> > >
> > > (b) On stats updates, iterate the parents and update the per-CPU
> > > counters of the stat directly AND update a global atomic if the per-C=
PU
> > > counter exceeds a threshold. I think updates may get too expensive as=
 we
> > > may need to update multiple atomics, especially when updating the roo=
t
> > > counter as it will be contended by all cgroups.
> > >
> > > The flush side becomes an atomic read, so should be very cheap, and w=
e
> > > can drop other heuristics and optimizations.
> > >
> > > ---
> > >
> > > I think ultimately we need to experiment with these approachs (and
> > > perhaps others) to check what actually works in practice. You'll
> > > probably want some benchmarks or synthetic tests with many cgroups to
> > > exercise the worst case scenarios.
> > >
> >
> > These are the results I'm seeing from the benchmarks. I'm comparing
> > non-ratelimited rstat vs (a) vs (b). I'm comparing non-ratelimited
> > rstat instead of ratelimited rstat, because ratelimited rstat relies
> > on the 2s flusher and doesn't incur any additional flushing when
> > called.
> >
> > ~On the update side~
> > ns per update (measured by having a kthread pinned to each CPU and all
> > threads updating the same cgroup for a 200ms window, run on 80 CPUs,
> > computed as total CPU time / # updates)
> > depth      rstat      (a)         (b)
> >     1        22.34       32.49      60.10
> >     8        22.46       47.12      140.72
> >     16      22.49       70.96      206.39
> >     32      22.51       139.16    305.40
>
> There goes my dream if an rstat-free world :')
>
> I am very surprised though that you care about hierarchies this deep.
> I don't think we have anything close to even 8 at Google, and in all
> my previous testing I usually test up to 4 or 5 levels. I suspect at

At Meta, we often see depths 8 to 16.

> that level the difference might be acceptable. But aren't other
> operations also really expensive at that depth? I imagine the charging
> path is really slow if it has to do atomic updates for 32 parents. Is

I agree. This aligns with what I saw when running the page counter
approach for zwap on depth 32. For the writeback path though, the
dirtying / writeback folio lifecycle is just stat updates. There's a
charge, but that happens only once, when the folio enters the page
cache.

> the update path really a problem given everything else?
>
> Given the constant cost of rstat updates, it also seems like
> memcg_vmstats_needs_flush() is mostly evaluating to true and skipping
> the parent walk. I wonder how much this remains true in practice, I
> think Shakeel mentioned that it does help in production.

I think for the writeback path, this is probably often encountered in
practice, since the threshold is 64 * nr_cpus and any sustained write
would cross that quickly. It would matter most with order-0 folios
since there's 4 updates incurred per folio independent of folio size.

>
> >
> > (a) and (b) perform worse on higher memcg depths, whereas rstat is
> > unaffected by depth level, which makes sense given that (a) and (b)
> > can't break early if the flushable threshold has already been
> > exceeded.
> >
> > ~On the flush side~
> > ns per flush call (measured at leaf of memcg chain, ie best scenario
> > for rstat, # CPUs on the system is 80)
> >   rstat                      10165.60 ns   (min 9924)
> >     (a)                       734.10 ns
> >     (b)                        4.79 ns
> >
> > (a) is around 14x cheaper than an rstat flush, which I think is
> > because the rstat flush goes through every stat, even ones that are
> > not directly relevant.
>
> I think that's only part of the story. rstat iterates all children
> cgroups as well. I think reading multiple contiguous stats may
> actually be really cheap since they are likely in the same cacheline.

In that benchmark, the flush cost was measured at the leaf of the
memcg chain, so I don't think there were any children to iterate here.
Maybe some of it is attributed to the rstat locking? I'm not too sure.

>
> >
> > Using some napkin math, I think the breakeven point for (a) is around:
> >                       updates per read
> > depth 1             ~900
> > depth 8             ~380
> > depth 32           ~80
> >
> > eg for depth 1:  (10165.60 - 734.10) / (32.49 -  22.34)
> >
> > This is assuming one read per flush, which is what (a) and (b) would
> > necessarily have to pay, whereas rstat only needs to flush when the #
> > of stats updates exceeds the MEMCG_CHARGE_BATCH * nr_cpus threshold,
> > so the updates per read numbers above are in reality lower.
> >
> > Running a fio write job and using tracepoints to count # of stat
> > updates, # of reads of those stats, and how many of those reads flush,
> > I'm seeing:
> >                      updates/s              reads/s
> > flushes/s         updates per read
> > bs=3D1M            643                           119                 45
> >                        5
> > bs=3D4k            156,415                     123                 58
> >                      1267
> >
> > For larger folio sizes, (a) is cheaper for writeback (since there are
> > 4 update events *per folio* in the dirtying/writeback lifecycle) but
> > for smaller folio sizes (eg order 0 folios), (a) is worse, as a lot
> > more updates are incurred, and the performance is worse the deeper the
> > memcg is nested.
>
> Hmm interesting analysis, but I actually think a more interesting one
> is the effect of the update latency in respective update paths. For
> example, in the zswap_store() case you analyzed earlier, it ends up
> being in the noise. I would check what the hottest update paths are
> (probably networking?) and check what the update paths are, to check
> if they are really sensitive to the increased update cost. It could be
> the case that at least stats that are used by in-kernel flushers do
> not really care about the extra update cost.

Extrapolating a bit from the synthetic benchmarks, at depth 8, I think
the extra overhead incurred on an update comes out to roughly around
25ns, and at depth 16, around 48ns. I haven't looked at the networking
path, but the lru path (__update_lru_size()) looks concerning, as it
would have that extra overhead while holding the lru lock, which "is
already a heavy contention point on memory-heavy workloads" [1]. As I
understand it, reclaim, compaction, and the page cache path all
serialize on that lock.

If we were to move all the callers off rstat, I think this also would
unfortunately make the walk more expensive. As I understand it, each
stat would be a per-cpu counter which would be added to the
memcg_vmstats_percpu struct, and that would have to spill onto
multiple cachelines. Or maybe I'm missing something here and there
would be a better way to do it.

>
> >
> >
> > I also ran some experiments with Jan's suggestion of scaling the flush
> > threshold to the memcg's limit rather than to the number of cpus. It
> > helps the overshoot we saw and slightly outperforms doing a plain
> > non-ratelimited flush (100% of dirty limit vs 101% on a 1G memcg, 103%
> > vs 107% on a 256M memcg) but led to ~2.4x more flushes.
> >
> > The initial reason we switched to the ratelimited version of the flush
> > was because flushing was expensive, but I'm not sure if flushing is as
> > expensive as it used to be. Testing the non-ratelimited version, the
> > flushes account for about 0.9% of the system CPU the write path
> > already spends, and I didn't see any throughput difference between the
> > two (249-252 MB/s either way), on a 32G memcg. With the
> > non-ratelimited version, it's also not a flush per read - it's still
> > "ratelimited" by number of updates that have elapsed since the last
> > flush (only flushing if stats_updates >=3D MEMCG_CHARGE_BATCH * nr_cpus=
)
> > which means concurrent writers writing back at the same time will
> > "share" flushes rather than triggering their own.
>
> Yup, this is exactly what I mean. This is a good analysis for the cost
> of the flush: how much it matters end-to-end. Even though the full
> flush is 14x more expensive according to your numbers, it seems like
> it ultimately doesn't affect performance much. I would do the same for
> the update paths, see if the extra cost really matters. WDYT?

imo ideally it would be great to minimize any overhead we can where if
we don't need the precision for a certain stat, then it would be
preferable to not incur any extra overhead for it on updates if the
overhead saved on reads doesn't justify it. In the grand scheme of
things though, I think in most cases, the extra overhead/latency isn't
really discernible except at high depths and except for the lock
contention issue mentioned above.

I don't really have an issue with rstat for cases like writeback where
we're not doing a lot of reads compared to updates, but I think we do
need to get rid of the rstat rate-limiting, as it seems so arbitrary
to rely on two seconds for stats being updated. Bounding it by time
and not stats_updates feels wrong. Even in the cases where precision
doesn't matter, it seems better to give those callers a higher stats
updates threshold depending on how much error they can tolerate, than
to rely on a blanket 2 seconds.

>
> >
> > In light of the above, imo it seems to make the most sense to just do
> > the plain non-ratelimited flush for mem_cgroup_wb_stats() and make the
> > flushing magnitude bound again, wh ich also aligns with what the
> > global non-memcg domain does. The question is whether the extra flush
> > cost is acceptable, but the numbers above make me think it is.
>
> If we can eat the cost of the flush here that's great, but I think we
> can't say the same for the vmscan and zswap paths (at least)? :/

I haven't tried out the vmscan repro or run any benchmarks on that
path, but the logic in vmscan seems weird to me, as it will always
conclude that there were no refaults whenever reclaim scans faster
than the refaults counter advances (which I think would be most of the
time under memory pressure). I'm thinking maybe we could do something
similar to what Usama did in [1] where we fold the refault delta into
a per-lruvec accumulator and let it decay. I'm planning to look more
into this and will follow up then.

For the zswap path, it's still a bit unclear to me whether exactness
is necessary or whether the 64 * nr_cpus error tolerance is
acceptable. If that error tolerance is acceptable, I think it makes
sense to use the non-ratelimited version of rstat with no forced
flushing, given that reads are supposed to be rare since rarely
anybody (from what I understand) in practice sets zswap.max. Quick
benchmarks at depth=3D4 with zswap.max set at every level, 20 workers on
80 cpus:  rstat forced =3D ~7,600 stores/s, rstat unforced =3D ~300k
stores/s, and hierarchical per-cpu counters =3D ~440k stores/s. The
hierarchical per-cpu counters outperforms rstat unforced on the stores
given that it removes the flush, but we already see massive
improvements from using rstat unforced over rstat forced.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/20260727162550.2032-4-usama.arif@linux=
.dev/

>
> >
> > Thanks,
> > Joanne
