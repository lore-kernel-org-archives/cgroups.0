From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: remove cgroup_pid_fry() and friends
Date: Tue, 20 Dec 2016 11:12:22 -0500
Message-ID: <20161220161222.15234-6-tj@kernel.org>
References: <20161220161222.15234-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=szNe+HG+luiLOKk+nxjLHYVgWB49t4byPKy8wiQanZI=;
        b=ZmX2fGzdvMV2Js35iYl1EJsILXaPfEWPc5TO73QX2OZkvSO7F9nr406v04/hsaJ7B7
         CTKtQV0M9nQSrMMtVRkw+jgGMvHj/9tTMSV0XMeoeKafMDWoQNXU/muXNoheTH+nSVLd
         W2drXnY1XUZEkS5WzLkMF5mWW014V61zRGLArY07cJJnxKY+xB0LiXHIaQutM076PK4p
         FSkPwHbfkeRW0fz0Qyx91XWz/jnUyMchaxDsez3ZlL3GdMeUYODhKJ8dtTBvnHLqT5Wa
         F7VmIY32MIr33Qu+3a80VO8pQSPuI17ZIfyRMBmPUu8HJsFtPtDpDBSM68jVu1ZYRhGX
         EFyg==
In-Reply-To: <20161220161222.15234-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_pid_fry() was added to mangle cgroup.procs pid listing order on
v2 to make it clear that the output is not sorted.  Now that v2 now
uses a separate "cgroup.procs" read method, this is no longer used.
Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fd684bfd..b9e2d85 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4618,42 +4618,12 @@ static int pidlist_uniq(pid_t *list, int length)
  * sorted by task pointer.  As pidlists can be fairly large, allocating one
  * per open file is dangerous, so cgroup had to implement shared pool of
  * pidlists keyed by cgroup and namespace.
- *
- * All this extra complexity was caused by the original implementation
- * committing to an entirely unnecessary property.  In the long term, we
- * want to do away with it.  Explicitly scramble sort order if on the
- * default hierarchy so that no such expectation exists in the new
- * interface.
- *
- * Scrambling is done by swapping every two consecutive bits, which is
- * non-identity one-to-one mapping which disturbs sort order sufficiently.
  */
-static pid_t pid_fry(pid_t pid)
-{
-	unsigned a = pid & 0x55555555;
-	unsigned b = pid & 0xAAAAAAAA;
-
-	return (a << 1) | (b >> 1);
-}
-
-static pid_t cgroup_pid_fry(struct cgroup *cgrp, pid_t pid)
-{
-	if (cgroup_on_dfl(cgrp))
-		return pid_fry(pid);
-	else
-		return pid;
-}
-
 static int cmppid(const void *a, const void *b)
 {
 	return *(pid_t *)a - *(pid_t *)b;
 }
 
-static int fried_cmppid(const void *a, const void *b)
-{
-	return pid_fry(*(pid_t *)a) - pid_fry(*(pid_t *)b);
-}
-
 static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 						  enum cgroup_filetype type)
 {
@@ -4741,10 +4711,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	css_task_iter_end(&it);
 	length = n;
 	/* now sort & (if procs) strip out duplicates */
-	if (cgroup_on_dfl(cgrp))
-		sort(array, length, sizeof(pid_t), fried_cmppid, NULL);
-	else
-		sort(array, length, sizeof(pid_t), cmppid, NULL);
+	sort(array, length, sizeof(pid_t), cmppid, NULL);
 	if (type == CGROUP_FILE_PROCS)
 		length = pidlist_uniq(array, length);
 
@@ -4876,10 +4843,10 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 
 		while (index < end) {
 			int mid = (index + end) / 2;
-			if (cgroup_pid_fry(cgrp, l->list[mid]) == pid) {
+			if (l->list[mid] == pid) {
 				index = mid;
 				break;
-			} else if (cgroup_pid_fry(cgrp, l->list[mid]) <= pid)
+			} else if (l->list[mid] <= pid)
 				index = mid + 1;
 			else
 				end = mid;
@@ -4890,7 +4857,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
 	iter = l->list + index;
-	*pos = cgroup_pid_fry(cgrp, *iter);
+	*pos = *iter;
 	return iter;
 }
 
@@ -4919,7 +4886,7 @@ static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 	if (p >= end) {
 		return NULL;
 	} else {
-		*pos = cgroup_pid_fry(seq_css(s)->cgroup, *p);
+		*pos = *p;
 		return p;
 	}
 }
-- 
2.9.3

