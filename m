Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD5014F112
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784177218; cv=pass; b=UZ9oJ8MYTjYqsgfrrRTYiIIb59qvqs8FLBQ3psKC7UpDotjOkirtxQI0qBdTmFjY8X+QDXurAA4aMWXznCGKGVzmXOclPxoD4f/pMqbLSCs/GUDjCzGYs4vrU7dVtX2EBUjhlVzyQoe4tCf16iVxAsV70Jykmcco7wLZ+L/zlKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784177218; c=relaxed/simple;
	bh=r9tMeIfnsk8MTtFIvkaqaDbeip/rrh7jyXC9aKBxDBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SslbrLahj7nCjrN6qz6ShySJZUIxPQ5NzqaYXORwvrZyLw08SI9mMR4VzckzyQWAYcC4y/R0xegcho3xXjy/iPYveltvYaUtzGvqK3vvCXuW0hDKHk5ThifgpuXtuuQ7RrG1pk0e6QY4ETxLgg/FPrlFaJsIRpCwmm4QPxiJsGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LLtpNQQF; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLtpNQQF"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c01c79467so165011cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784177216; cv=none;
        d=google.com; s=arc-20260327;
        b=E5zomCg2byQm3TjLILDFL4kIPrzi5O8ywojNybp7M9OLLfHPrgdy0lvur8h/qv0apJ
         7EWt/34fXyoPRQURp8fMUFdrtxxpdMJGgGWjQAyXBWUH8rz0CnKC/AWgBVPR6+CYS+Ft
         mlCb4lJkaCNDl4K/HkD5K7YMPw06T/+6RXDDXPf6FhACEn3axx+QCr41oK1E6plzU1Qo
         jQ7Wy5qv8GDmr4i2t3qP/Dc89LkSUuX0impjw9q22spLzC9KvFxtk63PT6Lx1bcQQ6rG
         rw1btXJq3z2XabJRCQ++okCshJ2frCCzutnl80FofYUxPEF5gHb+b9j2O95bKZOoDN3w
         xf6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QkYo68g6gezb441tzdBjHayPqeJqE9nrvYdojct+96I=;
        fh=jjmFsJK/cjuwvumCwRMPS7Fvjfun7boNnCFS8++qNQ8=;
        b=RZ0xYpyux/l/zqZQCUqxPVAuK9z9+/ol1LfMW4VHfdLXFlA2DtVvnfol5sBXBus+f/
         xygFFCUSh5P0gid2GLC3OCgabNNXo5DASHL5ntzNU44394tB8z8NOBH6cd3bpSqWrgcf
         OYiJ3YqPT5S7EDYw7IzVHN1YV1dqtuuWKVbBgSLrjy0/uprF2JgrX8u+uT6oQ6pnkDpy
         ZcrPauW0GTUEs/80X+TODhoMB0hS1d/s3AbutTE6Fr39JzdT+AEobRIwsEtY21yH73Yt
         b1lQyg0bfEMH+hV898kpw/1O/qm5O4uu4u9eFlTkUIiFeMlcFEvSEaoAnwF4qcMSV2um
         KXZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784177216; x=1784782016; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QkYo68g6gezb441tzdBjHayPqeJqE9nrvYdojct+96I=;
        b=LLtpNQQFuT9nStM15W8P/7lrjXRut/ysswh0UC79Ndg/bHfF5dpQ2a7QMrEgzklpfM
         w5mCYqi8Hdga3U4exQbGlo/UrGx6m9zw20S4wsYWQxHaDp3wW9foTEHB5qoyo5WAAjOf
         Dr+aoiWBxP1WxgY8syJVXBCx+6ZXjaGtkw0sEbPai6b3CT9P9C0EpM5GR9i0/Q1WvFBg
         b6RAkWJeHjWeGLH04rvM3Fp0J/B7uL+MTYWjSkaToN0lJCbZlAhFv1kfuzX8t+B94nNy
         FJfwa/PBUdY2UR8ZJ28ER8XmI72gfRGeCtyWoX7JKOdibfU+8IfCQX5R5gAKOFWBtD8p
         odmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784177216; x=1784782016;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkYo68g6gezb441tzdBjHayPqeJqE9nrvYdojct+96I=;
        b=Yqv62Ajym7t6g5kcak2951302OtvIQA+8z0RzErjWZ6gRkg13X7god5qHm5r4HyUUK
         imnso5Yr35vVw460MUTwK/DS5JJJu5VUiXhrImFHCUDOTYp+MwGsbF+WASmAcZYYH6Xo
         VodW2jqRXFlCTXefO9J0vjKETAm6NYwRUPtKheCE/xfEZl6d8IFRY/QF4+BZLA5iH7EY
         Z8Qkrq3PDX9+Lo1GroUTIrQVr+gQUJC89Bm/Oaw63H/JNAVM1fVfMDdLzADdlrQgqZkC
         RPgG5C+Bp7sxvi6C5ss5dvsqHOUge78lFcGAW5yVlaKY7GgsVQjBBGspwb6RklOp3yKQ
         JvJQ==
X-Forwarded-Encrypted: i=1; AHgh+RobC/JnsFfd1riyTi/tENG17D/EI+mIu6pl3vk6F2AdYaSGoxAc0pl5/THrS+KO49B8hALTmsEC@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7DVPfCQH8L8Fh/6t0BoNfbCGPEHCIhjAuTIsW4DXv+f+jm/OZ
	/SFiEHLg+28wyUYGF3imAWaUcKVQvXxJZBihCP73fp8OZxBPpKVshQTOVsVO0QttdXY8VaMVyUc
	ivcDFvlCWqTSyX62mWVhda5zTjcAf69xoJJn1tXoN
X-Gm-Gg: AfdE7ckUj88Ud1hbcAPdL4rxYkMpvYbwcJIuk7O0abopGr75/1z/MjGRwF/gehfnbql
	OI6Kdl8B+K3zQ1J2eZL8Y0hp93cGolx7/Ai/NH9j2AKNHC9z+dfO4tzubD0HBH2nZN/TwnTyBF3
	ymErMQl591v2TR+DC9eUXqcjO4Xc7i9IbRrhYVdiwGLbq3/u1yOqXx52/y0PoAEYFnKaHiDkC2C
	+cjB4P4NTTH4XAUsrjf1gwxo6AicKdj4kdnJsC+XUC83q5/U2gt0uuBwmOtObywrtubBVE=
X-Received: by 2002:a05:622a:4c11:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51f80c34977mr5409551cf.16.1784177215783; Wed, 15 Jul 2026
 21:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:46:43 -0700
X-Gm-Features: AUfX_mz_aFj-8xOsfsdMXRZ_fQhVoExHnQqcIqo8QRrYZa0FkludBjRw5lIFfIc
Message-ID: <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when unnecessary
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
> Start using the slab_needs_objcg() helper to calculate slabobj_ext size.
> Caches that we know to never need objcg pointers (currently
> KMALLOC_NORMAL caches) will thus stop wasting memory on them when memory
> allocation profiling is enabled.
>
> For things to work properly, we need to also add slab_needs_objcg()
> checks to mem_cgroup_from_obj_slab() and memcg_slab_free_hook(), because
> when obj_exts array exists for a slab only due to mem_alloc profiling,
> we would otherwise attempt to access a non-existing objcg pointer in
> that slab.
>
> The function __memcg_slab_post_alloc_hook() should not be possible to
> call for a slab where slab_needs_objcg() is false, but add a DEBUG_VM
> check there to prevent breaking this assumption accidentally.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

The change looks nice and simple. I'll take some more time to check if
we missed anything.
Only one nit below.

> ---
>  mm/memcontrol.c |  6 ++++++
>  mm/slab.h       | 12 ++++++++++--
>  mm/slub.c       |  3 +++
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6303a2b1a9d0..09659722ec85 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2871,6 +2871,9 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct =
slab *slab, void *p)
>         if (!obj_exts)
>                 return NULL;
>
> +       if (!slab_needs_objcg(slab))
> +               return NULL;
> +
>         get_slab_obj_exts(obj_exts);
>         obj_ext =3D slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
>         objcg =3D *slab_obj_ext_objcgp(obj_ext);
> @@ -3581,6 +3584,9 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>
>                 slab =3D virt_to_slab(p[i]);
>
> +               if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_nee=
ds_objcg(slab)))
> +                       continue;
> +
>                 if (!slab_obj_exts(slab) &&
>                     alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)=
) {
>                         continue;
> diff --git a/mm/slab.h b/mm/slab.h
> index 948d075cdbef..072cc2506756 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -622,7 +622,15 @@ static inline size_t static_obj_ext_size(void)
>
>  static inline size_t slab_obj_ext_size(struct slab *slab)
>  {
> -       return static_obj_ext_size();

Maybe now we should rename static_obj_ext_size() to
static_obj_ext_max_size() as it reflects the max possible size of
slabobj_ext?

> +       size_t sz =3D 0;
> +
> +       if (slab_needs_objcg(slab))
> +               sz +=3D 1;
> +
> +       if (slab_obj_ext_has_codetag())
> +               sz +=3D 1;
> +
> +       return sizeof(struct slabobj_ext) * sz;
>  }
>
>  #ifdef CONFIG_SLAB_OBJ_EXT
> @@ -741,7 +749,7 @@ static inline struct obj_cgroup **slab_obj_ext_objcgp=
(struct slabobj_ext *obj_ex
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> -       if (IS_ENABLED(CONFIG_MEMCG))
> +       if (slab_needs_objcg(slab))
>                 obj_ext +=3D 1;
>
>         return &obj_ext->_ctref;
> diff --git a/mm/slub.c b/mm/slub.c
> index 771d73abacb6..09c4931e5435 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2503,6 +2503,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, str=
uct slab *slab, void **p,
>         if (likely(!obj_exts))
>                 return;
>
> +       if (!slab_needs_objcg(slab))
> +               return;
> +
>         get_slab_obj_exts(obj_exts);
>         __memcg_slab_free_hook(s, slab, p, objects, obj_exts);
>         put_slab_obj_exts(obj_exts);
>
> --
> 2.55.0
>
