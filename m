From: Jianyu Zhan <nasa4836@gmail.com>
Subject: [PATCH 2/2] mm/memcontrol.c: introduce helper mem_cgroup_zoneinfo_zone()
Date: Sat, 19 Apr 2014 07:01:43 +0800
Message-ID: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=xjLzpvt9XxRYZmpeGX4JyVN0Hdq8dgdUqay/WHYX4co=;
        b=TupyTHp+xyuU2Lkl1SctPpSwITEZAxzOLqhN2z57mAZ2pWkE4RLmDSUBMon8eW6uw2
         V8lgSLvrY2XUBXVaRu6CZCB4kW6svvRhhAYnEz5ppQk7lLeA0D45ZBC7qrGYegqLLIqu
         9IuAGjHq2qteEMbdb0Pa8plMkB45GCcz/yRz8hm44tA9r/hHwqM2LmVLO8NLqsqi05c9
         9UImjqaqDpiS7K0jW7x9hqWThpQmy9A59Am9CvMvoF80HPh5B9zAsEPOiIS1Pu0XiiVk
         iog9pfKqy1UtaYRUlQQQhKZHHeuJtC+QP8uqg56LuNCMGXlTD10M5FbtXaLLS1SfH99f
         fNUQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com

introduce helper mem_cgroup_zoneinfo_zone(). This will make
mem_cgroup_iter() code more compact.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e0ce15c..80d9e38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -683,6 +683,15 @@ mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
 	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
+static struct mem_cgroup_per_zone *
+mem_cgroup_zoneinfo_zone(struct mem_cgroup *memcg, struct zone *zone)
+{
+       int nid = zone_to_nid(zone);
+       int zid = zone_idx(zone);
+
+       return mem_cgroup_zoneinfo(memcg, nid, zid);
+}
+
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 {
 	return &memcg->css;
@@ -1232,11 +1241,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 	rcu_read_lock();
 	if (reclaim) {
-		int nid = zone_to_nid(reclaim->zone);
-		int zid = zone_idx(reclaim->zone);
 		struct mem_cgroup_per_zone *mz;
 
-		mz = mem_cgroup_zoneinfo(root, nid, zid);
+		mz = mem_cgroup_zoneinfo_zone(root, reclaim->zone);
 		iter = &mz->reclaim_iter[reclaim->priority];
 		if (prev && reclaim->generation != iter->generation) {
 			iter->last_visited = NULL;
@@ -1340,7 +1347,7 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
 		goto out;
 	}
 
-	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
+	mz = mem_cgroup_zoneinfo_zone(memcg, zone);
 	lruvec = &mz->lruvec;
 out:
 	/*
-- 
1.9.0.GIT

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
