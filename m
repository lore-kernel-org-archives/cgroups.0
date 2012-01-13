From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC] [PATCH 1/7 v2] memcg: remove unnecessary check in
 mem_cgroup_update_page_stat()
Date: Fri, 13 Jan 2012 17:32:27 +0900
Message-ID: <20120113173227.df2baae3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Ying Han <yinghan@google.com>, "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, "bsingharora@gmail.com" <bsingharora@gmail.com>


From 788aebf15f3fa37940e0745cab72547e20683bf2 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 Jan 2012 16:08:33 +0900
Subject: [PATCH 1/7] memcg: remove unnecessary check in mem_cgroup_update_page_stat()

commit 10ea69f1182b removes move_lock_page_cgroup() in thp-split path.
So, this PageTransHuge() check is unnecessary, too.

Note:
 - considering when mem_cgroup_update_page_stat() is called,
   there will be no race between split_huge_page() and update_page_stat().
   All required locks are held in higher level.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 21ba356..08b988d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1866,7 +1866,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg)) || PageTransHuge(page)) {
+	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
 		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
-- 
1.7.4.1


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
