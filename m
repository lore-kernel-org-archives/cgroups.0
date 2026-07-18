Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBCB33EB10
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784387473; cv=none; b=uV/d4zfAwI/MLIk4U0Bb2KUqLVmKFH/wuPHCWjgflgzmMI6LVGfzKc2VzG0ucXqBINukWRvsw2SZKp5szVi47rk/p973bMk/do6aw3jmRv06k2f9x3CZZXFMDsBj57lEm+f5xCL+mX+Xpj9Gcmrw2wjM3OvJiBleUN8p7jdCmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784387473; c=relaxed/simple;
	bh=kTGUFkMiJqILH3IybAbG6mjkOK9DV6hwEq2BK6RKSmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DDxy1bdZoU5nTrlS162W+ZKstWDxnfQSU4/UCkDJjgIzmautJWVELKLooI9kAcDfDCBOZOoTy1JbHugzM+n3LzrYuwz8/23l0g6KiLZ/u+8H1y0dzqVb6Qy4WY8AILZeCxncoeFx20t/fv7wwwTem43Fhsq9HipYj4n9FQ2Z2QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 19 Jul 2026 00:11:02 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 19 Jul 2026 00:11:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 19 Jul 2026 00:11:01 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>

On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > >
> > > > > Hello Yosry!
> > > > >
> > > > > This series does not cover zswap as a tier yet.
> > > > >
> > > > > My plan is to land the swap tier infrastructure together with the
> > > > > first use case (cgroup-based swap control) first, and then follow
> > > > > up with zswap tier support in a subsequent series, continuing the
> > > > > discussions we've had above.
> > > > > (I mentioned on cover letter, right above the overview section)
> > > > >
> > > > > Does that approach sound reasonable to you?
> > > >
> > > > How does swap tiering work with zswap in the current series? I assume
> > > > zswap is just enabled for all devices in all tiers?
> > >
> > > Yes, that's correct.
> > >
> > > > I wonder if introducing zswap as a tier after the fact changes user-visible
> > > > behavior. I guess if zswap will be introduced with a default "max"
> > > > value it will more-or-less be the same behavior,
> > >
> > > Right, that's the plan.
> > >
> > > > but I would check all
> > > > user-visible behaviors related to zswap (e.g. interaction with other
> > > > zswap interfaces) to make sure nothing breaks or changes in a
> > > > meaningful way when zswap is introduced as a tier later.
> > >
> > > Fair point. Let me review this more and get back to you!
> >
> > Please do report back what you find.
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > requirements for that?

Hello Yosry, Shakeel,

I have been working through this in detail at the implementation level.
For now I am adding on/off control of zswap through the tier interface.

> From zswap's perspective, we just need to skip zswap is zswap as a
> tier is disallowed. Could just be a check in zswap_store() similar to
> the check if zswap is enabled. I am assuming that if a swap tier is
> disabled, nothing happens to the existing swapped out pages in this
> tier, but new pages do not get swapped out to it. This is the same
> behavior that happens if zswap is disabled at runtime.

This part works as you described, with no real issues.

> From the tiering perspective, we need to accept "zswap" as a possible
> tier, or maybe creating it as a tier by default if zswap is configured
> would be better to avoid handling the case where the user doesn't
> create a tier for zswap. We also need to disallow zswap being the only
> tier as that combination cannot work without vswap.

I tried to forbid this at the implementation level as you suggested
, and that is where I ran into trouble. 
A few code paths can end up with zswap as the only
tier, and they are awkward to handle.  Below is each case and what
handling it would take:

1) A write turns off the last device tier while zswap stays on.
   -> rejected with -EINVAL.  The write does not take effect.

2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
   -> the file goes empty, so zswap is not shown either.

3) A cgroup has zswap and one device tier on, and that tier is removed.
   -> the cgroup's zswap entry is reset to 0, which the user never
      asked for.

4) A cgroup has zswap and device tiers on, and swapoff empties them.
   -> the cgroup's zswap entry is reset to 0.

So the problem is that in (3) and (4), memory.swap.tiers.max has to
change on its own independently of what the user wrote 
and it is not like just error handling situation as (1). 

There is also a consistency point.  memory.swap.tiers.max already
accepts a child enabling a tier that its parent has disabled: the write
succeeds, no error is returned, and the difference is resolved
internally.  The user's setting is kept as written, and only the
effective behavior is constrained.  By that logic, accepting a
zswap-only setting and guaranteeing only that it cannot do anything
would fit how the interface already behaves.

Having thought it over, I think one of these two directions would be
better than enforcing the rule as above.

1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
   work without vswap, so today the setting does nothing and there is
   nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
   own, with no interface change needed.

2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
   track the user-set and the effective-set separately.  Exposing
   the effective one would show that a zswap-only setting is not in
   effect, giving the user visibility instead of rewriting what they
   wrote.  It would also help the parent-off/child-on case, where the
   child could see from the effective value that the tier is off.

What do you think? or any other ideas?

Thanks,
Youngjun
