From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH RFC] mm/memcg: recalculate chargeable space after waiting migrating charges
Date: Thu, 12 Jul 2012 18:39:21 +0800
Message-ID: <1342089561-11211-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=FnCmPck8jlLrpAajTU1lJgnd8W5BzVqmP4nMJ+7ijJs=;
        b=NI46HFcjZvXWTbRhMmBujAGguRtbu5T7JVWQfM/mZqtZ2cz9I5epOUY6DYVjLFfEtf
         4SVY2FM5UCB/5dvTvacikTL4G7oGVGBBaP8PIbUsnU8Cu4EU4JQvo5ZwXBWgHWi0Jn1f
         A6CwNAHvppQr043xM7GQ79HtdWIA2lu+5568zLJQ64ElqwOGD0IyzpDJsPD4zLLzsKq0
         OmU+g/LNxCi6W1MB5Jzh1/fGkXdiWD4jJfXAsrPzNX4M03kq0Bko//G0PLJOc385jC6d
         f67JiS+zaktxQusVnkko2jDoe9Z+qA24j3qj4rpEXF2DdvES1PgS5Drm83EL+vGRc6Sn
         +wvA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Function mem_cgroup_do_charge will call mem_cgroup_reclaim,
there are two break points in mem_cgroup_reclaim:
if (total && (flag & MEM_CGROUP_RECLAIM_SHIRINK))
	break;
if (mem_cgroup_margin(memcg))
	break;
so mem_cgroup_reclaim can't guarantee reclaim enough pages(nr_pages) 
which is requested from mem_cgroup_do_charge, if mem_cgroup_margin
(mem_over_limit) >= nr_pages is not true, the process will go to
mem_cgroup_wait_acct_move to wait doubly charge counted caused by
task move. But this time still can't guarantee enough pages(nr_pages) is
ready, directly return CHARGE_RETRY is incorret. We should add a check
to confirm enough pages is ready, otherwise go to oom.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..4ae3848 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2210,7 +2210,8 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * At task move, charge accounts can be doubly counted. So, it's
 	 * better to wait until the end of task_move if something is going on.
 	 */
-	if (mem_cgroup_wait_acct_move(mem_over_limit))
+	if (mem_cgroup_wait_acct_move(mem_over_limit)
+			&& mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
 
 	/* If we don't need to call oom-killer at el, return immediately */
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
