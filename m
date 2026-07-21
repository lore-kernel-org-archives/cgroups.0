Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816004028EE;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784602389; cv=none; b=HF/u06Zz/8jbP0v+tnt0ls2gSKZ2oa93k/ZZwf1JnmZRO74El1nLHxYlvPFxRVKhzKXuIauZP3IPn8uQRYatqvizi2q6bBBO1dHCs+ew9Swpthbo193as9RSdSsGcV5P5NOvRq+5BAzh/eHXTZH0a4koGQm/YrnKX5nAC1NkNSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784602389; c=relaxed/simple;
	bh=kSh9BQgS5QmHyKYjO89WZ2+3iTBXW5J+wxxG9vDVAJE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ByeBTkhczV81HC6cwaiNgHoHgjUdMnZFJ9jaerEfbvBWKi7hpvdDVp7cXcFY5H/SEtBo1qe1ZYsxloykB3iyDL0j7pv5BCygK4Yb7mWDZ/dpmCEwbbWqrMfbUPsTfhbgTviKN1z0mtxbIbn37+Dz/yzIcLNGt3K/3A+cXocamhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEHybAo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEHybAo+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23057C2BCFF;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=kSh9BQgS5QmHyKYjO89WZ2+3iTBXW5J+wxxG9vDVAJE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XEHybAo+2kZNVVGNyUv5FLdCH48YFNU3aR9zcL663YF8cgoDm5tEZG8C6kZrrD9ZQ
	 pUEKKPPhBB7T6MqJfWl8D1DxrKjorfKgwda1tcObkLEIva/ABl+y2OTShLxOpWAUfb
	 QGduIUi/81ESq7KJdMoxhAiAHjQNOB0vy63QE/d3RLQf52zMHPqaeVLUSCIrxY8MWQ
	 dda5HhbojUX3i6VuawQDBg8/VAFZfiNWnUISIbCVxcOkhCyA/wA09bHEvklUdRiWL1
	 2w8kogzEW4PrGK1QROYUWNaocIGPYtbMtZS3DnV3h1H2Tc2VCrX22TRJsV3ZO2u6oe
	 SKlAsthmOF/vg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF6AC44533;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:08 -0700
Subject: [PATCH v3 05/13] mm: hugetlb: Fix subpool usage leak on allocation
 failure
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-5-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=TxFD58wSA2jJAufxG4ptcnmkIwsdZTWOv5gzU++/HSs=;
 b=Cuw9IMu+njvxpvmnRk8QFmkwsKKjZPzSykOuLnRokUuqa3Z2CbGxGweoxUKCN7Lg7QoL0WSrH
 bxvolGurs8gCNt/+T6VZcrW5RuSxaR+OKnxfVIbStbxrn7DKeQ8rJkq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
was not used, but a global page was allocated instead), the subpool page
acquired via hugepage_subpool_get_pages() must still be returned.

Currently, the error path out_subpool_put: only calls
hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
skips it, permanently leaking the subpool's used_hpages counter.

With the earlier patch to always track used_hpages in the subpool, always
call hugepage_subpool_put_pages() if map_chg is true to consistently
restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
subpool (and global) reservation was used.

Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 061d7250c202d..3f6189d2d0188 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2859,7 +2859,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_chg;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3009,13 +3009,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg_rsvd);
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+
+		if (!gbl_chg)
+			hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
 

-- 
2.55.0.229.g6434b31f56-goog


