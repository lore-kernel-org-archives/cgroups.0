Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E8395255
	for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772036606; cv=none; b=g7U5GAO8khuw+YrW2kZfhT+KKdT+VBS2lAoVHz9sowmTxvZqySoPDY+sGG9zpNDO7VY3ksV4N6zkjrnkUnAEWE+cnCAffBmEw/v1ZgI9oFt0sSaUmm9gstm1RL+ZtY5woN5ohleQrbpl5HzzkofC+qSylPwmj/hCdWJ5XeLMdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772036606; c=relaxed/simple;
	bh=Qicav6fJ5kskEm1T+5PiQHbZCUV55ZLrkNeL7tLvGPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2GcaK2tbBdUe1erfd5PjtMKUWf6EmkkiYvpycNVX+qW3ebVYp680II6uJ00icFosNaygcrnsLsu+EMbyLNxj3NWi6u7VtMGBaGIuS7wq67XStYQSszsWvXN62a8ViFRGCxtmAeAOEHReh8HLiQDGHjAiX7ULETDLkfDLM8dFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WSl4pTZL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WSl4pTZL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lMW7um1zFk3y2lfz3dcqtafdNKn0uB27eRvgbewzzag=; b=WSl4pTZLsw4QoBOULrpeWRN4su
	1x2EFQQC248KOrGWqT5rhI1D29JewZTTDtKkHdcHMjxaeu1sa1Qp4lgx2y+C0IjwJwPC6kN8afTJ2
	otuzFjWj4DhjyE1IjV/QD+7cUtc5m8O5AYhcSlPyG2iUJp0SBd2rW5A/nFzljOC2L4/7KeSpqBaag
	BIgvia44HXomUVR5pYTADpWnUfxrzEh6Pr9i6wOrGL8LAV1PCckVT5A/doM/SUDrLxLZwKTMBhlsB
	NTbgxrTEHhuzSPX6VL4jbRY7uuAz9uN/ULeRd1i7Dg6uVVW/ag++rFV+rp/F3gZlV8W4gbRlCvbvW
	3ckFBl6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4s-3Zh8;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Date: Wed, 25 Feb 2026 16:22:17 +0000
Message-ID: <20260225162319.315281-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225162319.315281-1-willy@infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit f0c92726e89f removed the accounting of page tables to memcgs.
Reintroduce it.

Fixes: f0c92726e89f (ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor())
Reported-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       | 15 +++++++++++++--
 include/linux/mm_types.h |  6 +++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..34bc6f00ed7b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3519,21 +3519,32 @@ static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
 	return compound_nr(ptdesc_page(ptdesc));
 }
 
+static inline struct mem_cgroup *pagetable_memcg(const struct ptdesc *ptdesc)
+{
+#ifdef CONFIG_MEMCG
+	return ptdesc->pt_memcg;
+#else
+	return NULL;
+#endif
+}
+
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	ptlock_free(ptdesc);
 	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae722886..e9b1da04938a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -564,7 +564,7 @@ FOLIO_MATCH(compound_head, _head_3);
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
  * @__page_refcount:  Same as page refcount.
- * @pt_memcg_data:    Memcg data. Tracked for page tables here.
+ * @pt_memcg:         Memcg that this page table belongs to.
  *
  * This struct overlays struct page for now. Do not modify without a good
  * understanding of the issues.
@@ -602,7 +602,7 @@ struct ptdesc {
 	unsigned int __page_type;
 	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
-	unsigned long pt_memcg_data;
+	struct mem_cgroup *pt_memcg;
 #endif
 };
 
@@ -617,7 +617,7 @@ TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
-TABLE_MATCH(memcg_data, pt_memcg_data);
+TABLE_MATCH(memcg_data, pt_memcg);
 #endif
 #undef TABLE_MATCH
 static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
-- 
2.47.3

