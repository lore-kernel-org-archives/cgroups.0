Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8935B12B
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 02:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129174; cv=none; b=BR+muuYR+VPi7pmTEsWGFqnZQgtWrVV6Lk1eqaiMTvigqzDk1nT9Jt/GXwycIlv2ycvcYiXGyd8gWq3g1ZUKxd7BQh5hRiWnkXqybW0sVQ0GfJmULTtTq5GELGeHE9xtlIhQmUDAiiEzVdIuhUnTzhsTiQOL0+Ng5z/ylUT0JQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129174; c=relaxed/simple;
	bh=0ISTjzArDvrHCvzOuzvqWLDvbJceHC6JZIVo8RNRwPU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ce1amTDb3c6pn412B3RbYc+i6Xhe3qyNfFkVL0Om1cL53IUpo+Dm7rEvC1GVHAKnlE9y5Otqe30504HMt+ONEa1/VbzwhFuBVtgL4QtMhGP9ZweUOHwxsr1wvuHK5KHCilFzIhrUpu7hg4tLG5O4SWtIvxaETfQizBDk1wIHfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RWrtAuV1; arc=none smtp.client-ip=95.215.58.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RWrtAuV1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0ISTjzArDvrHCvzOuzvqWLDvbJceHC6JZIVo8RNRwPU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129169; v=1; x=1790733969;
 b=RWrtAuV1Yq/ALp5TKkxvoyTdBdAUXQKZ7gZieqVa98LZP1Er1GfeXlwRyrYasXm4o6gp3RTc
 vqrwlIcyTxHjw+9m6gk9WT+kIf0ZYDqKDIV0Pdbz/pYwap1+VA1FWJZdRweK0PQrF/p/svHp+0q
 PRv5qUmO91Ks1lUoAAQuO6EI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf62ea15ecec1017;
	Wed, 23 Sep 2026 02:06:09 +0000
X-Mizu-Trace-ID: cf62ea15ecec1017
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 23 Sep 2026 10:05:16 +0800
Subject: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
In-Reply-To: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=4285;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=XnpfUOE9XDiYB80tcgMo2fYCgw4drhX0D7pb8CGUdW8=;
 b=3j/63EyE0toWk7b1TPsklFCt/sTcSFe0N88Cd87hN9fQfmC8YUb/PLi2xqQKzcvACybh2WHJ7
 nawKxPtGfCeCKpIYgzJOc1by+YN3IJQOY/015YPf/IycUp7DinKYc3o
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=

From: Hongfu Li <lihongfu@kylinos.cn>

memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
stats. These stats are accounted against folio_nid(): incremented on
the folio's node when handed to a user, decremented when the folio is
returned to the pool.

During hugetlb folio migration, mem_cgroup_migrate() moves the charge
to the new folio and drops the memcg data of the old one, so the free
of the old folio right after the migration skips the memcg per-node
lruvec decrement. The hugetlb count stays attributed to the old node
for the rest of the life of the charge, while the target folio gets no
increment on the new node; its later free decrements a counter that
was never incremented.

Migrate the per-node lruvec accounting alongside migration. Global
memcg totals remain balanced because they track resource consumption,
not node placement.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/memcontrol.h |  8 ++++++++
 mm/hugetlb.c               | 25 +++++++++++++++++++++++++
 mm/memcontrol.c            |  5 ++---
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a8358f297b65..74110a324f9e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1452,6 +1455,11 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 519c30b338a8..76d019594b39 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -23,6 +23,7 @@
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/rcupdate.h>
 #include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
@@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
 	folio_put(folio);
 }
 
+static void move_hugetlb_lruvec_stat(struct folio *old_folio,
+				     struct folio *new_folio)
+{
+	struct mem_cgroup *memcg;
+	long nr_pages = folio_nr_pages(old_folio);
+	int old_nid = folio_nid(old_folio);
+	int new_nid = folio_nid(new_folio);
+
+	if (old_nid == new_nid)
+		return;
+
+	guard(rcu)();
+
+	memcg = folio_memcg(new_folio);
+	if (!memcg)
+		return;
+
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+}
+
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
 	hugetlb_cgroup_migrate(old_folio, new_folio);
+	move_hugetlb_lruvec_stat(old_folio, new_folio);
 	folio_set_owner_migrate_reason(new_folio, reason);
 
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 88824f783571..a5335da5d425 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;

-- 
2.54.0

