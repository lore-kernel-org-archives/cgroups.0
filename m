Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFDD3E172A
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780404454; cv=none; b=LVA7N6IbPTA8ULHUXctKGXWelTxdz0a4zMiEE+Vv1P4ONiIkbzggWqmHXwTbZ7wesHPjA/2zmiP/Vi6ryFNoajYYyBbZZoJ0RQz4OlhNIGgwEjLhF4pTUQd36FuL33p+RiBN450rt6JKi2cTVO1rV1RwQiQ5mmrbZ8dMG/i22Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780404454; c=relaxed/simple;
	bh=Y1FREikRAcNMsRLJb8TzrDykNfNoVW/0VsdPGwqVDTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qX9u01tS3uuJb6Rw3sE40y7ecgcbPukGp9EwD1p4q6iF5nhKkU+DSPpx7zzF1aqOQAPBAYaBADBTWvDs9YW6P8Q/n8bO+6Tsl0I8Y0b9OyAwvYwNwP319eWK4EmkodKv48rk1HjJTKGSngTULybt4/o6jTqxtKcMRQK3F5XfiBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UjEO2iIk; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UjEO2iIk"
Message-ID: <63797977-1c18-4885-8099-f5c21c80da39@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780404441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SUbKnFIvNRovA5Pj5Ujg3tyo5/9ilOMKehCU9gPd0Ao=;
	b=UjEO2iIkbjlGz3tnv2gwQ5b2SXnDpMqU+u3ltyp3GFfD9l2CEzudVlMAKbuSaMn8jDeYtI
	RIfEL93NgSsHKz44zWlMvUyenMydW6VrPmwfEVzW7DcUX+RTxDWPjrPcJMv28IBRd344F6
	nZXBO62tlcISx1VF65qSFfFQLsG5wrg=
Date: Tue, 2 Jun 2026 20:47:05 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: ljs@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
 liam@infradead.org, usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
 ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
 wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <1dce1561-b42a-4322-a99f-89eba1e7c227@linux.dev>
 <716c7351-2641-4317-8675-e07a16a1efe2@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <716c7351-2641-4317-8675-e07a16a1efe2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2026/6/2 20:11, David Hildenbrand (Arm) wrote:
> On 6/2/26 06:38, Lance Yang wrote:
>> Sorry, I missed Johannes in Cc ...
>>
>> On 2026/6/2 12:34, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> deferred_split_count() returns the raw list_lru count. When the per-memcg,
>>> per-node list is empty, that count is 0.
>>>
>>> That skips scanning, but it does not tell memcg reclaim that the shrinker
>>> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>>> count callback reports SHRINK_EMPTY.
> 
> What's the effect of that? Would we consider it a fix that we'd want to backport?

Just a stale memcg shrinker bit :) I'd treat this patch as a small
cleanup.

Once the queue is empty, count_objects() returns 0. That skips the scan,
but shrink_slab_memcg() only clears the bit on SHRINK_EMPTY, not 0.

So memcg reclaim can keep calling the shrinker even though there is
nothing on that queue.

>>>
>>> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>>> cleared once the queue has drained.
>>>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    mm/huge_memory.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 72f6caf0fec6..62d598290c3b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool
>>> partially_mapped)
>>>    static unsigned long deferred_split_count(struct shrinker *shrink,
>>>            struct shrink_control *sc)
>>>    {
>>> -    return list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    unsigned long count;
>>> +
>>> +    count = list_lru_shrink_count(&deferred_split_lru, sc);
>>> +    return count ?: SHRINK_EMPTY;
>>>    }
>>>      static bool thp_underused(struct folio *folio)
>>
> 
> This is against Johannes' work, right?

Yep, I noticed it there, but the behavior is older.

> If this is a fix, likely it would be fixing 87eaceb3faa5 ("mm: thp: make
> deferred split shrinker memcg aware"), right?

No missed reclaim, just some extra reclaim work :)

Cheers, Lance
