Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7D2568FA2
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171430; cv=none; b=tmJUnlKTZpu93aXVMcQvTZWcWkIgI6F1YOwXbcJBSr0XXPzFejodPLZjk/0P/7a7tqJvLoH0+KQtqTNV5DZdF09QX+MsQB84ta+3rgEbFKj3eiZ7YFWdkqbDz6TXbdz1QwibXlB+om6oVrvCnd9SFPru8QHQ1EpEIeKZ3pHmRcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171430; c=relaxed/simple;
	bh=7nD6qG1gj02yffhZ8tYHLK/oCrMOySil2AsAqLaLkCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QYE3u/lDZ/UzC+G+4ado9M1QBrMQ6S5tCqaa8fEU+wAjbWnF/HWrh8JZcMuuzhvSTrs1J9zobPUiwtnXhwAhc79PwgB3rxv+9Y3FQcZDnqRie+izpYfiIZRZ8YCIv9+2e2SfRqAaraU46gYchJLmkQuz7ZREPOEYol4x7Xwt20Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np2EcwB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np2EcwB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417441F000C5
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171429;
	bh=LZsk8rYIK+XFI7MAmldYNUD8oXy7bvpm0tJmA3DoohI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=np2EcwB3EQET3neT6c6PTkPUbbo2osvqx3a7yGUdgCX/5tF4knSxL9qRqJEqEMrvt
	 vQp/lgSwRl6KqSK0/Gfi+iHB94CAZMRr4Rcime3eaT4qNl5p6bbHMAxZGkAT290Mg2
	 ELTiL95MGGcwJk8uT0wSNXJi/EOs5VYWPvr0nUQV2whCweSFKBmY4GQufcRNX9PORe
	 SeCVmlUw5daQRTDZot0Snxd+dszDqQdsQ5ZwsEjixyhm66CmtJwJ50eXa4F5CY81dA
	 Twoo71347hfy/LuORVaAtsvyOK8o9r5QneXle39bN57nURvSz1gq3Ype/Lsq/zrrnP
	 fd9k04nOmTwWQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so111426a12.2
        for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 10:23:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByU1LTrjpf46pCjlrKIz/L4ubUiyvgBiTOXKvXaQTTMv/jfyF44e9hO85DwugdHl8Imzc5Vq0Nr@vger.kernel.org
X-Gm-Message-State: AFq9FYJcJdaiAO3+FD1xyUIr4Kf/jyp8dsYwxiL2fxqY7gL6qYsfhGde
	u/PeoxD+XvynSzIlF71xiHe7WIKwfj11M24Kv3Fj5/3Qv7B7IfI/V+0Ob3mxCg0G8TVekEv1Oyo
	PQ9zAjlxwYoOp50we6vxnNgokzmpfgMI=
X-Received: by 2002:a17:907:3e20:b0:c3f:ab0a:3674 with SMTP id
 a640c23a62f3a-c419f122f0emr38428766b.34.1792171428095; Fri, 16 Oct 2026
 10:23:48 -0700 (PDT)
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
 <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
 <as-fG4VB_4xnAI8n@google.com> <CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com>
In-Reply-To: <CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 16 Oct 2026 10:23:36 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOVhHw1E23ejrc+A+VLLQpDGHZ5E_zxFxP=v-UWXKStSw@mail.gmail.com>
X-Gm-Features: AclHuK_tugv7BYry5ury_b5ZFzWEgqxIcYk59lnfN3VZh-EULn7KZxcp-LDnRUE
Message-ID: <CAO9r8zOVhHw1E23ejrc+A+VLLQpDGHZ5E_zxFxP=v-UWXKStSw@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, James Houghton <jthoughton@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 6:41=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Oct 14, 2026 at 8:34=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > Thinking some more about how stats are used... I think there's two
> > > categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
> > > workingset counters, dirty/writeback, zswap) which are read very
> > > frequently from the reclaim, refault, writeback and zswap paths and b=
)
> > > userspace-only ones (everything else) that are read through
> > > memory.stat / bpf / etc and much less often. The hot in-kernel ones
> > > are a small subset (~20 of ~80). Most of the stats fall into category
> > > b). However right now, a flush always aggregates *all* of these stats=
,
> > > even when the caller only needs / cares about the hot in-kernel ones.
> > > Flushing does all the work for the stats in category b), which the
> > > in-kernel flushers don't need. With the per-node lruvec copies, a
> > > flush goes through 100+ counters per cgroup per CPU vs ~30 for just
> > > the hot in-kernel ones (on a single-node machine).
> >
> > I didn't measure this before, but I did tree adding a bitmask to check
> > which stats have updates and that actually made flushing more expensive=
.
> > It could have been the case that hot stats were distributed enough that
> > all the cachelines were being fetched anyway and the bitmask was just
> > added overhead.
> >
> > I think you should do a simple experiment first about how much flushing
> > gets faster if you skip the stats not used by the kernel. It may or may
> > not matter, depends on prefetching (conversely, I wonder if explicitly
> > prefetching the entire stats array on each CPU would help).
> >
> > I think it would matter less if we manage to completely get rid of root
> > flushes (except for userspace stat reads).
>
> I ran some benchmarks on the split rstat trees idea. On an x86 80-cpu
> 2-node machine, it makes in-kernel flushing around 40% to 45% cheaper,
> but for the userspace flushers, reading two rstat trees adds ~25%
> overhead. I think this could be remedied though by just keeping the
> existing tree as is for userspace flushers (eg hold all the stats, not
> just the ones in-kernel flushers don't need) and adding a "slim" tree
> with just the hot in-kernel stats for the in-kernel flushers. Reading
> memory.stat would then just behave the same as it does now and the
> in-kernel flushers would just walk the slim tree. This would add a bit
> more overhead (and complexity) when updating hot stats though, but I
> haven't yet benchmarked this "extra slim tree" idea nor pursued it
> further. For the prefetching idea, when I ran some experiments with
> prefetching the entire stats array on each CPU, I saw it made flushes
> around 1% to 7% slower every time.

I think separating the in-kernel stats is sound in principle, but
implementation and maintenance wise it's not great (especially having
the same stats in two trees). That being said, I didn't see the code
yet, so perhaps I am wrong :)

This is why I think we should measure the improvement after
eliminating root flushes if possible.

>
> >
> > >
> > > What do you think about splitting the stats into two rstat trees, one
> > > for each category? In-kernel flushers would then only flush the hot
> > > tree (~30 counters). memory.stat would still flush both (eg userspace
> > > would see the same thing as it sees today). Each tree would have its
> > > own lock and its own stats_updates threshold.  I can run some
> > > benchmarks but I think this would make flushes a lot cheaper, and
> > > since flushes would hold the lock for less time, it should also reduc=
e
> > > the contention we see between concurrent flushers right now. Together
> > > with using node counters for root readers, hopefully this will make
> > > the non-ratelimited flush cheap enough for all non-root in-kernel
> > > readers and ideally let us get rid of the ratelimiting variant
> > > altogether.
> > >
> > > Do you think something like this makes sense?
> >
> > We have to consider the update side of things as well. How many code
> > paths will need to update both trees? That could be a problem.
>
> When I tried to measure the update cost of the split rstat trees (not
> the slim tree variant), I was seeing a lot of inconsistent / noisy
> numbers I couldn't get rid of even across boots of the same kernel and
> even between memcgs on the same boot, which seemed weird. I ran perf
> stat and that showed that the slow runs were executing the same number
> of instructions but had a lot of extra stall cycles. The variation
> between memcgs on the same boot pointed to maybe cacheline contention
> being an issue and when I ran perf c2c, it showed that the most
> contended cacheline between cpus was the first 64 bytes of
> mem_cgroup_per_node, which is strange since those are only read on
> stat updates and not written to.
>
> That struct already has cacheline padding (_pad1_) to keep the memcg,
> lruvec_stats_percpu, etc fields on a different cacheline from the
> lruvec but apparently Intel/modern cpus do "spatial prefetching" that
> pull in the adjacent cacheline (the Intel manual [1] says "This
> prefetcher strives to complete every cache line fetched to the L2
> cache with the pair line that completes it to a 128-byte aligned
> chunk"). So I think basically every time we read lruvec_stats_percpu
> (read on every per-node stat update), this pulls in the cacheline
> holding the lru list heads. The lru list heads are constantly getting
> written to by different cpus, so when the stat update happens and
> pulls in that cacheline, that ends up introducing a lot of extra
> overhead because it has to fetch that from another cpu, but also even
> worse, whichever cpu holding lru_lock has to now invalidate that copy
> before its next write and wait for all the acknowledgements to come
> back, which adds extra latency to the lru critical section and
> delays/hurts everyone who's waiting on the lru lock. I saw these same
> results on the baseline kernel even without the split changes.
>
> I think having the update path find the per-cpu counters through the
> memcg instead of mem_cgroup_per_node fixes this. On a multi-threaded
> fault benchmark in a single memcg, it improves shmem throughput by
> ~35% at 20 threads. I saw also that the inconsistent/noisy numbers I
> was seeing across reboots / memcgs on the same boot disappeared too,
> though I'm not sure yet why that fixed that issue. I'll clean up the
> change in my tree and send that out as a patch.

This is an amazing finding! I am surprised that the CPU would prefetch
a contended cacheline to be honest.

>
> But with that fix applied and with another series of local changes
> that move LRU stat updates to outside the lru lock (I'll clean up and
> send out this series as well, as it also applies to the base kernel
> regardless of the split changes), I didn't see the split changes added
> any update overhead that wasn't within noise. The lru stat updates
> changes to move it outside the lru lock are necessary though, as
> without that, there was around 2% increase in update overhead, since
> it added more latency to the lru critical section. But after that was
> moved out of the lru critical section, I didn't see any degradation
> anymore.

This also sounds amazing :)

>
> >
> > From a code perspective, it would also be a bit annoying to maintain. I
> > would check if we can eliminate root flushes first tbh, then check any
> > other potential optimizations on top. Subtrees should me a lot smaller
> > than the entire tree.
>
> Will do.
>
> >
> > > Separate from this but also kind of semi-related, I noticed
> > > css_rstat_flush() takes the rstat lock for every possible cpu, even
> > > cpus that have nothing to flush for the subtree. Maybe another
> > > improvement is to just first check locklessly whether there's any
> > > updates and then just skip the cpu if there aren't any. I can send a
> > > patch out for this.
> >
> > Only the updated cgroups are on the update tree, not their ancestors,
> > not until the flush time. We used to put the ancestors on the tree on
> > the update side, but we don't anymore.
> >
> > So we can only check the if the per-subsystem list is empty, not the
> > subtree specifically, right? Can we walk the per-subsystem list without
> > holding the lock or deleting first?
>
> My thinking was that on machines with hundreds of cpus, a good number
> of them would likely have no memcg updates since the latest flush so
> even the per-subsystem list would be empty a lot of the time. I can
> try to find some data though on how often that actually happens in
> prod.
>
> I think maybe walking the per-subsystem list locklessly could be
> slower in a lot of cases than just acquiring the lock? It seems like
> we'd have to walk the whole list to know for certain if it's a
> negative or not.

IIUC, llist can only be walked locklessly if you first move it to a
local list. But yeah the question was rhetorical, I don't think we
should walk the list to check if the cgroup is there or not.

>
> My plan is to clean up and send out the changes I have in my local
> tree this next week (the cacheline fix, switching root readers to node
> counters (getting rid of root flushes), updating stats outside the lru
> lock, removing ratelimited variant of flushing (and then if needed,
> more experimentation on the slim tree idea)).

That sounds great, thank you a lot for all your work here!

>
> Thanks,
> Joanne
>
> [1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-o=
ptimization-manual.pdf
> (bottom of page 62/800)
