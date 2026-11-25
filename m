Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795612399;
	b=pE7x8/6DL5cWxJM3g27cK0MS0NmO+/81wvs1kdURFmMwCYyAHWYnzxBrOWI5LftuEwgs
	 L2O0Xy5y0tdjTsu5YRAaZPhG6bLAeKqq4Ej3uQlvnKRccVq4n4cIBX/Bfa2DGPTxRFPcl
	 eApihxq/mM2jVGcvxtVwUrUlig1IxmaeWsciq7xouedgcbY1O7MOKQ3SHUYdNbzCWdz1c
	 LNEZHW4kGihRYFPo9bVh9icNKS9+k2UWZ5IvIBCCUixHcsgnCNmQ4A6vqHnkBKbBsCyJM
	 GVF2M1K1vuWWX0dvAqvO7iCCN7jh6/wYrJ0jwPCwtmE1P97maqqciphrMUtOMDwsScg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795612399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
	b=DCgEplj5opIwgFUE9+oJFhhDZEO2DLPkXu3ozqRMC6b0Yq3rawqHUyEJvzuPkF+LBdp/
	 vanS6svWC2OnTNGJPZJUl57qwBOL4c+uu9nerkesTvrMw6e+RhqXcEHxyKuNclOSW1cJZ
	 XHsvGwMgFUy+otLetP1RP56/pU/+GcvS/gLNZ/LHqu+8MT46OF6y1o9n+2uqOGCUE/w56
	 90lXjmcWBy7oVybW9oaEAAGWgnzSMCagGHDJhH4L+vpZoLb21OrVN1rKHiPm3DNYScn+h
	 wvSgoF9M2JDFCufDdMLPBdoD1YveZ0S2RMxoymFXJelaD9D95JtbgHVkbNU2L8rKyOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0vv5HDD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECBA606A326
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 13:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ECBA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0vv5HDD
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5118deebcfso857381166b.1
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 05:13:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795612397; cv=none;
        d=google.com; s=arc-20260327;
        b=L2D49xhneZFaqfBslpVC1aY677PbtiJAfO+6Elfkcs5vPJsiWzWnxGYnk38OY5me9C
         M3iRdPsxObixel1ywY+YMJFEbXsXum8yYCnTcdOl14dWauYUf5J25bq1leB46hgs2Jz0
         zIgYwidXWOefHj4b+TT81KsLZxr7Y8Ii6mvIZGf/xTK4IfnQZ84THFY7K7uUQf9lPDAM
         c0SfH9nNhUq59I5RRbCEQ4CMWHsPVGaHQGrsIGErHce6iy3opJNvKb3TdVlNWKjRaO3t
         zyB4sEuPy6uxezW4+qNv0rtY13990FWoyQe/Hu8aleBcseG1gusET51HqWDBU34ApwBo
         u31A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        fh=h8neeJcBFCKsZTOzkdfBJALMF9kPHUBsgI3QB2KFHIQ=;
        b=soCAciSivglQ1cp+EidxIxi57fAy4vUtj0pK0vj3/wHX6IkWDK7horIHdZ6mrVX1LG
         /tmpT2PDb13haA7rzVKqRBnqDW0rj0Tim9hVGXqciXs3X2N1W9/OFbCG2HH7DeiLDqUS
         PpwoxxeTxhvu8njmKH+EoqsMOHesHkehPOwWr5RcPV1RoKCDhg9896lt8nU0Xfu9nquD
         4EdMcrez7D4wkhhO287r9s7yBnvtRGmM9QcZfX4CnRL0VioPbPzf0ukgcKjk2rPdbhSf
         gPSX3MVP3YXFTey5+c6BPAixcaS+vJSF+03u3Mhq7UVdTODJ6f+aRufM4rO3Uk1IbC2t
         I/cQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795612397; x=1796217197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        b=n0vv5HDDhQGJx2A3SZ9UrU+9j+SJMLmyzK7GRIhTgCeVF3W9mHcsWgDDEOIM+SSb5J
         d0zlmJEZMWQJbBbMP7QULVebH35itoKoCjJ0eHNerucf5DgJiMaidCg5rvo9SmOde1il
         E1HZ42khDgyKjqkNbwHk/IYMCc3VvVXmJ24IK1eSUsUsq5Sz+0xxCOasIX+zmAD51LsO
         21MDtIAT4wQCBGMbhKocFMemYjqSPdS11kFF/qU3oIH7R2e80W1dhPd2uTzfbpJhIIsu
         6/vX6CPqvL2aDs2Z/rHJe9uhXBRc0EGpUV0CAKNi4D+AQsll6t8CBem4My/QX30ws8qS
         seuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795612397; x=1796217197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Yz7JNlPDDcs8XZFhzYAPoSiu941gv9oYg8JZ/90iT4=;
        b=EK/Pga/n9KdrUEze23oJa49p9rmpZpllAhmSNCIyhqkILCgbZnPLikIWHbx+v0kSHJ
         xTh4hrKTc4d5h3jsczfsKuHFk59DdN/K1oni5lDZXP+ub4wULr7Sl/8hUYtWxgLCNYqn
         VmNwu/s3+Sq4hhqM9MoRusncCTzsSu2Ha0ns1T+UAOajzw86JlqiL/ZxLlc33vHVBp2b
         f993bTGAuOkKCPByloIIAIVbxvLUzpL9p/TOIcYpp+opaiA2avBEl7Z/nLT8Cg8WUk6E
         /X4rslDQYb/Y/Q/+Y7MWu68fgU4p1LDAF0TQgf/02BwW60heiyG+W+nr4xkTSY/Ii1tG
         N9KA==
X-Forwarded-Encrypted: i=1; AL+hErFx/p0OU5RBtvRsL1kfjgiStsNmi26TPEEVzqWZx7CSg51rv2kHh5KgJQjd69GJbZsBQnz61E+b@vger.kernel.org
X-Gm-Message-State: APuU4Z+s87wxfen0rG7rOCcs+tsIbs7myggbx8YvUc/MD+8mY1jVtlX/
	8EVaNbtY1Jls7FReEk6hmnu8oZV3xBYSby2XtzD5p7GC4KYRf6zWCoHorompiixnmfKaZoyhBOD
	PyEIa09LuS599NqX6JxEYqLatTSh4Lhc=
X-Gm-Gg: AZFdTZcRM7LJg8lsob8PLa9pUbqHM7vPbETx5wuvg+0d26T9qYS50shXuDm/8aozvph
	2CkcUUPo1oWR83ampBCPh9Uc8ouXvNL8sdHBJ1Mz4ZSn9YjwvDgX9jVIVOK7+gJVlBtrcJHt31M
	fxuaTfhHrsCESIOcKodknHpykCPOQDRQH/74ioyjWPZmdGRyiXcoYeCUWkOOiRad8Cmt9ZBkv2Q
	dZDAX05k2EGLGBo9Zbz1c9AJC/hHae11H1rTSoy9xZOQolxm91Iop5ETY4+5Kl4m9FPqwarGIzi
	nKiteElKG5GUe70uPI+/uXQvhpnF/Ow+VV+IZYSsqqU2QKvOGPaTW9GX7FRHhmJC8XxfcxA/PbR
	MMB1rr5iHofen5x9FS/U3xdknB42s9OQjIXATy6oA6l1FkbelTOJ/CmBCpbOy7a7MKRB5vQ==
X-Received: by 2002:a17:907:9693:b0:c4c:ddd1:d006 with SMTP id
 a640c23a62f3a-c513ab47f40mr1378964566b.38.1795612396826; Wed, 25 Nov 2026
 05:13:16 -0800 (PST)
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
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com> <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
In-Reply-To: <fc51ad85-16f7-41fb-8eb3-2b8ee595e711@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 21:12:40 +0800
X-Gm-Features: Aa3M54rLCFPdJCUVsWAcKF2l0FhpWm6CiFAaLjU-bCfz_TzbQSOhJaNF1aUKI_Q
Message-ID: <CAMgjq7D-EFYsivqq1Z4c60ZMh0pBU2ofgfqVaqp_vbPG8wbSiA@mail.gmail.com>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
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

On Wed, Nov 25, 2026 at 6:09=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only checks and sets the folio's referenced flag, which is=
n't
> > enough since folio flag updates on access have their own rules. Ordinar=
y
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
> >
> > So first just use the right helper here to be more consistent. Keep
> > accounting the young PTE as a cache access, sticking to the current
> > behavior.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 75e8641bf9ff..fa9f6d21e786 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_are=
a_struct *vma, pud_t *pud,
> >
> >       if (!folio_test_dirty(folio) && pud_dirty(old_pud))
> >               folio_mark_dirty(folio);
> > -     if (!folio_test_referenced(folio) && pud_young(old_pud))
> > -             folio_set_referenced(folio);
> > +     if (pud_young(old_pud) && vma_has_recency(vma))
> > +             folio_mark_accessed(folio);
>
> Can we just have a helper that abstracts that? We pass in vma, folio and =
young
> state and it takes care of things?

I think we can have a folio_mark_accessed_vma(), and so it will be:

+     if (pud_young(old_pud))
+             folio_mark_accessed_vma(folio, vma);

Also converts a few other callsites too, also avoid touching too many
other folio_mark_accessed callers, there are a lot of them. We can
audit and see if folio_mark_accessed can benefit more by passing vma
from more places later.
