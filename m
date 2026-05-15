Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CC13DB996
	for <cgroups@vger.kernel.org>; Fri, 15 May 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865652; cv=none; b=kHEENwwD0AL7pvpaslhP/Efv4hOUxspD1W1y9ru1YwHXsfytgupiU3VHTcWy9/WK1UqZZ+6GpwkL7dLBBvd0py6n3U6ih+li6onbOUJtvWDer1mfMUjaPHJJIP4tNFT9o3M5KROLHWV+aZ98KFIibZJsqq2fh1y/05cFm7xhFqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865652; c=relaxed/simple;
	bh=BhbAU7pbEaMBJV8j8vxAdn5jKhnOV73y0eUp/bKD3tc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mV6rU5E/Ip6ZGviMYtjkkyM4tfLMWHRYbaYPScsv1xst4WZJJWgZ0Y2bNS5QAggVX4nE9tlyATVW9uaqzjmTdEFyRji1/p7de3fEOseWIKVuzJ+eeOKkUUkPVvmYIa3MMfRSNR7okgSkX3gxfH07BHI9rU8e1nvMeJRESPWE5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eLcDOAKi; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eLcDOAKi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778865639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B+gjGpKlxU8y7+0y5q8kDTxRVJrx4COiQ/G069Vfv7I=;
	b=eLcDOAKim84FlWMX3j2N/CWmKi5YYyXdduXkEnjm6fiPTjvo6cs01DM1sSwCyhKiulS+Vt
	bkMcHj/085lEvUQyXQ7NmwFUQK3ipwd0wVYVS7SY+FKqHB/icSwWCxl+CtMDhECBjhiAkh
	Oq/BkODkiR0A5bA1iclyLUxa367OYyY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
Date: Fri, 15 May 2026 10:19:53 -0700
Message-ID: <20260515171953.2224503-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node, but the per-CPU obj_stock_pcp still keys cached_objcg by
pointer. Cross-NUMA workloads now see a drain on every refill and a
miss on every consume that targets a sibling per-node objcg of the
same memcg, producing the 67.7% stress-ng switch-mq regression
reported by LKP.

stock->nr_bytes are fungible across per-node objcgs of one memcg:
drain_obj_stock() and obj_cgroup_uncharge_pages() both account via
obj_cgroup_memcg(). Treat the cache as keyed by memcg in both
__consume_obj_stock() and __refill_obj_stock() so siblings share the
reserve -- eliminating the drain on free and keeping the alloc fast
path in consume.

Though kernel test robot reported the regression but it was not easy to
reproduce locally. Qi implemented [1] a specialized reproducer to show
the corner case which cause the regression and then Qi tested the patch
and reported that the corner case is eliminated after the patch.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Qi Zheng <qi.zheng@linux.dev>
---
 mm/memcontrol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..66448f428531 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3210,7 +3210,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
+
+	/* Cache is keyed by memcg; sibling per-node objcgs share the reserve. */
+	if ((cached == objcg ||
+	     (cached && obj_cgroup_memcg(cached) == obj_cgroup_memcg(objcg))) &&
 	    stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		return true;
@@ -3318,6 +3322,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3332,10 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	/* Same memcg: bytes are fungible, no drain needed. */
+	if (cached != objcg &&
+	    (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-- 
2.53.0-Meta

