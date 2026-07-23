Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1679C33DEDF
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772884; cv=none; b=GpC2UDl9i4fU8pp4BndFiJgmCPpeseteyCbeAL3bno1w4IXz7Kc3DHdVQi3jjxh6ubrJC19ysyqWh64nYfmROI3Gi7EwW1Xu+m7Vmj2zS1BUELxC3gyUkfKCDdqEUqziTWyEL0wzobSltbSLUiPxc4eEu/P1krZkjQiB51jkxy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772884; c=relaxed/simple;
	bh=HiNYttoXKIcZezY/2vkaEQ04OGuiI5oNnIHLl3Xe7uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7AwYKPn16wzp0kq6h1peeiPiWesn9rnAUGAdbf2vMx7ytThEFRhmZgs0pUSO8/I8ipFGUnimudEj+3iVQNmITL2cQFeRUwo49nsdla6w/vvt6WgIcUHOUKqfdlr4wy46Ipv9G2Tt7QkVTbRnwpsqX0B4qRxCuK0kshyICXs0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aSRYVuKY; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aSRYVuKY"
Message-ID: <17abc770-0185-4795-a23f-f4e9ab1772bc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784772880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ambDkTqQMLokaCulVxvlNgNFFnydU6SgnMT5PS4qzuQ=;
	b=aSRYVuKYI+X+eIqzX80L4HC58+VvyU+t/J1qYv4GWd5wIq4n4Fzjt9jJYGfC4GwK1MiOgE
	jsl+2yxDV1HbF2MIG0UTcq1n57XkSiSVrzknTDtDem920CDcJ+beu3mW+Dfd1guE94MF3X
	ANHJqssR1Guu811cLymy/LDaCM7dGgo=
Date: Thu, 23 Jul 2026 10:14:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-2-ridong.chen@linux.dev>
 <amF1ii74RlzKiepO@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <amF1ii74RlzKiepO@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/23/2026 9:59 AM, Johannes Weiner wrote:
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> One small suggestion:
> 
> On Thu, Jul 16, 2026 at 11:17:28AM +0800, Ridong wrote:
>> @@ -76,6 +77,25 @@ enum swap_cluster_flags {
>>   	CLUSTER_FLAG_MAX,
>>   };
>>   
>> +extern int vm_swappiness;
>> +
>> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>> +{
>> +#ifdef CONFIG_MEMCG_V1
>> +	/* Cgroup2 doesn't have per-cgroup swappiness */
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +		return READ_ONCE(vm_swappiness);
>> +
>> +	/* root ? */
>> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
>> +		return READ_ONCE(vm_swappiness);
>> +
>> +	return READ_ONCE(memcg->swappiness);
>> +#else
>> +	return READ_ONCE(vm_swappiness);
>> +#endif
> 
> How about:
> 
> #ifdef CONFIG_MEMCG_V1
> 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
> 	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
> 		return memcg->swappiness;
> #endif
> 	return READ_ONCE(vm_swappiness);

This is simpler.

Hi, Andrew, I notice you just applied this series to mm-new branch. Would you 
mind I update it?

-- 
Best regards
Ridong

