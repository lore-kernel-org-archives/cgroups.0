From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] cgroup: make cgroup hold onto its kernfs_node
Date: Tue, 28 Jan 2014 18:59:42 -0500
Message-ID: <1390953585-16554-6-git-send-email-tj@kernel.org>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rwD9IIlZNeDaRuOY16Gc0f1vMT04q1wfuA7RaWwxz/U=;
        b=ad6Jm5uOiYcnRB4h3i2Gb3Krxo2zbe5j+9iq3NzItnz/HO9ogGu+VsIgsIkwrCR6t8
         s70KkX4MiAQSEzulKQtFpTqlUC00u03dRpP6tz8L6E+p4LCCV5NDgF7eLH3K2/ZxqlfX
         GAaURD8mAfbaP0Ex3yyQCi/dDVOKMHU4iBc5CPk8CRxrlqUWGD+G1YYDG8otg7Arbb9f
         3G4Zev+Tst1MYKZFsiAB4Mi/9Xz3SLggTC87Th/f84RVj6rEpEQmDghcG4urKc4clz2E
         cC9rSu9+3YMmTxKY/D286rrHVH0nxFdLedk+NV5TAPxqnPSgCPnTRcKhBJfDNqKy7SEx
         tklg==
In-Reply-To: <1390953585-16554-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup currently releases its kernfs_node when it gets removed.  While
not buggy, this makes cgroup->kn access rules complicated than
necessary and leads to things like get/put protection around
kernfs_remove() in cgroup_destroy_locked().  In addition, we want to
use kernfs_name/path() and friends but also want to be able to
determine a cgroup's name between removal and release.

This patch makes cgroup hold onto its kernfs_node until freed so that
cgroup->kn is always accessible.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d015c1..3e4df3c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -957,6 +957,8 @@ static void cgroup_free_fn(struct work_struct *work)
 
 	cgroup_pidlist_destroy_all(cgrp);
 
+	kernfs_put(cgrp->kn);
+
 	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
@@ -3768,6 +3770,12 @@ static long cgroup_create(struct cgroup *parent, const char *name_str,
 	}
 	cgrp->kn = kn;
 
+	/*
+	 * This extra ref will be put in cgroup_free_fn() and guarantees
+	 * that @cgrp->kn is always accessible.
+	 */
+	kernfs_get(kn);
+
 	cgrp->serial_nr = cgroup_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
@@ -3948,7 +3956,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 {
 	struct cgroup *child;
 	struct cgroup_subsys_state *css;
-	struct kernfs_node *kn;
 	bool empty;
 	int ssid;
 
@@ -4026,13 +4033,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * cgrp->kn->priv backpointer, which should be cleared after all
 	 * files under it have been removed.
 	 */
-	kn = cgrp->kn;
-	kernfs_get(kn);
-
-	kernfs_remove(cgrp->kn);
-
+	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
 	RCU_INIT_POINTER(cgrp->kn->priv, NULL);
-	kernfs_put(kn);
 
 	mutex_lock(&cgroup_mutex);
 
-- 
1.8.5.3
