Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256B326C385
	for <cgroups@vger.kernel.org>; Tue, 19 May 2026 03:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779161774; cv=none; b=dEw1tdrVQU26ID8A6bgonwjw9xsyckrCgYha839aWEhQqTNvaQaWCCdT+wkDhkSJM6EtJcgKeo/3vhEJosAbJQj+AUDWz9a1DHJHwVnfDFjvrOcPOT9s0LC7wvx84ufEZQiDvKprgJBPFhLE7w2lznYqryyqKUGzXVz3RwrlKN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779161774; c=relaxed/simple;
	bh=poHaFL8h/2CkGfT0JJzC65n6FCriKq6ZCBtrikjKqLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AslFR7RExdQdqgPPN5kbqaATQx3fN2kav9PxHTMcjD/xx94UWAILOMYHit5mFKe0tp+l+yQcDpLaKQykNYa5L935FuBvPSaPfttGjmwgqyIYsfPIw+RsMglUkaHn9tBZFpyvFMstCCYjD36Ux0AVe2/iJQw7Dpgr7peZp3lNmAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i7WLipU/; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i7WLipU/"
Message-ID: <06b25f78-8e2d-4075-9b80-133bbd691c71@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779161761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79xn5oODka7E2yFSa2rWy0pgiQ4vVTV+hSyNwQyFHq4=;
	b=i7WLipU/jyMHBPg4YSql7DyviH9pGydMk+r+CvMT+MEB2g68jI2FOwOD0OL8Z5XzvhADnK
	3TdjaPPJgQf7XfnE7ARh4sA8OoDDtXFgfoKuumD2VNmlm/R2T2LaTp+n1Suz+YKZO//JRH
	9asWZmRbhkySKFgbSYwbdy72mRK/T00=
Date: Tue, 19 May 2026 11:35:42 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aguiSnY3ie1y4nEl@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 5/19/26 7:41 AM, Shakeel Butt wrote:
> On Mon, May 18, 2026 at 03:28:27PM -0700, Shakeel Butt wrote:
>> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
>> per-node type") split a memcg's single obj_cgroup into one per NUMA
>> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
>> pointer. Cross-NUMA workloads now see a drain on every refill and a
>> miss on every consume that targets a sibling per-node objcg of the
>> same memcg, producing the 67.7% stress-ng switch-mq regression
>> reported by LKP.
>>
>> stock->nr_bytes are fungible across per-node objcgs of one memcg.
>> Treat the cache as keyed by memcg in __consume_obj_stock() and
>> __refill_obj_stock() so siblings share the reserve. Compare via
>> READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
>> the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
>>
>> Sharing the reserve without re-caching means bytes funded by one
>> per-node objcg's slow path can be consumed/freed under a different
>> sibling, leaving sub-page residue on whichever sibling was cached at
>> drain time. The pre-existing obj_cgroup_release() path would WARN and
>> silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
>> bytes per memcg lifecycle from the page_counter. Forward the residue
>> into a per-node objcg of the same (post-reparent) memcg at release time
>> instead, so it can be reconciled later via a refill atomic_xchg or
>> another release; the chain terminates at root_mem_cgroup, whose
>> page_counter has no enforced limit.
>>
>> Please note that this is temporary fix and will be reverted when
>> per-node kmem accounting is introduced.
>>
>> Update the stale invariant comment on __account_obj_stock().
>>
>> Qi Zheng built a specialized reproducer [1] for the corner case and
>> confirmed the fix.
>>
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
>> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Debugged-by: Qi Zheng <qi.zheng@linux.dev>
> 
> Sashiko's review below and my response.
> 
> 
>>
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s)
>> to consider:
>> - [High] Race condition during memcg offlining causes a permanent page counter
>> leak when forwarding `sub_bytes`.
>> - [High] Unbounded accumulation of `sub_bytes` in a non-allocating parent
>> memcg causes a permanent page counter leak and integer overflow.
>> --
>>
>> commit e90ccbfce3bb9538bf1cdf185a1c10a7269e0939
>> Author: Shakeel Butt <shakeel.butt@linux.dev>
>>
>> memcg: cache obj_stock by memcg, not by objcg pointer
>>
>> This commit changes obj_stock_pcp caching from pointer-based to memcg-based
>> so sibling per-node objcgs share the reserve. It also forwards sub-page
>> residue into a per-node objcg of the same memcg during release so it can be
>> reconciled later instead of being lost.
>>
>> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/
>> [1]
>>
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>   index d978e18b9b2d0..a547ec7c42d16 100644
>>>   --- a/mm/memcontrol.c
>>>   +++ b/mm/memcontrol.c
>>>
>> [ ... ]
>>
>>>
>>> @@ -160,23 +170,33 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>>>   */
>>>   nr_bytes = atomic_read(&objcg->nr_charged_bytes);
>>>   - WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
>>>   nr_pages = nr_bytes >> PAGE_SHIFT;
>>>   + sub_bytes = nr_bytes & (PAGE_SIZE - 1);
>>>   
>>>   - if (nr_pages) {
>>>   + if (nr_pages || sub_bytes) {
>>>   struct mem_cgroup *memcg;
>>>   
>>>   - memcg = get_mem_cgroup_from_objcg(objcg);
>>>   - mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
>>>   - memcg1_account_kmem(memcg, -nr_pages);
>>>   - if (!mem_cgroup_is_root(memcg))
>>>   - memcg_uncharge(memcg, nr_pages);
>>>   - mem_cgroup_put(memcg);
>>>   + rcu_read_lock();
>>>   + memcg = obj_cgroup_memcg(objcg);
>>>   +
>>>   + if (nr_pages) {
>>>   + mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
>>>   + memcg1_account_kmem(memcg, -nr_pages);
>>>   + if (!mem_cgroup_is_root(memcg))
>>>   + memcg_uncharge(memcg, nr_pages);
>>>   + }
>>>   +
>>>   + if (sub_bytes && !mem_cgroup_is_root(memcg)) {
>>>   + struct obj_cgroup *fwd;
>>>   +
>>>   + fwd = rcu_dereference(
>>>   + memcg->nodeinfo[numa_node_id()]->objcg);
>>>   + if (fwd)
>>>
>> Could there be a race condition during memcg offlining here that leads to a
>> page counter leak?
>>
>> If this executes concurrently with the offlining of the memcg,
>> memcg_reparent_objcgs() might have already replaced the nodeinfo objcg
>> pointer with NULL. In this race window, fwd evaluates to NULL, and the
>> sub_bytes would be dropped.
>>
>> Since they are dropped without being uncharged or forwarded, it seems the
>> page counter would permanently leak these charges.
> 
> This is not much a concern as it is bounded (i.e. nr_nodes * PAGE_SIZE - 1) and
> previously for the warning case, we were already dropping the sub-page charges.
> 
>>
>>>
>>> + atomic_add(sub_bytes, &fwd->nr_charged_bytes);
>>>
>> Does this unbounded addition create a risk of integer overflow and page
>> counter leaks if the parent memcg never allocates?
>>
>> If the parent memcg is used strictly as a hierarchical container (like
>> system.slice) and performs no kernel allocations, its objcg is never cached
>> in any CPU's obj_stock_pcp.
>>
>> Because __refill_obj_stock() relies on the cache to periodically drain
>> nr_charged_bytes, it would never be invoked for the parent. Could child
>> residues continuously accumulate in the parent's nr_charged_bytes without
>> ever being uncharged, eventually overflowing the 32-bit atomic_t?
>>
> 
> This can be a concern for a long running cgroup. However fixing this would add
> complexity not worth it. This is a temporary fix and will be reverted in newer
> kernels.

I think this is fine as a temporary fix:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

> 
>>>
>>> + }
>>>   + rcu_read_unlock();
>>>   }
>>>
>> -- 
>> Sashiko AI review ·
>> https://sashiko.dev/#/patchset/20260518222827.110696-1-shakeel.butt@linux.dev?part=1
>>

