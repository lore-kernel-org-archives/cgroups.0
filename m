Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193A748B385;
	Thu, 11 Jun 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199908; cv=none; b=VzEREAAgZZln3BkSl/ht/lg5KT4msYh3LkgX7DxBVvyQPScjqZHTePi9MPP8GYlRGy1vYC/fHIsKDdXZJdkCiBoBa8wtd3PONh6ZCBReW3gHdvaV5FN3XVPt0CFhAgB4rJl8mg2JJ3u4FyGEDeuXGZqwEtHHcAt1qxdzM0hCd+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199908; c=relaxed/simple;
	bh=0vBiCAY1y31EICrgx65F0heV7GNSgHg52mARy3JPODg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBWXg4IxuwfapfdA3RgQZZ6iemxhdvu33u6bCNeorMPCf0H8ZG7RN8s6PhKHbCglFhiRwRzPQHp2gEZ8jHDYUfAOM/ro4nCJL4IfFzerrclQuwADzgg8SqqhRLetCahOdgINEvs2WXXhBeWxmmg2cDyQeO9OJXN5GJLtwMn4zdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLvD1dja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLvD1dja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CCE1F00893;
	Thu, 11 Jun 2026 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781199907;
	bh=y8cxqvFMDkblWaaUu15Mc6reR5WFsyNDXWf8l/ksL/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PLvD1dja2zpwPeg3XS5BQsZ1Ozpipc8Xk4694DeZWeAkXOqUza9BthUuNRHH5iiz9
	 d/UkZONrEgpHIPrtRY8wUZ2xc0MrCunp/dn7DpCChmOToGAc8HDCUpvzIU6fHDkGh3
	 /MxJqjk1oULyhbETFfuTD4BncjvhVYKmmuT1M8AZkHGK0FAqan6zklx4pgEg/YK5f5
	 c9k6QFnMWdZtvNg0y5Y/TvJiV6j/k00MtSfMB5J4j0FXyNAso7w0suH2MJILUIMnVn
	 gtWdG8vSAahiQEDTTrE/ZxJAhQK4L9Rrl+y+7g/b589PBI/XGkWA8cPf2nzt9huMHm
	 IDiCU/i8FOMKQ==
Date: Thu, 11 Jun 2026 17:45:04 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, 
	chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <airzE7jD9UtyR17J@google.com>
References: <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>

On Tue, Jun 09, 2026 at 01:19:13PM +0900, YoungJun Park wrote:
> On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:
> 
> +Chris +Kairui +Baoquan
> 
> Hello
> 
> Thanks for inviting me to the discussion, Shakeel.
> 
> > > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > > to lower tier swap. What would be the appropriate interface?
> 
> Speaking of my work on swap tiers, I recently submitted a patch and am
> currently considering memcg integration:
> https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/
> 
> The future use-cases imagined above seem to align with this
> direction. (BTW, I am currently waiting for reviews/feedback from the memcg
> folks on this patch. Any reviews would be highly appreciated!)
> 
> We could potentially assign a target tier
> for writeback within the existing memory.zswap.writeback interface. 
> 
> For instance, '0' could mean disabled, while non-zero values could represent
> specific tiers, which would maintain backward compatibility with the current
> version. Alternatively, if zswap is treated as the default top tier, 
> the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.
> 
> Furthermore, this could be expanded so that each swap tier can demote data
> user-triggered demotion between swap tiers.
> 
> Based on the current patch's ideas combined with my swap tiers concept:
> 
> Assuming a hierarchy like:
> zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)
> 
> We could configure the active tiers via a setting like `memory.swap.tiers`
> (tier2 enabled, tier3 enabled).
> 
> For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
> could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
> to explicitly trigger demotion from tier2 to tier3.
> (BTW, if we combine these features, my personal preference for the keyword
> format would be `<size> <demote_prefix><tier_name>`. I think it would be
> better to explicitly indicate that it is a swap demotion by using a specific
> prefix followed by the tier name. 
> Or make demote prefix another key is also possible)

I am not sure if proactive demotion between swap tiers would be driven
by memory.reclaim, I am guessing a new interface might be more suitable.
But yes, you are right that it's very possible that
'zswap_writeback_only' with memory.reclaim will become obsolete once
swap tiering matures and starts supporting things like proactive
demotion.

Part of me wants to wait until the swap tiering interfaces are figured
out so that we don't end up with redundant interfaces, but I also don't
want to hold Hao's work since it doesn't directly depend on swap
tiering.

Shakeel, how do you want to handle this? I think there's a few options:

1. Add zswap_writeback_only now, and when we have swap tiering demotion
it becomes a redundant interface, like memory.zswap.writeback -- or
maybe we try to deprecate both of them at that point. It's difficult to
remove interfaces tho, but maybe easier to stop supporting
zswap_writeback_only.

2. Add zswap_writeback_only behind an experimental config option, to
unblock development but have a line of sight to dropping support once we
have a swap tiering interface.

3. Wait until we figure out the swap tiering interfaces and then add
the proactive zswap writeback as part of it.

WDYT?
