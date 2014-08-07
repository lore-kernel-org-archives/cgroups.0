From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/4] mm: memcontrol: add memory.current and memory.high
 to default hierarchy
Date: Thu, 7 Aug 2014 15:39:20 +0200
Message-ID: <20140807133920.GD12730@dhcp22.suse.cz>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
 <1407186897-21048-3-git-send-email-hannes@cmpxchg.org>
 <20140807133614.GC12730@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140807133614.GC12730@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 07-08-14 15:36:14, Michal Hocko wrote:
> On Mon 04-08-14 17:14:55, Johannes Weiner wrote:
> [...]
> > @@ -132,6 +137,19 @@ u64 res_counter_uncharge(struct res_counter *counter, unsigned long val);
> >  u64 res_counter_uncharge_until(struct res_counter *counter,
> >  			       struct res_counter *top,
> >  			       unsigned long val);
> > +
> > +static inline unsigned long long res_counter_high(struct res_counter *cnt)
> 
> soft limit used res_counter_soft_limit_excess which has quite a long
> name but at least those two should be consistent.
> I will post two helper patches which I have used to make this and other
> operations on res counter easier as a reply to this.

These two are sleeping in my queue for quite some time. I didn't get to
post them yet but if you think they will make sense I can try to rebase
them on the current tree and post.
---
From 3f3185306b225931a45387f288645ba9044565d0 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 19 Jun 2014 19:14:31 +0200
Subject: [PATCH 1/2] res_counter: provide res_counter_write_u64

to allow setting member based value setting. This will reduce code
duplication for the new limits added by this patch series.

Use the new helper to replace one-off res_counter_set_soft_limit.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/res_counter.h | 14 ++------------
 kernel/res_counter.c        | 14 ++++++++++++++
 mm/memcontrol.c             |  2 +-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 56b7bc32db4f..bea7f9f45f7a 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -71,6 +71,8 @@ struct res_counter {
 
 u64 res_counter_read_u64(struct res_counter *counter, int member);
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
+
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
@@ -208,16 +210,4 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
 	return ret;
 }
 
-static inline int
-res_counter_set_soft_limit(struct res_counter *cnt,
-				unsigned long long soft_limit)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cnt->lock, flags);
-	cnt->soft_limit = soft_limit;
-	spin_unlock_irqrestore(&cnt->lock, flags);
-	return 0;
-}
-
 #endif
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index e791130f85a7..4789c2323a94 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -171,11 +171,25 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
 
 	return ret;
 }
+
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	*res_counter_member(counter, member) = val;
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
 #else
 u64 res_counter_read_u64(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }
+
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	*res_counter_member(counter, member) = val;
+}
 #endif
 
 int res_counter_memparse_write_strategy(const char *buf,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1b311687769..1ad5d4a2bc4e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4378,7 +4378,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		 * control without swap
 		 */
 		if (type == _MEM)
-			ret = res_counter_set_soft_limit(&memcg->res, val);
+			res_counter_write_u64(&memcg->res, name, val);
 		else
 			ret = -EINVAL;
 		break;
-- 
2.1.0.rc1

---
From 8c79f2c209f806b97ec368c3e649ef58caeb7e99 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 19 Jun 2014 19:42:25 +0200
Subject: [PATCH 2/2] memcg, res_counter: replace res_counter_soft_limit_excess
 by a more generic helper

Later patches in the series will add new limits which we will want to
check for excess as well so change the current on-off
res_counter_soft_limit_excess to a more generic helper.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/res_counter.h | 21 +++++++++++++++------
 mm/memcontrol.c             | 10 +++++-----
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index bea7f9f45f7a..9015013784fa 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -156,23 +156,32 @@ static inline unsigned long long res_counter_margin(struct res_counter *cnt)
 }
 
 /**
- * Get the difference between the usage and the soft limit
+ * Get the difference between the usage and the limit defined
+ * by the given member
  * @cnt: The counter
  *
- * Returns 0 if usage is less than or equal to soft limit
- * The difference between usage and soft limit, otherwise.
+ * Returns 0 if usage is less than or equal to the limit defined
+ * by member or the difference otherwise.
  */
 static inline unsigned long long
-res_counter_soft_limit_excess(struct res_counter *cnt)
+res_counter_limit_excess(struct res_counter *cnt, int member)
 {
 	unsigned long long excess;
+	unsigned long long limit;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cnt->lock, flags);
-	if (cnt->usage <= cnt->soft_limit)
+	switch(member) {
+		case RES_SOFT_LIMIT:
+			limit = cnt->soft_limit;
+			break;
+		default:
+			BUG();
+	}
+	if (cnt->usage <= limit)
 		excess = 0;
 	else
-		excess = cnt->usage - cnt->soft_limit;
+		excess = cnt->usage - limit;
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return excess;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ad5d4a2bc4e..75b5db78e9be 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -773,7 +773,7 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		mz = mem_cgroup_page_zoneinfo(memcg, page);
-		excess = res_counter_soft_limit_excess(&memcg->res);
+		excess = res_counter_limit_excess(&memcg->res, RES_SOFT_LIMIT);
 		/*
 		 * We have to update the tree if mz is on RB-tree or
 		 * mem is over its softlimit.
@@ -827,7 +827,7 @@ retry:
 	 * position in the tree.
 	 */
 	__mem_cgroup_remove_exceeded(mz, mctz);
-	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
+	if (!res_counter_limit_excess(&mz->memcg->res, RES_SOFT_LIMIT) ||
 	    !css_tryget_online(&mz->memcg->css))
 		goto retry;
 done:
@@ -1983,7 +1983,7 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 		.priority = 0,
 	};
 
-	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
+	excess = res_counter_limit_excess(&root_memcg->res, RES_SOFT_LIMIT) >> PAGE_SHIFT;
 
 	while (1) {
 		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
@@ -2014,7 +2014,7 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
 						     zone, &nr_scanned);
 		*total_scanned += nr_scanned;
-		if (!res_counter_soft_limit_excess(&root_memcg->res))
+		if (!res_counter_limit_excess(&root_memcg->res, RES_SOFT_LIMIT))
 			break;
 	}
 	mem_cgroup_iter_break(root_memcg, victim);
@@ -3941,7 +3941,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 			} while (1);
 		}
 		__mem_cgroup_remove_exceeded(mz, mctz);
-		excess = res_counter_soft_limit_excess(&mz->memcg->res);
+		excess = res_counter_limit_excess(&mz->memcg->res, RES_SOFT_LIMIT);
 		/*
 		 * One school of thought says that we should not add
 		 * back the node to the tree if reclaim returns 0.
-- 
2.1.0.rc1

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
