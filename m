From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] mem_cgroup: optimize the atomic count of wb_completion
Date: Fri, 24 Sep 2021 14:46:22 +0800
Message-ID: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=H3OrsFf3LDF8kSA9N72sHEwF/fijXJFJCQiPZi5ceNI=;
        b=G5C/0K7kIPn/uiaKVOaxliCn+ouk/2e/osVmj23SnCpR85VvwHouKbfuHaBSy+boIb
         NrLyylleC0PA3Lue5lGpx20aF/ecY5JzRgsujH9BvrKqT4te1OHXzpPJZ9i3onCiy4CL
         P3v/TRdjiy3NOnOGjTVCdu41amLOzx6RPNRP+8ZtPsgZ+TNPy6XL3YQc5n6mDBAIWbQX
         Q2+K4iqYoXamQjcW2JSVR9CscB+QuxHR2BheEYgKHm8ImCecNHgWDH9uYNaPwbbDpkMI
         V1BRTrN/Vy08LtJ58RWLyMgw9w3gXQymyllFJ9ffvuIof7yQjH2eKxZ+6a8rwo/kXmR/
         xpnw==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In order to track inflight foreign writeback, we init
wb_completion.cnt to 1. For normal writeback, this cause
wb_wait_for_completion() to perform meaningless atomic
operations. Since foreign writebacks rarely occur in most
scenarios, we can init wb_completion.cnt to 0 and set
frn.done.cnt to 1. In this way we can avoid unnecessary
atomic operations.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 fs/fs-writeback.c                | 1 -
 include/linux/backing-dev-defs.h | 2 +-
 mm/memcontrol.c                  | 7 ++++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 81ec192..1ef10f2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -186,7 +186,6 @@ static void wb_queue_work(struct bdi_writeback *wb,
  */
 void wb_wait_for_completion(struct wb_completion *done)
 {
-	atomic_dec(&done->cnt);		/* put down the initial count */
 	wait_event(*done->waitq, !atomic_read(&done->cnt));
 }
 
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 3320700..38bd571 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -71,7 +71,7 @@ struct wb_completion {
 };
 
 #define __WB_COMPLETION_INIT(_waitq)	\
-	(struct wb_completion){ .cnt = ATOMIC_INIT(1), .waitq = (_waitq) }
+	(struct wb_completion){ .cnt = ATOMIC_INIT(0), .waitq = (_waitq) }
 
 /*
  * If one wants to wait for one or more wb_writeback_works, each work's
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b762215..3e1384a6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5168,9 +5168,10 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 #endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		memcg->cgwb_frn[i].done =
-			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		atomic_set(&memcg->cgwb_frn[i].done.cnt, 1);
+		memcg->cgwb_frn[i].done.waitq = &memcg_cgwb_frn_waitq;
+	}
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
-- 
1.8.3.1

