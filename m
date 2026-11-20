Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162166;
	b=ejJRg9LpWcG2gCP9iSFhANIZyvNErsCQOdLr9lDfdc332FXgO4JpMw6LzM3VJ+o1uiVW
	 Mq9vjZ21uqB98Zl390osYZUnKzBL1TDuwZM+mPSOS3sj4nr6T/fDIT1woZ15gd3xQV/Vy
	 q1XDsMDyWAkoMD09e2JEb8byC7hFU4veY8e8WG1LVDIW186yiCdkaRj8gI1tkRVC/x4rd
	 zl9f9suJAH0Ja9O9Qqd278TF1eSyEW7xhsNG3u3S5pZ7Fovn6PiD0nP820RpL/do0R/8q
	 lwv4hYoEFwE7vMChIHNCydZVTrpWMkZMdOVnx0fMIz56TK0G47yzbFI+vkceoEkMbaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162166;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
	b=KYSQdVufA8BOo7wTxRC7U+Y3uSy51Al6WHmu/Qgq2Z3ttWu0nMopw28UBjyzzTQdo9O3
	 ITXSVimSp6yqJFNriQb6LFSplG016C8BB1uJw2YeTGQA2rM7D/f1tHHodGE6Fh/d4Sgq8
	 4U0TsghB0hbAIxjbauDLe5ZyLP8mmD24GBmhnGualr+LVEyKPPRUitpCO8hwFLyKAr/mc
	 SJ6WUpARKdXR1NOI4xAtA+yVYjbK0l86raaQnoUjeCRgnwH/2oWyB70NuaZ4La4GWt7ai
	 mpzFBOKD+LiLuLhre5dcKTcJ3bf2Lh+t27e30/X13gl8XsbgzK2bEhMh4eUFW2VTcmQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a+pS7F1O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC3606A325
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4AC3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a+pS7F1O
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so3842265e9.2
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:09:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162163; cv=none;
        d=google.com; s=arc-20260327;
        b=Hh66nTBELSVqODIc1Bln7u3oWb4v36XR+oovh20apztohyPNk7j3XvnALYfQEHsBQ4
         UWPUJE4HRNSQXwBj9EF7mEVLd+D3g3I3ZS0yLbkm2Gc20OZwzebhE8ttiiKVYMZ2cZYY
         pGBlbsJk83z0GMaQwSNPj3H1RJYX9QAj4wjZZOBU7XyPo/WDpZPBbsBMz0wnOc1KgyAh
         BmGMQWIZuKG7H4Agx2RK1cIZRWvHfhzegyUsqCItwIgY81vh4lqTmvF7pH5SbFRNPzK9
         716s5tECZV9cuy0zgs+UlNGiTlulUlCqtxxaHFy1LbgZZQTZFJ5w98dmMy+TaJSS15D3
         9Nww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        fh=gXoWVLcqQrb4JR10YaoyGuEqVn374vd3qau5RiBifxg=;
        b=PHM9ltZH2jalNqIiU07jxgzLkNQmUN3IniyqrEJwOHxCP5W9Jed+zo1Kq00TC8d5rP
         E9THtrtb3b6JZXaSh8xJrplaXmxlGa1xX8BJicKOM++DXZEFA1hUvJMNqhhF6akCvYr9
         33vE8lk/8cq0sQXFGwSudGM9ZK4rq0C8FDSxs803LHKgBjtwIjaGOgx44jY0tDp7COER
         b7VzZAcT039BzHHz665+lWQbtsurELSD0BjJDtSN2M4IC7qX/0c7H5rInFHu3d4S58W7
         tpdTknrKVhePzmyd5k82d12vajfF+vf42BnCPpxqIrAWWIBNi/9XwQho/dp/t68VgGlF
         zvOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162163; x=1795766963; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        b=a+pS7F1OZ+3sMtD4L2v38crmKBAj9JIR6eUtmxbWry9M227DaXFK3/HVave72TbeZk
         PyiJzm2ra4UHHIw0MYZV4DRkkBmUANX68zp9D9e69EmFvIhQgWPP/NC2b4HxxbMpeVZh
         5xpT/qw2ya99FCNmkPwvyA8XXrbVArjDe3PCSJJi1ObUnsnLshTmSp5OBVgkCwM6NtsF
         NfkStvyxN3XF1YTdkmIbehHEzHxKCQaB8jwfv6f/lm4ISa8ulysh2HPcAqi63CP3tQNu
         ZWLJX6wiQ9dqulusokk9wKxvmowAV3AeXM3cEdisvvSY8ZTHC+1FOYaxrx3FDlihXaAe
         H2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162163; x=1795766963;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        b=Bl/Fd5a5Ejz7XOWutbXnMogYfzn85AZVL+exV/bgeLz20/Aky1qWcjwnPAYMAL0Sp3
         mqDbBqBDA21Q56/s11RHs2eAl8GX+7QCdUR4Xy8wZirXYu++Whc3X5CIwidqEkLNIzbt
         tpY7gifgMqmY+U0aY1hCJwUbb1C+3MFHf3gOHkQ8s+xqpOwicCLv/doVfPfm1elJ8u+g
         R+gW2Upo9Tvg/85OJiarBXMwafnJnc5x1ErTvmu667SRv6C2pLjXCnfpAd7SckQ3oUzl
         CQ5XrXjXkh+PNFZRtMYa966GskRYonaDxRBtIZo0IkU4j0sZrDh3Z/t2NqlCxF2wqWok
         yyUw==
X-Forwarded-Encrypted: i=1; AL+hErF/Y+dSaBtARm6dXUrDeLpl0GVfn9KlXStpmU/iqHYsldDAYc8RUS3XXhkgSdkI1pTQfF82m0wO@vger.kernel.org
X-Gm-Message-State: APuU4Z/ufCzhY4mrVix5X+gjzoh/jnmK6oQUjQ1+24B8ycoycPACHQDW
	NupXzF7k1aAhwGFHUiNRBYqkQaStVZ6zUBsJk4TVubSGOkT8TyF7iWdVqmeD507gJPAFRwdoeP1
	4szPTzLEqMCRiyRcmKpKP4nxGHjKCpeE=
X-Gm-Gg: AYBFou1MWRhu6CAomOPJ6TGyunKwlJ7JjmBEniIJJB7PxfPSSY41DF18NkO5Rr6J+M1
	NH4j2LJNK0Onrj0DkZWGUpvudosfmz2bOhSSzZdqRXy5hGkWhM51UShbtd7IPwB+VPfcbX4U5t8
	2ngulreoTCshNJV+GgaBphxxC5F5w5yxgR72c7uHZvTk1IbWTAHIQwkliQ8+/FsA/GwCKYjyECB
	+6jpHSNbUMO2z/xnnXFDW3Nn2av6p2A66moYm/3PtEqUt2mSpd2JkubPMmxZZLC67Lins7N/c3T
	34r3+E78b6JOESfJVARfyjUkDiWj+CQ29+rvcJW4JZFHAH0/K0z6q8KJ90WtkbxN0Xt2KbK07j1
	O0Ed+PagXtTY06+NiOKwW55+Ar7t+wqu2N6YHW0YrOtncNmCPr0OctC6NZ1M20OIMOw==
X-Received: by 2002:a05:600c:820d:b0:4a1:dfaf:f465 with SMTP id
 5b1f17b1804b1-4bb887c2ca3mr50773205e9.4.1795162162231; Fri, 20 Nov 2026
 00:09:22 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:09:10 +0800
X-Gm-Features: AclHuK_VKlqqEhyVsFjwMPNFqZB7zpvWpa4YrOLbcuQl6B76cFC6fUDgwP17mRM
Message-ID: <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ssLRU referenced count set by lru_set_refs_flags().
>   */
> -static inline int lru_get_refs_flags(unsigned long flags)
> +static inline unsigned int lru_get_refs_flags(unsigned long flags)
>  {
> -       if (!(flags & BIT(PG_referenced)))
> -               return 0;
> -       /*
> -        * Return the total number of accesses including PG_referenced. Also see
> -        * the comment on LRU_REFS_FLAGS.
> -        */
> -       return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> +       unsigned int refs;
> +
> +       /* Decode the per-folio reference state. */
> +       refs  = !!(flags & BIT(PG_referenced));
> +       refs |= !!(flags & BIT(PG_workingset)) << 1;
> +       refs |= ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> +       return refs;
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +static inline unsigned int folio_lru_refs(const struct folio *folio)
>  {
>         return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>  }
>
> +/*
> + * Referenced at least twice. Unlike lru_refs_is_active() this is not
> + * bounds-checked: folio_inc_lru_refs() evaluates refs unclamped.
> + */
> +static inline bool lru_refs_is_workingset(unsigned int refs)
> +{
> +       return refs >= LRU_REFS_WORKINGSET;
> +}
> +
>  static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>  {
>         unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> @@ -238,14 +252,26 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  }
>
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>  }
>
> +static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
> +{
> +       unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
> +
> +       /* The MIN_NR_GENS oldest generations, which eviction scans next */
> +       BUILD_BUG_ON(MIN_NR_GENS != 2);
> +       return gen == lru_gen_from_seq(min_seq) ||
> +              gen == lru_gen_from_seq(min_seq + 1);
> +}
> +
>  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
>  {
> -       unsigned long max_seq = lruvec->lrugen.max_seq;
> +       unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
>
>         VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
>
> @@ -302,23 +328,24 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>                                               bool reclaiming)
>  {
>         int age;
> +       bool workingset = lru_refs_is_workingset(folio_lru_refs(folio));
>         int type = folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>
>         /*
> -        * +-----------------------------------+-----------------------------------+
> -        * | Accessed through page tables and  | Accessed through file descriptors |
> -        * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> -        * +-----------------------------------+-----------------------------------+
> -        * | PG_active (set while isolated)    |                                   |
> -        * +-----------------+-----------------+-----------------+-----------------+
> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
> -        * +-----------------------------------+-----------------------------------+
> -        * |<---------- MIN_NR_GENS ---------->|                                   |
> -        * |<---------------------------- MAX_NR_GENS ---------------------------->|
> +        * +------------------------------------------+------------------------------------------+
> +        * |     Accessed through page tables and     |     Accessed through file descriptors    |
> +        * | promoted by folio_inc_lru_refs_walk()    | protected by folio_inc_lru_refs/inc_gen  |
> +        * +------------------------------------------+------------------------------------------+
> +        * | PG_active (set at isolation or refault)  |                                          |
> +        * +--------------------+---------------------+--------------------+---------------------+
> +        * |     LRU_REFS_MAX   | LRU_REFS_WORKINGSET |    LRU_REFS_MAX    | LRU_REFS_WORKINGSET |
> +        * +------------------------------------------+------------------------------------------+
> +        * |<-------------- MIN_NR_GENS ------------->|                                          |
> +        * |<----------------------------------- MAX_NR_GENS ----------------------------------->|
>          */
>         if (folio_test_active(folio))
> -               age = MIN_NR_GENS - folio_test_workingset(folio);
> +               age = MIN_NR_GENS - workingset;
>         else if (reclaiming)
>                 age = MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
> @@ -326,7 +353,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio))))
>                 age = MIN_NR_GENS;
>         else
> -               age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> +               age = MAX_NR_GENS - workingset;
>
>         return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
>  }
> @@ -341,6 +368,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
>         int zone = folio_zonenum(folio);
>         struct lru_gen_folio *lrugen = &lruvec->lrugen;
>
> +       BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
>         VM_WARN_ON_ONCE_FOLIO(gen != -1, folio);
>
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
> @@ -408,7 +436,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   */
>  static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>  {
> -       BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
>         folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>  #else /* !CONFIG_LRU_GEN */
> @@ -444,6 +471,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>         return false;
>  }
>
> +static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> +{
> +}
> +
>  static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>  {
>         if (folio_test_referenced(old))
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 4c4aad95b0b6..5470dd708e44 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -453,57 +453,103 @@ enum lruvec_flags {
>  #define MAX_NR_GENS            4U
>
>  /*
> - * Each generation is divided into multiple tiers. A folio accessed N times
> - * through file descriptors is in tier order_base_2(N). A folio in the first
> - * tier (N=0,1) is marked by PG_referenced unless it was faulted in through page
> - * tables or read ahead. A folio in the last tier (MAX_NR_TIERS-1) is marked by
> - * PG_workingset. A folio in any other tier (1<N<5) between the first and last
> - * is marked by additional bits of LRU_REFS_WIDTH in folio->flags.
> + * Each generation is divided into multiple tiers. A folio's referenced
> + * count maps to a tier as shown below (with one extra refs bit):
>   *
> - * In contrast to moving across generations which requires the LRU lock, moving
> - * across tiers only involves atomic operations on folio->flags and therefore
> - * has a negligible cost in the buffered access path. In the eviction path,
> - * comparisons of refaulted/(evicted+protected) from the first tier and the rest
> - * infer whether folios accessed multiple times through file descriptors are
> - * statistically hot and thus worth protecting.
> + * MGLRU (frequency guidance)
> + *  Refs  Tier  |- Refs: observed accesses, capped on promotion.
> + *   0      0   |- Mostly cold pages, readahead, etc. [1]
> + *   1      0   |= LRU_REFS_REFERENCED: Used at least once. [2]
> + * -WORKINGSET-+|- Workingset floor, unless explicitly reset. [3]
> + *   2      1<-+|= LRU_REFS_WORKINGSET: Classical workingset, accessed twice, protected. [4]
> + *   3      2   |- LRU_REFS_PROTECTED: Protected workingset, promoted pages capped at here. [5]
> + *   4      2   |
> + *   5      3   |- The tier here is MAX_NR_TIERS - 1
> + *   6      3   |
> + *   7      3   |= LRU_REFS_MAX: Promotion candidate. [6]
> + * -PROMOTION->-/
>   *
> - * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice the
> - * number of categories of the active/inactive LRU when keeping track of
> - * accesses through file descriptors. This uses MAX_NR_TIERS-2 spare bits in
> - * folio->flags, masked by LRU_REFS_MASK.
> + * Ideally each tier holds folios of similar access patterns: lower tiers
> + * are less important and evicted faster.  A page's reference count and
> + * tier are capped when it changes generation, preventing it from
> + * dominating the new generation based on old-generation access history.
> + * The generation and refs together represent logical refs: hotness relative
> + * to the aging window. Promotion moves the folio forward and caps refs;
> + * gen aging then lowers logical refs even without updating the stored count.
> + * This avoids a separate full-cache aging walk to reduce old hotness.
> + *
> + * Refs tracks accesses from two sources: page table (lazily collected by
> + * the page table aging walk or rmap eviction lookup) and file descriptors
> + * (by folio_mark_accessed).  Page table accesses promote more readily
> + * because the accessed bit is sticky (undercounts repeated accesses),
> + * passively collected, and page faults are generally more important as
> + * userspace does not expect a memory access to block on reclaim.  Both
> + * access types increment refs by one; the result is capped at
> + * LRU_REFS_PROTECTED on promotion or deferral, or LRU_REFS_MAX otherwise.
> + *
> + * 1. Tier is fls(N-1) for N > 1, 0 otherwise.  Folios with zero
> + *    accesses (refs == 0) are generally cold, e.g. readahead folios.
> + *
> + * 2. Folios accessed once stay on tier 0: one-time usage does not
> + *    qualify for tier protection. A second access can advance the folio,
> + *    aligning with classical LRU's use-twice threshold.  A page table
> + *    access that brings refs to LRU_REFS_WORKINGSET promotes to the
> + *    latest gen. A file access at that refs count only defers eviction
> + *    from the tail gens of its type.
> + *
> + * 3. Folios accessed at least twice are considered workingset.  This
> + *    mostly aligns with classical LRU: at least one I/O is saved by
> + *    keeping them in memory. Unless explicitly reset, these folios stay
> + *    at or above tier 1 (the workingset floor), so tier 0 stays a clean tier
> + *    for cold cache while tier 1 serves as the fallback line for
> + *    actually reused or historically hot folios.
> + *
> + * 4. Starting from tier 1, PID protection sacrifices lower tiers to
> + *    protect higher tiers by comparing refault rates for long-term
> + *    accuracy, and caps higher refs to LRU_REFS_WORKINGSET.  Rejected
> + *    folios also keep at most that count on putback, allowing further
> + *    accesses to distinguish their hotness again.
> + *
> + * 5. Pages beyond the ordinary workingset tier form new tiers for the
> + *    PID controller to protect differently.  Folios at or above this
> + *    level are capped at LRU_REFS_PROTECTED on promotion or deferral,
> + *    and at LRU_REFS_WORKINGSET under PID protection in the oldest
> + *    generation, where they represent a historical workingset.
> + *
> + * 6. A further cache access at LRU_REFS_MAX advances an older folio by one
> + *    generation, with refs capped to LRU_REFS_PROTECTED. Folios already in
> + *    the newest generation just saturate their refs.
> + *
> + * Tiering uses PG_referenced and PG_workingset as the lower two bits,
> + * and the bits masked by LRU_REFS_MASK as the higher bits, so the refs
> + * count ranges from 0 to LRU_REFS_MAX.
> + *
> + * Cold hints can reset refs with lru_gen_clear_refs(). Refault restores
> + * its referenced count, capped at LRU_REFS_PROTECTED, which aligns with
> + * promotion.  Fault-driven refaults of previous workingset folios set
> + * PG_active, so they are placed in the latest gen.
> + *
> + * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice
> + * the number of categories of the active/inactive LRU.
>   */
>  #define MAX_NR_TIERS           4U
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> +/* Access source flags for folio_inc_lru_refs() */
> +#define LRU_REF_MAPPED         0x1U
> +#define LRU_REF_EXEC           0x2U
> +
> +#define LRU_REFS_REFERENCED    0x1
> +#define LRU_REFS_WORKINGSET    0x2
> +#define LRU_REFS_PROTECTED     0x3
> +
>  #ifndef __GENERATING_BOUNDS_H
>
>  #define LRU_GEN_MASK           ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>  #define LRU_REFS_MASK          ((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
> -#define LRU_REFS_MAX           BIT(LRU_REFS_WIDTH)
> -
> -/*
> - * For folios accessed multiple times through file descriptors,
> - * lru_gen_inc_refs() sets additional bits of LRU_REFS_WIDTH in folio->flags
> - * after PG_referenced, then PG_workingset after LRU_REFS_WIDTH. After all its
> - * bits are set, i.e., LRU_REFS_FLAGS|BIT(PG_workingset), a folio is lazily
> - * promoted into the second oldest generation in the eviction path. And when
> - * folio_inc_gen() does that, it clears LRU_REFS_FLAGS so that
> - * lru_gen_inc_refs() can start over. Note that for this case, LRU_REFS_MASK is
> - * only valid when PG_referenced is set.
> - *
> - * For folios accessed multiple times through page tables, folio_update_gen()
> - * from a page table walk or lru_gen_set_refs() from a rmap walk sets
> - * PG_referenced after the accessed bit is cleared for the first time.
> - * Thereafter, those two paths set PG_workingset and promote folios to the
> - * youngest generation. Like folio_inc_gen(), folio_update_gen() also clears
> - * PG_referenced. Note that for this case, LRU_REFS_MASK is not used.
> - *
> - * For both cases above, after PG_workingset is set on a folio, it remains until
> - * this folio is either reclaimed, or "deactivated" by lru_gen_clear_refs(). It
> - * can be set again if lru_gen_test_recent() returns true upon a refault.
> - */
> -#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced))
> +#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced) | BIT(PG_workingset))
> +#define LRU_REFS_MAX           (BIT(LRU_REFS_WIDTH + 2) - 1)
>
>  struct lruvec;
>  struct page_vma_mapped_walk;
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 02b619eb6106..06a034713b5d 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -25,7 +25,7 @@ int main(void)
>         DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
>  #ifdef CONFIG_LRU_GEN
>         DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
> -       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 2);
> +       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 3);
>  #else
>         DEFINE(LRU_GEN_WIDTH, 0);
>         DEFINE(__LRU_REFS_WIDTH, 0);
> diff --git a/mm/folio.c b/mm/folio.c
> index ea3adb6a89d7..06c9cde834f7 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -352,32 +352,6 @@ static void __lru_cache_activate_folio(struct folio *folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -       unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> -       int refs;
> -
> -       if (folio_test_unevictable(folio))
> -               return;
> -
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_lru_refs(folio)) {
> -               folio_set_lru_refs(folio, 1);
> -               return;
> -       }
> -
> -       do {
> -               new_flags = old_flags;
> -               refs = lru_get_refs_flags(old_flags);
> -               if (refs == LRU_REFS_MAX) {
> -                       if (!folio_test_workingset(folio))
> -                               folio_set_workingset(folio);
> -                       return;
> -               }
> -               lru_set_refs_flags(&new_flags, refs + 1);
> -       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         int gen = folio_lru_gen(folio);
> @@ -388,7 +362,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>                 return true;
>
>         folio_set_lru_refs(folio, 0);
> -       folio_clear_workingset(folio);
>
>         rcu_read_lock();
>         seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> @@ -399,10 +372,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>
>  #else /* !CONFIG_LRU_GEN */
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         return false;
> @@ -428,7 +397,8 @@ void folio_mark_accessed(struct folio *folio)
>         if (folio_test_dropbehind(folio))
>                 return;
>         if (lru_gen_enabled()) {
> -               lru_gen_inc_refs(folio);
> +               if (!folio_test_unevictable(folio))
> +                       folio_inc_lru_refs(folio, 0);
>                 return;
>         }
>
> @@ -474,21 +444,6 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /*
> -        * For refaulted workingset folios, set PG_active so they
> -        * can be added to active generations.
> -        * For prefaulted file folios, folio_mark_accessed() sets
> -        * PG_referenced so lru_gen_folio_seq() places them into
> -        * the second oldest generation.
> -        */
> -       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -               if (folio_test_workingset(folio))
> -                       folio_set_active(folio);
> -               else if (!folio_test_referenced(folio))
> -                       folio_mark_accessed(folio);
> -       }
> -
>         folio_batch_add_and_move(folio, lru_add);
>  }
>  EXPORT_SYMBOL(folio_add_lru);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0f24b6ebc1eb..a02504c5a7d7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -818,38 +818,204 @@ enum folio_references {
>  };
>
>  #ifdef CONFIG_LRU_GEN
> +/******************************************************************************
> + *                     Referenced count feedback
> + ******************************************************************************/
> +
>  /*
> - * Only used on a mapped folio in the eviction (rmap walk) path, where promotion
> - * needs to be done by taking the folio off the LRU list and then adding it back
> - * with PG_active set. In contrast, the aging (page table walk) path uses
> - * folio_update_gen().
> + * The folio_inc_lru_refs{_*} helpers below collect the referenced info
> + * (hotness) from the page table walker, the rmap walk upon eviction, the
> + * rmap look-around, and file descriptors (folio_mark_accessed).
> + *
> + * Each access adds one to the refs count, capped at LRU_REFS_MAX.  A
> + * fresh folio's refs go from 0 to LRU_REFS_REFERENCED to
> + * LRU_REFS_WORKINGSET, and so on.
> + *
> + * Mapped access (PT, LRU_REF_MAPPED) has a higher priority since the
> + * accessed bit is sticky (it under-counts repeated accesses) and a fault
> + * could be more costly than FD I/O. So, a page table access always
> + * promotes a folio on an expiring gen by at least one gen. And starting
> + * from the second access (refs == LRU_REFS_WORKINGSET), it moves the folio
> + * to the newest gen. Executable file folios promote on their first access
> + * to avoid I/O thrashing. The refs are increased at a normal pace though.
> + *
> + * File descriptor accesses (FD) are a precise access method. So, only
> + * since the second access (refs == LRU_REFS_WORKINGSET), every access
> + * will promote a folio if the folio is on an expiring gen (close to
> + * min_seq). If the folio is not on an expiring gen, it will be promoted
> + * when its refs exceed LRU_REFS_MAX; the newest gen just saturates.
> + *
> + * Promotion, regarding the source, always caps the refs at
> + * LRU_REFS_PROTECTED, so folios in a newer gen start at or below the
> + * protected tier, and folios with lower refs in a newer gen are logically
> + * hotter than a folio in an older gen with higher refs.
> + *
> + * A folio with refs at or above LRU_REFS_WORKINGSET is considered a
> + * workingset, and the tiers starting there engage PID protection.
> + * PID-protected folios (folio_inc_gen) are capped at
> + * LRU_REFS_WORKINGSET independently to make full use of tiering.
>   */
> -static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
> -{
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
> -               /* Activate file-backed executable folios after first usage. */
> -               if (is_exec_file_folio(folio, vma_flags)) {
> -                       folio_set_workingset(folio);
> -                       folio_set_lru_refs(folio, 0);
> -                       return true;
> +
> +/**
> + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promote it.
> + * @folio: The folio being accessed.
> + * @flags: The type of ref: FD access, or mapped access optionally with
> + * executable access.
> + *
> + * Used by both cache access (flags == 0) and page table access (flags ==
> + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> + * Context: The caller must keep the folio alive by a reference or the page
> + * table lock of a mapped folio.
> + */
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> +{
> +       int max_gen;
> +       int type, refs, old_gen, gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec = NULL;
> +
> +       type = folio_is_file_lru(folio);
> +       old_flags = READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags = old_flags;
> +               old_gen = lru_get_gen_flags(old_flags);
> +               refs = lru_get_refs_flags(old_flags) + 1;
> +               gen = old_gen;
> +               if (old_gen < 0)
> +                       goto out;
> +               /*
> +                * Lock the lruvec if the folio is on-list. We are already
> +                * doing lazy promotion so in theory we don't need this,
> +                * but for now, concurrent aging would still corrupt the
> +                * size counters.  This is a temporary limitation and
> +                * will be lifted very soon, so the lock here is not a
> +                * performance concern.
> +                */
> +               if (!lruvec) {
> +                       lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
> +                       lrugen = &lruvec->lrugen;
>                 }

Can we do the lookup under RCU and preserve IRQ state here?
filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
still holds gpc->lock.

Thanks,
Kunwu
