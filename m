Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7BD40681A
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788436150; cv=none; b=a4GSG2QEtMxaBPhDb9jZLvMWZ/hvxgw09KS5+T6YfFSXG3GC99I2I2EacyMIQTLbsC1IopwiSt79+vL3uk6PIGZefv7lC0niwCOASmqyIR1R5MgDY5p7lZQAAzjK24NAbk0Q+pk4mzNXfWh5R3meJCMok6BfctwW8gKG+CdDZMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788436150; c=relaxed/simple;
	bh=77ef0smQwTHv7ciVNhDJeRJa0P6JZyLYvgjHop8xgXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SU+bcHpElxyeXZOrjRapyg06cokRnC3YYWzPVAZn7YVgeTeBUXQRo6cQtECUkFcJJTXXkpBU91f9VoBJvXZFYa6/npza5zQudtniRSgVH2HrvogD3d5p3LMOtnzZdVbnmDx8/O3RKg2mxAMwUcCc/BWtLe/0bHTbM7bREqX1uVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TjUa2R95; arc=none smtp.client-ip=91.218.175.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TjUa2R95"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=77ef0smQwTHv7ciVNhDJeRJa0P6JZyLYvgjHop8xgXY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788436137; v=1; x=1789040937;
 b=TjUa2R955q9nVy4b4LUdivA4FzzWYtSTFBTH8RO0Mfy/UC+61uc3/1t5BQ4pHuYo7+/vHx+C
 5+3B+LeXwitx0WunELzPRB6a+B+d45myP1W2BstqE+Dg+u5YJeNRq8pWMoiOSHL89NAexPLpMI+
 n7xlWW1JMbnyMOVyxaggoTF4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 10f1446bfee7baed;
	Thu, 03 Sep 2026 11:48:47 +0000
X-Mizu-Trace-ID: 10f1446bfee7baed
X-Migadu-Flow: FLOW_OUT
Message-ID: <f067f8c9-00f0-484a-adf3-da58fe972bfe@linux.dev>
Date: Thu, 3 Sep 2026 19:48:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-3-ridong.chen@linux.dev>
 <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wKaboESQfUJPi8y4BNJuxpEWG2Prjb44NvFKDV_aeVhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/3/2026 2:30 PM, Barry Song wrote:
> On Thu, Sep 3, 2026 at 11:20 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> For MGLRU, memory.min/low is not honored during global proactive reclaim
>> (writing to the root memory.reclaim) and global direct reclaim, because
>> these paths shrink memcgs using stale or effective protection (emin/elow).
> 
> Are you sure it should be “stale or effective”?
> My gut feeling is that we don't need the “or” here.
> 

My bad. It was a typo. Will remove "or".

> [...]
>>
>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
> 
> With a few nits:
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
> [...]
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index b4c9b8f3dfe9..500cc2051d13 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>          struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>          struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>
>> -       /* lru_gen_age_node() called mem_cgroup_calculate_protection() */
>> +       /*
>> +        * For kswapd, lru_gen_age_node() has already called
>> +        * mem_cgroup_calculate_protection()
>> +        */
> 
> Could be clearer:
> 
> /*
>   * For kswapd, mem_cgroup_calculate_protection() has already
>   * been called during the top-down cgroup traversal.
>   */
> 

Thank you, will update.

>> +       if (!current_is_kswapd())
>> +               mem_cgroup_calculate_protection_path(NULL, memcg);
> 
> Best Regards
> Barry

-- 
Best regards
Ridong

