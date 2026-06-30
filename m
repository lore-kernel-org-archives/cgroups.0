Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2C23393E
	for <cgroups@vger.kernel.org>; Tue, 30 Jun 2026 10:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816306; cv=none; b=dMnXXhAhBSSK1mtNm0ppZKQS/8VpfJTePvQJlq8j3Yta3tuhUKQZhG1m8QJ2pQn9e/EeSoT+5qpTnx1SkBpFWdOQScqs1rINRg/G4Vq7FFNCz4MqBAJ4gDUqoAZxgBL9rhHvkuvj9ldtNSl8oSxLOrK8Lvy7qKgjRiCE9VQ/vjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816306; c=relaxed/simple;
	bh=dNUphZ+P4RvXzyL7+wp/p1ux06KtBOrOaXVEx+ZdBhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IS4XUQdKUgHGdBZTNN6L0DNn1FJ9/4sEp0rAWoxkuOX68wdt5rxqtO08QEDbZuWQVA4IPxUZYA90vCO7vKd0nYVOl3NSCrg3V+JJV1nbExHCBCVONB5CFG4vBr+TM+P+NDDqSoxjR5IKCEAEywvfkdGEV/Zw12tRtkBjuEMbjX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XHYswoBS; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XHYswoBS"
Message-ID: <eb3a62d5-5fff-4da5-a211-860ef0d4aec2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782816292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLRS7nAqGz48MGg7TIU1nka9vUVrVauvgr4FneekIG0=;
	b=XHYswoBSXYGhbmC1LEOvVbk31oj5YII1IAkDH1/MNafvK9SSO+2C3YK+RXrk58DYfS0Qqk
	/hV+o5FnPxzg+bukyKwurLyVJoggsDPxUfLg5OtO2GvxzyvipgtJydSRyPut3qdySn74/z
	f+OCW7UiVu659VzjphMQfSqJgWb0NcA=
Date: Tue, 30 Jun 2026 18:44:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: reset zswap settings in css_reset
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260630100832.107062-1-jiayuan.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260630100832.107062-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 6/30/26 6:08 PM, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> mem_cgroup_css_reset() is called when the memory controller is disabled
> on a cgroup but the memcg cannot be destroyed because it is pinned by a
> subsystem dependency -- for example, the io controller declares
> .depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
> and the css is hidden rather than killed.
>
> The purpose of css_reset is to revert the memcg to its vanilla state so
> that no policies are applied and the css can be safely made visible again
> later.  Currently, all page counters (memory.max, swap.max, kmem.max,
> tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
> reset to their defaults, but zswap_max and zswap_writeback are not.
>
> These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
> zswap_writeback inherited from parent) but were missing from css_reset.
> As a result, stale zswap policies remain in effect after css_reset: the
> zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
> zswap_max limit, and the writeback path continues to honor the old
> zswap_writeback setting, even though the memory controller has been
> "disabled" on this cgroup.
>
> Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
> their defaults in css_alloc.
>
> Test:
> 	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control
>
> 	mkdir /sys/fs/cgroup/test
> 	mkdir /sys/fs/cgroup/test/child
>
> 	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
> 	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max
>
> 	# child/memory.swap.max and child/memory.zswam.max disappear
> 	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
>
> 	# re-enable memory control
> 	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control
>
> 	# before this patch
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    8192
>
> 	# after this patch, same as memory.swap.max
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    max
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>   mm/memcontrol.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d20ffc827306..eeeb22a5e8cc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>   
>   	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
>   	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
> +#ifdef CONFIG_ZSWAP
> +	memcg->zswap_max = PAGE_COUNTER_MAX;
> +	WRITE_ONCE(memcg->zswap_writeback, true);
> +#endif
>   #ifdef CONFIG_MEMCG_V1
>   	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
>   	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);


https://sashiko.dev/#/patchset/20260630100832.107062-1-jiayuan.chen%40linux.dev

Ai is right...


Also I'm thinking that should we add a helper instead of using open code 
in css_alloc and  css_reset ?


static void memcg_zswap_reset(struct mem_cgroup *memcg)
{
#ifdef CONFIG_ZSWAP
     WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
     WRITE_ONCE(memcg->zswap_writeback, true);
#endif
}

mem_cgroup_css_reset()
{
...
memcg_zswap_reset()
...
}

mem_cgroup_css_alloc()
{
...
memcg_zswap_reset()
...

}



