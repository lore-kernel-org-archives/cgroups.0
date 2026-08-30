Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754B825A321
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788110361; cv=none; b=XjYS/REnn6/gPzfcdU8gpvOHQE5SbcgCVDBjHF9oxUwaLuYAcuLrGZ+LNqoZCbKBPIMdYE3VCMUivmrpmvSKGX2PjrqCmH7gz35FzNnJo0WPyfoBa/j6VJHSQPdzId4JzmzcKlvaiFylcwBVxpZkPPn+/5O2Dk+mbtyAncUFquQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788110361; c=relaxed/simple;
	bh=xph1ZbpAuVGBQ9BGgKp2r4tB6wXDf4tOCzRDoW0QHA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucDgMwRFx2nNBc+szZJHui9puFdf/tPXNshEluw3zzb8NaAGhv3X/wOE2Moan/IXq+h8j9lfMO+EIOCW2JLBAG+sd87ZjECSuuMVLAjprv557ZlCi8axV8PFUWZTJgPsWRC+DY8UQstdPYmF2TouOkPH6AiClkj6w693u31TeOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rmvnw6sS; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rmvnw6sS"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1c9879395so2025954a12.1
        for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 10:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788110360; x=1788715160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y2hq6QuB9tMpONgBvXPbELPoG76SYlrSEl+e1j2HRJk=;
        b=rmvnw6sS3CWG9WYTJu9J/0CSqiaY9+htmnU3Ew4kIPBYypubJMojH6hkyw/xCFxmoH
         GwJjQRCYcYxXnwrtnxBmvf4SflJvnBPGFLfXxtLTi6BXLywXAtUKWFUgsBZ+hNXUrsyb
         oZG5H1OlqWPMRTtmhVDNEKcMvmWL64sjcET33SQLk7hAyIZfxUcfFqL72CqYI2Y8v+Pw
         fCZmyR6g/R3OKqt5xLdGCGnyPdUJK94ppz9u1lUgXj4g0VPNKsJoR1cNM96+kXqMiWt3
         c7InbcdDyaz11CWcJ9/1BLM0sU7QPeC4Pbp4adXwi4NU0BVZkT0eGpCXeiNDpsvx29ep
         QdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788110360; x=1788715160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y2hq6QuB9tMpONgBvXPbELPoG76SYlrSEl+e1j2HRJk=;
        b=lc5/gdUoF40B6lY7oe1+VXmfZMLc5ljjRYNsUqbHhPtYQO77lbiF3m46RtNzYhzvIt
         rwlFfa7fq9KooVKBOz64ZVUnnNwsgvIpUaNIz2cefZn/Bbnixs8uZATujALh6i3GZe9L
         FlN2sYH5bVVz9pMxsL6477w4CsjKY2GHtnxpSg6QvuQV3aCjV6NAwHespN3w31IS/NeO
         2F9fadaMzijh3okg78LphO//fSPkM8IyBz4ulXVpFfoj3s2g1k3trNHjQPD24rl1X4eB
         298XuHzH5JyGsOLDjLuJ0d7DCD3VItbUcV3n7gufC/rLZ2mO98BFRdlwge/372xjHCou
         yA2Q==
X-Forwarded-Encrypted: i=1; AKwUvBym8JlX17SAgm8YmLtYDu4p5QvcsOmN17BwfCHbwdWp0JyPp+xEFKYI9UGEtddyPNIG3hRGvqo+@vger.kernel.org
X-Gm-Message-State: AFuF++mJl7PO+k0NqjnblMvwxAPgzifYEyuxVbITx6+IQ+3YlyPQQVOX
	1+ZY6xgWQY2FnqO8IH6DAjr89CIpl4+ulv9VFA040+AY/n9rEYcyxB/J
X-Gm-Gg: AYBFou04WgjHSS//wZMIlB3EB5dGMVv/ZnnGzQBmQ91ZrZ3Dj7qrDnYadQZBSgoANZS
	YjvCSR8WPM24Y8BUvo+PDV3DO9isHCaVpAYyDVPatz+Aadq5t0TyED+wPZn2CMlGwuy2ud96JTH
	puJUA+A7FGDjZcZtT9pdaugkdqUN2QDY3MCq7zAJRto8cOWcrZyxyRDAXklHuw4HbbiNCIvvGiY
	erSsnayhS7cPzV+o/O8BylSgCKCWOjokA2WTWLov5ry3CwFq3viRCC7J3kP0++WD696YjK1GwBz
	FPFYaFBGMaIRQzYTQCdeazW0sVCF8QBt0B4Od/vU6U7RebKr8xpZ6LTJFgg+DiofB+yVGwwfhha
	nsAfJk/73F38GCCK1HAnLUY3MADHBKJsbEeqI8FSRmaS/C6VhaMwANPDXBeM9uEPIPZp+oXVbCO
	SEqeFp+nZ4kFvZKm2j0lLEVieC+Hs8r3/REkid1xrW7N1um2j7a6Eg0YJnkywnK1JUJMvwIssJc
	GKSVXfXIHpL5IAx/J3bzLJ0v7Th/22RMz0=
X-Received: by 2002:a17:90b:54c5:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-396d0e5ccc7mr35280422a91.3.1788110359674;
        Sun, 30 Aug 2026 10:19:19 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992e05sm17245893a91.15.2026.08.30.10.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 10:19:19 -0700 (PDT)
Date: Mon, 31 Aug 2026 01:19:11 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
Message-ID: <apRkq7A-tvmNvO0O@KASONG-MC4>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <ad8acdc0-7618-4caf-88ca-4780e39ff324@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8acdc0-7618-4caf-88ca-4780e39ff324@linux.dev>

On Sun, Aug 30, 2026 at 04:39:33PM +0800, Ridong Chen wrote:
> 
> 
> On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting a folio's refs and generation info, making the code easier
> > to debug and understand.
> > 
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states. There is
> > no measurable performance impact, and some paths even look slightly
> > better in the generated assembly.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
> >   include/linux/mmzone.h    |  1 +
> >   mm/folio.c                | 19 +++++++-----
> >   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> >   4 files changed, 114 insertions(+), 43 deletions(-)
> > 

...

> > diff --git a/mm/folio.c b/mm/folio.c
> > index c02dcea9c03c..a932059057ac 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
> >   static void lru_gen_inc_refs(struct folio *folio)
> >   {
> > -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > +	int refs;
> >   	if (folio_test_unevictable(folio))
> >   		return;
> >   	/* see the comment on LRU_REFS_FLAGS */
> > -	if (!folio_test_referenced(folio)) {
> > -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> > +	if (!folio_lru_refs(folio)) {
> > +		folio_set_lru_refs(folio, 1);
> >   		return;
> >   	}
> 
> Do we still need this branch now?
> 
> If folio_lru_refs(folio) == 0, that means refs =
> lru_refs_from_flags(old_flags) == 0, correct?
> 
> If so, the do-while loop below already handles this case, making this early
> return redundant.
> 
> Or am I missing something here?

You are right, it can be optimized. And that's is not the only part can be
optimized after the cleanup I think. But perhaps optimization can come
later? The helper convertion will be harder to review if mixed with
optimization I think.
