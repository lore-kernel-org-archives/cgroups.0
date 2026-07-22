Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0B23624C5
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 01:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784682730; cv=none; b=hBHYUVR8wZyAWgg4cJxxgIn1pElVjjc7M8CfSAmRZovG6XhMRYwDJaBty9aTJKJYI9OKQmPU9LH4Gsabdkrkqdlxgqj6Bqm6fw9rxd/kp2dJDTl0dS0/KJgzApPnY4K++RhggZ6lxajhgc04bnEu99Mqki6D8iUKXseRtQ2FKl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784682730; c=relaxed/simple;
	bh=gXvP8zUBWfvsLTJXEW7O+4RlG9hwQmEK+fDObyNztPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8fMgbf41KvLOt5+qDz0BanGKHwFGN2ZVOjzgV8/vKf0C8JMrmkdYERtPJfMGXO1FdcGFfO31ND8OmolYqywtDIcxcQDv7spmSy56gSnwIT0e5sJu/r7RzsNWY368REd8QVIpF8jLouJY3uEAzwT3SoesEmOv8mwl+lvM0e8btg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GxOwvukR; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GxOwvukR"
Date: Tue, 21 Jul 2026 18:11:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784682712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPeWjqbBuNWvil2Wi1GbJzxHLNLfXAIIvk3axfPdvVE=;
	b=GxOwvukRpoFyR8PdP9f5TWXO15pCgm937M4Z1QA4Bz+5Po0vKLHau87RH8cURsoyLnX3e/
	/rQEhdPoJlOjrBDww2yRH0QVuvc9jZCtPjQkjFIL3MbP1o0ljrhhvh3FIXKP3MASNq90zn
	mQx97xDidduv6eGu9uNqBsT+dfH5bP0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, 
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amAYvvTtg8QLyInH@linux.dev>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
 <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 11:27:56AM -0700, Yosry Ahmed wrote:
> > Hello Yosry, Shakeel,
> >
> > I have been working through this in detail at the implementation level.
> > For now I am adding on/off control of zswap through the tier interface.
> >
> > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > disabled, nothing happens to the existing swapped out pages in this
> > > tier, but new pages do not get swapped out to it. This is the same
> > > behavior that happens if zswap is disabled at runtime.
> >
> > This part works as you described, with no real issues.
> >
> > > From the tiering perspective, we need to accept "zswap" as a possible
> > > tier, or maybe creating it as a tier by default if zswap is configured
> > > would be better to avoid handling the case where the user doesn't
> > > create a tier for zswap. We also need to disallow zswap being the only
> > > tier as that combination cannot work without vswap.
> >
> > I tried to forbid this at the implementation level as you suggested
> > , and that is where I ran into trouble.
> > A few code paths can end up with zswap as the only
> > tier, and they are awkward to handle.  Below is each case and what
> > handling it would take:
> >
> > 1) A write turns off the last device tier while zswap stays on.
> >    -> rejected with -EINVAL.  The write does not take effect.
> >
> > 2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
> >    -> the file goes empty, so zswap is not shown either.
> >
> > 3) A cgroup has zswap and one device tier on, and that tier is removed.
> >    -> the cgroup's zswap entry is reset to 0, which the user never
> >       asked for.
> >
> > 4) A cgroup has zswap and device tiers on, and swapoff empties them.
> >    -> the cgroup's zswap entry is reset to 0.
> >
> > So the problem is that in (3) and (4), memory.swap.tiers.max has to
> > change on its own independently of what the user wrote
> > and it is not like just error handling situation as (1).
> >
> > There is also a consistency point.  memory.swap.tiers.max already
> > accepts a child enabling a tier that its parent has disabled: the write
> > succeeds, no error is returned, and the difference is resolved
> > internally.  The user's setting is kept as written, and only the
> > effective behavior is constrained.  By that logic, accepting a
> > zswap-only setting and guaranteeing only that it cannot do anything
> > would fit how the interface already behaves.
> >
> > Having thought it over, I think one of these two directions would be
> > better than enforcing the rule as above.
> >
> > 1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
> >    work without vswap, so today the setting does nothing and there is
> >    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
> >    own, with no interface change needed.
> >
> > 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
> >    track the user-set and the effective-set separately.  Exposing
> >    the effective one would show that a zswap-only setting is not in
> >    effect, giving the user visibility instead of rewriting what they
> >    wrote.  It would also help the parent-off/child-on case, where the
> >    child could see from the effective value that the tier is off.
> >
> > What do you think? or any other ideas?
> 
> Hmm yes, seems like enforcing this rule comes with a lot of complexity
> for little gain. It's possible today to enable zswap without adding
> any swap devices, which would render zswap useless anyway. I suppose
> in the same way, we can just do (1) and allow users to disallow all
> tiers except zswap for a cgroup, which would effectively disable zswap
> in the same way (albeit a bit less clear). We can document this
> clearly in the memcg docs.
> 
> Shakeel, any objections to this?

Nopes, no objections.
