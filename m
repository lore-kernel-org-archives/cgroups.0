Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC742A155
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785829796; cv=none; b=OnteC04/fIg2q5aBzmC/+n8h7TsTYEuynGlX4SmJkpJzMU00v1600iECnSBwq2hDnMYxwv4vvl8WyH7UvfzUoTOankOSM33l7tZIso3ggtSB6eCaPHYol9x6m8uCLkVwr8LVpvKhbmID0tc9+DCTfNIap97Qd0WOV3+1utl2ecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785829796; c=relaxed/simple;
	bh=DZJ23dxm5S2iULFhjorByh6gLjKGXvQQZ+eOil3JS70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvUYfd8GT5ttVa2mGXwMBKq394DkrIuoCzIF+C+vE4v1oxsKBZOjWQqxP2MSGFLqIckmgdU1y5281NTErsQMnTaxVqG8cDpqfkDNOuPTiC7Sx6D516drUQxxslQHJYRTUNiTZkU/Fmw6rmebQLlf1ifX84sQHqmh8+i2GZ4Oeno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C2OY1f6a; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2OY1f6a"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso41349415ad.2
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 00:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785829794; x=1786434594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iFJL8jVhfCxZjR9xu1MoV5ZlsyVSM+R/CWmz/4XH5e4=;
        b=C2OY1f6ao6tnrkzEAqwvJl1Nt37kkH1+VhIvcf+OwATduE8SpFbRRYfdf7Z2td4+fB
         2FTVZ5EZ/PPFBJ6egXaBKiRV0+4FLm/4eo2XOq9CTHOnarmGVzloBP3T+yWMQxNBXAfv
         DCW+L8RTIZSgFl6ckEcPoTxSFtD1l3gczOyx++j1fpj00Fz7+oMqSKM2D2Nm3sPYN94A
         1GvaVgn4wqPH2ETVqiSSuptcwc8jWI0KlMmjFWICFbd8V1ZZ6Oc5YRpehzY8Pvr1FsPL
         Tp5KbPMtvIeXcmFjPVceQrAz0ZE+BUFbiqzTb/fYA3Rz9bKNmPEpqflycNQzC/R2m1ef
         yWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785829795; x=1786434595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iFJL8jVhfCxZjR9xu1MoV5ZlsyVSM+R/CWmz/4XH5e4=;
        b=BlFA5rcI4GiIUJBEeyJ5nW3CFFZbB49D8TkXzEBy9j54uaM40b4wQcCUgL8EdwuYAi
         diEHGhRU8rwZ6+QzCJ15V/X5DFmADfJu29VERphlZmO7tcZ+zf6OfE+b9VoNRvsLpUVP
         Ut3IZO8p6wPmSF8Muz/H77WukOkJBA1LCiadPg3z8Enmr/UCLU6S5OepUq2qbADNIfMK
         xh84knK4W3qHvPOvDjVW0VvMu7tkSUuuSjpQV0CyolJhthqy9IU66QI7SKqVxDIlAYrJ
         NEabOtNCc2O7SoXZLZSAnUqStJJXhG5DdrJjCAyvGpuAPSATDj5jVTrAdAeKQ1xScA2k
         EehQ==
X-Forwarded-Encrypted: i=1; AHgh+RptJ00AVZXK7uAyQxCyxsItSUjPqGLOrnddB/bJqtfxmnGNOEUi7LrsVC6xJ+VFLV4JZ5Gh6jtD@vger.kernel.org
X-Gm-Message-State: AOJu0YxgX7h+5ZFMDMan2xWumW/MvPqMjIUOO+7lEXGn1eX+2M6TCVCg
	Hf7eS349RkOkQ6rLj4zdpnElW1BQ9Kjt0T344xs2efjQxqjHUxEnIQQ4
X-Gm-Gg: AR+sD12yRkmDQImiis/2TBmAuhC1SDIncHg+bF4J4TREau8U3Q27eAYFEVgRJyM7FhC
	eNIcGvylXmkQesow7aDNoZEsevhza6HA1OpAG+qKtwWOHUEkPX2FhsZBtGaVWEdzj5eZkHxnkCO
	Rcvp+GP9pw9o8UoobxK5+RYWMnSAi1xdiWDzzyWs9y+j97+dHg0NQGQw13x8EpclXWmoE0e8Wjs
	H5Saapp5h+CwRWk25IT/36r53TE3AeIlC/LntCiwEBaM/sLkE0BNh29/aZFwVmuxspdP2lIQgoy
	+JKerS+6gcpKSvttWvQw2dx9VyQ3oBB/0vlD9KMj8IuufXOz8QBi+hFEoUyQJRpn0aslgEw79js
	HmjESyL0467wCkhQaT1X9ZWyR2xdY1w3azhqU9Pdnb+l1LbHcOseKyvab0qMMO5/XfrH/ozf9ok
	NoifJBZBa6+LavVl8VSoP0mq90MILS1LTqqP4Iha01DKyYUNxq2xwT2vtX0Cy6iprMbQlZTdpuT
	X89RV0rjfafiFdU9yHCjvAWPg==
X-Received: by 2002:a17:903:3843:b0:2c6:a012:6241 with SMTP id d9443c01a7336-2d05219f33fmr125825295ad.6.1785829794408;
        Tue, 04 Aug 2026 00:49:54 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa492c74sm1850085ad.54.2026.08.04.00.49.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Aug 2026 00:49:53 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a generic API
Date: Tue,  4 Aug 2026 15:49:27 +0800
Message-ID: <20260804074935.99991-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-10-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi Kairui,

I am trying to understand the intended semantics of making the referenced
count a generic API, and would appreciate your guidance. My understanding is
that, with the new encoding, raw PG_referenced and PG_workingset users no
longer see simple boolean states for every reference count.

A few examples I found:

- damon_pa_pageout() still calls folio_clear_referenced(). With refs == 2 it
  clears nothing, and with refs == 3 it leaves refs == 2. Thus DAMOS pageout
  may retain workingset history instead of clearing the MGLRU reference state.
- EROFS zdata uses PageWorkingset() for PSI accounting. With the new encoding,
  the PG_workingset bit is clear for refs == 4 or 5 even though the folio is
  hot.
- /proc/kpageflags exports PG_referenced directly, so KPF_REFERENCED appears
  to become the parity of refs rather than a boolean referenced state.

Are these semantics intended? The DAMON case in particular looks similar to
the madvise conversion in patch 15. If my understanding is correct, would the
remaining raw-bit users need a tree-wide audit together with the API
conversion?

If I have misunderstood how these users are expected to behave, please feel
free to ignore these concerns.

Thanks,
Lian

On Tue, 04 Aug 2026 03:47:06 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> To prepare for unifying the API for checking folio referenced status,
> expose the referenced times counting as a generic API. For MGLRU this
> helps to adapt other subsystem based on the referenced times counting,
> for non-MGLRU this is still bitwise compatible and there won't be
> major behavior change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 233 ++++++++++++++++++++++++++++++----------------
>  mm/migrate.c              |   2 -
>  2 files changed, 155 insertions(+), 80 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 944baa91bf18..a13b7d3c033a 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -94,6 +94,161 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
>  	return lru;
>  }
>  
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
> +	int refs;
> +
> +	/*
> +	 * Return the total number of accesses. Also see the comment on
> +	 * LRU_REFS_FLAGS.
> +	 */
> +	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
> +	refs += (flags & BIT(PG_workingset)) ? BIT(1) : 0;
> +	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> +	return refs;
> +}
> +
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
> +{
> +	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +	BUILD_BUG_ON((LRU_REFS_MAX >> 2) > (BIT(LRU_REFS_WIDTH) - 1));
> +	*flags &= ~LRU_REFS_FLAGS;
> +	if (refs & BIT(0))
> +		*flags |= BIT(PG_referenced);
> +	if (refs & BIT(1))
> +		*flags |= BIT(PG_workingset);
> +	*flags |= (((unsigned long)refs) >> 2) << LRU_REFS_PGOFF;
> +}
> +
> +static inline int folio_lru_refs(const struct folio *folio)
> +{
> +	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +
> +	do {
> +		new_flags = old_flags;
> +		lru_refs_set_flags(&new_flags, refs);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}
> +
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec);
> +
> +/**
> + * folio_is_referenced - Tell if a folio was accessed before.
> + * @folio: the folio.
> + *
> + * This helper currently only works as intended for MGLRU, as it checks
> + * all LRU_REFS_FLAGS. It might be fine for non-MGLRU to replace
> + * folio_test_referenced in some cases but the user should be careful.
> + *
> + * Returns: true if the folio's LRU referenced / accessed count > 0.
> + */
> +static inline bool folio_is_referenced(const struct folio *folio)
> +{
> +	return folio_lru_refs(folio) >= LRU_REFS_REFERENCED;
> +}
> +
> +/**
> + * folio_mark_referenced - Mark a folio as referenced.
> + * @folio: the folio.
> + *
> + * Ensures the folio's LRU referenced count is at least
> + * LRU_REFS_REFERENCED. Won't do anything if the count is already larger
> + * than that. This helper currently only works as intended for MGLRU.
> + * Not a drop-in replacement, but should be fine for non-MGLRU to replace
> + * folio_set_referenced with this after audit.
> + */
> +static inline void folio_mark_referenced(struct folio *folio)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +
> +	do {
> +		new_flags = old_flags;
> +		if (lru_refs_from_flags(new_flags) >= LRU_REFS_REFERENCED)
> +			return;
> +		lru_refs_set_flags(&new_flags, LRU_REFS_REFERENCED);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}
> +
> +/**
> + * folio_mark_referenced_by_bit - Mark a folio as referenced by bit.
> + * @folio: the folio.
> + *
> + * non-MGLRU may want to make use of the lowest LRU referenced count bit
> + * explicitly as a referenced mark.
> + */
> +static inline void folio_mark_referenced_by_bit(struct folio *folio)
> +{
> +	set_bit(PG_referenced, folio_flags(folio, 0));
> +}
> +
> +/**
> + * folio_clear_referenced_by_bit - Clear the referenced bit of a folio.
> + * @folio: the folio.
> + */
> +static inline void folio_clear_referenced_by_bit(struct folio *folio)
> +{
> +	clear_bit(PG_referenced, folio_flags(folio, 0));
> +}
> +
> +/**
> + * folio_test_clear_referenced_by_bit - Test and clear the referenced bit
> + * @folio: the folio.
> + */
> +static inline bool folio_test_clear_referenced_by_bit(struct folio *folio)
> +{
> +	return test_and_clear_bit(PG_referenced, folio_flags(folio, 0));
> +}
> +
> +/**
> + * folio_is_referenced_by_bit - Test if the referenced bit of a folio is set.
> + * @folio: the folio.
> + */
> +static inline bool folio_is_referenced_by_bit(const struct folio *folio)
> +{
> +	return test_bit(PG_referenced, const_folio_flags(folio, 0));
> +}
> +
> +/**
> + * folio_is_workingset - Tell if a folio is part of the workingset.
> + * @folio: the folio.
> + *
> + * Can be used to replace folio_test_workingset safely. For MGLRU the LRU
> + * referenced count tells if a folio is a workingset as intended. For non-MGLRU,
> + * the check below only holds true if the PG_workingset bit is set.
> + */
> +static inline bool folio_is_workingset(const struct folio *folio)
> +{
> +	return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
> +}
> +
> +/**
> + * folio_mark_workingset_by_bit - Set the workingset bit of a folio.
> + * @folio: the folio.
> + */
> +static inline void folio_mark_workingset_by_bit(struct folio *folio)
> +{
> +	set_bit(PG_workingset, folio_flags(folio, 0));
> +}
> +
> +static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> +{
> +	folio_set_lru_refs(new, folio_lru_refs(old));
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>  
>  static inline bool lru_gen_switching(void)
> @@ -171,58 +326,6 @@ static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>  	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
>  }
>  
> -/**
> - * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
> - * @flags: folio flags
> - */
> -static inline int lru_refs_from_flags(unsigned long flags)
> -{
> -	int refs;
> -
> -	/*
> -	 * Return the total number of accesses. Also see the comment on
> -	 * LRU_REFS_FLAGS.
> -	 */
> -	refs = (flags & BIT(PG_referenced)) ? BIT(0) : 0;
> -	refs += (flags & BIT(PG_workingset)) ? BIT(1) : 0;
> -	refs += ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> -	return refs;
> -}
> -
> -/**
> - * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
> - * @flags: pointer to the folio flags
> - * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
> - */
> -static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
> -{
> -	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> -	BUILD_BUG_ON((LRU_REFS_MAX >> 2) > (BIT(LRU_REFS_WIDTH) - 1));
> -	*flags &= ~LRU_REFS_FLAGS;
> -	if (refs & BIT(0))
> -		*flags |= BIT(PG_referenced);
> -	if (refs & BIT(1))
> -		*flags |= BIT(PG_workingset);
> -	*flags |= (((unsigned long)refs) >> 2) << LRU_REFS_PGOFF;
> -}
> -
> -static inline int folio_lru_refs(const struct folio *folio)
> -{
> -	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> -}
> -
> -static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> -{
> -	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> -
> -	do {
> -		new_flags = old_flags;
> -		lru_refs_set_flags(&new_flags, refs);
> -	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> -}
> -
> -int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec);
> -
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>  	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> @@ -369,11 +472,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return true;
>  }
>  
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> -{
> -	folio_set_lru_refs(new, folio_lru_refs(old));
> -}
> -
>  #else /* !CONFIG_LRU_GEN */
>  
>  static inline bool lru_gen_enabled(void)
> @@ -401,27 +499,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return false;
>  }
>  
> -static inline int folio_lru_refs(const struct folio *folio)
> -{
> -	return 0;
> -}
> -
> -static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> -{
> -}
> -
> -static inline int folio_inc_lru_refs(struct folio *folio, bool promote, bool is_exec)
> -{
> -	return 0;
> -}
> -
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> -{
> -	if (folio_test_referenced(old))
> -		folio_set_referenced(new);
> -	if (folio_test_workingset(old))
> -		folio_set_workingset(new);
> -}
>  #endif /* CONFIG_LRU_GEN */
>  
>  static __always_inline
> diff --git a/mm/migrate.c b/mm/migrate.c
> index c737d0682fa4..806f1e913a38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  		folio_set_active(newfolio);
>  	} else if (folio_test_clear_unevictable(folio))
>  		folio_set_unevictable(newfolio);
> -	if (folio_test_workingset(folio))
> -		folio_set_workingset(newfolio);
>  	if (folio_test_checked(folio))
>  		folio_set_checked(newfolio);
>  	/*
> 
> -- 
> 2.55.0
> 
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)
