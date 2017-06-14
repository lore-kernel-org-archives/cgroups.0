From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process constraint
Date: Wed, 14 Jun 2017 11:05:32 -0400
Message-ID: <1497452737-11125-2-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 7F932C0587C8
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

The no internal process contraint is rather limiting. The fact that
threaded cgroups are exempt from this rule means that the restriction
is actually not needed in some cases.

Rather than having threaded cgroups as exceptions, the no internal
process contraint is now relaxed to apply only when those resource
domain controllers, which are not allowed in a threaded cgroup,
are enabled. That will cover the case of threaded cgroups without an
explicit exception. This also makes it easier for those controllers
that can handle internal process competition to migrate to cgroup v2.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 44 ++++++++++++++++++++++++++++----------------
 kernel/cgroup/cgroup.c      | 24 +++++++++++++-----------
 2 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 96db840..98f92b1 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -374,15 +374,27 @@ disabled if one or more children have it enabled.
 
 2-4-3. No Internal Process Constraint
 
-Non-root cgroups can only distribute resources to their children when
-they don't have any processes of their own.  In other words, only
-cgroups which don't contain any processes can have controllers enabled
-in their "cgroup.subtree_control" files.
-
-This guarantees that, when a controller is looking at the part of the
-hierarchy which has it enabled, processes are always only on the
-leaves.  This rules out situations where child cgroups compete against
-internal processes of the parent.
+When a non-root cgroup distributes resources to their children while
+having processes of its own, its internal processes will then compete
+against its children in term of resource allocation.  For some resource
+types, that is not a problem and the controllers are able to handle
+them correctly.  For others, the controllers may not be able to handle
+internal process competition correctly.  This type of controllers are
+called resource domain controllers in this document.
+
+Internal processes are not allowed on non-root cgroups which has
+any one of those resource domain controllers enabled.  Currently all
+controllers that are allowed in a threaded cgroup will be considered
+as a non-resource domain controller and hence will not block internal
+processes.  In other words, only cgroups which don't contain any
+processes can have resource domain controllers enabled in their
+"cgroup.subtree_control" files.
+
+This guarantees that, when a controller is looking at the part of
+the hierarchy which has it enabled, processes are always only on the
+leaves when resource domain controllers are enabled.  This rules out
+situations where child cgroups compete against internal processes of
+the parent for those controllers that can't handle it properly.
 
 The root cgroup is exempt from this restriction.  Root contains
 processes and anonymous resource consumption which can't be associated
@@ -390,13 +402,13 @@ with any other cgroups and requires special treatment from most
 controllers.  How resource consumption in the root cgroup is governed
 is up to each controller.
 
-Note that the restriction doesn't get in the way if there is no
-enabled controller in the cgroup's "cgroup.subtree_control".  This is
-important as otherwise it wouldn't be possible to create children of a
-populated cgroup.  To control resource distribution of a cgroup, the
-cgroup must create children and transfer all its processes to the
-children before enabling controllers in its "cgroup.subtree_control"
-file.
+Note that the restriction doesn't get in the way if there is no resource
+domain controller enabled in the cgroup's "cgroup.subtree_control".
+This is important as otherwise it wouldn't be possible to create
+children of a populated cgroup.  To control resource distribution
+of a cgroup, the cgroup must create children and transfer all
+its processes to the children before enabling controllers in its
+"cgroup.subtree_control" file.
 
 
 2-5. Delegation
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 216657e..f72dce1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2297,13 +2297,14 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
  * @dst_cgrp: destination cgroup to test
  *
  * On the default hierarchy, except for the mixable and threaded cgroups,
- * subtree_control must be zero for migration destination cgroups with
- * tasks so that child cgroups don't compete against tasks.
+ * subtree_control must not have any !threaded controllers for migration
+ * cgroups with tasks so that child cgroups don't compete against tasks
+ * for those !threaded controllers.
  */
 bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
 {
 	return !cgroup_on_dfl(dst_cgrp) || cgroup_is_mixable(dst_cgrp) ||
-		cgroup_is_threaded(dst_cgrp) || !dst_cgrp->subtree_control;
+		!(dst_cgrp->subtree_control & ~cgrp_dfl_threaded_ss_mask);
 }
 
 /**
@@ -3020,12 +3021,12 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	}
 
 	/*
-	 * Except for mixable and threaded cgroups, subtree_control must be
-	 * zero for a cgroup with tasks so that child cgroups don't compete
-	 * against tasks.
+	 * Except for mixable cgroups, subtree_control must not contain any
+	 * !threaded controller for a cgroup with tasks so that child cgroups
+	 * don't compete against tasks.
 	 */
-	if (enable && !cgroup_is_mixable(cgrp) && !cgroup_is_threaded(cgrp) &&
-	    cgroup_has_tasks(cgrp)) {
+	if ((enable & ~cgrp_dfl_threaded_ss_mask) &&
+	   !cgroup_is_mixable(cgrp) && cgroup_has_tasks(cgrp)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -3086,10 +3087,11 @@ static int cgroup_vet_thread_mode_op(struct cgroup *cgrp, enum thread_mode_op op
 
 	/*
 	 * @cgrp is starting or ending a normal threaded subtree.  Make
-	 * sure the subtree is empty and avoid needing implicit domain
-	 * controller migrations.
+	 * sure the subtree has no !threaded controller enabled and avoid
+	 * needing implicit domain controller migrations.
 	 */
-	if (css_has_online_children(&cgrp->self) || cgrp->subtree_control)
+	if (css_has_online_children(&cgrp->self) ||
+	   (cgrp->subtree_control & ~cgrp_dfl_threaded_ss_mask))
 		return -EBUSY;
 
 	/* no partial disable */
-- 
1.8.3.1

