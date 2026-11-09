Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794216809;
	b=Qx5UOGXEpIH0Zgt48ot1tE7nCFqsS4ru3TwwWIaRKSTr08m21aspYg2AuDPA7qcm8wdP
	 Brt0f64MG9EuPFnZcM+kDyxUD88fpZw//DN7LG0umdew9EZdH7RJUIy8TphVk13G5ZS4o
	 pgxOWqOcIPOvUueuhzqyh8I5IjEDmYGUloUS0q96iVRjDmgkinxNa39f1TyNz5swaTe3G
	 U6NjvlIya1dNC2BA/zLqTiGChJWlryvcU3ewqSG75NYDNUr67FK8KkCsNvu9VKoe301aX
	 0g7b3ZB6rrzKC/XteMMorzvVxezG3ctRH3HOpk68vOhW8eq0o46HlFUZMWMUSEwzK0g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216809;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
	b=Jtkj6EYqEU5dwa9mV921fxsOwiFvaupD6p6oZDLiZ4gy/GyVilD1n8oz5l7gCSdwiURM
	 zvPYM1AJyMSoBMQU1mWKk8Yjv7AXZWQakZW1HW5bCrWxlY/B0xLBufx5xsBfgP/ng8Ksa
	 iTYkWSGEYA87qRN7O8PUbjuro8unGxTi07jhglVY0T89yP0qfqmpfKinedCEOCfZnPp2J
	 qnpulVyBEfd4ObAFnESTzjXLL+sJ44R4soMQfmv+hcy1ebiHquzgZ7Mjn07vicljsQbwK
	 qQkGkKVL/TIetcqBiKo/jhQMgOVPanvNg2gpydhIXIDwdsCGLnJUZz4RrE9t4fBhIlA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d8CKQD7A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727A606A31C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 09:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7727A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d8CKQD7A
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso90365966b.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 01:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794216808; cv=none;
        d=google.com; s=arc-20260327;
        b=PdXGNzutUcshVDvPQbx7+Iz21jjI/gHYRqg+efsu8kWPhKMWruDvVnulZ1JEX0dsu3
         oeBiF8+L+03kc8d7/qjEgGRXm4+2hbwyYaqu//2acTJ2Z/MGnATh9HnGqlJllbYWjke2
         LqQgpOE/r65La4ftYT8Whbmip/Ezm1zY71Jr/Jw9FsNB1iD3LT88JmmSu4Y6pc955DkR
         mlv5tdYLtRUEEemv6G1/2jvdBtSulBicuvYoCabL3IYhp9wvLujesgT5Y/mQLINm1ZtQ
         LxOXaMqDlHRmPohfMLrjENYpXMoihcmEyNNimj8jm7UYAp81RSNiqZvxzaNjfBb8ZGof
         2wGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        fh=hEz1f+seFxoUCG8YSvlrOxytkCK20ZXG2SQDQGcLNQc=;
        b=guJfK8a2QavISBTnjVlEzGR6+nQ7qaIoUyjRAVNKzneUiEnsm/v5QB7OOubBt2RMc5
         f0Hshtv1Av9APKTszpEIUUuTwL7aWuJBFp5KNlX75i+z0gKJ6+jqTTZhpjno1MB+5Mwu
         lr0W+lPLfWc/J4nsAEi/XRohXuRpfKSwJxx66V8Ygvuvm/7WvTgzl8gmrNE2nxfWX7+C
         A6U+VNGRhyh+7yadqnUEkse/f5i8c65k7DpzM3YOF0C4OjXWkHs01VJB/o4DXl/N8t2c
         Gpn9yHiY9KvHXJLZ94CXrO+7Z1+mYVsLSHKPgdXX8snuqbBnprBSWRTd80SawMUV9dCy
         9z4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216808; x=1794821608; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        b=d8CKQD7AmQFWq5xRHoblvM0Fzjp3LOVqxc+agEXKrQSoN61liVReEPTibMKp1EL8d6
         zSyiiakmeOcEaU0nQubLDJUM4kKZIGH5Yh81r6OHAYVOOapqmhbS18SActLCQKmh34+C
         oqGKNsb/8QFmGzn6Pvco4VxXSzO97kgeVA7APX2iPK4/e6gOwkclotimHqB3I7OaMQtt
         QFdcCPoLLyt5OIYX3b6al3IVsveoaHpkR0ZEDlcY8as0x9CeimBecKwjw1EuTPZhF78c
         s/N0jPH/Xh4tSoegsQ6ydmvEmFelKC4bA4tZdrvSD0BwBOoBdVn2bnseYB89zsdtWB3V
         TgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216808; x=1794821608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        b=dPdS0DoohvUzjI28u+qcmQKHI2XJmB6izC6yh9hrvq5d8hJFcdFLg2LuJQGeRq/qZS
         DhTEWnuCEyI0l3AO/V+3aWGkhupcYmTOHn6HEsWuS+tpgglJaBRZ3PxS6B8HeHryM2a5
         DQ5Jz9hw8UrC/5ei9TdrrfbN/RhiXcjA3NSwgJYE24nCuSXIWk5nqRRb8Ts1A2RJhdxt
         CxenUgFHaRaUDavYyK8rgi8xnqEjHfLdqrDDt7D+RlKUJVd8C/GWakqPruFFhklvm6tr
         H6T4QVljtcpAikz5uyYnX4CUZV23UoPI+OdKGVLSy2LkHGV7tw8aCO5+Nd3PD7TU6xHf
         ntbA==
X-Forwarded-Encrypted: i=1; AL+hErFX76ZaWbRbCfG1wisgp1JNgTM0orsv2TWOE3CXoJi/yDcj6k8cXPWSQaRImRL9gV+TRR+Wyg2l@vger.kernel.org
X-Gm-Message-State: APuU4Z+LDtM/IOEw5Vbebzv32cjJdnMpIjgd8uRMLJD2zqDCCKM/9nsN
	O4bzAe9udG/i12OKq3zUBG4U7q/FdHky/0ufefesoI61g6r64Hm5J7CE4CEdK8ZpLpf3U9QyE9+
	p1z6IKQzKBpgrC4NkHPOktwc5fBEpbLw=
X-Gm-Gg: AYBFou3ro+TCark7QEpo3akHMcJE/SwS7cyvVzW/VQw51oAgxrHE9Bl0PlGAVby7wN6
	Qf3GnSJyg+i8WEguOArPZFBETDUf2gL28G/+c6GDsYvRnswMCnHCEFp5OTRCer6MxFRqETsICZg
	VnZplAkwMtZsdIaBvHg80kCx6IysTThZHzUXtDksD68w5KDG7jDoCEyvS0slxuMy9u+LT77Fe6V
	cdNaSITZldE7BUpPEbLuNR0iP6U3B6elWdm+tPf1W/pqPFkh92KwB9ZSO7CqM11as6xUU+e5xd6
	/c4ilp6JhmMxd1kZhIq2Vjuj8T2KEXgT3l6kwQf1CKaBR+Z6b8+ijPk8267b4qwf+5+QBbHw9cf
	11CglvBMD2djWgsKvRPC3PbqWAU77EVicmIzR7fKDNl+jUUhyBGp1K8LVTFBp07DUZNVX
X-Received: by 2002:a17:907:2d94:b0:c40:3a99:3f96 with SMTP id
 a640c23a62f3a-c4d6d35c245mr238537266b.10.1794216807560; Mon, 09 Nov 2026
 01:33:27 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-7-2106750c0bfa@tencent.com> <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 17:32:51 +0800
X-Gm-Features: AclHuK-CEIJ-OmAap_Q_FmrC7aIH9q-wRCoxV2MMC7FO6jMxD0d_umEF-d1s_Ho
Message-ID: <CAMgjq7Dw6QtM_VgTuReNs5duPeAZbRukVFZkGuDgbQOXLm7Mjg@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] mm/mglru, gup: mark folios referenced via a fast helper
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 5:04=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> > LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> > classical LRU as before. No counter update, promotion, and guarteens
> > no other complex operations in following commits.
> >
> > Convert the gup fast-path sites. No behavior change for classical LRU.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
> >  mm/gup.c                  |  6 +++---
> >  2 files changed, 28 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 65415eeac802..effa13c63632 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -454,6 +454,31 @@ static inline bool lru_gen_del_folio(struct lruvec=
 *lruvec, struct folio *folio,
> >  }
> >  #endif /* CONFIG_LRU_GEN */
> >
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
> > + *
> > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > + * untouched. For the classical LRU, a plain PG_referenced set.
> > + */
> > +static __always_inline void folio_inc_lru_refs_fast(struct folio *foli=
o)
> > +{
> > +       unsigned long new_flags, old_flags;
> > +
> > +       if (!lru_gen_enabled()) {
> > +               folio_set_referenced(folio);
> > +               return;
> > +       }
> > +
> > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +       do {
> > +               if (lru_get_refs_flags(old_flags))
> > +                       break;
> > +               new_flags =3D old_flags;
> > +               lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
> > +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> > +}
>
> What is the actual purpose of this patch? Is it to skip
> cmpxchg() when the folio already has non-zero refs for
> better performance?

Right, as the name suggests, it's a faster helper, sacrificing some
recency accuracy (limited to LRU_REFS_REFERENCED, so it never touch
any counter). But the low bar for this helper is still equal to
mainline so I think it's fine at this point. I can add more commit
message or comment on this.
