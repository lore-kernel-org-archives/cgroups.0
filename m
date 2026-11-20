Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157380;
	b=1c1AtzF9WIRoHW56Zgvb2RiaDEeq+2DRdSb5KjPiy9uPCFtsnGBn//0in13HPjj25gPx
	 oG9cwMb0StazCF09wfoQYkcxM14oUAj2kvz1qR8K0Jmxr037R1rp1GSCd60DIOdZPXjjs
	 8RRBrDr7h0QvVhIpnFjBZIikuiE/AJTtWMFGm0ld9zA5X0Xbo70OSatngjm9ghdM+i2c8
	 mo2J+eVMbO1DQSqdihlxnXGuj+JrTDJj5PtNSjREdWTtVJXURIoDMpP1M/AH51xYpfIXy
	 3H5eB8Mi+TWSIjV+3DeULeAFVGFTpcC20m8uPus4xTUe2qJvXu2grko9hGZq05BRmuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
	b=CP1mQP7xQYGkpJu61F8ykUH9pkXFZeiJTW9Zilp6oY5mTS4LNI3xHUXi0BTlieHawKfV
	 BZfFLDBdc71f/spI0J7sSLws6l3BeuUnPcT2OkexYJYPUmBtiPtxbWGU7N97z5i5vlr30
	 7Aknd9sBsydi9o6oXN5ciU7eZlUb0VRA+CidCE+sQ67hKUf7KLuNj0iapZyRX+S3xPVkG
	 hY2b3g0k3+nXggbOUq5LJVUh4eRdUw7z15YF+cQ0BE9tZaCaN7ryZvyeWItXvfSjCZdWw
	 LdJRh/JmAz74yawy/fAxu6iJIVzMOTymn1aJiU6Blh0JcQcrF2ffxJf9OVDjJXWTh4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kxuiz41v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6CD606A32C
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 06:49:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A6CD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kxuiz41v
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so4011165e9.2
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 22:49:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157378; cv=none;
        d=google.com; s=arc-20260327;
        b=hSVmaaU6C8FLDi25Vzpv08SS87QLlFh5SckVgnHHhjCmGtm/i7f6mLG/Ou03zb923o
         cL5g0/ZpGbs61vXsFa1jxbe5pbosJGsTFYhf3mZCKTQhzXXSFljsLJluGhVHuJKnjanL
         +eFzlfQ/l1vWhB2Fzo6sIwdLN1cNOoM1oaT9lIWtqsZ8Kbtimg9WPYlvRduCD8pvAnLM
         gWkeb+ZfR88x/Ua1B0+4kx4WotsbKKkKig7e3rWWEgGPAIE8k/0RGvjY7quVoe6uTR+F
         83q1yM3svfv1vqtBdTk7gqs/xlv1A/USdEnS188gSjk/lnwZ+VlahVd0BEfPKQDiowXn
         m/8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        fh=VRHUh2DAMzfi+kgubxLKMqaFtScKVcURgEJBVhYd+RM=;
        b=b/F9QNAEeVWxwQO8tWTctBzbSaO6SEhYhZKoHU67ImJN7upzlmqWqIApIcafJJpNgM
         IA0P6kginBu6vLYkXqPMSVnEj2PKh3v8DmfWKvhSeJ/EKvPzxSqQdY72Drc0utNLYkxo
         2dXxeLzUhaaj3LhMbiDKZypNAhsopwVd/Ig3cNPU1ZdFV027tfCDCmIMPUPSuYVbXzNU
         kWTlZPvt5+EPaJ+6Bp7kVTxkJCwdCNGZc+dgGbvugwcYihHa9cs97Dgfx8gKO0NxTdVe
         899ggWJ0fsiYq3i3YLbJtxHfbACX3WKBtetBVXtozbmA3Rvjrhvq7wWIeyOF9CWRmjOY
         vNDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157378; x=1795762178; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        b=kxuiz41vwmj3mVrVneWY8bgVRZV278TQrnwZ8wcFraur08aDRPlwEGAyBmhyWew1N8
         zATRsw093bzfloFu8qEo+eJtQv1AcoFzgfxgkalFVKKk6Z63DiykmMRdANWFXc39A2u5
         sd8PahmEGR7TIib6jFVqj7ATijE7x1biAcotmNvP3tT6WRhgnSbZMu7MlDDrQHe4AiqL
         ZuAcGdXINwPh5kzRN8oAz8yahRdW2cQBWZSCcU/LnHW3TpqQJ899J2g8J1XxIRehzk/c
         KFmlYHIb+pTSzideveDEjx4aIjSf13TbrpfAeDeNu2XcA42W6pOQQ+wUYDAjiGTDXeOf
         2h6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157378; x=1795762178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        b=BJ0zTQjWmYy/59Nrjb86XW5cgPVIE+ABiQagwVAOadvXODaBzNSHXLzin/ZBYl4Puv
         oC3fBqO0WOa7sUdFdSAw8cTzSLvhSOUs667L2qG9AzZuEDS/+xYP3rAhb2wRxwNIVJO4
         FJpdubSaGeWO1/rI674/tt88RKC9UW2/fc2MOOn9TDBh5y8M8g1zPsKArMUZ56Doqil5
         H/kWnc3913o01ozxTkd6knfNIzJO57YzzRWHC+VOK5Fl/FKrszO5i2/bYaGbMk7OJQpa
         gO/5YUHKWuY/NeXu918lEAhaFZ7St3/kqjrwnpyHQS6I1gHOVldXDJ4jgEBf9c9WnB4p
         4fgQ==
X-Forwarded-Encrypted: i=1; AL+hErE58CF56ZaDpqt5yD6nZTMRZOAjBPqR5b7HD1dp8eKIONA3dXg8F8RFL6S8W09N3ZxjbJld9VkG@vger.kernel.org
X-Gm-Message-State: APuU4Z/Klx0llFB+masz/PnUsqI7cNVB7NNeMqlPX/Xs/Da1AeWyejZH
	9wlW6sKNj43a/YgAnx7p5ufuVm0DYbiKCKwmIPn5NLXPzbLNL0MaGNR8bkBhW4+Y6HeqBadYVi/
	Vvqise/lbsi1eSpOINpF8tgvzmT28n5w=
X-Gm-Gg: AYBFou1BGskGwfqrjioea4FK9NhKpX9BKPouXDA6S1LGUPssM0BpUxMMZb/mohwXsh7
	/f/LqllGko698lrJjb3CLioEQjKx9C86E+aMtyi+zH5CCXfaUISpdOVTvY23sIx18vvh0lg4yGy
	fG9alR5KFwcF++DoBPb+A1DX0hkaV9BxdsXKelBsjHIOTb2ifYMtRqtpm9VGCtA5XnQSQHxyk6m
	WH6DNHwAgdvseb5zjUuejyoCAi2N3G4/+UI6UNtJ2ftbVf/3T6R6rJSbbm3PbYK+ZXvBeSmjBDg
	wvwyjrRkSzk8p/35SBZ08iKwx1Yrst8jRMIxqf9MkKxs4HSySp7q4bSqRn/utUX2+lIqKAyQGXR
	vIPtomNfJlxsk/hQRrn/0FYIPwYgBhkZQI88JInqwm9GKbu5B5/erIpY7GjNWPXGGXQ==
X-Received: by 2002:a05:600c:37c6:b0:4bb:7033:c938 with SMTP id
 5b1f17b1804b1-4bb888147b7mr42207885e9.14.1795157377099; Thu, 19 Nov 2026
 22:49:37 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:49:23 +0800
X-Gm-Features: Aa3M54qOc1yY5SxJT7UDbDpxwpV9EzYxtLGhUe-eTcqoOXQmzD9xaaxO1UoM8Dw
Message-ID: <CAN_Opa_4DSrhb=nOKFEP2eV-WVaFpehpS1-o_PTO1cibJ8doUQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
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
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2edb9beef6d3..46beded51c7d 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>         VM_WARN_ON_ONCE(old_gen =3D=3D -1 && new_gen =3D=3D -1);
>
>         if (old_gen >=3D 0)
> -               WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -                          lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> +               atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
> -               WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
> -                          lrugen->nr_pages[new_gen][type][zone] + delta)=
;
> +               atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
>
>         /* addition */
>         if (old_gen < 0) {
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c161d563ce8f..4c4aad95b0b6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -554,7 +554,7 @@ struct lru_gen_folio {
>         /* the multi-gen LRU lists, lazily sorted on eviction */
>         struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES]=
;
>         /* the multi-gen LRU sizes, eventually consistent */
> -       long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> +       atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>         /* the exponential moving average of refaulted */
>         unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
>         /* the exponential moving average of evicted+protected */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fe1fe1439c7c..8d14831cdf83 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk=
 *walk)
>                         continue;
>
>                 walk->nr_pages[gen][type][zone] =3D 0;
> -               WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
> -                          lrugen->nr_pages[gen][type][zone] + delta);
> +               atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]=
);
>
>                 if (lru_gen_is_active(lruvec, gen))
>                         lru +=3D LRU_ACTIVE;
> @@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int=
 type, int swappiness)
>                                 break;
>                 }
>                 flush_lru_batch(head, &batch_end, target_list);
> -
> -               WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -                          lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> -               WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> -                          lrugen->nr_pages[target_gen][type][zone] + del=
ta);
> +               atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
> +               atomic_long_add(delta, &lrugen->nr_pages[target_gen][type=
][zone]);
>                 if (!remaining)
>                         return false;
>         }
> @@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsi=
gned long seq, int swappiness
>         for (type =3D 0; type < ANON_AND_FILE; type++) {
>                 for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
>                         enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> -                       long delta =3D lrugen->nr_pages[prev][type][zone]=
 -
> -                                    lrugen->nr_pages[next][type][zone];
> +                       long delta =3D atomic_long_read(&lrugen->nr_pages=
[prev][type][zone]) -
> +                                    atomic_long_read(&lrugen->nr_pages[n=
ext][type][zone]);
>
>                         if (!delta)
>                                 continue;
> @@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec=
 *child_lruvec, struct lruvec
>         child_lrugen =3D &child_lruvec->lrugen;
>         parent_lrugen =3D &parent_lruvec->lrugen;
>
> +       /*
> +        * The child is offline and the lockless updaters, which hold
> +        * rcu_read_lock() over the update, avoid racing with reparenting=
,
> +        * so the read/set/add operations below are safe.
> +        */
>         for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
> -               long nr_pages =3D child_lrugen->nr_pages[gen][type][zone]=
;
> +               long nr_pages =3D atomic_long_read(&child_lrugen->nr_page=
s[gen][type][zone]);
>                 int child_lru_active =3D lru_gen_is_active(child_lruvec, =
gen) ? LRU_ACTIVE : 0;
>                 int parent_lru_active =3D lru_gen_is_active(parent_lruvec=
, gen) ? LRU_ACTIVE : 0;
>
> @@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec =
*child_lruvec, struct lruvec
>                 list_splice_tail_init(&child_lrugen->folios[gen][type][zo=
ne],
>                                       &parent_lrugen->folios[gen][type][z=
one]);
>
> -               WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> -               WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -                          parent_lrugen->nr_pages[gen][type][zone] + nr_=
pages);
> +               atomic_long_set(&child_lrugen->nr_pages[gen][type][zone],=
 0);
> +               atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][t=
ype][zone]);
>
>                 if (lru_gen_is_active(child_lruvec, gen) !=3D lru_gen_is_=
active(parent_lruvec, gen)) {
>                         __update_lru_size(child_lruvec, lru + child_lru_a=
ctive, zone, -nr_pages);
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index c2cea36289f3..6551f0a6691a 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lr=
u_gen_folio *lrugen,
>         unsigned long size =3D 0;
>
>         for (int zone =3D 0; zone < max_zone; zone++)
> -               size +=3D max(READ_ONCE(lrugen->nr_pages[gen][type][zone]=
), 0L);
> +               size +=3D max(atomic_long_read(&lrugen->nr_pages[gen][typ=
e][zone]), 0L);
>
>         return size;
>  }
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
