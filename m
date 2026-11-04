Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797808;
	b=4lE8VdCLWa/nx9Q6EHocR6wCQZRRgyOHZBnqNF68gMotMzMc1AQUAqbqBxC2hyYuv39+
	 dUG4vD8UUvu5rExAaPzLH9GEwXyTLCnuRvNBZAIlF9SiFNaXVav9aPFS0VLNCbxwh96qv
	 IBKSkXClJQWU6DvQluMo0n0uMqdgKuaQfH5V7YqqvbgmQGI6vVrVQy027+QJmY+d1aZYl
	 ntzTHqajYujPSdWAiml3gyvb5aVIPCZxKdFBGA/bwb5bcMItqKAgHwl1MSJ1sVSEMAHVG
	 jl+6umcS7Ox5Y7ZsA2agcGx7ZTBpaUUx+22nSUwYC9leNmusQBsqnvdxQC/5gFu/Ypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797808;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=feKxj4rUU1agh9cPsbT01Dhq4roHTkxI/CAewLAASlA=;
	b=fk43MTN4N5Ip78LxlF281UPQWIS3ac3GQ8rdyTP5cdOwL80noiBTAlNLRuuF+oSkCS+s
	 eKeD4OdUCp3kWwUayO6JmByaPqUTdnzSzyNQJLbTyrfE1mlcobhE4yRrQB9U1rvSEFVG0
	 Y+7MVS6DvUred3BwxsgvBT7h7Lx4a+AbPOT43Hra7Gak9EOvnrHPxQYSVHekzcmg3gxIW
	 FnFF/1tFxz2XOhOdYQm2UFyMn5I0zr6+vHuxON5IgHWQJ9d9NKX13/HuVxoAZSvQISLVC
	 /XYXSiZ9a5uPTGT3UfJV+tHJ7pcCp1k4GYDAXwG6qI9+p4SGhDV12zcGKoWmjc8fwKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uxwrkurz;
	arc=none smtp.remote-ip=95.215.58.106
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAC9606A33D
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FAC9606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uxwrkurz
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Aeo6u39n3YW9ht9du79+b0964r+JpKZmsg93cKbtI5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797806; v=1; x=1794402606;
 b=uxwrkurzJC3VIKA0//3jcrqAaJb5Hq87ckG3BVWf157gvXIaQnRuCNy7WsucyRdpyGa84Qgb
 mpK8oRZjr7wVfRFCmxr9iOIrA4ZEB57hA9XkPyjKlDNXcAIdrryvh3xiT75R1kW2Xcrg04Im7h1
 l0EJDb7+5Ffab75543BAQ5II=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a6fc3d540e2ed3ed;
	Wed, 04 Nov 2026 13:10:04 +0000
X-Mizu-Trace-ID: a6fc3d540e2ed3ed
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
Date: Wed,  4 Nov 2026 21:08:17 +0800
Message-Id: <20261104130817.849089-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq to create a new youngest generation.
It is triggered from try_to_shrink_lruvec() when should_run_aging()
finds that eviction is no longer possible, or that it would be better
to age first at the current priority. There is currently no tracepoint
on this path, so it cannot be observed when and why aging is needed.

Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
swappiness, max_seq, the anon and file min_seq, and the number of pages
in each generation for both types, as computed by lruvec_gen_size().

The reason for aging is not reported explicitly, as the logic in
should_run_aging() may change, e.g. for imbalance-based aging. It can
be derived from the generation window and the per-generation sizes,
which are taken before aging, so the youngest generation is populated
as well.

The nr_anon/nr_file arrays are ordered by seq rather than by generation
slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
they go from the oldest generation to the newest, the same order as the
debugfs lru_gen file, so the output can be read directly without mapping
slots back to seqs. The arrays are printed with __print_array(), so the
output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec, sc and swappiness are passed in; everything else,
including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
does no extra work when the event is disabled. Reading max_seq there
rather than using the caller's copy keeps the window consistent with
the per-generation sizes read right after it, should another reclaimer
age the lruvec in between.

The event marks the aging decision, not its result: the following
try_to_inc_max_seq() may find that aging is already in progress or
done by another reclaimer, so concurrent reclaimers can each emit it
for the same max_seq. Whether max_seq was advanced can be seen from the
following mm_mglru_scan_folios.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  1 +
 2 files changed, 53 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..565c56428364 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,58 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_aging,
+
+	TP_PROTO(struct lruvec *lruvec, struct scan_control *sc, int swappiness),
+
+	TP_ARGS(lruvec, sc, swappiness),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+		__field(int, priority)
+		__field(int, swappiness)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		unsigned long max_seq = READ_ONCE(lrugen->max_seq);
+		int i;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_ANON]);
+		__entry->file_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_FILE]);
+		/* from the oldest generation to the newest, as debugfs lru_gen does */
+		for (i = 0; i < MAX_NR_GENS; i++) {
+			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
+
+			__entry->nr_anon[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+			__entry->nr_file[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->priority = sc->priority;
+		__entry->swappiness = swappiness;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu priority=%d swappiness=%d max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->priority,
+		__entry->swappiness,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d05050ac49df..bcb229cc320d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5098,6 +5098,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		}
 
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
-- 
2.34.1

