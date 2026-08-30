Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE8125F988
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 18:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788114893; cv=none; b=gRrTAS6J49aWLbgeBsN/7U7VoE75+rUK7HNRGwVt5o2ft/QEwU8BUIZCyiNpf48ztkFcyVBCkUYqIMPr3ippQFEKmAAkbzwR3yPEilgFdbfQx+P8ZTfJBaROrjLUm+eOw+sXRbjzcb8FuW+7r0qyWiwPHM476sT1mKxb1q9mkTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788114893; c=relaxed/simple;
	bh=5/5s81NWJ47FiUJFRDO+SzIEGSJvrgMrmIrqhox4ohU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttEmWdGHtNR8PJjueGHV6Ue/sVre2ATaksGGEG/STmWL9NERLNDZFuvg7AOcIh8R0xF2kMM8ni7uCvnsWVhrYkrHWP005ULslJwZz2h6GZvHpNOthyBOkWSxmhtQr+pfNfBTDUYPb/DHQcpBm+H5v5xAVUdpociSeiP8Gw1oKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UyhoGSKB; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UyhoGSKB"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-382ef647e20so2681725a91.1
        for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 11:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788114891; x=1788719691; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G0B4wZ3fn9SdpG81JGH8ihBKW0Pv8b+m2YhlqJODgpk=;
        b=UyhoGSKBptxU9+2IP6vXABW7+bdfmRONs2ktvbLzUglaXAxQp4mXhOVa9pcOKmvYys
         uKO5FG5EVo3xWgYo/EMLk6jXbm6jSxjCxIAw2TrXAf67dk8esomf7r002KJCMeMmStrg
         YhsgCGSnvuVyBeV0Ob24SbEEnTfIej9TvNFS+OkrpzTOtkc74Aj+1tnNSoIu8hCv4e1C
         VdDNSJ/CG0cL/TNshjK6uz+1KzFwrUbWCfSAVZYURuqO3QeKsNH0NA/tQzcziuxQMeGn
         cCR/r8HtRO9UN4Yt+ci+0sV7Ict99FiK2MMI6kV9kho8ZFwkUSzLonyMHTIN5tau+UNl
         8xWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788114891; x=1788719691;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G0B4wZ3fn9SdpG81JGH8ihBKW0Pv8b+m2YhlqJODgpk=;
        b=UWUx+UZlnJTKlZUX2fs6XNoypqWgCGWHkTvW8U+WR+NmUeTiTmPK0CPVacSEBqeREh
         LwTCsxhKNc+379NMBmWZXPflgqMzNJzjUGpYaAYSBs/uaPFMEvqSfGCweNr35r5GyNEz
         lPJDmb3an2DC1YLX3rN5MLf55yAfG5Pa35xegdAaAIPphI6z57cf6Sa7NB9ZSUQFoqQr
         NpVyEcoYqBx6Wiv8P4LihM0L+OkskZdgWzfG9MXxAWo1g8RXm/q73D0rQo7GlczjsuqW
         XSYeDxgNbv5lzXjr4eoK4k9zvOqifZauRHPOaS251lD+TDIjMlQlGwk/mrEsS9gHJEzl
         6JLw==
X-Forwarded-Encrypted: i=1; AKwUvBw6EvkI0eIWFwCTwZkrFRGX1iK/x5Fout9YvxummAlYOtloxfTIQWz2z4VQ+r7/VW7KuTPYA2fc@vger.kernel.org
X-Gm-Message-State: AFuF++lSOxdkDkgrgEe40QVa6vXIRLawGAoSnhs5ACu6/bVy0ucJ5cYk
	ftDyc2b60gnZTqrAQSCwMVYjEWeJccSIXRsif/dkHBrSLWBRxoIXPdSJ
X-Gm-Gg: AYBFou1GV0mvC0kyYHk888p4jowff3886VyYj8To2UBq+lG4f1W0oqXuX3ZbyKkSMXc
	x9PTeeQl/IMKdcJeh8wmgDy3x8WoVQm/ucv6aLuNXQPTerXPJ5jV92P0LUO0mvfbcyxVvf+vg9X
	Wm3sQcUfy78l4UwesQlLsb2oZWWcivSd3aJRxRXL4mWrrO/ferlHXriWYgXxotaZ9Cv7JDidPGl
	95ayau9uvEx9zIzC7W2e+g4Ac4mfOv/babuY3WAxzZ2RCCw+inR09NZ1YzNlxrQ3K/y6NCqGwVi
	7HAIbS4hWUpGuticoLfK7FqhzHkq+72K9Re0obMzVFj0ZlvtSzadgbrNcXV0JTGrXZ25hQJ5mZn
	e5jlp44Ts+phiFXXS7bT/Slb6mkZqM+J1KVCIlzNeYjh8/8N3SLBEDHUu3CWirqGZ/5Q+8CvMXT
	q47SmEvIgcYBejaK4WTIYxosBPHooUPu1kfWIOqcupjAk3ishWhGpOo7Y/z7Lkf6QQZTeKTn4SA
	eFS4q1stiuD865Y4YWg4GFkuA==
X-Received: by 2002:a17:90a:4ca6:b0:398:bd66:35f5 with SMTP id 98e67ed59e1d1-398bd66372fmr8496745a91.25.1788114890953;
        Sun, 30 Aug 2026 11:34:50 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a2d45bd0sm3248973a91.0.2026.08.30.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 11:34:50 -0700 (PDT)
Date: Mon, 31 Aug 2026 02:34:41 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
Message-ID: <apR2LxjPMbripExL@KASONG-MC4>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
 <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>

On Sat, Aug 29, 2026 at 03:47:42PM +0800, Kairui Song wrote:
> On Sat, Aug 29, 2026 at 12:22 PM Barry Song <baohua@kernel.org> wrote:
> >
> > On Wed, Aug 26, 2026 at 1:53 AM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > > adjusting a folio's refs and generation info, making the code easier
> > > to debug and understand.
> > >
> > > No functional change is intended: some combined atomic operations are
> > > split into two, which only creates harmless transient states. There is
> > > no measurable performance impact, and some paths even look slightly
> > > better in the generated assembly.
> >
> > Hi Kairui,
> >
> > I like your idea. Overall, it looks good to me. With some cleanup,
> > we might have the following:
> >
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
> > >  include/linux/mmzone.h    |  1 +
> > >  mm/folio.c                | 19 +++++++-----
> > >  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> > >  4 files changed, 114 insertions(+), 43 deletions(-)
> > >
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index 621c8653d8f7..edfaf2661812 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
> > >         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> > >  }
> > >
> > > -static inline int folio_lru_refs(const struct folio *folio)
> > > +/**
> > > + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> > > + * @flags: folio flags
> > > + *
> > > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> > > + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> > > + */
> > > +static inline int lru_gen_from_flags(unsigned long flags)
> > > +{
> > > +       int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > > +
> > > +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > > +       gen -= 1;
> > > +       VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> >
> > Since `gen` is an `int`, it seems a bit odd to have
> > `gen != -1 && gen >= MAX_NR_GENS` combined here.
> >
> > Do you actually mean the following instead?
> >
> > VM_WARN_ON_ONCE(gen < -1 || gen >= MAX_NR_GENS);
> 
> Thanks for the review!
> 
> Yeah, thats's a better sanity check, will udpate it.

Hi Barry

After second though, I now remember why I did this in the first place.
And there is already many following checks in upstream:

VM_WARN_ON_ONCE(new_gen != -1 && new_gen >= MAX_NR_GENS);
VM_WARN_ON_ONCE(old_gen != -1 && new_gen >= MAX_NR_GENS);

And gen is signed everything since it has a -1 special value.

The reason is MAX_NR_GENS is unsigned, so a signed -1 will
look larger and trigger false warning on it.

Or we will have to have something like:
VM_WARN_ON_ONCE(gen < -1 || gen >= (int)MAX_NR_GENS)

I prefer to keep it with the existing style, with proper
comment, further sanity check cleanup later. Right now the
usage of MAX_NR_GENS is limited so I think we are fine.

In fact I'm think we can get rid of the -1 by combining with
PG_lru, or use a formal special flag. Which can be done later.
