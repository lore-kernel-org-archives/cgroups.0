Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD3F30D40A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784175109; cv=pass; b=JTb5AQI7/CQ1sCa6cOnySwAeDgH8echpUC4L34jLOKBlCIubBf5ZdKx6sjNHyH6/ns7y20GLFfT7sE8YOm28CAJcwFZmteH9rWEV7tBIWgvKMIZCzY+WjOGCZQrAVSHYC8w4pcSYk6zfnzZvqpBR+wdlovMIxZDD3A/+HpPtnhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784175109; c=relaxed/simple;
	bh=SnctVqNMHifyjiQrx5QG8yoTRdoh14J2ybAjo9hwyYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uyCdbkosTlDEFSylZgZUbnxFnu+YNvwBPJOhcHwfk2e3BpVLgTWl195op7ELm2UzUtStbXJ5VrKBCv0Wd5NZHiS+1QPz8Qq/Qajqn/i+9b8AQjUpLr5gRTGOypjxBM9RVXaKziu5w2rzw7F/3CWa+dzcSKGz223+c5SxFl+dDuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKp2V54w; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKp2V54w"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10ed63c0so113771cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784175107; cv=none;
        d=google.com; s=arc-20260327;
        b=fl59xorBmQze2jVDLcFRPK2bK3U92XE+6LTImomc6719VsqDR6wUfr9sFj1c9ho8m1
         cuW47xg6f6+x7LieEEcjwR2xL0Xm8Gt0CobY31SK90ZHiz6v8DdwaOJecR/MdQB27yps
         uk9kPp1PMF+oAc7vcSVsNcmoJK6wBCDfOH7wgtWDikwoWWK+IzZvepwJQkkeEe1AkyPD
         bANR8igouR8DB2zn9wNkEy+JnEWhfngHckQG2db4n65bP+5rlx0czCYAq3QKEtHHfKF2
         +BYWaru96iD4mSsyNIo9mNHgkflxceSSFRG8eg97nawKMmAE0kkiAopSKZmV6DWe8yrK
         UINA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NrULQ860uqutCMctJCUNcuP6jCmEncIkfJ8w3bYOK54=;
        fh=gCdLdLm5066FbiB0QRam0ISOM5hxd2pD9/uOvYpXFp4=;
        b=mGicOfEOaSqhfHgkL9B3SvlVHelwR0TcMCRJ5NtgzekDDdBKrlKxLQCWEvWA9R9nIh
         vRRJ75CFIomLeiT/l06pG7YaRD9lUkNTv7w4lJgu49LPy1cuUicZL2cHY1T+i1kwRO/U
         6muXxpszKHTqSM/I5EEwYn0AyQjvp/rf8RK2vp8V/4/EZfQ3yVlgxwnLIqiipttyNUPX
         BHCCNrvLR8UyLLhf1wFdg6RNd2f7N+Crt0bSwk1Ov/OWo1Mhm/SH30DjiJ2eq50y99cW
         NmeqbN4qYx4YYQj5YKqfDxklEj+bic+2kvhqKTl/AXIbFMvJalk1SP+cn8G70gR4WsL5
         XVeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784175107; x=1784779907; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NrULQ860uqutCMctJCUNcuP6jCmEncIkfJ8w3bYOK54=;
        b=PKp2V54ws5Xp62jvyp390c4NzDm+EM2Q51egx698AYj5YPnvZxPcmz21zQEdOb5s9g
         q12nS/2itHhH4EZ8lWDHwZwGyHFmqM3WsuBxdIZddlXNnoqGRVKsgPg4esfVElWua5iZ
         3aPrCMAM5o1opNU9tlznauVoL9P8k277kJVixhnOVCiu/jGloNjgFq1IMXru/4YaxGR0
         NohkgawZkBnpy8e5REqQSxHFhagbBfqlpqgcjbhoUtGsIqDRJVNZjTvM9GA1BsNdtC77
         BRCXqxW0ErD0FyKI5qcCmTzvmrpNvAlCaGs8XELcPQCLXmLLzRMEmeEZTE4oHHw37zq5
         27Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784175107; x=1784779907;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NrULQ860uqutCMctJCUNcuP6jCmEncIkfJ8w3bYOK54=;
        b=mXIWlOz5KfcgwnF4bhndGebul0Fj0dmT1rmqFYH6JrzM8HfBPqZV5jvwS+Ib2npXl4
         e+oIuSWDYpLphAT7z+xKf00kaU0hYbRjndayYaBLgJQLoTgOkf5cyuB49TCjFsd3tSnU
         l72tfi6tbAIL+OqmAcGZGyOqCKf0fr8x5ZETNKN+VeA5skDS3S4fmCmPNCZrghprD1kV
         /gzdKGhwZvX3XEIfuehNpocz3WcooCPPUjbKGRyrNqFCgAozGHlFZYvx4n2S9/JcadfN
         b38Lv+en2R4cydZHtbJld/zrE1PZd/pExff1VZWqz4gpWv7+XhUVI1wK9BEt2nWaHmdK
         0gNg==
X-Forwarded-Encrypted: i=1; AHgh+RoXpR4ynDEDnkNh4GUfDMQc5dckv+5nNZIVxzc3kuT9dB4kv5C7SCDZLEW5gp8RVpi7olrvvnFb@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHVql7ySBdBQVutvP3TxNoPgi2z+qGgj61zVg0pWKnKRN1OcD
	zfxb4dVIdxOl020mHlYyom0iPtGUJD9SrZJiIPEKI1NrpqYxhjXf+YzowGq7CDx2dcpbUnJ48TC
	63Scb77K5cqiAH2Dp0WAmhGuC4xezLGyR6+zSGa/e
X-Gm-Gg: AfdE7ckVLFVeV1GfzmSl96P/v3UODFXmeuMzFB/KnAwQp7wvfn8KbcfbxPjc4CGr5CD
	nR5K58x7Zdv2TlRcCj/MusabGK5iJmPmSn4NKXJOkOOVAquTqOQuE5opsxc2txO5XtMgWyFQxmW
	dML8Hp/d5VonLflCydOVhheAPcgBZ5STyY+BFhsL51twDK2Dl3GQFawytePfpzba9ZL14koNjhV
	PccyKCiZmBP3jKfcWGi+M3fDeSWMhUtxYLMuQ3H8DFs4Qy9UClTXC1fSrhU
X-Received: by 2002:a05:622a:2c7:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-51f7e70546dmr4830331cf.8.1784175106282; Wed, 15 Jul 2026
 21:11:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:11:34 -0700
X-Gm-Features: AUfX_mzmBxfVFHGAloT5zOeFHiT-qyP82qT-DjMIIzg-ZYl4231yZILA88Rx53s
Message-ID: <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
Subject: Re: [PATCH RFC 08/12] mm/slab: change struct slabobj_ext to a union
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
> Currently, struct slabobj_ext can hold both objcg pointer and
> codetag_ref (when both are compile-enabled) and there is an array of as
> many slabobj_ext instances as there are objects in a slab.
>
> This makes the layout fixed so even if codetag_ref is unused (because
> memory allocation profiling is disabled), the space for them is
> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> do not ever need objcg pointers, leading to wasted memory with memory
> allocation profiling enabled.
>
> To make this more flexible, change the layout so that struct slabobj_ext
> becomes an union of objcg pointer and codetag_ref (to ensure uniform
> size; in practice both are the same size anyway). The slabobj_ext array
> then can have twice as many elements as before. For cache locality
> purposes, the effective memory layout is unchanged, so objcg and codetag
> ref for a given object are still adjacent.
>
> static_obj_ext_size() returns the effective size of (0-2) struct
> slabobj_ext's, depending on the config. slab_obj_ext_size() is currently
> static as well, but takes a slab pointer so it can be made dynamic
> later. Replace all sizeof(slabobj_ext) usage with these.
>
> No functional change intended, the layout is still effectively static.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

This is much cleaner than what I was preparing. Nicely done!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 41 +++++++++++++++++++++++++++++++++--------
>  mm/slub.c | 17 +++++++++--------
>  2 files changed, 42 insertions(+), 16 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 3ad9777ad600..359ab8caf61e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -554,14 +554,34 @@ static inline bool need_kmalloc_no_objext(void)
>   * if MEMCG_DATA_OBJEXTS is set.
>   */
>  struct slabobj_ext {

Perhaps we should add a comment here stating that every element of
this union should be pointer-sized?

> +       union {
>  #ifdef CONFIG_MEMCG
> -       struct obj_cgroup *_objcg;
> +               struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -       union codetag_ref _ctref;
> +               union codetag_ref _ctref;
>  #endif
> +       };
>  } __aligned(8);
>
> +static inline size_t static_obj_ext_size(void)
> +{
> +       size_t sz =3D 0;
> +
> +       if (IS_ENABLED(CONFIG_MEMCG))
> +               sz +=3D 1;
> +
> +       if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
> +               sz +=3D 1;
> +
> +       return sizeof(struct slabobj_ext) * sz;
> +}
> +
> +static inline size_t slab_obj_ext_size(struct slab *slab)
> +{
> +       return static_obj_ext_size();
> +}
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>
>  /*
> @@ -650,17 +670,18 @@ slab_obj_ext(struct kmem_cache *s, struct slab *sla=
b, unsigned long obj_exts,
>  {
>         struct slabobj_ext *obj_ext;
>         unsigned int index;
> +       unsigned int stride;
>
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
>         index =3D obj_to_index(s, slab, obj);
>
> -       if (!obj_exts_in_object(slab)) {
> -               obj_ext =3D ((struct slabobj_ext *)obj_exts) + index;
> -       } else {
> -               unsigned int stride =3D s->size;
> -               obj_ext =3D (struct slabobj_ext *)(obj_exts + index * str=
ide);
> -       }
> +       if (!obj_exts_in_object(slab))
> +               stride =3D slab_obj_ext_size(slab);
> +       else
> +               stride =3D s->size;
> +
> +       obj_ext =3D (struct slabobj_ext *)(obj_exts + index * stride);
>
>         return kasan_reset_tag(obj_ext);
>  }
> @@ -668,6 +689,7 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab,=
 unsigned long obj_exts,
>  #ifdef CONFIG_MEMCG
>  static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext=
 *obj_ext)
>  {
> +       /* if objcg exists, it's first, so we don't need to do anything *=
/
>         return &obj_ext->_objcg;
>  }
>  #endif
> @@ -676,6 +698,9 @@ static inline struct obj_cgroup **slab_obj_ext_objcgp=
(struct slabobj_ext *obj_ex
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> +       if (IS_ENABLED(CONFIG_MEMCG))
> +               obj_ext +=3D 1;
> +
>         return &obj_ext->_ctref;
>  }
>  #endif
> diff --git a/mm/slub.c b/mm/slub.c
> index 98a14e5842a2..dd15af8abd62 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -803,7 +803,7 @@ static inline bool need_slab_obj_exts(struct kmem_cac=
he *s)
>
>  static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
>  {
> -       return sizeof(struct slabobj_ext) * slab->objects;
> +       return slab_obj_ext_size(slab) * slab->objects;
>  }
>
>  static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s=
,
> @@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, str=
uct slab *slab, u8 *p)
>         off +=3D kasan_metadata_size(s, false);
>
>         if (obj_exts_in_object(slab))
> -               off +=3D sizeof(struct slabobj_ext);
> +               off +=3D slab_obj_ext_size(slab);
>
>         if (off !=3D size_from_object(s))
>                 /* Beginning of the filler is the free pointer */
> @@ -1404,7 +1404,7 @@ static int check_pad_bytes(struct kmem_cache *s, st=
ruct slab *slab, u8 *p)
>         off +=3D kasan_metadata_size(s, false);
>
>         if (obj_exts_in_object(slab))
> -               off +=3D sizeof(struct slabobj_ext);
> +               off +=3D slab_obj_ext_size(slab);
>
>         if (size_from_object(s) =3D=3D off)
>                 return 1;
> @@ -2089,6 +2089,8 @@ static inline bool mark_failed_objexts_alloc(struct=
 slab *slab)
>  static inline void handle_failed_objexts_alloc(struct slab *slab,
>                 unsigned long obj_exts, struct slabobj_ext *vec)
>  {
> +       unsigned int stride =3D slab_obj_ext_size(slab) / sizeof(*vec);
> +
>         /*
>          * If vector previously failed to allocate then we have live
>          * objects with no tag reference. Mark all references in this
> @@ -2101,7 +2103,7 @@ static inline void handle_failed_objexts_alloc(stru=
ct slab *slab,
>                 union codetag_ref *ref =3D slab_obj_ext_codetag_ref(slab,=
 vec);
>
>                 set_codetag_empty(ref);
> -               vec++;
> +               vec +=3D stride;
>         }
>  }
>
> @@ -2127,7 +2129,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>         unsigned long new_exts;
>         unsigned long old_exts;
>         struct slabobj_ext *vec;
> -       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
> +       size_t sz =3D slab_obj_ext_size(slab) * slab->objects;
>
>         gfp &=3D ~OBJCGS_CLEAR_MASK;
>         /*
> @@ -2270,8 +2272,7 @@ static void alloc_slab_obj_exts_early(struct kmem_c=
ache *s, struct slab *slab)
>
>                 get_slab_obj_exts(obj_exts);
>                 for_each_object(addr, s, slab_address(slab), slab->object=
s)
> -                       memset(kasan_reset_tag(addr) + offset, 0,
> -                              sizeof(struct slabobj_ext));
> +                       memset(kasan_reset_tag(addr) + offset, 0, slab_ob=
j_ext_size(slab));
>                 put_slab_obj_exts(obj_exts);
>
>  #ifdef CONFIG_MEMCG
> @@ -7930,7 +7931,7 @@ static int calculate_sizes(struct kmem_cache_args *=
args, struct kmem_cache *s)
>         aligned_size =3D ALIGN(size, s->align);
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>         if (slab_args_unmergeable(args, s->flags) &&
> -                       (aligned_size - size >=3D sizeof(struct slabobj_e=
xt)))
> +                       (aligned_size - size >=3D static_obj_ext_size()))
>                 s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
>  #endif
>         size =3D aligned_size;
>
> --
> 2.55.0
>
