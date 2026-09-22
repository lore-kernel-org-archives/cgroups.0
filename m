Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD3743E08F;
	Tue, 22 Sep 2026 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070755; cv=none; b=i4r6T4MA1guxjGkG/bAOlg97UB3/SEVWJD9UI04VvA/lOWfZYqGrHxfvkQFox/d0HsBws9/XWqLXFLz4DQe2v+mZXM9A3r7J6egbLI2NZ3wTqxSHG5dAgu1tT+OATLbH4DPMqh2fyjSC16B5chBZPzBbuyqWyS5GJUIYKPJgnDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070755; c=relaxed/simple;
	bh=IOLIY/iVTnmqBFIGzbrUeePIfRsgjk3jUrVJ442QJzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQMJKarbJ/82xoqfmKYLc6XazgsG4gI7o4CRAUQQ7MuOmgOGp6JwvcXvZ4dvJVukqya+UgO0Tic6EV2auqNGIBs8N+fnnB/Hslw+KONfZVHRQVbFGx1i+2hPphb8Dw0arJZZe6McWJD3qoeAhcX0E9ePC/W+HVYe0qt7jkrjiW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qPGC01KS; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qPGC01KS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790070744; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uLXPio8neK/XWQ24/aYWgPbiu1ZOhj0GPf/ayqaAKLs=;
	b=qPGC01KSGvPEAo/piyIMeU0NmSz6Rzl1q0/KISqF4hJCDdaH3BAXjxbp7Zda098HpEk1B31uyNODYY7x8wXzS/BJ2I+KX1aybeqmVwkze68ReIvsFC3Gum1ErvFgtQgm4pGdmMnUoBqd+p/NVxgE50y2YeILOi0h/jJt/lZIgAc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XBTMM3c_1790070738;
Received: from 30.178.68.4(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XBTMM3c_1790070738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 17:52:22 +0800
Message-ID: <db317551-0b1e-40f8-b265-d00d65653089@linux.alibaba.com>
Date: Tue, 22 Sep 2026 17:52:17 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
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
 <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/11/26 6:34 AM, Andrew Morton wrote:
> On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> With cgroup.memory=nokmem, the THP deferred split shrinker and the
>> zswap shrinker are degraded in two ways.
>>
>> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
>> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
>> limit-induced reclaim of a cgroup neither splits its partially
>> unmapped THPs nor writes back its zswapped pages.  v1 of this series
>> [1] restored the flag to fix that.
>>
>> However, as Sashiko's review of v1 pointed out [2], the flag alone
>> is not enough.  __list_lru_init() also collapses every list_lru into
>> per-node lists under nokmem, so even with the flag restored, the
>> objects of all cgroups share one list per node: the per-memcg
>> shrinker bit is only set for whichever memcg happens to repopulate
>> the empty list, so pressure in other cgroups may not even trigger
>> the scan, and when it does, the scan walks everyone's objects.
>>
>> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
>> list_lru"), THP had fully per-memcg deferred split queues embedded
>> in struct mem_cgroup, working independently of kmem accounting.
>> nokmem only opts out of kernel slab accounting; THPs and zswapped
>> pages are user memory and remain charged to their cgroups, so
>> per-memcg reclaim is still what these shrinkers want.
>>
>> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
>> memcg aware under nokmem:
> 
> Thanks.
> 
> It seems that Sashiko still doesn't understand that memory allocations
> in __init code are considered "can't fail".
> 
> 	https://sashiko.dev/#/patchset/20260910080722.3961351-1-qinyuntan@linux.alibaba.com
> 
> otoh, failures in the functiond which hugepage_init() calls might be
> caused by things other than ENOMEM so I guess we shouldn't zap all that
> cleanup code.
> 
> Anyway, that's unrelated to your changes.
> 
> I'll save this patchset away for later and shall await reviewer input. 
> Please poke me in a week or so if there hasn't been any, Things are
> crazy lately.

Hi Andrew,
 
Thanks for your time looking into this series. A gentle ping, as you
suggested. Please let me know if anything else is needed from my side.

Thanks,
Qinyun Tan
