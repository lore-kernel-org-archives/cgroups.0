Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512851E3DDE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787188825; cv=none; b=EkQFJL7lbrIdTMmAjF+tgZb2mUn6sKoX9U+rMsqvv1OI8KrSbLeEhN5VuL2wqwkEPLnABGV57lLzLCDVBB7P+w/q9EFE/XCZXTPR7i9DVS5ZoXbMMIvrN3y08vbpPJ9hh7GopW+W/qoR4Jot+PCJ+fJjILiH4bcve8GwatLOJSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787188825; c=relaxed/simple;
	bh=EmRWlLrhUsn2mz2khysYs0MSc5Fd2vcA/XgcGeGyEd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fL9wS0aA6t43QisTiD77SR/n9WusChLAa/9YoJaX5LOMk+z0BtTxi0B9rHM7nT4rjR/CIZUN8mHfeBFTdelxcWxUuJyaBBg+6wpDFhI9SciSX21+hJ8360Vr+yc8tzRBIO3Ra9ml9PBgAIobQ+lAuLV2pmyp/vDXAmbNPVFybiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TctZde4m; arc=none smtp.client-ip=91.218.175.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TctZde4m"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EmRWlLrhUsn2mz2khysYs0MSc5Fd2vcA/XgcGeGyEd4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787188819; v=1; x=1787793619;
 b=TctZde4mK1IEAOuc9IeIastqyEN0xaP6dv/V5XGHluMvk4YAu7cvE1wwgED2WgmBAuz8ETIi
 eGl7eSJISFao1CKa9L+1+5oDW7hxvBYTY6Zv7mHoMxxB2lUaJvT45Rob2TTK1nmf/nhA5PmA/PP
 ZGmmYAFB/VJTTxoKKyOl4Nc0=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:19::)
	by smtp.migadu.com with ESMTPS id 56f0944df267c2d4;
	Thu, 20 Aug 2026 01:20:19 +0000
X-Mizu-Trace-ID: 56f0944df267c2d4
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: [PATCH v2] memcg: trim the per-cpu charge stock instead of draining it
Date: Wed, 19 Aug 2026 18:20:10 -0700
Message-ID: <20260820012010.2016086-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Joy reported that an application generating a request/response traffic
pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
for a range of message sizes, against 0.27% to 0.71% outside that range.
Running from the root memcg, where socket memory accounting is skipped,
recovers the performance.

Tracing the charge path showed that the application generates a pattern
where the write syscall charges one page and the read syscall uncharges
two pages on the same CPU. This hits a corner case in the memcg percpu
stock code that thrashes the stock continuously.

In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
watermark and the emptying target, i.e. on a request to charge one page
the kernel charges MEMCG_CHARGE_BATCH pages and caches
(MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
and refill_stock() then empties the cache completely. With such a
pattern the percpu stock becomes completely ineffective.

Instead of a single boundary point for charges, use the technique the
page allocator uses for its own percpu caches, which keeps the watermark
and the emptying target apart: nr_pcp_free() frees between batch and
high - batch pages, leaving at least pcp->batch on the list. Add a high
watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
return only the pages above MEMCG_STOCK_LOW. The watermarks are
MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
batch.

For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in
future we will reevaluate if it makes sense to increase it.

Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---

Changes since v1:
http://lore.kernel.org/20260817234651.666540-1-shakeel.butt@linux.dev
- Kept the upper limit of memcg stock same as before (Michal)

 mm/memcontrol.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..58e4d23cf5e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2048,6 +2048,15 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
  * nr_pages in a single cacheline. This may change in future.
  */
 #define NR_MEMCG_STOCK 7
+
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
+ */
+#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
+#define MEMCG_STOCK_HIGH	(MEMCG_CHARGE_BATCH)
+
 #define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
 	local_trylock_t lock;
@@ -2223,17 +2232,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
-	uint8_t stock_pages;
+	unsigned int stock_pages;
 	bool success = false;
 	int empty_slot = -1;
 	int i;
 
 	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 * nr_pages[] is a uint8_t and a slot's count is capped at
+	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
+	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
@@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			empty_slot = i;
 		if (memcg == READ_ONCE(stock->cached[i])) {
 			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			if (stock_pages > MEMCG_STOCK_HIGH) {
+				memcg_uncharge(memcg,
+					       stock_pages - MEMCG_STOCK_LOW);
+				stock_pages = MEMCG_STOCK_LOW;
+			}
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
 			success = true;
 			break;
 		}
-- 
2.53.0-Meta

