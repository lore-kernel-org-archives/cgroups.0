Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525465;
	b=vzayMsCnIml5dk96c1UyunhIJH5UljQeEnNjAmfwIGRoNcxyouDvljhWwajoLvpBhTVu
	 BuRClqxWpQhp5K5tAp/YuLvU1b/MaRpko1cZLH8raf3a5/B5txsR90EOSI0D6nNCWlQSO
	 HiHfYtrPj4MjEC4f8yXAd00UScuuLg/2khz0UQSGHcdz6Z2XxQYp82Cjo9fvoQ412mx8a
	 cygCYRFnZZfMTAX/WF4Wy0f5KR8P1okNUHtqMypG/i9kFgAX7M+vWcBfMGO6VwIDuiDZO
	 9t3QjOKpD5MQWoyAvL8L00CIJYnOz2TGH3jk4AMPC9/Gt8MYqsYtdq1NyV3FR49/zvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525465;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=UhXFRDgklqWJZXsQBXehAnqcTgNEWphuWxxYPXa/PkM=;
	b=iyvcqX737HN1BJw/gf3wV2YCUMzJbsp1ZJEnZ4SooP9tznUtMT2+Hwye6sbNFs3zWQTU
	 cxZaD8GhLvuJ9e1CEABB7tjGznBtWFgXIMkhevTmrXupJOIPiJN9T3k5zYXONZkJIvlBH
	 8zwp8tcEwHBDZyJ63JR2Zblj7KJxKK8m42D2ZkDZ4FPugKynV8Y8vkpRtVxlDeGcG2JSe
	 8n9ocf1L5DDKmrIqMNM+5FZzyzvy3iNDUtfR3yFjIHNrz5sdhTIK+obMHPTxQLW4R72U+
	 Nk2aVcZ+Nfpkd20jYXn6z5WOR6KK2LN8bBs0FWnmxD++lfkDdBirU4+QLKMvy9mmbLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gNTNF6gB;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EC1606A33F
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 13:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95EC1606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gNTNF6gB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhXFRDgklqWJZXsQBXehAnqcTgNEWphuWxxYPXa/PkM=;
	b=gNTNF6gBmigWIz0cpH89lLrl2jb6ThW9qcCW+TytDSL8Ib1yrbdp04kc5QVKvzQinBQpEk
	isy1h7YdnbTqcynJZyU17wODIGT1Md4ziZP/1I+rOsL4kFeZF5fVwl+tiDIQsiZ6QxzjF2
	GeabC6qmtcgcHdpj1mtuNMmUSsUczVI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-ze27s0z_PEedshaj3hlIMA-1; Tue,
 24 Nov 2026 13:04:18 +0000
X-MC-Unique: ze27s0z_PEedshaj3hlIMA-1
X-Mimecast-MFC-AGG-ID: ze27s0z_PEedshaj3hlIMA_1795525452
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6410318E68F7;
	Tue, 24 Nov 2026 13:04:07 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47DB6195B3C0;
	Tue, 24 Nov 2026 13:03:58 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:35 +0100
Subject: [PATCH v6 1/7] memcg: Add MEMCG_DMABUF accounting infrastructure
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-1-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=9939;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=1XCKfoay3P/PvghqteXO1nZtigYh1r/G5WRXoLX24sg=;
 b=nNMdn2CuPc24ib8ePxWV3xu1+WxCQY53IpE9BIiPmBB9g3nYJNSB+OEr4uOOOLy+0M+LOeHx5
 7OPhdKGZeYtAWWl72ilAclEzeZJptNOsdqstyCSsxBZvA0LDZM+Npdn
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: "T.J. Mercier" <tjmercier@google.com>

Introduce a MEMCG_DMABUF stat counter and helpers for charging,
cancelling, and uncharging dma-buf memory against a memory cgroup.

The charge is tracked on struct dma_buf via a new objcg pointer.
The object cgroup reference is stored into (or cleared from)
dmabuf->objcg by the helpers, removing the need for callers to manage
those details. The release path in dma_buf_release() is reduced to a
single mem_cgroup_uncharge_dmabuf() call.

obj_cgroup_reserve_dmabuf() takes nr_pages as unsigned long and
rejects values above INT_MAX. This differs from the rest of memcg
API. Specifically, dma-buf sizes can be userspace-controlled
and long-sized (size_t), while memcg charge and stat updates are
int-sized. Charges that pass the reservation are therefore safe
to handle as unsigned int in the export, transfer, and uncharge
paths.

Rather than charging at the page level via __GFP_ACCOUNT, which
would require exporters to expose their backing pages for
cross-cgroup transfer via new dma_buf_ops, charges are tracked
externally on struct dma_buf through a single accounting path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |   4 ++
 drivers/dma-buf/dma-buf.c               |   3 +
 include/linux/dma-buf.h                 |   4 ++
 include/linux/memcontrol.h              |  32 +++++++++
 mm/memcontrol.c                         | 112 ++++++++++++++++++++++++++++++++
 5 files changed, 155 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..f1f6808c5600 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1666,6 +1666,10 @@ The following nested keys are defined.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  dmabuf (npn)
+		Amount of memory used for exported DMA buffers allocated by the cgroup.
+		Stays with the allocating cgroup regardless of how the buffer is shared.
+
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0dac2c4fb968..945438b88fab 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/memcontrol.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
@@ -182,6 +183,8 @@ static void dma_buf_release(struct dentry *dentry)
 
 	dmabuf->ops->release(dmabuf);
 
+	mem_cgroup_uncharge_dmabuf(dmabuf);
+
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
 		dma_resv_fini(dmabuf->resv);
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..2f56afd1f830 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,7 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct obj_cgroup;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -429,6 +430,9 @@ struct dma_buf {
 
 		__poll_t active;
 	} cb_in, cb_out;
+
+	/** @objcg: object cgroup to which this buffer is currently attributed */
+	struct obj_cgroup *objcg;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..46fbb418bf39 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -10,6 +10,9 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
+
+struct dma_buf;
+
 #include <linux/cgroup.h>
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
@@ -41,6 +44,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 	MEMCG_NR_STAT,
 };
 
@@ -688,6 +692,9 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg, gfp_t gfp,
+			       unsigned long nr_pages);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -703,6 +710,11 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg, unsigned long nr_pages);
+
+void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf);
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1203,10 +1215,30 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg,
+					     gfp_t gfp,
+					     unsigned long nr_pages)
+{
+	return true;
+}
+
+static inline void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg,
+					    unsigned long nr_pages)
+{
+}
+
+static inline void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf)
+{
+}
+
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
 
+static inline void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+}
+
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..e4a9af2fdaa3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -70,6 +70,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include <linux/dma-buf.h>
 
 #include <linux/uaccess.h>
 
@@ -459,6 +460,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1644,6 +1646,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	{ "hugetlb",			NR_HUGETLB			},
 #endif
+	{ "dmabuf",			MEMCG_DMABUF			},
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -5826,6 +5829,115 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * obj_cgroup_reserve_dmabuf - charge an object cgroup for a dma-buf allocation
+ * @objcg: object cgroup to charge (may be %NULL)
+ * @gfp_mask: reclaim mode
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages against @objcg. Call this before allocating pages so
+ * the cgroup limit is enforced up front. On success the caller must
+ * finalize the charge with the MEMCG_DMABUF stat update, or call
+ * obj_cgroup_cancel_dmabuf() to undo it.
+ *
+ * @nr_pages is derived from the buffer size, which may be controlled by
+ * userspace, so it is taken as unsigned long and rejected above what
+ * a single memcg charge can account.
+ *
+ * Returns %true on success, %false if @nr_pages is too large or the
+ * charge would exceed the limit.
+ */
+bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg, gfp_t gfp_mask,
+			       unsigned long nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	if (!objcg || mem_cgroup_disabled())
+		return true;
+
+	/* a single memcg charge accounts at most INT_MAX pages */
+	if (nr_pages > INT_MAX)
+		return false;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge(memcg, gfp_mask, nr_pages);
+	mem_cgroup_put(memcg);
+	return !ret;
+}
+EXPORT_SYMBOL_GPL(obj_cgroup_reserve_dmabuf);
+
+/**
+ * obj_cgroup_cancel_dmabuf - undo a dma-buf charge
+ * @objcg: object cgroup to uncharge (may be %NULL)
+ * @nr_pages: same value passed to obj_cgroup_reserve_dmabuf()
+ *
+ * Returns @nr_pages of charge to @objcg. Use when the allocation fails
+ * after obj_cgroup_reserve_dmabuf().
+ */
+void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg, unsigned long nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	if (!objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+}
+EXPORT_SYMBOL_GPL(obj_cgroup_cancel_dmabuf);
+
+/**
+ * mem_cgroup_commit_dmabuf - finalize a dma-buf charge
+ * @dmabuf: buffer whose charge is being finalized
+ *
+ * Adds @dmabuf's size to the %MEMCG_DMABUF stat of the cgroup its object
+ * cgroup currently resolves to. Call after obj_cgroup_reserve_dmabuf()
+ * succeeded and the buffer is about to be exported. Safe to call when
+ * @dmabuf->objcg is %NULL.
+ */
+void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf)
+{
+	struct mem_cgroup *memcg;
+
+	if (!dmabuf->objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(dmabuf->objcg);
+	mod_memcg_state(memcg, MEMCG_DMABUF,
+			PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT);
+	mem_cgroup_put(memcg);
+}
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its object cgroup
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a finalized dma-buf charge. Drops the object cgroup
+ * reference stored in @dmabuf->objcg and clears the pointer.
+ * Safe to call when @dmabuf->objcg is %NULL.
+ */
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+	struct obj_cgroup *objcg = dmabuf->objcg;
+	struct mem_cgroup *memcg;
+	unsigned long nr_pages;
+
+	if (!objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	obj_cgroup_put(objcg);
+	dmabuf->objcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0

