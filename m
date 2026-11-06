Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959569;
	b=qAmfoYQ6TiaHGUbBoMSeeiUk07IvATNtW/aRocfU2J3ijulStbMfe2R6s/fkOUnKlhg/
	 PTrfuVqnGtGLnTRJcWDutR9r89TIWbowuuoyXsibEtbAgihHrgXcyOo4wIJ9LXqN64OLS
	 aHRk+dBAycSxj/g/+FxSmxLuC2XV8JlSgVTSCL9OgC6/MsfZVZ4f52L2/xxouU0ZSFzet
	 uG/nXRVEIF2gNKZhjYv5aJNTa+6roKw/zJD0jX9VdcXDkViZzGYe/55egj/dWpks3wsKO
	 9ULvfGScVbsEOLfBkuDZdBkgf8YS/dl4iMkPboX24aXKBhP5+r35ifN99tKGRe89zDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959569;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FrQo1zWdhbR37KjzuqMTCbGMlx2UHVUhGDoqAfLgAy8=;
	b=mXiQaHPw1Neq+Z9Y+hkIJoeSiv1f//rTAl7yOIQWYRAA65DBIZsjntrnoHqfVjwNrx5f
	 vg+IMadAC7b+JBx3nuFZ0lKE2eh6XMwl1dmG2lUbi5fVgq4onrua6KjPO47hjNwu95waV
	 3ruW0WKXWRF82oyUaaIPbQTZwON/yWyyyizV6pWFRyYVNWuBFAfwFDUXhg0ewPs+2TdzV
	 QZIKjX/5y1pFVLBfQgB8E/T2HLHNo3Ei8cuKO1bq44riIvBuGDOWTlG16/9CUKbvrzbdh
	 d4ayQ5XbGLyfin9V9qUGDDWnMBEGYUznm4mpA/+3CwXIH1MsWH3dIegQEYV76dY+3fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQcQuH9V;
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C7C606A326
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39C7C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQcQuH9V
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bNru5tLaTrRcZny2inHzZJIS32KRCi5plf6iM9ROkK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959566; v=1; x=1794564366;
 b=QQcQuH9VnzgGtpanWuXL2/YQfHVbyvzI/2MufWqAK8iHgjK9fxO0jO1ZBEOlJWmWvML6hs4y
 cXVhDX5Fi8xY0Llbfo1CLnKzo8/YXAKXuSAIO3xMs2is5wxAaEjhZlBHHgYwJfgoVaUgCoT2m97
 ajM6C2X2j/XcKzdf812B3tOo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f3d9d3dc338d93a1;
	Fri, 06 Nov 2026 10:06:06 +0000
X-Mizu-Trace-ID: f3d9d3dc338d93a1
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH v3 2/4] mm/hugetlb: Preserve persistent flags when returning folios to the pool
Date: Fri,  6 Nov 2026 18:05:19 +0800
Message-ID: <20261106100521.30099-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
restoration fails. It clears folio->private and restores only
HPG_vmemmap_optimized, losing other flags that must survive the rollback.

Clearing HPG_cma causes a later free to bypass the CMA release path,
leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
loses the indication that the locations of poisoned subpages are unknown,
undermining the checks that prevent freeing or unpoisoning such folios.

Preserve the existing flags instead of resetting folio->private. Callers
already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
before attempting to free a temporary folio, so a failed vmemmap restore
does not leave that flag set on a folio returned as surplus.

Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
incomplete transient flag cleanup.

Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6fba92b0f674..5b5353ff5ee2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1450,6 +1450,12 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			      ~(BIT(HPG_vmemmap_optimized) |
+				BIT(HPG_raw_hwp_unreliable) |
+				BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1460,9 +1466,6 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1750,6 +1753,7 @@ void free_huge_folio(struct folio *folio)
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-- 
2.53.0

