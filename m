Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674670;
	b=5GEoLXGnD8Q2tSmIrW7BI8hrZ1+g2LFeisJIQeo3twWsXJYrBtjO4NliXICzAVq0oiys
	 OLHn8NHLuSFSIn4eWahFSEB8hCR8e6RrDrbeqbwpaapu+v0NiotYrcfaJE9TaDg2qaVXy
	 JipbZdg9LNsfoWsPN9Yi7Pbb9zKMB4esLVhkyBz91DCBfHJFuu47SwvfpzjLObUjXvsd1
	 69sYCg0sbRTZrhedSc71U5MT/7Ixsv2MpsIVEItkLQ0kHqDt4hoJxM4Ibl8ADOHKb3mdz
	 QsdXNSWBKkbtingcq1xQyV06uuRLhvcVQR+fR9YQN62yDIF6vL2dViSKghJwV/cpfbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674670;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2CYw4TJon3a1gyE3IXvNjkyv8y6xkEjfo7VNXh+JX/8=;
	b=Ujf0AC5yGrZ3bIRq/iw5eNKlJpHn5JZZroeIGWmQZJnVDj+BC1lPUkIQzQVyJq5m7WZo
	 LKMcy26+vZl1fNt4riG53E2V77wQlgOW8HDbJUSgmR3WCb+L2HuDuHbkXmkEjUw2Y8m+E
	 yfkDMREEBxC+URerta/4h81MxEPWhIDln9beF19uMvDzMACPH4DH721UgKks/+wjWeYrP
	 zID0sknyvqzngeWM8e3QFin3NFzhwZkdm104yc1liafThES286hsuK8flReWVJ2Pw83a1
	 0MOMQALCb7ZiB1ghL5yqujZlIghYh3hqJTisCn18I0VDJmJvCU71Jf9qImHtMMxthOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qRmZKOvx;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4DF606A329
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 02:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD4DF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qRmZKOvx
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JI4Fvh2wr8Cnl+a4gBEMEis0OoLVQQsg/DZU5Vjf0/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674668; v=1; x=1794279468;
 b=qRmZKOvxAZzm29pWdZ4p+FiOcdAlOd31TkwZ1mYWu/Aio0acThHVchO6FD9KWaFd/nRjO78T
 e5LBfuH+TgccdMlIR8DpejX0pY34wf/rrevm06HpYXTCB0J5wGvvHe4/wTPC9n+m7nXwVgfTJYX
 53zm5OnXyfcKKE7BNqjbDBS4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 066f37554edb6d0d;
	Tue, 03 Nov 2026 02:57:46 +0000
X-Mizu-Trace-ID: 066f37554edb6d0d
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
Subject: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
Date: Tue,  3 Nov 2026 10:56:09 +0800
Message-Id: <20261103025610.3738894-7-ridong.chen@linux.dev>
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

The number of pages of a given type in a generation is computed by
summing lrugen->nr_pages[gen][type][] over all zones and clamping each
per-zone counter to >= 0, since the counters are updated locklessly and
can transiently go negative. This loop is open-coded in
lruvec_evictable_size() and in the debugfs lru_gen output.

Add lruvec_gen_size() to compute it from a seq, and convert both users.
Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
header, can use it as well.
An upcoming tracepoint and the MGLRU swappiness rework will also use it.

No functional change.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 18 ++++++------------
 mm/vmscan.h | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3054175717ab..1581b73aec56 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4207,18 +4207,15 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			total += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	return total;
@@ -5723,20 +5720,17 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
-			seq_printf(m, " %10lu%c", size, mark);
+			seq_printf(m, " %10lu%c",
+				   lruvec_gen_size(lrugen, type, seq), mark);
 		}
 
 		seq_putc(m, '\n');
diff --git a/mm/vmscan.h b/mm/vmscan.h
index adb22e80d760..c6b583fc7493 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -3,6 +3,7 @@
 #define _MM_VMSCAN_H
 
 #include <linux/gfp_types.h>
+#include <linux/mm_inline.h>
 #include <linux/nodemask.h>
 #include <linux/swap.h>
 #include <linux/types.h>
@@ -115,4 +116,19 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+#ifdef CONFIG_LRU_GEN
+/* The number of pages of @type in the generation @seq, summed over all zones */
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+					    int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+#endif /* CONFIG_LRU_GEN */
+
 #endif /* _MM_VMSCAN_H */
-- 
2.34.1

