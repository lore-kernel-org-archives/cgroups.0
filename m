Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2BE3AB271
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 02:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780452056; cv=none; b=A4semyWTQbVgk5FrOXEv2HhxUn2RpJ/eYJsiMLSfrigIn377wXgxf3OKyoTctzqUnwouTDO5IohnoZL5nxLZ0qCxsd7vO/oOL43TuvCzhVMGW4vBZLn0cgVuVEFB0GP1Lyfot9D9sx5O2qLEpC/GiQfaEO3BPMHQ0vNq42BqJGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780452056; c=relaxed/simple;
	bh=cvRv8xMtq0WCcjq7Ft9xBpdBJQmg8mtlgWqmwiKIPbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnglozntZApEb8FwXbUKC4bw1eQweBHbvY2URQ29NC5G0727S8n7Ko0yCB/CXKusiMmElC1RsRYyml3QSju42IB09vWaJuwRaO7LwSTZEyXlqz8FvHtx19qZ3BWm8gJMTHJa3M7vwRdIAtpTa+OCkYwjBwqI1+sVf3oIhmKWie4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OpV6w1zh; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OpV6w1zh"
Message-ID: <f5061a2f-c52a-47c4-855c-82f3967833d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780452052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LeJhAZRLWtGVTIwFCHuqUJodfl2KhzLTyWve4qcCjP0=;
	b=OpV6w1zhJuO9Fvzn8HsG5QQIKizSG6UQlTGMYcaaGFMyxQu6EKE+D7en/a3XSllzlZr09c
	OL45e43afq5M8uzJH+i6A6D/I/7sBvkz4DASrXvWF8YTzQPYljiqO0j2vMSg8whTUhwLAm
	sdEXdAeJV4ySUtPk/pQSFbGcLsXdX4g=
Date: Wed, 3 Jun 2026 10:00:33 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, wangkefeng.wang@huawei.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/6/3 04:37, Andrew Morton wrote:
> On Tue,  2 Jun 2026 12:34:53 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> deferred_split_count() returns the raw list_lru count. When the per-memcg,
>> per-node list is empty, that count is 0.
>>
>> That skips scanning, but it does not tell memcg reclaim that the shrinker
>> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>> count callback reports SHRINK_EMPTY.
>>
>> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>> cleared once the queue has drained.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/huge_memory.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 72f6caf0fec6..62d598290c3b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>   static unsigned long deferred_split_count(struct shrinker *shrink,
>>   		struct shrink_control *sc)
>>   {
>> -	return list_lru_shrink_count(&deferred_split_lru, sc);
>> +	unsigned long count;
>> +
>> +	count = list_lru_shrink_count(&deferred_split_lru, sc);
>> +	return count ?: SHRINK_EMPTY;
>>   }
>>   
>>   static bool thp_underused(struct folio *folio)
> 
> Should this be handled as a fix against hannes's "mm: switch deferred
> split shrinker to list_lru"?

Hmm ... I noticed this while looking at Johannes' work, but the
behavior is older than that ...

We also discussed the Fixes tag earlier[1] and decided to leave it
out. There is no missed reclaim, only some extra reclaim work :)

[1] 
https://lore.kernel.org/linux-mm/63797977-1c18-4885-8099-f5c21c80da39@linux.dev/

Cheers, Lance
