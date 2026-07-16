Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90635370AC7
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784176607; cv=pass; b=EHK0MHfpPj0tPyloavsb3l/HWo+jclDuqwcgJHNuuTC+HcOst0+V5OKSUrSdNbOBAbDAoNzZh/CF1Ry4EAgc6iP/NEKSIUz5jkGmBOUHoEFgts0sOVdwy5597JtvVHIE8uVNx8ZERTHrzMK3kKq8eCKUvGdxN6/FeHjyc2vIeR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784176607; c=relaxed/simple;
	bh=A/AnbnA9aoh3DJpkNRs1CtAgNkfbbricjqLSvFEDP88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+J6CBfK6Jtx6cnGjh0OzIVQ0cav2MaUw8fA5K61zS9N/q6AfObOU3qm98bt6HogN7VSAcUqUITgI3CwvfS+i7tk0eVqT6M7fSO7jZgCnXz7XWdoogbPNK7Xy4TFG8OkpuHjI3J7/rL34pTTztlc476CgyOmQUrhl5apxhlkNgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qJN/Vjqy; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qJN/Vjqy"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c10ed63c0so118281cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784176604; cv=none;
        d=google.com; s=arc-20260327;
        b=n2jWtfywahRQjhpCWEbioTABuD75An7NcBqzLuBSQ5Fw7U2tg7sU8+8YmQjTFzea/B
         gyN9Z/Blnd0j6GhYai4sIKR0kOj9QcmWNKc7loho/gqalSwhCL8eBfJysTOTyYL+mZUA
         93bnHmv3A9ouvepvN+SesJGzdGavyzuM/PLpVmoPCdZlzOLh7OICIf1xmYr//gsTCN+3
         gG4VhJBKIUNHsImbxuMgSO396dZ+Yrue1YsNekwh1T17MVyklKrqPixZjk/vtnuYFa92
         MFcZeP5AB1NW8VE/GZrPVr6tVorPHSia5gCQug+e42gvekV+g0nDAHQTvs2Z2MthOFlc
         iwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QITRJJ9I0wFb6SZoNyOXqNtZqIkjcQXWV4/MUrIOPv4=;
        fh=eNJ4Z29Ol/FGkbIc0kAjWzdRd1PfdW9o21b9AoB1+d4=;
        b=hWSXy4zaxBUEgOpGtXKpayPZiQC+zROuje1MufwvghSKdtZa2Z4FFollIs9Y9RN+wd
         sSX2R7Pl2y69PUYA3xxT57tGUyxLI8MnvQDU3sQ/y+mkop06eauPzqUvdLTlHxBqytAA
         YTsvIpKLJ1+fdOJUciT2zvVabGgx92YOcjku5NWDF87eNSnAgG0zND8ThgPZGEkEveth
         zWq604b1HSN12pUIB/6cfsZ1e/Rx881YTgxLCLtDp678RhcLodp0VgD+usGjwIlWsEqP
         pgmiJeaS6YpGkba1G/ImJGqOYE5FmMfswKQxqMBTR0fTbflObXxRvTCS7IvDn56982Iy
         iq6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784176604; x=1784781404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QITRJJ9I0wFb6SZoNyOXqNtZqIkjcQXWV4/MUrIOPv4=;
        b=qJN/VjqyQoclSoOpVDrekr4VszD6F377wm+o9gRjkzWdo/hgDpITrdWwr4icomOKfk
         7e7VeyZbCuvEXjB5AzrwC8cchqzo21eWU76SNS/lrezR7ACTTK5eP9p2HgGE1TgmnSAo
         YNpT/Z4A7u2GuKaWCLTvYvZqhtEeswZPFeFjSA6vSh3a5Yl7ReA5uWEUq2AslS9cTCan
         GLA0xBriENG+8bG15+wags/iMntdwc8UFN3gCNT5Gc5PXgXRXzgPJgc1CsfUi7iXrGSP
         pO2KKSFLh0QmiKQb3EIjVkEd8ncbAWpqOZoyb938AuCBCVXbKYEWCwRJY9yHISdYGC0+
         tFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784176604; x=1784781404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QITRJJ9I0wFb6SZoNyOXqNtZqIkjcQXWV4/MUrIOPv4=;
        b=MdUMZsCmbLC1IwmS3m42TZnClJIOPaijdJtEgvRbTJ3E4pV/q6lRjuzv+O0eLxYEwE
         EvszI4Fmpz99Q9KoXplOSaDNMtL7AGVxsgw2WX4ondk50dAoyNCPzatTLw/GG6m9hu9Y
         u/7ndxKFpT5vAX9YianWU4JFBUiiVenVEo6xErxmOr9dUtlhq6WMF3NfZEA7n54aHTu6
         3VaoYjKa39ZoTZd1Xrk1vruKkyhO4vLREB95osOMOvXumnfzLE4xWNQgqW4P415cWCVA
         x+Z+fD07YmF4nGG4hk//VwSymbBORnP2+UAIjjLPvFp+E8oAJoW6vv4rNiC7q8kHZlcJ
         nYTw==
X-Forwarded-Encrypted: i=1; AHgh+Rqz6UD9V1brwl6Vo0Ri9FVPZ8vf+uMXef71MOdh3gXFuGetaiHgVH71p2cDhpa0WyOftdQZ3K3s@vger.kernel.org
X-Gm-Message-State: AOJu0YztvZXnxPRTsBGocRsLR8A9tkAbChhbGy5W4HEAjDUbUC645Mho
	kxAlUPkkwFeGCBW9feCwRz8/n8jEvIZNnODxcQJeBAQZRVU3G/1yKKtuHnOkvyvXSe/LSD0ZKF5
	HLhqciwsXgZcRKpEPvqs0J9q8eUmO7baVxMYPYK7i
X-Gm-Gg: AfdE7cnBxWUxdi5W2ENit4v6TD91idMTtJ8zCSgqAS59eU21toIndKltBlVmSnsLX/H
	bK10IC2Aaq9X49rn+OQv8kL1POu7V8fv6VOM0YcfgwKwBK4Hw2EgQZVwJp4rixe7T+Ccu3szG2j
	HVVA9XzY8X00S/I7lIbgeA3LUwjDNivMg6hiIpsfZPydvOp+/m6b7FYDypDzCw2N0msHVZCdt96
	4hpYS3CUWXgn6rYPDLqurQMAljRJAWtu1hEaJs0W8EkFNduBVyYKd3Thckvlr9o53W2ILA=
X-Received: by 2002:a05:622a:598f:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-51f7b8edd36mr5923421cf.0.1784176603889; Wed, 15 Jul 2026
 21:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-11-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-11-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:36:33 -0700
X-Gm-Features: AUfX_mwLXx5kot7A00Q3hyCUcflgHM7XmoOgT0JJ9Nx_X_bElsMSswtKRvnAaew
Message-ID: <CAJuCfpEwBeuo-70-GZJ1jMZP6+vopmuEsBScvHki97ccRyDDuA@mail.gmail.com>
Subject: Re: [PATCH RFC 11/12] mm/slab: add slab_needs_objcg() helper
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> Slabs of some caches never need the objcg part of struct slabobj_ext.
> Introduce a helper to query this for a slab.
>
> Currently only is_kmalloc_normal() caches are considered as not needing
> objcg's. We could also consider all kmem caches without SLAB_ACCOUNT,
> however some might be used with and without __GFP_ACCOUNT concurrently
> and we currently don't restrict that. This can be improved later.
>
> To make the evaluation of slab_needs_objcg() faster in the allocation
> and free fast paths, add a obj_exts_needs_objcg flag into slab itself.
> This optimization is only available on 64bit architectures where free
> bits are available for the flag.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/kfence/core.c |  3 +++
>  mm/slab.h        | 31 +++++++++++++++++++++++++++++--
>  mm/slub.c        |  4 ++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 717e8baf7e5d..afeaf80484ad 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -640,6 +640,9 @@ static unsigned long kfence_init_pool(void)
>                 struct slab *slab =3D page_slab(page);
>                 slab->obj_exts =3D (unsigned long)&kfence_metadata_init[i=
 / 2 - 1].obj_exts |
>                                  MEMCG_DATA_OBJEXTS;
> +#ifdef CONFIG_64BIT
> +               slab->obj_exts_needs_objcg =3D 1;
> +#endif
>  #endif
>         }
>
> diff --git a/mm/slab.h b/mm/slab.h
> index a50347c9dbe3..948d075cdbef 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -81,10 +81,11 @@ struct freelist_counters {
>  #ifdef CONFIG_64BIT
>                                         /*
>                                          * Some optimizations use free bi=
ts in 'counters' field
> -                                        * to save memory. If these free =
bits are not available,
> -                                        * such optimizations are disable=
d.
> +                                        * to save memory or CPU. If thes=
e free bits are not
> +                                        * available, such optimizations =
are disabled.
>                                          */
>                                         unsigned obj_exts_in_object:1;
> +                                       unsigned obj_exts_needs_objcg:1;
>  #endif
>                                 };
>                         };
> @@ -580,6 +581,32 @@ static inline bool slab_obj_ext_has_codetag(void)
>  }
>  #endif
>
> +#ifdef CONFIG_MEMCG
> +static inline bool cache_needs_objcg(struct kmem_cache *cache)
> +{
> +       return !is_kmalloc_normal(cache);
> +}
> +
> +static inline bool slab_needs_objcg(struct slab *slab)
> +{
> +#ifdef CONFIG_64BIT
> +       return slab->obj_exts_needs_objcg;
> +#else
> +       return cache_needs_objcg(slab->slab_cache);
> +#endif
> +}
> +#else
> +static inline bool cache_needs_objcg(struct kmem_cache *cache)
> +{
> +       return false;
> +}
> +
> +static inline bool slab_needs_objcg(struct slab *slab)
> +{
> +       return false;
> +}
> +#endif
> +
>  static inline size_t static_obj_ext_size(void)
>  {
>         size_t sz =3D 0;
> diff --git a/mm/slub.c b/mm/slub.c
> index 4200e7105b30..771d73abacb6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3426,6 +3426,10 @@ static struct slab *allocate_slab(struct kmem_cach=
e *s, gfp_t flags,
>
>         slab->objects =3D oo_objects(oo);
>
> +#ifdef CONFIG_64BIT
> +       if (cache_needs_objcg(s))
> +               slab->obj_exts_needs_objcg =3D 1;
> +#endif
>         slab->slab_cache =3D s;
>
>         kasan_poison_slab(slab);
>
> --
> 2.55.0
>
