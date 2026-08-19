Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E0375F7B;
	Wed, 19 Aug 2026 09:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787132813; cv=none; b=MSzw6EpypNmOz2WNVwGA9klI/lq6XhF9MQ2YRxsM/9RCZh+uXoV2dIsUQB6uPAUA85uGhTMADcNq2Arn3osWqmfsHKWHNJvH90dFAncUvcr4MM6AQt8DD0LRME2z9cCC6Uh8zjnoRxIVPJQWsDvoZxZ7N243nFJs5j8ioNNGeRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787132813; c=relaxed/simple;
	bh=ogQsoPkdcih9aS6kybIwFk8cPZsCWzTBt0G/NJ95CQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krJ4BeSw+WSdbGqvtGSgNgccV3UKSgdLBCB4EKTPbS7+oKebNc8EeKc2hFQK2AbbzUHIgabQFXX0PE/Q4vWxla11YzdOuuF85M6z7K4gZA1JQ6FG38VBb/t7Chm7oOKckGxobZkfNLoYvL/78zFhnN7HehpcPgIwiNHnzkQVkJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mQw0FoLZ; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mQw0FoLZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787132802; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LjAzNT6vBtj9gmZbzdnPdbmcTF5paC7A92/5+0dRtBU=;
	b=mQw0FoLZkt6FZkO3AqPswgUk3kfPt2sYQyC+Vt+dDnX3I6ebr5scwpC3LK0MvZeV1ZFH6pYZOxXPY4BRfcZbqaaneachNyhElZ2MmaKk8eVablAQ72QMscTIlJ2juFOZQO7uO4zGVQZodICwd09GRpsF33odTsSMgetXWaPLxLQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X9GFJ5v_1787132798;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GFJ5v_1787132798 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:46:40 +0800
Message-ID: <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:46:38 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
 <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/19/26 5:37 PM, Kairui Song wrote:
> On Wed, Aug 19, 2026 at 5:03 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Instead of doing bit ops on folio->flags.f, introduce helpers for
>>> adjusting folio's refs and gen info, make the code easier to debug and
>>> understand.
>>>
>>> No functional change is intended: some combined atomic operations are
>>> split into two, which only creates harmless transient states.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>> Thanks for the cleanups. One comment below.
>>
> 
> Thanks for the review!
> 
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 94f9c3ff5416..32d9354a754f 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -496,7 +496,9 @@ enum lruvec_flags {
>>>    #ifndef __GENERATING_BOUNDS_H
>>>
>>>    #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>>> +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
>>
>> There are still many places using MAX_NR_GENS to compare gen counters,
>> so I'm concerned that introducing a new macro would make the use of the
>> max gen counter even more confusing.
> 
> I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
> users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
> bit hard to follow for me since:
> 
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
> new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
> 
> Things like this are everywhere and I found it really hard to follow
> what is actually going on. And adding more operations to refs/gen
> looks ugly and painful to do, and, it's impossible to add any sanity
> check. With proper gen and refs helpers, we can ensure every time
> gen/refs is modified, the value is valid (in debug builds).

I agree LRU_GEN_MASK and LRU_REFS_MASK can be cleaned up further.

> 
> Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to understand.
> 
> Oh and this LRU_GEN_MAX is only used for sanity check for now.

But my point is that people may not know when to use LRU_GEN_MAX vs. 
MAX_NR_GENS, since they seem to have the same semantics.
