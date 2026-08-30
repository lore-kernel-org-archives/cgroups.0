Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A46282F34
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788080916; cv=none; b=l07ifp3Npg0CTZ9biWvZF9kAEY893zhnKiz5pS52++fV/G+fCuffjUBOnfqoLUtZzwWCk5JIcxNmxTY1N0yOHKMPJLRLbmvtTToGykA5ZQNhE9c8SP33ws89c2eDoED+KPFk/jKuhaRR+6BlGqwzWTUj8hWD2qUmAf3htdUX/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788080916; c=relaxed/simple;
	bh=V2dtd4OYMUBexxYoOnaLyFCYO8Ylxw79o0cRyiJ0VzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TTQJCzYNOdw8L1pvC2hBkthpwYIjOLSp09BA1SzKhHuEl8d3WkjC45mB1XiBQ3us5yUZpyLR7DrHhGLlvZSMaRPZ85p9AdM0siXmLV/6ofmzG9+mXzvkTPXcYI9/R8Vp4O46o/3NAqsKHStvw6zq37kcWcg8mJ9okqS/bT+BnoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gWm6X2w3; arc=none smtp.client-ip=95.215.58.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gWm6X2w3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=V2dtd4OYMUBexxYoOnaLyFCYO8Ylxw79o0cRyiJ0VzI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788080911; v=1; x=1788685711;
 b=gWm6X2w318Tm9BUpaoSF20X1w9rnY1A9fdT5HEHUKpCVMVKevFobkk3n7fRbn5OOVRpWEXJD
 +d5EQ01N8n5+cMs2qAaRSP/fO3/oVDMe1Swz9eieZnbyCiMQSpSDx813+5YmZRsEeSxtd0gMI6C
 kuhWUO6u1a4oKcrOlJrVcY/Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b72dab2c1cd40654;
	Sun, 30 Aug 2026 09:08:21 +0000
X-Mizu-Trace-ID: b72dab2c1cd40654
X-Migadu-Flow: FLOW_OUT
Message-ID: <d270d063-027a-4297-bd0c-8f4a1eaf3f40@linux.dev>
Date: Sun, 30 Aug 2026 17:08:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Barry Song <baohua@kernel.org>, kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/29/2026 12:21 PM, Barry Song wrote:
> On Wed, Aug 26, 2026 at 1:53 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
>>
>> From: Kairui Song <kasong@tencent.com>
>>
>> Instead of doing bit ops on folio->flags.f, introduce helpers for
>> adjusting a folio's refs and generation info, making the code easier
>> to debug and understand.
>>
>> No functional change is intended: some combined atomic operations are
>> split into two, which only creates harmless transient states. There is
>> no measurable performance impact, and some paths even look slightly
>> better in the generated assembly.
> 
> Hi Kairui,
> 
> I like your idea. Overall, it looks good to me. With some cleanup,
> we might have the following:
> 
>>
>> Signed-off-by: Kairui Song <kasong@tencent.com>
>> ---
>>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>>   include/linux/mmzone.h    |  1 +
>>   mm/folio.c                | 19 +++++++-----
>>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>>   4 files changed, 114 insertions(+), 43 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index 621c8653d8f7..edfaf2661812 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>>          return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>>   }
>>
>> -static inline int folio_lru_refs(const struct folio *folio)
>> +/**
>> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
>> + * @flags: folio flags
>> + *
>> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
>> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
>> + */
>> +static inline int lru_gen_from_flags(unsigned long flags)
>> +{
>> +       int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
>> +
>> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
>> +       gen -= 1;
>> +       VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> 
> Since `gen` is an `int`, it seems a bit odd to have
> `gen != -1 && gen >= MAX_NR_GENS` combined here.
> 

Agreed. Especially with the gen -= 1 right above, it took me a while to figure 
out what that actually meant.

> Do you actually mean the following instead?
> 
> VM_WARN_ON_ONCE(gen < -1 || gen >= MAX_NR_GENS);
> 

Maybe we could add a macro like the one I mentioned in my earlier reply:

GENS_UNREF -1

>> +       return gen;
>> +}
>> +
>> +/**
>> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
>> + * @flags: pointer to the folio flags
>> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
>> + */
>> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>>   {
>> -       unsigned long flags = READ_ONCE(folio->flags.f);
>> +       VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
>> +
>> +       *flags &= ~LRU_GEN_MASK;
>> +       *flags |= (gen + 1UL) << LRU_GEN_PGOFF;
>> +}
> 
> It seems that we are setting the gen in the flags, rather than
> setting the flags themselves.
> 
> The current name makes me think that the function is setting the
> entire flags field, especially since `lru_gen` is used as the
> namespace for various MGLRU functions, e.g.:
> 
> void lru_gen_add_mm(struct mm_struct *mm);
> void lru_gen_del_mm(struct mm_struct *mm);
> void lru_gen_migrate_mm(struct mm_struct *mm);
> struct lru_gen_folio;
> lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> 
> However, this function only sets the gen bits in the flags.
> Maybe we could use a name that makes this distinction clearer?
> 
> Could they be named as below, or is there a better naming option?
> 
> set_gen_to_flags(unsigned long *flags, int gen);
> get_gen_from_flags(unsigned long flags);
> 
> Or something like flags_to_gen() or gen_from_flags()?
> 
>>
>> +/**
>> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
>> + * @flags: folio flags
>> + */
>> +static inline int lru_refs_from_flags(unsigned long flags)
>> +{
>>          if (!(flags & BIT(PG_referenced)))
>>                  return 0;
>>          /*
>> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio *folio)
>>          return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>>   }
>>
>> -static inline int folio_lru_gen(const struct folio *folio)
>> +/**
>> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
>> + * @flags: pointer to the folio flags
>> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
>> + */
>> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
>> +{
>> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
>> +       BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
>> +
>> +       *flags &= ~LRU_REFS_FLAGS;
>> +       if (!refs)
>> +               return;
>> +       *flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
>> +}
> 
> Similar to the above, maybe we could use more descriptive names?
> 
>> +
>> +static inline int folio_lru_refs(const struct folio *folio)
>>   {
>> -       unsigned long flags = READ_ONCE(folio->flags.f);
>> +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>> +}
>> +
>> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>> +{
>> +       unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>> +
>> +       do {
>> +               new_flags = old_flags;
>> +               lru_refs_set_flags(&new_flags, refs);
>> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>> +}
>>
>> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> 
> [...]
> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 73a81b4a3e16..9ee9f8dc6805 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>>                  /* Activate file-backed executable folios after first usage. */
>>                  if (is_exec_file_folio(folio, vma_flags)) {
>> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
>> +                       folio_set_workingset(folio);
>> +                       folio_set_lru_refs(folio, 0);
>>                          return true;
>>                  }
>>
>> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>> +               folio_set_lru_refs(folio, 1);
> 
> We have quite a few instances of folio_set_lru_refs(folio, 1) and
> folio_set_lru_refs(folio, 0). Do these values have any special
> meaning? Could we add wrapper helpers to make the code more readable?
> 
> `1` just means `PG_referenced`, right? Could we add a comment or
> changelog description to clarify that `1` actually means `refs = 0`,
> but `PG_referenced` is set?
> 
> Thanks
> Barry

-- 
Best regards
Ridong

