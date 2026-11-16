Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827061;
	b=ls3ZHacK4nIGqD+vu2jXteCuEyVI5t7Zr1bpbQpZQIVJecWg/DJWJH1iW1/8KNTqHRin
	 LNla5+a6a8FKGuhQpKaMU6/bChK+qAZldr/CgX9/hQFlp4ga4dAqNoZ/kJd/uS6YiXsc/
	 aq7QWsR4cDiHEOs1HocAknBpnJnn53OI+RHn+5PjPJOPztIyTYVtrlh9YPsAZe8x/A9bw
	 Q+AWrpA6gWk0D5IwAHMafnWMZ4S8QU/8CWuK1T8QiCy/CMvUnwaK220xtBDUaltMHoXNB
	 Ux0yhvYYxv/EK2BFrUxobTu+Z59LXq5q5ewTsKfVAfkpYFOyHr+iCwN1/GyUtsC/J5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827061;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7dAcKypowp6pgdAJ+FuQHJX/9djNf1D5bjpko35/FA=;
	b=B5P7HA70aF87niGCsx3POqumEVpPoZimUubdIihmtWk8dv1jrKEQUHQdj+091iMeh30H
	 akAMQOJgDy41/xqKwUJlrRyckkwww8RAoTlodnkxDcPhx00OQYhbfH5f92Y2T9B/Z/alK
	 kqWSGRFRTnihYyj/0GdfLYVirjbLCIBdqJsrA7fKFhDKuCl+agUt5U/XB+aUNAbJJdKaA
	 +6n6uV58XvIkgXTQ8GJuBiaJsD0bF/HlV5DViI40QFA2kbW+nzkI/pZ7uaUQXYzbB+hc6
	 itcg3Y22tPr6KhQgy5qy+N4yXf7D8sS2FfGjBcQpe9k8SYpM2Lfj//SnNm3ylEwqfeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o3EpSNhx;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAC1606A334
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CAC1606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o3EpSNhx
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-170135e43c7so5232629c88.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827060; x=1795431860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7dAcKypowp6pgdAJ+FuQHJX/9djNf1D5bjpko35/FA=;
        b=o3EpSNhxGs0rDOqZE96Er076UTvnHTmp8kL/6pjj/6wc1TI+25cPULcqFcugBiSvcM
         AdawxH6Tv8t7QI1C+d+p2XvOt+Jmk+leYfzDQrpBGmIbnbHcANU8l4BMwBSxAnHSPdZG
         Qb/uXZf95+cxRa+yRLJSxUPaLvLzp+2pZVvsTNCa68edkyE4PsPngddo3/j/7cAafm4T
         BBQkvSYTK0R5zPiK+VNtuT34j2rSqrLmAu8gwSrYR8TmgKkB3ETIRiTZoA8u4+LkRpDp
         f76IIg/K4NJbjl6h721INpSE3kdXiAQkRtl5z3k68Obk/LXRuaNxYvddYu53P7pH2IL+
         Z0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827060; x=1795431860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7dAcKypowp6pgdAJ+FuQHJX/9djNf1D5bjpko35/FA=;
        b=a/K6bsMwex/A7xqmz+MksOrDae24Zbi1YBlcNVV6EnDXoHCRDxheEMnA6mVgbJNuSy
         1HGY0uGZvETN9Rb/No+5A+rjKbTIalZwyV/cjXBSe/zHM0GaEcFzZ6ztf5hHK+/kJBrm
         fgwzj9WhMdGyPeoPvaYWSlwn6K9R8l5B1vWWG8tMOVXGaFM5aAXSm27eNWNIsYKl3YXA
         vhtiJU4tLyZqH6N4Z1EtNW2MisSQRn3fe++CM8bwuGpTw8L58WmPwMtiA7pjEt3jjYTy
         MgKzODNYOofzqXBXSaZUbLUnXE4qTsjPi0pho7Vs+EW38wXVdzYbew4u7LvAIzO5YPvG
         kgWg==
X-Forwarded-Encrypted: i=1; AL+hErFzf8R5J3QW2uMoPzBtgk4qHe7XsXbPg/Wl7ikC1CNz5GRx+c7nMUwzNBNd9UiTkeDhsIb9iN/M@vger.kernel.org
X-Gm-Message-State: APuU4Z9gZDo5I5XqhLSXs+Ajxzs5WTHFEpzLGFImZAqUMtNQtqQUe82+
	8nXOgjt7HWlcRpQRC8tq08jzkPhjq03wVcZY8sWX20e178b25eG1/VFP
X-Gm-Gg: AYBFou2aWobCJA/ZA36Y9nrkdm7kKoMIbHjOsT715w62lmNl3gq1200bKVy/QhW1FlB
	ZZ08db7Z5pN6CYjvl0i5tBeQ4Z/rDB9U6Qs5JmpammBxfNDal+oDgVMsU7XndxnIV9Ndlh+Pzsx
	sYzw6rQWpZI4PDxAYwmH8Rswuwl1cf9eNzJF/Q7KdnPZqoOg+ohfAJS3ra0HPcshR5v5ZZfSSGt
	NnkbecuiEPbDijGZI5lMJ8Ae6U3mYo87RfDe4K/fPSeWfXVxiI6JqQf5UutSQlozZOI163Vlaoi
	LoRFK9YwbTlZqnNjepEdOMPseX2UBwkhbENhfRu3OSNqQKNklrbMhsOfZrpnP6Uf/LNF1PyiWjA
	rq/WwXRHoHwjv2PgfMt69XoSPtq4Rze3Zn+ArwEI/gEPmDa8dn4ZTwvJ2pihH6OfOi+rzQmw/ba
	5sy/CO+NqBwlW9kddEUMv/knZ6F0P+75VEkQkM1C9XEcEaw3UjSwJ+rpmltqawE6KegBsId1SOj
	KIxjJPp0zUVyHgi6fKcrpnpuja2BKhI27vcKZLlDvShJQwsG/8uM+vCIY6u5RR1ZXN3puYqhn1s
	KAhn0WNuJYughsU38RZ/D+RvAe6DG6lhJGUh5gGM80QnHTY=
X-Received: by 2002:a05:7022:1701:b0:1b4:f5cb:ebe3 with SMTP id a92af1059eb24-1b50311597dmr10189226c88.16.1794827059067;
        Mon, 16 Nov 2026 03:04:19 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:18 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 08/16] mm: memcomp: compress foreground batches asynchronously
Date: Mon, 16 Nov 2026 19:01:14 +0800
Message-ID: <20261116110122.309748-9-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
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

Foreground reclaim can have several eligible folios ready for
compression. Processing each request synchronously prevents a matching
asynchronous acomp provider from overlapping those requests.

Prepare bounded batches and submit through the standard asynchronous
compression API after unmapping and flushing source translations. Keep
requests, completions and payload buffers alive through completion and
backlog handling. Drain outstanding requests before releasing a batch
that cannot continue.

Consume completed payloads through the store and refresh transactions,
revalidating each folio before publication. Acquire store leases after
asynchronous waits so a suspended batch does not retain the synchronous
context lease. Fall back to synchronous compression when no batch is
available, and keep busy-folio handling within the current reclaim pass.

Carry finish-failure handling into deferred processing. Preserve
resident rollback, slot and producer ownership, object-cgroup refunds
and the ordinary swap fallback when compression finishes but reclaim
does not.

Keep task-side batching without a dedicated compression worker. Order
compressor selection and late registration so a matching asynchronous
form cannot change the chosen synchronous codec. Leave codec
implementations unchanged, and provide a KUnit-only asynchronous
provider for controlled completion and failure coverage.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h |  59 ++++++
 mm/Kconfig              |   4 +
 mm/memcomp.c            | 426 ++++++++++++++++++++++++++++++++++++++--
 mm/memcomp/anon_store.h |   3 +-
 mm/vmscan.c             | 248 ++++++++++++++++++++++-
 5 files changed, 727 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index cebad54a3844996c72cd3e413a7d6c7e05df953d..600de70efda7d547d8e9ad12932af7a4414b5beb 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -10,6 +10,7 @@
 struct folio;
 struct mc16_slot;
 struct mc16_cluster;
+struct memcomp_async;
 struct memcomp_reclaim_ctx;
 struct vm_fault;
 
@@ -24,6 +25,9 @@ struct memcomp_ref {
 	u32 token;
 };
 
+/* The most pages one asynchronous compression batch takes. */
+#define MEMCOMP_ASYNC_PAGES 32
+
 enum memcomp_reclaim_source {
 	MEMCOMP_RECLAIM_DIRECT,
 	MEMCOMP_RECLAIM_KSWAPD,
@@ -88,6 +92,23 @@ bool memcomp_reserve(struct folio *folio);
 /* A non-NULL *@ctxp lease is consumed and cleared on every return. */
 bool memcomp_store_after_unmap(struct folio *folio,
 			       struct memcomp_reclaim_ctx **ctxp);
+/*
+ * A batch to compress a run of folios asynchronously with, or NULL when the
+ * compressor cannot or none is free.  Submit each folio once it is unmapped,
+ * wait once, store each with memcomp_store_after_unmap_async(), and put
+ * the batch back.  All batches serve foreground reclaim; a spare batch is
+ * available only while another batch would remain free.
+ */
+struct memcomp_async *memcomp_async_get(void);
+struct memcomp_async *memcomp_async_get_spare(void);
+bool memcomp_async_submit(struct memcomp_async *async,
+			  struct folio *folio);
+void memcomp_async_wait(struct memcomp_async *async);
+bool memcomp_async_complete(struct memcomp_async *async);
+bool memcomp_store_after_unmap_async(struct folio *folio,
+				     struct memcomp_reclaim_ctx **ctxp,
+					 struct memcomp_async *async);
+void memcomp_async_put(struct memcomp_async *async);
 void memcomp_rollback_folio(struct folio *folio);
 bool memcomp_folio_dirty(struct folio *folio);
 bool memcomp_folio_incompressible(struct folio *folio);
@@ -233,6 +254,44 @@ memcomp_store_after_unmap(struct folio *folio,
 	return false;
 }
 
+static inline struct memcomp_async *memcomp_async_get(void)
+{
+	return NULL;
+}
+
+static inline struct memcomp_async *
+memcomp_async_get_spare(void)
+{
+	return NULL;
+}
+
+static inline bool memcomp_async_submit(struct memcomp_async *async,
+					struct folio *folio)
+{
+	return false;
+}
+
+static inline void memcomp_async_wait(struct memcomp_async *async)
+{
+}
+
+static inline bool memcomp_async_complete(struct memcomp_async *async)
+{
+	return true;
+}
+
+static inline bool
+memcomp_store_after_unmap_async(struct folio *folio,
+				struct memcomp_reclaim_ctx **ctxp,
+				    struct memcomp_async *async)
+{
+	return memcomp_store_after_unmap(folio, ctxp);
+}
+
+static inline void memcomp_async_put(struct memcomp_async *async)
+{
+}
+
 static inline void memcomp_rollback_folio(struct folio *folio)
 {
 }
diff --git a/mm/Kconfig b/mm/Kconfig
index 08d366b1593e048f09bb3bc1239add175394f842..4bd19dc449490d226d1dd5ce94235c2426cbc7c1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -217,6 +217,10 @@ config MEMCOMP_DEFAULT_COMPRESSOR
 	  for registration before trying zstd. Setup failures also fall back
 	  to zstd. Memcomp stays disabled if neither can be set up.
 
+	  The synchronous algorithm choice is final. A matching asynchronous
+	  implementation registered later can enable batched compression
+	  without changing that choice.
+
 config MEMCOMP_DEBUG_STATS
 	bool "Debug statistics for memcomp"
 	depends on MEMCOMP
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 465eb11b4ecf4e95967ea416e8141560f6a4bae4..f5110f46b857407c15c77c215238c9b6e99413c6 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -15,6 +15,7 @@
  */
 #define pr_fmt(fmt) "memcomp: " fmt
 
+#include <crypto/acompress.h>
 #include <crypto/algapi.h>
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
@@ -45,6 +46,7 @@
 #include <linux/preempt.h>
 #include <linux/printk.h>
 #include <linux/rmap.h>
+#include <linux/scatterlist.h>
 #include <linux/sched/cputime.h>
 #include <linux/shrinker.h>
 #include <linux/slab.h>
@@ -300,6 +302,38 @@ struct memcomp_direct_staging {
 	struct memcomp_ctx_timing_record timing;
 };
 
+/*
+ * A compressor with an asynchronous form compresses a foreground run
+ * of folios together: reclaim hands all of them over, waits once, and
+ * stores each with the payloads already made.  One request per page of the
+ * run, a folio's pages in a row; see memcomp_async_submit().
+ */
+struct memcomp_async_req {
+	struct acomp_req *req;
+	struct memcomp_async *async;
+	struct scatterlist src;
+	struct scatterlist dst;
+	void *buf;
+	/* The folio whose page this is, at its offset from its first. */
+	struct folio *folio;
+	unsigned int len;
+	int ret;
+	/* Set only by memcomp's full software scan, never by a codec error. */
+	bool same_filled;
+	/* The value the software scan found. */
+	unsigned long element;
+};
+
+struct memcomp_async {
+	/* Requests not yet done, plus one until the batch is waited for. */
+	atomic_t pending;
+	struct completion done;
+	unsigned int id;
+	/* Requests taken, from the first. */
+	unsigned int nr;
+	struct memcomp_async_req reqs[MEMCOMP_ASYNC_PAGES];
+};
+
 /* Borrowed under the locked source folio's OWNER; never put this carrier. */
 struct mc16_zero_carrier {
 	struct memcomp_ref ref;
@@ -310,6 +344,11 @@ struct mc16_zero_carrier {
 
 struct memcomp_store_ctx {
 	struct memcomp_direct_staging *staging;
+	/*
+	 * The payloads, made before the store from the same contents: the
+	 * request for the folio's first page, followed by one for each other.
+	 */
+	const struct memcomp_async_req *precomp;
 	/* The span's anon_vma reference, for the caller to drop once stored. */
 	struct anon_vma *anon_vma;
 	struct mc16_zero_carrier zero;
@@ -494,7 +533,7 @@ static DEFINE_PER_CPU(struct memcomp_decomp_ctx, memcomp_decomp_ctxs) = {
 static bool memcomp_enabled;
 static char memcomp_compressor[MEMCOMP_COMPRESSOR_NAME_LEN] =
 	MEMCOMP_DEFAULT_COMPRESSOR;
-/* Serializes synchronous compressor selection. */
+/* Serializes compressor selection and publication of an async pool. */
 static DEFINE_MUTEX(memcomp_select_lock);
 
 static bool memcomp_is_enabled(void)
@@ -593,6 +632,8 @@ static atomic64_t memcomp_raw_reject_huge = ATOMIC64_INIT(0);
 static atomic64_t memcomp_raw_reject_ge_page = ATOMIC64_INIT(0);
 static atomic64_t memcomp_raw_reject_zs_fallback = ATOMIC64_INIT(0);
 static atomic64_t memcomp_raw_reject_net = ATOMIC64_INIT(0);
+static atomic64_t memcomp_async_payloads = ATOMIC64_INIT(0);
+static atomic64_t memcomp_async_fail = ATOMIC64_INIT(0);
 static atomic64_t memcomp_reserve_entry_alloc_fail = ATOMIC64_INIT(0);
 static atomic64_t memcomp_refresh_state_fail = ATOMIC64_INIT(0);
 static atomic64_t memcomp_refresh_payload_fail = ATOMIC64_INIT(0);
@@ -2879,13 +2920,26 @@ static int memcomp_compress_result(int ret, unsigned int *dst_len,
 	return 0;
 }
 
+/* Recheck the software same-filled result before storing the payload. */
+static bool memcomp_same_filled_plausible(const void *src,
+					  unsigned int src_len,
+					  unsigned long element)
+{
+	const unsigned long *words = src;
+	unsigned int last = src_len / sizeof(*words) - 1;
+
+	return src_len == PAGE_SIZE && words[0] == element &&
+	       words[last / 2] == element && words[last] == element;
+}
+
 static int
 memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
 			       const void *src, unsigned int src_len,
 				   unsigned int *length,
 				   unsigned long *handle, u8 *pool_idx,
 				   bool allow_provisional_raw,
-				   struct memcomp_store_ctx *store)
+				   struct memcomp_store_ctx *store,
+				   const struct memcomp_async_req *precomp)
 {
 	struct memcomp_compress_timing_stamp compress_timing;
 	struct memcomp_direct_staging *staging = NULL;
@@ -2906,12 +2960,37 @@ memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
 
 	lockdep_assert_held(&ctx->lock);
 
-	if (page_same_filled(src, &element)) {
+	if (precomp && precomp->same_filled &&
+	    !memcomp_same_filled_plausible(src, src_len, precomp->element))
+		precomp = NULL;
+	/*
+	 * A software same-filled result follows the same full scan as a
+	 * synchronous store.
+	 */
+	if (precomp ? precomp->same_filled :
+		      page_same_filled(src, &element)) {
 		*length = 0;
-		*handle = element;
+		*handle = precomp ? precomp->element : element;
 		return 0;
 	}
 
+	/* The page has been compressed; all that is left is to store it. */
+	if (precomp) {
+		target = memcomp_select_pool_idx();
+		pool = memcomp_pools[target];
+		huge_class_size = zs_huge_class_size(pool);
+		allow_slow = ctx->background;
+		compressed = precomp->buf;
+		dst_len = precomp->len;
+		ret = memcomp_compress_result(precomp->ret, &dst_len,
+					      src_len);
+		if (!ret)
+			raw_reason = memcomp_payload_raw_reason(dst_len,
+								src_len,
+								    huge_class_size);
+		goto have_payload;
+	}
+
 	target = memcomp_select_pool_idx();
 	pool = memcomp_pools[target];
 	huge_class_size = zs_huge_class_size(pool);
@@ -2951,6 +3030,7 @@ memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
 		timing = &staging->timing;
 		preempt_enable();
 	}
+have_payload:
 	if (ret) {
 		memcomp_debug_inc(&memcomp_compress_fail);
 		return ret;
@@ -3045,7 +3125,8 @@ static int memcomp_prepare_payload(const void *src, unsigned int src_len,
 		return -EBUSY;
 	ret = memcomp_prepare_payload_locked(&ctx, src, src_len, length,
 					     handle, pool_idx,
-						 allow_provisional_raw, NULL);
+						 allow_provisional_raw, NULL,
+						 NULL);
 	WARN_ON_ONCE(!ctx);
 	memcomp_put_comp_ctx(ctx);
 	return ret;
@@ -3074,6 +3155,23 @@ memcomp_arch_prepare_to_swap(struct folio *folio)
  * between unmap and the payload store can map the original pages back.
  */
 
+/*
+ * The payload made beforehand for page @i of the folio @store is for, when
+ * one was and it says what compressing the page would: a size, that the
+ * page does not shrink, or that it is same-filled.
+ */
+static const struct memcomp_async_req *
+memcomp_store_precomp(const struct memcomp_store_ctx *store,
+		      unsigned int i)
+{
+	const struct memcomp_async_req *r;
+
+	if (!store || !store->precomp)
+		return NULL;
+	r = &store->precomp[i];
+	return !r->ret || r->ret == -E2BIG || r->ret == -ENOSPC ? r : NULL;
+}
+
 #include "memcomp/anon_store.h"
 
 /*
@@ -4256,10 +4354,11 @@ bool memcomp_folio_incompressible(struct folio *folio)
 
 static bool
 __memcomp_store_after_unmap(struct folio *folio,
-			    struct memcomp_reclaim_ctx **ctxp)
+			    struct memcomp_reclaim_ctx **ctxp,
+				const struct memcomp_async_req *precomp)
 {
 	struct memcomp_ctx_timing_record *timing;
-	struct memcomp_store_ctx store = { };
+	struct memcomp_store_ctx store = { .precomp = precomp };
 	enum memcomp_anon_store_fail failure;
 	struct memcomp_reclaim_ctx *ctx;
 	unsigned int nr_pages;
@@ -4304,7 +4403,299 @@ __memcomp_store_after_unmap(struct folio *folio,
 bool memcomp_store_after_unmap(struct folio *folio,
 			       struct memcomp_reclaim_ctx **ctxp)
 {
-	return __memcomp_store_after_unmap(folio, ctxp);
+	return __memcomp_store_after_unmap(folio, ctxp, NULL);
+}
+
+/*
+ * Asynchronous compression.  A batch lets a reclaimer compress its run of
+ * folios at once on a compressor that works on its own - a hardware engine,
+ * which otherwise has a CPU spin through every page - and sleep through all
+ * of them at once.  A shared pool of batches serves foreground reclaim.
+ * A run that finds none free is compressed synchronously in the store,
+ * as it would be without them.  A foreground reclaimer may have two, one with
+ * the compressor while it fills the other, but takes its second only while
+ * that leaves another free; see memcomp_async_get_spare().
+ */
+struct memcomp_async_pool {
+	struct crypto_acomp *tfm; /* Release-published after all batches. */
+	spinlock_t lock; /* Protects the free-batch bitmap. */
+	unsigned long free;
+	unsigned int nr;
+	struct memcomp_async *batches[BITS_PER_LONG];
+};
+
+static struct memcomp_async_pool memcomp_async_pool = {
+	.lock = __SPIN_LOCK_UNLOCKED(memcomp_async_pool.lock),
+};
+
+/* Take a free foreground batch, leaving @keep for another reclaimer. */
+static struct memcomp_async *
+memcomp_async_take(struct memcomp_async_pool *pool, unsigned int keep)
+{
+	struct memcomp_async *async = NULL;
+	unsigned int i;
+
+	spin_lock(&pool->lock);
+	i = find_first_bit(&pool->free, pool->nr);
+	if (i < pool->nr && hweight_long(pool->free) > keep) {
+		__clear_bit(i, &pool->free);
+		async = pool->batches[i];
+	}
+	spin_unlock(&pool->lock);
+	if (!async)
+		return NULL;
+
+	atomic_set(&async->pending, 1);
+	reinit_completion(&async->done);
+	async->nr = 0;
+	return async;
+}
+
+static void memcomp_async_give(struct memcomp_async_pool *pool,
+			       struct memcomp_async *async)
+{
+	/* Nothing may still be writing into a batch handed back. */
+	if (atomic_read(&async->pending))
+		memcomp_async_wait(async);
+	spin_lock(&pool->lock);
+	__set_bit(async->id, &pool->free);
+	spin_unlock(&pool->lock);
+}
+
+struct memcomp_async *memcomp_async_get(void)
+{
+	if (!memcomp_is_enabled())
+		return NULL;
+	/* Pairs with async_init's release publication of a late pool. */
+	if (!smp_load_acquire(&memcomp_async_pool.tfm))
+		return NULL;
+	return memcomp_async_take(&memcomp_async_pool, 0);
+}
+
+/*
+ * memcomp_async_get(), but only while another foreground batch would
+ * still be free after: for a reclaimer that has one out already, and would
+ * otherwise leave the next to come none.
+ */
+struct memcomp_async *memcomp_async_get_spare(void)
+{
+	if (!memcomp_is_enabled())
+		return NULL;
+	/* Pairs with async_init's release publication of a late pool. */
+	if (!smp_load_acquire(&memcomp_async_pool.tfm))
+		return NULL;
+	return memcomp_async_take(&memcomp_async_pool, 1);
+}
+
+void memcomp_async_put(struct memcomp_async *async)
+{
+	if (async)
+		memcomp_async_give(&memcomp_async_pool, async);
+}
+
+static void memcomp_async_done(void *data, int err)
+{
+	struct memcomp_async_req *r = data;
+	struct memcomp_async *async = r->async;
+
+	/* A backlogged request has been started; it completes later. */
+	if (err == -EINPROGRESS)
+		return;
+
+	r->len = r->req->dlen;
+	r->ret = err;
+	if (atomic_dec_and_test(&async->pending))
+		complete(&async->done);
+}
+
+/*
+ * Start compressing the pages of @folio in @async, each a request of its
+ * own.  The pages may be read any time until the batch is waited for, so
+ * their contents must already be what the store will keep: the folio is
+ * locked and unmapped, with the TLB flushed, and holds no more references
+ * than the store accepts.  Whatever then changes that also fails the
+ * store's own checks, which run again before the payloads are used.
+ *
+ * Returns whether the folio went in, which takes a request for every page,
+ * or room for them.  One that did not is compressed by the store, as usual.
+ * A same-filled page takes its request too, to pass the software scan
+ * result to the store without invoking the compressor.
+ */
+bool memcomp_async_submit(struct memcomp_async *async,
+			  struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	u32 flags;
+	unsigned int i;
+
+	if (!async || !folio_test_locked(folio) ||
+	    nr_pages > MEMCOMP_ASYNC_PAGES - async->nr)
+		return false;
+	if (folio_mapped(folio) || folio_maybe_dma_pinned(folio) ||
+	    folio_ref_count(folio) != 1 + nr_pages)
+		return false;
+
+	/* The batch bounds the number of outstanding requests. */
+	flags = CRYPTO_TFM_REQ_MAY_BACKLOG;
+	for (i = 0; i < nr_pages; i++) {
+		struct memcomp_async_req *r = &async->reqs[async->nr + i];
+		unsigned long element;
+		bool same;
+		void *src;
+		int ret;
+
+		r->folio = folio;
+		r->same_filled = false;
+		/* The store keeps these as they are, without a payload. */
+		src = kmap_local_folio(folio, i * PAGE_SIZE);
+		same = page_same_filled(src, &element);
+		kunmap_local(src);
+		if (same) {
+			r->ret = 0;
+			r->len = 0;
+			r->element = element;
+			r->same_filled = true;
+			continue;
+		}
+
+		sg_init_table(&r->src, 1);
+		sg_set_page(&r->src, folio_page(folio, i), PAGE_SIZE, 0);
+		sg_init_one(&r->dst, r->buf, PAGE_SIZE);
+		acomp_request_set_params(r->req, &r->src, &r->dst, PAGE_SIZE,
+					 PAGE_SIZE);
+		acomp_request_set_callback(r->req, flags,
+					   memcomp_async_done, r);
+		atomic_inc(&async->pending);
+		ret = crypto_acomp_compress(r->req);
+		/* Anything else, and the request is done without a callback. */
+		if (ret != -EINPROGRESS && ret != -EBUSY)
+			memcomp_async_done(r, ret);
+	}
+	async->nr += nr_pages;
+	return true;
+}
+
+/*
+ * Wait for every request of @async; call once, before using any of them.
+ * The compressor is doing the work meanwhile, so the wait is no load.
+ */
+void memcomp_async_wait(struct memcomp_async *async)
+{
+	if (async && !atomic_dec_and_test(&async->pending))
+		wait_for_completion_state(&async->done, TASK_IDLE);
+}
+
+/*
+ * Whether every request submitted in @async has completed, so that waiting
+ * for it would not sleep; ask before memcomp_async_wait() only.
+ */
+bool memcomp_async_complete(struct memcomp_async *async)
+{
+	return !async || atomic_read(&async->pending) == 1;
+}
+
+/*
+ * memcomp_store_after_unmap(), with the payloads @async made for @folio,
+ * if it made them.  A page whose request failed for any reason but the page
+ * not shrinking is compressed by the store itself.
+ */
+bool memcomp_store_after_unmap_async(struct folio *folio,
+				     struct memcomp_reclaim_ctx **ctxp,
+					 struct memcomp_async *async)
+{
+	const struct memcomp_async_req *precomp = NULL;
+	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned int i;
+
+	for (i = 0; async && i < async->nr; i++) {
+		if (async->reqs[i].folio != folio)
+			continue;
+		/* Taken in a row for the folio, which cannot have split. */
+		if (!WARN_ON_ONCE(nr_pages > async->nr - i))
+			precomp = &async->reqs[i];
+		break;
+	}
+	for (i = 0; precomp && i < nr_pages; i++) {
+		int ret = precomp[i].ret;
+
+		/* A software same-filled page has no compressed payload. */
+		if (precomp[i].same_filled)
+			continue;
+		if (!ret || ret == -E2BIG || ret == -ENOSPC)
+			memcomp_debug_inc(&memcomp_async_payloads);
+		else
+			memcomp_debug_inc(&memcomp_async_fail);
+	}
+	return __memcomp_store_after_unmap(folio, ctxp, precomp);
+}
+
+static void memcomp_async_free_batch(struct memcomp_async *async)
+{
+	unsigned int i;
+
+	for (i = 0; i < MEMCOMP_ASYNC_PAGES; i++) {
+		if (async->reqs[i].req)
+			acomp_request_free(async->reqs[i].req);
+		kfree(async->reqs[i].buf);
+	}
+	kfree(async);
+}
+
+/*
+ * Set up the batches when the compressor has an asynchronous form; the
+ * synchronous one stays what every other path uses.  Both are the same
+ * algorithm by name, so they make the same payloads.
+ */
+static void memcomp_async_init(struct memcomp_async_pool *pool,
+			       const char *compressor)
+{
+	unsigned int nr = min_t(unsigned int, num_possible_cpus(),
+				    BITS_PER_LONG);
+	struct crypto_acomp *tfm;
+	unsigned int i, j;
+
+	lockdep_assert_held(&memcomp_select_lock);
+	if (pool->tfm)
+		return;
+
+	tfm = crypto_alloc_acomp(compressor, CRYPTO_ALG_ASYNC,
+				 CRYPTO_ALG_ASYNC | CRYPTO_NOLOAD);
+	if (IS_ERR(tfm))
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct memcomp_async *async;
+
+		async = kzalloc(sizeof(*async), GFP_KERNEL);
+		if (!async)
+			break;
+		init_completion(&async->done);
+		async->id = i;
+		for (j = 0; j < MEMCOMP_ASYNC_PAGES; j++) {
+			struct memcomp_async_req *r = &async->reqs[j];
+
+			r->async = async;
+			r->req = acomp_request_alloc(tfm);
+			r->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+			if (!r->req || !r->buf)
+				break;
+		}
+		if (j < MEMCOMP_ASYNC_PAGES) {
+			memcomp_async_free_batch(async);
+			break;
+		}
+		pool->batches[i] = async;
+		__set_bit(i, &pool->free);
+	}
+	if (!i) {
+		crypto_free_acomp(tfm);
+		return;
+	}
+	pool->nr = i;
+	/* Late readers must see every request, buffer and free bit first. */
+	smp_store_release(&pool->tfm, tfm);
+	pr_info("async compression through %s, %u foreground batches\n",
+		crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm)), i);
 }
 
 static void memcomp_destroy_comp_ctxs(void)
@@ -4518,6 +4909,7 @@ static int memcomp_start(void)
 		memcomp_meta_shrinker->scan_objects = mc16_meta_shrinker_scan;
 		shrinker_register(memcomp_meta_shrinker);
 	}
+	memcomp_async_init(&memcomp_async_pool, memcomp_compressor);
 	/* Make every initialized resource visible before enabling callers. */
 	smp_store_release(&memcomp_enabled, true);
 	pr_info("using %s\n", memcomp_compressor);
@@ -4549,13 +4941,15 @@ static int memcomp_start(void)
 /* As long as the driver core waits for the modules a device's probe needs. */
 #define MEMCOMP_COMPRESSOR_WAIT	(10 * HZ)
 
-/* The startup decision is protected by memcomp_select_lock. */
+/* The startup decision and late async work share memcomp_select_lock. */
 struct memcomp_compressor_select {
 	struct delayed_work work;
 	struct notifier_block nb;
+	struct memcomp_async_pool *pool;
 	char *compressor;
 	unsigned long deadline;
 	bool decided;
+	bool started;
 };
 
 static void memcomp_select_worker(struct work_struct *work);
@@ -4568,6 +4962,7 @@ static struct memcomp_compressor_select memcomp_select = {
 	.nb = {
 		.notifier_call = memcomp_crypto_notify,
 	},
+	.pool = &memcomp_async_pool,
 	.compressor = memcomp_compressor,
 };
 
@@ -4597,8 +4992,11 @@ static void memcomp_select_worker(struct work_struct *work)
 	select = container_of(to_delayed_work(work),
 			      struct memcomp_compressor_select, work);
 	mutex_lock(&memcomp_select_lock);
-	if (select->decided)
+	if (select->decided) {
+		if (select->started)
+			memcomp_async_init(select->pool, select->compressor);
 		goto out;
+	}
 
 	if (crypto_has_comp(select->compressor, 0, 0) != 1) {
 		if (time_before(now, select->deadline)) {
@@ -4609,10 +5007,11 @@ static void memcomp_select_worker(struct work_struct *work)
 		}
 		pr_warn("compressor %s unavailable\n", select->compressor);
 	}
-	/* The synchronous compressor choice is final. */
+	/* The synchronous choice is final; keep listening for its async form. */
 	select->decided = true;
 	if (crypto_has_comp(select->compressor, 0, 0) == 1 &&
 	    !memcomp_start()) {
+		select->started = true;
 		goto out;
 	}
 
@@ -4622,6 +5021,7 @@ static void memcomp_select_worker(struct work_struct *work)
 			sizeof(memcomp_compressor));
 		if (crypto_has_comp(select->compressor, 0, 0) == 1 &&
 		    !memcomp_start()) {
+			select->started = true;
 			goto out;
 		}
 	}
@@ -4798,6 +5198,8 @@ static ssize_t __events_show(char *buf)
 			  "raw_reject_ge_page %llu\n"
 			  "raw_reject_zs_fallback %llu\n"
 			  "raw_reject_net %llu\n"
+			  "async_payloads %llu\n"
+			  "async_fail %llu\n"
 			  "reserve_entry_alloc_fail %llu\n"
 			  "refresh_state_fail %llu\n"
 			  "refresh_payload_fail %llu\n"
@@ -4868,6 +5270,8 @@ static ssize_t __events_show(char *buf)
 			  raw_reject_ge_page,
 			  raw_reject_zs_fallback,
 			  raw_reject_net,
+			  (u64)atomic64_read(&memcomp_async_payloads),
+			  (u64)atomic64_read(&memcomp_async_fail),
 			  (u64)atomic64_read(&memcomp_reserve_entry_alloc_fail),
 			  (u64)atomic64_read(&memcomp_refresh_state_fail),
 			  (u64)atomic64_read(&memcomp_refresh_payload_fail),
diff --git a/mm/memcomp/anon_store.h b/mm/memcomp/anon_store.h
index 110c315cbcad938385f826d77067adc5f661f190..c8749d315f2c63f28cdad7f48eac5aa1b926de6a 100644
--- a/mm/memcomp/anon_store.h
+++ b/mm/memcomp/anon_store.h
@@ -172,7 +172,8 @@ mc16_anon_refresh_full(struct memcomp_reclaim_ctx **ctxp, const void *src,
 		ret = memcomp_prepare_payload_locked(ctxp, src + i * PAGE_SIZE,
 						     PAGE_SIZE, &lengths[i], &handle,
 						     &pool, nr_pages > 1,
-						     nr_pages == 1 ? store : NULL);
+						     nr_pages == 1 ? store : NULL,
+						     memcomp_store_precomp(store, i));
 		if (ret)
 			goto payload_fail;
 		payloads[i].word = handle;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f11964567da39f3049282fa8c3ebe5b135c079b..064db53fabfe830ea260c776e91bfc7f4bc46dd9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1120,9 +1120,229 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+#ifdef CONFIG_MEMCOMP
+/*
+ * Anonymous folios shrink_folio_list() has reserved and unmapped for
+ * memcomp, kept back to be compressed together on a compressor that
+ * works on its own; see memcomp_async_get().  The reclaimer flushes the
+ * TLB once for all of them and sleeps once while they compress, instead of
+ * having a CPU spin through each page.  These batches serve direct reclaim,
+ * kswapd or MADV_PAGEOUT in the task performing the reclaim.
+ *
+ * A full batch is handed to the compressor and left with it while the next
+ * is unmapped; the one before is stored then, once this one is also with the
+ * compressor.  So the CPU unmaps and stores while the compressor compresses,
+ * instead of each waiting for the other.
+ *
+ * The context lease each store needs is taken after the wait, so a batch
+ * does not hold the limited store contexts while it compresses.  Failure
+ * to acquire a lease fails the store; an unmapped folio cannot fall back
+ * to swap without first restoring its mappings.
+ */
+struct memcomp_deferred_batch {
+	struct list_head folios;
+	unsigned int nr_pages;
+	struct memcomp_async *async;
+};
+
+struct memcomp_deferred {
+	/* The batch being filled, and the one before, with the compressor. */
+	struct memcomp_deferred_batch fill;
+	struct memcomp_deferred_batch busy;
+	enum memcomp_reclaim_source source;
+	/* Where shrink_folio_list() puts what it frees and what it keeps. */
+	struct folio_batch *free_folios;
+	struct list_head *ret_folios;
+	struct reclaim_stat *stat;
+	unsigned int nr_reclaimed;
+};
+
+/*
+ * Whether a folio about to be unmapped for its store can be kept back in @d,
+ * which takes a batch for it if it has none.  memcomp_defer() then keeps
+ * it back once it is unmapped.
+ */
+static bool memcomp_may_defer(struct memcomp_deferred *d,
+			      struct folio *folio)
+{
+	if (folio_nr_pages(folio) > MEMCOMP_ASYNC_PAGES)
+		return false;
+	if (!d->fill.async)
+		d->fill.async = memcomp_async_get();
+	return d->fill.async;
+}
+
+static void memcomp_store_deferred(struct memcomp_deferred *d,
+				   struct memcomp_async *async,
+				   struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct memcomp_reclaim_ctx *ctx;
+
+	if (folio_mapped(folio)) {
+		memcomp_count_unmap_fail(nr_pages);
+		memcomp_rollback_folio(folio);
+		goto activate;
+	}
+	/*
+	 * The lease is not held through the wait; there are few of them.  A
+	 * folio of a batch too small to have been submitted is compressed here.
+	 */
+	ctx = memcomp_reclaim_ctx_get(nr_pages, d->source);
+	if (!ctx || !memcomp_store_after_unmap_async(folio, &ctx, async)) {
+		memcomp_rollback_folio(folio);
+		goto activate;
+	}
+	if (folio_test_dirty(folio))
+		folio_clear_dirty(folio);
+
+	/* As shrink_folio_list() goes on with a stored folio. */
+	if (folio_maybe_dma_pinned(folio)) {
+		memcomp_finish_fail(folio, nr_pages);
+		goto activate;
+	}
+	if (!memcomp_release_folio(folio)) {
+		memcomp_finish_fail(folio, nr_pages);
+		goto keep;
+	}
+	folio_unlock(folio);
+	d->nr_reclaimed += nr_pages;
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(d->free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(d->free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(d->free_folios);
+	}
+	return;
+
+activate:
+	if (!folio_test_mlocked(folio)) {
+		folio_set_active(folio);
+		d->stat->nr_activate[folio_is_file_lru(folio)] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+keep:
+	folio_unlock(folio);
+	list_add(&folio->lru, d->ret_folios);
+}
+
+/*
+ * Compress small batches synchronously.  Deferring them adds submission and
+ * wakeup overhead without enough work to amortize those costs.
+ */
+#define MEMCOMP_DEFER_MIN_PAGES	8
+
+/*
+ * Store what @b has kept back, with what the compressor made of it if it was
+ * submitted, and give back its batch.
+ */
+static void memcomp_store_batch(struct memcomp_deferred *d,
+				struct memcomp_deferred_batch *b)
+{
+	struct folio *folio, *next;
+
+	memcomp_async_wait(b->async);
+	list_for_each_entry_safe(folio, next, &b->folios, lru) {
+		list_del(&folio->lru);
+		memcomp_store_deferred(d, b->async, folio);
+	}
+	memcomp_async_put(b->async);
+	b->async = NULL;
+	b->nr_pages = 0;
+}
+
+/*
+ * Hand what @d has kept back to the compressor, then store the batch before,
+ * which the compressor has had meanwhile; the new one is stored next time
+ * round.  Too few pages to be worth the compressor's while are stored
+ * straight away.
+ */
+static void memcomp_submit_deferred(struct memcomp_deferred *d)
+{
+	struct memcomp_deferred_batch *fill = &d->fill;
+	struct memcomp_deferred_batch *busy = &d->busy;
+	struct folio *folio;
+
+	if (list_empty(&fill->folios))
+		return;
+	/* No CPU may write through a stale entry once they are read. */
+	try_to_unmap_flush();
+	if (fill->nr_pages >= MEMCOMP_DEFER_MIN_PAGES)
+		list_for_each_entry(folio, &fill->folios, lru)
+			memcomp_async_submit(fill->async, folio);
+	memcomp_store_batch(d, busy);
+	if (fill->nr_pages < MEMCOMP_DEFER_MIN_PAGES) {
+		memcomp_store_batch(d, fill);
+		return;
+	}
+	list_splice_init(&fill->folios, &busy->folios);
+	busy->nr_pages = fill->nr_pages;
+	busy->async = fill->async;
+	fill->nr_pages = 0;
+	fill->async = NULL;
+}
+
+/* Compress and store all @d has kept back, and give back its batches. */
+static void memcomp_finish_deferred(struct memcomp_deferred *d)
+{
+	memcomp_submit_deferred(d);
+	memcomp_store_batch(d, &d->busy);
+	memcomp_async_put(d->fill.async);
+	d->fill.async = NULL;
+}
+
+/*
+ * Make room in @d for a folio of @nr_pages, submitting what it has if it is
+ * full.  A batch the compressor is done with is stored at once, so that its
+ * folios are not held locked longer than they have to be.  While one is with
+ * the compressor, the batch to fill next is taken now: if that would leave
+ * the pool none to spare, the one out is stored first and its batch taken
+ * back, rather than storing each folio by itself meanwhile.  Called before
+ * the folio's own context lease is taken: the stores take leases of their
+ * own.
+ */
+static void memcomp_defer_room(struct memcomp_deferred *d,
+			       unsigned int nr_pages)
+{
+	if (d->fill.nr_pages + nr_pages > MEMCOMP_ASYNC_PAGES)
+		memcomp_submit_deferred(d);
+	if (memcomp_async_complete(d->busy.async))
+		memcomp_store_batch(d, &d->busy);
+	if (d->fill.async || !d->busy.async ||
+	    nr_pages > MEMCOMP_ASYNC_PAGES)
+		return;
+	d->fill.async = memcomp_async_get_spare();
+	if (!d->fill.async) {
+		memcomp_store_batch(d, &d->busy);
+		d->fill.async = memcomp_async_get();
+	}
+}
+
+/*
+ * Keep back a reserved folio that is now unmapped, its TLB flush maybe still
+ * to come, for its store.  Returns false if it is to be stored now after all.
+ */
+static bool memcomp_defer(struct memcomp_deferred *d,
+			  struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	if (d->fill.nr_pages + nr_pages > MEMCOMP_ASYNC_PAGES ||
+	    !memcomp_may_defer(d, folio))
+		return false;
+	list_add_tail(&folio->lru, &d->fill.folios);
+	d->fill.nr_pages += nr_pages;
+	return true;
+}
+
+/*
+ * shrink_folio_list() returns the number of reclaimed pages
+ */
+#else
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
+#endif
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
 		struct reclaim_stat *stat, bool ignore_references)
@@ -1134,6 +1354,17 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
+#ifdef CONFIG_MEMCOMP
+	struct memcomp_deferred mc_deferred = {
+		.fill.folios = LIST_HEAD_INIT(mc_deferred.fill.folios),
+		.busy.folios = LIST_HEAD_INIT(mc_deferred.busy.folios),
+		.source = current_is_kswapd() ? MEMCOMP_RECLAIM_KSWAPD :
+						MEMCOMP_RECLAIM_DIRECT,
+		.free_folios = &free_folios,
+		.ret_folios = &ret_folios,
+		.stat = stat,
+	};
+#endif
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
@@ -1385,6 +1616,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				if (!memcomp_reserve(folio))
 					goto memcomp_fallback_swap;
 				memcomp_reserved = true;
+				memcomp_defer_room(&mc_deferred, nr_pages);
 				memcomp_ctx = memcomp_reclaim_ctx_get(nr_pages,
 								      memcomp_source);
 				if (!memcomp_ctx) {
@@ -1520,7 +1752,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto activate_locked;
 			}
 #ifdef CONFIG_MEMCOMP
-			if (memcomp_reserved) {
+			/* Or flushed and stored with others, below. */
+			if (memcomp_reserved &&
+			    !memcomp_may_defer(&mc_deferred, folio)) {
 				try_to_unmap_flush();
 				if (folio_mapped(folio)) {
 					memcomp_count_unmap_fail(nr_pages);
@@ -1545,6 +1779,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 		if (memcomp_reserved && !memcomp_stored &&
 		    !folio_mapped(folio)) {
+			if (memcomp_defer(&mc_deferred, folio)) {
+				memcomp_reclaim_ctx_put(memcomp_ctx);
+				continue;
+			}
+			/* It may have been unmapped for keeping back. */
 			try_to_unmap_flush();
 			if (folio_mapped(folio)) {
 				memcomp_count_unmap_fail(nr_pages);
@@ -1809,6 +2048,13 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				folio_test_unevictable(folio), folio);
 	}
 	/* 'folio_list' is always empty here */
+#ifdef CONFIG_MEMCOMP
+
+	memcomp_finish_deferred(&mc_deferred);
+	nr_reclaimed += mc_deferred.nr_reclaimed;
+	mc_deferred.nr_reclaimed = 0;
+#endif
+
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat);
 	nr_reclaimed += nr_demoted;
