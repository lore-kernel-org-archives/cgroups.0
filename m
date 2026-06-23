Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1821F37AA77
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 01:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178197; cv=none; b=I9pm+MZpVOLQnqYvOMv1QWj/qodWw4BBkozjL5dUjt33xyP8jvBIsvmEFMnw49kKKLcsMWumu0loQ/QpWwx1WDqw3/cxZ7LUzm7NdL6ybzCXNrYz5Z/KbwhGz7ggSQcLguYDpNB+rpC2YO7VnbEXggJW/pGQnsJCY0LXRh5RXd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178197; c=relaxed/simple;
	bh=g7AnO37BBHfkf4A/3eaC+5htqNFLtJU5lOEv/R0NBFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADLchOb5ZbjBYe8RNC2g+bZmhouBwvPgIrlylEUji3JfDRiTwzai6ZGLx5oeDC2yPmrvQTrQi2RPphmMd+xgCqvn21C8r7+YhQn4u97N3e/yQQkUjCuUBAbM+XPlqbWWS7kg6k88SmKYcM9bg5ZlLIbHDuDRd0caGhjiV3SxoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 23 Jun 2026 10:29:52 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.126 with ESMTP; 23 Jun 2026 10:29:52 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 23 Jun 2026 10:29:52 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <ajnhkK/dT4MsqyAR@yjaykim-PowerEdge-T330>
References: <20260620181635.299364-1-youngjun.park@lge.com>
 <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>

On Mon, Jun 22, 2026 at 02:23:40PM -0700, Yosry Ahmed wrote:
> On Sat, Jun 20, 2026 at 11:16 AM Youngjun Park <her0gyugyu@gmail.com> wrote:
> >
> > This is the v9 series of the swap tier patchset.
> >
> > The main change in this version is the addition of selftests for the tier
> > interfaces, requested by Nhat; see the changelog below for the other changes.
> > I designed the test cases and wrote the selftests with some AI assistance.
> >
> > For context, the bulk of the series is unchanged since v8, with great thanks
> > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > The main change in v8 was the interface change to use memory.swap.tiers.max
> > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > by Shakeel and Yosry.
> >
> > This change allows for future extensions to control swap between tiers and
> > aligns better with existing memcg interfaces. It is confined to patch #3's
> > user-facing interface; internally, patch #3 still uses the existing mask
> > processing method, which is implementation-efficient.
> >
> > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > valuable feedback.
> >
> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Tiering applies only to the vswap + zswap combo. Zswap itself will
> >   not be tiered, as the current architecture requires a physical device
> >   for zswap allocation.
> 
> I thought we agreed that zswap should be a tier, so that proactive
> zswap writeback can be implemented as proactive swap demotion?
> 
> The only restriction we talked about is that zswap cannot be the only
> allowed tier as long as vswap isn't supported. We can lift the
> restriction when vswap support is added.

Okay, I misunderstood that part. Thanks for the clarification.

To summarize our agreement.
zswap can be the first tier regardless of vswap support.

- With vswap: zswap can be the only allowed tier, as it can operate
  independently.
- Without vswap: zswap cannot be the only allowed tier, as it cannot
  operate without a physical backing device.

I will proceed with this understanding.

Youngjun Park
