Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0C3B3C03;
	Thu, 13 Aug 2026 09:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786613254; cv=none; b=O5YD3crj6XtY/BaKyZLZBdxioAgMIZ/LQQAQTmFi4R2NGeAcqckftoK5nzlbAzOcSjd/JnBP57V/Pq3Uuts3ESxN1Yv4QItlGOnrxJPoa1YdhzH4HMjGr/6iEgT3UCnDjGKmKcNBU39gnYhWtUYYzw0WnMryx/8zwpYErHrFF8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786613254; c=relaxed/simple;
	bh=EKKHgSs8yZh6+u9oH06JQBe1jVKZ/DCCbiTqpOIy7QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0WjLrLO1bfoehC4CVYjeigzz6C2pNJHqrjxH6tBePPTIrXswAJ4jzG7cywZhah1kBpV1vjrMjCnfOji+qeFlV2XNvNLzkUWUayJiw8S06Yf65f88h50q2pWxzjjcEneoCxS+HYqz/vH5t/MsacTYOvoYMundwoeT0fPo1IKCiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKKP0aaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKKP0aaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3771F00A3A;
	Thu, 13 Aug 2026 09:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613250;
	bh=J0WfG9LtUU7qIATkbY9c7VbNU4tFX7Iam6iBGsEbqBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fKKP0aaflcesVE16gmCdIUQZXRadXKPNnorPID/XlTMeQNeLHsIR28CRvP+c6tv0J
	 GiCgXFFIpH2jQffDALJEoRKtEpNvFEK/wsgTFqXso/t6JYdOaw2xjsePWdkwspBvrk
	 LAcdnbsVjFw2Rq9h4BiQ69Sk4X/EaJA7hQhJhbvTOuMR9DA8JqwLBB99tjjrjz34o6
	 D8XYz0iZ4U515IRFaGmbyVSZ6WyRGrmMhaMfYv25FKZTceSb2wGwabvOSN6HmubtGj
	 ND6iPTXtl32xcMeLHue7tZns05qcKFHWgznrw+8cFKUft+K5WGYP2xuRtxkRyswykU
	 0DapLWAEcv6qQ==
Date: Thu, 13 Aug 2026 10:27:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Message-ID: <an2HYmJ57BCY_Zwt@lucifer>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>

On Tue, Aug 11, 2026 at 01:31:54PM -0700, Shakeel Butt wrote:
> Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
> reclaim is the only thing that runs shrink_lruvec() from kswapd with a
> target memcg set, and thus the only way kswapd can reach
> lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
> mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
> reclaim. Do not reuse for anything else." comment and a priority hack,
> and it simply never got taught about MGLRU.
>
> Rather than teach it, let's delete it. The v1 soft limit was deprecated
> in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
> soft limit"). Nobody has reported depending on it in the ~21 months
> since, and v2 has covered the same ground for a long time with
> memory.low and memory.min.
>
> Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]
>
> Shakeel Butt (9):
>   memcg: make the v1 soft limit knob inert
>   memcg: remove v1 soft limit reclaim
>   memcg: remove mem_cgroup_shrink_node()
>   memcg: remove the soft limit reclaim tracepoints
>   memcg: remove the soft limit rbtree
>   memcg: remove lru_gen_soft_reclaim()
>   memcg: remove the per-node soft limit tree fields
>   memcg: remove mem_cgroup->soft_limit
>   memcg: simplify v1 event ratelimiting
>
>  .../admin-guide/cgroup-v1/memory.rst          |  49 +-
>  include/linux/memcontrol.h                    |  27 --
>  include/linux/mmzone.h                        |  30 +-
>  include/trace/events/vmscan.h                 |  14 -
>  mm/internal.h                                 |   4 -
>  mm/memcontrol-v1.c                            | 435 ++----------------
>  mm/memcontrol-v1.h                            |  12 +-
>  mm/memcontrol.c                               |   7 +-
>  mm/vmscan.c                                   |  96 +---
>  9 files changed, 66 insertions(+), 608 deletions(-)

This is a gorgeous diffstat :)

Obviously not my area but looking over it, all LGTM so feel free to add:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

To the whole series!

>
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo
