Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795157597;
	b=TiRcsxvuiQu0NOY+KFQFH7a1x0tjV9Q+PFcGJuM4jQlhLj4SGQCX7k2ZH8JPxW4QDoDq
	 ix9vHZiUd0EtEMAlBiv9lmzam+dtVzWpWM7ND84Cccde394i7uu1xRw6SZPqUV6L96XT+
	 8hZnIdJJAlOxlrkwbFPOVG44PKO5bl2LNCL/r8+74wvbcZqPrS53KyK01U8T1mWGZGU8T
	 I2Et0K80POIl6eXmfx+IAvb1Ls6+3jznK9s5ysoGqG8vYLtklLHFSGSPPB1xfoaKEk5Lk
	 T7M9DN9TN3txoO3vYyZDRrDIYUrZQd/tcPPhFy8Q7E8pgTQId0G6RFwM91Btvq4pVOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795157597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
	b=wM3/H0dLUF6b67/DHwyNQs/ygWrF6J0a8fSVz+EGlOKtgM6WOZZHqyayXFe7X0WyR34B
	 MZgXayxrTCl0IxDNkIwBA4CTNHo7VruCBvTetwhjjqFgRhjXmoChT2CJe2Ejw7pY7z7Ov
	 MVFllCeXym3pDtSgxkB3E+oH/IPmDHpuiA53SO+TlE8IwTup5dwj57ggTS2R76WmEJmAO
	 aW0x4OKa+JVCTkOiV6JKM1ua3u/tnrLUVRkVMSw4bnqmFhwzV3llvVC0LWVdPsYuHaOXp
	 o8E1RZztT0biMU2tPvUU1zx4wFG/zhPd8InUER0xhTz9TzKxWGm0GYUsXgr/hT2KAaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DiV092ZI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC4606A320
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 06:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0AC4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DiV092ZI
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so4120085e9.3
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 22:53:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157595; cv=none;
        d=google.com; s=arc-20260327;
        b=bPpjxn4GTUvatgQm2LlcRjWAE7OvBBJx18dVBwfNfS0F432vPzw3TZQxXoUkzOlrXP
         YuuCN4cEbquGJh7vWH6RAGb4J9j7CqooCF8GU4epoLXuPezTJxTF1B/5MWfmWkWJlZlx
         wNbLn9ZOpiSF7yTfErDINw75bRvJ5q5DgD161TV719x9Z8Wb4Gcvqzhljybo1Bux+E0g
         VSZWifjBGoW3YPwTS4jDI/w0hM3VRFfcXktFajHjB8NgsKYjlb+AsV5NIKu7w8kuD1Pk
         5WXmXpNBhGGPQndQenNvll635eSdyqecDFpduwEijPifbDWYLoAR0fGt5/Do4J0c34T+
         HM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        fh=hCQGYFwsB2dsBzjWSgrPgeCHzjgLhpyhedcLi7kTD8k=;
        b=RygyItCQuawftDeXR2lhPtDo1uHPrTIKQDu9uGFeNfSIXnNd46073QhpSXpjglurRh
         YWGFw3uiChKFLWjIeElKh34KYagrgjdhPOvwFkEdMtbigsg/pHzFCvIBosBVmDdgrwDQ
         smyQxlVkpWHHm63y2hDj6pETLc0OzD/VAt1ruzaXbbObpKqr508Tc32TODDoM8EVSL6p
         lNIDvDZvQIPUByFUdQK3J1hFGZLyBG+MEa4/kZ4VHBSD/fKfM+PcCV64YKWk9cOTfBdi
         LKbRFZfNMqz577pE0K9DFoHxIcx0quHudV8iKVf6B1w6q8U93GAzYKsVZ54axbb2VzNG
         398w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157595; x=1795762395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        b=DiV092ZIRlWMel1MulUloZDRoQg0zO2BluGBldR8RURqLG1XfCSvLfAmU5Z5RS/uhK
         6g2LceFrMm0H7yfXVVWZLxrQgGcIFs3xD8kqnLFce271h2i43yRw0BKOPv6hZBfHPhXg
         7BtRLDCtpkHeHYY7/c8PSH5axbxH4nmNVbru94prpfdGbXKrl0t903cYb0RXw7dH0OG8
         acbTTY7+Z6b4rI7JwP3lQV/fli4FpMbIGQQXwtIhnly5v+gztiSIc1y5UKT61ertwBt8
         jGxWinlkvYOj8UdPBcRlSUTFl/PhfxrjSqbS/HiPK93wsstf75FJo3m2Kwk/XcskN33C
         on6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157595; x=1795762395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/fJM3JyrbV2mEEaUD0SZw8LIvK7Rur9l2Ozl8m23grs=;
        b=i6B0TYAI49zO+pclyCScCzRDotsnruOv2QOOPbExH4lyD6sfIMbqRfmRj1GGj/kvR3
         jXAL9ibYTSIwuDtBrgSycXB8fM/mwk7WQ/2jYZSHJrbbCAys9f4tipOWlalTd0p6AFfE
         otHERJhN39it+DKtwo6FC3RZCjR4wmA8ta66sSPGn+Vx2kA92zt1BdJ4FotBfbMfsqAB
         ZQn9jLskGMCgegkvQbo41WHXl59B8ShL24WTwc3wdxureJmg9dXVboR+0rJW57CLwJf5
         RE9Wmt+/BpF1WydG4rYPHLRcNZyVmLXAwsj97QSEUdpshLIuQpUMOUpVTGPeCasc6Lm+
         XA6g==
X-Forwarded-Encrypted: i=1; AL+hErGa0fp6jtIcd3KgzLPk8NDCBcQshFzdDtLUAl0fqSfSdj9/VKa0iNzhfrVHvwOkvUJ/1cN8h/l+@vger.kernel.org
X-Gm-Message-State: APuU4Z+6FCOt07IQWNUha6NCPXOR40wNOJZB+x99cebbRuutrNthBugz
	iAmekcBy6VTI8A3OGOWrYtRnv2+gHH17DYXkFjqMGp1JGB1CRK5AJ6B0g4soQ6B5rEw0foKEXbv
	ehfGmDUTnnpDaOnvCNgXJa3VGyqrl66M=
X-Gm-Gg: AYBFou2sqsnPyDF/HUrwjYAOEA/0CX/yt0Be6mWg6HjB480lYUWYwu9QEIgX2lTmNlW
	MO53vgE/nZoNw+FeSy14BS/xEky+QHl/oY9CQW45V/fY/pXFCBbQ1mEssesBZ9cXINid+E/XH21
	i0f6pjeSnBJqishiB+AJqFSGmmuJ8F7AnpoczgGFQH1CORtPhidaNE/AVJlveZMPZm0t820DZOL
	+LFwTIzr1td7I+kmaV+Q+OLJL3tyQINbSA1tbVX9BgMHB/80IroAY3SC3SGy+6+qxs/m0UlD6xx
	TBOwqbtZs7F2XF1r/TN9yEk+Ful6RCW0QYCM9SC2ia7zInlFQD9vnd8vCASZ8U+nQssvaJ/x2aN
	R6GpehIcxMeYTre5tyoXZ/T/aCbpxVqGKT/1s9/yAum3UsUKj56+3VhqB9Z0ZE5d1aA==
X-Received: by 2002:a05:600c:4f0d:b0:4bb:5c97:f4b1 with SMTP id
 5b1f17b1804b1-4bb8881941bmr45328225e9.24.1795157594548; Thu, 19 Nov 2026
 22:53:14 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:53:02 +0800
X-Gm-Features: AclHuK-UAZOlULyacCKbVJRgcNRnp6P5R-TwcyKCwuErXy_grzV4Q1tvMgKauLc
Message-ID: <CAN_Opa8b0Uh9WQ85HkZJPm6UuqW+eSqtdP_UWW76naupt3HNmg@mail.gmail.com>
Subject: Re: [PATCH v5 05/17] mm/mglru: skip the flags cmpxchg when nothing changes
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
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The update is
> complete at the point of that read: the flags already hold the target
> value, and a concurrent change to them is ordered after it. When the
> cmpxchg would have succeeded, the value written is the same, so no new
> state becomes reachable.
>
> What the patch drops is the retry. A retry re-reads the flags and
> recomputes new_flags from the newer value, so it overwrites a concurrent
> update with what this CPU wanted. For folio_update_gen(), a walker that
> read an older max_seq can lose the cmpxchg against a promotion done by
> another CPU, and then write its older generation back on the retry.
> folio_set_lru_refs() can likewise clear a refs increment that raced with
> it. Breaking out keeps the newer state.
>
> No caller relies on the full barrier that the locked instruction
> implied on the skipped path: the eviction and isolation callers run
> under the LRU lock, and the others (page table walks,
> folio_mark_accessed(), lru_gen_clear_refs()) only care about the
> resulting flags value, which is already in place. Note that
> lru_gen_inc_refs() already returns without any atomic when refs is at
> LRU_REFS_MAX and the folio is in the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=3Dnever) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%
>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> [kasong: folio_update_gen() is replaced by folio_inc_lru_refs_walk()
> later in the series, which keeps the same early exit.]
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 46beded51c7d..2571b3f01226 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *f=
olio, unsigned int refs)
>         do {
>                 new_flags =3D old_flags;
>                 lru_set_refs_flags(&new_flags, refs);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8d14831cdf83..0f24b6ebc1eb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, int *type,
>                 lru_set_gen_flags(&new_flags, new_gen);
>                 lru_set_refs_flags(&new_flags, 0);
>                 new_flags |=3D BIT(PG_workingset);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
>         *type =3D folio_flags_is_file_lru(&old_flags);
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu
