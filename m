Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785287;
	b=lWxAYCyiC7MAq2jTnlc/pP9MSzwjTFIvny/u85TIaCxpYNIyLVoW3P5CS4lH4hfAMfBF
	 1OYvfK+EFFlJfFeVtwJTcJB6mVk98KlEERWOExxI1Yj/JyyBN9niru84MsZfIz3KR2GdU
	 wqrmSyVWBMrnkZcOV1BazZn94odoJVGGCNet5rnIKeddOoBQh+0dox4pQD0ecCa+mwj6g
	 oT/d465IB3HEg35xzheTj+Stvl/NaTu4xAJOgtyd3B1qX3SjHAQveTQXBB2oA20nHl/mj
	 ba5Oow8KjaPqmlDgGZySgwe4Hbb7RwQ3fiycd0XDTGERK/BNVELnHOkl/Yu7M347x4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
	b=Wo7l9eatDEdxmDkm8Afl9U1MiVbgle3nyiR3St0jXeG8lWzKyKeVQCuqWnJ+lhNe3okR
	 2sYKX2x9nDZFZjo4jSB853WihokpUGy5FI6kOMJrTtXRcr639nWNIxjeRaWyVHFnDdUEm
	 0IK69G06bVCuqJOHKyOdDYPpGA2lqGh+KS2RMaSLKbEpBoxSKqeRTkjSBXdkaMhKNXmNQ
	 popxFAlPJj12WdD4ijZ542otcNAznLqyIFLy5y6adMGATeIwI+EspHKSzambbRQdXO6fH
	 0rWBcGSo/x05mmE1ibGIRR7GTfp4bj9xgG3QFEB9h+CNMU11yMLmO4p0z8NfZl4JtZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Gcu1Joza;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220BF606A31F
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 19:54:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 220BF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Gcu1Joza
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-67a2bd0c297so1232840d50.2
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 12:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785286; x=1793390086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
        b=Gcu1Jozat77CILJcetS76ujnyX1JvSLANUFtAstZaXlCr0Pak5L7nK/x90SYCnhjTr
         Xq3pjC1BwEy/JJbcsnIv0h44udDQYvJ0Anp9rXW8Iv5q8l3z3w9uLKPwtNmxnE2eH98p
         bCKHGftGfUKxy1BWoSP//J6Zb+L9m0ePfqlPtFPUKIb/IY9MwT5i8TIWY4V0WoYO4bhI
         X2jgE5Mh/3nUi6jHX6hNfGbhw4RuZKxyDSF0Tge0jYlyVdHojKx5yZH5L4IQ8PQo+QBh
         ZnghqQDhZmqU1T++W92SR0V0Ehfrsk2ZxSziI6Lpban+YkL3VjFn2CqZybhLx/4LJ0bK
         wv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785286; x=1793390086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zwi3GYLBUBlxRf6m2NubJmhIzNf7qgE5p10VsGudk4o=;
        b=aLuz+zx3WPs7ZI8WAfkYzIFSnJ49QWg5jgJL6ZqL3s0yyzV84nT0MBY4k4oLbn7+tD
         ixtL49meJ9qVbVJNkM2XnGS6K4pQxqSyGziva0qogdQyO3D/GdAes05UH49pvlDPkKDf
         D2tD1m1UiGNvn9HNfDSti7bKm/9PQfepguwL6luFhEhSyqn1DHIowBq6L6wUDEpO4dAk
         YeCRyh+ceOLYG8EMBmmpBuxKi0HYi4Jf0T4Svvsn7SEgLoi91rVoRem6S0iqg8TTHuXq
         nYhpFyUH6I+CLhz0P4clM2g3t3Q+GNC27IKpQsHrcp3zvMuXvut00dw0iWtDi0ZfCLKS
         pvnw==
X-Forwarded-Encrypted: i=1; AKwUvByKkSoxzAx6mxUwBD0smrCjyqA2uhJU8tEmTLq6ZE6CzceGziNucHjxJlYg44tW6u6oNRxEBh1r@vger.kernel.org
X-Gm-Message-State: AFq9FYLPypowbw8Zv/eZR02kTL4lZzzTHTmTGV9+yBGVpkpJSEunaT3Q
	TgqCHkpJ/QCyxvAMHWT5FlcC5FOWfGUGy7iKVtwVglfowyigelkodHkM
X-Gm-Gg: AYBFou3IWD6aOIYrRzJRX9qD3ounb5Ij1GThpVmY02kWW5CKcpzt1N6jjFv3dmP9k1B
	jFGqywzEIgRK1gi2M0GTXIMaNWRrIxlbB4DZRcL6PJ8ddJuL6hJl/duPMaWx5p8CIHE4XK0cKz6
	4VPktV5c78DFRPigzeAm1KrDH+8VYAHUdhQp9JUc13hmZZQlYoHIUM+TePF7dTD7/RIq1zJECde
	wj6W/A1J+7u++0jcLOb/xC+S76PTOGtAghvY1zVmytr0IQv+rIZgy96hFapF/NsknWucMdIGQq2
	ZNKDxpfSPEoWoBgzH78vHgsBVKlYlOSZIZgsPBYMYuOC0KW0uxPH4o5Y71hfWBK2Iz8RDMyhSw0
	359FfYr5fTxh7rjSrBnQ862+rnhXbqs2cB0dqaDoiFLO+/DVYvq3hza76tFTg5doEvOXv6UQHiH
	JiIrqMpNs4WiT3J/vqd/Px/tpDHtjP1pWKakqzLsZfZv11eAVyMyFbmWNI/liOjeXJRb6XTMxjU
	KbMIF+u1VzIwkwAXw/nvrONp2s1LN2gJyvDFp2VWL8tAi8c8Rx29NuRhj9x9sjehWlC3HLKCrQj
	V6TLHPU1LJw6gMqjRH04UnD0Yo+v+hzd
X-Received: by 2002:a05:690e:439a:b0:672:a52c:daf3 with SMTP id 956f58d0204a3-67a454d11d4mr119886d50.102.1792785286111;
        Fri, 23 Oct 2026 12:54:46 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a4622e78esm11114d50.12.2026.10.23.12.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:45 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] memcg: reduce cacheline contention between lruvec stat updates and LRU lists
Date: Fri, 23 Oct 2026 12:54:16 -0700
Message-ID: <20261023195417.1391216-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023195417.1391216-1-joannelkoong@gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
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

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node. These updates are extremely frequent (eg these
updates happen several times for every page that's faulted in, freed,
dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but Intel CPUs do spatial
prefetching [1] and fetch cachelines in 128-byte aligned pairs.
Depending on where struct mem_cgroup_per_node lands in its slab, that
cacheline can be paired with the cacheline holding the LRU list heads.

When this happens, every stat update also pulls in a copy of the LRU
list heads cacheline, which is written to constantly by other CPUs under
the lru_lock. The stat update has to fetch it from another CPU, which is
unnecessary overhead since the stat update doesn't use the LRU list
heads at all. But even worse, the lru_lock holder then has to invalidate
those copies and wait for the acknowledgements to come back before it
can do its next write, which makes the lru_lock critical section longer
for everyone waiting on the lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly, so
that the read-mostly cacheline is paired with the cold cacheline
instead of the LRU list heads.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.59M   (+18%)
  shmem, 80 threads  7.94M     8.66M   (+9%)
  anon,  20 threads  3.04M     3.08M   (+1%)

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..6139195b7fa4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,24 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/*
+	 * Touched only when the memcg is reparented or freed. Placed right
+	 * after memcg_pn_read_mostly because CPUs with spatial prefetching
+	 * (eg most Intel CPUs) fetch cachelines in 128-byte aligned pairs.
+	 * This keeps the read-mostly line, which every lruvec stat update
+	 * reads, from being paired with the LRU list heads, which are written
+	 * constantly under lru_lock.
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +132,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.52.0

