Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7F3B8407
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 06:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784095213; cv=none; b=fGocOXixmjd3WKG55A0T3/b54vfuqaTkrzch28hT8kBLFd1qI68Qu2ja00HujLUCr8pZZG9Gp7I0OnUtg+9KAmg44lZR1LK4Ev6/OmT6s/nL1AqG+p9HkkPyrPwUovAvTO87qSx7jiifJvgJLxxTnvc0ujTvt0XpOaHdZRHu/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784095213; c=relaxed/simple;
	bh=eSNsvkcvE6JKJNwmVFw3JfTZhkZlxVISlOSZiTBrCyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+8ayKK9J/EAi1xUeleD5r9AP2lsn+QvY8hjYUBbX3L3EM2mPQtDAfARBXvFpY5T3JjDV0mht65ck6SNqv6OLeEFvSODMkl7tLSfeGWo6vmnJlQAzs1di0sntWxehRLCVUzt1pXrO7pibN6yAwcRyHWnbL3VticBgNXhMUlGTGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.53 with ESMTP; 15 Jul 2026 14:57:53 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 15 Jul 2026 14:57:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 15 Jul 2026 14:57:53 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alawYov0c7a0Q6_l@linux.dev>

On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> [...]
> > >
> > > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > > requirements for that?
> > 
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
> > 
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap. 
> 
> Default tier if zswap is configured makes sense. Should zswap be treated as
> having 32767 (or maybe 32768) as priority as it sits infront of all swap
> devices today? Also whichever swap tier has priority range containing 32767,
> will have zswap in it.

Maybe we can handle zswap as an internally reserved tier which is always
preferred over swap devices.

I do not think there is a strong use case for grouping zswap together with a
swap device that happens to use the highest priority. Also, using a visible
priority value for zswap may have a small side effect that one priority value
effectively becomes unavailable to users.

That said, if zswap is represented as a tier, I agree that it should be the
top tier. The exact priority value or whether it is internally reserved should
be adjustable when we implement it.

> > We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
> 
> Do we need to do anything explicitly for this? I am assuming in a kernel with
> swap tier support, there always exist a swap tier if there is even a single swap
> device configured i.e. a tier with the full priority range.
> 
> > 
> > I think this should be enough to support "zswap" as a tier and allow
> > disabling/enabling zswap per-memcg (or globally?) through tiering.
> > 
> > In the future, if/when swap demotion is added, we need to figure out
> > how that would work with zswap. For example, if pages should go to
> > swap device A then swap device B, then an entry in zswap using a swap
> > slot in device B should not skip device A and be written back directly
> > to B. vswap would naturally give us a solution for this problem.
> 
> This seems reasonable to me. Punting demotion/writeback to future.

I agree this is reasonable. I can treat the demotion/writeback interaction as
future work and follow up separately.

> Youngjun, what do you think? Is this reasonable amount of additional work or do
> you envision some complexity here?

I sent a note with some thoughts about making zswap a tier. Since Chris also
raised concerns around this area, I think it would be better to discuss it a
bit more and evaluate the details carefully.

At this point, there does not seem to be an immediate use case that requires
zswap tiering in this series. So my preference is to keep this as future work
for now, and follow up with an RFC after verifying that introducing zswap as a
tier on top of this patchset does not cause problems.

Thanks,
Youngjun
