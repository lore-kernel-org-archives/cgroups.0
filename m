Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162829;
	b=wkEHOyHvohbUnpHwLpsonwpbju3tQS2OAQV3Ko5or/2OdyUxrGBsCpLb7ys2wDQoODC8
	 srfDNagoCzUW5TC/7fJe13mcxJrWCvyAS0DCdshmbeBckGIsek3tqvlXAzX8CzW39ravm
	 eobEjVTDDUk1mchOYu7dJp7OK4YOfHOJAQ3wXOBsi1xBViRvtSsolAQPmOvRflfElBBO1
	 3eu9RhxzexXmR/41pSs09JuX+n2Rm8FGUUXzlMu3dv1aKcGsys1Gy2jPzCtF54lU5YI2Z
	 ZGcmqtb1Xc/CvTB7JoQMSQuZD0XwDRFSAaGyF3Y4x4ZB+q945X/GMtIuQxRaXb+kbQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162829;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
	b=uPy3ZN5IXWutUQxVcfPOE02eI7+TMUeW0QCFeKuCTjEunDwQoFg82UagZqW0c12iazKi
	 uFHk1ANTNL4DHuwEQoFFQ0NdZVbxEec9Y/ch7fcxtZhQWHmqe1n9Cb93xG4kdNO8yfvet
	 rDcl8sjUkWXokOtY1FUWqgBo1dBBEvc3kqBKxA7DpLsl8bKnLmFkmFFXlmo8qwrj8PbS3
	 W7R1DN7tO2xLfAzdsWIjpKN3g2iUd9mirR0jsJv0tIUwYe/dBxLGmEebNsaouc+kHY/qR
	 kP3dKo40SmoimCCGr8/D76FYScYP5Va6WgP++AXLBZCpMP9ktSe/D2zJRhNx034fimA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C8HoSI7f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CE9606A326
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8CE9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C8HoSI7f
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso15944755e9.0
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:20:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162827; cv=none;
        d=google.com; s=arc-20260327;
        b=A6re1iaZKEJ2AFRTs1TzkWwWjb+rIyM6ZvZxISa2q61btwT3hc5CjV5Jc2FA2VCC3B
         iArbXtOBSn5Q9SS3uX8flRg37YO17bZRJ9qSDwWCACrIX5G0fNZbT2QeOULnveeEMgMe
         J0E5NJYtZprAaBJrGyMZrjukUZ/7BZFJ5bUM3CaGXQXGIKE54FK3TyRIkpnz37sVr1C9
         xgcWV6BB6nVMR27rXkZOUte+8qdDQmD06nLbd6kgf4+5X35K2DiBW2QuinyIIrLQyvVL
         qrsf5QReBep3WU7s925/BS7lS94FbQeMZu+bgBEt4xTdp/ks7qRwjC6StT1l9vxeNJ0Y
         nWZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        fh=N57I26txwJa2JNYiZ3AdBEhFgjF9R9HGsTSf6j8KODI=;
        b=oj0MuO+PpnMorPrzUF67lhqZRZ44PYJ4n2W5YX5LTg48hdXppXDGJ7OGl4hKVZFNPm
         m3b/iXQmUmrUv2MPe/URQpH45IILs6apw7yCS51NIu0Ii/Zn9KM80+5u/Qv3CVwRScjq
         sBbWtyXhIeDGA3LU9JB0pDpzp1FvYxhOcN16eV6EHVRkokNTLw2B67FnEjb51FwhncnT
         jSqNCxV20dj1n1tysoVNI6mHolmmi/nkoJDhlx9fpc4jEYez+v6iZY3LYmXEGKhUNyzV
         2hC3Kc7HXc7Lm9uxDAw5rAAH8Pc2GsnPJXcN96qo9BpzbGt2lTcRGiBMIuMybKoKBDm7
         NXIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162827; x=1795767627; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        b=C8HoSI7fmzQqSFOXS31oD3FBLkxhz9Ruego3Dv1D3lPfU8LERi3bOVkE94w0HiSOnz
         Q2sQUYXxgTh1jIlulfxC2RSVcBvHlWBQKOOb+VVwD5MG9/Yyy00BbNSEb2o1LmJpvot7
         glPZJ3rY1I6sFhRlA46IqU/mdSBy0EjvpwkbzcydC4keBozMmPNXwgutpB3w9VEsM6JC
         bUwQaYX4lLQ9QMptax4kLlFUTcVxcQt7Fq/9pLSffdHgGQJyMGgTUbyYNVSPUJ7SGQ3d
         okHWgDdJ7gT5RIroMQ7jmBqmfPmkubd3C6mnFeXTYA7xoL7nxmXZC0bx1qeKCAN47EjL
         OKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162827; x=1795767627;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        b=hmi9FbqE1U7xWmvYnk0PVxe+Gx3kPGP+pP6vuyaMcbrBSf517pI4U/kDX4V3XSvuNY
         kVKgxroC/cJY+ANxByLsEwWfCB9tiKs6kPlQj5iYK3t/4cKeaiei2YmCg0xS6yn5eXxq
         ZbxFkMVfUTG8hrkZOLMYcPqdAAeHxN2cAjCQ8/tPzJVDbhKvgdk9JItJcRi5yXAAgXJi
         Z2SPnapu0G7G76WFi6V1ecIcyxloU534V7Z4IbClv0+iU0Cvgt0MYvlQ2u/GmA3CLlgB
         bm4wfG6jJLerGzUFHCYnTmYbnnRX0/Cw0Ixw9UR9UEG4JV7jLm/8WW3t/rtwwy9tpQbH
         nYBw==
X-Forwarded-Encrypted: i=1; AL+hErE9dR66+AAlBczDwE9HP8Kznpmp9cTg06/pgwtUqNtz9rWzuzqvSSCv8Gc5h6sueZRK7H9luhOT@vger.kernel.org
X-Gm-Message-State: APuU4Z8hkCz1nmatNf6ZlrbfLAG72DJPya14TucnKXOM2PyYrDy2LZtp
	ObyLuadoPCoYc0x6uFCBgiaywMJrOApGQSs4FUqxFHlYc0iBFdEGeVNnM/bw1/CEJrcYHE3xPuN
	eua3flcClB0PJnThEpf/B9Gi83JPu19I=
X-Gm-Gg: AYBFou2LSM8SZVhiM5wfG/ZZnjpt6Jdv0PUXZV/JpVKILfnWfgxMDmGrFcPbU7Rugox
	m0xNArJY+p0T144dhHMOUbnZ0H1KQkn09ogVUnCpuN+zQcps8u8j+iReCq2o1V795tkJZNsy4zz
	TukHkgAg0LikCwx3fVBw3Kl8VUfPyCZ3SrzeZQ2H4xoBSF2E+IQsO9laXIxkOFf4iVDovEh2r6u
	5nIVTSKpUnuqgo/lPl6dLEshWR+/vza7fU+3TqSVslnhGe4OpjL4LOhCM2umTLL9Rna7jzO+iGP
	MhA0iUeplf1auv+rC0Pa0AB3u59b5/NDDytWvrqMTZAiSInJ6JZ2WA+ocNaJdtMvHXzmt0qivpK
	AFZCvs6w2gx9bZWyku6pq/gh5hkOf5pW6nG6E0UmyXpyAmlp9XWMAlWU9NoNgOuwl
X-Received: by 2002:a05:600c:4504:b0:4b4:a551:681a with SMTP id
 5b1f17b1804b1-4bb887fc396mr47908935e9.3.1795162826538; Fri, 20 Nov 2026
 00:20:26 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-8-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-8-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:20:12 +0800
X-Gm-Features: AclHuK_oxtudcnoh95U_WO0vrwwpF-uDqqiNW6HAKd9dIMedRC4HEEVfEGFR52A
Message-ID: <CAN_Opa_3vb54=6pMeRfzBpTmXG0Bfprhjw8H1mzA8NZ4c51U-Q@mail.gmail.com>
Subject: Re: [PATCH v5 08/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
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
> Pure code shuffle, no behavior change.  lru_gen_update_size() now only
> updates the per-generation counters plus the promotion move; the
> addition and deletion active/inactive accounting move to
> lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
> and can apply the active-window test directly.
>
> The unevictable case is untouched: unevictable folios never enter
> lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> before.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 180db43c3a85..b15c3618a1f2 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -322,21 +322,9 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
>
> -       /* addition */
> -       if (old_gen < 0) {
> -               if (lru_gen_is_active(lruvec, new_gen))
> -                       lru +=3D LRU_ACTIVE;
> -               __update_lru_size(lruvec, lru, zone, delta);
> +       /* return now if not a promotion */
> +       if (old_gen < 0 || new_gen < 0)
>                 return;
> -       }
> -
> -       /* deletion */
> -       if (new_gen < 0) {
> -               if (lru_gen_is_active(lruvec, old_gen))
> -                       lru +=3D LRU_ACTIVE;
> -               __update_lru_size(lruvec, lru, zone, -delta);
> -               return;
> -       }
>
>         /* promotion */
>         if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruv=
ec, new_gen)) {
> @@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
> +       int delta =3D folio_nr_pages(folio);
> +       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> @@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(struct lruvec=
 *lruvec, struct folio *foli
>         set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
> +       if (lru_gen_is_active(lruvec, gen))
> +               lru +=3D LRU_ACTIVE;
> +       __update_lru_size(lruvec, lru, zone, delta);
> +
>         /* for folio_rotate_reclaimable() */
>         if (reclaiming)
>                 list_add_tail(&folio->lru, &lrugen->folios[gen][type][zon=
e]);
> @@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>  {
>         unsigned long flags;
>         int gen =3D folio_lru_gen(folio);
> +       int zone =3D folio_zonenum(folio);
> +       int delta =3D folio_nr_pages(folio);
> +       enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
>
>         if (gen < 0)
>                 return false;
> @@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> +       if (lru_gen_is_active(lruvec, gen))
> +               lru +=3D LRU_ACTIVE;
> +       __update_lru_size(lruvec, lru, zone, -delta);
>         list_del(&folio->lru);
>
>         return true;
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
