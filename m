Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793005443;
	b=gI7JKq0qXlN+7ubVq6LVd9Cap4SbiVfC6drnQvuhY/xg+yKnlVar4paaqsL26BbnIsF8
	 93l2odTh7k/rYqdpzleJWIiVUSJ0wVkE7ssqGWuf12AO9vSVLtvrMYtENJj0bBycRebk8
	 zy6XibBOP4YcQ/KM0WFKojG0+Vh0thEEp8i5fHKs2Ma/GNPEhUWxLVzV+23nuC//Dlt4q
	 2c2AW2Gh3LT434AUI33WaFpJz7XjROl/09veEQ1Si8QDKNPy0HyuM9dVaPfWhdCp5Haj5
	 T+x1RlTT9LkR/RLy0cZUaY0+FXA6HfsViHaoy2vo/XScwl9m54s/VSTmGNpRa2/8I9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793005443;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
	b=GroIMy6+hW2M7dhmzlGKYwQo6NaHBHNkDY0tbCOmcCThbugcxVjIuPjAcAzaHRXJCbRG
	 VbXc9dLZKlAdV1ngB22oJri29y2XYF3Z1vqdoU0va3zY8VgzFyhcgQXnn59VvkvdzpmmB
	 1CbByJZKHsY80SnWclmGyAEDSyrTmNMDG/9NLaR7Dw7wD94bQDVFb0HultN4JvAq3xWip
	 4C92T9LLZa5DK36W6MMijde9sswPDAE1FYl3xJnC5T6Lvsg3Vsn9RVr8Xc0xeTXJWGUbY
	 3rTgRJfYPtwOEHF1/73VVKr6LBcCALscoZA5L0zX75iVHMetBv/lvzRqNBjFklROYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMU83mp8;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42844606A31F
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 09:04:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42844606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMU83mp8
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4677aad67bso288715566b.0
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 02:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793005442; x=1793610242; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
        b=FMU83mp8ZzZDzERBMqxyQ+KOkK5gA3Ya9rheWJuHrY/YwWyKqjr6OXtWWkbul7Feva
         XoNBuJABPK0fitlY5dXn1LIOd9957kMVAZ3n3qdio1oyox5oGjLHGScPWylqZZHGnFGl
         zoDbZ1IxDXAsovK+7fWkQbpcSubRNkQ1tWUqDYTZOuwGC+NELCfK9onzH0Y9fw7hc/FB
         NEIL//MO/N4O05hlivPB3FnkkREH7QasXiajHOGFJ2K02AB+v0H0LeSDr1JRSYBQnAPc
         iw83FQ5L1D8aE9Y9hUpHe5UU7wMHmNILSzDDn1OvLR+j5vP8NFXZvAAWRmcu63gTakEA
         ZNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793005442; x=1793610242;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
        b=ajeWPLWyU6ODLyf57HqI8EiEZU1pThERN+TB7L7CdT8UqigApxmZqwVxeBTNA6p3on
         DnXBlDv8N259Gbx9+36hEKUrdQa5BqEz6dZPBbjHkzYqVqoD0rGm39HLrvE+7poEdGhG
         IhRjgxNpKakMqRwCOdxqAQnWlWJpk6i/Q6CP1ZcUjKfuhcv4LM32J+pVdAit/Dah/5Ld
         SK8Eq1Ky5y06w9AoMbJPCZr4u2IGs53uZ3xAU4fPimgyi0mZO7gXoaZBTU0lX7Mjk/Sk
         QNgBUAHzWr3FuxL5UC6VICdDDMcZALOfdTGvrQyF8MdXzw1itQ6sBMmzMCDNn50Wjcyq
         bcHA==
X-Forwarded-Encrypted: i=1; AKwUvBz38GnqFVHXluTmmiawLzQ8p47cGOK8dtYWtSsISKzoCXl9WjK1XdAzHcO+GRUdWLIF3vBoGe+Y@vger.kernel.org
X-Gm-Message-State: AFq9FYLqQErIgwEwLpB+AX7lxQbctrMH26SduSIiNv7Z/CNO7LkA/g6E
	aOrrmaFjq5c8bhOEHrlBJuxPtsX4pyJ8LySHuzAe9gDN+u2P+aaAiidUOVK2mRZa72g=
X-Gm-Gg: AYBFou1vnR2YUA6n3w+JXvjATdva2jakIMWMK3FdARZKDqVqZlmWaPNzNKB32l+JWRn
	eZmka2IzU488GJtQ66UNsEU8TGI7QwDlIV27VHUsHe184CF+Ag0VeqgHG08M2CuRFeU4G+mcAho
	yg+xuLMUGqJcCitE5j8HzbvVhRgY4wH/S5MH97CuJr5pF0QHOdPgRset3lvw6VZ9JeMDABkqk4H
	dQIQjpwMErJojVPW4S29px+F0Ekr/Rvuy9ZvwgVDY3EM4k04XB4pLmfEB3iI0rvn78ViyaWD2GJ
	mLBlf1/4CnqxVHMLvogRWyYhHeDDZD9Kh1DutcwvYfA9dPNLejM8hU3Hi4GeTMiW1xJ62DOGmCW
	PwvquJQ7G/Va0HzODgFpOUBFiQYNXKpKDiwsr89kQPV30s6+pZ5tEzD7Uu5jR4IquBvw2SvCdTf
	iXnqC87KDPo1hnMOMNdlywsTxAC310GhoIV5kKCGou2Ww2FGTU+71aEMv3sKWRIiFEziVwfGF3G
	PNLRywNTOG8XP0VpZ/ID153jGx81rLsMipDgnLm8e0iTvH1GUSRQcYKNVpzwIxVn7V8jy1k5fmf
	y8gLSUzaEV857AQ=
X-Received: by 2002:a17:907:6094:b0:c41:6de7:7dee with SMTP id a640c23a62f3a-c46bda6a198mr773866466b.7.1793005441393;
        Mon, 26 Oct 2026 02:04:01 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8ddasm16802864f8f.48.2026.10.26.02.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:04:01 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:03:58 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <at8XfoqWwe9HSL9y@tiehlicka>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>

[Sorry for coming to this really late]

On Wed 21-10-26 15:55:09, Joshua Hahn wrote:
> v6 --> v7
> =========
> - Preserve two cgroup v1 proprerties that previously followed implicitly
>   from sharing a stock:
>   - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
>   - Reclaim does not swap when memory and memsw have equal limits.
> - Wordsmithing commit messages for 4/5 and 5/5 to document the
>   cgroupv1 divergence (bounded) between memory and memsw caused by
>   independent stock.
> 
> INTRODUCTION
> ============
> Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> allocations do not walk the page_counter hierarchy every time.
> Today, the stock implementation is within memcontrol code, even though
> the operation it caches is a page_counter charge. This makes it
> difficult to add new page_counters to a memcg and preserve the fast
> path behavior.
> 
> This matters for future work like my tiered memcg limits series [1]
> which introduces multiple new page_counters to memcg. Without making
> stock a page_counter-level property, it means that every memcg charge
> now goes through multiple page_counter hierarchy walks, instead of
> being able to cache these charges.
> 
> To make future page_counters scalable and performant, move stock from
> mem_cgroup to page_counter so that each page_counter can opt into its
> own per-CPU cache of pre-charged pages.

What does it mean that each counter can opt into its own per-cpu
caching?

> We get an added benefit of simplifying try_charge_memcg(), which now
> has all the stock management handled transparently within the
> page_counter layer.

This is quite a large change and I believe it will be really benefitial
to have some high level design overview in the cover rather than trying to
chase it in respective patches.
Namely, are there any changes to the locking (which is arguably quite
tricky to allow completely lockless fast path)? Also what are
implications to caching at different levels of the hierarchy? An example
of cache propagation up/down the hierarchy during
charge/uncharge/draining would be really useful to wrap ones head around
how this is supposed to work.

> EFFECT ON MEMCG V2 USERS
> ========================
> This series has no functional changes intended for memcg v2 users. We
> preserve all draining, refilling, and (un)charging behavior, including
> the uncharge path's refills / direct uncharges.
> 
> EFFECT ON MEMCG V1 USERS
> ========================
> For memcg v1 users, the decoupling of the memsw and memory stock means
> that each of them now manage their own independent stocks and can lead
> to a different size of precharged cache for each.
> 
> Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
> than or equal to memory.usage_in_bytes, because memsw is a superset of
> memory. With separate stocking, this could have been broken in scenarios
> where the memory stock is bigger than the memsw stock, leading to
> memory usage appearing to be inflated and greater than memsw usage,
> even though the real usage preserves the invariant.

How can this happen when counters are always charged together?

-- 
Michal Hocko
SUSE Labs
