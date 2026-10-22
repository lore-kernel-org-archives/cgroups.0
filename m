Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792699446;
	b=lZqnDGerDpARb4B0zwHDymuIp/UWr/cXBczCfpALB2Yw2rh8Tq3CHBkNVdd1YCvAULPm
	 fAMI8dCQy/FtwuB24Y6RBd2wjfFE0dnS0nWYMW/jCcS1UW8nm7XL58JdBpreN0CarUA3v
	 ijWAZk8WvqBk97Ag/BMbYarAc/AQvUOHTWJhqRfjEo5nf5F1dv5+b5dCdCsN8iv7htj0M
	 7zBPvbMQdrnWVumnQTkkEp77OSIjnIvOe96VzVDUwyaL1v/WkCxQiGEHE1qOjxh62iR1t
	 00OMXd8nJQ/i5f4njmPvGpQlQgFYItba4m435NBjcbKwTQt0um1XB5/kfS3ld8qERGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792699446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
	b=bObxqc78vePvPnyN74swTdoiwDCI5CNUw2G1F3QZdk6SEUzoshDZ4u6tdyGqGXuuzy8J
	 KpBpmMoVItr+uO+Vdfj+OEgtVKitySnREsKl0FJc6vBzW13BJ7awXu/t2UqS0/7J8eC8I
	 VIcqeYQ9zpVSEKfUKphq9I3/bIJnYy7JQNWXHIWmjBbJ2495pJ+udyiRhOKi/DDQ+2Ozq
	 fU8yV3FTGtNPEspvsegpGRQeGtVxIVaffUDh8WZKu7uFRC7HYNl08pqYZeZCSADNQrk7X
	 HTud7RI/5SIqF7WTbvnu13hZCaFapNmxaNFsuanmoCMfMGitonNstWUFQZ7VmdoF9hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="g/UawE3e";
	arc=none smtp.remote-ip=74.125.224.49
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E3606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 20:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 747E3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g/UawE3e
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-679334baa1fso274385d50.2
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 13:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792699445; x=1793304245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
        b=g/UawE3eMeJ8KykezADFP3vfPSIH7ad5L7i30C+VMncZNPt8pibtxGMGNRLWEEn2jd
         i4pLF5oSVQR7irkK1ExyV8QbHiQlU1piVTJGKX49wxAZN2CdyEqvW6K6WLxvnW/fJb5y
         pLRqFvg3QuHX977rXb4VTPeX3cjSyTxCAM8XafYtmLI/q1nHJgLV4MQTnmzlbZlpOAhR
         N+mgrB++S8y9SxHzkCkz5qmwydH/N+77atzkZujsMwX1ZfI1Hj64+v9DOPNDExyFFEaJ
         B+gZZ7jKD7HI1g22TcjFh4+z2NN5DyQofS5QGhveOcJF90SI6xKcWrigOLaz5hnohdG4
         h+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792699445; x=1793304245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YRntzMBmnfmIB4INuU9xu5/Fgelt39Yq9cPrtthNfGc=;
        b=dRaHwJI8wyjvjn3ktEa5YMjI7gs2LiKHy6oAgPWqsH0kSy74xLhUQ++YUYDazkKSlC
         ax5XswjxsLdcmd8SoR+eFQxdoKJveXU5B0DczHfofDCdAGluKd+E3j5rfwfcg60xKX3T
         a4e+C5CBPWYI6TqHEAqIHzYjey1rbSnQGeIbJLP60oTgVpYS61eeyRIp1pVjCYsF0OK5
         K/4yJqJ3Jfw+f1nkeVzy6AkI2L0/zyyK3ggi8V/6eCmruHVD4UNb5t6HfbYe8hF4taIR
         O6LNDxHJNuOaNQ3Y4GdYp9rs3Mz3SBORsGjQUa2m4zXZgjXuryoj7T+GDrF0tZL7V+/5
         jNFg==
X-Forwarded-Encrypted: i=1; AKwUvBwa0iDjzYrAdCoFTzbfiJsNBsFSAziPyiWrQNxdIH2IkXSaDbVLAWN/NGUXEYaEuoeYBPgBzOnv@vger.kernel.org
X-Gm-Message-State: AFq9FYLDYxa1chxqVDaqTVJKIwxTgij2zUYJdhM3Q3lti6w7Z/dGJ7qU
	EvCxYMHSZ4p5srqAx98etE3XCcf+pk/CeAzWSgcSyP3M1qjtw/q0knZP
X-Gm-Gg: AYBFou2jyZzZmH4DKTupLWeZgV7FgRRYVhCnN8sH1vQjU2PWpVphYQVMMXFuFgoyQqx
	V6EmNdj7VZg7MzCp5rMWvfegJGy35dn/JwZxxLFWtfCXchgEcN3Jpwi7ssrfVhbvawqlCGaY08b
	BJtG2rAiEdV/VxNRwUrgA3Sm0PEeEhFtRflNOiRjuqOfAnc/NSzZmJzDv/DAzqInm82tsOmb3fB
	AwZ4CEd6iOpSo2/QoexdyJuo7lR43n3ihE2XfESeL2oPE8QqzIFEUojZ4VkzxVNrpOO7Tc6NnPT
	CDTb9XBK0fmpLC9rZQiyYW4RU8QyLxEBtw8ZQ98+htEhhgtt5Ve1UzZ1i960wPPKHJju3xg+hcz
	qm7iSGU/HhDLZJ/nDX7/TvbeEYc6G3jVG2mZh6whRfTWbizyOZZc3w0wUoWDzyqrbHC+mi0Y0Gf
	7vvTHhXB0INhvavZnEZsW736zuTe55uVk8FeUtlHraWanF89E6aKfMtNb/e09zK+ARjTHjavulZ
	bh5yxbrUvR8QFyuK1X0mc5QHt0nKuj4dafmIaY2qTI9Lnm+3o/lnnQeqxkn/h+uBZOMAZKf0OjP
	9XV4leyKLrpN11am0hPPvqOnyDFVTRU=
X-Received: by 2002:a05:690e:128e:b0:679:9c43:8599 with SMTP id 956f58d0204a3-67a359e6abemr53680d50.8.1792699445215;
        Thu, 22 Oct 2026 13:04:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1560cc857sm3450147b3.9.2026.10.22.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 13:04:04 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1] mm: move LRU size stat updates out of lru_lock in folio batches
Date: Thu, 22 Oct 2026 13:03:13 -0700
Message-ID: <20261022200313.2354350-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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

folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
once per batch, but they update the node and memcg lruvec stats for
every folio in the batch while holding the lock. Only the LRU lists and
the memcg lru_zone_size need lru_lock. Updating the stats while holding
the lru_lock is unnecessary, and they make up a large part of the
critical section, as seen in [1]. With many threads faulting and freeing
memory in a single memcg, about half of all cycles are spent waiting for
lru_lock, and the hold time of the lru_lock directly limits throughput.

Accumulate the stat changes per LRU list while holding the lock instead,
and only apply them after dropping the lock (while still inside
the RCU read section that keeps the lruvec's memcg alive). This moves
the stat updates out of the lru_lock critical section and turns the
per-folio updates into at most one update per LRU list per batch.

The batch is attached to the lruvec while lru_lock is held so that the
LRU add/del helpers don't need to pass it down. To keep struct lruvec
from growing, cost_lock is moved into the hole after lru_lock, which
leaves room for the batch pointer in the same cacheline as lru_lock.

The stats can now lag behind the LRU lists by one batch, which is well
within the per-cpu batching they already have.

On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
CPUs repeatedly faulting in and freeing memory in a single memcg,
average pages per second over 7 freshly created memcgs per run, 2 boots
each:

                     before    after
  shmem, 20 threads  4.74M     5.47M   (+15%)
  shmem, 80 threads  7.94M    10.33M   (+30%)
  anon,  20 threads  3.04M     3.35M   (+10%)
  anon,  80 threads  3.23M     3.41M   (+5%)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
An alternative that avoids adding the lru_size_batch pointer to the lruvec
struct is to pass the batch down explicitly, but the plumbing for this is a
bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happy to go
with this if that is preferred.

[2] https://github.com/joannekoong/linux/commit/2f20765b01f98113e3c83ea0d0f98580502bfb96

 include/linux/mm_inline.h | 12 ++++++-
 include/linux/mmzone.h    | 11 +++++--
 mm/folio.c                | 67 +++++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..b3d85fe91385 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -50,7 +50,17 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	/*
+	 * Batches in mm/folio.c attach an lru_size_batch while holding
+	 * lru_lock, to apply the node and memcg lruvec stats only after the
+	 * lock is dropped. The stats don't need lru_lock and updating them is
+	 * a large part of the critical section when batching. The zone stats
+	 * are still updated right away.
+	 */
+	if (lruvec->lru_size_batch)
+		lruvec->lru_size_batch->nr_pages[lru] += nr_pages;
+	else
+		mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3b96d6c7123b..ac14f7118562 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -739,10 +739,19 @@ struct lru_cost {
 	unsigned long		last_io;
 };
 
+/* LRU size changes made under lru_lock, applied after the lock is dropped */
+struct lru_size_batch {
+	long nr_pages[NR_LRU_LISTS];
+};
+
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* Protects cost[]. */
+	spinlock_t			cost_lock;
+	/* If set, defers lruvec stat updates until lru_lock is dropped */
+	struct lru_size_batch		*lru_size_batch;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -751,8 +760,6 @@ struct lruvec {
 	 * serialises that update.
 	 */
 	struct lru_cost			cost[ANON_AND_FILE];
-	/* Protects cost[]. */
-	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
diff --git a/mm/folio.c b/mm/folio.c
index 45c814f3857b..dc2c796a4ea7 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -64,11 +64,54 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+/*
+ * lru_lock helpers for batches that defer LRU size stat updates until the
+ * lock is dropped, see __update_lru_size(). The deferred stats are applied
+ * while still in the RCU read section entered by locking, which keeps the
+ * lruvec's memcg alive.
+ */
+static void lruvec_unlock_irqrestore_batched(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	struct lru_size_batch *batch = lruvec->lru_size_batch;
+	enum lru_list lru;
+
+	lruvec->lru_size_batch = NULL;
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+
+	for_each_lru(lru) {
+		long nr_pages = batch->nr_pages[lru];
+
+		if (nr_pages) {
+			mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+			batch->nr_pages[lru] = 0;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void folio_lruvec_relock_irqsave_batched(struct folio *folio,
+		struct lruvec **lruvecp, unsigned long *flagsp,
+		struct lru_size_batch *batch)
+{
+	if (*lruvecp) {
+		if (folio_matches_lruvec(folio, *lruvecp))
+			return;
+
+		lruvec_unlock_irqrestore_batched(*lruvecp, *flagsp);
+	}
+
+	*lruvecp = folio_lruvec_lock_irqsave(folio, flagsp);
+	VM_WARN_ON_ONCE((*lruvecp)->lru_size_batch);
+	(*lruvecp)->lru_size_batch = batch;
+}
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
-		unsigned long *flagsp)
+		unsigned long *flagsp, struct lru_size_batch *batch)
 {
 	if (folio_test_lru(folio)) {
-		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
+		folio_lruvec_relock_irqsave_batched(folio, lruvecp, flagsp,
+						    batch);
 		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
 	}
@@ -80,12 +123,13 @@ static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
  */
 static void page_cache_release(struct folio *folio)
 {
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags;
 
-	__page_cache_release(folio, &lruvec, &flags);
+	__page_cache_release(folio, &lruvec, &flags, &batch);
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 }
 
 void __folio_put(struct folio *folio)
@@ -165,6 +209,7 @@ static void lru_add(struct lruvec *lruvec, struct folio *folio)
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	struct folio_batch free_fbatch;
@@ -199,14 +244,15 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 			continue;
 		}
 
-		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
+		folio_lruvec_relock_irqsave_batched(folio, &lruvec, &flags,
+						    &batch);
 		move_fn(lruvec, folio);
 
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
@@ -998,6 +1044,7 @@ void lru_cache_disable(void)
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
 	int i, j;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
@@ -1014,7 +1061,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
@@ -1028,20 +1075,20 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			free_huge_folio(folio);
 			continue;
 		}
-		__page_cache_release(folio, &lruvec, &flags);
+		__page_cache_release(folio, &lruvec, &flags, &batch);
 
 		if (j != i)
 			folios->folios[j] = folio;
 		j++;
 	}
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 	if (!j) {
 		folio_batch_reinit(folios);
 		return;
-- 
2.52.0

