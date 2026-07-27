Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071FF379ECD
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169581; cv=none; b=RiTXMUbyzcxyxyQb0wobT91wgywtFq+wmBwOHiqrsa5pZaFYP3UxwI/wmMW0FtyS6jmem6Kp9NN2Vui7j6l3iNiq37ZGcCuFdrosZX3EYwRyM1OoD3YpPGZw9QCPpMONAsDgVHy7hO9zOSXIUq3aHBIqzYR2mJlmmw6O6UqePWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169581; c=relaxed/simple;
	bh=5HAWywEc/D08fqoDgy/G9oScBrgYF4l60piI4KTJwpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIkLIpUeQLUGRSqesyzliPHyrkXxZptkd5Ph2lFrRq+uBOud5iw7clGCTg1vBNz8ouglfu8I6YS3bi+048oj/yKkBTZbPg26B4KLPOI75mSOAcachsf27Viha8MJvBV52ui10ZnaZDXjdEpA8qFxwbK/r/Bf8goG4/w1Z0rHTo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kdejEm6p; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kdejEm6p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785169577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hE5H8fckKPN/KybXJL2X3Y1zfiFpP0Zt/q6Odg6IVKY=;
	b=kdejEm6pjVysh0JTY+T0jinI+6498rvPiWK2fDo94EXZ4LzXSYDWHVbBwQ1E0KnEDxhG87
	rCOG6u+nAMj9VVffC5i37eJsvVYsYHsRgyRt23gppulNkrzHtisoY9CoP9bXZr4v3D2v7w
	l72FsKiuD+UtEvkhiesox44uB5lRW6A=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
Date: Mon, 27 Jul 2026 09:23:24 -0700
Message-ID: <20260727162550.2032-3-usama.arif@linux.dev>
In-Reply-To: <20260727162550.2032-1-usama.arif@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reclaim can spend substantial work on an LRU type without immediately
reclaiming or demoting a corresponding amount of memory. Record this
work in PGROTATE_ANON and PGROTATE_FILE.

For classic LRU reclaim:

  - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
    corresponding anon/file counter when isolation succeeds.
  - Active-list reclaim adds referenced executable file folios that
    are retained on the active list to PGROTATE_FILE. Active anon
    reclaim does not contribute this component.

For MGLRU, add the number of initially isolated pages that remain
unreclaimed after both the initial and retry passes to the counter for
the selected anon/file type.

These counters are distinct from the existing pgrotated vm event.
pgrotated records an actual move to the inactive-list tail, primarily
after reclaim-marked writeback completes or failed invalidation leaves
a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
measure reclaim cost and do not imply that a folio moved to an LRU tail.

A subsequent patch will consume these counters for anon/file scan
balancing.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h |  2 ++
 mm/memcontrol.c        |  2 ++
 mm/vmscan.c            | 14 +++++++++++++-
 mm/vmstat.c            |  2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..aab06fb6c6d5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,8 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index de84c399cea2..23adb698dadd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -419,6 +419,8 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..053f41584989 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2043,6 +2043,9 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
+	if (nr_scanned > nr_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
+				 nr_scanned - nr_reclaimed);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
@@ -2152,6 +2155,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_rotated)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
@@ -4815,7 +4820,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4827,6 +4833,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4839,6 +4846,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4892,6 +4900,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c4364f0eb08a..87d4a6781367 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1300,6 +1300,8 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
-- 
2.53.0-Meta

