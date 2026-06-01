Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C0B640
	for <cgroups@vger.kernel.org>; Mon,  1 Jun 2026 03:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780285825; cv=none; b=gcNzokUXTLAsoLno27rPzLkTPGPq2lYlTk35OhbU7Gotab0in9+S6X3X4FoX8hlt7FW4xEzeo+sy7Wpg7Qk6OE7jo2sdWpgYzvNDF2ZsVkwFpdbc23A647jYuUK8vHYEwPaAjIR7TQQhOvoUsWuNu7EMCfTZvBMBVT006nhl6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780285825; c=relaxed/simple;
	bh=XQ6hhmtg/cGGAvDtwL2UHOvRcakPJlj+X1VT9QS6kV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0NQ2IsGiW0sKwbY8+Lf1U2c/qjrCmB8cas1p2rn29Ro+pQ5PsGsbaoruEv/m2y4I4x1+fNw30wE6sdSyxwpjORKqsmK5ybMIcFVqR9gxTzCNsFyGRHk5RwrWDYOHDop1imFFo3GSp+oOx8ErV/OsBgPBuZYRTzRU1vpamwEOKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Jun 2026 12:50:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 12:50:21 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ah0BfRFv285gWph8@yjaykim-PowerEdge-T330>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527062247.3440692-5-youngjun.park@lge.com>
 <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
 <CAKEwX=N2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRvU_6YFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=N2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRvU_6YFw@mail.gmail.com>

On Sat, May 30, 2026 at 11:21:12AM -0700, Nhat Pham wrote:
> On Sat, May 30, 2026 at 10:51 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> >
> > How expensive is it to add per-cpu caching for each device :(
> 
> to clarify - a percpu_swap_cluster per si for every si.
> 
> >
> 
> ... or for each tier (assuming devices in each tier share the same
> performance characteristics, and could be used interchangeably?).
> 
> Basically:
> 
> struct percpu_swap_cluster {
>     struct swap_info_struct *si[MAX_SWAPTIER][SWAP_NR_ORDERS];
>     unsigned long offset[MAX_SWAPTIER][SWAP_NR_ORDERS];
>     local_lock_t lock;
> };
> 
> Seems like 4 is the default number of tier right? So the extra
> overhead is just (nr cpu) * 10 * 3 * (sizeof(unsigned long) +
> sizeof(*ptr)) or wev?

I agree. I actually considered the idea of a tier-centric cache as well.

You might remember that in the previous "per cgroup swap priority"
patchset, I implemented per-cpu caches per priority, which is essentially
the same as having them per tier.

However, as you agreed in another thread, including this optimization
right now might be a bit premature. If the core swap tier idea gets
merged, I plan to explore this optimization further as follow-up work.

Thanks
Youngjun Park
