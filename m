Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460017;
	b=nJACq6MGfUpmgCq95MdhSNVgCNXk4nI3DC1PuhiDD/Y/YIi1yRtRtwgsS0KTU8AiALLn
	 Mh9bn8cemooe6KEqJRt7S+BFaAQVs6GgOjn/ARaKZ4mVHRIUrTvqd4fGo3fRod4Aynb/3
	 CV1qMdDVlhWT/6bmImDSgSvjcDcVzNN/K9+w14Is+/pVvpj6ax8FCYL6DF1kqHyEW04Y/
	 FLZptGCrvy5BVMLqoo1CyYX9mAPRuC+JfQyP3m8hfkMVYsTjMzKU8bNl0EHxx8HU5LtzR
	 2A0SDkLUi2ha+J5WYDKIp6EgXRfA8W6CJjrFVYCbAXQi7ngCnku9UyfScf+R1B6G3Zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460017;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	b=akXpbPZQYOP3YcU9+yHE0KICnrluccy9RGxEGagEDpJK+ws1wnjAVNVp9Kopi90EhqKh
	 9XauR7axLQa9cvBY9j2/aIaQwsWDnSLDhwIDrvtyNl0D+jM/6HnkJrL+4NEatO8H7d2pE
	 1vZ0O7DK4jfGuJoMNG3NDLcjV/CUngXtzdhOpSoP6Lp6RGYtPn28MZL+3LazvJ4os1ZFd
	 QneMjZGaDG1zsBZuBFe8S5ZBc0y/rLmSjSLP/+EADdBFtieVFNiPZvYQMp5IVpb9fD2Gn
	 3/ZdEEmlhnNuqO+PdSh3Jqi4zv5/4NzX9UXwdG4zgP+oFViNgY/hLfAm1dwuvnYFygA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMsjoHrk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D7E606A690;
	Mon, 23 Nov 2026 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMsjoHrk
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460016;
	b=plPWeGjfEZ3bTdKOz55h8saeWZEkJpR5jJmu3r+CiirM8+r5fJ1HBC/hLRGeQoClnvTG
	 Nhp8O/GuPFmxEe5s8HlCQw2KspweuhtGB9sAquAe2gPhDwWyTd6nLQnuNc2U+Rv42oxnP
	 y0XXmrOB/+d8Adw4i7loX0HrckleIMGgkx3k1SQuybOQBccG5E4Q1Nw/eDcd7gl6QV7TT
	 Bazsx/Jbp1lIjbVqSKSlUeVoE5pJc9OscXkewRjbZkMgnyUWjruWpioh6VOsP5WDyn9u4
	 GT89h52s+ilVOVLFXD6O2BamyA54QC0hScyO+sQ4oSb/votV2xQVSQWBjsIW6drF76g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460016;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	b=WqPWsg9ANHJgvoBLVS8ZdA8TfFSwwu2mBmh2nzs3GySdO1wYHKbrfTKywhVBxA+pobSF
	 yiIcu+w1PRbERkxFn6wd1TZaz5/bTlEEC17IL2BcxdtihChciWZ20Hd/2pUUFgcdgjOGy
	 lkgRCVUYtNzkQefV/UGmEEB+woadsi68reDdENye+UbhPL81aZ25sBvSEAwiPbQPKVqCQ
	 0VmvbngRhXyhMvu0m/MClgwGc33SbaR35BSgU9BVoMVaG4QhJBkSE2QIor0NTpRjSuypl
	 0h0sNj2Piov1K3ywHRtrQ/Cq4J+Yx2fVnQ0X4IXhJT6+DNZ2UdyioLerGQphsQ+Xf4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 025A21F00A00;
	Mon, 23 Nov 2026 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460016;
	bh=horbJ+WRFpXrHIUpt9mddEfhWXyxTruu2VhXlMsfh58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EMsjoHrkoukJH0WJ6cAQrzxLVECxGQbZiHjN1a1TCOGrqYP9Gj2bMlxns7MB/sW+2
	 rlKkWPVtRLr+9DUibY5bZIJthJgLxVXBOkI3lrsVjoKkB1csrtp1g0SC/ZKMxLyeji
	 u81j4IIHhaEvkF3O3RZoDfq7rKxoXxPR3YLwP47kzYWNAsTFrUryBNKfHQzjcRhcZB
	 pmQIC5Ul1eSfmIUFBLLjWwcAeU1KO7/QnRlBYfM1fgx1umzJaTXJy2N6/E2oJG1EZG
	 7QOv18bsyrs4cbPrgG23Mappd3UkKAMskDueMXW60q3LQZyFEA2Jm9J/ognhvHmIZm
	 rrWn9zqcnyv1A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 630B84C655;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:03 +0800
Subject: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3877;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SyGC47j2sShmDrstNnpICQjj8oxfwuGK/s3C+V+Hk1k=;
 b=zDeAcKA97ZXD5+wk30UPTAW0+f1NPxG7RvOr5muhguEVkFZjwS92VJecDA26puiKkUFemGJIY
 FU8Dgte6mVHAd28IbxPk82XmytTsRUsfRtz/LrUROT9BqXOCuZBS2gq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

PG_referenced is only the lowest bit of the folio LRU refs count
(LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
clear it, and now it toggles as the count grows. But with the LRU
referenced count as a stable API now, we can use two helpers to provide
in-kernel users a stable and sane reading of the referenced status of
an LRU managed folio.

Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
count when MGLRU is enabled and PG_referenced otherwise, and switch the
smaps paths over to them. The lru_gen_enabled() test stays inside the
helpers, so its static key is not splattered over the few call sites.

Convert smaps as the first user of them. MGLRU now reports every folio
with a nonzero count, so the reading no longer flickers and clearing no
longer results in an ambiguous status.

The classical LRU case is unchanged.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c        |  6 +++---
 include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 540c936aad47..d2a524c6ad4b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -890,7 +890,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || folio_check_lru_refs(folio))
 		mss->referenced += size;
 
 	/*
@@ -1690,7 +1690,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1719,7 +1719,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 13c8b6bce349..0f470ddf5c48 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -513,6 +513,37 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/**
+ * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
+ * @folio: The folio to test.
+ *
+ * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
+ * which is also correct for the non-MGLRU case. Kept as a separate helper,
+ * to avoid splattering the lru_gen_enabled() static key.
+ */
+static inline bool folio_check_lru_refs(const struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio) > 0;
+	return folio_test_referenced(folio);
+}
+
+/**
+ * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
+ * @folio: The folio to clear.
+ *
+ * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
+ * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
+ * just like folio_check_lru_refs().
+ */
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {

-- 
2.56.1


