Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C93D902E;
	Thu, 20 Aug 2026 08:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216004; cv=none; b=cPVXxS/TqZWamgEFyq3AKduWNVTFTw4IvbZQukeoXYas7t0sXbKpNE+peAyrtD1LuhMwOcTXtC8f6t6OmWPxy8SBRUhpyCh2uFLFus1kks4keioSxxnD8rK1J5GTJ95sn4jmL+0NvK7nmQwRQml72XU8eujQ3uqqs2Prktn/4hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216004; c=relaxed/simple;
	bh=5rb9j5oXRPNsZ6uQgpnne7cWXuuvlHfr1YaHrApExDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iOUl4vnuWGRkEo0qaRhDzxNd04MoyPeQIfiCeLmEhoDaWOBca7K5+VrkKnfskAj3GpRaoYhBZgSDbAj91740XjtZTlp3Y8UziPy9PbDEy0p87qpMeuNzm4jZgzGw+RKj0oMUQQVKSXcdRN+jY0WgqZ+97bwXnhm/VfMlffW0Z4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FgIJDn5M; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FgIJDn5M"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787215990; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o8Lji253+j+EUKJdFcDdXwfYlhhfwBCDuK0dwHnKqzw=;
	b=FgIJDn5MjGOcsco+SZiumiqgSrM0oXsKoT226aJRHzJp/IUPGozxuCAhiEBSc46WWIKH3fkgCp8yqSypICHjKVSd8nr0aeqXCutOCWjam+w0gS4MJUgBjqDAWeikNocwbZQg1yPhYZo6U1Fvcp4Dq0YhUEa+a0ux6jyDZ6I4raY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X9J.X2b_1787215987;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9J.X2b_1787215987 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 16:53:08 +0800
Message-ID: <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
Date: Thu, 20 Aug 2026 16:53:07 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
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
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
 <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
 <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/20/26 11:45 AM, Kairui Song wrote:
> On Thu, Aug 20, 2026 at 9:52 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Each generation of MGLRU accounts anon and file folio numbers
>>> separately. The page table walker's update_batch_size() derives the
>>> anon / file type of a folio from its current flags, but the page table
>>> walk holds neither the lruvec lock nor the folio lock, so the type can
>>> change during that period.
>>
>> Right.
>>
>>> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
>>> so the folio is no longer considered on the anon LRU list. Lazyfreed
>>> folios can also be changed back to the anon list again. If the flip
>>> lands between folio_update_gen()'s cmpxchg and the type read in
>>> update_batch_size(), the batched delta pair is applied to the wrong
>>> type. The anon and file generation counters then carry phantom deltas
>>> that nothing reconciles, permanently skewing lrugen->nr_pages and the
>>> reclaim budgets derived from it.
>>
>> But I think the problem occurs between update_batch_size() and
>> sort_folio(). update_batch_size() only updates the anon or file folio
>> statistics, while sort_folio() moves promoted folios to the
>> corresponding type's list:
>>
>> /* promoted */
>> if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
>>          list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>>          return true;
>> }
>>
>> If the folio's anon/file type changes between these two steps (e.g., a
>> lazyfree folio), it would lead to what you described: "The anon and file
>> generation counters then carry phantom deltas that nothing reconciles,
>> permanently skewing lrugen->nr_pages and the reclaim budgets derived
>> from it."
> 
> Actually no, the counters follow eventual consistency (note the word
> "permanently"), we are fine with a drift as long as it will eventually
> be corrected. Lazy promotions creates counter drift from the physical
> location, but that is actually fixed by the sort_folio.
> 
> Now, for the type issue, use the lazyfree case as example (I think
> that's actually the only place,), lru_lazyfree will remove the folio
> form lruvec before marking it !PG_swapbacked, so during that removal
> period, the gen bits are zero (folio's gen == -1), so any lazy
> promotion CAS won't touch the counter, and only folio_update_gen will
> do it since folio_inc_gen only handles on list folios. The
> PG_swapbacked clearing in lazyfree only happens on folio wich has gen
> == -1 (off-list). And it makes sense since update PG_swapbacked need
> to update the counter and move the folio.
> 
> And if the CAS happends before the list removal, the list removal, the
> folio is on the anon list, so the CAS is moving a folio in the anon
> list, folio_update_gen will call update_batch_size asking it to update
> the anon counters, we are fine after this commit. (Before this commit,
> the CAS is moving a folio in the anon list but update_batch_size may
> occur on file coutners). The list removal will update the anon
> counter, and the subsequent list addition will account for the right
> file counter.
> 
> And if the CAS happens after the list add, we are still fine since the
> file counter is charged and sees a file type here.

Thanks for the expalnation. Now I see the problem and I think your are 
right.

(This involves the combination of the gen counter and the folio's type, 
so it would be better to have a diagram describing the race, otherwise 
it's indeed hard to follow.)
