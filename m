Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157567;
	b=jtXMmIgpFN+H4f/XJuQvn5lQYrIr6DalMt0So416ibXIraudLW+z92tNG0v7c/Bfs1pM
	 XgeC192qvq9veOD8WdsMggDnHuplhXrUROHHGRHwL84snC0bvFwtSRBvFhwCZR6umHKts
	 FNEnr7N9oo80n0DbJtVXo0nhLwyrPa5QdVrtF5gcR1m47xcYkbj6FOR21e8+JHU6aP+/j
	 kQdaobW0KYz9BMAeOzo2C9zQRJCRCZ6KgrdqYnA9nLc9fo3HDmvmFAcCyz84OnKdRrbFs
	 4j3WSW9YD4ASfUfjTNGzlF75XF22eOWLUVvnNaxYXpw+3fYXzgGM3ZneAfJzbCQ6X3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
	b=WjxQWW+D39nnwNwWDIc2LA0DMN765Oj0UaI9cCSsGP30yrw0gT0t3ItPkYHAdEOpTbAB
	 5sPxtCSoEmnugQ0VpR/IovC3YbTwLZPdX50Qp3QLead/cudoKLuEj0mSoWSeI5v95BzNy
	 lpL+qmBkGJQM0yRINnut9QAB1Mq/qihEBOn47LIoleUUfsGthvWRQgxrl8dnY7f0JOjnN
	 POlj9bB8zuLtmbuQKNIJM38eptQ/H0DYcBGmhotLvd9LsD1hrrOFdku0lW+NRIgdbSnro
	 6+iSAB2JZKJzyOzqjNdJ1fJNqPZuE80qWLCOfokZufne4kJDO0V4taPM3FDE7LYPV+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gfLaLfBZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AED606A32A
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 06:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57AED606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gfLaLfBZ
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so3825925e9.1
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 22:52:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157566; cv=none;
        d=google.com; s=arc-20260327;
        b=dUo4p3nfxIdOu//zmvhbZ33BaevIobLvCDbUpFnS4K7ajcunwMsbdx/dMf4DEwEOsl
         tNCKD8GEBvICYGKh42EVyd4RCbBjsQU+wLkj9b6cj+SCRDSKgU1J70iHm93n8jaNCs2c
         VXKxyjBFzuZOICWs1ZcVhQH6kuTE9MpPsHQLgkIXfb35lt0V2NyaKBxJYDJLuVv/hQ7n
         rBoAzfo3nZ64+N2med2uT5/hNeJIHpJR5P7BqNhJMjnCdwwRUY65ql52bE+/18ADmvQq
         //A7/s7R22WhnD4Fb9uGVXbXmwQUm1PLpVBcJ3HtStyEw0F4Mysu1ys/NIPptl5FYIWH
         FzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        fh=+3fQ0YjRDzY4mztct48ksny80NFlOBsa0JK5JhMG70w=;
        b=Mm8HcNsXXyuHpZ6sXg7GfVM+ctH5bbw4KnCdyNC/6QaP8QM9Vzl7/sFXMYXx3lUM+O
         7/JECghrCBESKDlZn/I1FhcQ3cwyMxC3G2uhLh1bqwzIOpNr/vHF+E8lSjrB7uNA53dT
         hMtmDFG8QhlMDWGNmaLsfSgPKrh245lU+fM2quZcdghZXtYj+NhOG4P0PGHge+BPcEfi
         BPBKV1Ek54cpuplh+kyxpQ9R3g++6FqpPRi5FZRpM2594fG6QRDAou11hz/zAqucKvTj
         /7JWYJEL5+wwFtcBXkrr06AS6K7FYf7QzOSfU4gMdunomnWBfXYzhPLMuAKDj8wt8GNt
         RjoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157566; x=1795762366; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        b=gfLaLfBZe2o1BQCk1TaRV6GSpd4u3IX6Xzt4nNZ5wpLL1OOEbakST9zThAzeRqfbMI
         QRRN739UcCv98EIN0173cXnoJWToWRn3f30dOLFlizwbRzsZnKcwkkC9kn7GZm4prY09
         0piXjM8bfdwn08jTekVocFNYoWLZV347rGsNE5CSR6ZixwHxDkbHg+qm6FdqBAC5G25F
         oc7Js3khziGs3BF6RuH95JAgDj2E/11YiR5l5KjFIrxuPsI7oEJEfZT4KtHDhoLFwa/6
         qI9G8q0FvDo1+3w9GeLBrWgBD7V4YQFoFPHjbojrdKC3sfjiWt+WDlrVrh8dlNofjGdR
         JhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157566; x=1795762366;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        b=CKp2IlsZauxQE1CfO2ffivAjKjlrCCDYfL9+wT4BabpFBIctUnOcfNaxl79fuhTWsz
         n6K7YqlSQcPktFGTvwdmZuUSsO88DlS6dlZfcapHtZnYoMAZ1nQCQ+njJ+ofPDbUtrSd
         ficcN605hormPPPPAwvVHNS/qVzS7g4u9i2c7tMsPtlPzooxH0P2/tsqC4hYhfhZe8Fp
         WH0qiyILKDE1u5yBQQgDna7BgDivgCl0LVRywcaq5HluQRmwci3bbQYQxr6RCWsAxQ8A
         6f3pSedrgmE/DiocyHUOSks3z6SkuwFXCLEcgXqbMY0HD/kE6U9K88+powI/fcinRUiN
         1DlA==
X-Forwarded-Encrypted: i=1; AL+hErHhCxOXpTIcMHeIxnAv5OkUOgciVzeuxSoKo03Pl9kTZgnPxZvH1Rrhb/Jnn3hwSQ0WPSILbmfL@vger.kernel.org
X-Gm-Message-State: APuU4Z+rUg8GVvwaBay9NfgI55W2EXyai57ijXy1PiE/9c2b1tO0Ase0
	9pKHo9l+ae0tTEaOf9QP66xJTmjvYUABzPjUoRLlTwFlu2z3KUrFWgCDobvi5SJmUzB8EMSQrAg
	IQRysExNzCF5ByLBSGKr6CJmbrAjHWF0=
X-Gm-Gg: AYBFou2xAppyKRk2WONSaVgPoOkpJAv9FvfRXhJ1mVZ5iwOp/UsOeUV4ae1LES7dYAo
	LyccU4cvC+hyf7Q6Aps9GtOm1haukSkXL2oLLkXSdS0SmpbiismfAE57hzV6f9hU0cW+wsOEvpl
	A4g1w7T0vGAxwkN8hLQ2qGWuOy5fgOc9RYCW0qg/dBX4zTzxtb3ltV0foZ4PG0R91neFznRfeNE
	a31aLJjEjLkaVX43YZIPnh9wA6BkpeyK45bXUtPwzc/D7qpuxrEaFi4PBhq5jg2do+6CUu81aBa
	D3ZIFB6StVTj2w0754MC1PMs1UbGfJT9cnSHvP3Ltw37cV12nsveoRWJ7RBBmm90agV6PbSf74Q
	wsafo/IE3BxnRUSsSxVJEZizvFX6AG0VwqqC48MxQd69rGs2CwzjEuTzlKusgMCqIVg==
X-Received: by 2002:a05:600c:3b8a:b0:4ba:761:c0c5 with SMTP id
 5b1f17b1804b1-4bb8880f0e0mr43956385e9.5.1795157565119; Thu, 19 Nov 2026
 22:52:45 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:52:32 +0800
X-Gm-Features: AclHuK8u9ADIpuCbwIFublehlsAz2Sh82b8gcTYOiMH_psNdYRsQZkiWsXcTuLk
Message-ID: <CAN_Opa_h083WMGuehgFLYb=Rc+Kd3t3JdPiG2xkEw_+digwQyw@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
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
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Add a helper that resolves a live lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.  The first user is
> the lockless folio_inc_lru_refs() path later in the series.
>
> Factor the ancestor walk out of lruvec_live_lock_irq() into
> __lruvec_get_live(), so that both entry points share it, and spell
> out why the walk is enough while only the RCU read lock is held:
> reparenting of a memcg that starts dying waits for a grace period,
> so it cannot race with the caller until the lock is released.
>
> Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> predicates, and use it for the walk rather than repeating the open coded
> css_is_dying() test a few definitions away from where it is explained.
>
> No functional change for existing callers.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..441a5d57e723 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>         return !cgroup_subsys_enabled(memory_cgrp_subsys);
>  }
>
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +       return memcg ? css_is_dying(&memcg->css) : false;
> +}
> +
>  static inline void mem_cgroup_protection(const struct mem_cgroup *root,
>                                          const struct mem_cgroup *memcg,
>                                          unsigned long *min,
> @@ -1349,6 +1354,11 @@ static inline bool mem_cgroup_online(struct mem_cg=
roup *memcg)
>         return true;
>  }
>
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +       return false;
> +}
> +
>  static inline
>  unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
>                 enum lru_list lru, int zone_idx)
> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec =
*lruvec)
>         spin_lock_irq(&lruvec->lru_lock);
>  }
>
> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +/*
> + * Reparenting moves a dying memcg's LRU state to its parent at any time=
,
> + * so anything added to that LRU afterwards would be lost.  This helper
> + * walks up to the nearest live ancestor while the caller must hold the
> + * RCU read lock: reparenting of a memcg that starts dying waits for a
> + * grace period, so it cannot race with the caller until the lock is
> + * released.
> + */
> +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
>  {
>  #ifdef CONFIG_MEMCG
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       rcu_read_lock();
> -
>         /*
>          * The memcg can be NULL when the memory controller is disabled.
>          * Otherwise, the caller keeps the memcg owning @lruvec alive.
>          */
> -       while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +       while (unlikely(memcg_is_dying(memcg))) {
>                 memcg =3D parent_mem_cgroup(memcg);
>                 lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>         }
> +#endif
> +       return lruvec;
> +}
>
> +static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_lock();
> +       lruvec =3D __lruvec_get_live(lruvec);
>         spin_lock_irq(&lruvec->lru_lock);
>  #else
>         lruvec_lock_irq(lruvec);
>  #endif
> -
>         return lruvec;
>  }
>
> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const stru=
ct folio *folio,
>                lruvec_memcg(lruvec) =3D=3D folio_memcg(folio);
>  }
>
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> + * accounted to the nearest live ancestor, which is where reparenting
> + * would put it anyway.
> + *
> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> + * folio_lruvec_live_put().
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_lock();
> +       return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +       return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_unlock();
> +#endif
> +}
> +
>  /* Don't lock again iff page's lruvec locked */
>  static inline struct lruvec *folio_lruvec_relock_irq(const struct folio =
*folio,
>                 struct lruvec *locked_lruvec)
> @@ -1826,11 +1877,6 @@ void mem_cgroup_node_filter_allowed(struct mem_cgr=
oup *memcg, nodemask_t *mask);
>
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -       return memcg ? css_is_dying(&memcg->css) : false;
> -}
> -
>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1901,11 +1947,6 @@ static inline void mem_cgroup_node_filter_allowed(=
struct mem_cgroup *memcg,
>  static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *m=
emcg)
>  {
>  }
> -
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -       return false;
> -}
>  #endif /* CONFIG_MEMCG */
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
