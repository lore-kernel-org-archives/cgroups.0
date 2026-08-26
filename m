Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F219C553
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785702; cv=none; b=r1uDAvJBWRUzXazfNgbjV1SGazZ0mAaJppDMeDcwblA+UseJSirLSxwdYI1zAU6x1vA3FJe8aw/6rqfT2x2KLpnJag5nMS0oL6UYoABC0IfRgG4G4sOnvpI8hoBVOqYZs8thXUtDj4kVuoG3dKBGzuahiNR+2T4M1HYQR07uCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785702; c=relaxed/simple;
	bh=noRPLNdLIahOGuFurijMFn6y8l/0FZg7N9AF61uRmC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VW4b5XOIYHBHBVYqhS/VaDHgkuUSLBTgKiW/YJUhW5M2CNI25Nx2KvPRVVUVK5dQSj9li2a5LJ/psOgc1t7IejRVOMga9f8+pxw35zAe3NHg9DKTQUzTSlROqzNHsp0NhgqAD1j/iaS7+1tjCCUfIpY8mDdj6H8n6eAG7bF6GMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DT5vIEV/; arc=none smtp.client-ip=95.215.58.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DT5vIEV/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=noRPLNdLIahOGuFurijMFn6y8l/0FZg7N9AF61uRmC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787785697; v=1; x=1788390497;
 b=DT5vIEV/bquOIInj1H3LekDV3nFXNIgsOzU4ZlUHzMk50FLqFYYu1WEo3c5t/WRLgZNgHex1
 W/xPHXt2Zh1DKABImooRkPof02s4LEX6iGntwOBzLa4gxZc+1X7JhnM2JgruUHL1zAe2jdvfQ8J
 7WRtR60m6JS8CDXeo/Tumsgg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:1d::)
	by smtp.migadu.com with ESMTPS id 8f2a058e7e3a482c;
	Wed, 26 Aug 2026 23:08:07 +0000
X-Mizu-Trace-ID: 8f2a058e7e3a482c
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:08:06 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <ao9q-m9k-NMxDvA1@linux.dev>
References: <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org>
 <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com>
 <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
 <ao9YFgBQJEy-85iB@linux.dev>
 <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zO6VWRGh3CbqyymSkEaw6gFd6AKYQgZE_rTQP7svWEMfw@mail.gmail.com>

On Wed, Aug 26, 2026 at 02:55:57PM -0700, Yosry Ahmed wrote:
> > >
[...]
> > > If (c) is holding up for writeback and vmscan, I would question a more
> > > radical approach of tearing apart the rstat framework and using it
> > > across the board. That is obviously a heavier lift and more
> > > controversial,
> >
> > Yes controversial because we used to have similar mechanism which did not work
> > and we had to move to rstat. Check the commit 42a300353577 and fixes to it.
> 
> IIUC, in that commit, the update side modifies one per-CPU per-cgroup
> counters, and when those counters exceed a threshold atomic updates
> are performed on all parents, which I think is the slow side. Then,
> the read side just reads the potentially stale atomic. That was
> problematic because:
> (1) The update side can end up performing atomic updates on all parents.
> (2) The read side can be inaccurate by up to MEMCG_CHARGE_BATCH *
> nr_cpus * nr_children
> 
> What I am proposing in (c) is different:
> 
> (1) The update side always updates per-CPU per-cgroup counters in all
> the parents. It never does atomic operations. The parent iteration is
> not cheap, but it is cheaper than atomics for sure and we already do
> parent iteration today in some cases in memcg_rstat_updated().So the
> "slow" path should be the same as today.

Yes but that parent traversal is short circuited when we hit the flush
threshold. At Meta scale, we have observed significant cpus being spent on
memcg_rstat_updated before that.

> (2) The read side always iterates per-CPU counters in this cgroup, so
> it's always accurate. This might be more expensive on an rstat flush
> on average (e.g. if memcg_vmstats_needs_flush() skips the flush), but
> it is much more consistent and the tail latency is much better.
> 

It might be or not. Usually such things are more clear at scale in production
instead of benchmarks.

> >
> > This worked for zswap stats because their update and consumption are not on
> > performance critical code paths i.e. these are on the way to compress or
> > decompress or in reclaim context.
> 
> Well, decompression is in the fault path, that's performance critical
> to some extent (although not like other stats updated by networking).
> Anyway, I think the update path shouldn't regress much with the
> approach described in (c).

Decompression is on the scale of micro-seconds (and I suspect the simple minor
page faults are on nano-seconds scale) and the upward traversal is definitely
much cheaper and will be a noise there.

> 
> >
> > > but if we can get away with it, I think it will
> > > simplify things greatly and honestly rstat has been causing a lot of
> > > trouble in the last few years.
> > >
> > > But this can be done incrementally too, we can start by separating out
> > > the problematic stats to use the new update/flushing scheme,
> >
> > This I think we do need but for specific stats. I think the stats which have
> > in-kernel consumers need this. However not all such stats might be fine with
> > slow update side like zswap. So, we need to evaluate thoroughly.
> 
> I think in the proposed approach (c) the main concern is actually read
> latency, not update latency. So if it works for in-kernel consumers it
> should definitely work for userspace consumers as well?

Here I was mainly talking about consumers which has more strict staleness
requirements and those are mainly kernel consumers. Rstat flushing is definitely
more expensive than this for-each-cpu traversal and most of the time they just
need it for one or very small set of stats.

I am imagining once we have this special mechanism for selected stats, we can
potentially remove ratelimited flush and stats update threshold code.


