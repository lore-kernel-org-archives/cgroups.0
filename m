Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460028;
	b=t9WlI/WRgvBcCPal/jdpUZE/nO1PdGryXr/BRB6mOWe7NrOF+pLKS87NPIkTTiN6JEE0
	 3uJ25IgbI3aEmCDSmWV0GlJxzaWNr8m4+y+eysuPfPkTOkoAFGsk3c0dYFGwjGeOoUdbi
	 fOrOi8UjtbC7/uLY8dgiJZs3E2PPjVD8qzpqajsAzfhTWzIrdMIfIsm8FKWHZQbwg33W4
	 m5Wq/Fhpfyryq1jYsSnmnm+ClaRgMXypVhcxp4VxOCusb79xR1fb1LwaMcjl3A/oXK/xG
	 TBD8hrl1l9z8UF/IvAshG51YmZ5Ks/LNv2bq3Td3AVA54d79RvncWOnLNGKbHgt41Zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460028;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HW3m15cwOhOmCQi5QS7IBcTVWDziQbgROwHGLA00qiA=;
	b=kVk6uwIofZcyZPDZEKmVvQb3XALCD0dWyfqhV6558/UdjOlnwnwLlEiuc3jADalgmK5N
	 Let8gy+vOH/FoBjO/Qs1qvCx7A2ex8fdr8g8UyhJLxZceXR8cYpIYY4yOJbIfDm+NvtxB
	 lSkJI0tOr2rMa9ZwZ8++KoZ1VFzsRNQPa8YC2ysJG1VoCStPf8aV0Nv7qkGMDz5QWTK3B
	 +OmcAPwp5WClysW1PyyLyFrg7qj2o3uqruxaqIREcUann9D9f30nBJY14DbSZcDao2Sbp
	 6LHjGIGve7S2ZGaHCfYAMduo2f7/GEhPGg7JF+koRNmaOhqUtyzwGVeY5251HHqLopw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W+cWUfD+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C93A606A31A;
	Mon, 23 Nov 2026 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W+cWUfD+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460028;
	b=LVKkst8/8RbCJcBLVShOCW3aBlTfnAd4hc96P/GIpd8uElPc05bMXlaANMxJGgXGAWht
	 ETuD5k5CoNso83EZ9WNrMfuJkQToLkw4X3dbRB9aSVQhoomCHkszai9l5lsXv0EC1g3H8
	 I7ZCp6xqVclPXVtPHNcLRrQGm1EjHT7bjLb1n+g+oS6SvurOVkguDWTMcZJ6UBKgiG9FR
	 q0VyhMAzy6XTqT0pi4W3HqpaJujBw2QGYYGjxjyzFwU5KiOOgaMzsm35eB/xIjvsGFGYR
	 hS8sTRT2ddDxtKAzqkg9lYRfXUu2c981Abkb9lINEhFTrKyZjjJguckhoVxkWdAwMRQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460028;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HW3m15cwOhOmCQi5QS7IBcTVWDziQbgROwHGLA00qiA=;
	b=xbICeuFIOKvxVm/brVqwFuv3wFDuZiXB4Pkigo+6qCW8NnKfxouniyjHOWVc/WLYr4w7
	 A4SR6NKbI4YVrxoK/xtGOO2ynnGLPIHflAixvKgF3bVf5yBczT8cl3OL5jl8e0OkaZKPy
	 dGq5Y3vBtuT2E6OR5yDLYF6/CsF/qRTCjcQevUZW9aR/qHQX9XHZVZGwWzdeczkdlP6jt
	 rMA3CcU9+bbT5xL2UnpzjXe/ZHP3JrH3iREqdFGJEKyCZ+pxYspEGY8qkwBt83FBTTdF/
	 PeTkzOQrgazHLY8TWLp3ChjOl0f2hLvSBIK6zQbAop0jqYOxuvKwGle2l/n2LMxrzNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C19BF1F000EE;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460028;
	bh=HW3m15cwOhOmCQi5QS7IBcTVWDziQbgROwHGLA00qiA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=W+cWUfD+EV2139/AlMMM4kwHz10da/jilCMVMAEUXVfMtK2sUOxlDhGNwduDAWYT2
	 HUCPX+QZJDtSntZC4tbVt6P51m7/gw/tdd6ZWousNV/T/VwhfqfFt2JDIrZXNuSClR
	 wSSV8FgRMcXM+regetFS3wcP5IPS13HUN8dFEB0WZ0Lb4YB7SXfkiTD+vMt0AowxZs
	 9/ymI9ZhYu40lvEf5b0mLyN5M6ZVTD+60F097qdf7KNofx7gkLT393sYmfoEytb31c
	 rAcX+J4F4CqvQw1eTSKkYf4sgY6qACE8Yt1Uyp02feCtWlM1Qsr4YOZqTkp2D2OMp+
	 MZsJYZG0uPFkQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0038E4C669;
	Mon, 23 Nov 2026 18:53:02 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:08 +0800
Subject: [PATCH v6 16/18] mm/mglru: make PG_workingset helpers work based
 on folio LRU refs
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
Message-Id: <20261124-mglru-fg-v6-16-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=6298;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FeZ1X36y0gjLoNuGBhnIl7GXAntfQovoxU409olinNk=;
 b=1VQ9pndS33m4Kvn5Bxu4wL7Vfltv3HU9XfA3NipSyzY8gijlcuTI7FnfCR5lNBgS/0H+Szg78
 zZU1/x1iy0HCGin+8N0ZqTISRFUtg1fGvsKT9WkEUVt/8aQ4GtDYp8c
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

folio_test_workingset() currently tests the PG_workingset bit, which
is only the second lowest access bit of the folio LRU refs count now.
Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
and no longer have PG_workingset set, so the bit test misses them.

folio_set_workingset() currently sets the PG_workingset bit with a
plain set_bit(), which also over-promotes folios at a higher refs
count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
toward LRU_REFS_MAX and an earlier generation promotion.

Move both helpers into mm_inline.h, the test as an inline helper based
on folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.

The set stays reserved for the classical LRU, as under MGLRU the refs
count is maintained by folio_inc_lru_refs(): it now warns when the folio
is on a gen list, where the raw bit would corrupt its refs count.

MADV_COLD, the one caller that runs on an on-list folio, sets the
count with folio_set_lru_refs() instead. The one PageWorkingset() user
in erofs is converted to the folio helper.

There is no behavior change for the classical LRU: it does not maintain
the refs count, so for a folio that was never on a gen list the test is
equivalent to the PG_workingset bit test.

This prepares the convention for follow up MGLRU change.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c     |  1 +
 fs/erofs/zdata.c           |  3 ++-
 include/linux/mm_inline.h  | 30 ++++++++++++++++++++++++++++++
 include/linux/page-flags.h |  2 --
 mm/filemap.c               |  1 +
 mm/madvise.c               |  2 +-
 mm/page_io.c               |  1 +
 7 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ad90e14032db..127c5ee38979 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm_inline.h>
 #include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e981e371d6c2..34ee41e1ccdc 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -6,6 +6,7 @@
  */
 #include "compress.h"
 #include <linux/psi.h>
+#include <linux/mm_inline.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
@@ -1713,7 +1714,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_test_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 0f470ddf5c48..a4daf366e6aa 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -283,6 +283,21 @@ static inline void folio_migrate_lru_refs(struct folio *new, const struct folio
 	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET. Under the classical LRU flag encoding,
+ * this is just testing the PG_workingset bit.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return lru_refs_is_workingset(folio_lru_refs(folio));
+}
+
 #ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 {
@@ -544,6 +559,21 @@ static inline void folio_clear_lru_refs(struct folio *folio)
 		folio_clear_referenced(folio);
 }
 
+/*
+ * For the classical LRU or isolated folios only: with MGLRU the PG_workingset
+ * bit is part of the folio refs count maintained by folio_inc_lru_refs(),
+ * a raw set would corrupt it.  The warning below catches folios still on a
+ * gen list, the classical paths in the switching window only see off-list ones.
+ */
+static __always_inline void folio_set_workingset(struct folio *folio)
+{
+	unsigned long flags;
+
+	flags = set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset),
+			      BIT(PG_workingset));
+	VM_WARN_ON_ONCE(lru_get_gen_flags(flags) != -1);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b0ddc652e76c..f6625dc042da 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/mm/filemap.c b/mm/filemap.c
index dc0ceaa58a0f..acf5e562b732 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/leafops.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
diff --git a/mm/madvise.c b/mm/madvise.c
index 7e562e78d52a..e138082c518a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -378,7 +378,7 @@ static void madvise_cold_prep_folio(struct folio *folio)
 	if (!lru_gen_enabled()) {
 		folio_clear_lru_refs(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_set_lru_refs(folio, LRU_REFS_WORKINGSET);
 	}
 }
 
diff --git a/mm/page_io.c b/mm/page_io.c
index a57cdcf2892d..12deab296718 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
 #include <linux/writeback.h>

-- 
2.56.1


