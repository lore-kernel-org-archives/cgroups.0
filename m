From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 10 Nov 2020 11:10:15 +0800
Message-ID: <20201110031015.15715-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KlEMtRRnho5R/oyJ91jqGRJUyzsYfbjHE3I8y8AmGbY=;
        b=R9EijyKWLRbgDkV06Ti/5mY8HOQ6susqJloDOVCXIqcYpJ5pb7SPWMpqTcgVWIVS5r
         UiWNh/k9/+E8/5FvOJc5/z01kkQXtzYtvo34o/4wSuS14FkmgIttf4P8P51S7wPytvTS
         5B66HUz6Mu3iZsXyOCgw3HOm4eH0CCd4a6HCYOPQim/YG48Q9J2GvppV+acfVBsj2I+n
         qEn/5duGPZYda8iUehkSKlqVH8gb6oxgUD0TIuYpwuflNL+sFFjEq8RYaStSNbgWxyWf
         Rfb8TgiWxwR4PAcKDy7UXYv2O0tWoo2fhiZMf9o29JfklOxBeWfqWY/mi6EqSdgIBNWZ
         nvTw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, laoar.shao@gmail.com, songmuchun@bytedance.com, chris@chrisdown.name
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

If we reparent the slab objects to the root memcg, when we free
the slab object, we need to update the per-memcg vmstats to keep
it correct for the root memcg. Now this at least affects the vmstat
of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
size is smaller than the PAGE_SIZE.

Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
---
 v1->v2:
 - Just resend the patch.

 mm/memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2dde734df7d1..bbd40c5af61e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -875,8 +875,13 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_obj(p);
 
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	/*
+	 * Untracked pages have no memcg, no lruvec. Update only the
+	 * node. If we reparent the slab objects to the root memcg,
+	 * when we free the slab object, we need to update the per-memcg
+	 * vmstats to keep it correct for the root memcg.
+	 */
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-- 
2.20.1

