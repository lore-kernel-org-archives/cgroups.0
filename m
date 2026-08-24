Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E240927D
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787569778; cv=none; b=Of2/w1M9xO5xI3uYJC9fVW3ET3aNKLp1MyKqMXqkxt0n/KzcaIMsPkvbCuaNwxGeMRlwDkDuZE3xos+f6ZWe/ZyIMEmBtnMPkbMz4CE62i9Y9yLOiJSMhHkVFSXgfqlU6k6KGRm7odz/xI/Oxg4hlLwdRI6Rn99gQNYWeDeeIJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787569778; c=relaxed/simple;
	bh=jMKl6ZV8VKQYwnIufmRflu12OH18KYtDSa975PPqrLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUWwn0dilwWlPt3X3JjXZhRKLePD+ha2t7EL3BCbPIAy2nwCVMU6HVnnASDI8prAKvONxH2dWM/LqffuKz5Dg4qRT0IDm23Hzsnyp6BOasM0/tvZYIxG7aWHSvQQWzsjINQ1D2QA9jsaETADT0YisVKFnKEr+VjbF5YEuiMsxp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJU2yX5J; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJU2yX5J"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso2856799b3a.1
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 04:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787569776; x=1788174576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FqwXbXyfUlH6nF/dcWjMtptrPqoYpuG4oKFrsn7psr0=;
        b=QJU2yX5JKzA7Xy7F251AC6hYb79nxMHmN1rYMxgOC5Z510tQqt2Ll8XDozvIGE8icl
         TKi3lSuBn0ztGZ/j0iR1VFP+h1/Q2Gty8MHEmB+Miz5p+G65wWNSB2s0tAKWDK9HAFDi
         BB8cZnzpCjst3ydcneXmfcT2ALX+Nj+Gj3xapLZmAkJpBCEyr7SHz7xHAfYldjKoXch9
         RjC3EV9N+99wTUiXKxCndTWU9wMGuOhHFAdMn8kY7hX2lCefONrh0Hggbi01FJKnJabD
         KfRm65pVs1b9ZAUaBcVzFvTdMIZF2oF+mDS8XD1rZ/LWPGaK0MsTiQkr2HdtkviVs+6u
         zofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787569776; x=1788174576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FqwXbXyfUlH6nF/dcWjMtptrPqoYpuG4oKFrsn7psr0=;
        b=pNdMKdRCdTs0u2n6hEcwy0u02bXJeps37IrP8LuucGjKuWevpGghzE/rBiYHzgwH91
         ttNw5QoI0ZyKnrsRhEMo2aiZ5r2Nm7Pj+Hov9chUsGli8N/Pt995SEFrgDV/xm8zk4Js
         DhLoEA+D5m7Ot3JwfNriUgqyBexbB5mNguFI7CR4hkBoVbaFOS3u+osmw1gr2CjWXwNz
         8Qy/yNxNnaVDx0oUlNG3fYUlIElXR3awsS7gr00ztknVuCXDdRrB/hzfoE4BJpcBSHXt
         UpdrutIjph5zVC0tw5o5bilVew3Y1Rrgh1Q7bRFUzDTwkYN16x2IZkF7xNkQ3GFMCQIk
         icUg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3QFZzkHJ8gMiUAhJN1UUOsJS4YQNQGgwHKBiJ6MZBvPSbyTO4RBbQEUe0Guo7GE75eK1KkR2y@vger.kernel.org
X-Gm-Message-State: AFuF++nbFNQdQzOTkbrkGtbQso9P1ReSgwZiI7NQT0ofbWquMlpS6fPq
	pHs4LQhtys/ld/ig+XugeaceT3wxZwURQWAMehIDtt8M9eWqD/Sr+N9D
X-Gm-Gg: AR+sD12MIOXYmf9tjeZWANRkmdhXTb1wCT78Gkl4EUM6AvYYtJV+fq5vyah5KxIPDGf
	s0pt4JZ7IABjtMmZP0RtlY4IWyv+cik+QdyRN10GUI9hmH4lHiWxosuYuP0g50mDhna56fVXayF
	YlhlzN7eVnvUnnjRDddch/i16p3f++yLn0BbAd7Rzdz4Vc6rVGcYy/xxtlsCi7PdfSlOx8+PPAp
	EbEHEc7yttFn4NzoKRqr3xF9gMyfC3wJ+v/XvjhhT+7i4IpwuJPihk1FVltMeGAZ7gASRkzKkY5
	3Ux1o8ix7c7ss3AiW8b3r1HEO46iMr4jz/Bv1DP+Xle0mHM+dMaGkyC1XBN5VmPXhrbOp3Wppjc
	h4mAfynTj2Jpoteecp5zPHYkaMXyT06k2pihfbAUsglzQD8V4Vcvtu3RKrtCbeUOTRPjzwvqVMq
	KJFo26nggsqL7SiPSrjEqmGGskT+GkjRfqm4j8y553PVX29xpqhY+WSsDONFlY6Qeqe03xyCISs
	ipsh1pKxJuipFmbAaYY+Z1I
X-Received: by 2002:a05:6a00:2d04:b0:84b:9a69:156d with SMTP id d2e1a72fcca58-851f9a2c87amr22297176b3a.0.1787569775691;
        Mon, 24 Aug 2026 04:09:35 -0700 (PDT)
Received: from KASONG-MC4 ([114.246.239.71])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520ef26df4sm1790900b3a.21.2026.08.24.04.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:09:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 19:09:24 +0800
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
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
Message-ID: <aowABnB6OPCb95eC@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <a13c3895-cc53-4f91-aac8-2bfef765eca5@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13c3895-cc53-4f91-aac8-2bfef765eca5@linux.dev>

On Thu, Aug 20, 2026 at 09:43:38AM +0800, Ridong Chen wrote:
> 
> 
> On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting folio's refs and gen info, make the code easier to debug and
> > understand.
> > 
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
> >   include/linux/mmzone.h    |  2 ++
> >   mm/folio.c                | 19 +++++++-----
> >   mm/vmscan.c               | 61 ++++++++++++++++++++----------------
> >   4 files changed, 117 insertions(+), 44 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 621c8653d8f7..93bf3fa221f8 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -142,10 +142,43 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
> >   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> >   }
> > -static inline int folio_lru_refs(const struct folio *folio)
> > +/**
> > + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
> > + * flags indicate the folio is off the list (e.g., isolated).
> > + */
> > +static inline int lru_gen_from_flags(unsigned long flags)
> > +{
> > +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > +	gen -= 1;
> > +	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);
> 
> Perhaps we could define a macro such as GEN_OFF = -1 to make the code more
> self-explanatory, I found this warning a bit confusing at first glance.
> 
> LRU_GEN_MAX already bears some resemblance to MAX_NR_GENS, so introducing
> yet another macro may add some clutter.
> 
> Just my two cents.
> 

Thanks for the review.

Let me just simplify the sanity check then, I think using MAX_NR_GENS are
good engough.
