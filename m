Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655566;
	b=vdAzWx3cAYV51kJ1mgPKqPQJWlaf096F2qU5w+USM/uPNTmZYofSUnq5GeRIo6SXrGom
	 PiWfkiy0lRaPv7WJzMBEDh8lPCLnTGc20XQ3Pn1AL6iIgVnfs1h+xpCu0whwviefkfwFL
	 WDT6e4uIEYXWZtEuYytHhHKAjU/q5D7EmqzMbdqnSBbzUqBXlfbg/FbvJCfJlOegj4Tvt
	 fJtLc4Msqitv2XAfI0dF8XXVSkoJ9Ty64TwHcA7CVZ4mymh5U88Ag2nIj0AOiTZ9wbWF2
	 NYzdCgRyobY2kk0cR7O/gWAvBa/YbVlH4iRgFWaUNLZns6SYWjTy09tX190ELp9OLKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4k4497sTbbDvYeqvxlbwbiiYz6zh1ROyOPLpxYM4Y3U=;
	b=pZNamPQg51ZelI7I2GO17CzH1vNkb3uX0YYkdmG2kZU8tDBcuuMq7IbMt3WFIbjnt/Fy
	 1rJ+1zFnyov8bW7S3M8g8jC/eT7CUXyNyfOEXhsqatUvKrxhyVLROagSJ/rHVhswIzNfO
	 /ubTcpJDqQ801ly8aqxJSH9Pxb8GCiYNFyyubGg5d4zkdBBz+ZvyWgEDB9NChIx/U3KGd
	 ab6CSGBv3qdqasGYvS49uswk413i8iVMeoruJLDAVkjjp++fugAe08p3R68Mp5sMRNZl0
	 fXiAAcqaYEIp4tSTFT+GfGAAR+MuxzIY63cgOoX+60DaberRurDwMzFgzuATTNwiQKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jouev5Qt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31896606A335;
	Mon,  2 Nov 2026 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jouev5Qt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA5A1F00A16;
	Mon,  2 Nov 2026 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655565;
	bh=4k4497sTbbDvYeqvxlbwbiiYz6zh1ROyOPLpxYM4Y3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jouev5Qt+8GltlW45V5pTUQV7gF9lqCjSzgOdMtlplRDu8wkW1tS8zUxZkwrLfNoS
	 Go7Xnm7RHkpOao988ciNLcvGMB+qTzrRvSAyDHr9HGiB26HoveciMqfozQeA/1FkgC
	 dMXstNtWJirqYHBZE93b0O8LsKzBKM9XVaQA0k3yIbmMdKGp2xVmAzmwofgm3GJ8JZ
	 fCzy01U7ZfgO9h7xH6sDPIqN6Mg4KhnFm7LG+Taef7bp80Piy+npF+2+SoXjuo4cwk
	 9ezM+djl2yFupw3dIdMFU/nsKfQvTrP6uNmI8JlZOvatS8SgR7g1MLQ6lGmNTTbvMB
	 AMxMIaS5/5sLA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: devnull+kasong.tencent.com@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	chenridong@xiaomi.com,
	chrisl@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	ehab.ababneh@intel.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	ryan.roberts@arm.com,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	sj@kernel.org,
	surenb@google.com,
	tz2294@columbia.edu,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	vernon2gm@gmail.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhaozhengzhuo@uniontech.com,
	ziy@nvidia.com
Subject: [PATCH v4 01/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Tue,  3 Nov 2026 05:39:15 +0800
Message-Id: <20261102213915.57805-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261016-mglru-fg-v4-1-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-1-2106750c0bfa@tencent.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Oct 16, 2026 at 2:15 AM Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> we still follow final consistency of the counter, and it only serves as
> a estimated metrics, a little inaccuracy has no visible effect.

This might be a good idea. Updating the LRU size without
holding lru_lock could open up possibilities for further
optimizations.

Recently, I've been thinking about something in the aging
path. For example, suppose a folio belongs to the root
memcg and is heavily shared by some of its descendant
memcgs, which also access it.

Currently, aging in those descendant memcgs will simply
skip this folio. Eventually, we'll have to rely on the
rmap of the root memcg to determine whether the folio is
hot or cold within the root memcg.

Since the shared folio may have a very large mapcount,
walking its rmap could be quite expensive.

So I've been thinking about this and put together some
very PoC code. It doesn't really work; it's just meant to
illustrate what I have in mind:


diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ddef3b488b3..31b02478269b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3618,7 +3618,7 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 		return NULL;
 
 	rcu_read_lock();
-	if (folio_memcg(folio) != memcg)
+	if (!mem_cgroup_is_descendant(memcg, folio_memcg(folio)))
 		folio = NULL;
 	rcu_read_unlock();
 
@@ -3723,7 +3723,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
+			walk_update_folio(walk, args->vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3736,7 +3736,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
+	walk_update_folio(walk, args->vma, folio_lruvec(last), last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3812,7 +3812,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
+			walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3826,7 +3826,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
+	walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4499,7 +4499,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, lruvec, last, dirty);
+			walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4511,7 +4511,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, vma, lruvec, last, dirty);
+	walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 	lazy_mmu_mode_disable();
 

We may want to explore this after mglru-fg. What are your
thoughts on this?

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..597f013c8e04 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,11 +47,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>  {
>         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>
> -       lockdep_assert_held(&lruvec->lru_lock);
>         WARN_ON_ONCE(nr_pages != (int)nr_pages);
>
>         mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -       __mod_zone_page_state(&pgdat->node_zones[zid],
> +       mod_zone_page_state(&pgdat->node_zones[zid],
>                                 NR_ZONE_LRU_BASE + lru, nr_pages);
>  }
>
>
> --
> 2.56.0
>
>

Best,
Barry


