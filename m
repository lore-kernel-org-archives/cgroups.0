From: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3] vmpressure: wake up work only when there is registration event
Date: Fri, 24 Sep 2021 06:44:25 -0700
Message-ID: <1632491065-10785-1-git-send-email-wang.yong12@zte.com.cn>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=C1qOcUv37x/aaV73V8Kv4uQFgD37HZdVWZKX5cd1Pnk=;
        b=nfd9Owc88HKGgehebXgCJr67ojOZM1yqCQzTr98bMufXc/0LgwVS7BnbHzNNhEJpBt
         3qbdd5XKWGxa4nYrhDO+Z/uHKASWxlzW8I0r6jitV/he2yVkhwwGEgb21kbP93X/PrTc
         PTsSb62GSsi4elOHlMxnSnSLmSVWgi9WEu59a2L79Bf9SZXlxgu3ACMfFL5KSXpux915
         XaDGo484m6SXrBYzy5YJ9kAnSk2gKuI1/QMjC+A5bpooa9Ro3oRB12RRNGzTK7xTZLc1
         pmxhmGWd07S/CXMnG3bjoTyzR8c2UGLwYhPB8h8xX+ejtFUUmJwfC+WTUd4hVow0CprV
         gYzQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Use the global variable num_events to record the number of vmpressure
events registered by the system, and wake up work only when there
is registration event.
Usually, the vmpressure event is not registered in the system, this patch
can avoid waking up work and doing nothing.

Test with 5.14.0-rc5-next-20210813 on x86_64 4G ram.
Consume cgroup memory until it is about to be reclaimed, then execute
"perf stat -I 2000 malloc.out" command to trigger memory reclamation
and get performance results.
The context-switches is reduced by about 20 times.

unpatched:
Average of 10 test results
582.4674048     task-clock(msec)
19910.8         context-switches
0               cpu-migrations
1292.9          page-faults
414784733.1     cycles
580070698.4     instructions
125572244.7     branches
2073541.2       branch-misses

patched:
Average of 10 test results
973.6174796     task-clock(msec)
988.6           context-switches
0               cpu-migrations
1785.2          page-faults
772883602.4     cycles
1360280911      instructions
290519434.9     branches
3378378.2       branch-misses

Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---

Changlogs in v3:
  -Use static inline helper to know whether there
   is registration event.
  -Add necessary description.
  -The location of the helper is based on that the else
   branch will modify the socket_pressure and will not
   wake up the work, and it is necessary to judge the tree
   parameters at the same time.

Changlogs in v2:
  -Use static_key type data as global variable.
  -Make event registration judgment earlier.

 mm/vmpressure.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 76518e4..1f53ced 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -67,6 +67,16 @@ static const unsigned int vmpressure_level_critical = 95;
  */
 static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
 
+/*
+ * Count the number of vmpressure events registered in the system.
+ */
+DEFINE_STATIC_KEY_FALSE(num_events);
+
+static __always_inline bool vmpressure_unregistered(void)
+{
+	return !static_branch_unlikely(&num_events);
+}
+
 static struct vmpressure *work_to_vmpressure(struct work_struct *work)
 {
 	return container_of(work, struct vmpressure, work);
@@ -272,6 +282,12 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	if (tree) {
+		/* If there is no registered event, return directly.
+		 * We wake up work only when there is registration event.
+		 */
+		if (vmpressure_unregistered())
+			return;
+
 		spin_lock(&vmpr->sr_lock);
 		scanned = vmpr->tree_scanned += scanned;
 		vmpr->tree_reclaimed += reclaimed;
@@ -407,6 +423,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 	mutex_lock(&vmpr->events_lock);
 	list_add(&ev->node, &vmpr->events);
 	mutex_unlock(&vmpr->events_lock);
+	static_branch_inc(&num_events);
 	ret = 0;
 out:
 	kfree(spec_orig);
@@ -435,6 +452,7 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
 		if (ev->efd != eventfd)
 			continue;
 		list_del(&ev->node);
+		static_branch_dec(&num_events);
 		kfree(ev);
 		break;
 	}
-- 
2.7.4

