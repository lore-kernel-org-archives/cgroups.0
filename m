Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3026113B293
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784163790; cv=pass; b=D4Bo4kBp9M/HeZ0FyIvugNN4gtcdeHSX6Y5LHwwyXTr3dEuV1Vc3E3BG5T8nePSQlh4R7bQcCugNAcLthaH9UfpNKtEy4cije2FllmoweETXGjEuq6UixzY2mnWKeSO/igEAj6DqFQ4YbPrSvV2HIjkkp0zA/AksYVY8vLj11CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784163790; c=relaxed/simple;
	bh=4HPCvjHvSCp1mP2PXUTRpJE8EUMlzi1PM4OTwnNk7+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLgyf6fV4+Ib/9vxAZkpj6hk6s1z2eqYk8KvvnltyB5GkV+lHPtAk37fY0g7Ox4TTRJITgbMDTgYnQsg3IFvR2phW7Uc+xSN8NfSLciD9ajCYPU8ELP+s/LKlpty4XnvEsT6VjmZ5lGwP3K0QAxxLLpyWnYhquWPPxQC4yxE3DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F20Iq3AJ; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F20Iq3AJ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c10ed63c0so77631cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 18:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784163788; cv=none;
        d=google.com; s=arc-20260327;
        b=r7Ik4fHjVwkvlARaRrthwjLGj/E++zSaxU3lmVhhojQy2XL7ZZsH6I5hJs9ey8KfKf
         fb0Bn25eXGi+gVgtKJFQquZm1WcWTF1i46DDDqFKCgDIhUpV8lk9LJg86DQL4SQbj1at
         87L8QOf5dcznG/89w/bNDAIeSRh7PwpQR6+3UfEv0d6ikMcAMtVxLi4wTG6FQ/0G2hBp
         JXdaUHyuNkQ/kzDr2aXHbJPT1TQeX4eSLy8RvdVbDCl8nl7vjsgMjzKB7OJGzmQdgeTV
         I1w4fFn1fHsCy7sPXUcVwA6tvo0xOWh9zoyGX0MbGYcyI9WBfKhPBDSU17uKm1FyTKei
         UUbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        fh=tAFlYIsaj/itFHyh1mSGQ3eH7ybjAB0fmOIL+5XSBog=;
        b=FRsXxkf5Hyt5vd12PQ8jkVZtZx1f41VDrp3KR7vkfAqrqGyoVFYlGz0uXKrOXnxj8M
         S5AEqg/zeY0K8KQ9kpOob1kLPJ6pSMCMsDNtieGMCbJ4q73rJmUEPfOPux7UC5B2yJIa
         jHKhZb2WTqu67FWPA9HVu4pnPv2fnDde243MO3j4v+3XJBsNyuKnjB9it35QWedLS57s
         jlo4ad2ZAVMSAvcx80cZcSjgTm2y8H48JHbvVtz+/43Ygibh9Or2Mraxt3cAhVnCpuiD
         nl3piLd0X6cJbDcYIvMXYKH/GH6xWT8DXU5p6X/0tSnV/aJ2DX5XIT/JmWM+QtrNet+h
         Hj2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784163788; x=1784768588; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        b=F20Iq3AJb0asmdMkEVGpgrAxWZE2CGmoZ9cSqURo2dmhHq2y5NZbZqV3reFqwBbUjU
         5ukxsJOe+CNTw/bhLo91j76OJ4XC1rvHncw0fQr+0KlfpolLfUG4Q6fTCU0Qj8hy1phR
         zntYBd85jTQq1VWvxb9Bp3T3e6pTn5iqSoem0uYQlrYkNujCNzued+UNy1mxZ2QV2AqV
         FvW99yAA0gvw/rRIeozTxXk82BQ0Rg+v06uA4/Ohy3lXkvhmb53dFE3U0prdAl5Yok1W
         JAoKSuMHGaG84N0QSCtwqS44f5NI2r3cXuewVINfNWpWkahZC2gPZRz52BoftpeqoScJ
         VXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784163788; x=1784768588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        b=jjzYFmPcAe8URGd/qCtxcbneq0PEegEArB7XbTicQ7Bejr3LxZDZkMwyxDqOJ9hmi8
         8P17lX6iKPMnNRcliFwvlELKFIfJljOpsfaSKssWRTjATVDiRGLCJD8MLQ4zZLEICUvm
         LaW4oUVBXvHYkzwovtQQKWPCGTHb9gWtCtEkkaPyesZTqilyQ3rVc74309SsSejDK4aX
         c/s4Wgth4HVmpZr4v5ylXQS1F9+L1FlgsRG4QRTYrbiqRZCTnB7EFizQi/yPI6V0GRy2
         m7lJgfaGHWgj81+YSqpDI+JxI97VN6u2NgOj3pmtIaZTKM7ujvWI26x95/1k5jXsXoYR
         NNwg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8pO2IoQaT2wXbV2WN+EATxO0YGwz3G7HnZtcjUS6Rs933lyB+ZIGkbpyUzhcm6BRvbQSUXwnd@vger.kernel.org
X-Gm-Message-State: AOJu0YzrwbOWt2dphcWGIaSYBUh/aL8U3+95L24ckwSmO0sBl6wwiNDn
	AQc80ajGVkgqd4ivLMk5igpUAeBeSJrNhdNoaXQfWFIBlmGsVY4U6IkgrV84K8Yipg0Mq1goOy9
	t/V99djEiXN0W5tuTs4JaWszKpURCxm+E1aLCy8Wj
X-Gm-Gg: AfdE7cmtbd4XbxBmZsAy4JVEKPY1v20mJ1oUEqYwGXi4Du7M2QMQmp5FcotSUUSuFpU
	mjvPV9huXYTfOPybNKyY4jJt5KPZ2nvDCNA+tDdcTi+lbbqJgHbl9wIUJO0eeal7N1oaxq3HjlN
	CTwKurU6S8Xoka4dce1+/9eDH8jUZIyDb9fw7urNwGV2sLbHwWgkoE0Xu9qGU7wJ1sqDz0H0Kbw
	YH2FDkGkGnqzil/0THz/ZXI/UTZHUf4blQpwDioKJmocFOp4M4FDrY8czYj
X-Received: by 2002:ac8:57cd:0:b0:51e:af63:e831 with SMTP id
 d75a77b69052e-51fa2e44190mr2311931cf.1.1784163787260; Wed, 15 Jul 2026
 18:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-4-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-4-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:02:55 -0700
X-Gm-Features: AUfX_mz4DPdQxxMzskTuOwtGaxTssBW96TnyywdO6bKuhvHoACEpqUhCrL0t3Cg
Message-ID: <CAJuCfpGBPkg=OFTX4iMMSu--YDK2yDtNcQXeO0Ktupc1uUqQgg@mail.gmail.com>
Subject: Re: [PATCH RFC 04/12] mm/slab: make slab_obj_ext() determine object index
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
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memcontrol.c | 12 +++---------
>  mm/slab.h       | 14 ++++++++------
>  mm/slub.c       | 22 +++++++---------------
>  3 files changed, 18 insertions(+), 30 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..4e427286a88a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,15 +2865,13 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struc=
t slab *slab, void *p)
>          */
>         unsigned long obj_exts;
>         struct slabobj_ext *obj_ext;
> -       unsigned int off;
>
>         obj_exts =3D slab_obj_exts(slab);
>         if (!obj_exts)
>                 return NULL;
>
>         get_slab_obj_exts(obj_exts);
> -       off =3D obj_to_index(slab->slab_cache, slab, p);
> -       obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +       obj_ext =3D slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
>         if (obj_ext->objcg) {
>                 struct obj_cgroup *objcg =3D obj_ext->objcg;
>
> @@ -3541,7 +3539,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>         size_t obj_size =3D obj_full_size(s);
>         struct obj_cgroup *objcg;
>         struct slab *slab;
> -       unsigned long off;
>         size_t i;
>
>         /*
> @@ -3616,8 +3613,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>
>                 obj_exts =3D slab_obj_exts(slab);
>                 get_slab_obj_exts(obj_exts);
> -               off =3D obj_to_index(s, slab, p[i]);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
>                 obj_cgroup_get(objcg);
>                 obj_ext->objcg =3D objcg;
>                 put_slab_obj_exts(obj_exts);
> @@ -3635,10 +3631,8 @@ void __memcg_slab_free_hook(struct kmem_cache *s, =
struct slab *slab,
>                 struct obj_cgroup *objcg;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
> -               unsigned int off;
>
> -               off =3D obj_to_index(s, slab, p[i]);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
>                 objcg =3D obj_ext->objcg;
>                 if (!objcg)
>                         continue;
> diff --git a/mm/slab.h b/mm/slab.h
> index 7bd361447c54..36d067d6e7c0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -646,14 +646,16 @@ static inline unsigned int slab_get_stride(struct s=
lab *slab)
>   * Returns a pointer to the object extension associated with the object.
>   * Must be called within a section covered by get/put_slab_obj_exts().
>   */
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -                                              unsigned long obj_exts,
> -                                              unsigned int index)
> +static inline struct slabobj_ext *
> +slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_=
exts,
> +            const void *obj)
>  {
>         struct slabobj_ext *obj_ext;
> +       unsigned int index;
>
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
> +       index =3D obj_to_index(s, slab, obj);
>         obj_ext =3D (struct slabobj_ext *)(obj_exts +
>                                          slab_get_stride(slab) * index);
>         return kasan_reset_tag(obj_ext);
> @@ -669,9 +671,9 @@ static inline unsigned long slab_obj_exts(struct slab=
 *slab)
>         return 0;
>  }
>
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -                                              unsigned long obj_exts,
> -                                              unsigned int index)
> +static inline struct slabobj_ext *
> +slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_=
exts,
> +            const void *obj)
>  {
>         return NULL;
>  }
> diff --git a/mm/slub.c b/mm/slub.c
> index 9e25f2dce7a6..5e3f53bcd0d3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2070,11 +2070,10 @@ static inline void mark_obj_codetag_empty(const v=
oid *obj)
>         obj_slab =3D virt_to_slab(obj);
>         slab_exts =3D slab_obj_exts(obj_slab);
>         if (slab_exts) {
> +               struct slabobj_ext *ext;
> +
>                 get_slab_obj_exts(slab_exts);
> -               unsigned int offs =3D obj_to_index(obj_slab->slab_cache,
> -                                                obj_slab, obj);
> -               struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
> -                                                      slab_exts, offs);
> +               ext =3D slab_obj_ext(obj_slab->slab_cache, obj_slab, slab=
_exts, obj);
>
>                 if (unlikely(is_codetag_empty(&ext->ref))) {
>                         put_slab_obj_exts(slab_exts);
> @@ -2362,10 +2361,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache =
*s, void *object, gfp_t flags,
>          * check should be added before alloc_tag_add().
>          */
>         if (obj_exts) {
> -               unsigned int obj_idx =3D obj_to_index(s, slab, object);
> -
>                 get_slab_obj_exts(obj_exts);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, obj_idx);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
>                 alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
>                 put_slab_obj_exts(obj_exts);
>         } else {
> @@ -2386,7 +2383,6 @@ static noinline void
>  __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, =
void **p,
>                                int objects)
>  {
> -       int i;
>         unsigned long obj_exts;
>
>         /* slab->obj_exts might not be NULL if it was created for MEMCG a=
ccounting. */
> @@ -2398,13 +2394,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>                 return;
>
>         get_slab_obj_exts(obj_exts);
> -       for (i =3D 0; i < objects; i++) {
> -               unsigned int off =3D obj_to_index(s, slab, p[i]);
> -
> +       for (int i =3D 0; i < objects; i++) {
>                 if (is_kfence_address(p[i]))
>                         continue;
>
> -               alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
> +               alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref=
, s->size);
>         }
>         put_slab_obj_exts(obj_exts);
>  }
> @@ -2489,7 +2483,6 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         struct kmem_cache *s;
>         struct page *page;
>         struct slab *slab;
> -       unsigned long off;
>
>         page =3D virt_to_page(p);
>         if (PageLargeKmalloc(page)) {
> @@ -2529,8 +2522,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         obj_exts =3D slab_obj_exts(slab);
>         if (obj_exts) {
>                 get_slab_obj_exts(obj_exts);
> -               off =3D obj_to_index(s, slab, p);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
>                 if (unlikely(obj_ext->objcg)) {
>                         put_slab_obj_exts(obj_exts);
>                         return true;
>
> --
> 2.55.0
>
