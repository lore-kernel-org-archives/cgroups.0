Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7DF3BCD11;
	Thu, 16 Jul 2026 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210304; cv=none; b=gqtv05Yh0mjDp/IX4fNttdwOVwWWTlAHUiwsQGJ5gpiP5f+XPNyMxz2ao8r0B1KrJG+gI1krukguTDzrVjEWroMsZFkSHsitL8YNu3+IY3/XW6b+SaxMtDly5gE6qfqrqEmgOAUboM2zz2yxuzP2u8YWmvkR+wd+H+j0dMy/0N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210304; c=relaxed/simple;
	bh=ZeafglfvX/hxAyhsqjQ331bwD6COfedQZ/3pdJ4UNhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azr0AYr+oEPdH6sLr1sVNK8w+5/e+VIdrAvJsPXrAL5f2YIwBPoXdjnmsdNW3Qdb8EwZ4GqCcw5JUL42+vqQkV5uoGK8g8vgdN/0wAHW5x2fncXw1QCLVBKxJxxRUTyMc+yKhCju8z29xsw/tJ0uPXyHheNlhuvbfD+8JLHEnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3QpNxlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3QpNxlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B711F00A3A;
	Thu, 16 Jul 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210303;
	bh=vZVvwb5gue2Pu5bCd5TzfBGCtT03YhDYvhjRxQgTOBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J3QpNxlK+VfRxOQBqJ3Un2Zp2XZu+SBFJoDzQKLY+1pcxm5h5JkuCmJePpKOi+bV4
	 FcmoPvyk+dtTe+rj/Sgm5BobMog+m8r01RYWJmkuIOv+y4gep+fqYziq43dFNUuz08
	 lLyDEkcWlpC6SlWuyKtQIEO8wMa0Bj15QBwbmJLBSleZ56WMyiWv9K9b4vJFYfwSJc
	 ZsEXhYV9Hl9MkVd7PMqi9AWwi1zYmgK3uH6Yc3HURviDObyLSXClZp2D/pc8IZU6Uw
	 cTlTiafXjZZVXG2b4SciG2SOTAWlJX6xnavIdMVZezkTWpn7jQ8fiMfbMCtI7hWExJ
	 AErWQyHw/crHA==
Message-ID: <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
Date: Thu, 16 Jul 2026 15:58:19 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
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
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/16/26 03:27, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:11 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
>>   */
>>  struct slabobj_ext {
>>  #ifdef CONFIG_MEMCG
>> -       struct obj_cgroup *objcg;
>> +       struct obj_cgroup *_objcg;
>>  #endif
>>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>>         union codetag_ref ref;
>> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>>         return kasan_reset_tag(obj_ext);
>>  }
>>
>> +#ifdef CONFIG_MEMCG
>> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext *obj_ext)
> 
> I understand why you need to return obj_cgroup** but maybe instead we
> can have a separate setter function and just return a pointer here?

Yeah I rewrote it now and it looks better. Thanks! It ended up like this due
to some previous attempt I made.

> That would also help catch cases when someone wants to set
> obj_ext._objcg that was optimized away (for that the setter would need
> an additional parameter to identify whether we allocated optimized
> objext vector).

It would need passing the slab parameter to assert
slab_obj_ext_has_codetag() in debug mode. I don't think it's worth it given
the get/set is only called from few specialized places.

> 
>> +{
>> +       return &obj_ext->_objcg;
>> +}
>> +#endif
>> +
>>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>                         gfp_t gfp, unsigned int alloc_flags);
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 5e3f53bcd0d3..48e10198a3ce 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>>         if (obj_exts) {
>>                 get_slab_obj_exts(obj_exts);
>>                 obj_ext = slab_obj_ext(s, slab, obj_exts, p);
>> -               if (unlikely(obj_ext->objcg)) {
>> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
>>                         put_slab_obj_exts(obj_exts);
>>                         return true;
>>                 }
>>
>> --
>> 2.55.0
>>

