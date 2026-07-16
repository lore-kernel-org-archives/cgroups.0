Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384225F98A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784165281; cv=pass; b=bu86C1urw6eAyLNH1m393UEzxaX7A1JyXhM2DH5hlLSbKZmVzfyKAnFPaR7ximeCMBMMmnTJX6MasMNNi92XC/6oTo9BGNp8m1rE4fhVFf2NTJBwutoOGbs9NucVl6dbrI2SARDvurEmYH7MB4yMLW2xpLgbxhbkqi4bkjw3nUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784165281; c=relaxed/simple;
	bh=wWNLG0R/Ju47ZgExm+myhmSssFISlp7IpPycwVDn5f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DlunEz+XlE8alllw2q0v54cDGu56VMEnXqjUgCkKeIQN8Vx5wO3k/IbKZCSLYDFR1vUSqwrMSQDcxuiXwMQL6iRh2N6yuwuzFMLGZfNoc4s3lkhbW4QM82h6AgkmpYnzEXv+9+dS5O8gcMri3erWtGso3NPGqAacGK0tLCGJj6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B0jiGAyj; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B0jiGAyj"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10e86e52so79431cf.1
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 18:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784165279; cv=none;
        d=google.com; s=arc-20260327;
        b=MH4HMHD0hs5JFEW4LxlguuM+TLGpu/Z6U26K4rOmFC+lko6k4kMsqOOruGyTqT6MKe
         EeizPSW2TjoFBCIX/FC9Ap6f683kXmLJ/Ay+hIOmahfnDa/IijgKivPZKELG+1vJ10QI
         8/ejXDfmXMlefdl2ronlonEh6z5jgu/Cql1Vzp66HxdCSAG+HSYOYnIaWKhE/v0lHp0L
         f4OGBOOaDcT6uqYW2eSZ/v0wm7iFu3s+WFio11bRM7Yr4uFwsPeOexS7Y3ruxFm28H5W
         NKV2fHk0Zt/ie1yv6SvnXI8ah4BYv8hpbLuY3eRydqgQP3BjzZQB5lzF9Gv7tRmD1zyh
         H5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        fh=TAaiRnJB8QX34GJRRyfXannyLj+3wDXhpNvzlNyGCu0=;
        b=OsM0vAWMLmEukhiGWaxw7zHIOdx0b/d/YdWrke78HF1DE76Q40MKxsfxUaR4cRhNug
         0c0wJUSlby2vPDN5FHhd/eM4vv79IGhMXkytiShHw7OA6y0IeUtOV7w3/azZkcw+NAc+
         ymO4qwQ3Ebwhl1ha3xPRzWg6hKkshbR9sCcdaS/Ml0biSj3ZmDl1Vp5NiAh9VUSGAdyX
         oT7vNwLLRJXFoxfnDpIW099iKRxFX7+xagPhJGISLkUekjIb7H2bqAPa5/WUeZCMYZb4
         XJBdItvrsdV9d+1HRHvxKn4j6zmjL7g8AI44dRPbSwReLmMhBAdINz6xZgfht0vd7yQL
         ymmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784165279; x=1784770079; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        b=B0jiGAyjdTD4c1zpu6rS9lPtob5Zasco/oan00lGSxxVKsxaiAlZw1byPb3F2cjN03
         3Xk1a4KznaUy0y9KfdlTaVs10NJM/JcSxIvSnOAlyznibmMC2qkacijxUaV5/uWBIsER
         KFnU/nfHgCimLbEkWvs4F9cOHQ+3pU1FkIuldDdaOWhRT3Bz7b+SzVWqv0VBEnVo2fWM
         y8QmIolUyoAIAsl8vNao2heg56AP1n0tCU+9k9Ev+wiL3w7BgEkXxRSroDZwRvYxYF9l
         DcMygQQFDBT87H+5PKG38oen1OiqQgW2YbqGJhGaWEkwPyzLDmopJKBtkOQsgOlffehs
         OL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784165279; x=1784770079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PA3pRdy5RNxLjfQOxJNOKUt8+gHRxgp3izrKjNvAOI0=;
        b=iZqif+gAs7ZZdX66yUe+JrWxyh9E9SnqbalNEKDl8MLWLvrq3d/Lo0DbIiqvC7Wzjk
         YxYNx9N1/UyF2HyPimABJDuZSnIQa1nyfXoXmwlwNHRzqcRoeD7n2VDRFQ8KJE6Uj3NQ
         pSjH2K78y3oPxO6Ae/RydW+sLeK/1qfczgvY0p3GG6AjFqUrPGVQyLb4ESTNDD+ubjlm
         rI7DaMkFYwsRcX0BbsmyRi5brx4xhKM8hSsUJ98Akt1k/6zsWlElMX1M7TPcFttdvYnt
         yMqgfmwGzg3MWwIwmqG2vJB5+9C/+P65dueMXs1Cs/HnoYRBGdfH87BlK3pjz5ezWuMu
         btFw==
X-Forwarded-Encrypted: i=1; AHgh+RpnBQFGIccHKDpBcOqnCCQh2NvaKppK8jrzZCuM1nE/Lc4uMrkWfL125JQr6ZdZ7cMh9ywigM8g@vger.kernel.org
X-Gm-Message-State: AOJu0YxlsbaoOfxlrkvs2j1pMUFibNnJGWQLs1ZT2ByOssEAVDgU/scQ
	IAxGV1JJLAKbDjSpWcLrrCraKs2zMP7QkBHudt6oc+2q+nq0RRW8Tj24fQBYYsx4N2qsX4H/jhN
	PgEae0xNOc+bVLTUQZnCnfG+xZCqt7ZomRzpyleJp
X-Gm-Gg: AfdE7cnHR3BkjFCBPOV11rL1W8AbrQVjtLJw5iwM2q1msCoeMHRcdB6sE8CBgWfDxjY
	/Qu1AcJzjukxvV8HcQPP5kdQ/uDTSAf/NB/CWM2MMtM+Mi8i0jZJ7KpgCm9TImMUQh3iUvleMCL
	XJWUGJpp9ZoKHRAqknwXhoVChv141TXeQ13thDaDWQLZooF4CZoZz7OH8qfQqnLEniCQGuYpRzk
	UO/fLaqiUxZ6pf6mK0Yey/+uytjRn4oBp8hjRvFGfYHr4XhrTmDKr6rTsE4
X-Received: by 2002:ac8:57cb:0:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51f7d272648mr4128911cf.2.1784165278136; Wed, 15 Jul 2026
 18:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:27:47 -0700
X-Gm-Features: AUfX_mw0hxBE87l_puhHNr7S0k7RJO-VLoBt5DLKGkywTu7tTOxb6OYu6XzRYSU
Message-ID: <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
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
> In preparation for changes to the structure, abstract access to the
> objcg field with a slab_obj_ext_objcgp() function.
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
>
> No functional change intended.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/core.c |  2 +-
>  mm/memcontrol.c  | 23 +++++++++++++++--------
>  mm/slab.h        |  9 ++++++++-
>  mm/slub.c        |  2 +-
>  4 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6577bd76954e..717e8baf7e5d 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -1249,7 +1249,7 @@ void __kfence_free(void *addr)
>         struct kfence_metadata *meta =3D addr_to_metadata((unsigned long)=
addr);
>
>  #ifdef CONFIG_MEMCG
> -       KFENCE_WARN_ON(meta->obj_exts.objcg);
> +       KFENCE_WARN_ON(*slab_obj_ext_objcgp(&meta->obj_exts));
>  #endif
>         /*
>          * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer fr=
eeing
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4e427286a88a..6303a2b1a9d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct =
slab *slab, void *p)
>          */
>         unsigned long obj_exts;
>         struct slabobj_ext *obj_ext;
> +       struct obj_cgroup *objcg;
>
>         obj_exts =3D slab_obj_exts(slab);
>         if (!obj_exts)
> @@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct =
slab *slab, void *p)
>
>         get_slab_obj_exts(obj_exts);
>         obj_ext =3D slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
> -       if (obj_ext->objcg) {
> -               struct obj_cgroup *objcg =3D obj_ext->objcg;
> -
> +       objcg =3D *slab_obj_ext_objcgp(obj_ext);
> +       if (objcg) {
>                 put_slab_obj_exts(obj_exts);
>                 return obj_cgroup_memcg(objcg);
>         }
> @@ -3577,6 +3577,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>                 unsigned long obj_exts;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
> +               struct obj_cgroup **objcgp;
>
>                 slab =3D virt_to_slab(p[i]);
>
> @@ -3612,10 +3613,15 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cac=
he *s, struct list_lru *lru,
>                 unlock_stock(stock);
>
>                 obj_exts =3D slab_obj_exts(slab);
> +
>                 get_slab_obj_exts(obj_exts);
> +
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> +               objcgp =3D slab_obj_ext_objcgp(obj_ext);
> +
>                 obj_cgroup_get(objcg);
> -               obj_ext->objcg =3D objcg;
> +               *objcgp =3D objcg;
> +
>                 put_slab_obj_exts(obj_exts);
>         }
>
> @@ -3628,16 +3634,17 @@ void __memcg_slab_free_hook(struct kmem_cache *s,=
 struct slab *slab,
>         size_t obj_size =3D obj_full_size(s);
>
>         for (int i =3D 0; i < objects; i++) {
> -               struct obj_cgroup *objcg;
> +               struct obj_cgroup **objcgp, *objcg;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
>
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> -               objcg =3D obj_ext->objcg;
> -               if (!objcg)
> +               objcgp =3D slab_obj_ext_objcgp(obj_ext);
> +               if (!*objcgp)
>                         continue;
>
> -               obj_ext->objcg =3D NULL;
> +               objcg =3D *objcgp;
> +               *objcgp =3D NULL;
>
>                 stock =3D trylock_stock();
>                 __refill_obj_stock(objcg, stock, obj_size, true);
> diff --git a/mm/slab.h b/mm/slab.h
> index 36d067d6e7c0..789bd292075f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
>   */
>  struct slabobj_ext {
>  #ifdef CONFIG_MEMCG
> -       struct obj_cgroup *objcg;
> +       struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>         union codetag_ref ref;
> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab=
, unsigned long obj_exts,
>         return kasan_reset_tag(obj_ext);
>  }
>
> +#ifdef CONFIG_MEMCG
> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext=
 *obj_ext)

I understand why you need to return obj_cgroup** but maybe instead we
can have a separate setter function and just return a pointer here?
That would also help catch cases when someone wants to set
obj_ext._objcg that was optimized away (for that the setter would need
an additional parameter to identify whether we allocated optimized
objext vector).

> +{
> +       return &obj_ext->_objcg;
> +}
> +#endif
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 5e3f53bcd0d3..48e10198a3ce 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         if (obj_exts) {
>                 get_slab_obj_exts(obj_exts);
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
> -               if (unlikely(obj_ext->objcg)) {
> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
>                         put_slab_obj_exts(obj_exts);
>                         return true;
>                 }
>
> --
> 2.55.0
>
