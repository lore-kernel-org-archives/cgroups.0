Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3FB30F819;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544527; cv=none; b=oa/QEuw/e6OCCPoxJmUAwERYXOeiKmX8TrxSIAaiPR0yMHOeUTVoycUglJrpaQoD4zUbwmPVTBmE0Ii6W2iaEvtBXfeAWGgW1j5REy8gC77nfXd18rQ73AAUe0hHjnpjBUaVg7FXt2iRnfiipvQhjUZwpdrx9vx1mPBbhv32Oas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544527; c=relaxed/simple;
	bh=ob6VrZobjIxhJd1syjRnD0Fz6UDbLx7k9+0T35c5Ifk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Voazdn/u1uhBX4/cVwPqKuivrr7yOdiCke6mApIIr7yrJLSA4AXvShEAxSnFOckrdfrtx4caSwK8wHsW7llhXE+MKJsKYIx2g8/gqpyqaUQrcdcHtx2Az+AD1ycYQr69o5s9yRJcUOFrgLB6FLuttiF8kxjyEmthK5QtiGRE0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RX0imueN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RX0imueN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A7D0C19423;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=ob6VrZobjIxhJd1syjRnD0Fz6UDbLx7k9+0T35c5Ifk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RX0imueNLxnKo6rUXkF0FvQ104tNzT+RDIgI3/9VpHbGhPl5ylP02acqwECdl9lIi
	 csDtkTmVwrUdMm5ocEnx0KSqrFsH/NreFVdyX+OZz4oV8nTO/fXJ36uuqx+Q90OLqj
	 QtHAv2ozRZVQlO8EJXfZhrov9EzaOU6DtSnvEkEfSoNOFrDO2rl3il4T2iEK1xPhdM
	 29LcWXU+gcudZkW0wUMrsTxx4l6WtZfZQ1NcX7b3Hh9Jg0JurM3DDaBiyeaCNZlvq4
	 MbrubBu3OlOc0PTIHbGKHerkilSmMx8S+PT5KLNpXaFyRD3kgWmbMEqZZtvNd24yTF
	 3WbmjOcRZVPJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185FBC531EA;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:02 +0800
Subject: [PATCH RFC 01/15] mm: move thp_limit_gfp_mask to header
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-1-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=3548;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EsaDsTDGqRS39tj8l8nvpBNRy9miEhNym6TC8RjJmDw=;
 b=wZakvnnlS13do00sOlIWHX8u8pD1P7hONi6OwqAIkTyXNu+BQg7Edjqh/iZMYuGM58ZYbJdRG
 6jgP9IrnMLJDt6qpU2w2ZuSjAyEz0NYHpKdYslZ4KSCbENbjAT0krGo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

No feature change, to be used later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 24 ++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..d522e798822d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -237,6 +237,30 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some of the flags set permissions, while others set limitations.
+ */
+static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 /*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
diff --git a/mm/shmem.c b/mm/shmem.c
index b976b40fd442..9f054b5aae8e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1788,30 +1788,6 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2062,7 +2038,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2138,7 +2114,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2545,7 +2521,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {

-- 
2.53.0


