Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D06925F98A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784165320; cv=pass; b=Rz6XcjPkQTFqIMKYq2hTwcibJAO5b5fHSVtg/L2HJuWmQtvTzp7M70Wm/wFsOo7KeWaiqmcLXcBGhKJltqpxo95J6FPJM3hDyNX21EtU7QoxH6YT/CzYu3aHmOgi/229Ble+Ilu05jB2xKRYP8sQFMaGsUWeGhWdZRv3ZIpBRq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784165320; c=relaxed/simple;
	bh=aiLdTek+c4JGeySjK32yDrCalDwPZCkrk21vNPzOKHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HHXAxwZQa0BdFaqTzTQ2djTv3iWSUP3EyyPHpea0DoZLJusYJLD2OidasDgDiP5WhX3KnqaEh6BkST+0nXXmgtVIEthILLqLj94hDgE0mzdl/ZVt63Z92CRE72cRiRbT//Wl72vZjx43dxdRwsMnqmmmTc7344jV9KtssUwCdOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bs8gX4aJ; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bs8gX4aJ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c01c79467so136781cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 18:28:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784165318; cv=none;
        d=google.com; s=arc-20260327;
        b=dj2P8npx11acVrp1ZQ/BOmOuVPZ9DVmpHaDLWzcCAH7z1HUsdfz55qQN3EJfPDLY5l
         RJiE6cZS936WHerIiC7FnkEeAHcw6sTm4o0yYna9CistW6ah7CCUT/k3efm6IfeAEgTF
         XGOVyTcq49oDdArKlTlKJVUUMPHjLcibCgqClJaPx+nPBw8kho+XoJtTdCSYIYXes4rq
         ilyUCYa6ZffiNPwJ2kBKrjTbRS33bRKhLbr8h+fJMeUcEQ9duknuAWE8JPrNdf/ds0yU
         TCW79aw96dUio4FdGFTEkSvWcpP1TA9Bx107JxFOC+AQFJZv3KDewEWiQq7+ZTDgEb+g
         rJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        fh=SNszfigz0Ry8YJnCojNov5GR/5mKcPqV2iKGtLXu4jY=;
        b=avrS+JJKt3zJl//6B0UJ8Re6e11A/iYE6l8UqfWF3z7n2D1/yWvDl2CD4K0v9AC3v7
         +QMhl3m0j0ieVcJpOZk+zSZKEI4g2vDl8WDckxoDs1bdmTFkQfqkfNBvtKVF/VKyTnN4
         2zHyr1LKnUGKMMarX8ftn5VrOnLqwxIra3lqmJ90Fvp/D9TT9VlmJEU4Y/eBkmT8Yj7O
         SX288sYzRBjbKa3g3VmKdExhg3Mt+iYXcy6rIRHHr3kcYrfjUkTz4DFp44zviEUsd4B/
         fTQ642NF3buCvmPY1fcAcSTEvvY6VKv6u0b1kEOCz7/Ow7h4xBvdOJIWImRnLh1HF1zz
         wFug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784165318; x=1784770118; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        b=Bs8gX4aJfEgsEuADAfndUiLp+6zq56x4hkl2F9XeOEa2e2s74cp8+eT41Z3p2ILxl+
         PglqTjWVZkygHOMm6PLsW8SAIOkDOOY03n+a2qHpK0cWmuVpLDkbvOpy2ap4JihH4BGL
         7nO33pp8S0rkIJIb5IlCoEbWD8hhGFw6RGW+iWbtPUryMFtIDgjGN1iL4cHH3WdsH4i2
         d/39qL5JySQa4293yGE0kfldrhyy06vDoiSlqCCFHBmpqob89VlVQNo+TbumcQO1lkUz
         D1yMB1JL0iDxLHtANEAdSziTN04PrbXd4cTk6n3TM1G7zBsbX4INaT2/tZHEEOz16XVp
         Apsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784165318; x=1784770118;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        b=HIPcAvrfWyZ8ptdKout3DVak+SARAtQUjtOa0HEl0TFCnnb/3rak/hJZiCj89Vrake
         GoRVdqSS7or0e5PPagE9RuV91mzwZLtJQQTWWgWAcI3JnqoDhcHGG4MkkJqvEkyM7Npk
         pMqpp8GazYwoo3grgvqGBIGMpmGCVzTe35Yj0KOm2yOa5wuzVI1mBED/5z0NLy1YW11A
         /8D9L71iLG4Tf0byvZ/J663+BqF6GnNgNrQvs5vmrMZdNr27YoCf8BA2zTWY6Y82g1YT
         zoNs0Bi8s4bWbxQt1dsU1c3epiEhu3U56mG4GBe8t3h1KM0wvY/Fee64hE8CMiXPuoAM
         IrYA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2wD5v9PtOX8Kxw/A82s2p8qIPEEsiLWCHQ/rIxjU7i1kbBuFA08RcSBaVWQbdyBs8xgCajvJe@vger.kernel.org
X-Gm-Message-State: AOJu0YwSz3cYY2F6VEWgTLCYkcrOXl/uiydC1Ai/bgYzX6uz+pD5iX5L
	tAL9wXM/VSEX4C4a0UJH3Peaa7sHi80OGyigMruXnmkG2Vp5OvD0nOSMOVwDwkA2qet4iDn4EUS
	4BONlsWARs1nBjkqvYu748R10/XM6gZSeMyp9MJIW
X-Gm-Gg: AfdE7cmtjXumTfd+IUAUA5GTbTltL16hMLGKi5GP6bTK0i30htGa24OLLWibV5XuZoZ
	E72ZvLsxyhB0SgwA+EstEAd2gaj1vpqwzvIZwWo4xPtRHZex5n5j7MY2qr06JjaET9Kpp4lu6f8
	joVhDwafhqQK+h3TEoCUw1erFuS114EZojpTmw5m1X+9vRmNBZtAzjPOTB7DcXXLV37l/0cfa5t
	REreNJMgxJ/Gifg/pgcQYX4AtbldsvF5ecuPoi16JBJbvqlrFEqnjsrrsYR93aDxW8AfSA=
X-Received: by 2002:a05:622a:1246:b0:51c:ba4f:9d19 with SMTP id
 d75a77b69052e-51fa4eac1dfmr2460461cf.19.1784165317618; Wed, 15 Jul 2026
 18:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-6-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-6-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:28:25 -0700
X-Gm-Features: AUfX_mwQH8Mlxnc5oTVolGJX11YQsGRkdly9lMd9axGSJ4lMqluk9IRUY26sPCQ
Message-ID: <CAJuCfpFDhV=O+TS2+A6s+gXagrNBnG3fWuFcS9Jk3g2BHLU8YA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/12] mm/slab: abstract slabobj_ext.ref access
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
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
>
> No functional change intended.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 10 +++++++++-
>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 15 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 789bd292075f..e3f8e42070f1 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -558,7 +558,7 @@ struct slabobj_ext {
>         struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -       union codetag_ref ref;
> +       union codetag_ref _ctref;
>  #endif
>  } __aligned(8);
>
> @@ -668,6 +668,14 @@ static inline struct obj_cgroup **slab_obj_ext_objcg=
p(struct slabobj_ext *obj_ex
>  }
>  #endif
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +static inline union codetag_ref *
> +slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
> +{
> +       return &obj_ext->_ctref;
> +}
> +#endif
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 48e10198a3ce..2bfcabc4c51a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2071,18 +2071,20 @@ static inline void mark_obj_codetag_empty(const v=
oid *obj)
>         slab_exts =3D slab_obj_exts(obj_slab);
>         if (slab_exts) {
>                 struct slabobj_ext *ext;
> +               union codetag_ref *ref;
>
>                 get_slab_obj_exts(slab_exts);
>                 ext =3D slab_obj_ext(obj_slab->slab_cache, obj_slab, slab=
_exts, obj);
> +               ref =3D slab_obj_ext_codetag_ref(obj_slab, ext);
>
> -               if (unlikely(is_codetag_empty(&ext->ref))) {
> +               if (unlikely(is_codetag_empty(ref))) {
>                         put_slab_obj_exts(slab_exts);
>                         return;
>                 }
>
>                 /* codetag should be NULL here */
> -               WARN_ON(ext->ref.ct);
> -               set_codetag_empty(&ext->ref);
> +               WARN_ON(ref->ct);
> +               set_codetag_empty(ref);
>                 put_slab_obj_exts(slab_exts);
>         }
>  }
> @@ -2092,19 +2094,22 @@ static inline bool mark_failed_objexts_alloc(stru=
ct slab *slab)
>         return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) =3D=3D 0;
>  }
>
> -static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> -                       struct slabobj_ext *vec, unsigned int objects)
> +static inline void handle_failed_objexts_alloc(struct slab *slab,
> +               unsigned long obj_exts, struct slabobj_ext *vec)
>  {
>         /*
>          * If vector previously failed to allocate then we have live
>          * objects with no tag reference. Mark all references in this
>          * vector as empty to avoid warnings later on.
>          */
> -       if (obj_exts =3D=3D OBJEXTS_ALLOC_FAIL) {
> -               unsigned int i;
> +       if (obj_exts !=3D OBJEXTS_ALLOC_FAIL)
> +               return;
> +
> +       for (unsigned int i =3D 0; i < slab->objects; i++) {
> +               union codetag_ref *ref =3D slab_obj_ext_codetag_ref(slab,=
 vec);
>
> -               for (i =3D 0; i < objects; i++)
> -                       set_codetag_empty(&vec[i].ref);
> +               set_codetag_empty(ref);
> +               vec++;
>         }
>  }
>
> @@ -2112,8 +2117,8 @@ static inline void handle_failed_objexts_alloc(unsi=
gned long obj_exts,
>
>  static inline void mark_obj_codetag_empty(const void *obj) {}
>  static inline bool mark_failed_objexts_alloc(struct slab *slab) { return=
 false; }
> -static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> -                       struct slabobj_ext *vec, unsigned int objects) {}
> +static inline void handle_failed_objexts_alloc(struct slab *slab,
> +               unsigned long obj_exts, struct slabobj_ext *vec) {}
>
>  #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>
> @@ -2181,7 +2186,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #endif
>  retry:
>         old_exts =3D READ_ONCE(slab->obj_exts);
> -       handle_failed_objexts_alloc(old_exts, vec, slab->objects);
> +       handle_failed_objexts_alloc(slab, old_exts, vec);
>
>         if (new_slab) {
>                 /*
> @@ -2361,9 +2366,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache =
*s, void *object, gfp_t flags,
>          * check should be added before alloc_tag_add().
>          */
>         if (obj_exts) {
> +               union codetag_ref *ref;
> +
>                 get_slab_obj_exts(obj_exts);
> +
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
> -               alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
> +               ref =3D slab_obj_ext_codetag_ref(slab, obj_ext);
> +
> +               alloc_tag_add(ref, current->alloc_tag, s->size);
> +
>                 put_slab_obj_exts(obj_exts);
>         } else {
>                 alloc_tag_set_inaccurate(current->alloc_tag);
> @@ -2395,10 +2406,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>
>         get_slab_obj_exts(obj_exts);
>         for (int i =3D 0; i < objects; i++) {
> +               struct slabobj_ext *ext;
> +
>                 if (is_kfence_address(p[i]))
>                         continue;
>
> -               alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref=
, s->size);
> +               ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> +               alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->siz=
e);
>         }
>         put_slab_obj_exts(obj_exts);
>  }
>
> --
> 2.55.0
>
