Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790586;
	b=1TMt7piip6CzirvhGupnQzTR7/NOxBNIzT2mt69utluCtf+vZEB6hMVOVR+9tsKEC9tD
	 RPVeZ7yFetWTl/DVIZcqY1i6+xw+aCKr7xFHDgtTmbnPQvOMgfkaWTJu8DwwpDlK+ISYp
	 EE1CSEuFiivwG36+zCFZVQgmsbE5/lFdKwFyf4I6u8TakrNpMzvhtExyWcBDIiEyvz+Fk
	 YljXfp0DJG/NbmTGffoUsHsKQL6Ql0RLLHinZb3H9tRNH4CJ6PKMB8SfExuo4sWEZjmBH
	 +bIC+F2qQoXNZZxQDJmDI14AZ3Y0BqvYZtBlk3HCW3BoBdZyHxklkRaQQZ75t9t+vUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790586;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=Qp9nScG11GrqgBlItXNhzVMsZBJCyQddn8ogzPVCmMI=;
	b=mFNwBWRq5hIqNttL5fGWcCQCxyMZepp5SMK9dhLscASBDBVuuFi8S5sUuXk++NcU34Lx
	 CEgIs/YlIGUFiEehzOLFSS4/6qRs6KwyWRY5U/pWugAIIIprKjQvYM6RxfiQTRofNBup2
	 eu7t63DAQ3rM2EhtwpsZXHifCh4kr9kghvQJtaGX44iBQzP611CSWsaZn6kN5okzSWHu/
	 S+G3SnS2qr+uYROk4s87tYv5OITmaHvnO7+3KcM6RFwI06hr26SF97tqiA1LBSQv3Xee0
	 xfZTzpRkYdN4BOB2Br9YiPck6TXMboM8kZL9l9jxBSdN7BUq+hZGBc/kzN2gG6+OOjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Txv0awtL;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50402606A339
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 11:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50402606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Txv0awtL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp9nScG11GrqgBlItXNhzVMsZBJCyQddn8ogzPVCmMI=;
	b=Txv0awtLMlOK5OV2j/NkokZoOsptGpPxKsb9RU/MqjRINJSCj4kU5vIvmGRhE22tivq/Wr
	yOiKBaw+WGKJ/2rQUp6khzeRtz6KruEzR096iWDerQ4kOaXCXRvsdymTLWqWoDYKoKshpb
	zCgTcbZ1WqyS6QgDRg+suGY8KpjRddE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-0SMqpboiMfCsn5fkXIFG0g-1; Wed,
 04 Nov 2026 06:09:38 -0500
X-MC-Unique: 0SMqpboiMfCsn5fkXIFG0g-1
X-Mimecast-MFC-AGG-ID: 0SMqpboiMfCsn5fkXIFG0g_1793790574
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DFB61956067;
	Wed,  4 Nov 2026 11:09:33 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E03FC1956088;
	Wed,  4 Nov 2026 11:09:24 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:10 +0100
Subject: [PATCH v4 1/8] memcg: Add MEMCG_DMABUF accounting infrastructure
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
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=7993;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Xd//d+OurkBWm68q76WSB58afqx3vEEkyNPsePwXKaE=;
 b=cwMwEzWH+QIsHY7DQWmY2jcf+y2i2MffYhODG5KKNEcLLQUFoJJzS9BkJKt3F9tumMDX2sD5z
 mjsrYqgmlqzCaAjnmXqPj5Pdqb/ceUKOGXG1f3XsCgmp026AIyK+V/w
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: "T.J. Mercier" <tjmercier@google.com>

Introduce a MEMCG_DMABUF stat counter and helpers for charging,
cancelling, and uncharging dma-buf memory against a memory cgroup.

The charge is tracked on struct dma_buf via a new memcg pointer.
The memcg reference is stored into (or cleared from) dmabuf->memcg
by the helpers, removing the need for callers to manage those
details. The release path in dma_buf_release() is reduced to a
single mem_cgroup_uncharge_dmabuf() call.

Rather than charging at the page level via __GFP_ACCOUNT, which
would require exporters to expose their backing pages for
cross-cgroup transfer via new dma_buf_ops, charges are tracked
externally on struct dma_buf through a single accounting path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 ++
 drivers/dma-buf/dma-buf.c               |  3 ++
 include/linux/dma-buf.h                 |  4 ++
 include/linux/memcontrol.h              | 27 +++++++++++++
 mm/memcontrol.c                         | 70 +++++++++++++++++++++++++++++++++
 5 files changed, 108 insertions(+)

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
index 4c9add51f9ef..1c6b9cee7ac2 100644
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
index 7d1c0ce189a8..4d1e82cf0833 100644
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
 
+bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
+			       unsigned int nr_pages);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -682,6 +689,10 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages);
+
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1167,10 +1178,26 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg,
+					     gfp_t gfp,
+					     unsigned int nr_pages)
+{
+	return true;
+}
+
+static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
+					    unsigned int nr_pages)
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
index 856a7d07586c..e53dd7eebc3b 100644
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
@@ -5658,6 +5661,73 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf allocation
+ * @memcg: memcg to charge (may be %NULL)
+ * @gfp_mask: reclaim mode
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages against @memcg. Call this before allocating pages so
+ * the cgroup limit is enforced up front. On success the caller must
+ * finalize the charge with the MEMCG_DMABUF stat update, or call
+ * mem_cgroup_cancel_dmabuf() to undo it.
+ *
+ * Returns %true on success, %false if the charge would exceed the limit.
+ */
+bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			       unsigned int nr_pages)
+{
+	if (!memcg || mem_cgroup_disabled())
+		return true;
+
+	if (try_charge(memcg, gfp_mask, nr_pages))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_reserve_dmabuf);
+
+/**
+ * mem_cgroup_cancel_dmabuf - undo a dma-buf charge
+ * @memcg: memcg to uncharge (may be %NULL)
+ * @nr_pages: same value passed to mem_cgroup_reserve_dmabuf()
+ *
+ * Returns @nr_pages of charge to @memcg. Use when the allocation fails
+ * after mem_cgroup_reserve_dmabuf().
+ */
+void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a finalized dma-buf charge. Drops the memcg
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
+	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	dmabuf->memcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0

