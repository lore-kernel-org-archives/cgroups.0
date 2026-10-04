Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49C5347532
	for <cgroups@vger.kernel.org>; Sun,  4 Oct 2026 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134957; cv=pass; b=Q/Xui6/DvGl55mcjbB3wLzxyEoLUGyffHdhoMxfgEWzcpfGsqrjKLrUoyQty4r2kUHKMeFTLHbEm7PFjkIr71vPybU1+qplukgcTW/rgc+Km+UdldXGnOaM+QQSg4seivAUAf0IlGP6Sv+CgUQvKGkad1lBKl/dY/mCEn8vm59k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134957; c=relaxed/simple;
	bh=d+klvdGuyQqsumljdCcLk777P9Nsc23NZ5zQHFqHQw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKKTN/Q7Ut4ULcy+U1CAamNmTz/l33ipl5vdr20z3YbCLDrwNlidxHyIuIQkDbQam4mD6U4ylRzudo4TyNRVPk6fEczqg8qw9seczAn3T/yf9CY7RNzH3oujkHWwY8Q15UwYMo4VZJSpV64T4u36PxUyKqsmVmKIWzKdOhOBcPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSHpEk1/; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSHpEk1/"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a1681949b8so6043885e9.1
        for <cgroups@vger.kernel.org>; Sun, 04 Oct 2026 10:29:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134954; cv=none;
        d=google.com; s=arc-20260327;
        b=JUxW2DaVmpKXTilOoZL8uQT43mvXT+wcvy00rMrxWXyNjxCNoKWzQMBQdihYmcSDkl
         MHh9d/pFzqAw+gmuIG/+EwvLjylQppxNP+BMi8HkkGPeJXf6BEfS+JRmKkCIquF793b4
         U7upF7l+HNEbCgOodQRGg+zh3nEUaAQzjyr/rXfY2HaU2XuAq5ZKgQY9MAMwqKIOgHYw
         BunWMLYQWBmTb7ymnsiK6zkglMBNMBP8k9OFh/1fThUrXkc9URD6x4QRq8VL/ObDYuwH
         JFZpa97Vlf1CPjZeI5DRszZkxdXPBDd6XiN53nzorOP6IONu41acR/SqQX5RIgJuGEsK
         VOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        fh=zwSIeoDRByKjaivcccwhfqB+j18A43wOOd9l9sPisyM=;
        b=oZaljr9U9ldoRbzIw4p663+HR5VLpkAnN2XPff0sxxYpkhhckJ6S+MnnELxX+ciWnU
         XvwB+HuQT4wt4VXWBX8bvp4afHEmiLXtsJ8T9raSP6fteSeFPYPChd3CR7lzGgEElQVM
         D3vop1trO85BSpm5pGjF8PQk0a+0vos/IjMFaiE0YgpopTl/C0sowOPkj+9QpKIWT8GQ
         ThTHFogqA/AAHbbYcvHn6yfNmMs7bWaCkigfmTDPRzgsVd3/gn2FG5nGVMPj1GwTF6FC
         2lRMNnCUDKEfcRCl0utptIqgDeypScjbePd7YngUUFvKf8e0kjsxjnFXL7x6VIyImLEk
         5Tlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791134954; x=1791739754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        b=eSHpEk1/LK35CgxKre1+OPjfWFqn7E7JR7ZGzbVl/yEKIHHdqa5H2Uq9sKPAujxk8E
         fp36DV21P8DylYfdkFnRGTebrUSAUuPfp2MW6Vpgsp6E0NkuIQS03ol3obz4JLwr4tRX
         +FdVGBSP8GrXLfdrS4oFXbTVFHmSgVd8g5oE8rl9gArmBY6P7QrvMbLuiFCcE7z3solA
         42cSInSTpAfoRZ1EGDuTSBnbhCW0gbVdT+yuHPFXDJtFy9w9zSErIgsLDCGVfSdudpGg
         lLA7JXL3jN7g5PyVYj6pO564SiKB04rnQpFhvr29EzN5hsRQVYHAuB9xwmXWNCLY8sb9
         ER+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134954; x=1791739754;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        b=Dl/jTuvJ5MF9rxruYs7I8PvD63PY2w7zE7kaQRewims92UtzUUyn8Lt33Sy6/AsEGm
         wQeYOFYmLfi8qvs4VU/agu6UO9zIDKTY1DWOuy6A6ZQcwnCAl5Ic7ahauqSFiK+ys97v
         MX4KFT9euO7XHzD6hmFrjUzvOg079k5UePLtbEqSU66mhDShUJfqK6eSvuHdN21Rpq4i
         ITRt+Y7ZEM57WNBZLoOlYLG1utXXmVYlyCaeUIM7zK6N4aBq6sgPgz7151nWEe5wyuAR
         KxodYwhyqbjx8vovSRK9+ZRkrVeZYNxipcGMZmTHV7MXka8DnRJC/9dJcCBBYCLdtnsM
         RI6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxCNOp1gmZMX1lp02j5amZRmOBrG5r5ImdLzcrf8xcWztfyDLKbQgACq1E25ScZECQPSBEAVgqK@vger.kernel.org
X-Gm-Message-State: AFuF++l0UHW8asQ+ttyq701Y1ffyYFr/V+DRRsAQc6ezJuzB0FTZLU9v
	Tug2FkHuHG9/MX9KiAwAcZvCpbkJJkGRIJjG+t9ta2OWF0YRX995g96oitQjjpmVniq+YKgSOhX
	ccptR3IguuBctqeV8UwuTvMZUiZFhl1o=
X-Gm-Gg: AYBFou2Iz1LrqdZrNHzu9IkAL4NT1uGIXc+kffNWCCvPlwqW7r8RfsjRJDC4moZVgdb
	Zxhhi6MkgmRhDl17fDzDZIv301Bm/cn614l4VDTg8MoX+H0T4ayelwMPpOTCOLABrJeLlUe6Us5
	zOgYSvTRkyVkoB5Qy6EZ4Rq2ThX+tJDpA2KvN8WUn4LV3P5q3Vr299ECz4n5k1kC3ex6cl26YXR
	B2XlPBhe5DZNt01gHMxAPOxlbPWSMk9gCE0JDLX6rHfMSvR8eDO6TfKlkR0OdTEUAVGUkW00r5T
	1TSswYHmXjsb1yvWIaTjTjmN3NiuZ691EiHVoJk+M8KzDSqF33hOt1C4
X-Received: by 2002:a05:600c:1f93:b0:4a0:1c10:1419 with SMTP id
 5b1f17b1804b1-4a1728f7420mr4939855e9.26.1791134953064; Sun, 04 Oct 2026
 10:29:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com> <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 5 Oct 2026 01:29:00 +0800
X-Gm-Features: AclHuK-zSaDkCDRQQGwKNOJNMAtHWxrJA-WegPxW9dj_BWzM-Y4DHWh_wT_NDVk
Message-ID: <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 8:55=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> concurrent aging from corrupting the size counters.  This is no
> longer needed: the per-generation counters are atomic, and the
> active/inactive ABI counters are updated per folio and linearized by
> the CAS on the folio flags, so concurrent aging can no longer corrupt
> them.  The same argument already allowed folio_reset_lru_refs() to
> drop the lock.
>
> Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> read lock around the lruvec lookup, and drop the spinlock entirely.
>
> Without the lock, aging can advance max_seq while a promotion is in
> flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> flags can return to the value read earlier and the cmpxchg succeeds
> with a target gen computed from a stale max_seq.  Recheck max_seq after
> a gen-changing cmpxchg: if it moved, account the committed update and
> retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> The retry may count the access twice, which is acceptable and avoids
> folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> orders the flags read, including the one returned by a failed
> cmpxchg(), before the max_seq read.
>
> Also simplify the post-CAS accounting guards: gen is only assigned
> non-negative values after the old_gen < 0 early exit, so gen !=3D old_gen
> implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard.
> The active/inactive ABI update keeps its gen >=3D 0 check because an
> off-LRU folio has no lruvec to update.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 10 +++++-----
>  include/linux/mmzone.h    |  3 ++-
>  mm/vmscan.c               | 47 ++++++++++++++++++++++++++++-------------=
------
>  3 files changed, 35 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ee7fcbe2366b..b68d68101248 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct folio *=
folio)
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
>  }
>
> -static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
> -                                      int old_gen, int new_gen)
> +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> +               struct folio *folio, int old_gen, int new_gen)
>  {
> -       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         /* use the refs from the atomic snapshot to avoid raced update */
>         refs =3D lru_get_refs_flags(flags);
>
> -       lru_gen_update_size(lruvec, folio, -1, gen);
> +       lru_gen_update_size(lruvec, type, folio, -1, gen);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
> @@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>  {
>         unsigned long flags;
>         int gen, refs;
> +       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> @@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
>                 folio_set_active(folio);
>
> -       lru_gen_update_size(lruvec, folio, gen, -1);
> +       lru_gen_update_size(lruvec, type, folio, gen, -1);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, -delta);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index e096fd0a5047..d78e3f97423e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -558,9 +558,10 @@ enum lruvec_flags {
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> -/* Access source flags for folio_inc_lru_refs() */
> +/* Flags for folio_inc_lru_refs() */
>  #define LRU_REF_MAPPED         0x1U
>  #define LRU_REF_EXEC           0x2U
> +#define LRU_REF_FORCE          0x4U
>
>  #define LRU_REFS_REFERENCED    0x1
>  #define LRU_REFS_WORKINGSET    0x2
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ae4a0522a8d5..9cc06a95d931 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, unsign=
ed int flags)
>         long nr_pages =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen;
>         struct lruvec *lruvec =3D NULL;
> +       bool aged =3D false;
>
> +retry:
>         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
>         do {
>                 new_flags =3D old_flags;
>                 old_gen =3D lru_get_gen_flags(old_flags);
>                 old_refs =3D lru_get_refs_flags(old_flags);
> -               file =3D folio_flags_is_file_lru(&old_flags);
>                 refs =3D old_refs + 1;
>                 gen =3D old_gen;
> +               file =3D folio_flags_is_file_lru(&old_flags);
>                 if (old_gen < 0)
>                         goto out;
> -               /*
> -                * Lock the lruvec if the folio is on-list. We are alread=
y
> -                * doing lazy promotion so in theory we don't need this,
> -                * but for now, concurrent aging would still corrupt the
> -                * size counters.  This is a temporary limitation and
> -                * will be lifted very soon, so the lock here is not a
> -                * performance concern.
> -                */
>                 if (!lruvec) {
> -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(foli=
o));
> +                       lruvec =3D folio_lruvec_live_get(folio);
>                         lrugen =3D &lruvec->lrugen;
>                 }
> +               /* Failed cmpxchg() does not order old_flags before max_s=
eq. */
> +               smp_rmb();
>                 max_seq =3D READ_ONCE(lrugen->max_seq);
>                 max_gen =3D lru_gen_from_seq(max_seq);
>                 min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[fi=
le]));
>                 if (old_gen =3D=3D max_gen)
>                         goto out;
> -
> -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> -                       /* Promote second page table access or executable=
 */
> -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF=
_EXEC)
> +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORC=
E)) {
> +                       if (refs > LRU_REFS_REFERENCED ||
> +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
>                                 gen =3D max_gen;
>                         /* First access only defers eviction from the old=
est gen */
>                         else if (old_gen =3D=3D min_gen)
> @@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
>                         break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       if (gen !=3D old_gen)
> -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 old_gen >=3D 0) {
> +       if (gen !=3D old_gen) {
> +               /*
> +                * Gen-index reuse can fool cmpxchg(). Retry locklessly, =
accepting
> +                * an extra reference to avoid folio_activate() latency.
> +                */
> +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)) {
> +                       flags =3D LRU_REF_FORCE;
> +                       aged =3D true;
> +               }
> +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> +       }
> +
> +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 gen >=3D 0) {
>                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
>

Hi Kairui,

One question about the retry path.

When `max_seq` changes after a gen-changing cmpxchg, the retry uses
`LRU_REF_FORCE` and promotes the folio directly to `max_gen`. In the
normal first `LRU_REF_MAPPED` access path, the same folio is only moved
to the next generation when it is in the oldest generation.

Is the stronger promotion on the retry intentional? In other words,
does detecting that `max_seq` advanced during the update justify
promoting the folio all the way to the newest generation, rather than
re-evaluating the original promotion policy with the new `max_seq`?

Thanks,
Kunwu


>                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_re=
fs),
> @@ -1047,8 +1052,12 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs),
>                                   folio_zonenum(folio), nr_pages);
>         }
> +       if (aged) {
> +               aged =3D false;
> +               goto retry;
> +       }
>         if (lruvec)
> -               lruvec_unlock_irq(lruvec);
> +               folio_lruvec_live_put(lruvec);
>  }
>
>  /*
> @@ -3648,7 +3657,7 @@ static int folio_inc_gen(struct lruvec *lruvec, str=
uct folio *folio)
>
>         new_gen =3D __folio_inc_gen(lruvec, folio, old_gen, &gen_increase=
d);
>         if (gen_increased)
> -               lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> +               lru_gen_update_size(lruvec, type, folio, old_gen, new_gen=
);
>
>         return new_gen;
>  }
>
> --
> 2.55.0
>
>
