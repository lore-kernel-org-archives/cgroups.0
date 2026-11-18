Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035828;
	b=w8tofSBPj7uKJ90Q4F+VnJSF8TDhzOUBgQn3D2nBvcIUSbC6jkRsl6P82AWYfboCsy3s
	 hdm6+ofD1b6lPE/tubemcCkNONkF5Cicx5zVBkuZrLGYUVr+i6mfUdfWjmsYemnk2+QEi
	 Tipq117qdUfyO6Ac///pLAOgPvDAuL0gZn1jMe3VYM3rOF2cmsCdqTwbBwWioN9vaaqav
	 b3fW5W50Ga+cCkvdw1+7GVNdCu/bZYtRMv3N3JSIsq054+hCR8Qpn+kUo6/I/RksQCI6K
	 BOkewUrQILk4IFiuurrQKPMjhn8nnmbNwkXHPy5L32BSBMfK8NJCL8JNPDJQQ9MWqOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035828;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	b=U1OUeekMmJv87JDAKO21E9GAgj0qqH6ryYwEPpyK4EC+Hri3ZZnlc30/S87MqbAq5utx
	 VZwcDV+OsKpws57qbhp8pVvzRzlzZEMHttcqpf4GwA6jT5Aeg01XY8y3aYzVJ5EyxX9VW
	 j1gMMmOEuVZ89X9SRFsTmkHorXa6/sJh2q8XLi+1BXlGx5ZDRkLbsl637PbG6Bp+gWJJc
	 BH7IshrezPxz98ptkDsEXUXqNzTBIt4U6IVOVBgNXgdtmC1TxgTWZu0UZUTqX6KAa+NIS
	 Ig7mfTRBI6udQN1OpJBCe2Xv/XV+E/KYANqL6Hygl80ywyPjkeXXuLj0ftlNhJCHXiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2q4Bdvq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8885A60A2612;
	Wed, 18 Nov 2026 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2q4Bdvq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035828;
	b=a2GHQnVJHxktDRTaWzvK+nVMt07Trp7ZArQGuiC7RQB5bjqcVYWZG5XQ1cdV9903TXOB
	 NZoi0GfsFk7+pCM7c2ZYio7iCO0SWH9+3z/1qpBc3Tr+J3pLqzdZKzbC+e71YhHuIpLYs
	 UlbUCHBdrIjrE1RNzCwTGIhwx9lQfW8E5EDNTz1a2Dk3iVGzUkV5xKNSvJG4R14oT/H0q
	 lQaqegZ96/LmkjYY/HM2/nRuz79Z4Jz+2vP32IyUFLyVzEv4bMc1K+F5zDlwlKBTA8W6o
	 AO5jOq8ErkOR+Dx9/qpHqwmRbA77+Svna/OwpH3kYtYpXm14fqi8Feizx0oxHBmeFag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035828;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	b=vbQLP3VZ73CDmitfwTruQbKStDbkVzLr/FHqWVV/SrEkZWFAJbuRDzAT/RHNF/hYgo7x
	 kNArejaR3FVNdfYF1jlX1+ydcVlalHxbzYljwba9YwMPWVA3fOtXcWW7c52B0+UoRU3MG
	 MEkZG5vSOj2XSfWsDyc7shg/nX1zwcVU+rN159kqtpntxJFaXhXAYkLZ3yXg997agSX7i
	 s6rsAJGW/4S3OU4Gh9hltbO9dqU6HdhyFtAr5LOPetIVQnemHdJnNau3WeZn+UrFaC6/v
	 wB+ZSXylDhOOeFZUZpAkHKLtHpXt+jHxCGwbWend+h79i0cG0NoKXcekyLevkeRoeTQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EB9441F000C8;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035828;
	bh=nrAIa7L3TPpYcGyoo7swmURvfjB++pEN9thqNCcvUe4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Y2q4BdvqW0QNbWCV2EHNKkUul0KaiGCIExyFxdiLyisbtcOS+WLgurUJqiyKHyQJF
	 pDB3kTasN+MkUZpaSviE3+Wm8F7n2YezLZw8EP9JGnMMQrDtxodIMsySL2mNECpVNU
	 b3g7EMYA+XGS2U2NGbURH4PwUzFASHw9A88MF644dQzI4nd63btmSlzPzcdOtxg9HG
	 5yzshWfel0y64mk9xroF4c74BNFGGxFd78W/KevBvJCbx9FZsU0aha8dKVDqdKMg4k
	 ySRhqTmqn1zP5OIaj0yr+qpEYAM+rxrWTascwvFgxvSH6TMdAKAmi9HN1fAJLstW/e
	 hyoyTLD1Hf6uw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 620D94AF90;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:35 +0800
Subject: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
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
Message-Id: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=5575;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=TDKkyOXacD8p0+c9vn3qY/1PAeUMnDBoLa5Oc6386Uc=;
 b=2EC1zlwGCYfSgMrWDtAJD+ridlWBFeFPEfIDM+QyTWb7dxJ27oUdhpXn3CGJ+C62Q+3FBXqk/
 /V+JMlVJCScBSDhWsUGEkw0xOvvbdBjqBsifAC9k0VlXVFDzKYHMBpX
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

No feature change, convert them to atomic so we can update them without
holding the LRU lock. A temporary underflow is fine: readers clamp a
negative value to zero, and the counters only need to be eventually
consistent.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h |  6 ++----
 include/linux/mmzone.h    |  2 +-
 mm/vmscan.c               | 26 +++++++++++++-------------
 mm/vmscan.h               |  2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 2edb9beef6d3..46beded51c7d 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
 
 	if (old_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
 	if (new_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
-			   lrugen->nr_pages[new_gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
 	/* addition */
 	if (old_gen < 0) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c161d563ce8f..4c4aad95b0b6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -554,7 +554,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fe1fe1439c7c..8d14831cdf83 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 				break;
 		}
 		flush_lru_batch(head, &batch_end, target_list);
-
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
-		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
+		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
 		if (!remaining)
 			return false;
 	}
@@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
+	/*
+	 * The child is offline and the lockless updaters, which hold
+	 * rcu_read_lock() over the update, avoid racing with reparenting,
+	 * so the read/set/add operations below are safe.
+	 */
 	for (gen = 0; gen < MAX_NR_GENS; gen++) {
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
diff --git a/mm/vmscan.h b/mm/vmscan.h
index c2cea36289f3..6551f0a6691a 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
 	unsigned long size = 0;
 
 	for (int zone = 0; zone < max_zone; zone++)
-		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+		size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
 }

-- 
2.56.1


