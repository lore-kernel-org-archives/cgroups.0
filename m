Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633645D5D5;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=nKBg86P4qFxIIZALyJjoynJX5ljB/puMCggr0/OaYdUoHncvVOTgpO2YscwiIO6Kj4DYbHsqPa/h39h0EN+5Fxv3QfFWEqZKQQ8IO0jHFgXQqaH+WAQ8yy/l4qIsCBIV7iqp+w0Odt5U5mN2CA16yobCGz2BJYfgv+SZyTHFB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=7XTSZ54VuyxsLQ8EW8ywMrv/5l0zWuujijQrt7Pcvak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q6DAEeF2j5qPlCe0hYFPPMoBXw//5bwl11mBFpSUeaXA3V1PCUrz3YaiQQ5/levH+qNRoaGUirEGYrMA7AhggqBBQnZngKpxdf3MpN1exKKf9zBIvRfYvuBFgrNqo6P0c30nRXDRU/A5SxrayXnYoLYaXBeGifzNgXeC86Br2DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugzi/Wco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugzi/Wco"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87CE8C2BCFF;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=7XTSZ54VuyxsLQ8EW8ywMrv/5l0zWuujijQrt7Pcvak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ugzi/WcoShNp/D/DCH+3feoSAi7gx1TxEeOYybBxLwuQx/FAZK1pCng4z66iCEdP+
	 OAN92X9SHTy1C1Q54xRLkHoGuIrkSGBO9FStW43D//pZl2TfSvf4tfu2g390cLcw50
	 ADbJ/NrkcLQrCM3AsoL+sdDK0A2ALaTmLObwL4GxAAyonArXR0meYdvxplyww3uAz/
	 mhmGWrJS0daVCuxvcsoV2p40e7iNe/r198E9EMnymkWrXbiCmQ6LT42ig8OtO0Fxnj
	 MDmUE9nAX+K9GWCS2Jh9vbb67GDnOkFZSugvsHHYEuLF8NJ09e4/c1wNNeY3JOYKZk
	 Ya+nLZY2sQSdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761C6C4453D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:19 -0700
Subject: [PATCH v4 11/16] WIP: mm: hugetlb: Make struct hugepage_subpool
 private to hugetlb_subpool.c
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-11-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2210;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lOjGCQX3/m/ifrV7JiSqPXOvpZ1jml5gEVW64pYajUU=;
 b=62CKcF92BwyBeZ4+JVII0ser/DgCEfN1PyHCWdGDtFmjFrAuQZH+HIAkkbwAgIhRX0bTFA9mn
 4K8I6LvaxRBBops7keMTrhLFMeObPf79bBddWfrNINpTiku9RWX/K7X
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

From: Ackerley Tng <ackerleytng@google.com>

Now that all filesystem and memory management subpool functions across
fs/hugetlbfs/inode.c and mm/ use getters, transition struct
hugepage_subpool out of the public header include/linux/hugetlb.h and
encapsulate it privately inside mm/hugetlb_subpool.c.

Replace the header definition with a forward declaration.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h | 13 ++-----------
 mm/hugetlb_subpool.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f36be371c6e88..074a45903973e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -18,6 +18,7 @@
 
 struct mmu_gather;
 struct node;
+struct hstate;
 
 void free_huge_folio(struct folio *folio);
 
@@ -34,17 +35,7 @@ void free_huge_folio(struct folio *folio);
  */
 #define __NR_USED_SUBPAGE 3
 
-struct hugepage_subpool {
-	spinlock_t lock;
-	long count;
-	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used page count, includes both */
-				/* allocated and reserved pages. */
-	struct hstate *hstate;
-	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
-	long rsv_hpages;	/* Pages reserved against global pool to */
-				/* satisfy minimum size. */
-};
+struct hugepage_subpool;
 
 struct resv_map {
 	struct kref refs;
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
index ac0f9057b4921..39413515a2722 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -14,6 +14,18 @@
 #include <linux/bug.h>
 #include "hugetlb_subpool.h"
 
+struct hugepage_subpool {
+	spinlock_t lock;
+	long count;
+	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
+	long used_hpages;	/* Used page count, includes both */
+				/* allocated and reserved pages. */
+	struct hstate *hstate;
+	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
+	long rsv_hpages;	/* Pages reserved against global pool to */
+				/* satisfy minimum size. */
+};
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)

-- 
2.55.0.229.g6434b31f56-goog


