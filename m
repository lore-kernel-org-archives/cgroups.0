From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH 5/8] memcg: Allow direct per-task memory limit checking
Date: Mon, 17 Aug 2020 10:08:28 -0400
Message-ID: <20200817140831.30260-6-longman@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597673403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=gLC3iaZ7OOAbkDpDBx+l3EQ6N48p5E+2TCrsju7XHF8=;
        b=L9tdU6U6Iveqx6SGsGy2mqlNhwYnVjPA0yjdZxqZySKlOtl9QqLS7sU7WAfv5Zg8erSV1d
        3p47QU1TuPc5RfoiA10qAQfHPa3TMRZu9Ic1r7yyRfDkQZUT6bTcTsHhIwOlMAe0PZu956
        ROSTdAkIigWAF6/blPxPdX/0+HS+u9Q=
In-Reply-To: <20200817140831.30260-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Waiman Long <longman@redhat.com>

Up to now, the PR_SET_MEMCONTROL prctl(2) call enables user-specified
action only if the total memory consumption in the memory cgroup
exceeds memory.high by the additional memory threshold specified.

There are cases where a user may want direct memory consumption control
for certain applications even if the total cgroup memory consumption
has not exceeded the limit yet. One way of doing that is to create one
memory cgroup per application. However, if an application call other
helper applications, these helper applications will fall into the same
cgroup breaking the one application per cgroup rule.

Another alternative is to enable user to enable direct per-task memory
limit checking which is what this patch is about. That is for special
use cases and is not recommended for general use as memory reclaim may
not be triggered even if the per-task memory limit has been exceeded.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/uapi/linux/prctl.h |  4 ++-
 mm/memcontrol.c            | 52 +++++++++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index ef8d84c94b4a..7ba40e10737d 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -265,13 +265,15 @@ struct prctl_mm_map {
 
 /* Flags for PR_SET_MEMCONTROL */
 # define PR_MEMFLAG_SIGCONT		(1UL <<  0) /* Continuous signal delivery */
+# define PR_MEMFLAG_DIRECT		(1UL <<  1) /* Direct memory limit */
 # define PR_MEMFLAG_RSS_ANON		(1UL <<  8) /* Check anonymous pages */
 # define PR_MEMFLAG_RSS_FILE		(1UL <<  9) /* Check file pages */
 # define PR_MEMFLAG_RSS_SHMEM		(1UL << 10) /* Check shmem pages */
 # define PR_MEMFLAG_RSS			(PR_MEMFLAG_RSS_ANON |\
 					 PR_MEMFLAG_RSS_FILE |\
 					 PR_MEMFLAG_RSS_SHMEM)
-# define PR_MEMFLAG_MASK		(PR_MEMFLAG_SIGCONT | PR_MEMFLAG_RSS)
+# define PR_MEMFLAG_MASK		(PR_MEMFLAG_SIGCONT | PR_MEMFLAG_RSS |\
+					 PR_MEMFLAG_DIRECT)
 
 /* Action word masks */
 # define PR_MEMACT_MASK			0xff
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aa76bae7f408..6488f8a10d66 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2640,27 +2640,27 @@ get_rss_counter(struct mm_struct *mm, int mm_bit, u16 flags, int rss_bit)
  * Return true if an action has been taken or further check is not needed,
  * false otherwise.
  */
-static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action)
+static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action,
+					  u16 flags)
 {
-	unsigned long mem;
+	unsigned long mem = 0;
 	bool ret = false;
 	struct mm_struct *mm = get_task_mm(current);
 	u8  signal = READ_ONCE(current->memcg_over_high_signal);
-	u16 flags  = READ_ONCE(current->memcg_over_high_flags);
-	u32 limit  = READ_ONCE(current->memcg_over_high_climit);
+	u32 limit;
 
 	if (!mm)
 		return true;	/* No more check is needed */
 
-	if (READ_ONCE(current->memcg_over_limit))
-		WRITE_ONCE(current->memcg_over_limit, false);
-
 	if ((action == PR_MEMACT_SIGNAL) && !signal)
 		goto out;
 
-	mem = page_counter_read(&memcg->memory);
-	if (mem <= memcg->memory.high + limit)
-		goto out;
+	if (memcg) {
+		mem = page_counter_read(&memcg->memory);
+		limit = READ_ONCE(current->memcg_over_high_climit);
+		if (mem <= memcg->memory.high + limit)
+			goto out;
+	}
 
 	/*
 	 * Check RSS memory if any of the PR_MEMFLAG_RSS flags is set.
@@ -2706,20 +2706,34 @@ static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action)
 
 out:
 	mmput(mm);
-	return ret;
+	/*
+	 * We only need to do direct per-task memory limit checking once.
+	 */
+	return memcg ? ret : true;
 }
 
 /*
  * Return true if an action has been taken or further check is not needed,
  * false otherwise.
  */
-static inline bool mem_cgroup_over_high_action(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_over_high_action(struct mem_cgroup *memcg,
+					       bool mem_high)
 {
 	u8 action = READ_ONCE(current->memcg_over_high_action);
+	u16 flags = READ_ONCE(current->memcg_over_high_flags);
 
 	if (!action)
 		return true;	/* No more check is needed */
-	return __mem_cgroup_over_high_action(memcg, action);
+
+	if (READ_ONCE(current->memcg_over_limit))
+		WRITE_ONCE(current->memcg_over_limit, false);
+
+	if (flags & PR_MEMFLAG_DIRECT)
+		memcg = NULL;	/* Direct per-task memory limit checking */
+	else if (!mem_high)
+		return false;
+
+	return __mem_cgroup_over_high_action(memcg, action, flags);
 }
 
 /*
@@ -2907,8 +2921,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 
-		if (mem_high && !taken)
-			taken = mem_cgroup_over_high_action(memcg);
+		if (!taken)
+			taken = mem_cgroup_over_high_action(memcg, mem_high);
 
 		/* Don't bother a random interrupted task */
 		if (in_interrupt()) {
@@ -7103,6 +7117,14 @@ long mem_cgroup_over_high_set(struct task_struct *task, unsigned long action,
 	    (sig >= _NSIG))
 		return -EINVAL;
 
+	/*
+	 * PR_MEMFLAG_DIRECT can only be set if any of the PR_MEMFLAG_RSS flag
+	 * is set and limit2 is non-zero.
+	 */
+	if ((flags & PR_MEMFLAG_DIRECT) &&
+	    (!(flags & PR_MEMFLAG_RSS) || !limit2))
+		return -EINVAL;
+
 	WRITE_ONCE(task->memcg_over_high_action, cmd);
 	WRITE_ONCE(task->memcg_over_high_signal, sig);
 	WRITE_ONCE(task->memcg_over_high_flags, flags);
-- 
2.18.1

