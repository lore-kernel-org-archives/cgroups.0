Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935DC4B4052
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596098; cv=none; b=H/Mk4jl0l0E3CCBUYqwjCb8RXPpsWYF3Y2TnsZSvgcwYjraYnCurrqtvhNI87brPbMbhmpwgyUhJKDChk9UyWlljqisEiUkJFiuEDz6peDHSJfRrsV1IxT1fnes1/lcln1VCjnvJEYdSoj5kTHY6cm85UM5W4vF1BrdfgwMuOUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596098; c=relaxed/simple;
	bh=tt7LGshuqhNxDtoKCH/LZTI4ttNHcJzRhKME5HBY9Uw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hrKfaR25WueMbF+aSnolmHjRAH6irYb0KWBoIp55vufuMLwJiWORrt9vatBu13JR+zLSqgjJn+3oYe+mIS6vvryA5WkgxE30nR3gpP2pRDUEn8J7cqO2Z0/3EhJ19v6QfEfP78e2kKl+0ksUFF8njpXInBqrwxm94fQhF7mW1DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UDtqHTvX; arc=none smtp.client-ip=91.218.175.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UDtqHTvX"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tt7LGshuqhNxDtoKCH/LZTI4ttNHcJzRhKME5HBY9Uw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596094; v=1; x=1791200894;
 b=UDtqHTvX165RknbB241mgGwmNCIveH0xUbj48b0WW73B2ZkDKd3SIGsgEgK5BowKVUYYgJJ7
 WtkOKGkzXhYGt2JlGwPlkBAiRhNcMxoApEgwYHA/Wrga7cwyKhqjrh6pgQDfpxO/ogch5XIVfIX
 pTImSctQcfExyTUv9LQDPXRk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cc434b568fabe6dc;
	Mon, 28 Sep 2026 11:48:14 +0000
X-Mizu-Trace-ID: cc434b568fabe6dc
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 7/7] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
Date: Mon, 28 Sep 2026 19:46:24 +0800
Message-Id: <20260928114625.3609130-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

balance_pgdat() passes sc.order and sc.nr_reclaimed to
mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
struct scan_control instead and read the fields out in TP_fast_assign,
mirroring mm_vmscan_balance_pgdat_begin. highest_zoneidx stays a
separate argument as it is a local of balance_pgdat() rather than a
scan_control field.

The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 9 ++++-----
 mm/vmscan.c       | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 04f285e77659..c27bc7cc6063 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
 
 TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
-	TP_PROTO(int nid, int order, int highest_zoneidx,
-		 unsigned long nr_reclaimed),
+	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
 
-	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+	TP_ARGS(nid, sc, highest_zoneidx),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
+		__entry->order = sc->order;
 		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_reclaimed = sc->nr_reclaimed;
 	),
 
 	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6ec84390ee2a..52d90a32091e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7403,8 +7403,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
-- 
2.34.1

