Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA0A346A1D;
	Thu, 16 Jul 2026 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784214486; cv=none; b=dc90ag+nNQMYitRTyvfayBCRYCnrUyny+dUpnHKtrFlkD7ysQXQKOq9fJXrIo99GQ/16p3KqjboOkCsZLv9eX4RwZDQvmCi6GxFlZEckOmKZSXiK3xlazBivITe9PsIbU2paX2ut7P0Yayt5j9W0jrn8nacgLyFBI/ebAW5DyDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784214486; c=relaxed/simple;
	bh=NUc8EizNIfEwE2KLFoAnxARrKDQi7kCpbQSCkz7LyQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kYlZBHyXn9YLSYbuszx9933EnnY7jdzijO2pL04mWWB8eCqGf6LPFtQLGaLY5MPJmolBp++u0Ukzb/Jkmo1J1cH2zmHAoSEca/85b1QYbCZFPn5t8NuNiDGILFkERGYtbaAnf8byK3BGq1KoVndvuv3vPjBA0NTLzkivbhCIrd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKMMmzgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKMMmzgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FCA1F00A3A;
	Thu, 16 Jul 2026 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784214485;
	bh=noEZ6+2cpB7DuHX7F4CYxQYpyejbPopCH8uJ2lKswiw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fKMMmzgD8UZAY4iQDNzHsoe/vm62FJ8khvmHljKlL+8k75A8GjRKAIn6MxudSwOUc
	 vHot8rNwI2vg53sgSyhGIYosr7n0Rlje8aG0MY/sPJh3bTMrzho8hN+4dErmvffD7D
	 cq0FMFsXL9W1mLRSQ3UnyxIN/3E0oNP5b05tKLJ3zZzX1+5Qzu9a6z2oWqci1Cah0e
	 DPjHAfrR+PWcfNifWNbVRkvz+r26Us9sLjTUH3aMr3nyCp4613zqvLVP6fsr+OtRLB
	 z7P60p8v64kv+j/P8AEXSdaFJ+1t8aimnb108Fbix2cfryCHs9nudMfOxH2yYrwP/Y
	 3y9/J0YyqjMnA==
Message-ID: <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
Date: Thu, 16 Jul 2026 17:08:00 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when
 unnecessary
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org>
 <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/26 06:46, Suren Baghdasaryan wrote:
> Maybe now we should rename static_obj_ext_size() to
> static_obj_ext_max_size() as it reflects the max possible size of
> slabobj_ext?

Hm with _max_size() it doesn't have to be called static_ anymore?

But maybe we can get rid of it completely.

The only caller is calculate_sizes():

#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
        if (slab_args_unmergeable(args, s->flags) &&
                        (aligned_size - size >= static_obj_ext_size()))
                s->flags |= SLAB_OBJ_EXT_IN_OBJ;
#endif

We don't have slab pointer to pass to static_obj_ext_max_size().
But we should be able to figure it out from the cache via
cache_needs_objcg().

So we'd need cache_obj_ext_size()?

The static max size here works, but may prevent SLAB_OBJ_EXT_IN_OBJ
needlessly if padding can only fit codetag_ref and not objcg, but
we don't need objcg.
Which is probably only theoretical at this point as kmalloc_normal
caches (that have no objcg) have no padding, at least without
slab_debug. But still.

>> +       size_t sz = 0;
>> +
>> +       if (slab_needs_objcg(slab))
>> +               sz += 1;
>> +
>> +       if (slab_obj_ext_has_codetag())
>> +               sz += 1;
>> +
>> +       return sizeof(struct slabobj_ext) * sz;
>>  }
>>
>>  #ifdef CONFIG_SLAB_OBJ_EXT
>> @@ -741,7 +749,7 @@ static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext *obj_ex
>>  static inline union codetag_ref *
>>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>>  {
>> -       if (IS_ENABLED(CONFIG_MEMCG))
>> +       if (slab_needs_objcg(slab))
>>                 obj_ext += 1;
>>
>>         return &obj_ext->_ctref;
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 771d73abacb6..09c4931e5435 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2503,6 +2503,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
>>         if (likely(!obj_exts))
>>                 return;
>>
>> +       if (!slab_needs_objcg(slab))
>> +               return;
>> +
>>         get_slab_obj_exts(obj_exts);
>>         __memcg_slab_free_hook(s, slab, p, objects, obj_exts);
>>         put_slab_obj_exts(obj_exts);
>>
>> --
>> 2.55.0
>>

