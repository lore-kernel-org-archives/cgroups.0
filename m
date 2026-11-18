Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035840;
	b=CIg3RICN2mbknC6Ew/uUhHpGp+paOqAxuH9OJd12JwA4dR8gZVzBva7vAer/ErYcO+8P
	 B4GyHtAAudR0XExPJKFer2VXZyltltaqRzvLTYXVNrDe7bQ6+jgMAachq4NwAYOLvaCNq
	 7CMJ+FyX2KaCIwf7IBzDcIvJgXplTUT+3qkeuTL/3VGYVd2OVbUIGrGe2eIDapw7wdD/O
	 S+EHTWVHmpnHDLVChhbm+Y7y635EG7+NXYv9hV8DrfHnZjsXuoful/6i2VTRO8TSHpqMF
	 CWlIg5YU6CjFubYOAimqqUQVPGxMOgeZUZs1Cljf40sau3NnCO5QkEjVomSrcfi5sXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035840;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=R2yASS0x3x8c7o6X04EtN6nfsCIUJMcX+xcEFYA2RvU=;
	b=Fa965rvsyVZLuUMdi8sNXo0A3matt2uMBOe1HBmSImubELYHRTBYBn0sOjApkiCn/88u
	 NX32sSPrsN3Ve9GiRH4U4PASG5D7mOFKPHxC00HC40tvCqDZsPd8uXJC9EhB0L3YC7AGs
	 3arvLfWjJvBX8ogK7XdD0+OfYXgf8ZtPLYHCKcKS4MQvBausCIdVB+c1ERWCMLW4jnh7b
	 mEsQ7zgZgp+C+RVY0O4NZCe+Rl0MQQ5yyevRtdUSTCXQGKjbBKIV83EH1zpzVPJjQ3l32
	 /ZM4zTm472lmHFf8xR5AjY2+Iw11CUSkrraHDx4uUtD5kvsVfZkcNUkHWN7E2IyNLJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdwPx1Mz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C75260A6F7E;
	Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdwPx1Mz
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035840;
	b=pwBX3+8HNMuWlIrj6sqJPCH70CgGlhUTYsZ+osEz6wTk+wLrtDaVzars9Xh0wy5LaW5+
	 zJ2wgr/H+Lg3N53xDmt545ItmVNVPKmXRYwFFZPXJWV9rZVb2ZCAHZ/GPEgRdptFnf7yS
	 p7WqLLqz9Ydf/vhh7AvT9KAxFmZnxjX9m10kziE43Pr1tHp1FPqaioaZsGbAOHR8fQRmn
	 eU+HPETuBjH7tSVTDRwp0DJ8oq4vreqOZPfS1+942gGwCCE245bR4xG5+Sz0ATGyx5a1O
	 iY4X6AxGMulmigm9L16txQvIJGN4LOu4koVJDwJb8yhw4+5fIFEsayRoLjfvbHV4fqQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=R2yASS0x3x8c7o6X04EtN6nfsCIUJMcX+xcEFYA2RvU=;
	b=iw1oMpCBISZ5Up197EKfcgFc0hn1B1MDVVKCxNy9/dEqgvVfrokSvSLEZXx+TkaHMHym
	 1PPsdCk7TsHNAD3uXiSGGrFeVzqaQxZG1u+0xzUq+WsAnGCzgVX5stsBvnDkqUl1wxd8/
	 IQd3I0KLYHKPQCphNK9Q7MrrZivrbMXjGLuCoxaFQllSWMj8xiNv2BhgDggjFqZrj5iKX
	 mmn86vjg2Vnpr57Dy5srZA+joaRk95Kti1csM2kGC+tSvzQ7siVx8AKat0NeuGYftrPlD
	 K39B3a+LsqHkSDy+VA7XCQGw++z42Dw+h15iEuEj4eTFKtzP9LChTds0ZvnsLS+3Ymw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1F47A1F01819;
	Wed, 18 Nov 2026 21:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035840;
	bh=R2yASS0x3x8c7o6X04EtN6nfsCIUJMcX+xcEFYA2RvU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EdwPx1MzRjAbzodSrWZ+6LLNox0VcPP84c7pbDWx5WckfB6FByPY+G/mXVqaNcbi3
	 JdkVbbOnDjmyYeq+swiwjP9WOS5A9WrD5cr+1vLkccdz4RMwlpCYFJjd7tDEe0+noI
	 SpWaq1P2UPJYYRoRBmhNy9ySDdJxYSsxFBe6ICwYWAZLuU97vGdm+cLYRSTXFgbagC
	 gdCt7v0xub4w4dC2UNpsJOdl7w0bwq9MtwYfYkoSxMdRVRZKy4m3FAJs+p/AhAcDlw
	 DQ3lB7/ypw47kyCSE2aS89Wv6SL38Lkt/V8iYbmtCA9TE1pIx6lSYe7ctGDGOmgaOo
	 fuCGtYtC4BlMA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CF22B4AFC7;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:49 +0800
Subject: [PATCH v5 17/17] mm/mglru: make folio_test_workingset() work based
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
Message-Id: <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=5663;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uTy2+XpciysxvPfP3ywWwGSNH419CnwoDfk4TzlDch8=;
 b=gPMVTMkXGxbz84pLQ8ToHpYWXlUSlW9vmxKrdCbl3IbFwvVCOD/FOYclIllZ3qW6RE0eKKn+Y
 3e0P4ranQKCCEjw0NcZi6C8HUE+dI6QIa+HjeWGPOaKne/5U/TAKpBp
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

Move the test into mm_inline.h as an inline helper based on
folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.  The set
stays a plain PG_workingset bit operation reserved for the
classical LRU: under MGLRU the refs count is maintained by
folio_inc_lru_refs(), and now triggers a debug WARN when called
while MGLRU is fully on (the switching window is exempt, as the
classical paths legitimately run alongside MGLRU then).  The one
PageWorkingset() user in erofs is converted to the folio helper.

Under the classical LRU the refs count is not maintained, so the
test is equivalent to the PG_workingset bit test, which is the old
behavior.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c     |  1 +
 fs/erofs/zdata.c           |  3 ++-
 include/linux/mm_inline.h  | 29 +++++++++++++++++++++++++++++
 include/linux/page-flags.h |  2 --
 mm/filemap.c               |  1 +
 mm/page_io.c               |  1 +
 6 files changed, 34 insertions(+), 3 deletions(-)

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
index 2c6cbd0df686..a2442e49aca2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -300,6 +300,23 @@ static inline void folio_migrate_lru_refs(struct folio *new, const struct folio
 	__folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET. Under the classical LRU flag encoding,
+ * this is just testing the PG_workingset bit.
+ * NOTE: folio_set_workingset() must not be used under MGLRU, as the
+ * folio refs are tracked by folio_inc_lru_refs() with rules.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return lru_refs_is_workingset(folio_lru_refs(folio));
+}
+
 #ifdef CONFIG_LRU_GEN
 static inline bool lru_refs_is_active(unsigned int refs)
 {
@@ -551,6 +568,18 @@ static inline void folio_clear_lru_refs(struct folio *folio)
 		folio_clear_referenced(folio);
 }
 
+/*
+ * For the classical LRU only: with MGLRU the PG_workingset bit is
+ * part of the folio refs count maintained by folio_inc_lru_refs(),
+ * and a raw set would corrupt it.  The switching window is exempt
+ * because the classical paths legitimately run alongside MGLRU then.
+ */
+static __always_inline void folio_set_workingset(struct folio *folio)
+{
+	VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
+	set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
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
index 648f783454c3..2939647940c1 100644
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


