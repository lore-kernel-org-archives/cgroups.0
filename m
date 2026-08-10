Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0665C38E8D0
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 08:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349206; cv=pass; b=PG83pKBkoFsnEpGezOm9TctAivwbIZFbblRw/V2FqQ/pOJZ/qsNqEbD+oCgRi9iDbpR85OBdMF5DlpsTr0pWNkYPBYsc1VK6DNuSHG9TUdRvT/8XuZylC3vbwzzPJjCmUZB5p1+gg1HxxjpkDNpn4lFrYKRAh3llwib72KYy22U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349206; c=relaxed/simple;
	bh=IyNx45s7UpB2wpQypLQirNntbYPacMSWeVfqoF3CRQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G2bs4zrTee4nPlJ+FHrUQkiRap0iy74IYhNoFZK8s0YFV+0Ff1T0PqXdHq56IHLZPkk9cM9fe1eZVRoP7HLtOgwtGyARx7VRZyPuW36jpd5vrIUvrOBURj+F7vMKbw9bWwifc10rt9JmNyhF9iCoz4ZJId+CDm9rUGoImCjcpJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dK3ViYqS; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dK3ViYqS"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495502852d1so924835e9.2
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 01:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786349203; cv=none;
        d=google.com; s=arc-20260327;
        b=rqGSv17Fh/x30k2PBzOj+hoHXrTw97X4mqvG+CWLjUYuyZvi8TxjmJadgMrbmGV1vB
         e2fTzQ0rTubEVzyfpadRodvsltdkAvbXbkmGJf128I+ZOQoeRNG/GnjNODRRZI8N+F4J
         deMWPaYD4syyWIrypccidE0ehQlUUPxrx7eafnDapHHWc1rehQTzsGWLCDgjipaUEGRY
         XX+91by70bVILYlzvgx7eLX/b/Bc6SwYDgVU4MIlWp/92Ee7s7Pfjhp4h0zKfJijr00b
         20FUbiF4Z3HYHlDwWkOixRh2WlxHzuLKlugaPbV6P1I4fKABdJvmd5fuQ7ZDDh+lz1fB
         Mxcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        fh=ZXJUJQ9BjrCTUw4YJVV4As5p5CTh9aev27uO9wvkgB4=;
        b=Irxna+8lvkwwkwxNG52p0Jmg/KhIbMV49ZalEy0D5Or6XltLYSu8T08U+gMSzqp1MB
         6s7fnGbBMP6F9pL1vpjV3Apxt4xkBHpTPixKxwKRA3kCp2X+Y//5+OethDPua+x+SsiX
         m4tnaNzEx691Tt1oEtt/JOegfP9yEziz7NE7yWuFY6whcsslH38EjucKShGNNipx7W9B
         i5LQGifCs7/FtnBfHDlq/leJIG6gbXFkbVEIF18unqrR38LC3pDw1WXScLCCyngT+PKV
         iOg7arv2DeZ7rFOmAWWyMdN3u6Vly4D6bP3BDthxRSzGk6ol5OTYwRA6O1SgLeqwx3K8
         oqcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786349203; x=1786954003; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        b=dK3ViYqSkmsU2MTD2y8vBQVesBUQRAmWREeIuVFMMNecIV2sDRVByz/XmK6SwB4IKQ
         FjWrk0ZrzzoBMuEmnDGdaa8hv1b9vuZp3epAi1YVS9CreJpcNNHV8R2EsWbo2iQRIPNk
         EzILe4NtkbavfC+8cyqx3ws+2JsnmBUcBDhAodpaiftlgLBsR55YLgw0XxQXLNCr3I22
         qKlOHgLRf1Hfb2OpNtxbUA/dBHUPPxA9x3N2I7GwjUHzXCZog4JJ6jUbocmod9yOoZUy
         5qpjOJit+T9qyYxTh9f9/Wd5hk+KCwR/pkP/jeK1d0BovTpwkSQeO82UyNYiXio06TUt
         xl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786349203; x=1786954003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lb84MTARn8U7o4c1RHhqcBiYy05PvlUptLl1sMIzsSE=;
        b=rUJQdMVPTS/h/bvyE4jHyTp49NXpJsBtaEosxxazu7xqabh9WHtI7TWdcGrVZosmc4
         s9yKuF9Dd/ANz1BD259JpgCkxBf0Qn9lxDd8wvGljPH+yAlyCyGT7Zbsvl5zMVM7VVwo
         6wI7Z6njKmPFAeHhSJAjL/xufLU0aySxgowuGFn+R2i5GEPjf2A7UekNagkTPGYRD16b
         zFZji4x+bqqc+PKNnby2eX+ao6xa9OtzejXnwhBIy/AfJG15jgVcDiHMnVempXBzg9Gn
         O0ZVDveU1PhElAGJzQRa5oVwQ8dfP8lwO8bxjqs9kgLR6twmva3cwNr2PnxAo402BuEv
         4S6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp3gvoeCpuilnn4QJG4dWf/tuFp8kMWsUZtxvSYX7NmDfNS0ppUFJ+aqIVu2RVZfbpVUJI2BF2Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyUZOqXcn2KvsznTKhxZiWpKw1Ni/kqIfP71inPQAR1Nvbn1BHu
	36RcIDhdXP9W4vkrSiiDOTtC6Pf2uvTkBLGA2fqwJ1BP94HzKzWr8PWP0Vl2d6sux0cdOvGDkl7
	gDSHquq9VqQPPwLoGkq6Ji2CXZZwbWvA=
X-Gm-Gg: AR+sD11f0gy8JYZJuIAUux1O7OtQq+nDVIV+lPCHyYh3CvENUYMDOdeLAUKBYlw8bxn
	TNXNLhDOIGrxwcLDwZW1ENIvdlJdqV2oWy24oP68/9wXyK4C8En1XDc3Lcb9BXOrnNiXEye7vke
	j9y1BfCPlNYuSI27s2MgZRlElkTy6KpNgpWinTwNOdk5AOW0Ghm6FxdHfdFXUG3KqiHUxojrW4x
	BkAqJuYp+DcQHQsXnktURWjBdmA/I7voN4rZG4nbFMBJz3SSiKpPUYDUd8K0iEpdxfSg9ow7IWf
	klxQw1zklGD4lmpqfXxr6OaKYf6bS7g2NiBbD4Y3cwjQDgwezl4xr1aCQGU/nBmyZNdAh1D9b1O
	+2NMCZbyW5IZeL0q2w+UoxMWAOU/vei/Az+KJYDo3eis=
X-Received: by 2002:a05:600c:4514:b0:493:f42e:1b3f with SMTP id
 5b1f17b1804b1-4994e7c7360mr265158745e9.3.1786349202901; Mon, 10 Aug 2026
 01:06:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com> <anWAZ3T6Sz8bsKSo@KASONG-MC4>
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 10 Aug 2026 16:06:29 +0800
X-Gm-Features: AUfX_my1zKS9rRfeQVRR_iYgHii3BkYqDGS35o7i0XrAqVeAoQI09AAC_0cvR_0
Message-ID: <CA+qSx6yzyOYT8OzFRjya6=N9FFwGkc_nyytku7i5B46dO-MYaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kairui Song <ryncsn@gmail.com> =E4=BA=8E2026=E5=B9=B48=E6=9C=887=E6=97=A5=
=E5=91=A8=E4=BA=94 16:29=E5=86=99=E9=81=93=EF=BC=9A
>
[...]
>
> Hello Xueyuan,
>
> Thanks for the patch!
>
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct=
 folio *folio, gfp_t gfp)
> >  #endif
> >
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margi=
n);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +                                          long *swap_margin)
>
> Am I the only one that feel this returning argument is a bit ugly? See be=
low..

Hi Kairui,

Yes, it does look a bit odd :P

>
> > +/**
> > + * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
> > + * @folio: folio whose memcg margin is queried
> > + *
> > + * Return: Remaining chargeable pages in the folio's memcg hierarchy.
> > + */
> > +long mem_cgroup_get_folio_swap_margin(struct folio *folio)
> > +{
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> > +     struct mem_cgroup *memcg;
> > +     struct obj_cgroup *objcg;
> > +
> > +     if (mem_cgroup_disabled() || do_memsw_account())
> > +             return swap_margin;
> > +
> > +     objcg =3D folio_objcg(folio);
> > +     if (!objcg)
> > +             return swap_margin;
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     swap_margin =3D page_counter_margin(&memcg->swap);
> > +     rcu_read_unlock();
> > +
> > +     return swap_margin;
> > +}
> > +
>
> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?
>
> >  bool mem_cgroup_swap_full(struct folio *folio)
> >  {
> >       struct mem_cgroup *memcg;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 70b90fa9c2a0..ae62c9f9c0f2 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap=
_info_struct *si,
> >   * swap cache.
> >   *
> >   * Context: Caller needs to hold the folio lock.
> > - * Return: Whether the folio was added to the swap cache.
> > + * Return: %0 on success, %-E2BIG if splitting the folio might allow s=
wapout,
> > + * %-ENOSPC if no global swap space is available, or %-ENOMEM if split=
ting
> > + * would not help.
> >   */
> >  int folio_alloc_swap(struct folio *folio)
> >  {
> >       unsigned int order =3D folio_order(folio);
> >       unsigned int size =3D 1 << order;
> > +     long swap_margin =3D PAGE_COUNTER_MAX;
> >
> >       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> >       VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> >
> >       if (order) {
> >               /*
> > -              * Reject large allocation when THP_SWAP is disabled,
> > -              * the caller should split the folio and try again.
> > +              * Reject large allocation when THP_SWAP is disabled. Che=
ck below
> > +              * whether splitting and retrying can make progress.
> >                */
> > -             if (!IS_ENABLED(CONFIG_THP_SWAP))
> > -                     return -EAGAIN;
> > +             if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> > +                     swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> > +                     goto failed;
> > +             }
> >
> >               /*
> >                * Allocation size should never exceed cluster size
> > @@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
> >                */
> >               if (size > SWAPFILE_CLUSTER) {
> >                       VM_WARN_ON_ONCE(1);
> > -                     return -EINVAL;
> > +                     swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> > +                     goto failed;
> >               }
> >       }
> >
> > @@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
> >       }
> >
> >       /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> > -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
> > +     if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
> >               swap_cache_del_folio(folio);
> > +             return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> > +     }
> >
> >       if (unlikely(!folio_test_swapcache(folio)))
> > -             return -ENOMEM;
> > +             goto failed;
> >
> >       return 0;
> > +
> > +failed:
> > +     if (get_nr_swap_pages() <=3D 0)
> > +             return -ENOSPC;
> > +     if (swap_margin <=3D 0)
> > +             return -ENOMEM;
> > +
> > +     return order ? -E2BIG : -ENOMEM;
> >  }
>
> How do you think if we apply this on top of this? (Not tested)
> Should be no behavior change but outside the existing races, the margin
> read moves from charge time to failure classification time, a small
> TOCTOU, which the original also has but in a different way.

Thanks a lot for the review and suggestion. I'll simplify the code along
the lines of your diff in the next version. :)

>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7d6216c8b830..dcf01d4c5e1b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -490,13 +490,12 @@ static inline void folio_throttle_swaprate(struct f=
olio *folio, gfp_t gfp)
>  #endif
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)=
;
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            long *swap_margin)
> +int __mem_cgroup_try_charge_swap(struct folio *folio);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         if (mem_cgroup_disabled())
>                 return 0;
> -       return __mem_cgroup_try_charge_swap(folio, swap_margin);
> +       return __mem_cgroup_try_charge_swap(folio);
>  }
>
>  extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int n=
r_pages);
> @@ -511,8 +510,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *f=
olio);
>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            long *swap_margin)
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         return 0;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b4c65ccf3538..d89054dd96a8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5650,13 +5650,12 @@ int __init mem_cgroup_init(void)
>  /**
>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>   * @folio: folio being added to swap
> - * @swap_margin: remaining memcg swap margin if allocation or charge fai=
ls
>   *
>   * Try to charge @folio's memcg for the swap space at folio->swap.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
> +int __mem_cgroup_try_charge_swap(struct folio *folio)
>  {
>         unsigned int nr_pages =3D folio_nr_pages(folio);
>         struct swap_cluster_info *ci;
> @@ -5675,7 +5674,6 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, long *swap_margin)
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         if (!folio_test_swapcache(folio)) {
> -               *swap_margin =3D page_counter_margin(&memcg->swap);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 rcu_read_unlock();
>                 return 0;
> @@ -5689,7 +5687,6 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, long *swap_margin)
>             !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> -               *swap_margin =3D page_counter_margin(counter);
>                 mem_cgroup_private_id_put(memcg, nr_pages);
>                 return -ENOMEM;
>         }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5d8d04576c13..09760985b911 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1756,7 +1756,6 @@ int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> -       long swap_margin =3D PAGE_COUNTER_MAX;
>
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> @@ -1766,10 +1765,8 @@ int folio_alloc_swap(struct folio *folio)
>                  * Reject large allocation when THP_SWAP is disabled. Che=
ck below
>                  * whether splitting and retrying can make progress.
>                  */
> -               if (!IS_ENABLED(CONFIG_THP_SWAP)) {
> -                       swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
> +               if (!IS_ENABLED(CONFIG_THP_SWAP))
>                         goto failed;
> -               }
>
>                 /*
>                  * Allocation size should never exceed cluster size
> @@ -1777,7 +1774,6 @@ int folio_alloc_swap(struct folio *folio)
>                  */
>                 if (size > SWAPFILE_CLUSTER) {
>                         VM_WARN_ON_ONCE(1);
> -                       swap_margin =3D mem_cgroup_get_folio_swap_margin(=
folio);
>                         goto failed;
>                 }
>         }
> @@ -1794,10 +1790,8 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> -       if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
> +       if (unlikely(mem_cgroup_try_charge_swap(folio)))
>                 swap_cache_del_folio(folio);
> -               return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
> -       }
>
>         if (unlikely(!folio_test_swapcache(folio)))
>                 goto failed;
> @@ -1807,7 +1801,7 @@ int folio_alloc_swap(struct folio *folio)
>  failed:
>         if (get_nr_swap_pages() <=3D 0)
>                 return -ENOSPC;
> -       if (swap_margin <=3D 0)
> +       if (mem_cgroup_get_folio_swap_margin(folio) <=3D 0)
>                 return -ENOMEM;
>
>         return order ? -E2BIG : -ENOMEM;
>
