Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659863;
	b=dLfBX3z4AqX25rhHOCXDk3AJXhfW1pvDJwZha+ASKF+mGLdJo8p/bJH5DkzimM78Wa5+
	 0vUtMGQww/tZHYDsBtzr+nL2NI02jKYI7kJq3tJZlpXUwVIi/s0H8vZmEXVArGPs/uulG
	 GAHBoSz5FS1jTzYQCab2ACHmnMSQxQimtZPLL8OV2mb71OmLpLdJrs5TSETK/8jv/Zhkx
	 YClRwTBVc+205Z6m5ozMZP8HN+iy6MQPRf48qEm99B8c/FcgOkpIdBUhMBUw8ubnkIUZx
	 jWxzQCT7jaRG+BIAM8KQU2y4WT90TNoOahFbPr7zxCpO8gQNwkO9XPr7ZEq3bgBZS3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659863;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
	b=481XxTKF5Zh+HLp1gkhLo/QqHziXFotLlU61pzxAy0X1uoWFtyRCEe568aBLSUKbX5Rx
	 vnTeqT89MTilekUgAIuu7lJ1vSIDgNmkKe6kArr1KGDWX2EEnRrY2/97IOAVPXnKZJQzg
	 qS8DeidsXn1TUBYMMkdXTKz6fElUqfgPwYtkADlYF0uHHfBLz4QX2eZv2GYximKGZICg0
	 btHs9p12Rq3ALVlhPWhdr9/URLMWR0NAxW1DM6Xwf0VSou6e9ausKGorECV5wR8187uhZ
	 vjY2QmZHPlZQ3hTHXTLD4N2Ozk8Bscaib92O/XK5bBBGufXGZvpeFot2mwF1GYwyRSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OtqXAvyu;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70A1606A324
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 22:51:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E70A1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OtqXAvyu
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b0d63f60bcso28691667b3.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 14:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659862; x=1794264662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
        b=OtqXAvyuZCzfBa5bag00KQV6zJLG9++ecZfQ1Ts2yhv6n7SPQDvma0qfnPshUdWYFU
         oOMQxU2dsRHIorpgji0vArKleH40p+OD3JFMXTKuOC+nKXrRx2W9yJxTHXramqgpOV3+
         /IAKxDG2KhsTIIVsfUeUSNhTi9XOWjHQNuDb0dkq7afdWrxE/p0UShzDhudZVQeXadqu
         LsaN7qZEcvPdc9W1EQkW1RO2TrTok4yhE6QehAuQbw3ZtDFG53e5HAm9xEPMl73CSXjR
         6ImeeFp0o8KD40lOwcIVDr/07dV9n21CEXPRhjfHXMe5c9PJ+9TT9I4XSdluSYOb8Fmh
         hSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659862; x=1794264662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
        b=WUwqIbgQ/tN/xAixOhydOQeExEWc2S9GFluRLR2FjV5VkxGwnFMMz7OYw7oop1XH/U
         8iPEH/hIljAeIB+hArem5xN+4YDEpT52gahfVUWLcLrjp7iH9y5PkrD+xgofWYI5nhPw
         vB89LGdIYUSAiQl+7Rv33ZBuA9NshXyvTWmdxM1xcjg4G6s5oB5E0qrCuuDsgOFN7oaN
         OqkI4dQfUCnLOogsJBGk8UbsOor4REDG//kK+qQbNA7zi7ei6uGqQUQQA1UEoRik27KJ
         WS5jU73QeovarLECDOlq5QU5UsUN9jW/xJRTb1Ch+7epG7KcIDMZyAE80ZKW/AE2e/az
         FEbg==
X-Forwarded-Encrypted: i=1; AKwUvBwc13gto0/P/veMmVr/Uzex5qp49I21SHKQhnP1NoeoTCMiu0DvC2/gEwgN/dSVfM3LirAJ6XaU@vger.kernel.org
X-Gm-Message-State: APuU4Z+mx3RES7QHfAbLWCK7E9Bb+Dy31vutOEjuJJMCyq5gSDtXGwoU
	1K5JSAWsKWFUqhrUR+60Xej/j/4LVE3peCqXOpkZbQF3LPh9bgZ06MMt
X-Gm-Gg: AYBFou0V7SvGRvkiHBPT2VZkN1pu6eumWKVlfrsfJFyIlzScadbV0ZbrwhrKso3VXn7
	k0Jv7Tk8IHRQVyTKqGLhL/nlYeuYPLQXo2x0Ut2bckW8SM5Y5d2hZCepcy46DkvYZ7qoTsjPqf2
	HSd87brpDsq5V75x9iLpqy1g41Jj6hkuC3Pv9U99UJ6aD8kr9srsfyHRaljhdl8xrP4ok9PdLoW
	OysHMI0u0jxKHy3jR3mz5ZQacFSnOYFoDTvWgbdAYXxS/nsjnUjVsWDPaa2VSA/CwACTLQIEg9O
	/GKZhPYpF/xPHJ4GBXs6ZQZ4saHyqX1JIBTXSoZkTQqgcUvtR/pC2umPEJtgI2g4WexBAFvpt6A
	VfjUVo5p3+sVVeYiw2QJL/9ASfvwUlFqPLvLerI0IJySQ9MLJiUZQgqyNQruTG8ixOmQXoQEFsG
	yqyi7cOCvjK6M8kAzbahhCm3iiGGhIppZW+6z26OpNJ9u4c5rO6EuZJGf222KjYwh4v+ijPZpeE
	dWZao/pJAVF575fUrRuohBYWJjJRAADfpmSHyvWxRcgPeUDAeEblM6M2qKPCPeKH1eBUqGCDQu/
	Yctg2C+rSdCim9A2ycGtAxtLZ3rTKlQV9w7xCkhPNR2W3L8SKPv6rt/zbt2NRL9z9HWaCrx7wXI
	W4DGA
X-Received: by 2002:a05:690c:6d81:b0:8b0:8b34:edc2 with SMTP id 00721157ae682-8b2b66c629bmr83714117b3.19.1793659861879;
        Mon, 02 Nov 2026 14:51:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b71bce56sm60299087b3.44.2026.11.02.14.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:51:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the node counters
Date: Mon,  2 Nov 2026 14:50:29 -0800
Message-ID: <20261102225030.2743129-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
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

Reclaim and refault detection read LRU sizes and workingset counters
from the target lruvec after a ratelimited rstat flush. For global
reclaim and the root memcg, that flush covers every cgroup in the
system, and the ratelimiting can leave the stats stale for seconds.

For stats that only track memory charged to a memcg (LRU sizes,
workingset, rotation and reclaim writeback counts), the root memcg's
hierarchical value equals the node counter, which is always up to date.
Add lruvec_lru_page_state() and a monotonic variant that read the node
counters for the root memcg, and use them in reclaim and
workingset_test_recent(). Root reclaim and refault detection then see
current values instead of stats that can lag by seconds.

workingset_test_recent() only reads the eviction memcg's own lruvec, so
skip its rstat flush when that is the root memcg. For reclaim however,
we still need to keep the flush (for now) since global and root reclaim
also read the rstat stats of the child memcgs they scan, which the flush
is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 16 ++++++++++++++
 mm/memcontrol.c            | 44 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                | 36 +++++++++++++++----------------
 mm/workingset.c            | 19 +++++++++-------
 4 files changed, 89 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..656bd677dd3c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -968,6 +968,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx);
 unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
+unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+				    enum node_stat_item idx);
+unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+					      enum node_stat_item idx);
 
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val);
@@ -1430,6 +1434,18 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+						  enum node_stat_item idx)
+{
+	return node_page_state(lruvec_pgdat(lruvec), idx);
+}
+
+static inline unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+							    enum node_stat_item idx)
+{
+	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+}
+
 static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
 					  enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a..938843346571 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
+static bool lruvec_is_root(const struct lruvec *lruvec)
+{
+	return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memcg(lruvec));
+}
+
+/**
+ * lruvec_lru_page_state - read an LRU stat of an lruvec
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * Like lruvec_page_state(), but for the root memcg the node counter is read
+ * instead. For stats that only track memory charged to a memcg (LRU sizes,
+ * workingset, rotation and reclaim writeback counts), the root memcg's
+ * hierarchical value equals the node counter. The root memcg can just read the
+ * node counter directly instead of going through rstat, which requires
+ * flushing. Flushing the root memcg flushes every cgroup in the system.
+ *
+ * Use lruvec_page_state() for other stats (eg slab).
+ */
+unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	if (lruvec_is_root(lruvec))
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	return lruvec_page_state(lruvec, idx);
+}
+
+/**
+ * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta sampling
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
+ */
+unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+					      enum node_stat_item idx)
+{
+	if (lruvec_is_root(lruvec))
+		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+
+	return lruvec_page_state_monotonic(lruvec, idx);
+}
+
 static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ddef3b488b3..fc93a1d8afe0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2379,8 +2379,8 @@ static bool inactive_is_low(struct lruvec *lruvec, enum lru_list inactive_lru)
 	unsigned long inactive_ratio;
 	unsigned long gb;
 
-	inactive = lruvec_page_state(lruvec, NR_LRU_BASE + inactive_lru);
-	active = lruvec_page_state(lruvec, NR_LRU_BASE + active_lru);
+	inactive = lruvec_lru_page_state(lruvec, NR_LRU_BASE + inactive_lru);
+	active = lruvec_lru_page_state(lruvec, NR_LRU_BASE + active_lru);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -2428,7 +2428,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	 * into a decaying average. This ensures currency, as workloads
 	 * change over time, and avoids overflow in the calculations.
 	 *
-	 * Use lruvec_page_state_monotonic() so unsigned subtraction
+	 * Use lruvec_lru_page_state_monotonic() so unsigned subtraction
 	 * yields the correct delta across a signed-long wraparound of
 	 * the underlying counter (a real hazard on 32-bit that the
 	 * clamp in lruvec_page_state() would otherwise turn into a huge
@@ -2440,13 +2440,13 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		struct lru_cost *cost = &target_lruvec->cost[f];
 		unsigned long rotated, io, nr_rotated, nr_io;
 
-		rotated = lruvec_page_state_monotonic(target_lruvec,
-						      PGROTATE_ANON + f);
-		io = lruvec_page_state_monotonic(target_lruvec,
-						 WORKINGSET_RESTORE_BASE + f);
+		rotated = lruvec_lru_page_state_monotonic(target_lruvec,
+							  PGROTATE_ANON + f);
+		io = lruvec_lru_page_state_monotonic(target_lruvec,
+						     WORKINGSET_RESTORE_BASE + f);
 		if (f == WORKINGSET_ANON)
-			io += lruvec_page_state_monotonic(target_lruvec,
-							  NR_VMSCAN_WRITE);
+			io += lruvec_lru_page_state_monotonic(target_lruvec,
+							      NR_VMSCAN_WRITE);
 
 		nr_rotated = rotated - cost->last_rotated;
 		nr_io = io - cost->last_io;
@@ -2468,10 +2468,10 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	anon_cost = &target_lruvec->cost[WORKINGSET_ANON];
 	file_cost = &target_lruvec->cost[WORKINGSET_FILE];
 
-	lrusize = lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
-		  lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
-		  lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
-		  lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
+	lrusize = lruvec_lru_page_state(target_lruvec, NR_INACTIVE_ANON) +
+		  lruvec_lru_page_state(target_lruvec, NR_ACTIVE_ANON) +
+		  lruvec_lru_page_state(target_lruvec, NR_INACTIVE_FILE) +
+		  lruvec_lru_page_state(target_lruvec, NR_ACTIVE_FILE);
 
 	while (anon_cost->count + file_cost->count > lrusize / 4) {
 		anon_cost->count /= 2;
@@ -2495,7 +2495,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		 * workingset is being established. Deactivate to get
 		 * rid of any stale active pages quickly.
 		 */
-		refaults = lruvec_page_state(target_lruvec,
+		refaults = lruvec_lru_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
 		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
 			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
@@ -2503,7 +2503,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		else
 			sc->may_deactivate &= ~DEACTIVATE_ANON;
 
-		refaults = lruvec_page_state(target_lruvec,
+		refaults = lruvec_lru_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
 		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
 		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
@@ -2518,7 +2518,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	 * thrashing, try to reclaim those first before touching
 	 * anonymous pages.
 	 */
-	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
+	file = lruvec_lru_page_state(target_lruvec, NR_INACTIVE_FILE);
 	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
 	    !sc->no_cache_trim_mode)
 		sc->cache_trim_mode = 1;
@@ -6701,9 +6701,9 @@ static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
+	refaults = lruvec_lru_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
 	target_lruvec->refaults[WORKINGSET_ANON] = refaults;
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
+	refaults = lruvec_lru_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
 	target_lruvec->refaults[WORKINGSET_FILE] = refaults;
 }
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..e8620ae1c516 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_lru_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
@@ -518,17 +521,17 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * workingset competition needs to consider anon or not depends
 	 * on having free swap space.
 	 */
-	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
+	workingset_size = lruvec_lru_page_state(eviction_lruvec, NR_ACTIVE_FILE);
 	if (!file) {
-		workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_INACTIVE_FILE);
+		workingset_size += lruvec_lru_page_state(eviction_lruvec,
+							 NR_INACTIVE_FILE);
 	}
 	if (mem_cgroup_get_nr_swap_pages(eviction_memcg) > 0) {
-		workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_ACTIVE_ANON);
+		workingset_size += lruvec_lru_page_state(eviction_lruvec,
+							 NR_ACTIVE_ANON);
 		if (file) {
-			workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_INACTIVE_ANON);
+			workingset_size += lruvec_lru_page_state(eviction_lruvec,
+								 NR_INACTIVE_ANON);
 		}
 	}
 
-- 
2.52.0

