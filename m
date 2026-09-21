Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6E457E4D
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982002; cv=none; b=OPUZzzw4ThpgG6PyDzPf30rGLS9c6n8xVBezg5Ux5PA3oBi2EMA3Tx/b2oUOsb6FFJiqtS4lkzCvAPSYs+dbP+FH3KLDGxdOKjBflYk5ZaqnXDOoZEuEh6JGqh8/xrEZ5bL4cCWxaP3zqX/mJFcJaSbZGDzdubPjydvL0OJNXZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982002; c=relaxed/simple;
	bh=IDs/EyWNmqJ898UTthMq8jY9Q1siEUrx/p114gn5Wns=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=niK4UfHf78BOOFzI4hdRF+ZcOC5RA4GlqneWhTCvgdzz5H9ApM4iO7Ni9pHNwBx8WwQTGnYhue83rwXMC9+VNSITPMeEpD5mF/YPtOpGnPeSLkypCpmoSKxasUzOzIDA+V2gj0U0khMePm7A/TQ/jd0tzCOUtP6Q2FUXploG4XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k9INECDi; arc=none smtp.client-ip=91.218.175.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k9INECDi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IDs/EyWNmqJ898UTthMq8jY9Q1siEUrx/p114gn5Wns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789981998; v=1; x=1790586798;
 b=k9INECDiU2azQYNr44eOEUMVpgjRuGHtZgw3KW/S0rCYFh5svYkyAudRiOe0RlFhOo71ZKV3
 JxstsVrQiNl/pNTeqE7qH5XfSaNomzF2QxPN3CZndi23nQYTYLmNGOFDSOlaSdlIaHSujntjOla
 SVe6LkR/PhUwmmH/pmR6Wk4I=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c126fa98069b27b1;
	Mon, 21 Sep 2026 09:13:18 +0000
X-Mizu-Trace-ID: c126fa98069b27b1
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Mon, 21 Sep 2026 17:12:35 +0800
Subject: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
In-Reply-To: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>
Cc: hongfu.li@linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789981974; l=2700;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=7maGt7gBIU3c+GPCYRQ3OHOtV+Op/E4Dxf2YD4KKGv0=;
 b=sYVTVa5VHI0QpIl9gKOtFeVmq6k72AX6PouymGlK4tZgfU/sDP/xUMQEYtPFsuetgF5HnkyHp
 Wol77pUzrqMA5+yMrquCywDFXnag9IZ0lTqCj5u9dbSqJzQakpxSiK4
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
---
 mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..9c96ebd5436f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+				     struct folio *old, struct folio *new)
+{
+	long nr_pages = folio_nr_pages(old);
+	struct mem_cgroup *memcg;
+	int old_nid = folio_nid(old);
+	int new_nid = folio_nid(new);
+
+	if (old_nid == new_nid)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+	rcu_read_unlock();
+}
+#else /* CONFIG_HUGETLB_PAGE */
+static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+					    struct folio *old,
+					    struct folio *new)
+{
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /**
  * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
  * @old: Currently circulating folio.
@@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 
 	new_objcg = get_migration_objcg(old, new);
 
+	if (folio_test_hugetlb(old))
+		move_hugetlb_lruvec_stat(new_objcg, old, new);
+
 	/*
 	 * @old was charged through a non-root objcg, so its charge is in the
 	 * page counters. If the re-derivation walked up to the root objcg -

-- 
2.54.0

