Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597392;
	b=g2ABmda/O8Kihp0Bf648YTdPpaCzD1AND4tGx93CGkCPnVzyV+4rUwMjDo7+KWdPgdak
	 1o2hbf4HROr1URpaKj2llGTf5O1naop24sh7M/m/E2wIM8V/YT8oHzqG8KJ6Fg5h0cIbo
	 QimUV7qsqEP+6E2B5W6AkgZeX5R99PaRQZxm8ATbSpYK1ogQG3MOVNsuwdC2Va5/cEzDb
	 JPScYqLvuIuatydGFtxr0pjCGdatrGZgQyhQfWQkuCOrWPEEdSowguRwzXARvpGfi8ZD4
	 JRCOHHrFDJFidjpM4wDQf+RjRfUGGLdjC0YzRwvWFJBYd8306T21S42Vx8Wp0ZXztYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597392;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=bWkWUhRxPDvXoa6KMlal8YtHGvJibFgZ+pmIbzWzfpI=;
	b=ToTfxQmatdc/FfnIzdOVt8dwJ2Kp3vy4M+IBCuWaAHjOps1rbI+uWbj+vHClnbtDRyix
	 bd6mraEKLe7ts+/glKGiVu/YtCD6DN6tFjohpklur+5+Ptm1Auj3vQVruuH1b8fMKs4D8
	 3yLr4sOqvOLTINnIKo+o3YXq83IAC7bxywe8OWZawzmhxr8Bxxe8NI58fP4dWu/ZREne3
	 HTuBJgLhZ0N6MDMX3lyTwfBDsRehG36ol8lpSkGZ6Ap9m/8YcwGabcZYyOO2LyYCl7MVm
	 TMC3zmsbmY2C42GoexJw6gY1LPGH4eqMJsYhcYYjN+k2qrWlfQT3TYwNAkHxuliPwxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BkmMaiWA;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99078606A31F
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99078606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BkmMaiWA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWkWUhRxPDvXoa6KMlal8YtHGvJibFgZ+pmIbzWzfpI=;
	b=BkmMaiWA86DA3XAwrNYY496qY3mHMoJpCyXeupaLMbgsSOjaTeTnpceCLeko9F+H1tasbM
	r4og+anF7as/MiHYjvzHtBvrmYmvUOfzkYoGoGhPQXlxTyVBq1+ciENpOlPHu7IQLz85k3
	HzWFQGMU2YpgWHAPX7LSL9NNbXYw00U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-jFNxnYdKMlaImvgI6R0zEg-1; Wed,
 21 Oct 2026 11:43:03 -0400
X-MC-Unique: jFNxnYdKMlaImvgI6R0zEg-1
X-Mimecast-MFC-AGG-ID: jFNxnYdKMlaImvgI6R0zEg_1792597379
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BCC718007FE;
	Wed, 21 Oct 2026 15:42:58 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2202E18005AD;
	Wed, 21 Oct 2026 15:42:49 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:22 +0200
Subject: [PATCH RFC v2 1/8] memcg: Add MEMCG_DMABUF accounting
 infrastructure
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
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-1-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=8161;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=uQH7UhskNWoMAVf3cHwhudyW2OlVTtHrF31AhHpWtUI=;
 b=nsHRl/ZgVbi4E0QPaytAAh7L9X39h8F5H46BFOjlKcT/OoYIbi+O9KCY/PcAh1aGuaUi8pmr9
 wKtBuHz9OvPDC1QNK62PhlWdcIGbE5BuOq8HpfQc47zUtc4UjR1IJc9
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: "T.J. Mercier" <tjmercier@google.com>

Introduce a MEMCG_DMABUF stat counter and helpers for charging,
and uncharging dma-buf memory against a memory cgroup:

The charge is tracked on struct dma_buf via a new memcg pointer. The
page count is derived internally from PAGE_ALIGN(dmabuf->size), and
the memcg reference is stored into (or cleared from) dmabuf->memcg by
the helpers themselves, removing the need for callers to manage those
details. The release path in dma_buf_release() is reduced to a single
mem_cgroup_uncharge_dmabuf() call.

This decouples accounting from the backing page allocator, avoiding the
need for every exporter to pass __GFP_ACCOUNT and enabling cross-cgroup
charge transfer, which is impractical with page-level accounting.

Remove __GFP_ACCOUNT from system-heap page allocations (added by
commit 3c227be90659 ("dma-buf: system_heap: account for system heap
allocation in memcg")) to avoid double counting once callers adopt
this path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 +++
 drivers/dma-buf/dma-buf.c               |  3 ++
 drivers/dma-buf/heaps/system_heap.c     |  2 --
 include/linux/dma-buf.h                 |  4 +++
 include/linux/memcontrol.h              | 20 ++++++++++++
 mm/memcontrol.c                         | 54 +++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..a3265a4a953e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1662,6 +1662,10 @@ The following nested keys are defined.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  dmabuf (npn)
+		Amount of memory used for exported DMA buffers allocated by the cgroup.
+		Stays with the allocating cgroup regardless of how the buffer is shared.
+
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4c9add51f9ef..f31f49ebd0af 100644
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
@@ -180,6 +181,8 @@ static void dma_buf_release(struct dentry *dentry)
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
+	mem_cgroup_uncharge_dmabuf(dmabuf);
+
 	dmabuf->ops->release(dmabuf);
 
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..0a99ac0183a8 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -388,8 +388,6 @@ static struct page *alloc_largest_available(unsigned long size,
 		if (max_order < orders[i])
 			continue;
 		flags = order_flags[i];
-		if (mem_accounting)
-			flags |= __GFP_ACCOUNT;
 		page = alloc_pages(flags, orders[i]);
 		if (!page)
 			continue;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..23ec0ff23fba 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,7 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct mem_cgroup;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -429,6 +430,9 @@ struct dma_buf {
 
 		__poll_t active;
 	} cb_in, cb_out;
+
+	/** @memcg: the cgroup to which this buffer is currently attributed */
+	struct mem_cgroup *memcg;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..aa08fbb0c26c 100644
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
@@ -40,6 +43,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 	MEMCG_NR_STAT,
 };
 
@@ -667,6 +671,9 @@ int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
+			      gfp_t gfp_mask);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -682,6 +689,8 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1167,10 +1176,21 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf,
+					    struct mem_cgroup *memcg,
+					    gfp_t gfp_mask)
+{
+	return true;
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
index 856a7d07586c..e94222237d31 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -69,6 +69,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include <linux/dma-buf.h>
 
 #include <linux/uaccess.h>
 
@@ -442,6 +443,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1625,6 +1627,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	{ "hugetlb",			NR_HUGETLB			},
 #endif
+	{ "dmabuf",			MEMCG_DMABUF			},
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -5658,6 +5661,57 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * mem_cgroup_charge_dmabuf - charge a dma-buf to a memcg
+ * @dmabuf: buffer to charge
+ * @memcg: memcg to charge; caller must hold a reference
+ * @gfp_mask: reclaim mode
+ *
+ * Charges the memory backing @dmabuf to @memcg and, on success, stores
+ * @memcg in @dmabuf->memcg (transferring the caller's reference).
+ * Returns %true on success, %false if the charge would exceed the limit.
+ * On failure the caller retains its reference to @memcg.
+ */
+bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
+			      gfp_t gfp_mask)
+{
+	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+
+	if (mem_cgroup_disabled())
+		return true;
+
+	if (try_charge(memcg, gfp_mask, nr_pages))
+		return false;
+
+	mod_memcg_state(memcg, MEMCG_DMABUF, nr_pages);
+	dmabuf->memcg = memcg;
+	return true;
+}
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a successful mem_cgroup_charge_dmabuf(). Drops the memcg
+ * reference stored in @dmabuf->memcg and clears the pointer.
+ * Safe to call when @dmabuf->memcg is %NULL.
+ */
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+	unsigned int nr_pages;
+	struct mem_cgroup *memcg = dmabuf->memcg;
+
+	if (!memcg)
+		return;
+
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	dmabuf->memcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0

