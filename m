Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE351346A07;
	Thu, 10 Sep 2026 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026426; cv=none; b=g2LAD/yEEJkWHSa7bn5AbVxR0m40Yij5J8HRhbQvLQw7w46otEE5annTRjQgyT/zDPVgkehxRRdMGPmTpnPNc5atSkPL0JssKahx+6OeXnwS8p6dYajmSEmy0kjmaDtMaU/v54IRLDbJ+WlAMZICg5+hKFV/9B2Zw0LyTNZTHJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026426; c=relaxed/simple;
	bh=lH7ybVtz+ru913Xuv8n6ruyztrtNiiDw4H9X2Gg/qL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gRxLcvXJV4bK2fFyTntNWo0yVyoVE92zdzyyBfXgbiOxPs28vN6aKKIMm+RrDG+qmOGwcafSZOBN6xR/dRWlYwkgISK+OUuPgnlhzXVl0tCOh0f7UBciyfDTWFp5jHqfbwR4EwToxdkUPEi72SlLo0tcpDItq4iN4Rd9mhiR5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=v9gf1qnu; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="v9gf1qnu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789026420; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SBZDbA7m6Uk1x34vpkryq/YkYdbuGu1YkB4b+p78Org=;
	b=v9gf1qnug911Bfd6CyT7PlmnqESXvi3VKOKiXhnMx1Ddu23Tde+q6DF6ACEr4O3Z2DmaF5c70eFEDqvDmhpdDRSAKQDbZ+xy9IkEG2q0UsDlxvJ4v0d1Y5K6v+5u+nvGn+OauX+HgQwXRFh+pFUSOBIHPOrGVg2KHn5B85PqbE4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XAgyScL_1789026417;
Received: from 30.178.84.157(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAgyScL_1789026417 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 15:46:58 +0800
Message-ID: <f5f6327a-bc9e-415c-a8b2-b498883b9746@linux.alibaba.com>
Date: Thu, 10 Sep 2026 15:46:56 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
 <aqGlV7NjxrFPYtRH@cmpxchg.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqGlV7NjxrFPYtRH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Johannes,

On 9/10/26 2:28 AM, Johannes Weiner wrote:
> On Mon, Sep 07, 2026 at 07:01:10PM +0800, Qinyun Tan wrote:
>> On a system booted with cgroup.memory=nokmem, the deferred split
>> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
>> partially unmapped THPs are only split under global reclaim; memcg
>> (limit-induced) reclaim never splits them, so a cgroup under memory
>> pressure keeps its underused THPs intact.
>>
>> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
>> split shrinker to list_lru"), which re-registered the shrinker without
>> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
>> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
>> precisely so it would keep working with kmem accounting disabled.
>> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
>> nokmem and the shrinker loses its memcg awareness.
> 
> Here is the reason why it was dropped:
> https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
> 
> After your patch to make list_lru expand for NONSLAB shrinkers, it can
> be restored.
> 

Thanks for the pointer. I'll update the commit message in v3 and
reference that thread.

>> This was noticed by Michal during review of the patch "mm/list_lru:
>> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>>
>> Restore the flag.
>>
>> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
>>
>> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
>> Suggested-by: Michal Koutný <mkoutny@suse.com>
>> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>


Thanks again,
Qinyun Tan
