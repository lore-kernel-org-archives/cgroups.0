Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795167730;
	b=R7Bt2FPnjITsUJA7LqKXcd8BT3iGbNwxkAe5uVXemV4bAZiVzLziL887H9r3cfahvNcG
	 4AIcQIs7+2EYOC6q2O607D6Bb5UyWPElQ0pB8j7qu1JY2VbCNsZciiOs9tq46OHyAZY/N
	 CX0fnEZdCAZCym8feheq43VGC1Z7PZ1PiUj/zfN1w/tx58TrAPgu2kPpFxXReU4Tttt3O
	 GAlrFkzcsbTyhjAQdf6G/zME+hITS5ULvoUtTPbJgNIOsIup0S4mt+tmp3lezs2iHe0qu
	 FszWSSXgvHJpgGygW2nSpf4gHryFFJQGzdbGEWcjQcX/cyrATKFzto+FApU8IOo2ehA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167730;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
	b=KhO41ZCJR+pkcjH5Ee+FNWVSB9q7DNVDdiVRv/k8tOsjh8wOAIjaL5+EKfUKCxn7pxnt
	 UpgjdDVmpTyzIRN+cNKbamOG/kPeOuqD8SuWq1/mAPK4vrOXCP1w5X4ky7oy13mmXKENh
	 NJ+inhEE7fFlDKxeicb073BcGBIrngL7ZC0n3DYptyRtoYOw7UWAFImJ7VP2d8JgKANuF
	 FkmpZPFffBUPTgwXJdOiKvWU6Mav/5XPu7zOD83c4gvJg9dE9Q2cZSgr1iZJuRYGmJLxu
	 N1kHDmhlhMbnyfO4is5A5PuONk2z5pyEn/4zpkv2t/jB0yufqLOzADhwLgUTCqJXm6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zLYiEH08;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C85F606A326
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 09:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C85F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zLYiEH08
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so5790705e9.2
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 01:42:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167728; cv=none;
        d=google.com; s=arc-20260327;
        b=af2h0HPJJ83P6l3Eu31ErDU2Ehx/VvYwYnIIx1zWgym43nNqrcjRpn5i4BwcUmrZak
         i1ZzXBFTb20at94bod17PpOJLXYrqfoL/a8i0dTbIf0WUPdAi5w7MnAjiCKIRh9Z+Bwe
         rmzOHw0S/fZ/Ug2C529JKr/h0XrQxigK0k9tX0alSdbxSEKXDfOfTkhKoAYFlmweqpSY
         6xc4eC9So49GiCoIAnx5VpLdWIe7f1MwvCcnKNTPrNqYPFboTVeoSp+05VOLbHWbbEzH
         JG1t3NhmsOFGqDo0ofryQMYWIk6HGUSvsWpWG+8vvDhI2wNuzJ+O4S2PJqtiFYVvUIw+
         KpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        fh=3yaLf6Y/Rxlpk4SbPmxV0ln0DpaBCH5C8RX/0tzpJ8A=;
        b=HmAcwOo6rVP/5XibsZBGvfDR9ZcLjQacyOzk9X7jocYvZIz9fOB9xMKUBa6CxB/cYB
         T6ilUWg4xomJ818AHMjVVfBN0HjxSgv0Ii0Qpt9Dx/CdjpVgGNjf+W6MCztK5gJC0NhY
         Vj+rJjgW6fk7cgR5M0JyR7L2I9WObVf1GS6rNRRcdcK1qsAPKA6uOwHXyIc5F6xtjYj+
         +Hi14kpijSd6URJWRm5crLW3oAlNvM0KbRw7Hz6R1to4jDF/DHKL4coOepiKwCdnJjSE
         nru12oA8iCxwF6TkN74r1o2V+7vT1zGfhdkJmZkhbW6kG5S1VcWqoGRhECnF6E0JW7Pv
         v7xA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167728; x=1795772528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        b=zLYiEH08IhY23a3r2wqFJiWEOWC4yGMO9eZaSVKWX3igGNvYRxYk71plqDbE4hi+io
         qekGkml6e6cnb88TOIoiIr3DxqFfYRTXugTyzUI34iNqqjoSEQ2WGKLo0lXNU/QhwhoT
         zz7LFuBOacsW6prI4LEHiItwLW7sNqwzipN5jcya9osHu9EVdaiP6C9p9sg8rcf+sWKE
         JWeXpKsyl4LYpQkrVXUDy9XOUH1QvPHjYIzjdSx57DSkbp5gahy7rsCkjhgGjmiZoh3+
         38bsaVKGvDWro73/Usp+8lD5Emuu8e2cWd9KQhRNYD8zD3FzWuLMBZQvP5Cbpb+fc2+f
         7Ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167728; x=1795772528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        b=FKadSM5igLFhj6yoESi7fSTu3//bmSemp+vXiQWd8azMw7mItU0uMkZVekzTDFbryE
         FL2Z/2GnDltg3rqtcCUf/9uFzKX0Y7gEx4Pepl1w8R9jFiKvVN4XoMIJ/zi6ueyxt7RJ
         qlRlHfTnw+pK2Ceso8r6Y3j0jbFImgvOYuH5CfLFYjhCRaCv7MrF7VWfjo1yXW9jKpbc
         ZkTKehZiOOAUmUP3yQEMSIsf4gIz6klzfe7eP06o6WkGiRjm/SAQKUTIks2mv3mrDfxf
         cAYMtmfyyK2m7T413xocJx2gyr4EaHTx7IpPamtQ7IO7nl6q3IOSKSplM5gHwP6vGEF/
         1uYw==
X-Forwarded-Encrypted: i=1; AL+hErFb0tSO/TuUPwA8SeHeXK9l3R4HrKjJYRlFKFhgrj9hOK2k73c1/hVbNPIb1Zh7T5tmUyLUlOje@vger.kernel.org
X-Gm-Message-State: APuU4Z+ey4YDDS2U6gRHxnka8P6fZYkTDXvkwtLteo353lzOXeSjsHT1
	jf0KNnBA6cKiDsG6Yd/1x60CGqWXQ0qALO46m/NM6YP/8PkCqaX/PcDyx4ReUCpa65uAodqH2xH
	0ASzP+6V6e7Pv5lNUJpFPHNErdogq4Zg=
X-Gm-Gg: AYBFou28rPrW/k8bXJ7CrM5iff7BGqiLLaj8VOqajCKUp3+LuSlUUARpC7YdocEO/hb
	3D0P/ldvG1Q6nh4OOtSqzsmxDphkzUsMIjyyuBIqBTKR26BHLSzvzzIH26FojTYVPRiJgFWkpYt
	z9QR/IR3/ieTa9q3dpoqMPor0s2A/EE7WcHeVX/4B64dodWQsL9XRx7DwElxa9nH7v2UzjDU7Bk
	h/8Emfq78VG/Crx5VnM/aZ8ekT7eFaASqaUK4kCxlB0pR03OPT/iONxD2HrtAdxLDoYRGLLAQ+H
	vRTtBg0nSwatMlc85RiCGo0UvetrA98CLzFYFruxvRne3+4/Qe4dnXm18yxyXQckxqtjADZ2mQE
	nV6xIS1d+GgNPakAXIbRmdP5pzneL6ziBnIsw42K3Q7U=
X-Received: by 2002:a05:600c:1d1d:b0:4bb:73ad:c1f0 with SMTP id
 5b1f17b1804b1-4bb88812b0cmr58328185e9.23.1795167727989; Fri, 20 Nov 2026
 01:42:07 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:41:54 +0800
X-Gm-Features: Aa3M54oYjUSUM675Gm3euCp0JmfduimCijFMBt2l5Ov01ZX35R428bhh5tZMXzI
Message-ID: <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
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

On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> concurrent aging from corrupting the size counters.  This is no
> longer needed: the per-generation counters are atomic, and the
> active/inactive ABI counters are updated per folio and linearized by
> the CAS on the folio flags, so concurrent aging can no longer corrupt
> them.  The same argument is what lets folio_reset_lru_refs() update
> the counters without the lruvec lock.
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
>  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++------------=
------
>  3 files changed, 39 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 77f514143266..2c6cbd0df686 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec *lru=
vec, int type, int gen)
>                gen =3D=3D lru_gen_from_seq(min_seq + 1);
>  }
>
> -static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
> -                                      int old_gen, int new_gen)
> +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> +                                      struct folio *folio, int old_gen, =
int new_gen)
>  {
> -       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         /* use the refs from the atomic snapshot to avoid raced update */
>         refs =3D lru_get_refs_flags(flags);
>
> -       lru_gen_update_size(lruvec, folio, -1, gen);
> +       lru_gen_update_size(lruvec, type, folio, -1, gen);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
> @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         unsigned long flags;
>         unsigned int refs;
>         int gen;
> +       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
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
> index 2680e15b6de9..235fb04f8d78 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -540,9 +540,10 @@ enum lruvec_flags {
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
> index 78a1b4de7076..4576a7a369e3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, unsign=
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
> +               /*
> +                * Read the flags before max_seq, paired with the store o=
f a
> +                * gen, which samples max_seq first.
> +                */
> +               smp_rmb();
>                 max_seq =3D READ_ONCE(lrugen->max_seq);
>                 max_gen =3D lru_gen_from_seq(max_seq);
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
> +                       if (lru_refs_is_workingset(refs) ||
> +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
>                                 gen =3D max_gen;
>                         /* First access only defers eviction of an old ge=
neration */
>                         else if (lru_gen_is_old(lruvec, file, old_gen))
> @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigne=
d int flags)
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
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_re=
fs),
> @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigne=
d int flags)
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs),
>                                   folio_zonenum(folio), nr_pages);

Could this leave the parent's local active count too high?
Isolation can debit the child's active count after the refs
2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
can go to the parent. On SMP, reparenting can clamp the child's
negative local count to zero.

Thanks,
Kunwu

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
> @@ -3517,12 +3529,13 @@ static int __folio_inc_gen(struct lruvec *lruvec,=
 struct folio *folio,
>  /* protect pages selected by the tier PID controller */
>  static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int=
 old_gen)
>  {
> +       int type =3D folio_is_file_lru(folio);
>         int new_gen;
>         bool gen_increased;
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
> 2.56.1
>
>
