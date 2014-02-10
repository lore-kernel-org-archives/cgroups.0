From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] cgroup: separate out cset_group_from_root() from
	task_cgroup_from_root()
Date: Mon, 10 Feb 2014 15:21:32 -0500
Message-ID: <1392063694-26465-4-git-send-email-tj@kernel.org>
References: <1392063694-26465-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=7XZGQYjuRNaDFr6z3I8vFFmDuSi63eM7cy10QkRZvpI=;
	b=1DLbXuioGKFDUPERFnmWCNPdqMYoBd3YPw0Ih5jw3lpCLC+37V4VhZsQ9leqao3MGz
	1jj+I4HDBvXfy0pb8C/4IvTz1x2zaun2ZXTg/Y+4Wv960ODEChaEsf++aTuJP2187U7C
	UC1tTGjUz3PyYlXMQxMwRJZCuboxJASjpt1668RH2l5a6vHVEHVStTaHh/O3u9fyQaQb
	4DZDL1vZAr+NKAvjFmdi1dR4KvF+B2dE/s8Mj3iGxMVHXEwfhvyWRGR+6j9cr1muL0AJ
	zB144KsyvxGSWZLfXo9UWDKDZ4S1W7ILhPnBj9BCV3uXcDbH7LuW/6ts7cvkd+3BNo9C
	kHNw==
In-Reply-To: <1392063694-26465-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This will be used by the planned migration path update.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6727171..9201160 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -758,25 +758,15 @@ static void cgroup_destroy_root(struct cgroupfs_root *root)
 	cgroup_free_root(root);
 }
 
-/*
- * Return the cgroup for "task" from the given hierarchy. Must be
- * called with cgroup_mutex and css_set_rwsem held.
- */
-static struct cgroup *task_cgroup_from_root(struct task_struct *task,
+/* look up cgroup associated with given css_set on the specified hierarchy */
+static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroupfs_root *root)
 {
-	struct css_set *cset;
 	struct cgroup *res = NULL;
 
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_rwsem);
 
-	/*
-	 * No need to lock the task - since we hold cgroup_mutex the
-	 * task can't change groups, so the only thing that can happen
-	 * is that it exits and its css is set back to init_css_set.
-	 */
-	cset = task_css_set(task);
 	if (cset == &init_css_set) {
 		res = &root->top_cgroup;
 	} else {
@@ -797,6 +787,21 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 }
 
 /*
+ * Return the cgroup for "task" from the given hierarchy. Must be
+ * called with cgroup_mutex and css_set_rwsem held.
+ */
+static struct cgroup *task_cgroup_from_root(struct task_struct *task,
+					    struct cgroupfs_root *root)
+{
+	/*
+	 * No need to lock the task - since we hold cgroup_mutex the
+	 * task can't change groups, so the only thing that can happen
+	 * is that it exits and its css is set back to init_css_set.
+	 */
+	return cset_cgroup_from_root(task_css_set(task), root);
+}
+
+/*
  * There is one global cgroup mutex. We also require taking
  * task_lock() when dereferencing a task's cgroup subsys pointers.
  * See "The task_lock() exception", at the end of this comment.
-- 
1.8.5.3
