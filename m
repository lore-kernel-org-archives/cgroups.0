Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827049;
	b=DOi1YSCJvnirtpTSqrK1U+1SQCzFX34LGmUep5cAV1jJ34+zIXOciIhhtgpuzpwmRt3Q
	 mGCyOyQtiXx5sMEfeEz+AQAWav59kEsoOPZG55Q9JqFMhgcxVl5QDsuXVkw14n4ttFTPl
	 Y4P7XIYz/kpeqFPay3jWB+uQx7gQcV4P22q02nLlVCAdIh/R1fFTGwka7pduZOzWP3q3u
	 2+yxRnSddGNQj9gf+aQDpB/YhBouW2z1ibleu4UIo8d5WPP4oV1XNySDyaAli4OaPCULl
	 bX6FNLKLxzkEQJol7jx+QQzPMcGIAnM2x7hAIqgA49n+NKYXGlCox/3kq91Gc1Q1cMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
	b=rtrXgrgBg2uFHkF2mYyM7uaOQnEW7yR6aRHIEgqITMziU1uRODdZzaSdcal09/fMoUUq
	 x0vZVHWF3sTki2aVR0D7WGUXKtEwtKmzQmgBngruzwZRWCuAWBC+388yXISTD4FhfiNpi
	 Hd6e3RjOd0Z2zDXLbfGbW//FvAi/fKYA33NrdujGzC8mpGDRVm7FhI2NTt67BETcWl37q
	 cWV2+Xmd2+zQ+npVfkLHGfinkQI3OfKBmC0r7/AfdRfvD3agXMsmb00cx0eq9Hx8XV7vJ
	 /ee4eyXiGeYFFgMiPpGQkC6ujfi4NJbfYu02qWVVbEPEeFqgtFKxZpKtbg1B1PXs+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="p/iMZ87N";
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E7F606A323
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27E7F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p/iMZ87N
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-14394530ec6so3921061c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827048; x=1795431848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
        b=p/iMZ87ND5FfPyFBVgLUUhFcq1qMI4y8P39VH/Wr9Lx9Nith/rj8iYVd31huzUJdhj
         MOeH7V+23q+Tx2gVt3n39y72ri8+Mf8TeXlzo8o5/6OP7ud1Njl4Sqi80WOGbtepzYqv
         xibTkcx2oJ5xSJ2V3D2ZaOs5/XtRCRYL1QOhrRzKX6v/gAI9e29CJcnJElydvIQdqKsy
         6wSchR4asX3NwBus27xNjq5JyKga+jI/0l7vSDUHJ/cr0xU4UPFKaP6V36M4vJkJxJGK
         eF5Rguo6SSpzT5Qyn0zprPwoKKX4sz/3XxNu3Mt0hMX8FHFlpCmgFE6hDXlfBTDqINli
         P/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827048; x=1795431848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
        b=xCeBOvuKCQviTRwK6wSXQriDZ1OIckB/pZLOevUw/wXLCH3wr2biw61vlsBDq5p9Ww
         PN+M1EDkiYJA/MZH+TnGKrV2AY4ylOpuvUirfSNYFuRBDgJn/RRKHUoAVzPliTIvXnUy
         u+2IAGuqaoFOlLO9oLrvu9GKB7lrRdck+1oDVxnvzvzWOZW2KEfKWg40E81MM3PICBln
         Qx9JNyCy2sqTl4rxs2ecxgUKtxPG+8aP85xBocpO4vBVShstZ2VAm+nm2Ow0sDyGili+
         xNeLeF2P7fFeyrMFlGw+eml5knkJk6fu3O9xy3vuMLzcmKS4mRtq9PqZLB/2zfc0vWWV
         QrQA==
X-Forwarded-Encrypted: i=1; AL+hErGCTnuesbem0/zrzJrhx/gNnuc2t80oeFx7sntep5IyDuzXneAPq4/b3U7sNZX2P8VnCjAPNGY/@vger.kernel.org
X-Gm-Message-State: APuU4Z/X43EjYTF+yNWpsp45YOdlPBVVNUi0XYThsObzjv9fFJ010SzF
	/XqboUBjpdzjgaT6wSqM74aVcUm4tUMHUsjLmVgC4vqF/khztlcgT9Q8
X-Gm-Gg: AYBFou2lDAFHJt5rI4PrKTWjrB5wb018VMkSWrivf8iNOxx0iyPh3PazjlVlWB5y0MT
	Ey9ercA4HJcy2UzWicnXWF3ia9WSQsmndPVR0hrD59IABnrjdLgvHc38beMm7/hH1LTrH4ZHNXD
	ra2Ns21gLw/cbrakvwonl9fOlpD0rWelqR4IU7/TjuVOaM9C/WGDmC93mZ7I7W5CpbyMO1AT042
	e1qiLo59eJsE9vag68FcLqc08S0k/h4WauO3UMvH99jShNxj9VlFsoHftkejqQdV8S5ZlWAO6Jp
	Rcqoo5NLeeB6HKLJ1gYknDsus9bmcLJLOR1MGacdunOLGVkqGHLaoii82sTgZ2bKxAG4bdtFAs0
	F36nbN6+fC9Bj3qaRWDY2UDiwbv/dkk8xebg98Rytat77WEBPFpxRDpYzoknlpNBGMeOr3rMdI4
	eM2VVWxvj7GS/TsZGlrnLMJ7bpe1K6SfprQs63T9ynv3zlWMrFCA3mgNXkRE7Z3qCoiBgk6nXT4
	ihMgfBxgA1THztjK2ZFB9ujgT8G765fsa69xDqg1nhALMwlHUcIallKzyCNb9qhogCAfMFpTiAx
	BqlrbcJ0NkxtKfG6ilbaGl2gkVKQsnmcAZdVnn7NV/0Hs0M=
X-Received: by 2002:a05:701b:4212:20b0:179:a1d0:be39 with SMTP id a92af1059eb24-1b50312449emr10434131c88.29.1794827047944;
        Mon, 16 Nov 2026 03:04:07 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:07 -0800 (PST)
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
Subject: [RFC PATCH 06/16] mm: memcomp: store shmem and tmpfs pages
Date: Mon, 16 Nov 2026 19:01:12 +0800
Message-ID: <20261116110122.309748-7-nakixii@gmail.com>
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

Anonymous token PTEs do not cover shmem contents held by a page-cache
mapping. Shmem needs an exceptional entry that survives eviction and can
be replaced atomically when the contents are faulted back.

Store eligible single-page shmem folios in memcomp and place their
tokens in the page-cache xarray. Reserve per-key slot storage with cache
ownership distinct from an anonymous producer's resident-record
ownership. Prepare payload and accounting before activating the slot
references that the published shadow will own.

Keep a lookup reference while allocating, charging and decompressing a
refault folio. Confirm that the expected shadow remains installed before
committing the page-cache replacement. Only the winning replacement
consumes the cache owner; an aborted load retains it. Balance inode
accounting, memory charges and temporary references on every exit.

Publish a zero shadow's owner count only when the expected xarray
replacement succeeds. Keep that cache-owner ledger separate from
anonymous zero PTEs, and do not allocate slot metadata for a zero
shadow.

Retain ordinary shmem swap as a fallback. A successful in-memory store
needs no swap device, and truncate or swapin races can retry without
publishing contents from a stale shadow.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h  |  80 +++++++++++++
 mm/Kconfig               |   3 +-
 mm/memcomp.c             |  46 ++++++++
 mm/memcomp/api.h         |  34 ++++++
 mm/memcomp/cache_folio.h |  70 ++++++++++++
 mm/memcomp/cache_store.h |  70 ++++++++++++
 mm/memcomp/consumers.h   |  55 +++++++++
 mm/shmem.c               | 238 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 595 insertions(+), 1 deletion(-)
 create mode 100644 mm/memcomp/cache_folio.h
 create mode 100644 mm/memcomp/cache_store.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 20b553d12151f7bc0202c25d52e4f6832c6ae0b6..20e81dee9062b97274910a1ed3451dd0089ce235 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -103,6 +103,9 @@ void memcomp_entry_resident_put(struct memcomp_ref *ref);
 /* Consumes and clears the held guard on every return. */
 int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref);
 void memcomp_invalidate(unsigned long token);
+void memcomp_invalidate_cache(unsigned long token);
+/* Called only by the winning zero-cache XA replacement while locked. */
+void memcomp_publish_cache_zero(void);
 void memcomp_invalidate_nr(unsigned long token, unsigned int nr_pages);
 void memcomp_invalidate_folio(struct folio *folio);
 bool memcomp_release_folio(struct folio *folio);
@@ -125,6 +128,30 @@ void memcomp_entry_clear_refresh_pending(unsigned long token);
 bool memcomp_entry_get(unsigned long token);
 bool memcomp_entry_present(unsigned long token);
 
+/*
+ * Page-cache variants for shmem/tmpfs pages. A zero store result prepares
+ * a value only: its winning XA replacement must publish the cache owner
+ * before unlocking. An aborted zero preparation creates no owner to drop.
+ */
+bool memcomp_store_cache(struct folio *folio, unsigned long *token);
+/*
+ * Pin rejects token0 with an empty guard. Explicit zero load consumes no
+ * owner; the winning shadow replacement drops its cache owner separately.
+ * Pin must be resolved with exactly one abort or commit call.  Commit also
+ * drops the shadow owner and is valid only after replacing the expected
+ * shadow in the page cache.  Failed pins clear the output; abort and commit
+ * consume and clear the guard.  Load keeps the guard on every return.
+ */
+bool memcomp_load_folio_pin(unsigned long token, struct memcomp_ref *ref);
+int memcomp_load_folio(struct memcomp_ref *ref, struct folio *folio);
+int memcomp_load_folio_zero(struct folio *folio);
+void memcomp_load_folio_abort(struct memcomp_ref *ref);
+void memcomp_load_folio_commit(struct memcomp_ref *ref);
+
+/* Check if a page-cache xa_value is a memcomp entry. */
+bool is_memcomp_shadow(void *shadow);
+unsigned long memcomp_shadow_token(void *shadow);
+
 #else
 
 static inline bool memcomp_available(void)
@@ -225,6 +252,14 @@ static inline void memcomp_invalidate(unsigned long token)
 {
 }
 
+static inline void memcomp_invalidate_cache(unsigned long token)
+{
+}
+
+static inline void memcomp_publish_cache_zero(void)
+{
+}
+
 static inline void memcomp_invalidate_nr(unsigned long token,
 					 unsigned int nr_pages)
 {
@@ -301,6 +336,51 @@ static inline bool memcomp_entry_present(unsigned long token)
 	return false;
 }
 
+static inline bool memcomp_store_cache(struct folio *folio,
+				       unsigned long *token)
+{
+	return false;
+}
+
+static inline bool memcomp_load_folio_pin(unsigned long token,
+					  struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+	return false;
+}
+
+static inline int memcomp_load_folio(struct memcomp_ref *ref,
+				     struct folio *folio)
+{
+	*ref = (struct memcomp_ref) { };
+	return -ENOENT;
+}
+
+static inline int memcomp_load_folio_zero(struct folio *folio)
+{
+	return -ENOENT;
+}
+
+static inline void memcomp_load_folio_abort(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline void memcomp_load_folio_commit(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline bool is_memcomp_shadow(void *shadow)
+{
+	return false;
+}
+
+static inline unsigned long memcomp_shadow_token(void *shadow)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index d88c27e0235bf8ac79e05e009b8a4625d9d0c693..61356d7e375b4ce4bcf93b5d37108deb8dd655bd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -195,7 +195,8 @@ config MEMCOMP
 	select XXHASH
 	default n
 	help
-	  Enable direct in-memory compression for reclaimed anonymous pages.
+	  Enable direct in-memory compression for reclaimed anonymous and
+	  shmem/tmpfs pages.
 
 	  Pages are compressed into RAM and mapped through a special
 	  non-swap PTE entry type. This does not require swap block I/O as
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 8944fa081f3e35bfacf00d3a1c09c8bb32a9db18..07242de736f6771d4a6d74a6182b2cad4c9d150d 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -2234,6 +2234,35 @@ memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
 	return 0;
 }
 
+static int memcomp_prepare_payload(const void *src, unsigned int src_len,
+				   unsigned int *length,
+				       unsigned long *handle,
+				       u8 *pool_idx,
+				       enum memcomp_payload_mode mode,
+				       bool allow_provisional_raw)
+{
+	struct memcomp_reclaim_ctx *ctx;
+	unsigned long element;
+	int ret;
+
+	/* Same-filled shmem pages do not need a compression workspace. */
+	if (page_same_filled(src, &element)) {
+		*length = 0;
+		*handle = element;
+		return 0;
+	}
+
+	ctx = memcomp_get_comp_ctx(mode, NULL, MEMCOMP_RECLAIM_DIRECT);
+	if (!ctx)
+		return -EBUSY;
+	ret = memcomp_prepare_payload_locked(&ctx, src, src_len, length,
+					     handle, pool_idx,
+						 allow_provisional_raw, NULL);
+	WARN_ON_ONCE(!ctx);
+	memcomp_put_comp_ctx(ctx);
+	return ret;
+}
+
 static __always_inline int
 memcomp_arch_prepare_to_swap(struct folio *folio)
 {
@@ -2242,6 +2271,9 @@ memcomp_arch_prepare_to_swap(struct folio *folio)
 
 /* Allocate @nr_pages consecutive tokens, skipping fragmented free ranges. */
 
+#include "memcomp/cache_store.h"
+#include "memcomp/cache_folio.h"
+
 /*
  * Core store - compress @nr_pages pages and insert them into the global
  * entries xarray under consecutive tokens.  Returns 0 with *token set
@@ -2455,6 +2487,16 @@ static bool memcomp_map_resident(struct vm_area_struct *vma,
 #endif
 
 /* Check if a page-cache xa_value is a memcomp entry. */
+bool is_memcomp_shadow(void *shadow)
+{
+	return xa_is_value(shadow) &&
+	       is_memcomp_entry(radix_to_swp_entry(shadow));
+}
+
+unsigned long memcomp_shadow_token(void *shadow)
+{
+	return swp_offset(radix_to_swp_entry(shadow));
+}
 
 /*
  * Shmem/tmpfs variant: compress a folio and return the token.  This does not
@@ -2468,6 +2510,10 @@ static bool memcomp_map_resident(struct vm_area_struct *vma,
  * abort.  The caller handles locking, page-cache insertion and rmap.
  */
 /* Explicit zero transport: no sentinel guard or owner consumption. */
+int memcomp_load_folio_zero(struct folio *folio)
+{
+	return mc16_cache_load_zero(folio);
+}
 
 /* Fill an existing token span after every mapping has been removed. */
 
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
index 5e49d8484f0a303533f5ae04e0477960775c3512..4cc192fba3af9cd858f5752a8e5e931ef4e3af8f 100644
--- a/mm/memcomp/api.h
+++ b/mm/memcomp/api.h
@@ -29,6 +29,16 @@ void memcomp_invalidate_nr(unsigned long token, unsigned int nr)
 	mc16_pte_put_nr(token, nr);
 }
 
+void memcomp_publish_cache_zero(void)
+{
+	mc16_zero_cache_get(1);
+}
+
+void memcomp_invalidate_cache(unsigned long token)
+{
+	mc16_cache_drop(token);
+}
+
 bool memcomp_entry_present(unsigned long token)
 {
 	return mc16_entry_present(token);
@@ -146,4 +156,28 @@ int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref)
 	return (ret & VM_FAULT_SIGBUS) ? -EFAULT : 0;
 }
 
+bool memcomp_store_cache(struct folio *folio, unsigned long *token)
+{
+	return mc16_store_cache_folio(folio, token);
+}
+
+bool memcomp_load_folio_pin(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_cache_pin(token, ref);
+}
+
+int memcomp_load_folio(struct memcomp_ref *ref, struct folio *folio)
+{
+	return mc16_cache_load(ref, folio);
+}
+
+void memcomp_load_folio_abort(struct memcomp_ref *ref)
+{
+	mc16_cache_abort(ref);
+}
+
+void memcomp_load_folio_commit(struct memcomp_ref *ref)
+{
+	mc16_cache_commit(ref);
+}
 #endif /* _MM_MEMCOMP_API_H */
diff --git a/mm/memcomp/cache_folio.h b/mm/memcomp/cache_folio.h
new file mode 100644
index 0000000000000000000000000000000000000000..b0b9f154b42f02f54720f44f5c1e15dd2bf4140a
--- /dev/null
+++ b/mm/memcomp/cache_folio.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_CACHE_FOLIO_H
+#define _MM_MEMCOMP_CACHE_FOLIO_H
+
+#include <linux/highmem.h>
+
+/* Include after cache_store.h and memcomp_arch_prepare_to_swap(). */
+#define mc16_cache_folio_arch_prepare memcomp_arch_prepare_to_swap
+
+/*
+ * Caller holds the order-0 source folio lock throughout preparation and XA
+ * replacement. Output is valid only on success and unchanged on failure.
+ * Positive success transfers the initial cache ref, without another get.
+ * Caller drops it if the expected XA replacement loses.
+ * Zero success is preparation only: the winning XA replacement must publish
+ * one zero cache owner under its XA lock. A losing zero preparation owes no put.
+ */
+static inline bool mc16_store_cache_folio(struct folio *folio,
+					  unsigned long *token)
+{
+	struct memcomp_ref initial = { };
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	unsigned int nr_pages = folio ? folio_nr_pages(folio) : 1;
+#endif
+	void *src;
+	int ret;
+
+	if (!token || !folio || !folio_test_locked(folio) ||
+	    folio_test_large(folio) || folio_mapped(folio) ||
+	    folio_test_mlocked(folio) || folio_test_writeback(folio) ||
+	    folio_maybe_dma_pinned(folio))
+		goto fail_eligibility;
+	if (!memcomp_is_enabled())
+		goto fail_payload;
+	/* The arch predicate includes tags, unlike a byte-only zero scan. */
+	if (pages_identical(&folio->page, ZERO_PAGE(0))) {
+		*token = 0;
+		goto success;
+	}
+	src = kmap_local_folio(folio, 0);
+	ret = mc16_cache_store(src, folio, &initial);
+	kunmap_local(src);
+	if (ret)
+		goto fail_payload;
+	/* The arch hook keys metadata off page_swap_entry(). */
+	folio->swap = make_memcomp_entry(initial.token);
+	ret = mc16_cache_folio_arch_prepare(folio);
+	folio->swap.val = 0;
+	if (ret) {
+		mc16_ref_put(&initial);
+		goto fail_arch;
+	}
+	*token = initial.token;
+success:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_store_ok_pages);
+	return true;
+
+fail_eligibility:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_eligibility_fail_pages);
+	goto fail;
+fail_payload:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_payload_fail_pages);
+	goto fail;
+fail_arch:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_arch_fail_pages);
+fail:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_store_fail_pages);
+	return false;
+}
+#endif /* _MM_MEMCOMP_CACHE_FOLIO_H */
diff --git a/mm/memcomp/cache_store.h b/mm/memcomp/cache_store.h
new file mode 100644
index 0000000000000000000000000000000000000000..ca2d6097b491aeaaaf2807e367d37ec3f6b8cc8b
--- /dev/null
+++ b/mm/memcomp/cache_store.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_CACHE_STORE_H
+#define _MM_MEMCOMP_CACHE_STORE_H
+
+/*
+ * Prepare one cache payload, retaining its initial cache reference in out.
+ * The caller keeps the source/account folio alive and transfers that reference
+ * only after arch preparation and the expected page-cache replacement succeed.
+ * This lower-level helper does not choose the separate slotless-zero path.
+ */
+/* Private reservation -> counted initial cache ownership, infallibly. */
+static inline void mc16_cache_publish(struct memcomp_ref *ref, unsigned int bytes)
+{
+	memcomp_stored_bytes_inc();
+	memcomp_compressed_bytes_add(bytes);
+	mc16_account_state(ref, true);
+	mc16_cache_activate(ref);
+}
+
+static inline int mc16_cache_store(const void *src, struct folio *account,
+				   struct memcomp_ref *out)
+{
+	struct mc16_initial_payload payload = { };
+	struct obj_cgroup *objcg;
+	unsigned long handle = 0;
+	unsigned int bytes = 0;
+	u8 pool = 0;
+	int ret;
+
+	if (!out)
+		return -EINVAL;
+	*out = (struct memcomp_ref) { };
+	if (!src || !account)
+		return -EINVAL;
+	if (!memcomp_is_enabled())
+		return -EOPNOTSUPP;
+	/* Independent source owner, never a borrowed registry key across X1/X2. */
+	objcg = memcomp_objcg_get(account);
+	ret = memcomp_prepare_payload(src, PAGE_SIZE, &bytes, &handle, &pool,
+				      MEMCOMP_PAYLOAD_BEST_EFFORT, false);
+	if (ret)
+		goto out_owner;
+	if (!memcomp_payloads_net_reclaimable(&bytes, 1)) {
+		if (bytes == PAGE_SIZE)
+			memcomp_debug_inc(&memcomp_raw_reject_net);
+		ret = -E2BIG;
+		goto out_payload;
+	}
+	ret = memcomp_objcg_charge(objcg, GFP_NOWAIT | __GFP_NOWARN, bytes);
+	if (ret)
+		goto out_payload;
+	payload = (struct mc16_initial_payload) { .word = handle, .bytes = bytes };
+	ret = mc16_reserve_cache(objcg, folio_nid(account), &payload, 1, out);
+	if (ret) {
+		memcomp_objcg_uncharge(objcg, bytes);
+		goto out_payload;
+	}
+	/* No pending/resident/OWNER transition or record/member RMW occurs. */
+	mc16_cache_publish(out, bytes);
+	ret = 0;
+	goto out_owner;
+out_payload:
+	if (bytes)
+		memcomp_zs_free(pool, handle);
+out_owner:
+	if (objcg)
+		memcomp_objcg_put(objcg);
+	return ret;
+}
+#endif /* _MM_MEMCOMP_CACHE_STORE_H */
diff --git a/mm/memcomp/consumers.h b/mm/memcomp/consumers.h
index 929c046bf98d52c878e727e14d859d81c871b743..03aef9ffecb6df83b6314df43739677120fdd8f8 100644
--- a/mm/memcomp/consumers.h
+++ b/mm/memcomp/consumers.h
@@ -46,19 +46,74 @@ static inline void mc16_pte_put_nr(unsigned long token, unsigned int nr)
 }
 
 /* The caller removed one cache owner, independently of any PTE owner. */
+static inline void mc16_cache_drop(unsigned long token)
+{
+	struct memcomp_ref ref;
+
+	if (!token) {
+		mc16_zero_cache_put(1);
+		return;
+	}
+	if (mc16_get(token, &ref))
+		mc16_ref_put_count(&ref, 2); /* lookup + removed cache owner */
+}
 
 /* Empty output on failure, including token0; caller handles zero explicitly. */
+static inline bool mc16_cache_pin(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_get(token, ref);
+}
 
 /*
  * Keep this same guard through load and the caller's xarray transaction.
  * Failure leaves both the guard and cache owner intact for abort/retry.
  */
+static inline int mc16_cache_load(struct memcomp_ref *ref, struct folio *folio)
+{
+	void *dst;
+	int ret;
+
+	if (!ref || !ref->slot)
+		return -ENOENT;
+	if (!folio || folio_test_large(folio) || !folio_test_locked(folio))
+		return -EINVAL;
+	dst = kmap_local_folio(folio, 0);
+	ret = mc16_load_page(ref, dst);
+	kunmap_local(dst);
+	if (!ret) {
+		__folio_mark_uptodate(folio);
+		flush_dcache_folio(folio);
+		memcomp_arch_restore(ref->token, folio);
+	}
+	return ret;
+}
+
+static inline void mc16_cache_abort(struct memcomp_ref *ref)
+{
+	if (ref && ref->slot)
+		mc16_ref_put(ref);
+}
 
 /* Only the winner replacing the expected cache shadow may consume its owner. */
+static inline void mc16_cache_commit(struct memcomp_ref *ref)
+{
+	if (ref && ref->slot)
+		mc16_ref_put_count(ref, 2); /* same guard + cache owner */
+}
 
 /*
  * Explicit token0 branch: no guard, lookup or owner consumption. After the
  * expected zero shadow is replaced successfully, caller must cache_drop(0).
  * An aborted xarray transaction leaves the zero cache owner unchanged.
  */
+static inline int mc16_cache_load_zero(struct folio *folio)
+{
+	if (!folio || folio_test_large(folio) || !folio_test_locked(folio))
+		return -EINVAL;
+	clear_highpage(folio_page(folio, 0));
+	__folio_mark_uptodate(folio);
+	flush_dcache_folio(folio);
+	memcomp_arch_restore(0, folio);
+	return 0;
+}
 #endif /* _MM_MEMCOMP_CONSUMERS_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 5960e5035f983571fb806313855f74c61abf8354..a04e68d445d37384b02b56e791586d09b392fcfa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -80,6 +80,9 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/uuid.h>
 #include <linux/quotaops.h>
 #include <linux/rcupdate_wait.h>
+#ifdef CONFIG_MEMCOMP
+#include <linux/memcomp.h>
+#endif
 
 #include <linux/uaccess.h>
 
@@ -847,6 +850,15 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 
 	xa_lock_irq(&mapping->i_pages);
 	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
+#ifdef CONFIG_MEMCOMP
+	if (!error) {
+		swp_entry_t entry = radix_to_swp_entry(radswap);
+
+		/* Publish ownership before any reader can remove this shadow. */
+		if (is_memcomp_entry(entry) && !swp_offset(entry))
+			memcomp_publish_cache_zero();
+	}
+#endif
 	folio->mapping = NULL;
 	mapping->nrpages -= nr;
 	shmem_update_stats(folio, -nr);
@@ -864,14 +876,29 @@ static long shmem_free_swap(struct address_space *mapping,
 			    pgoff_t index, void *radswap)
 {
 	int order = xa_get_order(&mapping->i_pages, index);
+#ifdef CONFIG_MEMCOMP
+	swp_entry_t entry = radix_to_swp_entry(radswap);
+	long nr_pages = is_memcomp_entry(entry) ? 1 : 1 << order;
+#endif
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
 		return 0;
+#ifdef CONFIG_MEMCOMP
+	if (is_memcomp_entry(entry))
+		memcomp_invalidate_cache(swp_offset(entry));
+	else
+		free_swap_and_cache_nr(entry, nr_pages);
+#else
 	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+#endif
 
+#ifdef CONFIG_MEMCOMP
+	return nr_pages;
+#else
 	return 1 << order;
+#endif
 }
 
 /*
@@ -893,8 +920,23 @@ unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 	xas_for_each(&xas, page, max) {
 		if (xas_retry(&xas, page))
 			continue;
+#ifdef CONFIG_MEMCOMP
+		if (xa_is_value(page)) {
+			swp_entry_t entry = radix_to_swp_entry(page);
+
+			if (is_memcomp_entry(entry)) {
+				if (memcomp_entry_stat(swp_offset(entry),
+						       NULL, NULL))
+					swapped += PAGE_SIZE;
+			} else {
+				swapped += (1UL << xas_get_order(&xas)) <<
+					   PAGE_SHIFT;
+			}
+		}
+#else
 		if (xa_is_value(page))
 			swapped += 1 << xas_get_order(&xas);
+#endif
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
@@ -904,7 +946,11 @@ unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 	}
 	rcu_read_unlock();
 
+#ifdef CONFIG_MEMCOMP
+	return swapped;
+#else
 	return swapped << PAGE_SHIFT;
+#endif
 }
 
 /*
@@ -932,6 +978,15 @@ unsigned long shmem_swap_usage(struct vm_area_struct *vma)
 	if (!swapped)
 		return 0;
 
+#ifdef CONFIG_MEMCOMP
+	/*
+	 * info->swapped counts a memcomp entry as one page, which is what
+	 * shmem_partial_swap_usage() also reports for it, so the whole-object
+	 * answer is still exact without the walk.  Restoring this matters:
+	 * smaps_rollup is polled continuously, and the walk is an RCU pass
+	 * over every entry of the mapping with an xa_load per memcomp one.
+	 */
+#endif
 	if (!vma->vm_pgoff && vma->vm_end - vma->vm_start >= inode->i_size)
 		return swapped << PAGE_SHIFT;
 
@@ -1321,6 +1376,10 @@ static int shmem_find_swap_entries(struct address_space *mapping,
 			continue;
 
 		entry = radix_to_swp_entry(folio);
+#ifdef CONFIG_MEMCOMP
+		if (is_memcomp_entry(entry))
+			continue;
+#endif
 		/*
 		 * swapin error entries can be found in the mapping. But they're
 		 * deliberately ignored here as we've done everything we can do.
@@ -1459,7 +1518,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	swp_entry_t swap;
 	pgoff_t index;
+#ifdef CONFIG_MEMCOMP
+	unsigned long mc_token;
+#endif
 	int nr_pages;
+#ifdef CONFIG_MEMCOMP
+	bool memcomp_attempted = false;
+#endif
 	bool split = false;
 
 	/*
@@ -1475,8 +1540,84 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	if (WARN_ON_ONCE((info->flags & VM_LOCKED) || sbinfo->noswap))
 		goto redirty;
 
+#ifdef CONFIG_MEMCOMP
+	/*
+	 * Only an uptodate folio.  The !uptodate handling below is what gives
+	 * shmem_fallocate() its backpressure - it counts the folio in
+	 * shmem_falloc->nr_unswapped and redirties it so the fallocation can
+	 * give up with -ENOMEM - and what zeroes a folio whose contents were
+	 * never initialised.  Jumping straight to the store skipped both, so a
+	 * fallocate that should have failed ran on to OOM, and on a kernel
+	 * booted with init_on_alloc=0 the uninitialised page became file
+	 * contents.  A folio that arrives !uptodate takes the swap path, and
+	 * the retries below reach the store once it has been made uptodate.
+	 */
+	if (memcomp_available() && !folio_test_large(folio) &&
+	    folio_test_uptodate(folio)) {
+		memcomp_count_initial_compress();
+		goto try_memcomp;
+	}
+	goto try_swap;
+
+try_memcomp:
+	memcomp_attempted = true;
+	if (!folio_test_large(folio)) {
+		if (memcomp_store_cache(folio, &mc_token)) {
+			swp_entry_t mc_entry = make_memcomp_entry(mc_token);
+
+			mutex_lock(&shmem_swaplist_mutex);
+			if (list_empty(&info->swaplist))
+				list_add(&info->swaplist, &shmem_swaplist);
+			mutex_unlock(&shmem_swaplist_mutex);
+
+			/*
+			 * Raise swapped before nrpages is lowered, as the
+			 * swap path below does.  shmem_recalc_inode()
+			 * compensates for exactly that order - see the
+			 * comment on its `swapped > 0` clause - so calling it
+			 * after shmem_delete_from_page_cache() has already
+			 * dropped nrpages makes it count the page as freed
+			 * and hand a block back that nothing released.
+			 */
+			shmem_recalc_inode(inode, 0, 1);
+			shmem_delete_from_page_cache(folio,
+						     swp_to_radix_entry(mc_entry));
+			if (folio_test_dirty(folio))
+				folio_clear_dirty(folio);
+			/*
+			 * Leave the token on the folio.  The folio now has no
+			 * mapping and one reference, and shrink_folio_list()
+			 * only credits nr_reclaimed for a folio it frees on
+			 * its free_it: path.  Its recovery arm for exactly
+			 * this shape keys on page_swap_entry(), so without a
+			 * token the folio takes keep_locked, is dropped
+			 * unaccounted by move_folios_to_lru(), and direct
+			 * reclaim reports no progress for work it did - which
+			 * __alloc_pages_slowpath() counts toward OOM.
+			 *
+			 * The entry is owned by the page-cache xarray, not by
+			 * the folio: memcomp_do_store() was passed no
+			 * owner folio, so it carries MC_SHMEM rather than
+			 * MC_OWNER and the memcomp_invalidate_folio() that
+			 * arm performs drops nothing.  This is the same
+			 * handover memcomp_reserve() makes for anonymous
+			 * folios.
+			 */
+			folio->swap = mc_entry;
+			folio_unlock(folio);
+			return 0;
+		}
+	}
+
+try_swap:
+	/* This is the regular shmem fallback, not memcomp writeback. */
+#endif
 	if (!total_swap_pages)
 		goto redirty;
+#ifdef CONFIG_MEMCOMP
+	if (memcomp_attempted)
+		memcomp_count_normal_swap_fallback();
+#endif
 
 	/*
 	 * If CONFIG_THP_SWAP is not enabled, the large folio should be
@@ -1541,6 +1682,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 
 	swap = folio_alloc_swap(folio);
 	if (!swap.val) {
+#ifdef CONFIG_MEMCOMP
+		if (!memcomp_attempted && memcomp_available() &&
+		    !folio_test_large(folio)) {
+			memcomp_count_initial_compress();
+			goto try_memcomp;
+		}
+#endif
 		if (nr_pages > 1)
 			goto try_split;
 
@@ -1573,6 +1721,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 
 	mutex_unlock(&shmem_swaplist_mutex);
 	put_swap_folio(folio, swap);
+#ifdef CONFIG_MEMCOMP
+	if (!memcomp_attempted && memcomp_available() &&
+	    !folio_test_large(folio)) {
+		memcomp_count_initial_compress();
+		goto try_memcomp;
+	}
+#endif
 redirty:
 	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
@@ -2110,6 +2265,89 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	if (is_poisoned_swp_entry(swap))
 		return -EIO;
+#ifdef CONFIG_MEMCOMP
+
+	if (is_memcomp_entry(swap)) {
+		struct memcomp_ref mc_ref = { };
+		unsigned long token = swp_offset(swap);
+
+		if (!shmem_confirm_swap(mapping, index, swap))
+			return -EEXIST;
+
+		if (shmem_inode_acct_blocks(inode, 1))
+			return -ENOSPC;
+
+		folio = shmem_alloc_folio(gfp, 0, info, index);
+		if (!folio) {
+			shmem_inode_unacct_blocks(inode, 1);
+			return -ENOMEM;
+		}
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+		nr_pages = folio_nr_pages(folio);
+
+		error = mem_cgroup_charge(folio, fault_mm, gfp & GFP_RECLAIM_MASK);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			return error;
+		}
+
+		/*
+		 * Allocation and memcg charge may reclaim or wait for OOM.
+		 * Pin only after both, then recheck the page-cache entry.
+		 */
+		if (token)
+			memcomp_load_folio_pin(token, &mc_ref);
+		if ((token && !mc_ref.slot) ||
+		    !shmem_confirm_swap(mapping, index, swap)) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			if (mc_ref.slot)
+				memcomp_load_folio_abort(&mc_ref);
+			return -EEXIST;
+		}
+
+		error = token ? memcomp_load_folio(&mc_ref, folio) :
+			memcomp_load_folio_zero(folio);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			if (!shmem_confirm_swap(mapping, index, swap))
+				error = -EEXIST;
+			memcomp_load_folio_abort(&mc_ref);
+			return error;
+		}
+
+		error = shmem_add_to_page_cache(folio, mapping, index,
+						swp_to_radix_entry(swap), gfp);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			memcomp_load_folio_abort(&mc_ref);
+			return error == -EEXIST ? -EEXIST : error;
+		}
+
+		shmem_recalc_inode(inode, 1, -1);
+
+		if (sgp == SGP_WRITE)
+			folio_mark_accessed(folio);
+
+		folio_mark_dirty(folio);
+		if (token)
+			memcomp_load_folio_commit(&mc_ref);
+		else
+			memcomp_invalidate_cache(0);
+		folio_add_lru(folio);
+
+		*foliop = folio;
+		return 0;
+	}
+#endif
 
 	si = get_swap_device(swap);
 	if (!si) {
