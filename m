Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C225215075
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 01:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769235; cv=none; b=h8w+glpFQNTiH3KT1IRN4N7ijljpQBqmj1FCE725J8XGDfSAfndEv7b0V3jMCrtFfjeB0B1ERWeuzNYd9ozGSdKa5H/2fKT37MSabCgXdRfgtZzz1KM3/NbuwModoNxtb5jx4nB/N4RJwhZUAdMbUfajKjReOj8IXSkj8trCRAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769235; c=relaxed/simple;
	bh=/nhkOldcCvYMZ0Ts7Mcn7UWfcpwoVFPh5RDHNQAa1UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mQIqz9MDdUZE84M2FdTxYXWQujJrYQhMLvfnveT7U2Al/cruluCoUv1h02OI2vnG/XFV5iMw7uUKfi8GmqgoeYi+G8241/0G/HQv3rLwyXfhwB+nzIDK7EwDUQ3eyrROXp0Xu/aZgPlPNuKDu7AJFgjLeGGQ1qR4mXRiPjg6S+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bskeKuKG; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bskeKuKG"
Message-ID: <56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784769230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqNPZ++8/uzCmzQsC8MgE2wyP7W/2GXyiU7cXbmcOW8=;
	b=bskeKuKGJ4kcPI7CmZVDz7xoLlSOlfro5IKUZ0uYqemob74+vxEpG74CfrmuOOzhzNzPy4
	juNUddmSm5vkdzykw3SlkghDJXoO1nNLFGTGj7K+aXQmOuFA6vJLA3D/94cz/J2qbZe6c7
	djI04q3D8QwLcg9LqtnW90Y4dcTir1Q=
Date: Thu, 23 Jul 2026 09:13:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/2] mm: fix node reclaim swappiness handling
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong <chenridong@xiaomi.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260716031729.1064007-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/16/2026 11:17 AM, Ridong wrote:
> From: Ridong <chenridong@xiaomi.com>
> 
> The per-node proactive reclaim interface
> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
> 
> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
> This is a prerequisite for unifying sc_swappiness().
> 
> Patch 2 consolidates sc_swappiness() into a single definition that works
> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.
> 
> ---
> 
> v1 -> v2:
>   - Move mem_cgroup_swappiness() and vm_swappiness to mm/swap.h instead of
>     include/linux/memcontrol.h. Suggested by Barry Song.
>   - Correct fix tag for patch 2.
> 
> v1: https://lore.kernel.org/all/20260711091157.306070-1-ridong.chen@linux.dev/
> 
> Ridong Chen (2):
>    memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
>    mm: vmscan: fix node reclaim ignoring swappiness parameter
> 
>   include/linux/memcontrol.h |  4 ++--
>   include/linux/swap.h       | 19 -------------------
>   mm/memcontrol.c            |  4 ++--
>   mm/swap.h                  | 20 ++++++++++++++++++++
>   mm/vmscan.c                | 19 +++++++------------
>   5 files changed, 31 insertions(+), 35 deletions(-)
> 

Hello all,

Can this series be applied?

Just a reminder in case this gets buried.

-- 
Best regards
Ridong

