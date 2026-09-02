Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE73EC80B;
	Wed,  2 Sep 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788383516; cv=none; b=ZD7FbYemmKuVRm8ptaRQiaawynbzfjpqhjLqmtb3fyz4GZsy6DI9hExnnFEBY6AkFSmFHSf70+bcVLGfXeHuR6jusHVbCl6gwFj7Ugy93ezpk/cHWm2Roc7IQZS/1sAQpFLGF4IAWEVzMI+n1AkhkHuAUeqwM7zqWxf7gE4dn3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788383516; c=relaxed/simple;
	bh=93/OmGSeiRGdxNTXziMuvzAKSuH0jCD/smVEypPFlc0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ksE4s9gXo5sx/GWTZpDcXc4V9qNnyF53MkiV4f7wcF57csDh0swPAr3x1+zJeF0js3qay1JDd8HiueoIK42rM8o3L4EPEjE/Osx7ia4a4TlbxPQz9EmQY76yFX8a2DJIO8A3+z6q07yDp77uhE7SaWxs+fwxi0bZG/hKceNoF3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OAewaOe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OAewaOe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADF91F000E9;
	Wed,  2 Sep 2026 21:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788383514;
	bh=R58uimUktAT60F2STGL0CVSJ2s2uXX89Ga88btTYWqM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OAewaOe6yCKjB7JUZQRUerIw15rxe4H1LtPvtO1QqwsRPSX35jud9zfB+jPjbywpe
	 3zE40WHpcGOpZWzbxhhpn3G8nPVpUhZD6bEf8gvdJCWZSx0pEI4nZwqbj8y8lZJVSy
	 2MDQ/Fzay7tHMTX5AyjyI4F9upy4yeICOWkjPNBA=
Date: Wed, 2 Sep 2026 14:11:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Ridong Chen <ridong.chen@linux.dev>,
 Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, Zi Yan
 <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
Message-Id: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 02 Sep 2026 17:50:53 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This is a cleanup series separated out from the MGLRU-FG series [1]. As
> that series is getting too long in following updates, seperate out the
> clean up part for easier review and merge.
> 
> No feature change is intended, except one bugfix. It mostly replaces
> the open-coded bit operations scattered throughout the MGLRU code with
> new helpers, with proper kdocs, sanity debug checks, and hardens a few
> MGLRU functions.
> 
> A subtle generation counter leak is also found during the refactoring
> and the fix is included.
> 
> Also collected review feedbacks on the cleanup part from the posted
> series.

Thanks.  I hit a non-trivial reject in [2/6] presumably thanks to
mm.git (mm-new) race conditions (appended).

The patchset comes nicely review by humans, but AI is less happy:
	https://sashiko.dev/#/patchset/20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com

So please take a look at all that and retry in a few days?

Thanks.

--- mm/vmscan.c
+++ mm/vmscan.c
@@ -3307,21 +3313,20 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen)
 			return new_gen;
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
-
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 

