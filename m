Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D223B0AE1
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132038; cv=pass; b=D9IT1rAm4/INIVCLRhVYSORsDedzYAcOaqj9uF6APAfwbvppYXuKO/SiV8Ncd7BrpNws2zb5k8Eri05fIfrw1Pcqaer2LkzA7K7wi56IUnd0cI7dnO6tndHBob+NNMf53vnmG7x3fsRYY11cSYeNTgguxu1qD7DcHcmNO7TltPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132038; c=relaxed/simple;
	bh=Gqk2xfrCP7QtcWu2dcnH/EaXNlAyh1m4NaalRiol5p8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t7MDim9x+rCFdQb5bP6OECVKZO5C9wOyUZW+x/7J2ky1EHfK3SIkS4E17cbHkyV43vgnJAQfFJWZBXldxf5JY/TRa6HZF9RCqeQBP0jD19UtOJvrzLKgAAfmqmTK5yb3Kv+vnUYEiyFiAV6aZiH8sTnBBMK9CzI5hg0jMB46510=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vexZM7f6; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vexZM7f6"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so297761cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 09:13:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784132030; cv=none;
        d=google.com; s=arc-20260327;
        b=d+H/bgjiHLNivcdN6mSR4ZhZn2Re/PuPpA7RzoidyvTb1LtHvDZZCU9XSD8yNhIxi/
         njg8a8C3XDzaIDpX20A6caJDCYiJOB0DGUaEnd407McIOjWJ9kbTXR5dLp1/UKZy/PQy
         tkI1Zmep7El8Ra2qBxHkTvMCHCDI6IIK+qdJCs6WMW/dJktF5OxK+NXaPLeT/XD1muNd
         c1/M89eyRYsQ8jlCl/eKFDc/NIPylpxiri/NKFN10y/mUpgyicaKj4XEkW8pTYPavnxH
         hKbnUvhrxdHA2eYcz4xabED+GGujkAkeeCQlhH+8jgeEQ6EGKrLv5teo2G/W8KwtXx2y
         L3QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        fh=2U8dq2mDjp1OBrncbHjKwCMt6uCqXJTdJKzr+dJgqfc=;
        b=rZCGklq6AOsjbRe0GGbhVSdohmzitRTKB1ia2HqHK6CCeJB7F81gosASJB7st08k8D
         VvpLngZ66YL5d43JnbSdItf3GI33mvcY1PkW9Io/9A4TPgZTM4zhp2J40uM3LtpZacXo
         7XZEac++EZ3qWVaP/t5iTBoOJx2UNCzOVPtapO002RCYDqkZB59oxCy0ZAyjPnI6mx8T
         7ERwO3W3Nk0GIcuKDQLYTKv1ckpidUhRpiJRSsnmeRp/gu//pjpiH8wAHi4abjLf3R9T
         W/eEb7y1KRQLTLO/tGHEkiJZriF5pgPxokPF94nEtV3HuzbF0g+QOJrjQVVfYB2Tf717
         FjOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784132030; x=1784736830; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        b=vexZM7f6pVKynt7RYwnnPPjmLgSyfrUbj39lSm2dqqPw999ZGWjPLh+PFfPjcekpz8
         JykscWMiMWsVLAxJ7Z9vFRoaQqtCNIqUtK8O/a5aNJledvURQniZss9s9tenXmh6UsbQ
         lhptTi0VGoedehjtNzsP1FuxXEZEuxceErtj6AXHNA8GeWZKWpj42mupreiKx201UwHP
         4xS1/FSOUyy6DrsjWuBN6mpseOjF/2+vjUF+5euddhMKjs6ZztDVPM37jgyL3yKOyHl2
         gq3O+IbJqw6ZRb6bAzKuxOdk65YiES/6Hpv41bs362LncmB1918ISHYrBiEYtiKsuszC
         f2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132030; x=1784736830;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        b=a29WQnM1cmS0mQKwa5ZJ9oPer1mSZzyrvAJiEg9YW11U9PYkjbJYbqa+amUitVA8K3
         //0NGQw2sqhqs9iaL4crzYCk7qD7nS/6ENAgfqz39/6RQ3ItGQz0U2zc62oLhfRKigFX
         FWEd30pF76Kiy5GFzyWElEPjv6+6gbSFnYfyVM6cOpNOK4SyXcH5RD8XCPbh1AyrXh7h
         xqSQXzkyIY2DAE0qRF/6nE+/d6sJrVAi1sqWpgPWUsQ+BTJuf4eOAgJHThLUUMMSlhQ2
         zF8E2k8f2OQEnIfLXxN4iNb+uvS5W6U+ZvGsUPS/j5ESDQMxMoQGZoCD+5jVdcRW7n09
         33Bw==
X-Forwarded-Encrypted: i=1; AHgh+Rpuw1yEweFZz3LbbSqUi7WciR+5h3a9RikCNf1Vrw6yoqrTgGjVqGmJdMIruCDKjKCWfTvmd3jl@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7HgcQIyNo/h+OjHjnm7u+zsEWOZ0zYB1snxfsHd3WqndIVt5L
	YVi1Ge/lU0feTSes9PAflnuXB6lcO9XotahTnWfi+yuwhGvGlcW1ywIOYgr57Alj4AA/etRrUKN
	Q0CJi6x1gdQoh1W6WuneSMyarpl9mIN+y9PrwKmRM
X-Gm-Gg: AfdE7cnQ2jRwa3deDbJPofkGXTH7i9dde/VqW7rDouM86SDDHBGQNXojtNz7jUCGjNG
	/sONCVZWaHA/hXkaQsxa5KXIvo2/m7iMP+H51eqMD0Wb2asH50OD6Hyx9FAxSjBnUlB4+5h/c2W
	LrgZkg9+i5d+dVwez7BCWcRfE7C8OP01xvBTD8Lbump8Q7vkOJTU8S3Wj/ZGPUO7DZaN3fJ2J6/
	aDvX7ddAotse5VjdBiXoOjTh2eGKW3v0ptHojleZMD6WBezRTyvmzjRz5x+PQGLqNVIE6J0/0cQ
	XqwtxtfxlY30vBbOK6fp8xvOyWQ=
X-Received: by 2002:ac8:7fd6:0:b0:51c:523:9540 with SMTP id
 d75a77b69052e-51d7bd7292emr28840051cf.18.1784132029139; Wed, 15 Jul 2026
 09:13:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-2-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-2-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 09:13:36 -0700
X-Gm-Features: AUfX_mzWQymAiWtZQlBJB582QbB-RDSaqmDhzME45pNGf0-qJx6G_e02yGRYqOo
Message-ID: <CAJuCfpE1P=8RiSwm1FV2TCpM2FPo3A4VH5izpKR=J9F-_h5Y_Q@mail.gmail.com>
Subject: Re: [PATCH RFC 02/12] mm/slab: remove objs_per_slab()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: =E2=80=98typeof=E2=
=80=99 applied
> to a bit-field" but we don't need to keep a wrapper just for that.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasayan <surenb@google.com>

> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index de2d0f7d62b1..9867c03ef0ae 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t si=
ze, gfp_t gfp, enum allocat
>                          * memcg accounting works correctly.
>                          */
>                         KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc=
), 0U);
> -                       KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
> +                       KUNIT_EXPECT_EQ(test, ((unsigned int)slab->object=
s), 1);
>
>                         if (policy =3D=3D ALLOCATE_ANY)
>                                 return alloc;
> diff --git a/mm/slab.h b/mm/slab.h
> index f5e336b6b6b0..01535e1e2d3c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct=
 kmem_cache *cache,
>         return __obj_to_index(cache, slab_address(slab), obj);
>  }
>
> -static inline int objs_per_slab(const struct kmem_cache *cache,
> -                               const struct slab *slab)
> -{
> -       return slab->objects;
> -}
> -
>  /*
>   * State of the slab allocator.
>   *
> diff --git a/mm/slub.c b/mm/slub.c
> index a4be70d080fb..9e25f2dce7a6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2127,7 +2127,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags)
>  {
>         const bool allow_spin =3D alloc_flags_allow_spinning(alloc_flags)=
;
> -       unsigned int objects =3D objs_per_slab(s, slab);
>         bool new_slab =3D alloc_flags & SLAB_ALLOC_NEW_SLAB;
>         unsigned long new_exts;
>         unsigned long old_exts;
> @@ -2183,7 +2182,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #endif
>  retry:
>         old_exts =3D READ_ONCE(slab->obj_exts);
> -       handle_failed_objexts_alloc(old_exts, vec, objects);
> +       handle_failed_objexts_alloc(old_exts, vec, slab->objects);
>
>         if (new_slab) {
>                 /*
>
> --
> 2.55.0
>
