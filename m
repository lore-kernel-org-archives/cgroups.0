Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795609974;
	b=QtqnZyltga2UGXSYamonwP57Y1P1OTJskF984mnEahtFraP7MYhhFiub864xwrPYyKFU
	 3tmaGyUYRdHh8egUzPye1adLVvjNAyeCcUWU7upfU5k5s2X1NgOipYlmDa+BMh1JjEYV3
	 k71fcmfUaYexhk84ETUzUOrIgGScaEF0LZuuMDok/GnaRP1q8Z0IIk+Lux4vgOU0nfrJl
	 kndkwxf7GQ85iRTtYDAppAJTRF0ennUhL6R81NsGmg4ByPx2d6KRJB+mnHZD5YkrB08Uh
	 CY3LJxcmfewGYhYOKXEVqJ8SVhDe8HrOR2V+oX5xUtX6Dcdywc9JbokoxFR1pedJC5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
	b=g1bUi45au1VFeOlrxNWrq4N59JvmIArQsp3qANpQIP38uTOB+lU5Y+DrA/S4w84VRYET
	 hLoqWbOfpSHh7E23viBo1qVDyb8Syl/qxeBCCfWA9BxxKHuWAz7ceTIIJdm55reuKB41S
	 wkssBMxJ9A3nIOSjgTrciCetzL5+ui7ORozs2K+9gITzEal7p+vMfjxJuqLZwgvA/iapf
	 PDe2Pie6X6Yls8rqG6ErlEGdvkUdCbVVtnCygr959A62gurQjTEsDr5CPETSl5aYN3tde
	 U6R4ppVwnZXvJOauQyf9c7LQTIQfQmivf2FcpZ7R4YtcsDfVUtgWMhLwEvVHshnntSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNDojyPo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11554606A337
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 12:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11554606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNDojyPo
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c5126505cb3so734061266b.0
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 04:32:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795609972; cv=none;
        d=google.com; s=arc-20260327;
        b=fi+jdcmtchFrL86MQ+DzFFCfqqC2FkxLv6c9eEUU1xorhIRnmWFELrxk5N617bKXxO
         AfHdDjPPElvlPjhwuuBZuKwXEajkjHvQ21dGJacVHE8Qn66ohj7Bvl9rWUt6o0MEvDC2
         gBND3L575DiLuvKmZxoxFYmIKNKLxdCpAM/TfNt4pDsg1u0c2Ge3QynWgE1p/OTtXbYo
         17xZ3AG3xQo6yQbQFUnb6A5F90hlysimksU7F+Ks0hpL1CsV3qGQUKYZN5w9DTLe1S7i
         hKl8zk7/iBqtelULz5r5MVfdRLwUjAMezIpULPybUso4A5aLWV4ETzU/2+K9+eW29HY6
         oJLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        fh=WKj250RJkJunQwrRL0AnbooaRV6rCvYsLO1pgadsxEI=;
        b=ntZzQeVOpUqwsIvrLo2NhEGafj9wTIh+V2QbYeD57IgHXoS9JrCxfd0h9GpAsRMQZp
         VnBFdWC/cDhFggg2N1wPPJLARx5NKsMgzsVtxTNVSTjSg1j39Z5YqYCuQziW375uWDj0
         rjsCiyCrmzm1DzziL2J5X5PhcbNQXUBVorfjSdzAiE8s+8LM6Kn6MFczo2clyiLs10b4
         ZXI1uRgX5AOAW87XD5tGrDJT9EIG60EJxjqzYTPgP4NGwMDRBVmgc2gGsBCxZkyDLmFG
         vM7veHydftx9uTSM5ZY4vXxG6AvwjQUWZpFNHK6A9v3yt38cj5zi1oCzbv5yyiS7E2s+
         vqcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795609972; x=1796214772; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        b=fNDojyPo/8kFotywY0pBugtFsBtIrL8oBHXEqtShmAqzfwpOvCc2wpHclgkSJGyWut
         SWlGJQ2S/UbzxhmZXe1s189zxMt0m+PbxqQ0AAx62KWxeitVGXp93dexLN57CLT5/K9o
         bVlOwpoItRcZOvlcxt8x26dpSiOO07UZPY9epYXfp5w0f7iwBIhlUWkyU9DfKmPosAlL
         LCK8Mg7zOvNrfd2GEFOhJGWQXPWe993XuRsfhekF+E7w7hT6hCoxJoQUChpZX5AJgFRq
         W1ffUwTkA7JId3MUa7tnZPxsi04YEuDs2cET87nwtDiNbYK7sJDMcXYMUZqb8zRo4fPG
         x/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795609972; x=1796214772;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        b=cZxpW/d2nOWYCM8u3Ulj2xuOrwPFkzetchJdQh9MlvJz6s2Jzig1+SUDyBuFYa5tEa
         Y6netxtIuYyth1WotiOx79KEAHsE3tHPPqS0f3dvvBHyO7S/cFzt4aZocpq0B9rm1M1T
         rzw+3io8vD5OObUwHRq3Y1cKGmDUMg/eXXXQY7aXyV/+lj8zqjMCwWtZxWjkjheZN5RH
         SbuIUPAQfC2VHfrQeDDj6Chvm8dR2tXF7Cy43NrZfoLLaQFycN96V2mbB7jtD8tFpZef
         yaGBA5GwYSKYUHZ1QrBViKYJRdXUL8XQdSzwOgtzs2CoNaa89aikNpjA/Sf2ySJbhe72
         JTwA==
X-Forwarded-Encrypted: i=1; AL+hErE9ypB0qsZPlK+yOHht+3cYc/VTs8pVAf4hp+ocw+MW4lfagkBAaeKGyWRK4P2ZRjPRlUivLXeC@vger.kernel.org
X-Gm-Message-State: APuU4Z+Hdi8hbMjSz7/q7kimOWYSjGSoGVNzQE9d9R2Uz2WBz992LDxL
	6qIfVKdVkv/DcVmfPN8I1fvvkNHDYTnYc5bcX/2E2dBYXFZzVL7YbkivTpjc7KoKzqsRMRFLsZc
	bMK4l6voGccLez+PDGMZFtroiJgCemJs=
X-Gm-Gg: AZFdTZca1yJd9gf2HFCbaq2+82R4Q84VRoFhc1Z4c5WJIN7fEGTWa/EHaDfwwSiBe8g
	+dbeaddPOa+68+LAlhskEu/7so8ABPIbS4xPeHqRa8l+gd3BN2wPmxUlSKknrhRGBcXdQ485Nd2
	FTOdB2Vqy9qJR9DzbbqbIoDptqV9GvmpYd7+pAcsq3qihepEttuYh664+NJnRs0pgHsVpvYeCc+
	1YJ6CB1xVBPTKFXhG1E0ZleuW0I2hSu6l4sSy5nXdJeKhVR9p1NglYDeEuI8D+XfP+9McuDedlL
	TOJuomi2zryXxDTHC0gEosUpHTZTQEkpLUKTe6OgWQDlYDA/ov+OtsmDJ5O+uwcxdqz5cOzEJdX
	mCKZjPAEij4ELZWD+0IGEfmftARhSbjXxPk3EBNorB1kWeVqSKsWMwk1MmbVpuWVcIFNSVw==
X-Received: by 2002:a17:907:7f91:b0:c50:c747:a4ce with SMTP id
 a640c23a62f3a-c513a4b083bmr1510819666b.4.1795609972048; Wed, 25 Nov 2026
 04:32:52 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com> <ce7c1974-2524-4d49-91f1-508acf2e33d8@kernel.org>
In-Reply-To: <ce7c1974-2524-4d49-91f1-508acf2e33d8@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 20:32:15 +0800
X-Gm-Features: Aa3M54pyChceg9ROmZV659afdcgKNDI5RisCi7hnLxG16VuSebxmazytrDQ-wFs
Message-ID: <CAMgjq7B7dsT4xOfcpnC8XdXZSPd0OOw1br64M+HA_3E+ZeZ-5A@mail.gmail.com>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a fast helper
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 6:14=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> > LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> > classical LRU as before. No counter update or promotion is needed,
> > nonzero MGLRU refs are left unchanged.
> >
> > The classical path is taken for a folio that is off the gen lists while
> > MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
> > turned off, a folio can still be on a gen list after the static key
> > flips, and setting PG_referenced there would bump its refs count.
> >
> > That check uses lru_get_gen_flags(), so move the helper out of the
> > CONFIG_LRU_GEN block, it is now built with the option off, where
> > LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
> > an int so the subtraction of the offset-by-one encoding cannot fold to
> > ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERRO=
R.
> >
> > This helper only aims to be fast, it exists so the gup fast path can
> > stay a fast path. The new helper doesn't account for refs above
> > LRU_REFS_REFERENCED but that's fine for now as GUP never used that
> > or anything similar for CLRU either.
> >
> > Convert the gup fast-path sites. No behavior change for classical LRU,
> > no regression for MGLRU either. Just prepare for the following changes
> > by providing a helper that follows the new convention.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 62 +++++++++++++++++++++++++++++++++++----=
--------
> >  mm/gup.c                  |  6 ++---
> >  2 files changed, 49 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index b15c3618a1f2..13c8b6bce349 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_lis=
t(const struct folio *folio)
> >       return lru;
> >  }
> >
> > +/**
> > + * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > + * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > + */
> > +static inline int lru_get_gen_flags(unsigned long flags)
> > +{
> > +     int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +     /* The gen is stored offset by one, so zero means off-list */
> > +     VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> > +     return gen - 1;
> > +}
> > +
> >  #ifdef CONFIG_LRU_GEN
> >
> >  static inline bool lru_gen_switching(void)
> > @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long=
 *flags, int gen)
> >       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> >  }
> >
> > -/**
> > - * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > - * @flags: folio flags
> > - *
> > - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > - * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > - */
> > -static inline int lru_get_gen_flags(unsigned long flags)
> > -{
> > -     int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > -
> > -     /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> > -     VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> > -     return gen;
> > -}
> > -
> >  static inline int folio_lru_gen(const struct folio *folio)
> >  {
> >       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> > @@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(struct lruvec=
 *lruvec, struct folio *folio,
> >  }
> >  #endif /* CONFIG_LRU_GEN */
> >
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
>
> It's unclear when this function should be used and why it should be used.
>
> For someone reading/writing GUP code it's completely unclear why this mag=
ic is
> required.

Right I think I can add the context here in commit message and kdoc,
MGLRU requires the user to avoid calling folio_set_referenced(), so
folio_set_referenced() callers should use folio_inc_lru_refs* instead,
and folio_inc_lru_refs_fast is a variant of that aim to be much
faster, avoiding RCU / CAS / Memcg Counter update.

CLRU still uses folio_set_referenced() though. We can get rid of
PG_referenced and helpers later to make it much cleaner (co-exist of
two LRU is making this looks ugly indeed, I we can fix this step by
step):
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-32-913619b014d9@tence=
nt.com/
