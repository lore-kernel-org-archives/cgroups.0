From: Ivan Safonov <insafonov@gmail.com>
Subject: [PATCH] cgroup: use kv(malloc|free) instead of pidlist_(allocate|free)
Date: Sun,  8 Sep 2019 17:40:41 +0300
Message-ID: <20190908144041.19667-1-insafonov@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FmmHtAJUP2a/sLNIvsEgkXzhFS+gIz57sAKIuY6RAn8=;
        b=lBDsvcqqCALrs7Asc/HmKgFWFmwGNUKXuO1TAhKJ5Csl+ugUwRosyWCH334U7DF+ZF
         dcoLrwnMGGWEpFSOiyHsNBBRLoSjg97E2KnqWfDOV4ZIavS1O0CNzvZFJhRlUU6deFCS
         rMCFjQV/LyfaP0/59T1/0LlgAivaQpSrPCCk5LAJvkt7WHPFkVo6eS4szqHZNAQrGvxK
         LHXyEbIFlqq+lVSU6OZ6pJC8prWZ8mk0H+7gtoYydJpgt6dNrc+PdesE+N0mUu65ogSu
         vkkkXx3SIF2SWg+LALK7c/dINDV5wP70vX9NWMxYhgM9MdGv4vaJlLDWtFKjKYbWFxLp
         Q6jA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ivan Safonov <insafonov@gmail.com>

Resolve TODO:
> The following two functions "fix" the issue where there are more pids
> than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
> TODO: replace with a kernel-wide solution to this problem

kv(malloc|free) is appropriate replacement for pidlist_(allocate|free).

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
---
 kernel/cgroup/cgroup-v1.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 88006be40ea3..1f25f35af2c4 100644
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
+	array = kvmalloc(array_size(length, sizeof(pid_t)), GFP_KERNEL);
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
2.21.0

