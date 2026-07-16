Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCCE23F417
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784166276; cv=pass; b=UBl2Sm6r28ECUz3JE1lfnBzRBB+uxSXZXaDN8Ww73UvRSbqvdLuu0A8u8aKuzIFc3QCLoWqcwHaj1rYzYv/XGFxwCrkjzxV1YCwunMOS1He3RYNLB3llaoKAPEofkDycRPC4y7enGY/NN0k0KMFxUEFuw+U4337HBa2DDu0l7x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784166276; c=relaxed/simple;
	bh=KmqIioJn9Ter9KKxK7as6Oj7kr6mkBii5EgVCECmxGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5BeIfcC5qvvvxzbFh7krAqsEPy+wbpm/iUYVx6+bCdk5fEAjFbAxf9DiDerINXkEFFnHKAm0Jczx+KqqVgzpiXXRH+FftIZ81KKh6GyfYLxrEfoWUeSShmr9rrZwO8+hbm/dg2syr0u8922gXaDE/tJFZfUJV37z5ULJ4MuH2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gp/HBa2o; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gp/HBa2o"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c01c79467so139011cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 18:44:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784166273; cv=none;
        d=google.com; s=arc-20260327;
        b=NtNZi6h2eY7Fv38TE/pK5JuFSyp+sEuOm/kwuzSHt9bcBlSJYxGC86prEzA6IpdLHo
         +EA+fI+sooAi1TndOTxATvY0g+CXu0QCJieTnf/JaNNWvs6QjpL56sw8RXFRxFpSSrKu
         2V8irTPh0hT0Da2D3+8EG5UQLJ9891/5S7fG0AkuHNcv3UsC9E9EfVWlSkZVsiQYCPY1
         lK8AnjXyxVdaF5N8oGtYUYLMcCALjN7bYECTLrBw/V0qXZKRYM8w9LMZ76lLt2IXExBv
         9m2GkGBwf/sscGCo6lciXZgexkvMbxaJyU6caDZqBUUQBaJVeuf/Vm25KZ97h6a6LvIX
         UWZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        fh=go/wtVIRDa9v9YFPpyMGmuhJ3E5C5UdLoSciv9jTRP0=;
        b=d7MxETcVWcIv0pZQpRbqCeQ8mXwEXOmhb6pH/DUOi+EzFswMGoRm88VgsDG5GWpHA/
         UKkF0MGswSvVL2r+AK5Sjixmm1LwIQyGbKUDTfRVB67BhcwS3hteApQjNlEc8wvb2IJM
         NSXBBrFbcQk6SiaivcNK0pVj6AHM/QLZNKf2fidXbQBH+udJufRrht5PeqClnq+4J8E/
         PgPDVCh1Zxzo6kDDg/fopSo+JSUqT5+shJAcAihywew5SDEdXtgznNK1y7EIHiW84VWe
         cBAivDap31GHIQM1NSgeMJo2Yq1LMmTJmYazwZlmCYjpIVHyBdwHj0JRqHigX7h6hwYj
         +uaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784166273; x=1784771073; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        b=gp/HBa2ooqUJEvkXh6+bR25Th26RdJwILdvp7zxHS7kBlxFMSpDR1xZmviEsu9be7D
         RBRPc0OhKiMMdSWfuo5tHTaVdtzJqvdR0U13n8KBIgFNXeECSd0OC4CJRq28fvCyo1NH
         qfTGzHPLC5YQ6yD6LvKnaUbe4i8ecZGE+P6tIfa4MWK+Ke7rKk0i8GheyAy0ISrYLq5n
         B2s0XlUrqC3pz/Gt3CScFINnkiZERUPdZkOyyqVBZ2QV3o/+tgMMIfaKbpTP6A6upkHn
         tKbYL8PJHVVOb+n7bYASHlafR+lUtTjS0MDHgdiqInLv7uLNUt5RDWhP1uVDIQXOeRFg
         mSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784166273; x=1784771073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HG6g4Qkk9mg8e7LcMujxWtHO9GGtUCyxtC9f/0mnmVA=;
        b=oyQ0vjgsU5wvjs/menRWw8X5HAUIBMelumPs430QtvM6XiO+cjmrAwaLmRxqmeAIp3
         uB8ANWmi7/2rwrrfalO2imTjhu5DontToEjNbBeEKYpeg7uEc7YKTZw3iw1hERWiE3DI
         h8oFUVGVGw7ebJP/4aSFb7P2ab4ZlyLyKbRFBdJ4/PzClpTpPpARUBKyiT7VD7gYeSrP
         Nu1mpbC5Y19KJP4he3ss9/e9OkViL0fmZqVeqL9WLWza8NWrHiAg8kM0vEf8bCdjcKss
         nltf2zZ0WO+eHZs079PxSBjjowutEUx/I7Ifs6ZhqqNcdQirQSKvtZYg3uS6jnP5CTrl
         XN9A==
X-Forwarded-Encrypted: i=1; AHgh+RqHRVYA+CCrpj3M1GezvNw3oVUIWH+WZvoRkFDvVaic+P5l351WmI1BkQceOcAjQImRSUTWZzDP@vger.kernel.org
X-Gm-Message-State: AOJu0YzsWUbqbmmevuasF2eKMV3wwyEao3QGgpOR5OPbh8euBdMFZ7Ng
	nM5MLdjvAWXlMGM8JId/OwOXE+EMePjzyweT0dNKFqvzZ2fOEHlxQXrwQoKYMiIPVwB6tNDgcbS
	j97+53chfsCCpYvvNFgMC3W8vtCGiuVcbYymsH5yJ
X-Gm-Gg: AfdE7cm45dxH0tIi4JMOl4r0oym6xry76mmZ4O6mBEB/ELm9fHhZcFXdBCUCo2V2hy3
	AWL2l6tyv+kQm2ussB1u8+qoHO0Ptjpt6r0XpJ3kmvNm9uxP0QW20uXMNTMcKLu4vcbafIUmizW
	NjRW1uFh4y22zmxX7qlAZ0F04bpfCQNz9drcnTGcL0Xg1wY4Suy1UYLw6cdLjbEfEQZrkdqFxJo
	den0daNly/OiJB0GEGPo0LV4nx3UNLaKdCJwQzE/gHGRv0BBZJAo6ba8mm91lAYpbRKalA=
X-Received: by 2002:a05:622a:40c:b0:51c:7a8b:c3fe with SMTP id
 d75a77b69052e-51fa52b5f3emr2319101cf.23.1784166272682; Wed, 15 Jul 2026
 18:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-7-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-7-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:44:21 -0700
X-Gm-Features: AUfX_mxRzfbpXvPbtzleNmr4pCqVCmMSR5OiMWvVmadzdCakdqzD_65vP0JDxsA
Message-ID: <CAJuCfpGVDnBJ9eBFBYSG=x4iYRPQa8EXNwT8raCWLbNyHQgTpw@mail.gmail.com>
Subject: Re: [PATCH RFC 07/12] mm/slab: replace slab.stride with obj_exts_in_object
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
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
>
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
>
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
>
> No functional change intended. Performance impact TBD, hopefully
> in the noise.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 43 ++++++++++++++++++++++++-------------------
>  mm/slub.c | 42 ++++++++++++++++--------------------------
>  2 files changed, 40 insertions(+), 45 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index e3f8e42070f1..3ad9777ad600 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -81,10 +81,10 @@ struct freelist_counters {
>  #ifdef CONFIG_64BIT
>                                         /*
>                                          * Some optimizations use free bi=
ts in 'counters' field
> -                                        * to save memory. In case ->stri=
de field is not available,
> +                                        * to save memory. If these free =
bits are not available,
>                                          * such optimizations are disable=
d.
>                                          */
> -                                       unsigned int stride;
> +                                       unsigned obj_exts_in_object:1;
>  #endif
>                                 };
>                         };
> @@ -617,22 +617,20 @@ static inline void put_slab_obj_exts(unsigned long =
obj_exts)
>  }
>
>  #ifdef CONFIG_64BIT
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e)
> +static inline bool obj_exts_in_object(struct slab *slab)
>  {
> -       slab->stride =3D stride;
> -}
> -static inline unsigned int slab_get_stride(struct slab *slab)
> -{
> -       return slab->stride;
> +       /*
> +        * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and n=
eed to
> +        * check the per-slab bit. A cache can have SLAB_OBJ_EXT_IN_OBJ s=
et, but
> +        * allocations within_slab_leftover are preferred. And those may =
be
> +        * possible or not depending on the particular slab's size.
> +        */
> +       return slab->obj_exts_in_object;
>  }
>  #else
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e)
> +static inline bool obj_exts_in_object(struct slab *slab)
>  {
> -       VM_WARN_ON_ONCE(stride !=3D sizeof(struct slabobj_ext));
> -}
> -static inline unsigned int slab_get_stride(struct slab *slab)
> -{
> -       return sizeof(struct slabobj_ext);
> +       return false;
>  }
>  #endif
>
> @@ -656,8 +654,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
>         index =3D obj_to_index(s, slab, obj);
> -       obj_ext =3D (struct slabobj_ext *)(obj_exts +
> -                                        slab_get_stride(slab) * index);
> +
> +       if (!obj_exts_in_object(slab)) {
> +               obj_ext =3D ((struct slabobj_ext *)obj_exts) + index;
> +       } else {
> +               unsigned int stride =3D s->size;
> +               obj_ext =3D (struct slabobj_ext *)(obj_exts + index * str=
ide);
> +       }
> +
>         return kasan_reset_tag(obj_ext);
>  }
>
> @@ -693,9 +697,10 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         return NULL;
>  }
>
> -static inline void slab_set_stride(struct slab *slab, unsigned int strid=
e) { }
> -static inline unsigned int slab_get_stride(struct slab *slab) { return 0=
; }
> -
> +static inline bool obj_exts_in_object(struct slab *slab)
> +{
> +       return false;
> +}
>
>  #endif /* CONFIG_SLAB_OBJ_EXT */
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 2bfcabc4c51a..98a14e5842a2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -870,18 +870,6 @@ static inline bool obj_exts_in_slab(struct kmem_cach=
e *s, struct slab *slab)
>  #endif
>
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> -static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
> -{
> -       /*
> -        * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and n=
eed to
> -        * check the stride. A cache can have SLAB_OBJ_EXT_IN_OBJ set, bu=
t
> -        * allocations within_slab_leftover are preferred. And those may =
be
> -        * possible or not depending on the particular slab's size.
> -        */
> -       return obj_exts_in_slab(s, slab) &&
> -              (slab_get_stride(slab) =3D=3D s->size);
> -}
> -
>  static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
>  {
>         unsigned int offset =3D get_info_end(s);
> @@ -896,16 +884,20 @@ static unsigned int obj_exts_offset_in_object(struc=
t kmem_cache *s)
>
>         return offset;
>  }
> -#else
> -static inline bool obj_exts_in_object(struct kmem_cache *s, struct slab =
*slab)
> +
> +static inline void slab_set_obj_exts_in_object(struct slab *slab)
>  {
> -       return false;
> +       slab->obj_exts_in_object =3D 1;
>  }
> -
> +#else
>  static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *=
s)
>  {
>         return 0;
>  }
> +
> +static inline void slab_set_obj_exts_in_object(struct slab *slab)
> +{
> +}
>  #endif
>
>  #ifdef CONFIG_SLUB_DEBUG
> @@ -1206,7 +1198,7 @@ static void print_trailer(struct kmem_cache *s, str=
uct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> -       if (obj_exts_in_object(s, slab))
> +       if (obj_exts_in_object(slab))
>                 off +=3D sizeof(struct slabobj_ext);
>
>         if (off !=3D size_from_object(s))
> @@ -1411,7 +1403,7 @@ static int check_pad_bytes(struct kmem_cache *s, st=
ruct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> -       if (obj_exts_in_object(s, slab))
> +       if (obj_exts_in_object(slab))
>                 off +=3D sizeof(struct slabobj_ext);
>
>         if (size_from_object(s) =3D=3D off)
> @@ -1439,7 +1431,7 @@ slab_pad_check(struct kmem_cache *s, struct slab *s=
lab)
>         length =3D slab_size(slab);
>         end =3D start + length;
>
> -       if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
> +       if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(slab)) {
>                 remainder =3D length;
>                 remainder -=3D obj_exts_offset_in_slab(s, slab);
>                 remainder -=3D obj_exts_size_in_slab(slab);
> @@ -2253,9 +2245,6 @@ static void alloc_slab_obj_exts_early(struct kmem_c=
ache *s, struct slab *slab)
>         void *addr;
>         unsigned long obj_exts;
>
> -       /* Initialize stride early to avoid memory ordering issues */
> -       slab_set_stride(slab, sizeof(struct slabobj_ext));
> -
>         if (!need_slab_obj_exts(s))
>                 return;
>
> @@ -2289,7 +2278,7 @@ static void alloc_slab_obj_exts_early(struct kmem_c=
ache *s, struct slab *slab)
>                 obj_exts |=3D MEMCG_DATA_OBJEXTS;
>  #endif
>                 slab->obj_exts =3D obj_exts;
> -               slab_set_stride(slab, s->size);
> +               slab_set_obj_exts_in_object(slab);
>         }
>  }
>
> @@ -3402,9 +3391,10 @@ static struct slab *allocate_slab(struct kmem_cach=
e *s, gfp_t flags,
>                 stat(s, ORDER_FALLBACK);
>         }
>
> +       /* Initializes frozen, inuse, and any extra 64bit-only flags */
> +       slab->counters =3D 0;
> +
>         slab->objects =3D oo_objects(oo);
> -       slab->inuse =3D 0;
> -       slab->frozen =3D 0;
>
>         slab->slab_cache =3D s;
>
> @@ -6537,7 +6527,7 @@ static inline size_t slab_ksize(struct slab *slab)
>          */
>         if (s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_STORE_USER))
>                 return s->inuse;
> -       else if (obj_exts_in_object(s, slab))
> +       else if (obj_exts_in_object(slab))
>                 return s->inuse;
>         /*
>          * Else we can use all the padding etc for the allocation
>
> --
> 2.55.0
>
