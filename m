Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E75378D8E
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 03:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783912317; cv=none; b=i9UTXPIpOYd/sWdTT6qIUUBgIZztWswsQKmfMRWBPyu2s1vrffBnEBd0J3yzVgMrn0G9wxsql23Vg1t3NEgsDK6gGROl9zDkvm67edvCrK+8puUBTt7Ae4eneQajfyb2UrJ2oYNLNKmS0qwQE+QmpK7TcTCrHLnvNF2qS0JxelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783912317; c=relaxed/simple;
	bh=XaKmK17oeKnfDQ/ZEiYOB8nUr4mRinwBl1wB5noYncM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QvWZLqjAcrHa5G6Vw/G7QDOxKsTxKbtaBTC5AYgqieUi53oT/sz80JGzbt0ikRtS6XjN/zE8/T4MI9KZvLMkB0rkb3M/VijD7HmIJW0bkrHnYv9Kbszye4RUQ5EM7V7cObHhS5d0VxyGNYJH1/81S/VtTEr6NVAq+Mtsz0uTob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Jul 2026 11:56:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: [PATCH v10 4/6] mm: swap: filter swap allocation by memcg tier mask
Date: Mon, 13 Jul 2026 11:56:42 +0900
Message-Id: <20260713025644.170839-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
References: <20260713025644.170839-1-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

The folio's effective mask is computed once and passed to the fast,
slow and discard paths as a parameter, so all of them act on the same
mask even if the memcg's mask changes concurrently.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.
The discard fallback honors the mask too: otherwise it would drain
the discard clusters of a device outside the folio's tiers and then
loop back to allocate from a tier the memcg is not allowed to use.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When non-rotational devices are distributed across multiple
   tiers, and different memcgs are configured to use those
   distinct tiers, they may constantly overwrite the shared
   percpu swap cache. This cache thrashing leads to frequent
   fast path misses.

 - Combined with the above issue, if same-priority devices exist
   among them, a percpu cache miss (overwritten by another memcg)
   forces the allocator to round-robin to the next device
   prematurely, even if the current cluster is not fully
   exhausted.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f3cff586cf30..967399936108 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1359,7 +1359,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(struct folio *folio)
+static bool swap_alloc_fast(struct folio *folio, int mask)
 {
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
@@ -1371,8 +1371,11 @@ static bool swap_alloc_fast(struct folio *folio)
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset || !get_swap_device_info(si))
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1389,13 +1392,16 @@ static bool swap_alloc_fast(struct folio *folio)
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio, int mask)
 {
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
@@ -1429,7 +1435,7 @@ static void swap_alloc_slow(struct folio *folio)
  * Discard pending clusters in a synchronized way when under high pressure.
  * Return: true if any cluster is discarded.
  */
-static bool swap_sync_discard(void)
+static bool swap_sync_discard(int mask)
 {
 	bool ret = false;
 	struct swap_info_struct *si, *next;
@@ -1437,6 +1443,8 @@ static bool swap_sync_discard(void)
 	spin_lock(&swap_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
 		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
@@ -1736,6 +1744,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	int mask;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1759,13 +1768,14 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
+	mask = folio_tier_effective_mask(folio);
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
+	if (!swap_alloc_fast(folio, mask))
+		swap_alloc_slow(folio, mask);
 	local_unlock(&percpu_swap_cluster.lock);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
+		if (swap_sync_discard(mask))
 			goto again;
 	}
 
-- 
2.34.1

