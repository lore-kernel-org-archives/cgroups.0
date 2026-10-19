Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FFF3D9DB1
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 04:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383820; cv=none; b=HTWdjTCikS9lo/4gx9hiSNN6oiPZUQi4v+rfqZDJnVge1SFf2dyJl4rzzqrOJpVD28muWkP2prBsW7R9s4nSi2MAMgLUWeeOlQrypdxCIMnIGP/g0q6ikM9g8dlJTQOuKyGhnmfLjbkGI7FROsSf/3XwD56aIJQDJ5EDGX4LN8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383820; c=relaxed/simple;
	bh=7Fh4oWhpxYf6gDp8+ypvgmOJyH6o3AMY/5a5fCOp5W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WxSX2bS1S743eutmASQOKCZt1b9LGkV3qrkMtZXgVrv2hqCJMfkeObzI0czrFSArwPiNuDZizbWxsL0rfiAmE47KolTBFRBjBTbBxfIh9nVynLsA0VB+7YkpvX22QOUB74TDx6Z2xzw0FubqY4sdxJlkQ1k+U251uIUPOBZRqME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a6QHE08R; arc=none smtp.client-ip=95.215.58.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a6QHE08R"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7Fh4oWhpxYf6gDp8+ypvgmOJyH6o3AMY/5a5fCOp5W8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383815; v=1; x=1792988615;
 b=a6QHE08RlA/FtFPBT9ahJq3lrRxqw1ajmYxiPQZdm5Y0ZhOnyeRqTSfIoQqq5uu1BpV+DUyx
 u+93ERYyHTFIW+bUgaNqtSyFycobXbJzgY8yIDVP+QUv3NLyHqKEDU+gxNKUZ77Yhz9YyPbmIYs
 BHAQmcJMn5RNoDuevMX3srbE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a50a931287826443;
	Mon, 19 Oct 2026 04:23:35 +0000
X-Mizu-Trace-ID: a50a931287826443
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
Subject: [PATCH v4 6/9] mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
Date: Mon, 19 Oct 2026 12:23:05 +0800
Message-Id: <20261019042308.2372396-1-ridong.chen@linux.dev>
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
index b1b329039e14..54168ad45f6e 100644
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
index 5d5eee757c61..4bb00371a67f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2178,7 +2178,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
-- 
2.34.1

