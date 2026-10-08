Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C3047D477;
	Thu,  8 Oct 2026 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452383; cv=none; b=u6UeN+reIwZH739HBEX66uxC1GyEuyf7fDT2R3bXQ6qG2D2c7YTercYpytaGbdn+kZI4EOL/koiPfiBD1OoQshGhGshumwG29z3el5JDzbCGuZOyjLjrZjTFpQQJy4S2gr3P9CydU5E7+90j/7iy6fqUwtMo99ZoeoIfzyqrw3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452383; c=relaxed/simple;
	bh=JiikRSQcRMKViLurKtaeEtPPp4n+9wSR+dYlqCVdtOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f5q+atnJY5P0NuZni9aiDkoFVmLO0y9pbpBenuqdjxlJ2X1FoZTU5iH3flXnfRTf7rdZA22K//utyRK1HaTc+YVVCAaa1zacktsRYLVeEJs74rHmDdBvw6FnHt599aDn2KDAUqJANPsbiC39VlrrSSHIuW3MBB6iBh0DRWh0iIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=usSYJIdZ; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="usSYJIdZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791452375; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4IJ4lYBRnOH1ELDqm8p1BYesqSHem4oJyVkCQ2OMYXU=;
	b=usSYJIdZoezjfGixiBtwdBpx5hLTKNC8coFxvrI7frm3yjsAMoaT5p9f5j2jU5iS/c1oBVjoGO8gQp4kkzw8TKhFqN8ojKXfRtZOfV0xesjuZsXxvJtSf+3vVSOqXNiE/EUMjiAAnvMEGfiRGLRVNNDKnVo81aZYQxrTAdlxgoE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XCNdeuW_1791452367;
Received: from 30.178.85.189(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCNdeuW_1791452367 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 17:39:33 +0800
Message-ID: <01f89ece-9d46-47f2-b660-d32ab5d32923@linux.alibaba.com>
Date: Thu, 8 Oct 2026 17:39:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: memcontrol: drop kmemcg_id and use
 mem_cgroup_id() for list_lru indexing
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
 <20260910080722.3961351-2-qinyuntan@linux.alibaba.com>
 <CAMgjq7DkLi7aPLRyGv__f6NLPkRHY=0Fw0kLEdevnoTFpqsbzw@mail.gmail.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <CAMgjq7DkLi7aPLRyGv__f6NLPkRHY=0Fw0kLEdevnoTFpqsbzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/27/26 4:29 AM, Kairui Song wrote:
> 
> Hi Qinyun
> 
> With this commit, my arm64 VM hangs at every boot with a
> 100%-reproducible infinite loop in xas_find(), driven by
> the dcache shrinker during the first remount of the root filesystem.
> Reverting this fixes the issue:
> 
>    CPU: 2 UID: 0 PID: 579 Comm: mount Not tainted
> 7.3.0-rc4.orig-00725-g09d9672a5d4f #33 PREEMPT(full)
>    pc : xas_find+0x184/0x1c8
>    lr : xas_find+0x6c/0x1c8
>    Call trace:
>     xas_find+0x184/0x1c8
>     xa_find_after+0x88/0x120
>     list_lru_walk_node+0xc0/0x2a0
>     shrink_dcache_sb+0x80/0x130
>     reconfigure_super+0xc0/0x1f8
>     vfs_fsconfig_locked+0xa8/0x120
>     __arm64_sys_fsconfig+0x280/0x33c
> 
> Just for reference, this also fixed it:
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 7dbb6125cb1d..42c48c3b9235 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -427,13 +427,13 @@ unsigned long list_lru_walk_node(struct list_lru
> *lru, int nid,
>   unsigned long index;
> 
>   xa_for_each(&lru->xa, index, mlru) {
> - rcu_read_lock();
> - memcg = mem_cgroup_from_private_id(index);
> - if (!memcg || !mem_cgroup_tryget(memcg)) {
> - rcu_read_unlock();
> + memcg = mem_cgroup_get_from_id(index);
> + if (!memcg)
>   continue;
> - }
> - rcu_read_unlock();
>   isolated += __list_lru_walk_one(lru, nid, memcg,
>   isolate, cb_arg,
>   nr_to_walk, false);
> 
> ===
> 
> And BTW cgroup ID lookups seem much heavier, not sure about the
> performance impact.

Hi Kairui,

Thanks for tracking this down. I missed the reverse lookup in
list_lru_walk_node() when switching to cgroup IDs. Your change fixes
that mismatch.

There is a catch with mem_cgroup_get_from_id(), though: it calls
cgroup_get_from_id(), which only looks up cgroups visible in the
current task's cgroup namespace. Here we need to walk all memcgs
on the LRU, including those outside that namespace, so we need
a lookup without that restriction.

Thanks,
Qinyun Tan

