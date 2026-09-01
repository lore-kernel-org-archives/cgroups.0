Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567DE483BF4
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284241; cv=none; b=XGJrDH5+DzT7p9ybeFclhMIqpfu5Qn19swSOL8SOQsNhoF9gTiqSWpWQ8+/ae9Vzyok2hgu9XC5DKmno7pPEZTfyWjL0CkYRJBm9z+CZ1UpRpc7Km3DldMnYZILn5YekwspjSi6oUak7tuF8ZtvzL+vDJJEJLVP7oIxqxZjO8pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284241; c=relaxed/simple;
	bh=6zo0vD0WrMxDTrLkYi5SZlZp0oHj/c0Lu7P8MC3D64I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ky03D4cIGHqcpy5exDqOg6xCC32/x5oMqGxz5SlCqipUtzNUTv/MSYfzVTd9ian2Q7el/oUZgqm6PZ6j+kWwRKVGQurUHgi/qdfLkDPcgPD7J5QdFRxempjEyvQ4RUav8u84RxVobOD02hpKBFRh/Nv0bL49mUNH0+G3UcF7qfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y7GCVbGI; arc=none smtp.client-ip=91.218.175.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y7GCVbGI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6zo0vD0WrMxDTrLkYi5SZlZp0oHj/c0Lu7P8MC3D64I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788284236; v=1; x=1788889036;
 b=Y7GCVbGIEXLYVUd79jHtVQQqb+uBUWPuth9NYQmo6v5EAfHQ7tZSk2S6fa+0ez6f00vUj0nd
 aBFMZZR2tPO4xr3NjVhOh7PxBHZHxGuzip0tn0zpHpPGmn09eLJrd1mrL3q061ELjFruiaqFdoI
 CTFnd7yCBk67B0NrKgluxrng=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c386ce8340dde776;
	Tue, 01 Sep 2026 17:37:16 +0000
X-Mizu-Trace-ID: c386ce8340dde776
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 10:37:14 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <apcJgcFLHKZfI40m@linux.dev>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev>
 <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>

On Tue, Sep 01, 2026 at 01:20:33PM +0800, Kairui Song wrote:
> On Tue, Sep 1, 2026 at 12:38 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> > > introduced a sanity check to catch memcg counter underflow, which was
> > > more of a workaround for another bug: lru_zone_size is unsigned, so
> > > underflow wraps it around and returns an enormously large number, then
> > > the memcg shrinker loops almost forever as the calculated number of
> > > folios to shrink is huge. That commit also checked if a zero value
> > > matches the empty LRU list, so we have to hold the LRU lock, and
> > > handle the positive and negative deltas separately.
> > >
> > > But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> > > for lowmem requests when memcg is enabled") already removed the LRU
> > > emptiness check, so handling the deltas separately is no longer
> > > needed. And if we just turn it into an atomic long, underflow isn't a
> > > big issue either,
> >
> > Why atomic long and not just long?
> 
> Long is fine too; I was just trying to be defensive. The original
> check was a defensive design for leaks or races, and atomic long is
> more immune to race conditions. See below for the other conditions.

Unless we really need it, let's stay with "long" for now. As you mentioned below
this is busy/hot path, no need to add overhead of atomic here.

> 
> > > So let's turn the counter into an atomic long and check at the reader
> > > side instead, which has a smaller overhead. The underflow correction
> > > is removed: a massive leak of the LRU size counter would indicate
> > > that something else has gone very wrong, and one should fix that
> > > leaking site instead. Besides, the updater-side sanity check is
> > > unlikely to catch the leaking site anyway: if a folio was removed
> > > without updating the counter while other folios remain on the LRU,
> > > the WARN only triggers much later, from a likely innocent callsite.
> >
> > Do you have any data to support your claim that updater-side sanity check is not
> > that useful? Also can you explain the motivation to move the check from the
> > update side to reader side?
> 
> I think I described that in the commit message. Commit ca707239e8a7
> introduced the original emptiness check. The goal was to fix an
> over-busy reclaim scenario: upon underflow, an unsigned long returns
> an extremely large value. The reclaimer calculates the page number to
> scan based on that value, and thus enters a busy loop trying to
> reclaim much more than the actual usage. It's really a defensive
> design or workaround.
> 
> And later commit b4536f0c829c just removed that emptiness check,
> leaving only the underflow check. So at this point we are just
> defending against underflow. Currently, I don't believe there are any
> known leaks or underflow issues in mainline, still purely a defensive
> design.
> 
> Reading these counters (mem_cgroup_get_zone_lru_size()) is much rare
> than updating them: the only readers are reclaimer - per loop, each
> loop will scan a large chunk of folios. Or during reparenting - per
> child.
> 
> Writers, however, operate on every LRU folio.
> 
> So checking it in the reader side is much lighter and cleaner code-wise.

So, one motivation is cleaner code?

> 
> Checking in the reader side also tolerates deferred accounting false
> positives: if a folio is added to / removed from LRU but have the
> accounting happens later, that's fine, but might cause a temporary
> underflow (there shouldn't be such usage right now, but cleanly the
> oldest commit I mentioned is trying to catch something). It should
> just proceed without performing extra operations on the counter or
> raising a warning on the updater side.
> 
> The underflow won't affect anything besides the two readers mentioned
> above (reclaimer and reparenting).
> 
> Besides, I don't think warning on the writer side will help catch the
> real leak either, it just adds overhead to a busy path. The folio
> triggering the underflow is very unlikely to be the one leaking the
> count. And if that leak is actually caused by a race, the atomic long
> change should cure it.

I think you are going and looking too much into the history of this warning. I
think you just need to explain that the current warning in the update side
already can't always catch the actual leak and is costly. Moving to read side
make the code cleaner and warnings will be at the location where the consumers
we care about are going to consume it. Also add couple of sentences on behavior
difference it will have i.e. warning on flipping into negative vs we will
continue to operate even in negative but only warn on negative consumption.

Another question: why is this patch part of this series? Just some orthogonal
cleanups or are they related?



