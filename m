Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D9835F8B9;
	Thu, 16 Jul 2026 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193082; cv=none; b=pSohBush+9T67N/t8EhXG1/z3kmjiIugEX7Hny4JvjtDmG5CAe+jBF104imJ4rnjeAkioAbV8AdTKzBokdvZVKNPiVmfwiPOT0fls6Ex7bpOH/XWxxl4RwLa0+hn7HVij6SiMovneG2G9aTgM68h/pYDk3mXQG6MAQ/Tc7NQL/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193082; c=relaxed/simple;
	bh=KPce9QFMgAIwe+cwCpgtpgfsU9rtNqF4p5MVTIBLk84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WWVYLcFFXMBnp6aWR+wTtrcTdnyyHBK+R0IU7DstKYb07pAsm6JZHM8bMJ5UWySThBSbovDRYDEy4b7xCT/IMUxH4urJTDEqyszBQdZkhab2aMu4F1jUkTDmh/IAEnmKlEtuIDr/ct1I00cwYDNaioEo111myA0HimW8lyJ+SXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2vbq3wO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2vbq3wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C981F000E9;
	Thu, 16 Jul 2026 09:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784193071;
	bh=iKN5NO81HJ06ZzzJkfJP7JqXMoZORuMoTwUI7uq6cgs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z2vbq3wOpl76S0pNL0BrryzAjWr95MujoIU0p1D4TZj1lBt/ZIgS18pgjo/Z5r/jV
	 wTpZvwRRRrReEfLqcNc+TMBxpomB+f7LPVQuAi/mzYUmVg5NuiwcSo14a5Z0ZVF9aC
	 CkG2S1iU/K3K8q1xWNrudiqqdEgb7KCiTkK4jce5pLs0IQtn5s6XULuzZ0jhdnlks7
	 WgzMFWZOy3kzi6l6gSAHAYHHFGoQ4jAGglmqi3ABDTBVHDiG4FaGlvHFA5L4tUFMUt
	 0ehqga7FYirHu/3EtF3fXQ5UhHrbWXs9kOYAGwXUy+1lpJw4+cjDzWPkC6z0g/3+rf
	 5dKtDD8PK04vA==
Message-ID: <ab9782bf-d3dd-4cb5-ae66-127b3a16330b@kernel.org>
Date: Thu, 16 Jul 2026 11:11:06 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/12] mm/slab: skip kfence objects in allocation
 profiling
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
 <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
 <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/15/26 18:02, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:10 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> struct kfence_metadata only has obj_exts with CONFIG_MEMCG.
> 
> I don't quite understand this statement. obj_exts are allocated when
> either CONFIG_MEMCG or CONFIG_MEM_ALLOC_PROFILING is enabled.

See in mm/kfence/kfence.h

struct kfence_metadata {
...
#ifdef CONFIG_MEMCG
        struct slabobj_ext obj_exts;
#endif
...

then in mm/kfence/core.c kfence_init_pool()

#ifdef CONFIG_MEMCG
                struct slab *slab = page_slab(page);
                slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
                                 MEMCG_DATA_OBJEXTS;
#endif

So the slab kfence fakes only has this pre-inited obj_exts
with CONFIG_MEMCG.

What happens if we run memalloc profiling without MEMCG and this
fake slab doesn't have a pre-assigned obj_exts? I guess
__alloc_tagging_slab_alloc_hook() will allocate it via
prepare_slab_obj_exts_hook().

But it's something that was done consciously and probably
just accidentally works.

>> If it's
>> enabled, it does also work for allocation profiling, but there's little
>> value recording tags for KFENCE objects.
> 
> Unless we are leaking them, right?

Well if there are leaks in a particular callsite, we should see that from all
the allocations that don't end up in kfence (as kfence allocations are rare).
So we are very unlikely to miss a leak due to this.

>> Furthermore it would complicate
>> the upcoming changes, so just skip them in the slab hooks.
> 
> Ok, I can understand that. If we do this, we should document that
> kfence objects are no longer tracked.
> 
>>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0337e60db5ac..a4be70d080fb 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>>         if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>>                 return;
>>
>> +       if (is_kfence_address(object))
>> +               return;
>> +
>>         slab = virt_to_slab(object);
>>         obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>>         /*
>> @@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>>         for (i = 0; i < objects; i++) {
>>                 unsigned int off = obj_to_index(s, slab, p[i]);
>>
>> +               if (is_kfence_address(p[i]))
>> +                       continue;
>> +
>>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>>         }
>>         put_slab_obj_exts(obj_exts);
>>
>> --
>> 2.55.0
>>

