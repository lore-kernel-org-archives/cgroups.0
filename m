Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793149578;
	b=SIQfR9HuX2qaBXaNKiCgCXDuTvh/NlDlasbQI5x9BgKqLSsPlx6pAuAgrSxtt0LFMBjt
	 075j9bs4UAi6tZNiw3gP0+lS62BZlA46OVuH8pkRpHVSdV1xFmccBKqJXKpnvB3lGPK38
	 LpcjR6nfR0LcJ80eD8K6InPu0OWR5gEjblsdl/1wH7fkBBU8Snp+y2a9mF0zVraldU0Hp
	 htaM3Ox4bG4pVP2/Qrgf6Ua2bs2Hor29ZMne7lJz4JfeF7nT7mW6hYegaetCeZcyJ/3aX
	 M9q9xXgGOcEeZfA9z7783vUwjFHBxw9t54KC7Sp62UIg1i8LTs7vISZXS8aM6nFaD6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793149578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
	b=StdT9hknRY2byGsYp0h5CZRZjckCL0Jg56gIqiWFGhqang3BqIV7b66ApnZll1D0ZoSb
	 iJ+1jP2IAyciJmnLElC0cGYAHvzTKoCjb5fVo0S2bNylNr5eFIdN+85CYw6QAKf1RbEPl
	 hSyYvh+p3P3qpyoWY0evSaEox6Cv+d6fnKJMqJNH6qHHWle+sWB97JhnyccSm9VseKhzd
	 jyEVCdVSWh1gX0A9GA1qqAnD+a2NUszjWjd7tszI5KHHNXKFdQAZaI+AdE2fbJZl/3ytI
	 vGxSxDHJCdxoNk8RWhV9xIP4g0gHppOMzTWLOV3Sl5tExPiaS546VmtKG15CUYArgIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OtUv3TnD;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F1606A325
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 01:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 134F1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tjmercier.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OtUv3TnD
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3adbc9a47fbso480946a91.1
        for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 18:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793149577; x=1793754377; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
        b=OtUv3TnDPbA3AuHcy1JU6FuEYodEhAUNNGdhXYfAuph2rUOjTpyZEiLzsLSXpAJuuu
         xEwVjcZrLJF2XKOKc5g2WNXK6BJvoYtVWfeF3NPdW0tL486rau7oB1R9a4Mhy9/1gzgb
         bIaW4pmfNpLo96zwliWkgf8bWwIoeX2l08NfzYcogdMSAP5b+V3ce+duNa8GTD3mbEjF
         FCsGCgLMaFZX957D1JF5seAqeoxfRjroiFWPDbXyhkcvJofhw/V8hoLauaZiRd98Oqrq
         fEvkfB5OQY4FMU6U60kLTd0QwvylkqYbakuRIBu/G7xn78Hy3+SrYsSv+QZ+Krv6TlB4
         4Q1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793149577; x=1793754377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
        b=q3YrKBFJH3cgJIhKobUWL96WNGSSW58Ncui64VavrW0AKa4cgTKv3vXnUhlQ04VeO1
         h1b+pqyas6H2jtX5mrvCPkquu0M43+czFvU6i9fd1DScPRRpTjGwAmp4u7fw8xZklI0s
         U5Gh7dnqPvhcrNz90qqBYA1mT650OFM98IZodlzHVaxywd7I/NlK7yjhQhNIJnU8m4C2
         M16CzA3mqb5gVXxQYsR2Xvj7h0bIlICn4+HIdPoF+IrHseICF4mdFWG433XUFXdc0WmK
         YzKs/QxvSxGYk3SzYwfjL6ChCyYATyj8gbsoBQ5YYSTAUvkStUHoCGPpnOhigzKWhLUh
         mauQ==
X-Gm-Message-State: AFq9FYJy2dy3oasLR0fXzLasExUjO+mipSYte0IZYpwldYUvmpTFYrAM
	nmoJ7MAjxsFCrdpfvhrqSXznlKIT/nqhGUGDZPZp4+RTYK5V6AB75wPGKfdrW7BHd4NB0wZHUFj
	/AqN5mISmST6yfe+zrA==
X-Received: from pjbpw4.prod.google.com ([2002:a17:90b:2784:b0:3a9:ccc3:cbae])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:564c:b0:3ac:bc3d:6fe8 with SMTP id 98e67ed59e1d1-3ae58150cf4mr614654a91.34.1793149577155;
 Tue, 27 Oct 2026 18:06:17 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:05 -0700
In-Reply-To: <20261028010611.3929937-1-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028010611.3929937-2-tjmercier@google.com>
Subject: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
From: "T.J. Mercier" <tjmercier@google.com>
To: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
move LRU size accounting on reparenting instead of copying it"),
mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
and zeroes the child's lrugen->nr_pages and lru_zone_size before the
memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
afterwards. A folio that is off the LRU during reparenting looks up its
lruvec through its objcg, which now points to the parent so it is put
back on the parent's LRU.

As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
when !mem_cgroup_online(memcg) is true, making the offlined memcg special
cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
code. Remove them.

With the get_nr_to_scan() special case removed, an offlined memcg that
still has stale effective protection now has
apply_proportional_protection() applied like get_scan_count() does, so
the MGLRU and traditional LRU behavior is now the same.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 include/linux/mmzone.h |  8 ++++----
 mm/vmscan.c            | 28 +++++-----------------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3b96d6c7123b..7f078ff0dd76 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
  * The events that trigger the above operations are:
  * 1. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
- *    threshold, which triggers MEMCG_LRU_TAIL;
- * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
- *    threshold, which triggers MEMCG_LRU_YOUNG;
+ * 2. The first attempt to reclaim a memcg below reclaimable size threshold,
+ *    which triggers MEMCG_LRU_TAIL;
+ * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
+ *    which triggers MEMCG_LRU_YOUNG;
  * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
  * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
  * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..636152d8c94d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		scan = apply_proportional_protection(memcg, sc, lruvec_size);
 		scan >>= sc->priority;
 
-		/*
-		 * If the cgroup's already been deleted, make sure to
-		 * scrape out the remaining cache.
-		 */
-		if (!scan && !mem_cgroup_online(memcg))
-			scan = min(lruvec_size, SWAP_CLUSTER_MAX);
-
 		switch (scan_balance) {
 		case SCAN_EQUAL:
 			/* Scan lists relative to size */
@@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			/*
 			 * Scan types proportional to swappiness and
 			 * their relative recent reclaim efficiency.
-			 * Make sure we don't miss the last page on
-			 * the offlined memory cgroups because of a
-			 * round-off error.
 			 */
-			scan = mem_cgroup_online(memcg) ?
-			       div64_u64(scan * fraction[file], denominator) :
-			       DIV64_U64_ROUND_UP(scan * fraction[file],
-						  denominator);
+			scan = div64_u64(scan * fraction[file], denominator);
 			break;
 		case SCAN_FILE:
 		case SCAN_ANON:
@@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long total;
 	int swappiness = get_swappiness(lruvec, sc);
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	total = lruvec_evictable_size(lruvec, swappiness);
 
 	/* whether the size is big enough to be helpful */
-	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+	return total >> sc->priority;
 }
 
 static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
@@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
-	/* try to scrape all its memory if this memcg was deleted */
-	if (!mem_cgroup_online(memcg))
-		return evictable;
-
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
 
@@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (need_rotate && mem_cgroup_online(memcg))
+	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc))
 		return 0;
 
-	/* one retry if offlined or too small */
+	/* one retry if too small */
 	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
 	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
-- 
2.56.0.307.g5fe7bd680c-goog

