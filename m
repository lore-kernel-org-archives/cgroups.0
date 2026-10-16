Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D32324B31
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792114917; cv=pass; b=EvumwM99s06AYLu8I220qKgO7b4PIthCaHQjUFyUZEhngYBeQ374EP3qEzAQuYLuJhAWYLpc3iNoWvCA3ft6DRUFNVJ8mse3jqGxpgsz0LQlspsdUlMltA7BcdjFd3uIqpafvosJbwkrFn8hCw/YfqxiExWl9Ysm1UTQNS5/hD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792114917; c=relaxed/simple;
	bh=j/dhUpk8MUPUKpBECSdbGTxzHkZ/E6OYKPtq5luQEIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nD2jiUV/iEBN8l36kLBR464PfebuoMoaGMmlm5JPZ6moZMTH/VY4xjL+q6FFddVTQmwjd3UGORlK0+Mc/EA8Zk3AxqM7CtXZh3Q1X620Tu20fHiAUQFJN8FAUkOFWUDq86KcMQ/KaBRkRxzQNxGSE00ZvjDydkxKo30YTjlRLYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/SB7269; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/SB7269"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso12167995e9.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 18:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792114914; cv=none;
        d=google.com; s=arc-20260327;
        b=tAMXTjraoh9JV6elQxmj5K/fJQrY0w0KCn0tHHaQhMA+h83H7W6R2QDE8a9sBke/CQ
         mZZB6BSMDgjCzrhTwbUI7bVIzgUVusnBxmwZElEnRg8+8KdWZfcnqQA1zA+b46JY+meh
         tTAJg8OmVwAniE52HiBlAlSwyHqbL2oizXtjwRjedacA9VO77CTqcysTNkZu2SG4JxF7
         PfVi/Raz4qWdiI9VDZOqIPAbBi/Dc/vxetnkUhyRS7mzO5ym0Wk2dlEiuLojMXFXCmDg
         LsSD4BbVC+eRCMZt3rPst+0lfm6B98OQSb+HK0b/fWxsQmRDwzQry52tJreqxd+MEqns
         TGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        fh=4qM2zP4GKA8ui2OMcPsVs/pGvFn56O1ZII+pCV1B9nY=;
        b=IC35BmJvmNk/gNpOt7jnK0TjtJLhCoFkxyh+DCy3hl2O/4iNvN2+pI1HiHHEPyLHLT
         M7wctp0XSuo4/ShsAYKJ8s6N2wGNxChOZuqyAKrv9eJUgOJSvBdijkv/6nQkOXFbZYvn
         c87M+rtxHd370c/hjfDkAHNtZ3BAqvPxVr79HYKfj0czfWHTWjJJvkLhdRU0hIokVsT9
         YD3VHzGxS+bRhhBMjW/L1zekiIcUmA4uYEy7tCUTzsGbpt/h2oSHjmGqnmFU/wE0FzF3
         gsG4k0ZZmXd8F9fR0Pn3DPmNz5GCkKXL2233WDcDHKCCGpsWhUOtoksyj9WYxnPIGQMX
         oakA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792114914; x=1792719714; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        b=M/SB7269RETiiFDhzd6V1YWRwjcyOPEmoGaaZphIVv2hk/CMLkpzljm4250Lr1b6So
         aFQI8dyMP4QmljfbeHIj1R4ZPUjmM0PwIJ9/tRFGZj5xTjffLob5WA9MUjklonLsbbLe
         aTLzcUGHITDEa3mt0kqXPm1uKsL9lJvF0hPUgNRYMyWqgmla22oLy6sEaPtVw1bjS0uw
         96QhSj/O8BK4fC5znQX6DJ2gZL4ZydcWfIZsnUh1u8ApWAWYHh62qio2WBDN8YDeMT4Y
         OTmRwEtxITe4G+AXjEjheSkmA5OuQDAuAHzfkU1JqkIwEX7qg5bH/+7HyVgw8WqtTFrF
         BM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792114914; x=1792719714;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        b=nLCPAhUAlyrZFSywnkkAlI3ro2mCppPPb/p7qoJdkOKyi/JOHeH9NiRMtwgl81hWsT
         4FS7px/aXY8mQ+9f2iNNZgRTpBvhvTUccNdUTZgXtX+bNSqzMkldRBu0CYq0QTjLi/kC
         Hfuqs1zYDf3d2U/Xpu7Ycd6Ph6A4r/gBvx1UFI5uwYPMHzEZpLrJ5dCVlDI26x7cv/eG
         2b/vTun7Ygmx0UHWIyj0zHtsMaI0L7mTY03BobU+2k68ODODaOWHEXfb894xPRm5VVMx
         0W9D9G0Tr9vLlpjMGZxy9EuRkCbB+2K4JdUanKZJMmYl0lDS1fWPYxzdOxBHz3VUsJSP
         aMgg==
X-Forwarded-Encrypted: i=1; AKwUvBwCbQTHreUe1qQW+TkA4+xWsWyC04+J4APMaRCdkNN/PQGgQG1Dx4qGEdK+nqRqnbJzy2+URA7D@vger.kernel.org
X-Gm-Message-State: AFq9FYIVCxmLR6sKaJUvUV0XdPrXGEY7aEyybyFgTZMDqPny3gc8lbxB
	pO56kN8y548sZJut5P1gTSeYOFxZ6mGLYztm5dGR2gf4gWzv77MeBJ8KjlggZ9ys5+6n2NjMmHk
	0XfuKBsXhTjQZPrT+0gWyRNsL029RvpY=
X-Gm-Gg: AYBFou0FlT9Z1Cj3NB2nLH78G19wRj6to8f6ByQU+drM2yEuGFGCjJaJeYxFFSITOgA
	oz3jJsFM1A4uelNjyhqwsDBnOcUVQ8wGFyn5yHhSOpFRufISvZ62gTk9Enuka5Ps33OB90ngdY2
	xPisr1RjtDxpf6EjBaPaDiemkKgq56sO7Xoq5fOtiCSEGb7KzCI0tjNgW+Bd+8B6cRBnepoXnZK
	rhze/xqmdAsxcyDzNnq3MQAmzWL3wYYHdXG+3Nv9HRquQxZ3+bLc++oioWdCVx01lv3r6I1M2xc
	OAT92Ou+KCY50YGOI9Xo0Beb8cLcMy+YXTrbCRylC3bCyMvBpAJ/ymOUSH7NGjNH0VAUCoTv1sl
	Dw/35A85fx2iq5zuK9Fkz9qceW6Aw29IvKaDECg==
X-Received: by 2002:a05:600c:4e89:b0:4a0:12d7:4c88 with SMTP id
 5b1f17b1804b1-4a18e4ac77amr466612125e9.30.1792114913369; Thu, 15 Oct 2026
 18:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
 <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
 <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com> <as-fG4VB_4xnAI8n@google.com>
In-Reply-To: <as-fG4VB_4xnAI8n@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 15 Oct 2026 18:41:40 -0700
X-Gm-Features: AclHuK_QVOAQKY1S1XZkxawe6wbx-PftEnFXONrhi5eHzH2ij5-uw40iTGdk8vU
Message-ID: <CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, James Houghton <jthoughton@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 8:34=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > Thinking some more about how stats are used... I think there's two
> > categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
> > workingset counters, dirty/writeback, zswap) which are read very
> > frequently from the reclaim, refault, writeback and zswap paths and b)
> > userspace-only ones (everything else) that are read through
> > memory.stat / bpf / etc and much less often. The hot in-kernel ones
> > are a small subset (~20 of ~80). Most of the stats fall into category
> > b). However right now, a flush always aggregates *all* of these stats,
> > even when the caller only needs / cares about the hot in-kernel ones.
> > Flushing does all the work for the stats in category b), which the
> > in-kernel flushers don't need. With the per-node lruvec copies, a
> > flush goes through 100+ counters per cgroup per CPU vs ~30 for just
> > the hot in-kernel ones (on a single-node machine).
>
> I didn't measure this before, but I did tree adding a bitmask to check
> which stats have updates and that actually made flushing more expensive.
> It could have been the case that hot stats were distributed enough that
> all the cachelines were being fetched anyway and the bitmask was just
> added overhead.
>
> I think you should do a simple experiment first about how much flushing
> gets faster if you skip the stats not used by the kernel. It may or may
> not matter, depends on prefetching (conversely, I wonder if explicitly
> prefetching the entire stats array on each CPU would help).
>
> I think it would matter less if we manage to completely get rid of root
> flushes (except for userspace stat reads).

I ran some benchmarks on the split rstat trees idea. On an x86 80-cpu
2-node machine, it makes in-kernel flushing around 40% to 45% cheaper,
but for the userspace flushers, reading two rstat trees adds ~25%
overhead. I think this could be remedied though by just keeping the
existing tree as is for userspace flushers (eg hold all the stats, not
just the ones in-kernel flushers don't need) and adding a "slim" tree
with just the hot in-kernel stats for the in-kernel flushers. Reading
memory.stat would then just behave the same as it does now and the
in-kernel flushers would just walk the slim tree. This would add a bit
more overhead (and complexity) when updating hot stats though, but I
haven't yet benchmarked this "extra slim tree" idea nor pursued it
further. For the prefetching idea, when I ran some experiments with
prefetching the entire stats array on each CPU, I saw it made flushes
around 1% to 7% slower every time.

>
> >
> > What do you think about splitting the stats into two rstat trees, one
> > for each category? In-kernel flushers would then only flush the hot
> > tree (~30 counters). memory.stat would still flush both (eg userspace
> > would see the same thing as it sees today). Each tree would have its
> > own lock and its own stats_updates threshold.  I can run some
> > benchmarks but I think this would make flushes a lot cheaper, and
> > since flushes would hold the lock for less time, it should also reduce
> > the contention we see between concurrent flushers right now. Together
> > with using node counters for root readers, hopefully this will make
> > the non-ratelimited flush cheap enough for all non-root in-kernel
> > readers and ideally let us get rid of the ratelimiting variant
> > altogether.
> >
> > Do you think something like this makes sense?
>
> We have to consider the update side of things as well. How many code
> paths will need to update both trees? That could be a problem.

When I tried to measure the update cost of the split rstat trees (not
the slim tree variant), I was seeing a lot of inconsistent / noisy
numbers I couldn't get rid of even across boots of the same kernel and
even between memcgs on the same boot, which seemed weird. I ran perf
stat and that showed that the slow runs were executing the same number
of instructions but had a lot of extra stall cycles. The variation
between memcgs on the same boot pointed to maybe cacheline contention
being an issue and when I ran perf c2c, it showed that the most
contended cacheline between cpus was the first 64 bytes of
mem_cgroup_per_node, which is strange since those are only read on
stat updates and not written to.

That struct already has cacheline padding (_pad1_) to keep the memcg,
lruvec_stats_percpu, etc fields on a different cacheline from the
lruvec but apparently Intel/modern cpus do "spatial prefetching" that
pull in the adjacent cacheline (the Intel manual [1] says "This
prefetcher strives to complete every cache line fetched to the L2
cache with the pair line that completes it to a 128-byte aligned
chunk"). So I think basically every time we read lruvec_stats_percpu
(read on every per-node stat update), this pulls in the cacheline
holding the lru list heads. The lru list heads are constantly getting
written to by different cpus, so when the stat update happens and
pulls in that cacheline, that ends up introducing a lot of extra
overhead because it has to fetch that from another cpu, but also even
worse, whichever cpu holding lru_lock has to now invalidate that copy
before its next write and wait for all the acknowledgements to come
back, which adds extra latency to the lru critical section and
delays/hurts everyone who's waiting on the lru lock. I saw these same
results on the baseline kernel even without the split changes.

I think having the update path find the per-cpu counters through the
memcg instead of mem_cgroup_per_node fixes this. On a multi-threaded
fault benchmark in a single memcg, it improves shmem throughput by
~35% at 20 threads. I saw also that the inconsistent/noisy numbers I
was seeing across reboots / memcgs on the same boot disappeared too,
though I'm not sure yet why that fixed that issue. I'll clean up the
change in my tree and send that out as a patch.

But with that fix applied and with another series of local changes
that move LRU stat updates to outside the lru lock (I'll clean up and
send out this series as well, as it also applies to the base kernel
regardless of the split changes), I didn't see the split changes added
any update overhead that wasn't within noise. The lru stat updates
changes to move it outside the lru lock are necessary though, as
without that, there was around 2% increase in update overhead, since
it added more latency to the lru critical section. But after that was
moved out of the lru critical section, I didn't see any degradation
anymore.

>
> From a code perspective, it would also be a bit annoying to maintain. I
> would check if we can eliminate root flushes first tbh, then check any
> other potential optimizations on top. Subtrees should me a lot smaller
> than the entire tree.

Will do.

>
> > Separate from this but also kind of semi-related, I noticed
> > css_rstat_flush() takes the rstat lock for every possible cpu, even
> > cpus that have nothing to flush for the subtree. Maybe another
> > improvement is to just first check locklessly whether there's any
> > updates and then just skip the cpu if there aren't any. I can send a
> > patch out for this.
>
> Only the updated cgroups are on the update tree, not their ancestors,
> not until the flush time. We used to put the ancestors on the tree on
> the update side, but we don't anymore.
>
> So we can only check the if the per-subsystem list is empty, not the
> subtree specifically, right? Can we walk the per-subsystem list without
> holding the lock or deleting first?

My thinking was that on machines with hundreds of cpus, a good number
of them would likely have no memcg updates since the latest flush so
even the per-subsystem list would be empty a lot of the time. I can
try to find some data though on how often that actually happens in
prod.

I think maybe walking the per-subsystem list locklessly could be
slower in a lot of cases than just acquiring the lock? It seems like
we'd have to walk the whole list to know for certain if it's a
negative or not.

My plan is to clean up and send out the changes I have in my local
tree this next week (the cacheline fix, switching root readers to node
counters (getting rid of root flushes), updating stats outside the lru
lock, removing ratelimited variant of flushing (and then if needed,
more experimentation on the slim tree idea)).

Thanks,
Joanne

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-opt=
imization-manual.pdf
(bottom of page 62/800)
