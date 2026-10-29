Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793306564;
	b=JvHmDaQFeBUbzabKP22qTyQmPiTBNA7qXA9kUhb6kvSlusV/rJXJeEEKJ84DkxkT5OQ2
	 8jjHMv7j9L9V7Y5dqH8iNP7u+JP8TdVuY+hSPQuIJiwDxZ0Xb21Lk+cLHPCKdhmp3mfb/
	 WZJ+q2OvOyD6cgDTCUMj8LgpCtobkAv6LFfXT81ehpVkVD+5KTJStUeSsnvdZNeSDy6Mn
	 ejquZ2C0M7XO8mfhVhAx2Sm4qBtzQDBdZh9LaOUPC30ynBuBAXVwhSzSYZk3ik+Yblmc0
	 Zgbj6zYVkNRHzHPyeDnOyd5Z2N2H4DbXVZt23s8MN1VRenM/+G/kIhERosO+c5y9+Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793306564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
	b=xwitngWzwLXyY64EqjqhajAZmov9rlEhHjo4ehkW3hLnAKZYNgMon71givWMVCg4o7/d
	 w2Wwhq/V/klaJ/qMsJorLHlW/yC3SDFfbUzsUbwg0bpTXUbNjim7TBR4wSC9bmsgcmUi7
	 PTL+TspIyr43HnqXw5CpZvoEbq8pqUvK8uFLXxVXmOgRYD7L7TcbsfjaNCWw7j9gaIOdo
	 YdVvs/aCXG+WtD/KaMfP5bF87s1zynyurJAO0PucBUE4M8uecush+9GUh3cdZ7xSjyULl
	 8EEaq607g1fs9k3pjOPxKNolJrGfU1J1edtMB9MDiszwtM5lzpXg/blKMGg1e7RAN8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="pLDwrC/o";
	arc=none smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EF606A31C
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 20:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C9EF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pLDwrC/o
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ab432273c5so401977b3.3
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793306562; x=1793911362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
        b=pLDwrC/oEHNxB7Yncq8CZpt6k+r7a7tezM7sR38C65w3B8nlwfhiOWKtgkHvAOoN6O
         P5qekVJnF0WzXtlNdI2z8ax+VjA8QJXfKQwhUpyz8gUPVA3COhxv9osd2aDKKAqoKf8p
         M3JR8ux2HS4AK/4tjT55/yK7XWhLDHV5q3ESAjr2N4LYN/va5Q1zfsC26Cjl8bmwAAgE
         aTOihMjdB50bvCxZ4kGcx/h3LwGEuZVofHncsIW5F/QWoM6QSMc7Q/1mQSM8SI4P/PdR
         tRbP79iHexKxmLWxdcnzuco/pAwdTt9IzJM6quZP8BEvuEou4ZkFIkM0CSmrcj82vO8N
         Fd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793306562; x=1793911362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w/WnGJOegOoSLg6t17xX/8xCyLj+uCEUKKeXduOsb7c=;
        b=jIaP6p0b/SRw/inpKr0hqu16bM1T67+5iNuM6HOz+60wGRKPVhVzu5nb2/uHuzwfWs
         CLA5DOOkcb3/o7/duyc2jKUFCFMlZrCII1N5c9MGfMA+KHlBeEA7mbfKF+4EG4WWWC01
         PcRyolmQQLcQqvfuqnPBLdllOAO/HG5dKTRoseaBEl0OHA/wIOhodBG+wLpLfTwfwag7
         3N+hSYV+IA1vD9+NX1MI47AyaV2paR6oRmKYsdmske+Ep1EnbFQcuWGGvbngA+RZUEA8
         6S63yOX9vvmxNxoa+drgAYQM/I+WuLjVa/EO4V+gXmijBKrfCNTz3Mu0ERHkbecovWJI
         3fdg==
X-Forwarded-Encrypted: i=1; AKwUvBy/YiZeRR/TDvfNM/lEXJDpGUX54paUWLn4BmcK4H01xSGSa1unLf/Vn5fV1CR9UplDV3HGFWTd@vger.kernel.org
X-Gm-Message-State: AFq9FYI07udvIwLv0oPqE0sorMdNW+ewbbTiMCQ75XptHJL5TJ1Xj8BE
	jDw10qFFljiAnwtc9dz2Nod0pAuJ6f9oxZlCN5W4pVWS76qzv3MxlE5h
X-Gm-Gg: AYBFou3wxqanqlDMc+sqedVNQ83fsaF4KlOFMu8LVXR2R/PXlXVr1HCKP3dh7vInraM
	cIS99Lq03Ui7Jg1js4wr2zwjTZrHtAr6J5jlTxCZik84V7wzBFBLz1AU2x8Kr2m+q1YRrpyHkDY
	BKVozzAB5WWR6ZPu5r2mTeK0apkvb6fvw/n5iDLwJI/xYzgJDm0iXNThWm2DaZa/l2UYDfBZzM5
	/JieRVNKUyYeitkt2iO18pbA1mpuVwgwWrVbvlW4zO4h7evLMu0TUWwO7x73pEHi1mMy0q8WVqo
	dvCNkMa2vLMLtwgcd5BS/PaqHcU/NgNNtxsxg+q9u1Q6ynZwJk9v0J05AHke6ZMeDawOc6CMHBL
	CqncUL3MHaZce+yHIOjG/gwVZ1VY2kSPlkjkvPE6KlEMTur4ZYdJFd8RZMI763SW/Ll7zB8TaDY
	FqiEMMPxYy0BJssuMLsibbr477Z2YWCsawo4IAr2x3MQRJmRhDUwD/4HMwro+vK/ekE99F2fNMG
	b/0HxP+ThqcX/EI6yvevptTWndqrY4wFOBZjYlyg/+NBmWiEJtSL/Czc2NIOVXBn4dQl2rxALI3
	uMKpRAK9OsUm8eRefK5+PIJ3ENqQosJ3zgD6oiIRR72HUoggfYDZBBcuNWsi2rPeDzn5xr+h+Gn
	TfV7a2bvB1s1pnaw4/5tp9IzXrA==
X-Received: by 2002:a05:690c:f8d:b0:8b1:60a1:cd3b with SMTP id 00721157ae682-8b2b6738972mr619647b3.24.1793306562286;
        Thu, 29 Oct 2026 13:42:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b4b85986sm1522527b3.45.2026.10.29.13.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:42:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev,
	yosry@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
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
Subject: [PATCH v2] mm: move LRU size stat updates out of lru_lock in folio batches
Date: Thu, 29 Oct 2026 13:41:57 -0700
Message-ID: <20261029204157.117879-1-joannelkoong@gmail.com>
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
critical section, as seen in [1] where a change that added just a few
instructions to the memcg stat update path cost about 2% throughput
because the LRU stat updates run under lru_lock, and the overhead went
away once they were moved outside of the lock.

With many threads faulting and freeing memory in a single memcg, about
half of all cycles are spent waiting for lru_lock, and the hold time of
the lru_lock directly limits throughput. A perf profile with 80 threads
faulting in and freeing shmem in a single memcg shows 52.8% of all
cycles spent spinning on lru_lock, split evenly between
folio_batch_move_lru() and folios_put_refs(). About 25% of the time
spent holding lru_lock in those two paths goes to the LRU stat updates,
mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
per-cpu counters. The stat updates are only 0.7% of all cycles, but they
lengthen the critical section that the other threads are waiting on.

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
v1: https://lore.kernel.org/linux-mm/20261022200313.2354350-1-joannelkoong@gmail.com/
v1 -> v2:
* Added summary of [1] to the commit message as well as the perf profile
  findings (Shakeel)

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
index ecd1ebd49756..8618e9543983 100644
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

base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
-- 
2.52.0

