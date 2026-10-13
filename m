Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD525012AE
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897288; cv=none; b=JSs5praFWruebScYWhbjsK8D+fRCXHkYOkQjDDt3sEtu92hQk+UsHdQrWWpC3A5d03GS0QyrBriUz9H+9vh/vyVyVEoM4ZcCJUC6l37gCCPF67g+QypUWj4rJnfMZHLBx3ksdxwJoKE3OfdWc53/+0Gf6ediTWP7hWd92o1XuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897288; c=relaxed/simple;
	bh=FCVJ8SXRn0tZTV1HcFTggppi9Q6Q0r80nrilbAeBeVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lWv2MBjIQ5Sav/gWrzhceHEvq4RJk+fUTPbniUXgz8vMN9Tj0vYiKrMOt9wgZjB1LckJnTiZOK6Yzi4e3/nvaw5cW+njR5JQp3NrcUFWwKrHZDb/vVYcgNZAhmhMoCkqCIlJlqBNyyoCqWJZ/mnuAn4bz1na7CGrk/c6nRBNDUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UStBtHps; arc=none smtp.client-ip=95.215.58.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UStBtHps"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FCVJ8SXRn0tZTV1HcFTggppi9Q6Q0r80nrilbAeBeVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897284; v=1; x=1792502084;
 b=UStBtHpsdd2Kv0cnXCGfhWCETymyo4u4Aq8qZt6K4HIkh1dnOns7Kc6IlDY17p7F3ClQ7RPd
 xvfqnzzeb2/IhHn70mx8C9mhyi1Ui/OuNsDnelNfyGnk2rT/3YBVH7LW5pavuMqOsQZzvOgU9kB
 L2iF2U4jk4XuCtnviwZDvk1s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 320e4235ca64a28a;
	Tue, 13 Oct 2026 13:14:44 +0000
X-Mizu-Trace-ID: 320e4235ca64a28a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 6/7] mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
Date: Tue, 13 Oct 2026 21:13:08 +0800
Message-Id: <20261013131309.2790253-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

reclaim_folio_list() passes sc.nr_scanned to mm_vmscan_reclaim_pages as
a bare argument. Pass the enclosing struct scan_control instead and read
nr_scanned out in TP_fast_assign, consistent with the other reclaim
tracepoints. nr_reclaimed stays a separate argument: it is the return
value of shrink_folio_list(), which does not update sc->nr_reclaimed.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 10 +++++-----
 mm/vmscan.c       |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index aa27cb9524bb..96e41f444924 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -418,11 +418,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		 struct reclaim_stat *stat),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+	TP_ARGS(nid, sc, nr_reclaimed, stat),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -440,7 +440,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->nr_scanned = nr_scanned;
+		__entry->nr_scanned = sc->nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->nr_dirty = stat->nr_dirty;
 		__entry->nr_writeback = stat->nr_writeback;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c25ba910149d..b3278dbe47bf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2183,7 +2183,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
-- 
2.34.1

