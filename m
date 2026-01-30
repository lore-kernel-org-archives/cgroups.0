Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2734314D3D
	for <cgroups@vger.kernel.org>; Fri, 30 Jan 2026 04:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769747381; cv=none; b=jCja26MqUKkr7k9rtSG4DuqPMFOO1oWkF9EmI/2qX/wnMQ43WSZ9Zk49XHk+RwL3ELtQDk7Ohp0x9vbCvSkSXtkx1+qoRCT8Tq5ne/d3WV5KesmDkAotFCxg2rjKbpQIhBiqnSMMzrAnal4wVYBC2Oq6rfnYKsEduqUnTBMCKPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769747381; c=relaxed/simple;
	bh=d+7UWxm+5M3EJvh3PqqZWBR5C1l3WFH4arbKKIhfeLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XiCg+kvXN8f5cWp06wZReZLoazKuaXUT30LvFhSAjhW8SYc2JMBFOjqssLrSICqUHff+J3LVsfvNRBZsJykPTX5coPlpvG6GMg9AkCKGj1+x3a0vFYbgRDiVaTySJcaxDXHhkEFVMEp7y3l3K4oXtzoF6vPFaHiYbxOH5hDFC74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h96SwgeZ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h96SwgeZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769747378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gXklUk6N1YogTH8BAIYkPkvta0Ydd8XfF9+GbqyXKBs=;
	b=h96SwgeZWLx0lvw1WHXU4jVBCr/0kn7+7UP+V6RvJOoq9NybvulozWhUeyWBEznu60ssFs
	igGY9MTTKJ6pUv+wNV9JWnW3MZyohYvuF1AVM8kiSYAjyLVaKRa4di9n+tufN3v5eqdYEK
	MwodB6qvmj8DbnDhutlyBdlvVb9krJk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
Date: Thu, 29 Jan 2026 20:29:25 -0800
Message-ID: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In META's fleet, we observed high-level cgroups showing zero file memcg
stats while their descendants had non-zero values. Investigation using
drgn revealed that these parent cgroups actually had negative file stats,
aggregated from their children.

This issue became more frequent after deploying thp-always more widely,
pointing to a correlation with THP file collapsing. The root cause is
that collapse_file() assumes old folios and the new THP belong to the
same node and memcg. When this assumption breaks, stats become skewed.
The bug affects not just memcg stats but also per-numa stats, and not
just NR_FILE_PAGES but also NR_SHMEM.

The assumption breaks in scenarios such as:

1. Small folios allocated on one node while the THP gets allocated on a
   different node.

2. A package downloader running in one cgroup populates the page cache,
   while a job in a different cgroup executes the downloaded binary.

3. A file shared between processes in different cgroups, where one
   process faults in the pages and khugepaged (or madvise(COLLAPSE))
   collapses them on behalf of the other.

Fix the accounting by explicitly incrementing stats for the new THP and
decrementing stats for the old folios being replaced.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1d994b6c58c6..fa1e57fd2c46 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2195,16 +2195,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
-	if (is_shmem)
+	if (is_shmem) {
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	else
+	} else {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
-
-	if (nr_none) {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
-		/* nr_none is always 0 for non-shmem. */
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 
 	/*
 	 * Mark new_folio as uptodate before inserting it into the
@@ -2238,6 +2235,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
 		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
+		if (is_shmem)
+			lruvec_stat_mod_folio(folio, NR_SHMEM,
+					      -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
-- 
2.47.3

