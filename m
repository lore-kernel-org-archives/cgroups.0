Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959576;
	b=3CLCm/QEUkgqFGmGyCNGcFwfBR9YQXGhOV0y2uWzMnGHE+A7sP4SohtqNfuCOuTbq32X
	 8VgsO7gaCfU2QmPROzsTgPPuOPJ6TOz/XQFyMDwgwJ9OILAEVYP3IZc2uzOkDHSQpf4iR
	 dpwyKjcGZefWElAZGEq17A7AIAIGLqESwpnjmrV3LClYIPCcEO6qfM0Ss1qfQ0lXUtjJp
	 w9R6E5B6hugfG8W0WxS033YHG82NUdQvcSNDKJfLyesUR8ocp47aruywgcAgTgb0TPKWr
	 TUA+XQWzapb97y6rotMASbE5wteTLe+qebroD1U/Ub+NaLeB8O+JPgtZmOxhsCnoe3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959576;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=84LIFW+AvMdbqkXSFm047CRtvQ9GP0clJy2Lqj2p5f8=;
	b=Xg9MhhJMcWe6xp9ksTSHfyxpD4Ry6zlJjFmlISbf97dhUkVp5LnJwfWYFmR6xrXJ/loa
	 6S+ifEYLDiYGy3D0J5faZdtkiBPh9zRU9KqqyuM866iuQKfN4lX14vc1U2kmN+ngeJyor
	 gOnUefE/VYzAxJzqE3AGBknwDhmvu8/3kDrrMdVQU7UnpBpb/MoQHMnxZTDm/Zt++q/1Q
	 j586o2sFm824/xt2ZVFNpd3KoVJ6bihXEse+zloKJhQrM8gc8YO3ejdyF4nTvbuhne/+2
	 lBilElQc1S1NngKatrkw6IE1tX1tXvmatubYXMzXvMXFXjgbFKS57z932i7nNemvN3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IgGruhZp;
	arc=none smtp.remote-ip=95.215.58.176
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCF0606A329
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 10:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFCF0606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IgGruhZp
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9W5E0aTicTRcozWJfG/+L+M5IQx5AOnpXJfN4HLzHSs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959573; v=1; x=1794564373;
 b=IgGruhZpDLOXxyBCxUc7kPAa24gzvdY3E3hdfzGfdTdUF5ff7hZXhd4gSLMyKUpOSbrQP6Zf
 A+cK0kK2jrHRc0rpNtXRDqRn6YgJbPa/LSybGQBsev36mKcNlQAuY5MvKiDojbJROMFhJ1+h1ja
 yuudZFpe8iHYu9T0U5jnUa44=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9dea5587c19e644f;
	Fri, 06 Nov 2026 10:06:13 +0000
X-Mizu-Trace-ID: 9dea5587c19e644f
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
Subject: [PATCH v3 3/4] mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
Date: Fri,  6 Nov 2026 18:05:20 +0800
Message-ID: <20261106100521.30099-4-kaitao.cheng@linux.dev>
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

free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
allocated surplus folios can be freed before the counter has been
incremented.

This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
after its second surplus limit check. It also happens when
gather_surplus_pages() frees folios because a reservation cannot be
satisfied, or because concurrent pool changes leave excess folios
after the reservation succeeds.

These paths leave unmatched decrements, causing HugeTLB usage to be
underreported and potentially underflowing the counter.

Increment NR_HUGETLB before calling free_huge_folio() in both paths
to balance its unconditional decrement.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5b5353ff5ee2..31a92ed4165a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2140,6 +2140,8 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
+		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2384,9 +2386,13 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
+	 * These pages were not accounted in NR_HUGETLB, so balance the
+	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
+	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
-- 
2.53.0

