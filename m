Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B092F5A12;
	Fri, 31 Jul 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505800; cv=none; b=jz8msEcCWnLwwgSmmQbCJ0uFIMtRmo/HO66keQY4nHCrNg6G6kSxRAWHyxjic/UeUgOfkaYFet744RZIzqmnQ6xwxPgY9+DRuOqtZFfNEQTh12YBbv8Hcl1zoyFLz6Rpo/YE7IX/azCQRL9aqgszYQ4Il09aR174i4aAZrV+4cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505800; c=relaxed/simple;
	bh=iBzAO5FSJOJM0/Hs8vWNkgzEQGma4FdVaPnPk1NNgmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJffb5ctxowp2Aq4XH05LFTp2Pn1ZT9v7l4f1nYwM+D20yUw603WH3eM5zeca7Ffi2PcdUGz/IOLAovgZM4KFv7qP6FQre3laOt4FiKOjKZ1qMRKGtdKA2jodt8B8XCYMLxv1pUDsGt2U25LK+deSD4kgWzMGN7bBfVEnG6Dxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaXFjw9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaXFjw9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EF41F000E9;
	Fri, 31 Jul 2026 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785505799;
	bh=E6/53IoTaITFwF6OJqnQibU8ofhN9Lsow6iDpep0Xps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GaXFjw9ui0agGo1svAJcB/SttjHf5dRf1X34eOINiDbZ9wl3erajDcnoFQGY4AkF+
	 ZdOt1sWOKikj9vjtnoJFEScSFQrHDdIJljctwT2uK6JqRFDQ5SgtSAyb1h74SLnYgc
	 emA9164rFG2eP6Pccs7d5Qk4zL5njRqH1EK5B+wB4NoCNxg0GYJsNkxSojfarvcH8X
	 52YQjalKaamshJOOjaKDCCO+f5BItXxNrcBbqJlYeGefIGhNiM0C4p6+qV56WkZpx2
	 YL/IM9zcAVhQMileoGITOSlOYx15gQQUc3mqO/0UkbnoY9RpWa01O/sJHmv5fkaNO3
	 p/MK+xBS4aMRg==
Message-ID: <e9d202ed-c614-477e-be2f-f51975b003a0@kernel.org>
Date: Fri, 31 Jul 2026 15:49:54 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
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
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
 <amsxmCmsUTYM26Fh@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amsxmCmsUTYM26Fh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/26 13:16, Hao Li wrote:
> On Mon, Jul 27, 2026 at 02:53:55PM +0200, Vlastimil Babka (SUSE) wrote:
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
>>  Documentation/mm/allocation-profiling.rst | 7 +++++++
>>  mm/slub.c                                 | 9 +++++++++
>>  2 files changed, 16 insertions(+)
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
> 
> should this be 'allocation profiling is skipped' instead?

The document uses the word "accounting" when it comes to individual
allocations, so this fits.

> Otherwise, looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!

