Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674683;
	b=fpuBHyoIKpVHZq1NhuxXpe3pdhjCbxJaY33BKbj+4lwTy4qlhIe8++olOdZWnYIPk1Xg
	 nkymk0VacamQbg+SHFDt9egSA54Qu5G3N5KTs+Zsce8+DeH6P6y1uA9hh69giqe/t2MTU
	 kTXYulzoM6NjvMt6hPHDCwbgXYEhg9+4QGKD343rJd49RBHWew97T29v1GCDZd31fa3bk
	 6z6mfxxlrF+rDxY3gMC1/dcukhg9TjiWOAllphxRCSbkY4fgWoMhLrtgIiY2yR6JuXYCC
	 5/4+hhinb1XLxBolfZgSyHR2MGoljBt3GFwO8/tXJAfCUAPCvFT8LM4V8tekqkpTCUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674683;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4IRpsKB31ZWOQ5n/UsohIDOoT7iKXviBSO161ss/1dE=;
	b=dXYFxvghyQ0BAE5LDys9jCbUUtRgq+sXhLkMr5yPpffkBFuKCSOmEZRW9ErntfJ6lscS
	 ESqd+/VPtBaAwagWIBgeLTSzf64cerdsOAybxRgbrq2upfA5JHWlyY4HlgD9/gt9fx/a2
	 tg8/PfFCqXYRmn/uesmlFsRFMklODvxxGxYLlWxv2c10w41Za3nHeFyCKxgqy7WTyGqNW
	 FiwVbZNHdmboDT3cX5k0eN/QaSFrQ6vhX8g0FndkRtsf5Zw0NW4bMg3ICsDRHuRftSHZV
	 mJVCZYcC7Raia+IuLPLkZ6utPlSQ341aF5+0k6Tizh2Fva+kMQSOmfsycDZO2+gqaCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ymnes9hU;
	arc=none smtp.remote-ip=91.218.175.10
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1C7606A32D
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 02:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C1C7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ymnes9hU
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lyrb92uDQUPbkiBltZi1bjdhjSGbJYzJNmN2CpAeRBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674680; v=1; x=1794279480;
 b=Ymnes9hUueYcoUxGz5QwDS5GUw1Qmnr7X/K2zXmtGUWjBAqldu6yJuJArKlNuSWuC36/5Kw5
 BCkiEyv5qn7dI9NQNbJMqcVEVyyNlWsdwcoMUU9VOtgUcRweQ7FNGpdbwVe7hR2frOOLJNuqDOu
 ValsYvN1tCUXXv1UX2u6Uwn8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 595423ef5b9c1195;
	Tue, 03 Nov 2026 02:57:59 +0000
X-Mizu-Trace-ID: 595423ef5b9c1195
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
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
Date: Tue,  3 Nov 2026 10:56:10 +0800
Message-Id: <20261103025610.3738894-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
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

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
the lruvec lock is still held, with the node id, memcg id, the new
max_seq, the anon and file min_seq, and the number of pages in each
generation for both types, as computed by lruvec_gen_size().

The nr_anon/nr_file arrays are ordered by seq rather than by generation
slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
they go from the oldest generation to the newest, the same order as the
debugfs lru_gen file, so the output can be read directly without mapping
slots back to seqs. Entries for seqs below the corresponding min_seq are
not in use and normally read as 0. The arrays are printed with
__print_array(), so the output is hex and its length follows
MAX_NR_GENS automatically.

Only the lruvec is passed in; all of the above is collected in
TP_fast_assign(), so inc_max_seq() does no extra work when the event is
disabled. Paired with mm_mglru_scan_folios it makes the full
aging-to-eviction window observable per memcg.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 8148b8224422..40d6d90f1d7a 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -456,6 +456,52 @@ TRACE_EVENT(mm_mglru_scan_folios,
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
+		unsigned long max_seq = lrugen->max_seq;
+		int i;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
+		__entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
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
index 1581b73aec56..841fefa68d1f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4115,6 +4115,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	trace_mm_mglru_inc_max_seq(lruvec);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1

