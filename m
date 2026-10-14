Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43965551998;
	Wed, 14 Oct 2026 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992068; cv=none; b=aNjmV1S97OfE80s6BAqSv8WuloyoQ9DMh8Zn/iuWP4nftXZBH+uih6bZ7pEeIpBvJkTKHwSHVa+D4Gdo8xMdX3MBMTcgLDgb8yIH5S94Q5KaMF52nNMBfXX6Y35x+7JNCUTXgOCDMHLsOgaf7V5iGQL9MFhxJVEq5MBG03e6ns0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992068; c=relaxed/simple;
	bh=E3b5bGuxXiDmeXSWjXU/z/lrNdQ2up0OPotyR0w5mGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDX5Gc6xuwqWrYprWZaE6zpkMZ3ozCevsqyqiNzjvIa0lMO3p8FCU7D289HWw0ONiANpeErC2+wa2/1ymfwIvBydrrXk9W0KmonbcgbtqJfgGFdP3MQ9zqU1jWI56p50OpprVhaSGETFWri9Jll3q8XVH95kegUQeCskAKhKSG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXwsjiim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXwsjiim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADD91F000C4;
	Wed, 14 Oct 2026 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992065;
	bh=4PFOX9yalEabkXcpKYf0K7UJ8iSUGtpn9nhdGgjblA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXwsjiimljBkk3klGNvt2oGaICpvgZfYfSRo10UiYzT15XrWeCYt6KEOlmy6ogSP3
	 lvrU+RAONvfAw+EO/TwZA6uxO0ktnG4cQofibjrwCwnK5x37vHTvg0G9kufqPAqiEm
	 PHOVyF6jRrNvealKCeNKw1ZQE4eJtZ0tfoPeyt1W2ZLD7tv361JizIZMAhQf5HQLrV
	 435ZB8BCdRo12/DcFdO+x6EuaApq26T0noVRE9AIwbjec6e3CQeblCsaTouSHBYRgE
	 12I3RDGLcnHbknrkK6HM+70+HlA3PYB+TIvAZsUxBg97UMqA+Ind7CkAj5afjetywj
	 UnslMDXYih0yQ==
Date: Wed, 14 Oct 2026 15:34:23 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	James Houghton <jthoughton@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, fuse-devel <fuse-devel@lists.linux.dev>, 
	Jingbo Xu <jefflexu@linux.alibaba.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi
 strictlimiting")
Message-ID: <as-fG4VB_4xnAI8n@google.com>
References: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com>
 <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
 <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
 <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>

> Thinking some more about how stats are used... I think there's two
> categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
> workingset counters, dirty/writeback, zswap) which are read very
> frequently from the reclaim, refault, writeback and zswap paths and b)
> userspace-only ones (everything else) that are read through
> memory.stat / bpf / etc and much less often. The hot in-kernel ones
> are a small subset (~20 of ~80). Most of the stats fall into category
> b). However right now, a flush always aggregates *all* of these stats,
> even when the caller only needs / cares about the hot in-kernel ones.
> Flushing does all the work for the stats in category b), which the
> in-kernel flushers don't need. With the per-node lruvec copies, a
> flush goes through 100+ counters per cgroup per CPU vs ~30 for just
> the hot in-kernel ones (on a single-node machine).

I didn't measure this before, but I did tree adding a bitmask to check
which stats have updates and that actually made flushing more expensive.
It could have been the case that hot stats were distributed enough that
all the cachelines were being fetched anyway and the bitmask was just
added overhead.

I think you should do a simple experiment first about how much flushing
gets faster if you skip the stats not used by the kernel. It may or may
not matter, depends on prefetching (conversely, I wonder if explicitly
prefetching the entire stats array on each CPU would help).

I think it would matter less if we manage to completely get rid of root
flushes (except for userspace stat reads).

> 
> What do you think about splitting the stats into two rstat trees, one
> for each category? In-kernel flushers would then only flush the hot
> tree (~30 counters). memory.stat would still flush both (eg userspace
> would see the same thing as it sees today). Each tree would have its
> own lock and its own stats_updates threshold.  I can run some
> benchmarks but I think this would make flushes a lot cheaper, and
> since flushes would hold the lock for less time, it should also reduce
> the contention we see between concurrent flushers right now. Together
> with using node counters for root readers, hopefully this will make
> the non-ratelimited flush cheap enough for all non-root in-kernel
> readers and ideally let us get rid of the ratelimiting variant
> altogether.
> 
> Do you think something like this makes sense?

We have to consider the update side of things as well. How many code
paths will need to update both trees? That could be a problem.

From a code perspective, it would also be a bit annoying to maintain. I
would check if we can eliminate root flushes first tbh, then check any
other potential optimizations on top. Subtrees should me a lot smaller
than the entire tree.

> Separate from this but also kind of semi-related, I noticed
> css_rstat_flush() takes the rstat lock for every possible cpu, even
> cpus that have nothing to flush for the subtree. Maybe another
> improvement is to just first check locklessly whether there's any
> updates and then just skip the cpu if there aren't any. I can send a
> patch out for this.

Only the updated cgroups are on the update tree, not their ancestors,
not until the flush time. We used to put the ancestors on the tree on
the update side, but we don't anymore.

So we can only check the if the per-subsystem list is empty, not the
subtree specifically, right? Can we walk the per-subsystem list without
holding the lock or deleting first?

> 
> Thanks,
> Joanne
