Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F975331EB7
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 02:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129163; cv=none; b=qqYmeyHsZaXdQAv07piOaqVkPsuQl2uqVRwCI0ka8Kyhyria0hfB00/mnrwm+SWvfT03+6Gx6w3M62GBAr4rY/fR9ApSpYB4cQpreQSKAb5TXD542ZhBsxAWHfBBVvqYaHtfocJ1ZdTV+vFhzA6FM6yJlEf/aq46EXg9VT1b3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129163; c=relaxed/simple;
	bh=aoPVRLxrPlybDGOf83dbhyu8QddYp2j5TWPxs6wBNtY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NjuLSwKYS6b8jtlOeUKaLPxXkJP4Ir2j5WbCd2wcHpqQhkJOfyHWOoUuJG6+EICb9hPvvUzYFxQPS4Ra2ApidISesSyhU5J9MCT5Aw1GhyxCFHBnL38iyzWd12tmfOsiWfLP8GpIwhMnUbBs8ekykj/tZELlwHQ6KNWNBBOYTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f/0cdyLu; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f/0cdyLu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aoPVRLxrPlybDGOf83dbhyu8QddYp2j5TWPxs6wBNtY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129159; v=1; x=1790733959;
 b=f/0cdyLukEQbsWLnrKukNEVVKVvjggtnAevgEMhHpeZ9D5sXbRO3DnMFGL/OgxVnXgIBa1ey
 g7IOjtG0bAq2Td6fqdtx4ZPmGmOon6K3vdyyZiAy/J2Fb8+mWBIhsJ10BMJ9p+DliDgvMb2aePT
 lHDkHXsv54Lz+oonbK5XkK7g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6ba19cbf58ee3a51;
	Wed, 23 Sep 2026 02:05:59 +0000
X-Mizu-Trace-ID: 6ba19cbf58ee3a51
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 23 Sep 2026 10:05:15 +0800
Subject: [PATCH v2 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-for-hugetlb_state3-v2-1-e8a36245bfab@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
In-Reply-To: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=3398;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=hXC+tx4GVm4EpdooEXfm8U4IGYo4XIxQaYt9Zm+Q5C4=;
 b=kG89fQSsfZPkZFrzZC8Xzjc44NNawhKI9hCnKQZ/QPjilZlfVLnsiEmBhYE8BfraxqNxICGa5
 6qVieM5YhGlDOWVhEg6crzKggJjGJCTSnS4bviDruMGHk9ZtmFo/aSC
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=

From: Hongfu Li <lihongfu@kylinos.cn>

The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
when a huge page is handed to a user via hugetlb_alloc_folio() and
decremented when it is returned to the pool via free_huge_folio().

A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
hugetlb_alloc_folio(), so it is never accounted, while its free always
is. For a migration target this means the target node gets no matching
increment for the decrement on the old node, so the global nr_hugetlb in
/proc/vmstat drops by nr_pages for each migration. The same asymmetry
affects the failed migration path, which frees the target again right
away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
same helper.

alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
folios, has the same asymmetry: the folio is handed to a user without
being accounted, while its free is accounted through free_huge_folio().

Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
decrement in free_huge_folio(): a successful migration hands the folio
to a user, a failed one frees it again.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/hugetlb.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da980377d353..519c30b338a8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2206,6 +2206,11 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB,
+				      folio_nr_pages(folio));
+
 	return folio;
 }
 
@@ -2213,24 +2218,30 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
 {
-	spin_lock_irq(&hugetlb_lock);
-	if (available_huge_pages(h)) {
-		struct folio *folio;
+	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	if (available_huge_pages(h))
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 						preferred_nid, nmask);
-		if (folio) {
-			spin_unlock_irq(&hugetlb_lock);
-			return folio;
-		}
-	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* We cannot fallback to other nodes, as we could break the per-node pool. */
-	if (!allow_alloc_fallback)
-		gfp_mask |= __GFP_THISNODE;
+	if (!folio) {
+		/*
+		 * We cannot fallback to other nodes, as we could break the
+		 * per-node pool.
+		 */
+		if (!allow_alloc_fallback)
+			gfp_mask |= __GFP_THISNODE;
 
-	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
+		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
+						    nmask);
+	}
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
+
+	return folio;
 }
 
 static nodemask_t *policy_mbind_nodemask(gfp_t gfp)

-- 
2.54.0

