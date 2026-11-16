Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827076;
	b=uxOKybu4xG8TbKqgeHkNY5kDobuP2y7EVC8+eTb5bDzMajfzQJ7HUXKHRYf2X+DEUD1q
	 h/oK3jk8DQahKtnEVGJrw3Zthdu/JmnVwvzO+yxgy9HxoJfEylk00JyP+4CAv23yzRRy7
	 kdz02ll4zAzy1ZRMIFenJHY6uexRU3qxUrOmhlQ2SNLiSkIACkqHo8ap0I91OisSjjd9K
	 mArOKY72f4D3kbmRTcv23zFZuLtpRWexz43Di3AAiY5P687JWfLOSMZoEBaaq6H1vW3Lj
	 i6vfaVfpEun6yLlquVcDBV50WwsznZxRsjWwBxOLZ/rbwHfNS8C3wpEi5hKNJmwYaOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827076;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=shUcKwOTz+oZvjPnJoYGYtdbHRxBWu5TfpKyWmIjpdY=;
	b=qA2tT4ssiX7VY3Y1SOBCNeUm+qHBjT/XoxEBbpiiiM7/HrqbvOUDuUW8JYNjiW9cjA8d
	 TRnyoHgPXYLnqHiHZ0yTDlSThTVFy+FrVdKov8GpdWL36OXQfUVCey2ZeijuaIejAJRlC
	 BP5Kr+QSqLlZUPGK1IRtebvsfRFyPwN+U05hQmAwXs+OrTRJxxiVqdtvByrvapkDW9utF
	 quREXeNQozMXyom+MBKiqb+3XF5FxUPl7t3E84ZWLqe7GhT+8lhvDPPc4dWy51h1BZVFf
	 FkuL1Lwlo4j4ckxUqKKlf/vFZ8ohnmhGczhbIY+jGwQDnCj9Jzz49H51xQylcIbRVfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yyrdkZ3O;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8845C606A8A9
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8845C606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yyrdkZ3O
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso4001922c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827074; x=1795431874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shUcKwOTz+oZvjPnJoYGYtdbHRxBWu5TfpKyWmIjpdY=;
        b=yyrdkZ3OXc7Gf9BeSWY91qamGA7cC+ovAh4GlvW/jj0qtpQOI1A/5gXlVNJHWnV2Sj
         API/9RRs3HeomsDy3eSkgI3G5rlHv3rckVRHGoBXf5IekxgY8/ZivvQGKT7acr3Lpgmc
         2lZy0vCa1ZtNsMM8BE4x0ygxz7mkFQd6GZh5jgsoPrW9gDDAFbEEmm9ZOINDAbAQvGFd
         leAkbwo0n2l6H598vnyli4Q4SMRtB/Ri8we9mnE1DjVGoI14I7SKMTcqwnjeZ7aFmyke
         DSNsfYAVBc2ZtJ4+nKq52SlJi9Lu50X6LHiQXV0GYm5BpwvjrtCzok1mA7NCo2Pa0yur
         8zTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827074; x=1795431874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=shUcKwOTz+oZvjPnJoYGYtdbHRxBWu5TfpKyWmIjpdY=;
        b=bIQzbfFhhGdjuAfpAAqDmTxz/ur3Iz824CuVI5W3hKf2xcNED9Jd3mXMcSFaLdYM2Q
         KNy8OmFcJ1QVnCiVxza0uZtUPKacaX9IPBnPgGXCaarbJfo4KNRQqhygGPQT6mw5mfb8
         naYNVfgv6xxQ03tPSEb54aXGzVX77/B2X2kAVoTwv7wEZdSqrU+EjmV64JUA4W3wj+xy
         BhN7zSCA3ETHtlnCGejM3SVJl5utvC8+9JI8Drr7o1YS+5hbyMTJ7a9jkiI8tZFoAexc
         sHLR7WPfXNmo2kKwQKqutXRQqPyKwJ8LL0Unbqwormnb1yTonR+f+vsOReND8bkbusMK
         tF/w==
X-Forwarded-Encrypted: i=1; AL+hErF86ryQ8XxKDiAFiOrEeGnNx1g2F6rPNo1VOMR3wGhl2LPLV+WTs8RrF5CZ/TffzJAUi/GYtrt2@vger.kernel.org
X-Gm-Message-State: APuU4Z/0azZNd0uSyF4C4Sf8v2aCURjpyYCb/0gbZX52MgekSL+xvOjo
	4QaBaHGdHbCNtvcAMHW8jD9b8ke1Reo5pNhjZycsqjfshJPD4nVQq/5f
X-Gm-Gg: AYBFou01usC8SJB+0EEEIx6BLCglA7IuZaYanN2siA6WsIQiSJXY8MlmgxhH9C6Feea
	DldBT1ks98DxHAacr3OaPcU35ME/18zN4DfC/fX7Dcw/K+JJrorjX7GwVzoHB7I4Wqxv2jyOOwB
	4Shh9CDSeR5y8GbOLEprCBhi/h0W58w8R8w60HYkqN8KBqvoxWUIWCDKuUC3lcAA2G3roZ1kS9o
	jCed0tb+/hOIhw4BcyK1M8JXHSSmssN9uNkIWSMGu9GmqUoi6CdbBqlKznyFfagDwMEDdx33L/0
	1oIW8ypx3+dOnRvNSALiBUNW0WXRgZwzvr4Tyufrtk7G8a6v/LG/FqnxrHbb9o/QE7egfG16P2c
	Yf8oxbX+BshR3vi1zR65vNaMnpyS4im2GHyf7JoS+mufld2OW0G8G5xvPWibt9J6ZeMZhy9EHy2
	UtSz63rCDQPv0sOpSoqBQcB7zcyNducLtkHW84SsYg4ALxMD2E8PGKgt5TLh2x2nzOb0yqEqwyO
	K36bW25ALToXN/6a75honPVJZ0MksnK+hOtUhNX7sqMjNEV1AuDeEMbLnIASBIHTEYOTkSrUeSX
	I9DrmMrNd+XAtzviAveTg11QBjkFdXb5oB5ERHHmRh+SEZE=
X-Received: by 2002:a05:7022:97:b0:144:eaa7:2763 with SMTP id a92af1059eb24-1b5030980bemr9242199c88.16.1794827073778;
        Mon, 16 Nov 2026 03:04:33 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:33 -0800 (PST)
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
Subject: [RFC PATCH 11/16] mm: memcomp: account user eviction and refault
Date: Mon, 16 Nov 2026 19:01:17 +0800
Message-ID: <20261116110122.309748-12-nakixii@gmail.com>
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

Pin source memory-cgroup IDs independently of object-charge reparenting.
Keep per-base-page stock shadows behind the publication gate, publish
after source exit and consume them after charging a new user folio.

Account native eviction, refault, major faults, PSI and delay only for
user materialization. Mark real swap transport reservations with a
per-device bitmap and clear that marker through the native free path.
Keep publication retries and locking fixes with this protocol.

The shmem cache-store caller keeps the initial unpublished cache
reference until XArray publication. It keeps the slot, segment and
cluster alive while pin performs only lookup and a nonzero reference
increment. A failed pin cannot be safely reported by this void helper
without invalidating its caller's completed cache transaction, so retain
the ownership precondition check. Keep the temporary pin through
publication because truncate can then consume the cache reference.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h       |   6 ++
 include/linux/memcontrol.h    |  45 ++++++++++
 include/linux/swap.h          |  39 ++++++++
 mm/memcomp.c                  |  13 ++-
 mm/memcomp/anon_store.h       |  10 ++-
 mm/memcomp/api.h              |  17 ++++
 mm/memcomp/cache_folio.h      |  26 +++++-
 mm/memcomp/cache_store.h      |  33 ++++++-
 mm/memcomp/consumers.h        |   6 ++
 mm/memcomp/fault.h            |  15 +++-
 mm/memcomp/folio.h            | 130 ++++++++++++++++++---------
 mm/memcomp/load.h             |   4 +
 mm/memcomp/owner.h            |  52 ++++++++++-
 mm/memcomp/storage.h          | 161 +++++++++++++++++++++++++++++-----
 mm/memcomp/swapoff.h          |   4 +
 mm/memcomp/workingset_load.h  |  97 ++++++++++++++++++++
 mm/memcomp/workingset_store.h |  52 +++++++++++
 mm/memcomp/writeback.h        |   3 +-
 mm/memcontrol.c               |  99 +++++++++++++++++++++
 mm/page_io.c                  |  42 +++++++++
 mm/shmem.c                    | 101 +++++++++++----------
 mm/swap.h                     |   4 +
 mm/swapfile.c                 |  34 +++++++
 mm/vmscan.c                   |  14 ++-
 mm/workingset.c               |  32 +++++++
 25 files changed, 915 insertions(+), 124 deletions(-)
 create mode 100644 mm/memcomp/workingset_load.h
 create mode 100644 mm/memcomp/workingset_store.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 600de70efda7d547d8e9ad12932af7a4414b5beb..8248a44bbb57a9e98afe29cc0e0599ca9f6bc988 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 
 struct folio;
+struct mem_cgroup;
 struct mc16_slot;
 struct mc16_cluster;
 struct memcomp_async;
@@ -44,6 +45,11 @@ enum memcomp_anon_fail_event {
 #ifdef CONFIG_MEMCOMP
 
 bool memcomp_available(void);
+bool memcomp_release_folio_reclaim(struct folio *folio,
+				   struct mem_cgroup *target_memcg);
+void memcomp_publish_cache_eviction(struct folio *folio, struct memcomp_ref *ref);
+int memcomp_charge_folio(struct memcomp_ref *ref, struct folio *folio,
+			 struct mm_struct *mm, gfp_t gfp);
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 void memcomp_count_initial_compress(void);
 void memcomp_count_normal_swap_fallback(void);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1b41554a5fb32f36c1621225cba975a42d2b901..399e0bc0938ee06d5dd080b801bfef6811e25315 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -700,6 +700,21 @@ int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 
+#ifdef CONFIG_MEMCOMP
+/*
+ * Caller stabilizes the source folio's memcg. Root has a real ID and needs put.
+ * Production reserve uses the checked form: an online pin failure is an error.
+ * ID 0 means disabled or already retired identity and needs no put.
+ */
+int mem_cgroup_memcomp_id_get_checked(struct folio *folio, unsigned short *id);
+unsigned short mem_cgroup_memcomp_id_get(struct folio *folio);
+/* Duplicate a nonzero, caller-pinned ID for an independently owned key. */
+bool mem_cgroup_memcomp_id_get_ref(unsigned short id);
+void mem_cgroup_memcomp_id_put(unsigned short id);
+int mem_cgroup_memcomp_charge(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp, unsigned short id);
+#endif
+
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
 
 void __mem_cgroup_uncharge(struct folio *folio);
@@ -1207,6 +1222,36 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+#ifdef CONFIG_MEMCOMP
+static inline int mem_cgroup_memcomp_id_get_checked(struct folio *folio,
+						    unsigned short *id)
+{
+	*id = 0;
+	return 0;
+}
+
+static inline unsigned short mem_cgroup_memcomp_id_get(struct folio *folio)
+{
+	return 0;
+}
+
+static inline bool mem_cgroup_memcomp_id_get_ref(unsigned short id)
+{
+	return !id;
+}
+
+static inline void mem_cgroup_memcomp_id_put(unsigned short id)
+{
+}
+
+static inline int mem_cgroup_memcomp_charge(struct folio *folio,
+					    struct mm_struct *mm,
+					    gfp_t gfp, unsigned short id)
+{
+	return 0;
+}
+#endif
+
 static inline void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry, unsigned int nr)
 {
 }
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 83d188e927e0af6dd356d39c33026f860082056e..d289dd7e6d62ae5e7a957cacd892a0d05811533f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -306,6 +306,10 @@ struct swap_info_struct {
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
+#ifdef CONFIG_MEMCOMP
+	/* One bit per swap offset: 32 KiB for 1 GiB at 4 KiB/page. */
+	unsigned long *memcomp_transport;
+#endif
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
@@ -358,6 +362,37 @@ struct swap_info_struct {
 					   */
 };
 
+#ifdef CONFIG_MEMCOMP
+/* The caller keeps the device alive and owns the allocated swap slot. */
+static inline void swap_memcomp_transport_set(struct swap_info_struct *si,
+					      unsigned long offset)
+{
+	set_bit(offset, si->memcomp_transport);
+}
+
+static inline void swap_memcomp_transport_clear(struct swap_info_struct *si,
+						unsigned long offset,
+						unsigned int nr)
+{
+	unsigned int i;
+
+	/* Adjacent slots can be freed concurrently under different cluster locks. */
+	for (i = 0; i < nr; i++)
+		clear_bit(offset + i, si->memcomp_transport);
+}
+
+/* A locked swapcache folio holds SWAP_HAS_CACHE, so the bit is stable. */
+static inline bool swap_memcomp_transport_test(struct swap_info_struct *si,
+					       unsigned long offset)
+{
+	return test_bit(offset, si->memcomp_transport);
+}
+
+/* Only an inactive device may allocate or release its transport bitmap. */
+int swap_memcomp_transport_alloc(struct swap_info_struct *si);
+void swap_memcomp_transport_free(struct swap_info_struct *si);
+#endif
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
@@ -372,6 +407,10 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 				bool flush);
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
+#ifdef CONFIG_MEMCOMP
+void *workingset_memcomp_eviction(struct folio *folio,
+				  struct mem_cgroup *target_memcg);
+#endif
 void workingset_refault(struct folio *folio, void *shadow);
 void workingset_activation(struct folio *folio);
 
diff --git a/mm/memcomp.c b/mm/memcomp.c
index f5110f46b857407c15c77c215238c9b6e99413c6..01254bf22c8834dc61d731cf5f776cb77cd9c908 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -3140,6 +3140,7 @@ memcomp_arch_prepare_to_swap(struct folio *folio)
 
 /* Allocate @nr_pages consecutive tokens, skipping fragmented free ranges. */
 
+#include "memcomp/workingset_store.h"
 #include "memcomp/cache_store.h"
 #include "memcomp/cache_folio.h"
 
@@ -3278,7 +3279,7 @@ static void memcomp_writeback_slots_return(void)
  */
 static int memcomp_writeback_slot_take(swp_entry_t *swapp)
 {
-	unsigned int want;
+	unsigned int want, i;
 
 	if (!memcomp_writeback_slots_free) {
 		want = min_t(unsigned int, MEMCOMP_WRITEBACK_BATCH,
@@ -3290,6 +3291,13 @@ static int memcomp_writeback_slot_take(swp_entry_t *swapp)
 			get_swap_pages(want, memcomp_writeback_slot_pool, 0);
 		if (!memcomp_writeback_slots_free)
 			return get_nr_swap_pages() <= 0 ? -ENOSPC : -ENOMEM;
+		/* Mark the whole reservation, including slots later returned unused. */
+		for (i = 0; i < memcomp_writeback_slots_free; i++) {
+			swp_entry_t entry = memcomp_writeback_slot_pool[i];
+
+			swap_memcomp_transport_set(swp_swap_info(entry),
+						   swp_offset(entry));
+		}
 	}
 
 	*swapp = memcomp_writeback_slot_pool[--memcomp_writeback_slots_free];
@@ -3473,7 +3481,7 @@ static int memcomp_read_swapped_page(swp_entry_t swap, bool packed,
 	if (!folio)
 		return -ENOMEM;
 	if (allocated)
-		swap_read_folio(folio, NULL);
+		swap_read_folio_memcomp(folio, NULL);
 
 	folio_lock(folio);
 	if (!folio_test_uptodate(folio)) {
@@ -3895,6 +3903,7 @@ static bool memcomp_writeback_defrag_pass(void)
  * Core load - decompress one page from @entry into @dst.  Sleeps on the
  * token lock and possibly swap IO; never called under the PTE lock.
  */
+#include "memcomp/workingset_load.h"
 #include "memcomp/load.h"
 #include "memcomp/consumers.h"
 
diff --git a/mm/memcomp/anon_store.h b/mm/memcomp/anon_store.h
index c8749d315f2c63f28cdad7f48eac5aa1b926de6a..a0c01f9c52b039b81f01f6823267a7bb217e71f7 100644
--- a/mm/memcomp/anon_store.h
+++ b/mm/memcomp/anon_store.h
@@ -199,8 +199,14 @@ mc16_anon_refresh_full(struct memcomp_reclaim_ctx **ctxp, const void *src,
 		if (ret)
 			goto state_fail;
 		mutex_lock(memcomp_lock_of(refs[i].token));
-		ret = mc16_payload_commit_locked(&refs[i], folio, nr_pages, i,
-						 &payloads[i], &tail);
+		/* Close the gate before STORED/FIFO becomes visible under this T. */
+		ret = mc16_store_begin_locked(&refs[i], folio, nr_pages, i);
+		if (!ret) {
+			ret = mc16_payload_commit_locked(&refs[i], folio, nr_pages, i,
+							 &payloads[i], &tail);
+			if (ret)
+				*mc16_shadow_ptr(&refs[i]) = 0;
+		}
 		if (!ret)
 			mc16_zero_carrier_prepare_locked(store, &refs[i], nr_pages);
 		mutex_unlock(memcomp_lock_of(refs[i].token));
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
index 4cc192fba3af9cd858f5752a8e5e931ef4e3af8f..b73bde6c3d976f05bbe3ff35ecd57bf82f58f789 100644
--- a/mm/memcomp/api.h
+++ b/mm/memcomp/api.h
@@ -121,6 +121,12 @@ bool memcomp_release_folio(struct folio *folio)
 	return mc16_release_folio(folio);
 }
 
+bool memcomp_release_folio_reclaim(struct folio *folio,
+				   struct mem_cgroup *target_memcg)
+{
+	return mc16_release_folio_reclaim(folio, target_memcg);
+}
+
 void memcomp_rollback_folio(struct folio *folio)
 {
 	mc16_rollback_folio(folio);
@@ -161,6 +167,17 @@ bool memcomp_store_cache(struct folio *folio, unsigned long *token)
 	return mc16_store_cache_folio(folio, token);
 }
 
+void memcomp_publish_cache_eviction(struct folio *folio, struct memcomp_ref *ref)
+{
+	mc16_publish_cache_eviction(folio, ref);
+}
+
+int memcomp_charge_folio(struct memcomp_ref *ref, struct folio *folio,
+			 struct mm_struct *mm, gfp_t gfp)
+{
+	return mc16_user_charge(ref, folio, mm, gfp);
+}
+
 bool memcomp_load_folio_pin(unsigned long token, struct memcomp_ref *ref)
 {
 	return mc16_cache_pin(token, ref);
diff --git a/mm/memcomp/cache_folio.h b/mm/memcomp/cache_folio.h
index b0b9f154b42f02f54720f44f5c1e15dd2bf4140a..2bdc37b682a7ea598ba9af7ad721e3d50ff6d6ec 100644
--- a/mm/memcomp/cache_folio.h
+++ b/mm/memcomp/cache_folio.h
@@ -38,7 +38,7 @@ static inline bool mc16_store_cache_folio(struct folio *folio,
 		goto success;
 	}
 	src = kmap_local_folio(folio, 0);
-	ret = mc16_cache_store(src, folio, &initial);
+	ret = mc16_cache_store_prepared(src, folio, &initial);
 	kunmap_local(src);
 	if (ret)
 		goto fail_payload;
@@ -67,4 +67,28 @@ static inline bool mc16_store_cache_folio(struct folio *folio,
 	memcomp_debug_add(nr_pages, &memcomp_shmem_store_fail_pages);
 	return false;
 }
+
+/*
+ * The successful XA replacer borrows a guard acquired before taking XA.
+ * Cache preparation set PUBLISHING before the initial reference became
+ * selectable. That marker is never reopened by a cache reader/writer.
+ * The locked source pins its original folio_memcg until eviction completes;
+ * truncate may remove the cache owner, but cannot retire our guarded slot.
+ */
+static inline void
+mc16_publish_cache_eviction(struct folio *folio, struct memcomp_ref *ref)
+{
+	void *shadow;
+	bool prepared;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	mutex_lock(memcomp_lock_of(ref->token));
+	prepared = *mc16_shadow_ptr(ref) == MC16_SHADOW_PUBLISHING;
+	mutex_unlock(memcomp_lock_of(ref->token));
+	/* Idempotent: an already consumed shadow does not reopen its epoch. */
+	if (!prepared)
+		return;
+	shadow = mc16_store_eviction(folio, NULL);
+	mc16_store_publish(ref, 1, shadow);
+}
 #endif /* _MM_MEMCOMP_CACHE_FOLIO_H */
diff --git a/mm/memcomp/cache_store.h b/mm/memcomp/cache_store.h
index ca2d6097b491aeaaaf2807e367d37ec3f6b8cc8b..a81a2b8d56c50f0e22ae2a8293e3bee84c86dd71 100644
--- a/mm/memcomp/cache_store.h
+++ b/mm/memcomp/cache_store.h
@@ -17,13 +17,16 @@ static inline void mc16_cache_publish(struct memcomp_ref *ref, unsigned int byte
 	mc16_cache_activate(ref);
 }
 
-static inline int mc16_cache_store(const void *src, struct folio *account,
-				   struct memcomp_ref *out)
+static inline int mc16_cache_store_internal(const void *src,
+					    struct folio *account,
+					    struct memcomp_ref *out,
+					    bool prepared)
 {
 	struct mc16_initial_payload payload = { };
 	struct obj_cgroup *objcg;
 	unsigned long handle = 0;
 	unsigned int bytes = 0;
+	unsigned short owner_id;
 	u8 pool = 0;
 	int ret;
 
@@ -34,6 +37,9 @@ static inline int mc16_cache_store(const void *src, struct folio *account,
 		return -EINVAL;
 	if (!memcomp_is_enabled())
 		return -EOPNOTSUPP;
+	ret = mc16_source_id_get(account, &owner_id);
+	if (ret)
+		return ret;
 	/* Independent source owner, never a borrowed registry key across X1/X2. */
 	objcg = memcomp_objcg_get(account);
 	ret = memcomp_prepare_payload(src, PAGE_SIZE, &bytes, &handle, &pool,
@@ -50,11 +56,18 @@ static inline int mc16_cache_store(const void *src, struct folio *account,
 	if (ret)
 		goto out_payload;
 	payload = (struct mc16_initial_payload) { .word = handle, .bytes = bytes };
-	ret = mc16_reserve_cache(objcg, folio_nid(account), &payload, 1, out);
+	ret = mc16_reserve_cache_id(objcg, owner_id, folio_nid(account),
+				    &payload, 1, out);
 	if (ret) {
 		memcomp_objcg_uncharge(objcg, bytes);
 		goto out_payload;
 	}
+	/* The private refs-zero reservation is not selectable until activation. */
+	if (prepared) {
+		mutex_lock(memcomp_lock_of(out->token));
+		*mc16_shadow_ptr(out) = MC16_SHADOW_PUBLISHING;
+		mutex_unlock(memcomp_lock_of(out->token));
+	}
 	/* No pending/resident/OWNER transition or record/member RMW occurs. */
 	mc16_cache_publish(out, bytes);
 	ret = 0;
@@ -65,6 +78,20 @@ static inline int mc16_cache_store(const void *src, struct folio *account,
 out_owner:
 	if (objcg)
 		memcomp_objcg_put(objcg);
+	mem_cgroup_memcomp_id_put(owner_id);
 	return ret;
 }
+
+static inline int mc16_cache_store(const void *src, struct folio *account,
+				   struct memcomp_ref *out)
+{
+	return mc16_cache_store_internal(src, account, out, false);
+}
+
+static inline int mc16_cache_store_prepared(const void *src,
+					    struct folio *account,
+					    struct memcomp_ref *out)
+{
+	return mc16_cache_store_internal(src, account, out, true);
+}
 #endif /* _MM_MEMCOMP_CACHE_STORE_H */
diff --git a/mm/memcomp/consumers.h b/mm/memcomp/consumers.h
index 03aef9ffecb6df83b6314df43739677120fdd8f8..cdbd2262c632b089538c4abbbe5bcbb99bdc6c00 100644
--- a/mm/memcomp/consumers.h
+++ b/mm/memcomp/consumers.h
@@ -70,6 +70,7 @@ static inline bool mc16_cache_pin(unsigned long token, struct memcomp_ref *ref)
  */
 static inline int mc16_cache_load(struct memcomp_ref *ref, struct folio *folio)
 {
+	struct mc16_user_read scope;
 	void *dst;
 	int ret;
 
@@ -77,9 +78,14 @@ static inline int mc16_cache_load(struct memcomp_ref *ref, struct folio *folio)
 		return -ENOENT;
 	if (!folio || folio_test_large(folio) || !folio_test_locked(folio))
 		return -EINVAL;
+	ret = mc16_user_refault(ref, 1, folio);
+	if (ret)
+		return ret;
+	mc16_user_read_start(&scope, folio);
 	dst = kmap_local_folio(folio, 0);
 	ret = mc16_load_page(ref, dst);
 	kunmap_local(dst);
+	mc16_user_read_end(&scope);
 	if (!ret) {
 		__folio_mark_uptodate(folio);
 		flush_dcache_folio(folio);
diff --git a/mm/memcomp/fault.h b/mm/memcomp/fault.h
index afdde325c0e5f442868e9354d9abc84ae354bb0a..e051b0ee2c350101bebe5bb75b8cb813a883752c 100644
--- a/mm/memcomp/fault.h
+++ b/mm/memcomp/fault.h
@@ -22,6 +22,7 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 	unsigned int nr_pages = 1, fault_index = 0, i;
 	unsigned long start_addr = vmf->address, id_start = id;
 	struct folio *folio = NULL;
+	struct mc16_user_read scope;
 	pte_t *install_pte;
 	vm_fault_t ret = 0;
 	gfp_t alloc_gfp;
@@ -112,7 +113,7 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 		ret = VM_FAULT_OOM;
 		goto out_put;
 	}
-		err = mem_cgroup_charge(folio, vma->vm_mm, alloc_gfp);
+		err = mc16_user_charge(&refs[0], folio, vma->vm_mm, alloc_gfp);
 	if (err) {
 		if (nr_pages > 1) {
 			folio_put(folio);
@@ -162,6 +163,12 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 			goto fallback_single;
 		}
 	}
+	err = mc16_user_refault(refs, nr_pages, folio);
+	if (err) {
+		ret = err == -EAGAIN ? 0 : VM_FAULT_SIGBUS;
+		goto out_put;
+	}
+	mc16_user_read_start(&scope, folio);
 	/* A local highmem mapping covers one page, even for a large folio. */
 	for (i = 0, err = 0; i < nr_pages; i++) {
 		dst = kmap_local_folio(folio, i * PAGE_SIZE);
@@ -170,6 +177,7 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 		if (err)
 			break;
 	}
+	mc16_user_read_end(&scope);
 	if (err) {
 		if (err == -EAGAIN)
 			ret = 0;
@@ -179,6 +187,9 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 			ret = memcomp_fault_sigbus_or_retry(vmf);
 		goto out_put;
 	}
+	/* A new user folio was materialized; a later PTE race does not undo it. */
+	mc16_user_major(vma->vm_mm);
+	ret = VM_FAULT_MAJOR;
 	memcomp_arch_restore(id_start, folio);
 	__folio_mark_uptodate(folio);
 	/* No T survives mc16_load_page; PTL is acquired only after it returns. */
@@ -234,7 +245,7 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 	/* Each committed PTE owns a folio ref and relinquishes its token owner. */
 	for (i = 0; i < nr_pages; i++)
 		mc16_ref_put_count(&refs[i], 2);
-	return VM_FAULT_NOPAGE;
+	return VM_FAULT_NOPAGE | ret;
 
 out_unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
diff --git a/mm/memcomp/folio.h b/mm/memcomp/folio.h
index de8eeed276d9af56816d31ce85bd9341a9ee34a7..99ef0d51bedf0c503375876873bea7feac93be42 100644
--- a/mm/memcomp/folio.h
+++ b/mm/memcomp/folio.h
@@ -132,16 +132,20 @@ static inline void mc16_invalidate_folio(struct folio *folio)
 		put_anon_vma(anon_vma);
 }
 
-/* Success leaves the source frozen at zero, owned by the caller for freeing. */
-static inline bool mc16_release_folio(struct folio *folio)
+/*
+ * Success leaves the source frozen at zero, owned by the caller for freeing.
+ * Acquire the entire span first. Every fallible test precedes eviction, and
+ * no fallible sibling/head drop is allowed beyond that point.
+ */
+static inline bool
+mc16_release_folio_reclaim(struct folio *folio, struct mem_cgroup *target_memcg)
 {
-	struct mc16_owner_tail tail = { };
-	struct anon_vma *anon_vma = NULL;
-	struct memcomp_ref head;
-	struct mc16_view view;
-	unsigned int nr, i;
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	struct anon_vma *anon_vma;
+	unsigned int nr, i, held = 0;
+	unsigned long opened = 0;
 	u32 token;
-	bool dropped = false;
+	void *shadow;
 
 	if (!folio_test_locked(folio) || !folio_memcomp_reserved(folio))
 		return false;
@@ -154,50 +158,94 @@ static inline bool mc16_release_folio(struct folio *folio)
 		folio->swap.val = 0;
 		return true;
 	}
-	if (!mc16_folio_geometry(folio, &token, &nr) || !mc16_get(token, &head))
-		return false;
-	/* Resident PENDING holds reject the freeze without another T probe. */
-	if (!folio_ref_freeze(folio, 1)) {
-		mc16_ref_put(&head);
+	if (!mc16_folio_geometry(folio, &token, &nr) ||
+	    folio_mapped(folio) || folio_mapping(folio) ||
+	    folio_test_lru(folio) || folio_maybe_dma_pinned(folio))
 		return false;
+	for (i = 0; i < nr; i++) {
+		if (!mc16_get(token + i, &refs[i]))
+			goto fail;
+		held++;
 	}
-	/* The still-attached head owns the record throughout sibling detach. */
-	for (i = nr; i > 1; ) {
-		struct memcomp_ref sibling;
-
-		i--;
-		if (mc16_get(token + i, &sibling) &&
-		    !mc16_owner_drop_folio_held(&sibling, folio, nr, i)) {
-			mc16_ref_put(&head);
-			folio_ref_unfreeze(folio, 1);
-			return false;
+	for (i = 0; i < nr; i++) {
+		struct mc16_view view;
+		unsigned int state;
+		u64 *word;
+		bool valid;
+
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		word = mc16_shadow_ptr(&refs[i]);
+		valid = mc16_owner_can_drop_locked(&refs[i], folio, nr, i) &&
+			mc16_view_locked(&refs[i], &view);
+		if (valid) {
+			state = mc16_flags_state(*view.flags);
+			valid = (state == MC16_STORED || state == MC16_SAMEFILL) &&
+				!(*view.flags & (MC16_F_RESIDENT |
+						MC16_F_REFRESH_PENDING)) &&
+				(!*word || *word == MC16_SHADOW_PUBLISHING);
+		}
+		if (valid && !*word) {
+			/* Legacy low-level producers still require a real exit. */
+			*word = MC16_SHADOW_PUBLISHING;
+			opened |= BIT(i);
 		}
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		if (!valid)
+			goto fail;
 	}
+	/*
+	 * A resident actor that acquired a folio ref before its gate closed
+	 * makes this freeze fail. New actors see PUBLISHING under T. OWNER
+	 * plus our guards exclude refs-zero retirement even if every PTE zaps.
+	 */
+	if (!folio_ref_freeze(folio, 1))
+		goto fail;
+
+	/* From here on the transaction cannot fail or restore the source. */
 	mutex_lock(memcomp_lock_of(token));
-	if (mc16_owner_matches_locked(&head, folio, nr, 0) &&
-	    mc16_view_locked(&head, &view) && mc16_flags_valid(*view.flags) &&
-	    mc16_flags_state(*view.flags) != MC16_PENDING &&
-	    !(*view.flags & MC16_F_RESIDENT)) {
-		dropped = mc16_owner_drop_locked(&head, folio, nr, 0, &tail);
-		/* The detach tail owns this member until its final put below. */
-		if (dropped && tail.record &&
-		    (tail.record->record_flags & MC16_RECORD_ANON_VMA)) {
-			anon_vma = tail.record->anon_vma;
-			tail.record->anon_vma = NULL;
-			tail.record->record_flags &= ~MC16_RECORD_ANON_VMA;
+	anon_vma = mc16_span_take_anon_vma_locked(&refs[0], folio, nr);
+	mutex_unlock(memcomp_lock_of(token));
+	shadow = mc16_store_eviction(folio, target_memcg);
+	/* Detach head last, retaining every slot guard through publication. */
+	for (i = nr; i; ) {
+		struct mc16_owner_tail tail = { };
+
+		i--;
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		mc16_owner_detach_locked(&refs[i], &tail);
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		/* Only OWNER is retired here; keep the full-span lookup guards. */
+		{
+			struct memcomp_ref owner = refs[i];
+
+			mc16_ref_put(&owner);
 		}
+		mc16_owner_tail_put(&tail);
 	}
-	mutex_unlock(memcomp_lock_of(token));
-	mc16_ref_put_count(&head, dropped ? 2 : 1);
-	mc16_owner_tail_put(&tail);
+	mc16_store_publish(refs, nr, shadow);
+	for (i = 0; i < nr; i++)
+		mc16_ref_put(&refs[i]);
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-	if (!dropped) {
-		folio_ref_unfreeze(folio, 1);
-		return false;
-	}
 	folio->swap.val = 0;
 	return true;
+fail:
+	for (i = 0; i < held; i++) {
+		if (opened & BIT(i)) {
+			mutex_lock(memcomp_lock_of(refs[i].token));
+			*mc16_shadow_ptr(&refs[i]) = 0;
+			mutex_unlock(memcomp_lock_of(refs[i].token));
+		}
+		mc16_ref_put(&refs[i]);
+	}
+	/* Prepared payload gates live until the caller's rollback/retry. */
+	return false;
+}
+
+/* Compatibility API, not a test bypass: NULL is stock's global reclaim. */
+static inline bool mc16_release_folio(struct folio *folio)
+{
+	return mc16_release_folio_reclaim(folio, NULL);
 }
 
 /* OWNER + this probe's lookup is two, including the borrowed head lookup. */
diff --git a/mm/memcomp/load.h b/mm/memcomp/load.h
index ddfab6c83b4fc50ddf8ebb861296970e173774a6..ea6d6efa448dbfac3c94621e8e68179cbc035046 100644
--- a/mm/memcomp/load.h
+++ b/mm/memcomp/load.h
@@ -19,6 +19,10 @@ static inline int mc16_load_page(struct memcomp_ref *ref, void *dst)
 		ret = -EIO;
 		goto out;
 	}
+	if (*mc16_shadow_ptr(ref) == MC16_SHADOW_PUBLISHING) {
+		ret = -EAGAIN;
+		goto out;
+	}
 	if (*view.flags & MC16_F_REFRESH_PENDING) {
 		ret = -EAGAIN;
 		goto out;
diff --git a/mm/memcomp/owner.h b/mm/memcomp/owner.h
index 2d5505fb81ae1e19dab39b1201df6573668c102e..d28aa234157de957ff07bafaa35376439137c368 100644
--- a/mm/memcomp/owner.h
+++ b/mm/memcomp/owner.h
@@ -3,6 +3,8 @@
 #define _MM_MEMCOMP_OWNER_H
 
 /* Include after access/refs and memcomp_state_drop_owner(). */
+#include "workingset_store.h"
+
 struct mc16_owner_tail {
 	struct mc16_record *record;
 	bool resident;
@@ -22,9 +24,8 @@ struct mc16_owner_tail {
  * anon_vma must be handed off by the producer, never put by a PTL finalizer.
  */
 static inline bool
-mc16_owner_drop_locked(struct memcomp_ref *ref, struct folio *folio,
-		       unsigned int nr_pages, unsigned int page_idx,
-		       struct mc16_owner_tail *tail)
+mc16_owner_can_drop_locked(struct memcomp_ref *ref, struct folio *folio,
+			   unsigned int nr_pages, unsigned int page_idx)
 {
 	struct mc16_swap_fields swap;
 	struct mc16_view view;
@@ -57,6 +58,51 @@ mc16_owner_drop_locked(struct memcomp_ref *ref, struct folio *folio,
 			return false;
 	}
 
+	return true;
+}
+
+/*
+ * Infallible detach after whole-span validation, PUBLISHING and folio freeze.
+ * Source OWNER + guard keep the record attached despite concurrent PTE zap.
+ * Do not use a sequence of fallible sibling drops after recording eviction.
+ */
+static inline void
+mc16_owner_detach_locked(struct memcomp_ref *ref, struct mc16_owner_tail *tail)
+{
+	struct mc16_view view;
+	u16 flags;
+
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	mc16_view_locked(ref, &view);
+	flags = *view.flags;
+	memcomp_state_drop_owner();
+	view.member->owner_folio = NULL;
+	view.member->payload_charge = 0;
+	ref->slot->word = *view.word;
+	ref->slot->length = *view.length;
+	/* Publish the detached payload before lockless SAMEFILL readers run. */
+	smp_store_release(&ref->slot->flags, flags & ~MC16_F_OWNER);
+	*tail = (struct mc16_owner_tail) { .record = view.record };
+}
+
+static inline bool
+mc16_owner_drop_locked(struct memcomp_ref *ref, struct folio *folio,
+		       unsigned int nr_pages, unsigned int page_idx,
+		       struct mc16_owner_tail *tail)
+{
+	struct mc16_view view;
+	u16 flags;
+	bool resident;
+
+	if (!mc16_owner_can_drop_locked(ref, folio, nr_pages, page_idx))
+		return false;
+	mc16_view_locked(ref, &view);
+	flags = *view.flags;
+	resident = mc16_flags_state(flags) == MC16_PENDING &&
+		   (flags & MC16_F_RESIDENT);
+	/* Rollback/invalidation never creates a workingset shadow. */
+	if (*mc16_shadow_ptr(ref) == MC16_SHADOW_PUBLISHING)
+		*mc16_shadow_ptr(ref) = 0;
 	memcomp_state_drop_owner();
 	*view.flags = flags & ~MC16_F_OWNER;
 	*tail = (struct mc16_owner_tail) { .resident = resident };
diff --git a/mm/memcomp/storage.h b/mm/memcomp/storage.h
index f11aad87a1773c0e2f16b1bb3d506cb4caeb7386..1379e0dd546bf95c65d78d6140b6561575ea7477 100644
--- a/mm/memcomp/storage.h
+++ b/mm/memcomp/storage.h
@@ -45,6 +45,8 @@
 #define MC16_KEY_HASH_BITS	8
 #define MC16_CLUSTER_AGED	BIT(0)
 #define MC16_AGING_BATCH	32
+/* A private non-value marker; never insert it into an XArray. */
+#define MC16_SHADOW_PUBLISHING	2ULL
 
 struct mc16_key;
 
@@ -64,6 +66,7 @@ struct mc16_cluster {
 	u64 metadata_bytes;
 	u8 segment_live[MC16_SEGMENTS];
 	u8 reserved[8];
+	u64 *shadows[MC16_SEGMENTS];
 };
 
 enum mc16_key_kind {
@@ -78,6 +81,7 @@ struct mc16_key {
 	u64 metadata_bytes;
 	u32 clusters;		/* X protected, including queued header callbacks. */
 	u16 nid;
+	unsigned short owner_id;
 	u8 kind;
 	u8 zero_hint;
 };
@@ -85,9 +89,10 @@ struct mc16_key {
 struct mc16_segment_retire {
 	struct rcu_head rcu;
 	struct mc16_slot *segment;
+	u64 *shadows;
 };
 
-static_assert(sizeof(struct mc16_cluster) == 128);
+static_assert(sizeof(struct mc16_cluster) == 192);
 static_assert(offsetof(struct mc16_cluster, segments) == 0);
 static_assert(offsetof(struct mc16_cluster, key) == 64);
 static_assert(offsetof(struct mc16_cluster, fifo) == 72);
@@ -101,14 +106,18 @@ static_assert(offsetof(struct mc16_cluster, eligible_slots) == 102);
 static_assert(offsetof(struct mc16_cluster, metadata_bytes) == 104);
 static_assert(offsetof(struct mc16_cluster, segment_live) == 112);
 static_assert(offsetof(struct mc16_cluster, reserved) == 120);
+static_assert(offsetof(struct mc16_cluster, shadows) == 128);
 static_assert(sizeof(struct memcomp_ref) == 24);
 static_assert(MC16_SEGMENT_SLOTS * sizeof(struct mc16_slot) == 1024);
+static_assert(MC16_SEGMENT_SLOTS * sizeof(u64) == 512);
+static_assert(!(MC16_SHADOW_PUBLISHING & 1));
 
 enum mc16_storage_class {
 	MC16_META_SEGMENT,
 	MC16_META_CLUSTER,
 	MC16_META_KEY,
 	MC16_META_DESCRIPTOR,
+	MC16_META_SHADOW,
 	MC16_META_CLASSES,
 };
 
@@ -269,26 +278,52 @@ static inline void *mc16_alloc_zero(enum mc16_storage_class type,
 	return ptr;
 }
 
+/*
+ * A request owns a temporary source ID reference across X1/X2. Each key takes
+ * another reference, independent of objcg reparenting and the request lifetime.
+ */
+static inline int mc16_source_id_get(struct folio *folio, unsigned short *id)
+{
+	return mem_cgroup_memcomp_id_get_checked(folio, id);
+}
+
+static inline bool mc16_owner_id_get_ref(unsigned short id)
+{
+	return mem_cgroup_memcomp_id_get_ref(id);
+}
+
+static inline void mc16_owner_id_put(unsigned short id)
+{
+	mem_cgroup_memcomp_id_put(id);
+}
+
 /* Caller holds mc16_clusters.xa_lock for every key/current operation. */
+static inline unsigned long
+mc16_key_tag_id(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+		bool zero_hint, unsigned short owner_id)
+{
+	return (unsigned long)objcg ^ ((unsigned long)nid << 1) ^ kind ^
+		((unsigned long)zero_hint << 3) ^ ((unsigned long)owner_id << 4);
+}
+
 static inline unsigned long mc16_key_tag(struct obj_cgroup *objcg,
 					 unsigned int nid, u8 kind,
 					 bool zero_hint)
 {
-	return (unsigned long)objcg ^ ((unsigned long)nid << 1) ^ kind ^
-		((unsigned long)zero_hint << 3);
+	return mc16_key_tag_id(objcg, nid, kind, zero_hint, 0);
 }
 
 static inline struct mc16_key *
-mc16_key_find(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
-	      bool zero_hint)
+mc16_key_find_id(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+		 bool zero_hint, unsigned short owner_id)
 {
 	struct mc16_key *key;
-	unsigned long tag = mc16_key_tag(objcg, nid, kind, zero_hint);
+	unsigned long tag = mc16_key_tag_id(objcg, nid, kind, zero_hint, owner_id);
 
 	lockdep_assert_held(&mc16_clusters.xa_lock);
 	hash_for_each_possible(mc16_keys, key, node, tag) {
 		if (key->objcg == objcg && key->nid == nid && key->kind == kind &&
-		    key->zero_hint == zero_hint)
+		    key->zero_hint == zero_hint && key->owner_id == owner_id)
 			return key;
 	}
 	return NULL;
@@ -308,8 +343,8 @@ static inline struct mc16_key *mc16_key_zalloc(void)
 
 /* Key slab is manually charged, with one independent test-aware objcg hold. */
 static inline struct mc16_key *
-mc16_key_alloc(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
-	       bool zero_hint)
+mc16_key_alloc_id(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+		  bool zero_hint, unsigned short owner_id)
 {
 	struct mc16_key *key;
 	int ret;
@@ -319,10 +354,16 @@ mc16_key_alloc(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
 		return ERR_PTR(-ENOMEM);
 	mc16_meta_alloc(MC16_META_KEY, key);
 	key->metadata_bytes = ksize(key);
+	if (!mc16_owner_id_get_ref(owner_id)) {
+		mc16_meta_free(MC16_META_KEY, key);
+		return ERR_PTR(-ENOENT);
+	}
+	key->owner_id = owner_id;
 	if (objcg) {
 		ret = memcomp_objcg_charge(objcg, GFP_NOIO | __GFP_NOWARN,
 					   key->metadata_bytes);
 		if (ret) {
+			mc16_owner_id_put(owner_id);
 			mc16_meta_free(MC16_META_KEY, key);
 			return ERR_PTR(ret);
 		}
@@ -335,6 +376,14 @@ mc16_key_alloc(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
 	return key;
 }
 
+/* Legacy storage fixtures use an unrecorded ID, not root's real ID. */
+static inline struct mc16_key *
+mc16_key_alloc(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+	       bool zero_hint)
+{
+	return mc16_key_alloc_id(objcg, nid, kind, zero_hint, 0);
+}
+
 static inline void mc16_key_free(struct mc16_key *key)
 {
 	struct obj_cgroup *objcg;
@@ -346,6 +395,7 @@ static inline void mc16_key_free(struct mc16_key *key)
 		memcomp_objcg_uncharge(objcg, key->metadata_bytes);
 		memcomp_objcg_put(objcg);
 	}
+	mc16_owner_id_put(key->owner_id);
 	mc16_meta_free(MC16_META_KEY, key);
 }
 
@@ -389,12 +439,37 @@ static inline bool mc16_get(unsigned long token, struct memcomp_ref *out)
 	return found;
 }
 
+/*
+ * A guard (or an unpublished reservation) pins both arrays. Only T permits
+ * reading/writing the returned word; it must not escape that critical section.
+ */
+static inline u64 *mc16_shadow_ptr(const struct memcomp_ref *ref)
+{
+	unsigned int index, seg;
+
+	if (WARN_ON_ONCE(!ref || !ref->slot || !ref->cluster))
+		return NULL;
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	index = ref->token & (MC16_CLUSTER_SLOTS - 1);
+	seg = index >> MC16_SEGMENT_SHIFT;
+	if (WARN_ON_ONCE(!ref->cluster->shadows[seg]))
+		return NULL;
+	return &ref->cluster->shadows[seg][index & (MC16_SEGMENT_SLOTS - 1)];
+}
+
+/* The key identity is immutable and survives every held guard. */
+static inline unsigned short mc16_owner_id(const struct memcomp_ref *ref)
+{
+	return ref->cluster->key->owner_id;
+}
+
 static inline void mc16_segment_rcu_free(struct rcu_head *rcu)
 {
 	struct mc16_segment_retire *retired;
 
 	retired = container_of(rcu, struct mc16_segment_retire, rcu);
 	mc16_meta_free(MC16_META_SEGMENT, retired->segment);
+	mc16_meta_free(MC16_META_SHADOW, retired->shadows);
 	mc16_meta_free(MC16_META_DESCRIPTOR, retired);
 }
 
@@ -407,8 +482,10 @@ static inline void mc16_cluster_rcu_free(struct rcu_head *rcu)
 
 	cluster = container_of(rcu, struct mc16_cluster, rcu);
 	key = cluster->key;
-	for (i = 0; i < MC16_SEGMENTS; i++)
+	for (i = 0; i < MC16_SEGMENTS; i++) {
 		mc16_meta_free(MC16_META_SEGMENT, cluster->segments[i]);
+		mc16_meta_free(MC16_META_SHADOW, cluster->shadows[i]);
+	}
 	mc16_meta_free(MC16_META_CLUSTER, cluster);
 
 	/* A queued header still owns its key until this exact transaction. */
@@ -643,8 +720,10 @@ static inline void mc16_retire_slot(struct memcomp_ref *ref)
 		if (retired) {
 			mc16_meta_alloc(MC16_META_DESCRIPTOR, retired);
 			retired->segment = segment;
+			retired->shadows = cluster->shadows[seg];
 			/* Old RCU readers retain permanently zero refs until grace. */
 			smp_store_release(&cluster->segments[seg], NULL);
+			cluster->shadows[seg] = NULL;
 		} else {
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 			this_cpu_inc(mc16_storage_debug.descriptor_failures);
@@ -702,6 +781,7 @@ struct mc16_reserve_request {
 	struct obj_cgroup *objcg;
 	unsigned int nid;
 	unsigned int nr;
+	unsigned short owner_id;
 	u8 kind;
 	bool zero_hint;
 };
@@ -764,6 +844,7 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 	struct mc16_cluster *cluster = NULL, *spare_cluster = NULL;
 	struct mc16_cluster *replaced = NULL;
 	struct mc16_slot *spare_segment = NULL;
+	u64 *spare_shadows = NULL;
 	struct mc16_key *key, *spare_key = NULL;
 	struct obj_cgroup *objcg = request->objcg;
 	unsigned int nr = request->nr, nid = request->nid;
@@ -772,13 +853,15 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 	unsigned long irqflags;
 	bool new_cluster, new_key, reserved = false;
 	u8 kind = request->kind;
+	unsigned short owner_id = request->owner_id;
 	int ret = 0;
 	void *old;
 
 	memset(refs, 0, sizeof(*refs) * nr);
 
 	xa_lock_irqsave(&mc16_clusters, irqflags);
-	key = mc16_key_find(objcg, nid, kind, request->zero_hint);
+	key = mc16_key_find_id(objcg, nid, kind, request->zero_hint,
+			       owner_id);
 	cluster = key ? key->current_cluster : NULL;
 	if (mc16_range(cluster, nr, &index)) {
 		seg = index >> MC16_SEGMENT_SHIFT;
@@ -818,6 +901,12 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 		ret = -ENOMEM;
 		goto recheck;
 	}
+	spare_shadows = mc16_alloc_zero(MC16_META_SHADOW,
+					MC16_SEGMENT_SLOTS * sizeof(*spare_shadows), objcg);
+	if (!spare_shadows) {
+		ret = -ENOMEM;
+		goto recheck;
+	}
 	if (new_cluster) {
 		spare_cluster = mc16_alloc_zero(MC16_META_CLUSTER,
 						sizeof(*spare_cluster), objcg);
@@ -829,8 +918,8 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 		INIT_LIST_HEAD(&spare_cluster->fifo);
 	}
 	if (new_key) {
-		spare_key = mc16_key_alloc(objcg, nid, kind,
-					   request->zero_hint);
+		spare_key = mc16_key_alloc_id(objcg, nid, kind,
+					      request->zero_hint, owner_id);
 		if (IS_ERR(spare_key)) {
 			ret = PTR_ERR(spare_key);
 			spare_key = NULL;
@@ -840,7 +929,8 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 	xa_lock_irqsave(&mc16_clusters, irqflags);
 	if (ret)
 		goto cancel;
-	key = mc16_key_find(objcg, nid, kind, request->zero_hint);
+	key = mc16_key_find_id(objcg, nid, kind, request->zero_hint,
+			       owner_id);
 	cluster = key ? key->current_cluster : NULL;
 	/* Reject competing consumption/retirement without another allocation. */
 	if ((cluster ? cluster->id : 0) != target_id ||
@@ -877,8 +967,8 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 		spare_cluster = NULL;
 		if (key == spare_key) {
 			hash_add(mc16_keys, &key->node,
-				 mc16_key_tag(objcg, nid, kind,
-					      request->zero_hint));
+				 mc16_key_tag_id(objcg, nid, kind,
+						 request->zero_hint, owner_id));
 			spare_key = NULL;
 		}
 		key->clusters++;
@@ -890,6 +980,9 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 		index = 0;
 	}
 	seg = index >> MC16_SEGMENT_SHIFT;
+	/* Publish the zeroed shadow array before either lookup publication. */
+	cluster->shadows[seg] = spare_shadows;
+	spare_shadows = NULL;
 	/* Pair with lookup acquire; only new, zeroed storage is installed. */
 	smp_store_release(&cluster->segments[seg], spare_segment);
 	spare_segment = NULL;
@@ -902,6 +995,7 @@ mc16_reserve_request(const struct mc16_reserve_request *request,
 	xa_unlock_irqrestore(&mc16_clusters, irqflags);
 	/* Unpublished resources only; source/payload ownership stays with caller. */
 	mc16_meta_free(MC16_META_SEGMENT, spare_segment);
+	mc16_meta_free(MC16_META_SHADOW, spare_shadows);
 	mc16_meta_free(MC16_META_CLUSTER, spare_cluster);
 	mc16_key_free(spare_key);
 	if (replaced)
@@ -915,18 +1009,25 @@ static inline int mc16_reserve_hint(struct mc16_record *record, unsigned int nr,
 				    struct memcomp_ref refs[])
 {
 	struct mc16_reserve_request request;
+	unsigned short owner_id;
+	int ret;
 
 	if (!record || !refs || !record->producer || !nr ||
 	    nr > MC16_MAX_PAGES || !is_power_of_2(nr) ||
 	    record->nr_pages != nr ||
 	    kind != !!(record->record_flags & MC16_RECORD_SHMEM))
 		return -EINVAL;
+	ret = mc16_source_id_get(record->producer, &owner_id);
+	if (ret)
+		return ret;
 	request = (struct mc16_reserve_request) {
-		.record = record, .objcg = record->objcg,
+		.record = record, .objcg = record->objcg, .owner_id = owner_id,
 		.nid = record->nid, .nr = nr, .kind = kind,
 		.zero_hint = zero_hint,
 	};
-	return mc16_reserve_request(&request, refs);
+	ret = mc16_reserve_request(&request, refs);
+	mem_cgroup_memcomp_id_put(owner_id);
+	return ret;
 }
 
 static inline int mc16_reserve(struct mc16_record *record, unsigned int nr,
@@ -938,7 +1039,8 @@ static inline int mc16_reserve(struct mc16_record *record, unsigned int nr,
 /*
  * Direct SHMEM cache ownership: no record, resident folio hold or lookup ref.
  * Caller holds objcg (NULL for root), zs handles and exact bytes charges before
- * entry, keeps objcg alive until return, and keeps payloads immutable throughout.
+ * entry, keeps objcg and owner_id alive until return, and keeps payloads immutable.
+ * The ID is borrowed; a new key takes its own reference. ID 0 needs no hold.
  * Validate the entire span before X1: no error may follow partial publication.
  * bytes == 0 is a full-width SAMEFILL word; otherwise word is a nonzero zs handle.
  * Success transfers payload/charge ownership to stable slots, backed by the key's
@@ -950,9 +1052,10 @@ static inline int mc16_reserve(struct mc16_record *record, unsigned int nr,
  * private reservation or confuse its initial zero with a retired index.
  */
 static inline int
-mc16_reserve_cache(struct obj_cgroup *objcg, unsigned int nid,
-		   const struct mc16_initial_payload payloads[],
-		   unsigned int nr, struct memcomp_ref refs[])
+mc16_reserve_cache_id(struct obj_cgroup *objcg, unsigned short owner_id,
+		      unsigned int nid,
+		      const struct mc16_initial_payload payloads[],
+		      unsigned int nr, struct memcomp_ref refs[])
 {
 	struct mc16_reserve_request request;
 	unsigned int i, order, state;
@@ -971,11 +1074,23 @@ mc16_reserve_cache(struct obj_cgroup *objcg, unsigned int nid,
 			return -EINVAL;
 	}
 	request = (struct mc16_reserve_request) {
-		.payloads = payloads, .objcg = objcg,
+		.payloads = payloads, .objcg = objcg, .owner_id = owner_id,
 		.nid = nid, .nr = nr, .kind = MC16_KEY_SHMEM,
 		.zero_hint = false,
 	};
 	return mc16_reserve_request(&request, refs);
 }
 
+/*
+ * Compatibility for storage-only fixtures. Production cache callers pass a
+ * source-folio ID via mc16_reserve_cache_id(), held until reserve returns.
+ */
+static inline int
+mc16_reserve_cache(struct obj_cgroup *objcg, unsigned int nid,
+		   const struct mc16_initial_payload payloads[],
+		   unsigned int nr, struct memcomp_ref refs[])
+{
+	return mc16_reserve_cache_id(objcg, 0, nid, payloads, nr, refs);
+}
+
 #endif /* _MM_MEMCOMP_STORAGE_H */
diff --git a/mm/memcomp/swapoff.h b/mm/memcomp/swapoff.h
index 02460d353e593526a640e2893b8e8981e3985d71..9ddee36a9f561103fbefea1f91217ffa0b0617f5 100644
--- a/mm/memcomp/swapoff.h
+++ b/mm/memcomp/swapoff.h
@@ -101,6 +101,10 @@ mc16_swapoff_entry(struct memcomp_ref *ref, unsigned int type,
 		ret = -EIO;
 		goto out_unlock;
 	}
+	if (*mc16_shadow_ptr(ref) == MC16_SHADOW_PUBLISHING) {
+		ret = 0;
+		goto out_unlock;
+	}
 	if (mc16_flags_state(*view.flags) != MC16_SWAPPED) {
 		ret = 0;
 		goto out_unlock;
diff --git a/mm/memcomp/workingset_load.h b/mm/memcomp/workingset_load.h
new file mode 100644
index 0000000000000000000000000000000000000000..f939a2d396ae4eb285ef782d771d7ea1e416b21d
--- /dev/null
+++ b/mm/memcomp/workingset_load.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_WORKINGSET_LOAD_H
+#define _MM_MEMCOMP_WORKINGSET_LOAD_H
+
+#include <linux/delayacct.h>
+#include <linux/psi.h>
+
+/*
+ * The guard pins the immutable source ID independently of objcg reparenting.
+ * Charge may reclaim: callers retain no record pointer or T/PTL/XA lock.
+ */
+static inline int mc16_user_charge(struct memcomp_ref *ref, struct folio *folio,
+				   struct mm_struct *mm, gfp_t gfp)
+{
+	return mem_cgroup_memcomp_charge(folio, mm, gfp,
+					 ref->cluster->key->owner_id);
+}
+
+/*
+ * Charge precedes this transaction. Stable nonresident slots never return to
+ * PENDING. First validate the whole guarded span, then take-clear each word
+ * under its own T. No T survives the call into the stock workingset policy.
+ * Like swapcache insertion, a later read/install failure does not undo it.
+ */
+static inline int mc16_user_refault(struct memcomp_ref *refs, unsigned int nr,
+				    struct folio *folio)
+{
+	unsigned long shadow = 0;
+	unsigned int i;
+
+	for (i = 0; i < nr; i++) {
+		struct mc16_view view;
+		u64 *word;
+		int ret = 0;
+
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		word = mc16_shadow_ptr(&refs[i]);
+		if (!word || !mc16_view_locked(&refs[i], &view) ||
+		    !mc16_flags_valid(*view.flags))
+			ret = -EIO;
+		else if (mc16_flags_state(*view.flags) == MC16_PENDING ||
+			 (*view.flags & MC16_F_RESIDENT) ||
+			 *word == MC16_SHADOW_PUBLISHING)
+			ret = -EAGAIN;
+		else if (*word && !xa_is_value((void *)(unsigned long)*word))
+			ret = -EIO;
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		if (ret)
+			return ret;
+	}
+	for (i = 0; i < nr; i++) {
+		u64 *word;
+
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		word = mc16_shadow_ptr(&refs[i]);
+		if (!i)
+			shadow = *word;
+		*word = 0;
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+	}
+	if (shadow)
+		workingset_refault(folio, (void *)shadow);
+	return 0;
+}
+
+struct mc16_user_read {
+	unsigned long pflags;
+	bool in_thrashing;
+	bool workingset;
+};
+
+static inline void mc16_user_read_start(struct mc16_user_read *scope,
+					struct folio *folio)
+{
+	scope->workingset = folio_test_workingset(folio);
+	if (scope->workingset) {
+		delayacct_thrashing_start(&scope->in_thrashing);
+		psi_memstall_enter(&scope->pflags);
+	}
+	delayacct_swapin_start();
+}
+
+static inline void mc16_user_read_end(struct mc16_user_read *scope)
+{
+	if (scope->workingset) {
+		delayacct_thrashing_end(&scope->in_thrashing);
+		psi_memstall_leave(&scope->pflags);
+	}
+	delayacct_swapin_end();
+}
+
+static inline void mc16_user_major(struct mm_struct *mm)
+{
+	count_vm_event(PGMAJFAULT);
+	count_memcg_event_mm(mm, PGMAJFAULT);
+}
+#endif /* _MM_MEMCOMP_WORKINGSET_LOAD_H */
diff --git a/mm/memcomp/workingset_store.h b/mm/memcomp/workingset_store.h
new file mode 100644
index 0000000000000000000000000000000000000000..32629bb1e9ea1793f756ec8856371bd474e182d8
--- /dev/null
+++ b/mm/memcomp/workingset_store.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_WORKINGSET_STORE_H
+#define _MM_MEMCOMP_WORKINGSET_STORE_H
+
+/*
+ * Author: nakixii
+ *
+ * Include after storage/access/refs. A slot guard protects the side word;
+ * its token mutex T serializes every change. PUBLISHING excludes payload
+ * readers and background actors, not token reference removal by PTE zap.
+ * Only a source OWNER in its first PENDING epoch can open this gate.
+ */
+#define mc16_store_eviction workingset_memcomp_eviction
+
+static inline int
+mc16_store_begin_locked(struct memcomp_ref *ref, struct folio *folio,
+			unsigned int nr, unsigned int index)
+{
+	struct mc16_view view;
+
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	if (!mc16_owner_matches_locked(ref, folio, nr, index) ||
+	    !mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags) ||
+	    mc16_flags_state(*view.flags) != MC16_PENDING ||
+	    !(*view.flags & MC16_F_RESIDENT) || *mc16_shadow_ptr(ref))
+		return -EAGAIN;
+	*mc16_shadow_ptr(ref) = MC16_SHADOW_PUBLISHING;
+	return 0;
+}
+
+/*
+ * The caller has crossed its last fallible point with all span guards held.
+ * The source folio lock, source OWNER and PUBLISHING prevent any actor from
+ * changing this epoch. No T, PTL or XArray lock is held during eviction.
+ * Each base page gets the same stock shadow, with one folio-sized delta.
+ */
+static inline void
+mc16_store_publish(struct memcomp_ref *refs, unsigned int nr, void *shadow)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr; i++) {
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		VM_WARN_ON_ONCE(*mc16_shadow_ptr(&refs[i]) != MC16_SHADOW_PUBLISHING);
+		/* Make this epoch's shadow visible before admitting user reads. */
+		smp_store_release(mc16_shadow_ptr(&refs[i]),
+				  (u64)(unsigned long)shadow);
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+	}
+}
+
+#endif /* _MM_MEMCOMP_WORKINGSET_STORE_H */
diff --git a/mm/memcomp/writeback.h b/mm/memcomp/writeback.h
index e0dcd43940215c5d7b512b5249b2b794ec7b5754..598ba2b4fbe85de2057672a61f6f321f4bb4c72c 100644
--- a/mm/memcomp/writeback.h
+++ b/mm/memcomp/writeback.h
@@ -28,7 +28,8 @@ mc16_writeback_claim_locked(struct memcomp_ref *ref,
 	struct mc16_view view;
 	u32 bytes;
 
-	if (!mc16_view_locked(ref, &view) ||
+	if (*mc16_shadow_ptr(ref) == MC16_SHADOW_PUBLISHING ||
+	    !mc16_view_locked(ref, &view) ||
 	    !mc16_flags_valid(*view.flags) ||
 	    mc16_flags_state(*view.flags) != MC16_STORED ||
 	    (*view.flags & MC16_F_RESIDENT) || !*view.word ||
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d1e402f06f22a7a2e64eba4f9e8d66b6f193b2b..3181540447790b42a00d9526fd50c4ca1d278154 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3408,6 +3408,79 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return xa_load(&mem_cgroup_ids, id);
 }
 
+#ifdef CONFIG_MEMCOMP
+/*
+ * The caller stabilizes an ordinary anon/shmem folio's memcg binding, e.g.
+ * with the folio lock. Unlike objcg, this identity must not follow reparenting.
+ * Uncharged folios belong to root, which has a real, independently pinned ID.
+ * ID 0 selects the fault mm only for disabled or already retired identities.
+ * An online identity that cannot be pinned must fail reserve, not become ID 0.
+ */
+int mem_cgroup_memcomp_id_get_checked(struct folio *folio, unsigned short *id)
+{
+	struct mem_cgroup *memcg;
+	int ret = 0;
+
+	*id = 0;
+	if (mem_cgroup_disabled())
+		return 0;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	if (refcount_inc_not_zero(&memcg->id.ref)) {
+		*id = mem_cgroup_id(memcg);
+	} else if (css_tryget_online(&memcg->css)) {
+		/* Online state normally already owns an ID reference. */
+		css_put(&memcg->css);
+		ret = -EAGAIN;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/* Convenience for callers with an already known, available source identity. */
+unsigned short mem_cgroup_memcomp_id_get(struct folio *folio)
+{
+	unsigned short id;
+
+	WARN_ON_ONCE(mem_cgroup_memcomp_id_get_checked(folio, &id));
+	return id;
+}
+
+/* The caller keeps its existing ID reference until this operation returns. */
+bool mem_cgroup_memcomp_id_get_ref(unsigned short id)
+{
+	struct mem_cgroup *memcg;
+	bool got;
+
+	if (!id)
+		return true;
+	if (mem_cgroup_disabled())
+		return false;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	got = memcg && refcount_inc_not_zero(&memcg->id.ref);
+	rcu_read_unlock();
+	return got;
+}
+
+void mem_cgroup_memcomp_id_put(unsigned short id)
+{
+	struct mem_cgroup *memcg;
+
+	if (!id || mem_cgroup_disabled())
+		return;
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (!WARN_ON_ONCE(!memcg))
+		mem_cgroup_id_put(memcg);
+	rcu_read_unlock();
+}
+#endif
+
 #ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
@@ -4574,6 +4647,32 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 	return ret;
 }
 
+#ifdef CONFIG_MEMCOMP
+/*
+ * Same charge and offline fallback as swapin, without a real swap entry or
+ * any swap accounting. The source ID is kept alive by the slot's key.
+ */
+int mem_cgroup_memcomp_charge(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp, unsigned short id)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	if (mem_cgroup_disabled())
+		return 0;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (!memcg || !css_tryget_online(&memcg->css))
+		memcg = get_mem_cgroup_from_mm(mm);
+	rcu_read_unlock();
+
+	ret = charge_memcg(folio, memcg, gfp);
+	css_put(&memcg->css);
+	return ret;
+}
+#endif
+
 /*
  * mem_cgroup_swapin_uncharge_swap - uncharge swap slot
  * @entry: the first swap entry for which the pages are charged
diff --git a/mm/page_io.c b/mm/page_io.c
index 01749b99fb5473ab790d9ed88d951707b14e0ded..3dc30521384bd9cd74c1f3662e01ff496b90d4c1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -605,6 +605,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+#ifdef CONFIG_MEMCOMP
+static void swap_read_folio_common(struct folio *folio, struct swap_iocb **plug,
+				   struct swap_info_struct *sis, bool synchronous)
+{
+	if (swap_read_folio_zeromap(folio)) {
+		folio_unlock(folio);
+		return;
+	} else if (zswap_load(folio)) {
+		folio_unlock(folio);
+		return;
+	}
+
+	/* We have to read from slower devices. Increase zswap protection. */
+	zswap_folio_swapin(folio);
+
+	/* Select the existing filesystem or block-device read path. */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		swap_read_folio_fs(folio, plug);
+	else if (synchronous)
+		swap_read_folio_bdev_sync(folio, sis);
+	else
+		swap_read_folio_bdev_async(folio, sis);
+}
+
+/* The outer memcomp user-folio read accounts for this transport operation. */
+void swap_read_folio_memcomp(struct folio *folio, struct swap_iocb **plug)
+{
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
+
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
+
+	swap_read_folio_common(folio, plug, sis, synchronous);
+}
+#endif
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
@@ -628,6 +666,9 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	}
 	delayacct_swapin_start();
 
+#ifdef CONFIG_MEMCOMP
+	swap_read_folio_common(folio, plug, sis, synchronous);
+#else
 	if (swap_read_folio_zeromap(folio)) {
 		folio_unlock(folio);
 		goto finish;
@@ -648,6 +689,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	}
 
 finish:
+#endif
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
diff --git a/mm/shmem.c b/mm/shmem.c
index a04e68d445d37384b02b56e791586d09b392fcfa..a1d3c882753883eeaa9dfbf13cbcf40af4811ff5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -847,6 +847,17 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 	struct address_space *mapping = folio->mapping;
 	long nr = folio_nr_pages(folio);
 	int error;
+#ifdef CONFIG_MEMCOMP
+	struct memcomp_ref mc_ref = { };
+	swp_entry_t mc_entry = radix_to_swp_entry(radswap);
+
+	/*
+	 * Pin before replacing XA: a truncate may remove its new cache owner
+	 * immediately after unlock, before workingset publication below.
+	 */
+	if (is_memcomp_entry(mc_entry) && swp_offset(mc_entry))
+		BUG_ON(!memcomp_load_folio_pin(swp_offset(mc_entry), &mc_ref));
+#endif
 
 	xa_lock_irq(&mapping->i_pages);
 	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
@@ -863,6 +874,13 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 	mapping->nrpages -= nr;
 	shmem_update_stats(folio, -nr);
 	xa_unlock_irq(&mapping->i_pages);
+#ifdef CONFIG_MEMCOMP
+	if (mc_ref.slot) {
+		if (!error)
+			memcomp_publish_cache_eviction(folio, &mc_ref);
+		memcomp_load_folio_abort(&mc_ref);
+	}
+#endif
 	folio_put_refs(folio, nr);
 	BUG_ON(error);
 }
@@ -2273,79 +2291,74 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 		if (!shmem_confirm_swap(mapping, index, swap))
 			return -EEXIST;
-
-		if (shmem_inode_acct_blocks(inode, 1))
-			return -ENOSPC;
-
+		/* Keep the source identity stable across allocation and charge. */
+		if (token && !memcomp_load_folio_pin(token, &mc_ref))
+			return -EEXIST;
+		error = shmem_inode_acct_blocks(inode, 1);
+		if (error) {
+			error = -ENOSPC;
+			goto mc_put;
+		}
 		folio = shmem_alloc_folio(gfp, 0, info, index);
 		if (!folio) {
-			shmem_inode_unacct_blocks(inode, 1);
-			return -ENOMEM;
+			error = -ENOMEM;
+			goto mc_unacct;
 		}
 		__folio_set_locked(folio);
 		__folio_set_swapbacked(folio);
 		nr_pages = folio_nr_pages(folio);
 
-		error = mem_cgroup_charge(folio, fault_mm, gfp & GFP_RECLAIM_MASK);
-		if (error) {
-			shmem_inode_unacct_blocks(inode, nr_pages);
-			folio_unlock(folio);
-			folio_put(folio);
-			return error;
-		}
-
-		/*
-		 * Allocation and memcg charge may reclaim or wait for OOM.
-		 * Pin only after both, then recheck the page-cache entry.
-		 */
-		if (token)
-			memcomp_load_folio_pin(token, &mc_ref);
-		if ((token && !mc_ref.slot) ||
-		    !shmem_confirm_swap(mapping, index, swap)) {
-			shmem_inode_unacct_blocks(inode, nr_pages);
-			folio_unlock(folio);
-			folio_put(folio);
-			if (mc_ref.slot)
-				memcomp_load_folio_abort(&mc_ref);
-			return -EEXIST;
+		error = token ?
+			memcomp_charge_folio(&mc_ref, folio, fault_mm,
+					     gfp & GFP_RECLAIM_MASK) :
+			mem_cgroup_charge(folio, fault_mm, gfp & GFP_RECLAIM_MASK);
+		if (error)
+			goto mc_folio;
+		if (!shmem_confirm_swap(mapping, index, swap)) {
+			error = -EEXIST;
+			goto mc_folio;
 		}
 
 		error = token ? memcomp_load_folio(&mc_ref, folio) :
 			memcomp_load_folio_zero(folio);
 		if (error) {
-			shmem_inode_unacct_blocks(inode, nr_pages);
-			folio_unlock(folio);
-			folio_put(folio);
-			if (!shmem_confirm_swap(mapping, index, swap))
+			if (error == -EAGAIN ||
+			    !shmem_confirm_swap(mapping, index, swap))
 				error = -EEXIST;
-			memcomp_load_folio_abort(&mc_ref);
-			return error;
+			goto mc_folio;
+		}
+		/* Token0 is a fresh zero page, not a nonresident user load. */
+		if (token && fault_type) {
+			*fault_type |= VM_FAULT_MAJOR;
+			count_vm_event(PGMAJFAULT);
+			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
 		error = shmem_add_to_page_cache(folio, mapping, index,
 						swp_to_radix_entry(swap), gfp);
-		if (error) {
-			shmem_inode_unacct_blocks(inode, nr_pages);
-			folio_unlock(folio);
-			folio_put(folio);
-			memcomp_load_folio_abort(&mc_ref);
-			return error == -EEXIST ? -EEXIST : error;
-		}
+		if (error)
+			goto mc_folio;
 
 		shmem_recalc_inode(inode, 1, -1);
-
 		if (sgp == SGP_WRITE)
 			folio_mark_accessed(folio);
-
 		folio_mark_dirty(folio);
 		if (token)
 			memcomp_load_folio_commit(&mc_ref);
 		else
 			memcomp_invalidate_cache(0);
 		folio_add_lru(folio);
-
 		*foliop = folio;
 		return 0;
+
+mc_folio:
+		folio_unlock(folio);
+		folio_put(folio);
+mc_unacct:
+		shmem_inode_unacct_blocks(inode, 1);
+mc_put:
+		memcomp_load_folio_abort(&mc_ref);
+		return error;
 	}
 #endif
 
diff --git a/mm/swap.h b/mm/swap.h
index ad2f121de970d50647b3010e1ddf8d5af7daa1ac..60dea06ffa189d9ffb7b6208b60ffd6b65d77e39 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -12,6 +12,10 @@ struct mempolicy;
 int sio_pool_init(void);
 struct swap_iocb;
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
+#ifdef CONFIG_MEMCOMP
+/* Transport I/O: the user-folio caller owns PSI and delay accounting. */
+void swap_read_folio_memcomp(struct folio *folio, struct swap_iocb **plug);
+#endif
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dd36a7bf3f961276df3b40b2170ec461ed73476f..fb1836f2e0de7ef929dbd7d1712b7ee441a9de14 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -957,6 +957,22 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	spin_unlock(&swap_avail_lock);
 }
 
+#ifdef CONFIG_MEMCOMP
+int swap_memcomp_transport_alloc(struct swap_info_struct *si)
+{
+	/* Use virtual fallback for large swap areas, just like zeromap. */
+	si->memcomp_transport = kvcalloc(BITS_TO_LONGS((unsigned long)si->max),
+					 sizeof(unsigned long), GFP_KERNEL);
+	return si->memcomp_transport ? 0 : -ENOMEM;
+}
+
+void swap_memcomp_transport_free(struct swap_info_struct *si)
+{
+	kvfree(si->memcomp_transport);
+	si->memcomp_transport = NULL;
+}
+#endif
+
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
@@ -992,6 +1008,9 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
+#ifdef CONFIG_MEMCOMP
+	swap_memcomp_transport_clear(si, begin, nr_entries);
+#endif
 	clear_shadow_from_swap_cache(si->type, begin, end);
 
 	/*
@@ -2900,6 +2919,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
+#ifdef CONFIG_MEMCOMP
+	/* Device users and scans have drained; SWP_USED still prevents reuse. */
+	swap_memcomp_transport_free(p);
+#endif
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3500,6 +3523,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+#ifdef CONFIG_MEMCOMP
+	/* si->max is final; allocate before enable_swap_info publishes the device. */
+	error = swap_memcomp_transport_alloc(si);
+	if (error)
+		goto bad_swap_unlock_inode;
+#endif
+
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3605,6 +3635,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	inode = NULL;
 	destroy_swap_extents(si);
 	swap_cgroup_swapoff(si->type);
+#ifdef CONFIG_MEMCOMP
+	/* Clear the pointer before flags allow alloc_swap_info to reuse this si. */
+	swap_memcomp_transport_free(si);
+#endif
 	spin_lock(&swap_lock);
 	si->swap_file = NULL;
 	si->flags = 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 064db53fabfe830ea260c776e91bfc7f4bc46dd9..49f3d7517566ae91ab45f8b0c7af9833b2b70900 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -843,7 +843,13 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	if (folio_test_swapcache(folio)) {
 		swp_entry_t swap = folio->swap;
 
+#ifdef CONFIG_MEMCOMP
+		if (reclaimed && !mapping_exiting(mapping) &&
+		    !swap_memcomp_transport_test(swp_swap_info(swap),
+					 swp_offset(swap)))
+#else
 		if (reclaimed && !mapping_exiting(mapping))
+#endif
 			shadow = workingset_eviction(folio, target_memcg);
 		__delete_from_swap_cache(folio, swap, shadow);
 		mem_cgroup_swapout(folio, swap);
@@ -1150,6 +1156,7 @@ struct memcomp_deferred {
 	struct memcomp_deferred_batch fill;
 	struct memcomp_deferred_batch busy;
 	enum memcomp_reclaim_source source;
+	struct mem_cgroup *target_memcg;
 	/* Where shrink_folio_list() puts what it frees and what it keeps. */
 	struct folio_batch *free_folios;
 	struct list_head *ret_folios;
@@ -1201,7 +1208,7 @@ static void memcomp_store_deferred(struct memcomp_deferred *d,
 		memcomp_finish_fail(folio, nr_pages);
 		goto activate;
 	}
-	if (!memcomp_release_folio(folio)) {
+	if (!memcomp_release_folio_reclaim(folio, d->target_memcg)) {
 		memcomp_finish_fail(folio, nr_pages);
 		goto keep;
 	}
@@ -1360,6 +1367,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		.busy.folios = LIST_HEAD_INIT(mc_deferred.busy.folios),
 		.source = current_is_kswapd() ? MEMCOMP_RECLAIM_KSWAPD :
 						MEMCOMP_RECLAIM_DIRECT,
+		.target_memcg = sc->target_mem_cgroup,
 		.free_folios = &free_folios,
 		.ret_folios = &ret_folios,
 		.stat = stat,
@@ -1975,7 +1983,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		} else if (!mapping || !__remove_mapping(mapping, folio, true,
 #ifdef CONFIG_MEMCOMP
 							 sc->target_mem_cgroup)) {
-			if (mapping || !memcomp_release_folio(folio))
+			if (mapping ||
+			    !memcomp_release_folio_reclaim(folio,
+						   sc->target_mem_cgroup))
 #else
 							 sc->target_mem_cgroup))
 #endif
diff --git a/mm/workingset.c b/mm/workingset.c
index a2b28e356e68ed4b525d052acac0999afbb10cbd..8c604db239493952bb6488dce5cf4e20ca1bc9ae 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -379,17 +379,24 @@ void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
  * Return: a shadow entry to be stored in @folio->mapping->i_pages in place
  * of the evicted @folio so that a later refault can be detected.
  */
+#ifndef CONFIG_MEMCOMP
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
+#else
+static void *workingset_eviction_common(struct folio *folio,
+					struct mem_cgroup *target_memcg)
+#endif
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	int memcgid;
 
+#ifndef CONFIG_MEMCOMP
 	/* Folio is fully exclusive and pins folio's memory cgroup pointer */
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+#endif
 
 	if (lru_gen_enabled())
 		return lru_gen_eviction(folio);
@@ -404,6 +411,31 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 				folio_test_workingset(folio));
 }
 
+#ifdef CONFIG_MEMCOMP
+void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
+{
+	/* Keep the stock exclusivity contract, including its zero-ref check. */
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	return workingset_eviction_common(folio, target_memcg);
+}
+
+/*
+ * memcomp has irrevocably committed source exit. Anonymous sources are
+ * frozen; shmem still holds page-cache references while publishing its
+ * successful XA replacement. The locked, isolated folio pins folio_memcg().
+ * Caller holds no T, PTL or XA lock, and has excluded all token consumers.
+ */
+void *workingset_memcomp_eviction(struct folio *folio,
+				  struct mem_cgroup *target_memcg)
+{
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	return workingset_eviction_common(folio, target_memcg);
+}
+#endif
+
 /**
  * workingset_test_recent - tests if the shadow entry is for a folio that was
  * recently evicted. Also fills in @workingset with the value unpacked from
