Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0173824DCF9
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233150; cv=none; b=hlRCByt34Rr5q0HD1OLnF+fMWDlKM672fY4KH6qf5lXN54JrG8LLJ3DTtREj9CvYXEkCsvOo+GQAZ0PjTeabHIBYovmC+EX+jaYD8P82bhPkdbQSVWut3GEZpdWkXr2jLIGqwzlEJwnKj/zEo9TvwZV5pT/CJhWKfbOAZlHb+eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233150; c=relaxed/simple;
	bh=EifykRt2LKQ6kZJvwfPakJmr6DCGWMMbbwpMw2ZAXpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkgoTzyGTmsc05VPGSwhYS81v1D3qSCCbqRdTzc6yhdm/mAmRE+c3d07ei3R9UOx8OIdXGu0OD5AE25Z1hn91RisNuQUa241wDAGoTRh72kRSCOIuxLuHS9VFgaQvgCo0JL4f8Z5tKIqUpvLBnZWFrnwFDTxFJvpWEATy2jzq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnuELlo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnuELlo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BC1F0089A
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791233148;
	bh=NLFOoYWWtnRY6Ceo7GoZb6AHkD3ORrSQ4V9OneUN+Ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nnuELlo/mACSEwSUq3E6UHbBvwkqiJor4R5vdiUQ0PQ9PYoN3BmVH2v7zEKWsUfvs
	 PKPYRDW0hNp3HncNPCbgpu0D0BmbQlnqnBslDQdPWv+n7uSy+SXYSkKvbDZ/v7u6o2
	 otWP6/qYKlVDx3yKhcet53nAFnf12R4Qd2OVI/mP02xVfjMGN4eXYqStxf/liS5Hpq
	 0d6eQRLyA2QknqU+u4te6ymfN3uZCQzfbSHqxfmon8GYiUn04s9wRsAMPg/zofaDUB
	 vlqUqVdk8QAG0xQOt82im8ryWm1q3/QFQraLFWaqNiL3mzC49m/qFB+fA4bzfMPfCK
	 riRUoA1EOIxMQ==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so385806066b.0
        for <cgroups@vger.kernel.org>; Mon, 05 Oct 2026 13:45:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9AUTISHxXUBkX/0o2TYo8Fgw/0HChhlLstBaN77tyEMVz3jpcN3SS83x6xbyNjrKz3JJvUc/k@vger.kernel.org
X-Gm-Message-State: AFuF++nB+VdSoGF5qx7+a84NxRR7/J6Qm4p+bgc5TKzECkRY3X6so1XM
	Bfj+xPQJkNsTpHuIXGSfaCXhG1DfAKLCAQQ2+cJvlw8U7ITwLHfbBB7GH9Z/fkIj6fdRxtRqQdT
	yYn4i+Sis2ugAWvYnwB2YuVSLG/LUUx0=
X-Received: by 2002:a17:906:f594:b0:c29:53ba:a4cd with SMTP id
 a640c23a62f3a-c2e4ad13e7amr997364966b.11.1791233147408; Mon, 05 Oct 2026
 13:45:47 -0700 (PDT)
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
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com> <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
In-Reply-To: <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 5 Oct 2026 13:45:33 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
X-Gm-Features: AclHuK9bsxnzrNzCEGYxM5xbrCEvC4kIDgtRMWmkPhx27BYSlzrkiZ8zssPr8fA
Message-ID: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: James Houghton <jthoughton@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> I added some instrumentation to prepare_scan_control() and have been
> seeing that the OOM gets triggered in this pathway:
> a) the memcg is created with memory.max set to unlimited. 512 M gets
> faulted in. The new anon folios get put on the inactive list. Nothing
> reclaims them yet
> b) userspace then sets memory.max to half of memory.current (~271M
> from ~542 M currently used). This causes memory_max_write() to trigger
> reclaim logic
> c) the folios have already moved to the active list (my
> instrumentation shows 122684 active vs. 179 inactive) when reclaim
> does the scanning, which means the only way for pages to be reclaimed
> is for pages to get deactivated from the active list back to the
> inactive list.
> d) prepare_scan_control() (which decides if the pages get deactivated)
> reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> (the 2s flusher hasn't yet triggered since when the memcg was
> created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> still zero. The real values are all still sitting in per-cpu buffers
> that haven't yet been flushed. My instrumentation shows:
>         inactive_anon       rstat: 0    actual: 179
>         active_anon          rstat: 0    actual: 122684  (~479 MB)
> e) the deactivation logic in prepare_scan_control() is:
>
>                 refaults = lruvec_page_state(target_lruvec,
>                                 WORKINGSET_ACTIVATE_ANON);
>                 if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
>                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
>                         sc->may_deactivate |= DEACTIVATE_ANON;
>                 else
>                         sc->may_deactivate &= ~DEACTIVATE_ANON;
>
> The if check fails:
>      refaults != prev refaults: 0 != 0      (false)
>      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> inactive_ratio < 0     ( false)
>
> DEACTIVATE_ANON gets cleared
>
> f) pages don't get moved from the active list to the inactive list, so
> reclaim ends up freeing nothing. memory_max_write() goes through all
> MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> (but it's all on the active list).
>
> I saw that the skipped_deactivate retry did fire (on 858 of 4264
> scans), but not enough to get the memory.current back under the halved
> memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> and OOMed.
>
>
> imo I think the best fix would be
> a) for non-root memcgs, revert back to the non-ratelimited version
> (mem_cgroup_flush_stats())
> b) for root-memcgs (which if flushed will flush every cgroup on the
> machine), don't use rstat at all and use the existing node counters
> instead (which is what the non-memcg case already uses).
> mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> stat in the same call. For the root lruvec, the node counter reflects
> the same value and doesn't need any flushing. It has an error bound of
> 125 pages/cpu at most, but this is tighter than what we currently have
> with the ratelimited version.

This seems like the right thing to do. If we have global stats, we
should avoid a rstat flush. I actually wonder if we should start
systematically eliminating root flushes, and if that ends up being
good enough to keep everything else as-is for in-kernel flushers. The
flush in zswap_shrinker_count() is also a good candidate, we already
use global stats when memcg is disabled there as well.

>
> commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> reclaim") was what switched vmscan to using ratelimited flushing. The
> reason for this was to fix the stalls from concurrent reclaimers
> contending on the rstat lock. For the Cloudflare case, kswapd threads
> were contending on the rstat lock on 8 numa-node machines. That's the
> global path (eg sc->target_mem_cgroup is NULL,
> mem_cgroup_flush_stats() turns it into root, so this flush essentially
> ends up flushing every cgroup on the machine), which gets addressed by
> adding the fix in b), which takes kswapd and global direct reclaim off
> rstat entirely. For the non-root memcg case, the flushing is bounded
> by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> memcg's stats_updates only accumulates its own subtree's updates, so
> it takes a lot longer for it to be exceeded than the root's does).
>
> I ran some benchmarks to get a rough idea of what a) costs. I set up a
> workload that allocates 512M of anon memory in a memcg with memory.max
> set to half of that to trigger reclaim continuously. I varied the
> number of threads touching the memory, so that N of them hit
> memory.max and enter direct reclaim on the same memcg at once. I used
> bpftrace to measure the time spent inside css_rstat_flush() and
> shrink_node() and used those two numbers to get a percentage for how
> much of reclaim is spent in flushing. These are the numbers I saw:
>
> # threads      flush as % of shrink_node()
> 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> 64              ratelimited: 0.16%       non-ratelimited: 2.52%
>
> Between the ratelimited and the non-ratelimited runs, walltime and
> pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> pgsteal within 0.2%).
>
> I also measured the lock contention. At 16 and 64 threads, 15-20% of
> __css_rstat_lock() acquisitions hit a contended trylock with the
> non-ratelimited version. At 16 threads, the mean flush time rises
> about 8% and at 64 it roughly triples from the single-thread case
> (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> effect of this on wall time or pgsteal between the non-ratelimited and
> the ratelimited version, and the percentage of reclaim time spent
> flushing stayed at 2-3%. I think that's because css_rstat_flush()
> takes and drops the lock once per cpu rather than holding it across
> the walk.
>
> I also ran it with 32 actively churning sub-cgroups under the reclaim
> target, since css_rstat_flush() walks the descendants that have
> pending updates. I saw that per-flush cost rises slightly (~24 us to
> 27 us) but the share of reclaim time spent flushing went down rather
> than up (4.1% to 3.2%), because reclaim gets more expensive faster
> than flushing does. I don't have a ratelimited baseline at 32 children
> though, because with the ratelimited version, all the runs I tried
> OOMed. I think this is an alternative repro to the OOM issue but
> doesn't need/have KVM dependencies, so if this would be useful to
> clean up and send as a standalone C repro, please let me know.

It might be useful if it can be added as a selftest or similar, so
that such regressions can be caught more easily in the future?

>
> (Also btw (this is a bit tangential to this OOM issue, but somewhat
> semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> checking really does anything in practice. On my benchmark runs, the
> "refaults != prev_refaults" check evaluates to false in pretty much
> every scan. Even with flushing working properly, it didn't trigger on
> 1673718 of 1674912 samples, even though the cgroup was thrashing the
> whole time (a separate run of the same workload counted 6371860 anon
> refaults vs 6523 activations). I think it's because reclaim is
> scanning faster than the refaults counter advances, so it'll almost
> always see no change. I'm not sure how much this matters in practice,
> but I think effectively in that check above in prepare_scan_control(),
> deactivation relies entirely on the inactive_is_low() check.)

I am also not sure about this one. I am not sure if reclaim moving
faster than refaults is something universal, it seems like it would be
workload-specific. Johannes is the person that comes to mind when I
think about these heuristics, so maybe he has an opinion about this?
:)

>
> What do you all think about adding a) and b) as the fix for this issue?

I generally agree. Doesn't really matter much, but I think we should
do (b) then (a) to avoid reintroducing the regression temporarily?

>
> Thanks,
> Joanne
>
