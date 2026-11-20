Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795191645;
	b=DEYlTywl1lgABYymwK/wVncadgm7WoydDQ0TBU3Lp3n7fOnY8a9lXOBgRI1CxuPnKba3
	 8pCwpiEF26cQMrzUU1VD+OLPpFlPeO5GMxTAg4g2W8PTAv8fNu/k94LPvsfO2xsIeUzFF
	 bLDbueJ4ZK145sHSJTsWWvNKzMyBgujKdG3GWVzlEvxbf107R3Iqnm98ZeeZOFW3RHQMw
	 COiyBGihuLHxzWG8hUeXc55fhI1gexXVSIEMjumDZ9pk3UF7e889kLsA6crlwZaJyR9fG
	 Wu1/0Jc+LyW1AcljkjId+yg2S21ZTEz0FQMwhqv0aRsmFxCmqoxkltbVCuVGNYiz6QQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
	b=we5pCYN1Zn/B3+4utaUz/WjkgQEAtbNGtklbRhV1sYIMD7FeKcuZEs4ADat0euzOu8Hr
	 +Vkdncxli6S1swUdMC7EHo9darS/NR+BXanjQfMaartGlTh/5fkBFQdTf4uo4fefQ8oT9
	 yiB+UTJ2KLECAOqh67sDEdlbAgeDL9PUPCVqDg/8s5SazJyt0tTpD1m3UkICVGD4Afjm9
	 0pjF+ful+/06tNS8muB0Gv7zO62rjN83NEFKNNX86o1HLq4xhr1XKicvXzmechjKIboM/
	 lktLyt1VSEIeNfq9WvgQpphc4XA3B+XOtmmpe8BK5tqETUMRkOecZPF/6G8Ish57ycA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xZA5Lm80;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B516E606A32C
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 16:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B516E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xZA5Lm80
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so17448185e9.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 08:20:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191643; cv=none;
        d=google.com; s=arc-20260327;
        b=CeyFSXiZwBk9kdqb9MJO0AMAHreDwaDFqT7QAwYXUTTBNOVSLAVswXB/QZJMx78zNC
         nCgx6sypxkmtfoYAuxxKLOCJtWFzKZudgQ8qfj624juBu+zges8XScdKYokA6Lu45se2
         QhpVPRQwusWrOMCdw7uhBezRSCffEpJmclpVVOj63q1QNr2kOTfRMnxoN97stKgS5dAU
         Ckd88tph+LnV/Ym5kT7euDVxXFTKTdXBCjLywLnj/zChNM8+nziMkL7GfPGeabPRRqPr
         6Ij+MJu/J94T4wkDAQAxPjxqGKVo4P92bWRxtbpF+c4yAYIljkAKJ+r3EAoag9C1nqxS
         /eaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        fh=i4FBvjr8LeHqDsyJAUJcanwP7JEuHHk7HqVckt9b84w=;
        b=Ac2B4/N0yvP+u5a3mqThAzLd10ZHvJTQsxNENnUM16OHQsL6FlrPk2KroMFEjFyc8g
         /7eWmhl5GpXf5QrTdYm4uyTiQpX/RN2h8w0muyIPJWa8lPY1gAps1EzyUX6DRqnrUwsp
         hshAv2Os7cyAPWFlpXGB4OCInVorDIjYa31vang5qsS0fB0YCa/JMtLbrOT73Rvh6vLy
         wbd/evR3LriFVDaAWw0HwKta6MZPoME6D/iTbtz8sNFB7MHGaoHjeMYH82bXG3QpIGYO
         taKvL/WqSqzDuVdv1YsU5QQTsvy6G45VyGAHanNhENU1LOuaqHWq7EPxRwRqbgHnlbOD
         yNpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191643; x=1795796443; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        b=xZA5Lm80+LmwnUw/ns35xz13xjfstKAn+btE7x5CEnUfuPMX9rtmTlrF1HCNHn3wTA
         PBf7UOKGidfFBVxjBDPe/Ylm1BLDpT69s8c3/6YvhqNPnvEZ4Z4t8jq5XHgiSbtXcf3G
         ljZcejKzQgNKLnk/3S4a7Mgu0GlyteWhwqPwUQpQTnDOZiaINidP3xqmE4vxE8s2Opds
         YFLlC0yro7uc1n+fM+UlN5PrtKMKNzD5PEAZYSfXMgDU/ub5SI9IK5H2rT4SRp6LQ736
         0vD9WMMa213cajcUFtNGIDK0Qhn6c7Mko4FoV8RHP7DouH34MmkI1r3kWdVXK2qW2Ulc
         m8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191643; x=1795796443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        b=if9x85+FkWXXecAjz/PlucjILuzBPecyVHSdoiM6wWGVWCNwKgxpw7zfTvzzDzug8+
         vAm+mh2QQbn2n8VhAKK6p8QJE0J5TKCxF8eakOL3ImHR5aDAo5QuumAb5HpM96Q0CNt3
         pYYcIA5n/+WZpQJi3R85ZlDTfZ+ecMaoRbqc/fjjCMYz79pxFiCueBCNZM5RaIyol50V
         mlPG0JJZ3F2WC60gLmrOai3Juu4BFucV3TcRFe0JxU8iI/ktyWSyrGxo89QFWxxjGKU9
         UpB0ux6H7lWJYwAbS29HD8g0US4c7Q+H5g2AXxR3g+A4DlmbwKD6BCDwczFhtKHAgmj9
         QZuA==
X-Forwarded-Encrypted: i=1; AL+hErHYc72+aSnoejTxHu+QVRl/fu2wHS5c+aHNpsbWceSj3OufTKdaCLsyF8KGghi1c72h3QwxbIiK@vger.kernel.org
X-Gm-Message-State: APuU4Z8+zSL+8kbjH1XxO3b8s5LQHyeXTb2wTnWvNZyzOIBFxTIti0qG
	sYa73nTj94pQ3nb1dMM4E/nJ5vwAXpxW4GYbrw20EnA41BxH82o4rTQB5/Rfih94rQCPLdxP5gM
	Eo3b1olcYeOpJFuaMQOhiaPvaGCb9oM0=
X-Gm-Gg: AYBFou1TQgoWezbBfjwSEH+4XvpOyU0JES4gTV1A+8oSf823MgcsCRedpYvzIfGdME5
	7UqWDuZpEH8MIfRV1JbqN6MU0dVo6nNy7+/Duq2vs9xGiQpY7WXHKOHGWT99r3oeYo1SnONrNTM
	lWlVI5Kwewemk+moh6iiDAfLvtQ1TKTXaRaYqFrQgXG4Pz4kNAJytxl3DyamqZHoJU4FNca2qDN
	iuSwQA+diNWi3eWljXzP6WtgulYAhRMSF0FQ1m2w2LzqIq9pEriDOYQ727RZ8yvx1UiWx/Yckcf
	RZ7RqL/3ZEHoVLfp3lCYUpHVzTEo7UkAtosecYIpYOnEfXIwV/2y9X6+57T4yt5sG/MSo2X3hPu
	g5luJWZdv1HhZkEz2O1udnQPeX4slkfKUFsOB1qyxR2j6UOSMRBkBw8mf4pjunccfP5qhONNh9Q
	hcWUBpePiY+8zricpx3ow=
X-Received: by 2002:a05:600c:37c6:b0:4a1:88df:8a2a with SMTP id
 5b1f17b1804b1-4bb88812a84mr79631575e9.13.1795191642448; Fri, 20 Nov 2026
 08:20:42 -0800 (PST)
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
 <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
In-Reply-To: <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 21 Nov 2026 00:20:30 +0800
X-Gm-Features: Aa3M54pZxa4hRHw0Lgws3rEOfSeNigcJ3vp4dRWPeqYAT3KKSQ-I1gkfiyUitiM
Message-ID: <CAN_Opa93a7Z0wmPxLGFeKF+BssvZeioFHU6tcnBioXTQKWKP-g@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Kairui Song <ryncsn@gmail.com>
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

On Fri, Nov 20, 2026 at 5:36=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 20, 2026 at 4:09=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com>=
 wrote:
> > > +/**
> > > + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promo=
te it.
> > > + * @folio: The folio being accessed.
> > > + * @flags: The type of ref: FD access, or mapped access optionally w=
ith
> > > + * executable access.
> > > + *
> > > + * Used by both cache access (flags =3D=3D 0) and page table access =
(flags =3D=3D
> > > + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> > > + * Context: The caller must keep the folio alive by a reference or t=
he page
> > > + * table lock of a mapped folio.
> > > + */
> > > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > +{
> > > +       int max_gen;
> > > +       int type, refs, old_gen, gen;
> > > +       unsigned long new_flags, old_flags, max_seq;
> > > +       struct lru_gen_folio *lrugen;
> > > +       struct lruvec *lruvec =3D NULL;
> > > +
> > > +       type =3D folio_is_file_lru(folio);
> > > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > > +       do {
> > > +               new_flags =3D old_flags;
> > > +               old_gen =3D lru_get_gen_flags(old_flags);
> > > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > > +               gen =3D old_gen;
> > > +               if (old_gen < 0)
> > > +                       goto out;
> > > +               /*
> > > +                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > +                * doing lazy promotion so in theory we don't need th=
is,
> > > +                * but for now, concurrent aging would still corrupt =
the
> > > +                * size counters.  This is a temporary limitation and
> > > +                * will be lifted very soon, so the lock here is not =
a
> > > +                * performance concern.
> > > +                */
> > > +               if (!lruvec) {
> > > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lrugen =3D &lruvec->lrugen;
> > >                 }
> >
> > Can we do the lookup under RCU and preserve IRQ state here?
> > filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
> > lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
> > still holds gpc->lock.
>
> Thanks for the careful review!
>
> We can, but not in this commit, and in a later patch we did convert to
> RCU convention, so this lock is just an intermediate state because it
> may race with aging hence race with the active / inactive number
> update. In a later commit we changed how inactive/active is reported
> for MGLRU so this is no longer needed. We are basically lockless after
> this whole series (I mean, RCU lock only).
>
> Perhaps I should add a TODO in the comment here so reviewers won't got co=
nfused.

Thanks, Kairui. Keeping the temporary lock for the accounting
makes sense to me.

Kunwu
