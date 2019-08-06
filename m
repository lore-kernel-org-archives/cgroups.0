From: Marc Koderer <marc@koderer.com>
Subject: [PATCH] Use kvmalloc in cgroups-v1
Date: Tue,  6 Aug 2019 15:24:12 +0200
Message-ID: <20190806132412.92945-1-marc@koderer.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Marc Koderer <marc@koderer.com>

Instead of using its own logic for k-/vmalloc rely on
kvmalloc which is actually doing quite the same.

Signed-off-by: Marc Koderer <marc@koderer.com>
---
 kernel/cgroup/cgroup-v1.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 88006be40ea3..7f83f4121d8d 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -193,25 +193,6 @@ struct cgroup_pidlist {
 	struct delayed_work destroy_dwork;
 };
 
-/*
- * The following two functions "fix" the issue where there are more pids
- * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
- * TODO: replace with a kernel-wide solution to this problem
- */
-#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
-static void *pidlist_allocate(int count)
-{
-	if (PIDLIST_TOO_LARGE(count))
-		return vmalloc(array_size(count, sizeof(pid_t)));
-	else
-		return kmalloc_array(count, sizeof(pid_t), GFP_KERNEL);
-}
-
-static void pidlist_free(void *p)
-{
-	kvfree(p);
-}
-
 /*
  * Used to destroy all pidlists lingering waiting for destroy timer.  None
  * should be left afterwards.
@@ -244,7 +225,7 @@ static void cgroup_pidlist_destroy_work_fn(struct work_struct *work)
 	 */
 	if (!delayed_work_pending(dwork)) {
 		list_del(&l->links);
-		pidlist_free(l->list);
+		kvfree(l->list);
 		put_pid_ns(l->key.ns);
 		tofree = l;
 	}
@@ -365,7 +346,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	 * show up until sometime later on.
 	 */
 	length = cgroup_task_count(cgrp);
-	array = pidlist_allocate(length);
+	array = kvmalloc_array(length, sizeof(pid_t), GFP_KERNEL);
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
@@ -390,12 +371,12 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		pidlist_free(array);
+		kvfree(array);
 		return -ENOMEM;
 	}
 
 	/* store array, freeing old if necessary */
-	pidlist_free(l->list);
+	kvfree(l->list);
 	l->list = array;
 	l->length = length;
 	*lp = l;
-- 
2.22.0

