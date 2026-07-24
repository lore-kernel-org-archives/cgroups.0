Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4CF3CCFC4;
	Fri, 24 Jul 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908721; cv=none; b=IB+rTgqIFiwEYfPRh/EZCqypAz89f6/LrLm+FRkC5Tk1IeXqH3eJAeCuN4u3QNowpB0k/Bu7Z4mScwVDbz/4MrmwGw8A7LjXDraSch/o5vEAjPi2X/Q8VEoAhpYlhoNbBewIpmqwcLS0/0to8F8UVJRAT04EdYLdyHhuccqkUYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908721; c=relaxed/simple;
	bh=FFhgyd20eZJcVmzCjIbz4H6kvXz4YIdmMPHxPc8SLTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sgALUyQypUwRAxmrUvZ2RGHOLBsWEtZ8gsHmh23rOMBi1y2IBR+sD9qpnHudtlLS325jzSYRguj4oakZR0XUmRfjUsm0MozA6ummqloUVoBKLHtaIIB8pe4eMuVsSNsPRw0SOzjfvq3qYhJrs+73DfgrDLUA3QLAd2QUXZKaeKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ShtoNFDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShtoNFDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC9B1F000E9;
	Fri, 24 Jul 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784908719;
	bh=EFqqg9i7LZjv08q4O6WVX5vzanG/kxsPHPC8mdLPdug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ShtoNFDV1LMQuwtlmWoiusiSz/y/w2lCScRwcZoD6jzHMQ8LkFpIBR14LLslY4lhU
	 ap68H0EbJYx/aqPikqAObCXM+9iwTPWAYIBzH48xKhSo9oc/t5+5SmkdVCNdaPj+s3
	 IGgdk2O9W8Jf4d/1SYvYb0+jxL23PCjjV4tzuWsmKQGT5yvvaggl91UFj3++34pOfU
	 vFmUJLB6/SrCpr2J3xngtCPtK58yHFu0VD0vODyO7iwckbMFjpFV2rFu7gT3GIFoyv
	 tkHXddKI6woAmu6uJIG2C29IbvxawyFdRRHIq057HW9JgYaqw6j3xuUvo7Sok8xNmj
	 i1csXQ4eSpwlA==
Message-ID: <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
Date: Fri, 24 Jul 2026 17:58:36 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <amC6frE3LoWYjTMh@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amC6frE3LoWYjTMh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/26 14:47, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
>> struct kfence_metadata only contains struct slabobj_ext with
>> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
>> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
>> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
>> enabled, it will end up allocating its obj_exts via
>> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
>> These will probably then never be freed.
>> 
>> So things sorta work, but not always in the intended and optimal way.
>> The upcoming changes to slabobj_ext layout would additionally need a
>> proper refactoring to keep working.
>> 
>> However, there's little benefit in accounting KFENCE objects. KFENCE
>> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
>> (default to 255) outstanding ones at any time. For any callsite
>> prominent enough in the memory allocation profiling stats, allocations
>> served from KFENCE will be lost in the noise.
>> 
>> Thus let's not complicate things and simply stop accounting KFENCE
>> objects in allocation profiling and skip them in the related slab hooks.
>> 
>> We also need to skip kfence objects in mark_obj_codetag_empty() in case
>> a sheaf is allocated from kfence, per earlier sashiko review.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>>  mm/slub.c                                 | 11 +++++++++++
>>  2 files changed, 18 insertions(+)
>> 
>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>> index 5389d241176a..d02eb54ee8f2 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>>  
>>  - Then, use the following form for your allocations:
>>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
>> +
>> +Notes
>> +=====
>> +
>> +- When a slab object is allocated from KFENCE, its accounting is skipped.
>> +  KFENCE allocations are rare and limited to a small number, so this omission
>> +  is negligible.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0337e60db5ac..76acb78f2655 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
>>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
>>  						       slab_exts, offs);
>>  
>> +		if (is_kfence_address(obj)) {
>> +			put_slab_obj_exts(slab_exts);
>> +			return;
>> +		}
>> +
>>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>>  			put_slab_obj_exts(slab_exts);
>>  			return;
>> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>>  		return;
>>  
>> +	if (is_kfence_address(object))
>> +		return;
>> +
>>  	slab = virt_to_slab(object);
>>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>>  	/*
>> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>>  	for (i = 0; i < objects; i++) {
>>  		unsigned int off = obj_to_index(s, slab, p[i]);
> 
> I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
> maybe we could use:
> 
> if (is_kfence_address(p[i]))
> 	continue;
> off = __obj_to_index(cache, slab_address(slab), obj);

Hm it would work, but go away after patch 5/13 anyway, so will leave as is.
Thanks!

>>  
>> +		if (is_kfence_address(p[i]))
>> +			continue;
>> +
>>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>>  	}
>>  	put_slab_obj_exts(obj_exts);
>> 
>> -- 
>> 2.55.0
>> 
> 

