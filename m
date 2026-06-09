Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E132EAB72
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 08:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992189; cv=none; b=p7c+ZKM7sLFDdGE7p7x5YyuAEvRaCgkKvMF2q+dcWUdbUofCQF4gacH0tbMWNiJbIKv2zxl7l7rfRkHaB32OWXD223E6IABCyDlONAznqIMCl5jv8Hz9FHwEzzccdwWyjgQWtFZlfHKY1RQXGPLrpe6bytCuRcA53VEvSZ4ZETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992189; c=relaxed/simple;
	bh=7psJ3mXqxC7gENVmGvzWQwN73nK6rdrC51N5aD5Igec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImQ6RCQYX2DE6gwGbhGsVOC+Z/MDj1JZy6QkpRXiyS65Hy1M33Wrvq7JVUCsvFhWA8qRFslpbd90qfK4nom83btw5jzJU+zPv72aRbtYeCLa46vYuWwWKVmD9FDcwaUbqE9sXws3ew9OoKty3Po+ET421DoR9lHwneTmmRbkOuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jRsT/4aB; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jRsT/4aB"
Message-ID: <3306b3b4-a063-43f9-a740-2311dd87be3c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780992180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUcVuWAo1N6d6dSjCQRntUYShy5LQAwX8omMTfd5mYY=;
	b=jRsT/4aBlYtkb7QyMASuQsaRCIGhVQN28SEQahPXRkP6GdrPmLYHyV3FPEJEvccUtoUjgS
	bqwbEEfE3urBD6PIGshjjfBeQMLGqIgDhPHFvxB1Pdzq/taY9MywfQfbiAgh8BaO4tcAgd
	CgI1a9LIBP+8p3ujctXEZz1NlV8s3XI=
Date: Tue, 9 Jun 2026 16:02:46 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: hannes@cmpxchg.org, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, david@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <ah3MuK3GuimKVORB@cmpxchg.org>
 <20260609032058.23770-1-lance.yang@linux.dev> <aifB-YGdJAGzgprt@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aifB-YGdJAGzgprt@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/6/9 15:35, Lorenzo Stoakes wrote:
> On Tue, Jun 09, 2026 at 11:20:58AM +0800, Lance Yang wrote:
>>
>> On Mon, Jun 01, 2026 at 02:17:28PM -0400, Johannes Weiner wrote:
>>> On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
>>>>
>>>> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
>>>> [...]
>>>>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>>>>> index 04f5ce992401..9c3a5cf99778 100644
>>>>> --- a/mm/swap_state.c
>>>>> +++ b/mm/swap_state.c
>>>>> @@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>>>> 		return ERR_PTR(-ENOMEM);
>>>>> 	}
>>>>>
>>>>
>>>> Shouldn't this be limited to anon swapin?
>>>>
>>>> e.g. vmf && vma_is_anonymous(vmf->vma)
>>>>
>>>>> +	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>>>>
>>>> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
>>>> get here too when handling a large swap entry:
>>>>
>>>> shmem_get_folio_gfp()
>>>>    shmem_swapin_folio()
>>>>      shmem_swap_alloc_folio()
>>>>        swapin_sync()
>>>>          swap_cache_alloc_folio()
>>>>            __swap_cache_alloc()
>>>>              folio_memcg_alloc_deferred()
>>>
>>> Good catch, I think you're right. I shouldn't have dismissed that
>>> branch due to "/* Direct swapin skipping swap cache & readahead */"
>>>
>>>> @Baolin please correct me if I got it wrong :)
>>>>
>>>> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
>>>> only allocates the memcg list_lru metadata for deferred_split_lru:
>>>>
>>>> int folio_memcg_alloc_deferred(struct folio *folio)
>>>> {
>>>> 	if (mem_cgroup_disabled())
>>>> 		return 0;
>>>> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
>>>> }
>>>>
>>>> Since deferred_split_lru only queues anon large folios, doing this for
>>>> shmem swapin doesn't buy us anything :)
>>>
>>> Yes, agreed. I don't think it's a big deal / show stopper in terms of
>>> user-visible effect, but of course still worth fixing.
>>>
>>> I'll send a follow-up patch.
>>
>> Thanks.
>>
>> Looks like this has already landed in mm-stable. If you're okay with it,
>> I can send the follow-up.
>>
>> From: Lance Yang <lance.yang@linux.dev>
>> Date: Tue, 9 Jun 2026 10:56:45 +0800
>> Subject: [PATCH] mm: prepare deferred split metadata only for anon swapin
>>
>> __swap_cache_alloc() prepares deferred split metadata for large swapcache
>> folios.
>>
>> That also covers shmem swapin, because shmem_swap_alloc_folio() can call
>> swapin_sync() with a large order[1]. But shmem folios are not queued on
>> the deferred split queue, so preparing the metadata doesn't buy us
>> anything there.
>>
>> So let's limit it to anon swapin.
>>
>> [1] https://lore.kernel.org/all/20260601132135.14272-1-lance.yang@linux.dev/
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/swap_state.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index 9c3a5cf99778..7adac957c2b8 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -465,7 +465,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>   		return ERR_PTR(-ENOMEM);
>>   	}
>>
>> -	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>> +	if (order > 1 && vma && vma_is_anonymous(vma) &&
> 
> A folio can be anon for a non-shmem file-backed VMA though?
> E.g. MAP_PRIVATE-mapped file-backed mappings?

Ah, good point! vma_is_anonymous() is too strong here ...

Maybe use !vma_is_shmem(vma) instead?

> Not sure if that's something that'd be a factor here/meaningful though.
> 
>> +	    folio_memcg_alloc_deferred(folio)) {
>>   		spin_lock(&ci->lock);
>>   		__swap_cache_do_del_folio(ci, folio, entry, shadow);
>>   		spin_unlock(&ci->lock);
>> --
>> 2.39.3 (Apple Git-146)
> 
> Cheers, Lorenzo

