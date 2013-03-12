From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/8] cgroup: don't bother to resize pid array
Date: Tue, 12 Mar 2013 14:50:47 +0800
Message-ID: <513ED047.9060507@huawei.com>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513ED010.5060906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

When we open cgroup.procs, we'll allocate an buffer and store all tasks'
tgid in it, and then duplicate entries will be stripped. If that results
in a much smaller pid list, we'll re-allocate a smaller buffer.

But we've already sucessfully allocated memory and reading the procs
file is a short period and the memory will be freed very soon, so why
bother to re-allocate memory.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index be524ac..58ae040 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3400,35 +3400,14 @@ static void pidlist_free(void *p)
 	else
 		kfree(p);
 }
-static void *pidlist_resize(void *p, int newcount)
-{
-	void *newlist;
-	/* note: if new alloc fails, old p will still be valid either way */
-	if (is_vmalloc_addr(p)) {
-		newlist = vmalloc(newcount * sizeof(pid_t));
-		if (!newlist)
-			return NULL;
-		memcpy(newlist, p, newcount * sizeof(pid_t));
-		vfree(p);
-	} else {
-		newlist = krealloc(p, newcount * sizeof(pid_t), GFP_KERNEL);
-	}
-	return newlist;
-}
 
 /*
  * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
- * If the new stripped list is sufficiently smaller and there's enough memory
- * to allocate a new buffer, will let go of the unneeded memory. Returns the
- * number of unique elements.
+ * Returns the number of unique elements.
  */
-/* is the size difference enough that we should re-allocate the array? */
-#define PIDLIST_REALLOC_DIFFERENCE(old, new) ((old) - PAGE_SIZE >= (new))
-static int pidlist_uniq(pid_t **p, int length)
+static int pidlist_uniq(pid_t *list, int length)
 {
 	int src, dest = 1;
-	pid_t *list = *p;
-	pid_t *newlist;
 
 	/*
 	 * we presume the 0th element is unique, so i starts at 1. trivial
@@ -3449,16 +3428,6 @@ static int pidlist_uniq(pid_t **p, int length)
 		dest++;
 	}
 after:
-	/*
-	 * if the length difference is large enough, we want to allocate a
-	 * smaller buffer to save memory. if this fails due to out of memory,
-	 * we'll just stay with what we've got.
-	 */
-	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
-		newlist = pidlist_resize(list, dest);
-		if (newlist)
-			*p = newlist;
-	}
 	return dest;
 }
 
@@ -3554,7 +3523,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	/* now sort & (if procs) strip out duplicates */
 	sort(array, length, sizeof(pid_t), cmppid, NULL);
 	if (type == CGROUP_FILE_PROCS)
-		length = pidlist_uniq(&array, length);
+		length = pidlist_uniq(array, length);
 	l = cgroup_pidlist_find(cgrp, type);
 	if (!l) {
 		pidlist_free(array);
-- 
1.8.0.2
