Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793587795;
	b=Xz0mLUJmAE91/A+01yI5UJIHEZrRHLVRYBqmzV0j2tmsQgWHjEdSsyuG1dr6voZc6CJF
	 eucGUsZ6y6MTKzJf2GO+D+kac3XLaX9Y47UHxaP/5UJTRFVqJjtIm4QAlrV2aEGj1PWSQ
	 4AiD1j4rx/QGFxG3kZDqGmukuTVqWpt7IyIQcyOiaZuprg8VML+Y3HGpF/6OLSdjwmorp
	 HEZ4ccUMui6dAQ0X46Y/ZohEioPUIpPnDjhmeH582WFvNoGa7kRGM5vEydC46FPkHJEB9
	 7WaRRxX601boAkwKS5VtkKybQE6vUkVHSLkNSNpnkI1ZxjtSLzyVPLrFRcqpt6BRN7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793587795;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wsq265Y6LzBmkOdoymoFNHjnl3IW2ovvlI+9AwjjAuE=;
	b=FgUkS3TbM67cnNFjBxA8e3S21PdZ/G/gU5VcBTxDwDLTYoVqrIBrrYljmmWULXalgWR7
	 j5FJbz+kiplejfODytIkOpWXO13Rgp7AnbIz0PPzHhzih3lljLnheZu1PtxK6YVgbZZzF
	 fwDO6Q5rrqJFGZr+qf3xpykpeIzetmlOiTg4VE8vhSOljs0Al8g4Zttjjurgkf7JVy17M
	 B1KmUSnzKT1MoRtmdhsnfCZ1Mr547kIaOzExvKi0bSESThFdGInyvhsUz2A6x5d+mh9xi
	 u9ymBe/JJeJLKJesLoAUyVKrR2P6uCsLgo0sYEPchbHbz/YpfGb33eMmi3kWI/8J8tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="EKPM/T/+";
	arc=none smtp.remote-ip=91.218.175.47
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40676606A327
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 02:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40676606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EKPM/T/+
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j8pQESwrLrfT9Kc/KC2iuBXUJfIeLEImyATEFj6zlDg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587791; v=1; x=1794192591;
 b=EKPM/T/+fyZPfUGce3JQha20CDV8IN2FPRNcOmK0DL8riFkgbS58yOw2GC1oidgq5ierEgkF
 XcvtGSINu4IDEsSUidFOVkOQFjDSmAHdqQUuVt7TXSNCvnhcc9Jm6Ji7ZfAodvxAmmRvBH6KPOp
 BfOCPH3lpOtabQbt5d7mmxSk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 348b45477b4b0c16;
	Mon, 02 Nov 2026 02:49:51 +0000
X-Mizu-Trace-ID: 348b45477b4b0c16
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
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when returning folios to the pool
Date: Mon,  2 Nov 2026 10:49:09 +0800
Message-ID: <20261102024910.31486-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
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
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a008afaedf9..931ca3a30773 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			     ~(BIT(HPG_vmemmap_optimized) |
+			       BIT(HPG_raw_hwp_unreliable) |
+			       BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio)
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-- 
2.54.0 (Apple Git-157)

