Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE84570EC
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 04:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383862; cv=none; b=Ra6pKD7NCYZaMn5Pw7LT4gNPwxs6+pk1oGMd98sayHM5+X1BgEidj6A0rH/zcIkwYsnZG/gTyQ9SSyvA55Tn7Iwh6h9McvcKhX31+eHQm+xMl2kCBu77wYAdIKJPsWNY83n6idcoyE4ssDs1L1fU9ksjTJ5XFQDmREHL0g5tY2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383862; c=relaxed/simple;
	bh=rgCPstrZqNeEdMXP/SoDZYcPpE8lXWIHRU+cnN2B2DQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fkYcvTjl3o5nhvLSNlCZN6lu+j9qIUyAusA0wUWWtukD2Dru+Ypn6ERb0fbNrH3o8C8jw7Oea6Uo9lRPNPl8+BEBwN36a9k1UZU5z+NleqttUbb/7A/08fNfTbfxNhF8OkfgWj0aafn2ODwXsbSyiiuXJUkxxiJo/1aIRpLVUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UtBOYQeT; arc=none smtp.client-ip=95.215.58.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UtBOYQeT"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rgCPstrZqNeEdMXP/SoDZYcPpE8lXWIHRU+cnN2B2DQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383857; v=1; x=1792988657;
 b=UtBOYQeTvAeOkvPL5rT9MKUJj+4fbyTR8TCfgiIxaugA1ujuINo44eeFE8CPilvw/nTrVV4d
 NqAGKiob+r9yWe5tHwsfsWu9WQpCOQeI+ViliJuNYGUIyIJY37KkYUlpgbIgV6NX9kQVGPpvHx8
 BJFiHTZmfc28ImkgRKVdSKEo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a7533987bd4880b4;
	Mon, 19 Oct 2026 04:24:17 +0000
X-Mizu-Trace-ID: a7533987bd4880b4
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 9/9] mm/mglru: add tracepoint for inc_max_seq()
Date: Mon, 19 Oct 2026 12:23:08 +0800
Message-Id: <20261019042308.2372396-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
the lruvec lock is still held, with the node id, memcg id, the new
max_seq, the anon and file min_seq, and the number of pages in each
generation for both types, summed over zones and clamped to >= 0 the
same way the debugfs lru_gen file reports them. The nr_anon/nr_file
arrays are indexed by generation slot, so the emitted max_seq/min_seq
say which slot holds which seq. They are printed with __print_array(),
so the output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec is passed in; all of the above is collected in
TP_fast_assign(), so inc_max_seq() does no extra work when the event is
disabled. Paired with mm_mglru_scan_folios it makes the full
aging-to-eviction window observable per memcg.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..cddf42b5849a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(struct lruvec *lruvec),
+
+	TP_ARGS(lruvec),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		int gen, zone;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = lrugen->max_seq;
+		__entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
+		__entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
+		/* summed over zones and clamped to >= 0, as debugfs lru_gen does */
+		for (gen = 0; gen < MAX_NR_GENS; gen++) {
+			__entry->nr_anon[gen] = 0;
+			__entry->nr_file[gen] = 0;
+			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+				__entry->nr_anon[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
+				__entry->nr_file[gen] +=
+					max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
+			}
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d459678c5ee5..7b9b1aca5c88 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4129,6 +4129,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_mm_mglru_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1

