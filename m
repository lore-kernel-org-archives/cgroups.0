From: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] vmpressure: wake up work only when there is registration event
Date: Tue, 14 Sep 2021 09:05:51 -0700
Message-ID: <1631635551-8583-1-git-send-email-wang.yong12@zte.com.cn>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=s5oUww/KW0dwIowi5W2rJXOaMiXlxCDKY0oBpmzbqzw=;
        b=XNrj+vkp8TdMcL+diFidKiPuX7g/Eoa/0pzMB+yNwjiIwQAr4bkGqspPavHrz7GpRQ
         MziRNMfi0znxPuVdVPxwvv9+v7wo6qHOzG3ogD7u9i/MbRmA7Dj0JVLZ5hUDStlDwrHq
         5brNW89diOHl547VwRfBWjP/70q9IiyepW0X2BomJCAKbF1rzhe89iBPKRUfMekhg55G
         tcw6QgPWuPgC0TieK1r2ltDQrDKxxh5jTFDqKF++7iuTvtWutLm2uhmm892RGj0113Rp
         5/RqeZkRQvRokQqqt0YbvIsIbaJRxVfd1ife8WllzJf+Xm8mtTVuSZs/4t6Aq1OEMYMd
         Lf/g==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Use the global variable num_events to record the number of vmpressure
events registered by the system, and wake up work only when there is
registration event.
Usually, the vmpressure event is not registered in the system, this patch
can avoid waking up work and doing nothing.

Test with 5.14.0-rc5-next-20210813 on x86_64 4G ram.
Consume cgroup memory until it is about to be reclaimed, then execute
"perf stat -I 2000 malloc.out" command to trigger memory reclamation
and get performance results.
The context-switches is reduced by about 20 times.

unpatched:
Average of 10 test results
582.4674048	task-clock(msec)
19910.8		context-switches
0		cpu-migrations
1292.9		page-faults
414784733.1	cycles
<not supported>	stalled-cycles-frontend
<not supported>	stalled-cycles-backend
580070698.4	instructions
125572244.7	branches
2073541.2	branch-misses

patched
Average of 10 test results
973.6174796	task-clock(msec)
988.6		context-switches
0		cpu-migrations
1785.2		page-faults
772883602.4	cycles
<not supported>	stalled-cycles-frontend
<not supported>	stalled-cycles-backend
1360280911	instructions
290519434.9	branches
3378378.2	branch-misses

Tested-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---

Changes since v1:
-Use static_key type data as global variable
-Make event registration judgment earlier

 mm/vmpressure.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 76518e4..6f4e984 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -67,6 +67,11 @@ static const unsigned int vmpressure_level_critical = 95;
  */
 static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
 
+/*
+ * Count the number of vmpressure events registered in the system.
+ */
+DEFINE_STATIC_KEY_FALSE(num_events);
+
 static struct vmpressure *work_to_vmpressure(struct work_struct *work)
 {
 	return container_of(work, struct vmpressure, work);
@@ -272,6 +277,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	if (tree) {
+		if (!static_branch_unlikely(&num_events))
+			return;
+
 		spin_lock(&vmpr->sr_lock);
 		scanned = vmpr->tree_scanned += scanned;
 		vmpr->tree_reclaimed += reclaimed;
@@ -407,6 +415,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 	mutex_lock(&vmpr->events_lock);
 	list_add(&ev->node, &vmpr->events);
 	mutex_unlock(&vmpr->events_lock);
+	static_branch_inc(&num_events);
 	ret = 0;
 out:
 	kfree(spec_orig);
@@ -435,6 +444,7 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
 		if (ev->efd != eventfd)
 			continue;
 		list_del(&ev->node);
+		static_branch_dec(&num_events);
 		kfree(ev);
 		break;
 	}
-- 
2.7.4

