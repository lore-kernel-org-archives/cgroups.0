From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 5/6] memcg: make mem_cgroup_reparent_charges non failing
Date: Fri, 19 Oct 2012 15:49:34 +0200
Message-ID: <20121019134934.GG799@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

This is an updated version of the patch. I have dropped
.__DEPRECATED_clear_css_refs in this one as it makes the best sense to
me. I didn't add Tejun's Reviewed-by because of this change. Could you
recheck, please?
---
From 6c1f2e76e254e7638ad8cc87f319e3492ac80c5b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 17 Oct 2012 14:15:09 +0200
Subject: [PATCH] memcg: make mem_cgroup_reparent_charges non failing

Now that pre_destroy callbacks are called from within cgroup_lock and
the cgroup has been checked to be empty without any children then there
is no other way to fail.
mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
because all css' are marked dead already.

mem_cgroup_subsys.__DEPRECATED_clear_css_refs can be dropped as
mem_cgroup_pre_destroy cannot fail now.

Changes since v1
- drop __DEPRECATED_clear_css_refs

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f57ba4c..b4d854e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3738,14 +3738,12 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  *
  * Caller is responsible for holding css reference on the memcg.
  */
-static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
+static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 	int node, zid;
 
 	do {
-		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
-			return -EBUSY;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
@@ -3771,8 +3769,6 @@ static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 		 * charge before adding to the LRU.
 		 */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
-
-	return 0;
 }
 
 /*
@@ -3809,7 +3805,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 
 	}
 	lru_add_drain();
-	return mem_cgroup_reparent_charges(memcg);
+	mem_cgroup_reparent_charges(memcg);
+
+	return 0;
 }
 
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
@@ -5013,13 +5011,9 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
-	css_get(&memcg->css);
-	ret = mem_cgroup_reparent_charges(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	mem_cgroup_reparent_charges(memcg);
+	return 0;
 }
 
 static void mem_cgroup_destroy(struct cgroup *cont)
@@ -5621,7 +5615,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
-	.__DEPRECATED_clear_css_refs = true,
 };
 
 #ifdef CONFIG_MEMCG_SWAP
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
