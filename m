Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793437312;
	b=IXiMKeAXr/EA1irEBLGChzqyOx1ZjwpIKYfe7fgnVscyb2ZFPpjmKv1K13kEW8xKOA42
	 jHBSrbhrzx4rZnjuRi+hgGnBI7H/Z0SoXO8/xTU+dhdx+rZ3sLYfR6UAJQdRPYSNUY1Fh
	 LIMl6VqQC+9hD65MjVSSKVueaQIZFbTVilsxcAqRnPDgBIYnxrMi/tYrxlEWA/S/D/yJe
	 u1KTWrm9xMrKS486YoeiU9mwCEvCjr6NBNTUHnRKiVoACbTxgH+/LoVmmg8FpS25cQ+o+
	 B69NedGQgAAyCJaBhyJDAlwmz3/AtUueW6FxOFAEFcvQw5pOyzROPSoeNTwDvmBNsOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437312;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p4OmGQxsritGUdYbgy/naTEuzzYOIoKE4RkWq95RFj8=;
	b=cjM1Pk+7tN4wlxqPlYnEMCE+FVltBR7zk6GaLSGbQDVUJebU4//4++bUAAcGdWw41GRQ
	 3pqnG3yI+1HIR8eudHRtAGYfhEvtR+veQNVgs7XstjQT42raM7DfRdB0rgwFTGysOQsv/
	 z3DTkgGZyTkOCA3lpUl8g5UFVQXI2v0NuZFrN4v3m6uuwBuJmIx+UwRlupIVw0OfZKv/U
	 LEbE3v+oGuJFTIt7drPgCT3uWWh/hDcrrDdPjWfmCfwgbxq/Am5r2mnRk6XW0nbuk370A
	 mcAOfNkTu9oaRfbWfSDcsGPXvFdcOMe5ip5q6mmTvQ7Ef0a37z9OAv6Ncok6gnF7FTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bxoqk+Ac;
	arc=none smtp.remote-ip=95.215.58.99
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89968606A323
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 09:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89968606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bxoqk+Ac
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ls8zPAr0DtsaeSjNYl2FTkQyXE0tQvzbmKKSnoHdJ8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437309; v=1; x=1794042109;
 b=bxoqk+AcExeM4CrDXgUqVYesb4iWBXa5MSdaUclXkE2MuThsFFqcpRwHIhcMRvZhy4TW2eMr
 rU0orMLeqowtzGC1Xz+0d8AzyhjKbQ7FtzOR3eocB7dNFm6c5BwwUHpWN7ce3wHrOcQDcj6Gi1Q
 bnqgfwCF/JHkhpfAue+x9fSg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9b188fab69ac5f20;
	Sat, 31 Oct 2026 09:01:49 +0000
X-Mizu-Trace-ID: 9b188fab69ac5f20
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
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 5/6] mm/mglru: add tracepoint for scan_folios()
Date: Sat, 31 Oct 2026 17:00:40 +0800
Message-ID: <20261031090041.58574-6-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
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

MGLRU's scan_folios() emits the classic-LRU tracepoint
trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
scan/isolate counts and the LRU type, but carries no generation or
memcg context, so a trace of an MGLRU run cannot tell which memcg a
given scan belongs to, nor how far reclaim has progressed through the
generations.

Add mm_mglru_scan_folios next to it, reporting the same counters plus
nr_sorted (folios moved to a younger generation by sort_folio()) and
the context the classic tracepoint lacks: the node id and memcg id of
the lruvec, and the max_seq, tier and min_seq of the type being
scanned.

Now that struct scan_control is visible to the trace header, pass sc,
lruvec, type and tier straight in and derive everything else in
TP_fast_assign(), so nothing is computed at the call site when the
event is disabled. The int fields are grouped at the end of the entry
to avoid padding on 64-bit.

scan_folios() is the MGLRU-specific layer where folios are actually
scanned, so it has no classic-LRU counterpart. The existing tracepoint
is left unchanged.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |  2 ++
 2 files changed, 68 insertions(+)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index b2ad83e5f25e..8148b8224422 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -392,6 +392,72 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+#ifdef CONFIG_LRU_GEN
+TRACE_EVENT(mm_mglru_scan_folios,
+
+	TP_PROTO(struct lruvec *lruvec,
+		 struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_sorted,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int type,
+		 int tier),
+
+	TP_ARGS(lruvec, sc, nr_requested, nr_scanned, nr_sorted, nr_skipped,
+		nr_taken, type, tier),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_sorted)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, min_seq)
+		__field(int, nid)
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(int, lru)
+		__field(int, tier)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_sorted = nr_sorted;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->max_seq = lruvec->lrugen.max_seq;
+		__entry->min_seq = lruvec->lrugen.min_seq[type];
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
+		__entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+		__entry->tier = tier;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->highest_zoneidx,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_sorted,
+		__entry->nr_skipped,
+		__entry->nr_taken,
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__entry->max_seq,
+		__entry->tier,
+		__entry->min_seq)
+);
+
+#endif /* CONFIG_LRU_GEN */
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 15e9184a580a..ff51fee872f8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4852,6 +4852,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
-- 
2.43.0

