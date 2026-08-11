Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053C28504F;
	Tue, 11 Aug 2026 00:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786409306; cv=none; b=mEfSKX9Igncm6inxQtmi5EZ7LZXspO/rFFmf+/1z0Ui2aqvYFn8oeX09NyipbJyEJNszTdfsgTQh7bWPtVBewp2biAuF36gXNwHU+pHwd09zWwWCiDpkCixZ4jrSevcAL6qCc5HBRYTJVvJE2tbcooW2NGaDxElWMOmMH+FME2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786409306; c=relaxed/simple;
	bh=tQJKYAJCM8/IP2w8iYhe+xhqvbrDNSqHT+FreZPPRTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXreWYQwzp+pUTeQx3RE8Ra5AdSBm0lZJVF5fKc1UQnQVcQ6yGZbUhfhKbgRpaSxaasx6+qRoxbRw8QXOe9NRZjXaRtU1c+tJhJjpsuvcTm0XDdkslMHMZS6srZU8fI+06LKecgaj+cX+stwWrpUltK82hpzL4f6X5F+ylbQ+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcUlgPzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcUlgPzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35F71F000E9;
	Tue, 11 Aug 2026 00:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786409304;
	bh=qKS1JcrH56Iarz4e1apBMWyGOHTnqlTit3H0mkZq1+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KcUlgPzUP/WSHmvVXiEzTL5xhOjnjhy7SP7rgYlFvuerL+rkI/JPIc+z7BGGVt1sU
	 ZyFZN7JkpLvRGEI6sU/jVXwO5WmJP91a/h99jXywKX7eYkdeJI3VVnlczza/UfQU82
	 +LNG1qA870ipZuZNLOKkx77RgZu8h51N+IBnUuynE25xmHem+jjw3tuIVPL2F5+7cn
	 k0tieup1r3NUEn8y8sV61DAq9Kb2oD7p7ty72liD9iKhtaTB/e2jJs4dbAjLepqR8w
	 PpHOwAI+e205XoAy1r9jq2Ahu/S+ZL6UC1DsRDMyYPzkmDNEtm9iCOdCSzBpjMAYPK
	 AGyK+owE1mQCA==
Date: Tue, 11 Aug 2026 00:48:22 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, fuse-devel <fuse-devel@lists.linux.dev>, 
	Jingbo Xu <jefflexu@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi
 strictlimiting")
Message-ID: <anpsLy_pCanocgS1@google.com>
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>

On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> On Thu, Aug 6, 2026 at 2:31 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Thu, Aug 6, 2026 at 2:04 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > I'm not too familiar with memcg or vmstat so apologies if this is a
> > > naive question, but does it make sense for memcg to just do a similar
> > > approach to what vmstat does? As I understand it, mod_lruvec_state()
> > > updates the node counter and the memcg counter (if memcg applies),
> > > where for updating the node counter, mod_node_state() does some
> > > batching where it updates the global counter for that stat only once
> > > it crosses some threshold (pcp->stat_threshold). Could memcg keep its
> > > per-CPU counter as the accumulator but once it reaches some threshold,
> > > it then propagates it up the parent/ancestors into a per-memcg atomic
> > > global counter? The atomic would then only have to be touched once per
> > > batch than on every update, which might eliminate the overhead of the
> > > per-memcg atomic you saw previously? It seems like this would get rid
> > > of needing to do any flushing altogether, as we could just read that
> > > global counter directly.
> >
> > The memcg stats perform similar per-CPU counting and thresholding. The
> > main difference from vmstat AFAICT is the cgroup hierarchy. In vmstat
> > we have per-CPU counters and a global atomic counter for each stat.
> > For memcg, we have the same for each cgroup, then we also have a
> > cgroup tree. When we read the stats of a cgroup, we usually want the
> > hierarchical stats including all of its children, so we can't just
> > read the global counter.
> >
> > We use rstat, a cgroup framework that keeps track of which cgroups
> > have updates on which CPUs, and then memcg has thresholding logic on
> > top to only flush if the number of pending updates exceeds a
> > threshold. Essentially, if the magnitude updates on a CPU exceeds
> > MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We only
> > flush if that global per-memcg counter has > NR_CPUS *
> > MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to 2 *
> > NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
> > stats).
> >
> > See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this logic.
> >
> > Looking at this code again, it made me realize that we already iterate
> > the per-CPU stats_updates on every update to increment the number of
> > pending stats on this CPU. I wonder if we can replace this with
> > actually updating the stat on each parent, then the flush path only
> > needs to accumulate CPU counters. Or maybe as you mention, we update
> > the global per-memcg counter when updates on a CPU exceed a threshold,
> > and forgo the rstat flushing logic completely.
> >
> 
> I can run some experiments and see if updating the global per-memcg
> counter per batch and forgoing flushing could be a viable solution.
> I can use my setup to test it for writeback, but for the zswap use
> case, what's the best way to test if the changes are too expensive? Is
> there a benchmark program you're running?

I was running stress-ng and measuring the latency of zswap_load() and
zswap_store() with bpftrace. But I suspect whatever works for writeback
should work for zswap :)

> 
> For updating the stat on each parent and having the flush path only
> accumulate CPU counters, I think this means we would have to
> unconditionally walk the ancestors + update its counters on every
> update, as we wouldn't be able to early break if the flushable
> threshold was already exceeded. I don't think we could replace the
> stats_update update, as it seems like readers still need some way of
> knowing when to flush. It seems like this could be a nontrivial
> performance hit, but maybe it's a non-factor in reality. If you think
> this would be useful to get benchmark numbers on, I can run some
> experiments on this too.

I think we need to experiment with how much work we can shift around
between the update and reader sides.

Right now, on the update side, we call __css_rstat_updated(), which
iterates the parents and puts them on the per-CPU rstat tree, then we
iterate the parents again in memcg_rstat_updated() and:
- Check if flushing threshold is already met.
- Update per-CPU counter for stats_updates.
- If per-CPU update exceeds (another) threshold, we update an atomic for
  stats_updates.

The flush side checks the flushing threshold and does an rstat flush,
which will walk the update trees on all CPUs and iterates all child
cgroups on it. Pretty expensive when the threshold is met.

I think we discussed two different options:

(a) On stats updates, iterate the parents and update the per-CPU
counters of the stat directly.

In this case, we can't keep using rstat, as we would still need to add
the cgroup and all its ancestors to the update tree anyway and the flush
cost will remain similar. So on the flush path we'll need to iterate all
CPUs and add the counters. We can explore if use a cpumask can help
here, but perhaps not since we'll need to update it atomically on all
stat updates.

I imagine that if we do this we'll drop the stats_updates optimization
to avoid adding more cost to the update side. We'll be replacing parent
stats_updates modification with parent stat counter modification. But
maybe it's feasible to keep both to limit the cost of flusing.

This only works if the cost of iterate the CPUs on the flush side ends
up being cheaper than the current flush. I imagine the average cost will
be higher but the cost should be much more consistent vs the current
flush, so the tail should be better.

(b) On stats updates, iterate the parents and update the per-CPU
counters of the stat directly AND update a global atomic if the per-CPU
counter exceeds a threshold. I think updates may get too expensive as we
may need to update multiple atomics, especially when updating the root
counter as it will be contended by all cgroups.

The flush side becomes an atomic read, so should be very cheap, and we
can drop other heuristics and optimizations.

---

I think ultimately we need to experiment with these approachs (and
perhaps others) to check what actually works in practice. You'll
probably want some benchmarks or synthetic tests with many cgroups to
exercise the worst case scenarios.

For the zswap stats, I used to run stress-ng with a bunch of workers
(20, 50, 100, ..) in cgroups of different levels. Since all workers are
in the same cgroups, all the parents are common and all threads end up
competing on the same atomics, so worst case scenario. I was also
testing in a VM that has more CPUs than stress-ng workers, to exercise
the full extent of the concurrency and contention.

This could be a lot of work, so I am not really asking you to do it, but
just brainstorming and sharing ideas :)
