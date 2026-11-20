Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795167374;
	b=DgqXPmgFEn1AqsBpp4wJSwSgatP9sKHA6NARsHj3/k4Yc7cx4KvMHchSzIipU4BZi6EH
	 X+ZNeS2jQsfqQge5Ugp+9WNfx+PmgOZEmfY9AOtnNhNJ1ljEmpfVx2eP+OSGVw1FNkAyP
	 FTMrfJVzAvrBXuBD4Wun8sezq5x8r2BCC3EXqnEL1mEGD6rswa3ACGRxfvYXVxzuZ5tZa
	 6DDcFuGDmQNBw1VUdJzlWg/fe5bPhKKbcU3H2ZB9p2U6z/Xjwik3mZ3H9yqHheOi+XSO1
	 JDLxFIKompYI/lKjQPGHEBugQDghzByaF2BX+73LOU9o8woNAXJ0Pt+9TXd0tKiBfmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
	b=Y5GVvChbY+TIlRIWyFr7dwW5dxRExsvIW3fuV7eHAzMBZuBJr25jm1nFd+oc/5IOhoW8
	 axTWXoJgaSFrVgj/L6D4KdXfygmiKubQP2YEz2LCWlrwVKPQVVFH1uv2VuUMb20sbnagb
	 33vBM3I+iHaXcsngu//Xgy//Ms00CWP6UHnlZcWGJXKpCLbwwwFctR0yaB1ArN8IjoBRV
	 0IKenqNsPgkwBON4rAa/ohwaFagsDPkvtWsejOFNU9sDxuXFp+s/lN0D/GjoKHqGB7/XU
	 ms3rbqd3jg5Ws3vjQ4+Zm8COXHLkSVWaTrDOshCk3USLU2acmSQ+Q5e4HcvoKQ7XjNw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VM3KnwM6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848DC606A330
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 09:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 848DC606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VM3KnwM6
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50aaad19fbso81395766b.0
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 01:36:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167373; cv=none;
        d=google.com; s=arc-20260327;
        b=CxnskpwKJCXrVrZ1di9UGQLCXmgBo3S8R0LBHbFazlBEoxT8CYfKybjIiAcPFPH5bO
         XgdHkyf4RAwdQEI5Lf1PsUtOE8em2zQ7rlWXa1TrufFOA4S+Easutjzu9oacPc6MKqVM
         Ue8nCef8u/0Imm+EXSFf99NqpBf8OemocEGRtmYqixRv7zuiVyoJ3bzcyt9Izo2T9MuZ
         YFGchno34RovzSgz4Jy5K89mRSg3ifJlZ7zrtcI8u/SD6WLvGy4dK+YeRGaAdkGlqRI2
         VXgnPQ1xDjtrdwUamWT3T0hFKouJI9VGW1oBJJAvyjaXlm+hrj2JhhxP5sxc7PvILWZU
         9Z3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        fh=Ifd2YZFDetPO5qn6OppUucP8w4yjGCaBNYFZACqGry8=;
        b=qzng6BjtZr77kfjOBda6/36/AmmCuEA2AWmzaKguyzOPzd2UntgRX8siqmaBNM0kmE
         rOn7M10kN950y0ot5GPC2hCDtpN3VPklpZoO7tkg7nScA443gTuOiwIL7eb1Zm/MB5NG
         asHQVjklggXblMKJkb5/Ok5jA0wDIEiG/7CY4qlEy3eI3bAZ5Ia72F2PRxhrhWKA0C4U
         FMg1dk89gPQ6SpO40RBXpk6mb7IuA8Z+0PnXvPehGMgr+T6CxbqzGJTZTe7CynK86liC
         dBFz2uk+4GizclJQJxhrh+CpFbBnJ2Wl2qYiFDazgKOe+XbZgbgNE9YxKdfbpcArtgEK
         7tgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167373; x=1795772173; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        b=VM3KnwM6AUN5/1TidF8zbilAlicnuueyvE/LyvJfaeJnvgFr02HNKww70Tz7vQkqnU
         5/YutVl7o0kzxFtaWIvGqh5W1k2zCFmGIQywVNhUs7eLfPrtJL+ppOog6GHQZfR9XM9E
         IFNP+LomdvxpZiH5uYLNiocZvMHn2hze68Dj3eSvEEB7xiSCWMTmNnwOPri3jto7VtjB
         6r20b2CR/FQkYRv266zNBuPEsQb1xepdGE5U1sUPZZZjwtbrcvT2iCgLiswv+QWHKxst
         FDEM4juBe4DJna3J3dCNxtVevCcAJyssXTziVmF4k4Q6ZW7zc/1Drcq6ZP2k3K2PNNBd
         /Pdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167373; x=1795772173;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        b=rfU37ns7C219e8pdYnPiaHCnw3GdqJAzAfG5dFfbZ/B2dBhOsmL3OHZ5RNXZ6De8ZY
         FQcdiubBPLk6xkOQFJA4yCnTsL9h2A/uS2YTbFx4AQC/05XgpS28vjbT1J9unueao92O
         mJ+1HHAS1ikMYqjea1deLKUT/wO2vFTEQHk+o5V1UGTWc5zqtrCzDP7hPd5mWeTuGGmG
         GpeBmDNn7OJWuPtlQ5WjNKZA9FrbfoIxo4DUttE1kUDewTPe3jKJNSnz7dMGWgAorc8F
         jHdPjcbxNTouwEWTH2U5gJmU/9ROVIIsEld/RMWrdvl1P4kgDk3xEXXKNT4N2OblegPM
         XLsw==
X-Forwarded-Encrypted: i=1; AL+hErG5Ti2dnfNSNk6i5YXWaW+HJhcxKXnuvljzz5OKERvK8a7y8UmPomdX19RZImxMxlt9nnYM2IkM@vger.kernel.org
X-Gm-Message-State: APuU4Z/PnsgESwQp3eChAmE+pyhBerW5ooRL2azjkVrPqcDYkQA/ntg/
	io8A7tBkZcQg5qh9Egz5zepSmRmrGpEMRcvvWOLRwq+cGjwZpPazg/qyyLlQmsn4MQ1W7wA9u4b
	/gDLG+/d88pZloPjuoM40YyNZH3DyQIo=
X-Gm-Gg: AYBFou0p06JzGnBFDJKmHur/RBoxqIYeO0rlxJJJZmhLKhkaNo+1qaHFD5jLrdCBn17
	S5d0inSpAuKOKlphj06seasYHTDw08YQvWNrqEy671yAA0n0s/ShnijFxWtGWEdC/nGdgeKds1F
	pooeYQOtblWNArMv7nM4ksb7KtaGOrzo0q7DmyedhikunrqGmyyFlQBZaPaeFUojcs+69spWOM+
	DpaCu2N8YOH22cJyMlGptme8pE17dTk/FJMnWOOhps+1VlBtKoAwVJfcbK2o91zipQSBzUiK4oi
	yrKm3YL5WBLUrBoWX2iblEHMbp/DbFec3j50wGIgqlfN7aL0yFrppooBvmpWGrB+L0d0eyGiN4w
	RaHK8O34+7u/rB6nvxxUZzldFGmlJRXerrvhlAOi+Fkm4vwvuexAOSdQ=
X-Received: by 2002:a17:907:6c17:b0:c51:3cb6:5b11 with SMTP id
 a640c23a62f3a-c513cb65d73mr206830066b.49.1795167372628; Fri, 20 Nov 2026
 01:36:12 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com> <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
In-Reply-To: <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 17:35:35 +0800
X-Gm-Features: Aa3M54pbohOCQbswSkwv-YDHDqEuETdr2HZyOy_eh_9wY3LvfDu8zJdBWDbyUx8
Message-ID: <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: KunWu Chan <kunwu.chan@gmail.com>
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
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 4:09=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
> > +/**
> > + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promote=
 it.
> > + * @folio: The folio being accessed.
> > + * @flags: The type of ref: FD access, or mapped access optionally wit=
h
> > + * executable access.
> > + *
> > + * Used by both cache access (flags =3D=3D 0) and page table access (f=
lags =3D=3D
> > + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> > + * Context: The caller must keep the folio alive by a reference or the=
 page
> > + * table lock of a mapped folio.
> > + */
> > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > +{
> > +       int max_gen;
> > +       int type, refs, old_gen, gen;
> > +       unsigned long new_flags, old_flags, max_seq;
> > +       struct lru_gen_folio *lrugen;
> > +       struct lruvec *lruvec =3D NULL;
> > +
> > +       type =3D folio_is_file_lru(folio);
> > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +       do {
> > +               new_flags =3D old_flags;
> > +               old_gen =3D lru_get_gen_flags(old_flags);
> > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > +               gen =3D old_gen;
> > +               if (old_gen < 0)
> > +                       goto out;
> > +               /*
> > +                * Lock the lruvec if the folio is on-list. We are alre=
ady
> > +                * doing lazy promotion so in theory we don't need this=
,
> > +                * but for now, concurrent aging would still corrupt th=
e
> > +                * size counters.  This is a temporary limitation and
> > +                * will be lifted very soon, so the lock here is not a
> > +                * performance concern.
> > +                */
> > +               if (!lruvec) {
> > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(fo=
lio));
> > +                       lrugen =3D &lruvec->lrugen;
> >                 }
>
> Can we do the lookup under RCU and preserve IRQ state here?
> filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
> lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
> still holds gpc->lock.

Thanks for the careful review!

We can, but not in this commit, and in a later patch we did convert to
RCU convention, so this lock is just an intermediate state because it
may race with aging hence race with the active / inactive number
update. In a later commit we changed how inactive/active is reported
for MGLRU so this is no longer needed. We are basically lockless after
this whole series (I mean, RCU lock only).

Perhaps I should add a TODO in the comment here so reviewers won't got conf=
used.
