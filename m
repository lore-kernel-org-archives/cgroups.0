Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CEB1D89EF;
	Thu, 20 Aug 2026 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787187763; cv=none; b=MWPxo9MDExdT5NlNRDeABBbnWTUbw6cXBIo3gmQvhYD13Up0n+em1J/iAXODMBjF2EMzAPBp6VXEUnrn1z/FtnhY76QP9jAQniPYPG+0khJ0aeMTwExZ0VchCXRammekgKpUN4+LaZcpXFSedBQL7HqtD9z9B+SOi3XfPfPiI10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787187763; c=relaxed/simple;
	bh=dtr8WJ9kPprKlwo5kBcflzLCw73WrJj49WLXIk+uIZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m473w6wKZcT58sRwD3y3iVSHHLMobe7VTBJccDXdjXDcElLhHpkFl/jvk1dCnQNsCPI+a/nAc4I4ZLWcvAt1nuDhRXmAKeWzZO+zVZ+gaBKcKnBbXk7SjIiVOiKhxtrrbhvicJwT3JrdQzr+Gc3uKCzLXdG275iCaIZdF4UXf68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BN5/LT3t; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BN5/LT3t"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787187758; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tUw7pNGt/Yy5cHbPNU1onyvXNSn7k4oj0Wg482Px5y0=;
	b=BN5/LT3tCvepRYCX2cCWUIHbdHlsVwWnJrGnGklHxl0uAtX0Chv4h0PUXS6uEd8mc/Pygb2t0Ai6qNoSaxU+bwEFxcvwrRODNOxBqPhKg6skgG2cPv0lmMakyGZqQ+QADlPwZcGV/sFx+wrJ8/CVJWhKHIiZFulxncE3uViFLhA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9Hn7GZ_1787187756;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9Hn7GZ_1787187756 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 09:02:36 +0800
Message-ID: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
Date: Thu, 20 Aug 2026 09:02:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
To: Baoquan He <baoquan.he@linux.dev>, kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv> <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/20/26 8:57 AM, Baoquan He wrote:
> On 08/20/26 at 08:53am, Baoquan He wrote:
>> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The helper should never be called for an off-list folio, and it always
>>> expects the folio to be in the oldest generation before doing any
>>> cmpxchg. Add a sanity check for the off-list case: if it is ever
>>> violated, bail out and keep the folio flags untouched to minimize the
>>> damage, instead of silently treating the folio as if it were in the
>>> oldest generation and promoting it updating the flags to an unexpected
>>> status.
>>>
>>> Also rename the variables to clearly distinguish the folio's current
>>> gen from the oldest gen.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>   mm/vmscan.c | 14 +++++++++-----
>>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 7169cac60869..7e3ae0c6cba3 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>>>   {
>>>   	int type = folio_is_file_lru(folio);
>>>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>> -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>>> +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>>>   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>>>   
>>>   	do {
>>> -		new_gen = lru_gen_from_flags(old_flags);
>>> +		old_gen = lru_gen_from_flags(old_flags);
>>> +		/* This helper should never be called for off-list folios */
>>> +		VM_WARN_ON_ONCE(old_gen < 0);
>>> +		if (old_gen < 0)
>>> +			return min_gen;
>>
>> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
>> could only happen inc_min_seq() call it. While inc_min_seq() call it
>> because inc_max_seq() need increase max_gen to max_gen + 1 and found
>> get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
>                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
>    ~~~~~~~~~~~~~~~~
> Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
> oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.
> 
>> be put in the lastest max_gen. It may not be expected.

But how does old_gen < 0 actually happen? folio_inc_gen() is called 
under the lru lock, so how can a folio listed in MGLRU have a gen 
counter < 0? If this can happen in any case, we should fix this bug first.
