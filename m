Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C46EEA8
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 09:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786785641; cv=pass; b=dcCELI73jRPBWRTKbOyKZgMGq7ttjFK9J+DY+6WZ0osMs55P/f8FknoNZ4WqASzUd1D7wx+8BIl/HdmrEZ7M2qSsprVBdua5V28ZZW3qWODG+as8rOOU+Knh4AvexxB+sXKc5m/5FGKUSRLXEV3Ub287T7UC1LaK+KFpwJ9NSSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786785641; c=relaxed/simple;
	bh=CLKiohUTLkZ3vOg3O+B/65s3DGhrq9fg5gml/HppUi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RG1B1dVGE3sj6sAZ3GqzZI8VNA1EawAFdauQHs5WKKctOnfv7WVOSja42VQr4Fxbmbe4jN+w5STG5/fgfWMGD1kGO4Pl5+UX4kWVOmIVegj9pvLY5cJOeHTkfwmg+Z+oDmCsrInofcPL/aXl+AlTu8nzcLTKM1GUwfsBmp3kpqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QvopY5Z9; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QvopY5Z9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c197eaaab00so346261866b.0
        for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 02:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786785638; cv=none;
        d=google.com; s=arc-20260327;
        b=GkjzN6X5VqakYnP4RIQygjDfLnCwoMqWbRpa7XMcg+MKLKd1V34esQx1c3EBvoPpYo
         ZaiI/rWqc1by8oW0OoB+DU8bGkWvr6XioP4F16fkL/eU5GoGUDyhvvAnSG6G2u4NNH5W
         XNUSjOIsAr32a4TqF29mQdzxpAPLJXn+q1OFmm0NhNqMN72Rh8XUZ+HCLsKRCg5dyof9
         5G8gVJHKNtImBFULZ/gaWh4Wwu5vtM/Epp7RGmIQxUMA92q6Ic3cQZc9loR8O3eo+RsR
         bDmE4Vqexj67cCEk6YgArlBsofaYC2yIUWhoqR4lv53dkgXRGp57yxVOzDUGj7eNXkzu
         S2/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        fh=E2XmqNDw3pq2oSahqsAjtN0lISkel6H2GrWpJemqZr8=;
        b=gXXp3ffMzhIbGsEO+RsG3ZecHWRj6H91tRbJoTlOUPfwj4CxE8Gg6KcXGXSYNtsad2
         TCPErajx8CcZxl03AdHrY4meShAKHDWcsI6ueB0O2OJPW/WIX6EOz7iByJ5kKuMV6JAf
         kxTPnx/UHv/9f9FqijJ8gtFeWQtMUqTdIKAq8BVbetyWCvFjMMJO+fRJKdY+J373Yrs7
         ZYT7mGWwxUwyo/5+/8PR2+7DhDYmg6z0AoFWe38jp7RST3o1QxJyuwwphpoPZQjDGutf
         kP/oWHC1yluYwyuWgfG5PuAlkNQayOyFoK/9gDXg/phMOtkxub+fnRlGlKOix1RhV/+K
         Z5Jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786785638; x=1787390438; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        b=QvopY5Z9qNiAG/yLiTa3XOKaqzeVl9XLKtB2UQwU1mL23c87Gz/l66XsFkmvTY7eX+
         DvjLMNJ0mOrVpoFByxvzvZDzdbP8MQoU9KQzLPzShcCPHO/3i00FaifsHjestDz/YJ1Z
         QchMFtH013QlsSh5/FVOjNsrT2/A7FZoFxymGQ5G4QoA3lrhNiCRnG/on4kPsBr3JP6u
         iGikWbrbtIB1YI3z/2Rtw9FVI0FVrdlqI4I1s6TBcWgfMq/4D6loo3HH+qBqIuI18Jgp
         RorOyPQosereAMSEoaLw1n5FEJFc/cFjuvjO/urazZERyj5jNu8tPfQTeL1zlQACfIf/
         Xv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786785638; x=1787390438;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        b=mlawupM09m6zWwcTlwG2Ibedqxt55i4xt33WRnn+qnB2jlV3t3vzfLiHy5z7lFtr4n
         zwyJy1c87K1kXWT4fhjzIdBEE3GAG2eUulG0P9bRvzZv6czx/j+Gfmkx+QkSESqIVj84
         bkhqTl7O+8304efcBgln51xizSchHy6ACCjETRQWTKDwnsydvwgeaNP54fkznFW0Bugo
         TSbsXrBqhbPm8ROwKfIPgzbGr+JkiL3Dm7DK/5DrA1rOvDaZziSJuznTgEXselNrvIHM
         nxZSoJqzI0oerR+Mk/oNHF1Bdqki0SW44tlcrHYdRA+I9MTo0CHBsaWY352mid9Jqwkp
         d9/A==
X-Forwarded-Encrypted: i=1; AHgh+Rrhby4ay9gFJmuxvxg/oTnhudj/isEsEb9PHwrGBOgP9LLrIry6+g8UzXoPAetEC6Mc0U8Y5f1+@vger.kernel.org
X-Gm-Message-State: AOJu0YzLRQMCIbvddQQOeFcydY55z4kzgx39F3xkuLT3ejL7t45CTyjH
	sIWSfxF8YbdDKzBOZEj3MLuZ5Fi4Dv+08LmO0pC417MYeWou3WSryxEoT7GPTr7OyinEe4J5rS1
	koa/de/qXvr6j18aXjdL9l3i8pGqRjDE=
X-Gm-Gg: AR+sD10Af+rUWOJvCLlbwzSRva8tf0fZwScwCLVbvraVWJXpY1Gx14hzUviAPHmPYP/
	7SEMa3gVXOgbCueNRJABq6fGbh4vCB1gtFaBNpy4tHlCDOSXIL4JzwdfVTt7mKrz6M5yywa4A8j
	ihlGT6yS4A4mLDfSDkaDRuYhEZz5X/E4VmoR/zqkS1SRo30CI4j5G/VPbZmcuVCzdJR8xG68MVc
	5PVxUvdtHEh3ORM/6CzgnR92KG3poy2PHaAiVAkgBidQuxp75cRygYm1WSnNe66zGWC+TQAsHg8
	vRXnAoqlmw0j8GwnbHlG7/ZV7ZalAtQOfdnDqzMhQgvT01+Rgj60GL2CXfZ4gmMpVVZshGPQ4AR
	Shg==
X-Received: by 2002:a17:907:c02:b0:c1f:c061:569a with SMTP id
 a640c23a62f3a-c2129b5b0fbmr558940366b.7.1786785637644; Sat, 15 Aug 2026
 02:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
 <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com> <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 17:20:00 +0800
X-Gm-Features: AcwNN1UD6wlSIq4Zi3TIXvS0pqcdHhg-sYrZC--Sr_V-rOxVKiGYqZ0gVdl_kYo
Message-ID: <CAMgjq7DYpcA9Xu+NTzHk=N--CC_oPV=1Wj9ZcJRjDonZA9iqWg@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 8:13=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sat, Aug 15, 2026 at 2:06=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Thanks very much for the review and suggestion!
> >
> > Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
> > LRU_REFS_WORKINGSET, which are special referenced count number, maybe
> > LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
> > FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
> > which are commonly used already, that's one main hint behind the name
> > choice here.
>
> Yep, LRU_REF_FAULT and LRU_REF_EXEC sound good to me.
>
> BTW, is FAULT really the right term here? It looks like you're
> actually using it to indicate the result of PTE scanning.
>
> In the other place, you use "promote" instead:
>
> +static inline int folio_inc_lru_refs(struct folio *folio, bool
> promote, bool is_exec)
> +{
> +       return 0;
> +}
>
> So perhaps LRU_REF_MAPPED  would be more appropriate?

Sound reasonalbe, it idea behind that name is that if the folio is
evicted, that access will cause a major fault. I'm fine with both
name.
