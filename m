Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DED22BE644
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784175955; cv=pass; b=j+oQPV5OTtEfWm2ghVVaMbBHqtGt0wEXWFx2Pxq2miPWJQD2SUDg27r+lD+Moxs+kT8Jr+6saN1IF19RDF1tJXgth1GI6ihNb7VCxmDn28oX4Yzg1XbyceD1e54urHyFreT89BA6BHMkvYa+Y8lk4SnKjcPpV99e+2r2AVFSMEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784175955; c=relaxed/simple;
	bh=x2J7YgYRU0WIZTnCdfWLkwufxqLsKFgYnWuW0ubCnb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKGtMaF8s6Lz60anSfM5ffVSkKhaR1zhUVjtQUWfI3AbBDjoUN/SVS6zHSqERCdRygE4zRWAD7gb5teE1HWeUbkMvejmr2lRsSpSypiQaxdlz9zC0Wsp8Us79ZmfODelPOgD4sLqO0FihM0PH8GHhCIhtYzyUn9dr1q2ZA/ntnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=stvwYUmj; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="stvwYUmj"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c15a5b265so161141cf.0
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 21:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784175952; cv=none;
        d=google.com; s=arc-20260327;
        b=ro+W97jlXhOWrNjFASk1ZdVO9xtKTK9J3hEVrTPUiR7pzSWC3t8/L0YjcTjbcFr1QR
         MMDI1rblWI7JOAxXrc/ZKLSjtB2hH0P8WVeObV9coLHKX90f+tyQzyREQYrrU9g70Vlx
         o5gkNxVh2qO/vhW+PyR0XKf+DBL/5JWzwXlGXB3H2s+sIKkQoSwavX74CNVFufEBPXKB
         +YtlqU7d/3sNBGjwgjPrO42GIZQFqeQ0Rwjc8KQCnhzBPOTR6N1s6kwdKX9JD46AxceN
         5k167mmmh4RK9jFRLpz5PeT34qvQJQ1Xl8MlmGb4jVcFUn7kMtwVnW8tdjiEgCGW2PHX
         zioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pVYCl3gFF/KqqrwQ8EI7oyBmG80AyMLJQ63EeA/h5/o=;
        fh=kb8vfNdyjaTNtnJ+sPsSXQfkkWty4K2qpVLNvh7zNTw=;
        b=joa9gopzpKbZvHPCuovtTDMh/GZiPrgbNWlMgkNgEGqcK3Cvgh6PcQjowFiuxPyRHv
         VcMSD2sq0/8iYXY1Ah393ZpV0n0mE821Gqto19tXYfe4giHEMQPnR8Nt2I+0ch45xKWN
         l73SniPOXMk1TJugvEwqQr2ww35OyHvOkHHYAh2bN/cPH+7sDChYvJ0FTkzsJ6gZwFl0
         NozXm7HU6dD7g71lhgUmsovwrgZYtVLCHw0KqjZVOcqANh5sOgth1FxJVLBc1hPkb7le
         Z7Mdsx64kZJbuT5G488wRVEe5PRh9B84+wkAOc2tRyHtQ/0YbJAhTUXkNkYPWMQGzY1m
         bq1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784175952; x=1784780752; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pVYCl3gFF/KqqrwQ8EI7oyBmG80AyMLJQ63EeA/h5/o=;
        b=stvwYUmjth4Em3mQbR28myOFn8cFsuG65Rn+iwLG6+boRnQNMbrrJ7F8pFC9bGTApS
         6pKKpzMazgAGi8+ZBh2Ejm6eyWL6QrIjG/tIGofN4tjKdPBxg73Yr7QytnhNKt9bWXgG
         3LDO9nDe1L9oDA/EObqvthsNn8qNn8PuFsyRvZcQURh8RNH0K4PQQbkB1lt5yK2o+ReI
         PgqASnXyCfD+LqRRDoMCNn6NsKEwJ4T8VCCkev9XfFduuD39d7DaWrayYqTJNRlEfzgW
         HNYjXOzYWeomDYJZCqha7Dz2LdfqYUIndaSWSNy91I9YVjuVdOQ9xnGnTFyobn2gwc9J
         3Dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784175952; x=1784780752;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVYCl3gFF/KqqrwQ8EI7oyBmG80AyMLJQ63EeA/h5/o=;
        b=VTawyHoeZwoqBLytZk6q194W9ScHsqh5uuUsyKtj13W7mY4opslvNUAN6Vufy6MYmB
         1m1sdCYFDX0v6ylz77DULKVWS+yzN2rwY4dS0ZlSbkR4yjH0tk2a/lGC9UhQtwW8jx73
         pb8o17unAqw4A3F/+1G9sZTPPZCQqxkDXf4NDcER+wICrHBFSPwqillUOnkXfeQkCMiZ
         yU4QzuF1fZeBE+XO/RuD5nELEF4AqyPmtqxv5XI0Vd2gBTr4nkGrCpUm0/mbOFooj3ng
         uXu74uzApbmeWyFXQgMXjmJhu+UjrTdYeEHrMQjgFW7lwChsjL7cH15R/sC6d0L9D7oU
         N7hQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTMPFT9N1Jex48O8USZqBiWDqQ/tfqk9z14dxo34xbLB1PhIBfZHxtP6uh+asXZEvFnoaaE1jS@vger.kernel.org
X-Gm-Message-State: AOJu0YwqfV1Jx3DwdL5PaeRLsjvzG17rlmVCCyAbG2qwtJPN+Ldy2RIn
	hEUcav8Ohli6bzYgHrqmR4pywpo48LDk5ls1QMy4cVBdfL/uKs+Gixg+Yua2dtnCA/k8+zG2/Kt
	hUfZqVC6EmPly7UKs3o+6oFqj2lv028LQnw37ODzZ
X-Gm-Gg: AfdE7cmTyj1Zc2KPiduBV6xsjHH055tX1LvX7LphY2NuHn1adp0XKH9cNx1f2QZywPc
	0TE7bQaT0zHe2xiSh/UxTQCIdHK1wMbH0SM6h2SKEiOaEJItkHk3JnalG9x+GZFJKyJSqSoZKoS
	VFzT0PWaxTakSGZt4vewoUo9Eo/XyuwTd1uNN/vuVzfnClz/7k9xwYQOleL5jQlw1diC+WZTUhn
	9VVp5ohpD3V8PGm0WAheTPEp4mZjTopa9EdQ9NX8GOOvEi79b4wjkKVQ4xP
X-Received: by 2002:a05:622a:15d3:b0:51b:fd5e:e81a with SMTP id
 d75a77b69052e-51f7f2d3c89mr4849471cf.20.1784175951747; Wed, 15 Jul 2026
 21:25:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-9-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-9-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 21:25:39 -0700
X-Gm-Features: AUfX_mzcvEykd5q7uqCxKTbaLxmiOsf8J2efBdBVlcFgCD-l4xFsXTifi66X4m4
Message-ID: <CAJuCfpGkpe=5O_vW9VKqKFxrBO+QquCD+mXth_qeUSqcWcW6hA@mail.gmail.com>
Subject: Re: [PATCH RFC 09/12] mm/slab: introduce slab_obj_ext_has_codetag()
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
> mem_alloc_profiling_enabled() allows evaluating (with a static key) if
> memory profiling is currently enabled. mem_profiling_support is a
> variable where false means it's not possible to enable it anymore,
> because the system was booted with "never" or it was later shut down.
> This is possible to query by mem_alloc_profiling_permanently_disabled().
>
> To make slabobj_ext array size handling dynamic, we need a snapshot of
> mem_alloc_profiling_permanently_disabled() early in boot, so that's not
> affected by a later shutdown. We also need it to be static key based for
> performance. Neither mem_alloc_profiling_enabled() nor
> mem_alloc_profiling_permanently_disabled() satisfy this.
>
> Therefore introduce slab_obj_ext_has_codetag() with an underlying static
> key for that use case. Its state is made to reflect the result of
> mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
> which does happen after setup_early_mem_profiling().
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 16 ++++++++++++++++
>  mm/slub.c | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 359ab8caf61e..dcca86799fc9 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -564,6 +564,22 @@ struct slabobj_ext {
>         };
>  } __aligned(8);
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
> +                        slab_obj_ext_has_codetag_key);
> +
> +static inline bool slab_obj_ext_has_codetag(void)
> +{
> +       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_=
DEFAULT,
> +                                  &slab_obj_ext_has_codetag_key);
> +}
> +#else
> +static inline bool slab_obj_ext_has_codetag(void)
> +{
> +       return false;
> +}
> +#endif
> +
>  static inline size_t static_obj_ext_size(void)
>  {
>         size_t sz =3D 0;
> diff --git a/mm/slub.c b/mm/slub.c
> index dd15af8abd62..4200e7105b30 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -213,6 +213,11 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
>  static DEFINE_STATIC_KEY_FALSE(strict_numa);
>  #endif
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
> +                       slab_obj_ext_has_codetag_key);
> +#endif
> +
>  /* Structure holding extra parameters for slab allocations */
>  struct slab_alloc_context {
>         unsigned long caller_addr;
> @@ -2415,6 +2420,26 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s,=
 struct slab *slab, void **p,
>                 __alloc_tagging_slab_free_hook(s, slab, p, objects);
>  }
>
> +/*
> + * Make sure the static key used by slab_obj_ext_has_codetag() reflects =
the
> + * value of !mem_alloc_profiling_permanently_disabled()
> + *
> + * Any later mem alloc profiling shutdown won't be reflected in the stat=
ic key
> + * because obj_exts with codetags might already exist.
> + */
> +static void __init slab_obj_ext_has_codetag_init(void)
> +{
> +       bool key_enabled =3D IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING_ENABLE=
D_BY_DEFAULT);

nit: This seems a bit indirect. Reader needs to remember that
slab_obj_ext_has_codetag_key is initialized based on
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT. Wouldn't below code be
simpler?:

bool need_codetag =3D !mem_alloc_profiling_permanently_disabled();
if (need_codetag !=3D static_key_enabled(&slab_obj_ext_has_codetag_key)) {
        if (need_codetag)
                static_branch_enable(&slab_obj_ext_has_codetag_key);
        else
                static_branch_disable(&slab_obj_ext_has_codetag_key);
}

It might be less performant but who cares, it's __init function used
only one time.

> +       bool need_codetag =3D !mem_alloc_profiling_permanently_disabled()=
;
> +
> +       if (key_enabled !=3D need_codetag) {
> +               if (need_codetag)
> +                       static_branch_enable(&slab_obj_ext_has_codetag_ke=
y);
> +               else
> +                       static_branch_disable(&slab_obj_ext_has_codetag_k=
ey);
> +       }
> +}
> +
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>
>  static inline void
> @@ -2429,6 +2454,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s,=
 struct slab *slab, void **p,
>  {
>  }
>
> +static inline void slab_obj_ext_has_codetag_init(void)
> +{
> +}
> +
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>
>
> @@ -8541,6 +8570,8 @@ void __init kmem_cache_init(void)
>                 boot_kmem_cache_node;
>         int node;
>
> +       slab_obj_ext_has_codetag_init();
> +
>         if (debug_guardpage_minorder())
>                 slub_max_order =3D 0;
>
>
> --
> 2.55.0
>
