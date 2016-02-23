From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] cgroup: factor out cgroup_drain_offline() from cgroup_subtree_control_write()
Date: Mon, 22 Feb 2016 22:45:40 -0500
Message-ID: <1456199146-14765-7-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vB1IFRQxqziUEKVjThPyzdGi23+urRyDbc7SKBmKEXc=;
        b=CjMh26h9bTYBqeevmaS2nVnYbR/maaAMBw9ABS0umfufXhzH1To7P3NQ7GW3l0jLrv
         bfHBkEc7Z+zaWwNFaWVcssADfmZ5c0zY7gkwGDHpPkmKknU0M8K+lkTGmC3UJrkRvfKx
         uC4sYgEjS1Q13AN9seEmrqPEz6OQdr+IXnpbjiNp+mhj4F30AXkGMWRgmGA3hZfdYhw0
         S1o+kNZQBn+8ROATvcJ9NckFbzRDtiYG83DqEm2DgUs+UH2u2RwS+RThkqONtSzMyOSb
         +z+xXmyHk94hKo4WSTYhXu84dwiGiuISCU9Rb5+JHNPCZ8MslDz9+3CD6kNLWBig8kG1
         htaA==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Factor out async css offline draining into cgroup_drain_offline().

* Nest subsystem walk inside child walk.  The child walk will later be
  converted to subtree walk which is a bit more expensive.

* Relocate the draining above subsystem mask preparation, which
  doesn't create any behavior differences but helps further
  refactoring.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 77 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0282797..7966750 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2960,6 +2960,53 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	return ret;
 }
 
+/**
+ * cgroup_drain_offline - wait for previously offlined csses to go away
+ * @cgrp: parent of the target cgroups
+ *
+ * Because css offlining is asynchronous, userland may try to re-enable a
+ * controller while the previous css is still around.  This function drains
+ * the previous css instances of @cgrp's children.
+ *
+ * Must be called with cgroup_mutex held.  Returns %false if there were no
+ * dying css instances.  Returns %true if there were one or more and this
+ * function waited.  On %true return, cgroup_mutex has been dropped and
+ * re-acquired inbetween which anything could have happened.  The caller
+ * typically would have to start over.
+ */
+static bool cgroup_drain_offline(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	cgroup_for_each_live_child(dsct, cgrp) {
+		for_each_subsys(ss, ssid) {
+			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
+			DEFINE_WAIT(wait);
+
+			if (!css)
+				continue;
+
+			cgroup_get(dsct);
+			prepare_to_wait(&dsct->offline_waitq, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+			mutex_unlock(&cgroup_mutex);
+			schedule();
+			finish_wait(&dsct->offline_waitq, &wait);
+			mutex_lock(&cgroup_mutex);
+
+			cgroup_put(dsct);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /* change the enabled child controllers for a cgroup in the default hierarchy */
 static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
@@ -3048,6 +3095,11 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
+	if (cgroup_drain_offline(cgrp)) {
+		cgroup_kn_unlock(of->kn);
+		return restart_syscall();
+	}
+
 	/*
 	 * Update subsys masks and calculate what needs to be done.  More
 	 * subsystems than specified may need to be enabled or disabled
@@ -3063,31 +3115,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	enable |= css_enable;
 	disable |= css_disable;
 
-	/*
-	 * Because css offlining is asynchronous, userland might try to
-	 * re-enable the same controller while the previous instance is
-	 * still around.  In such cases, wait till it's gone using
-	 * offline_waitq.
-	 */
-	do_each_subsys_mask(ss, ssid, css_enable) {
-		cgroup_for_each_live_child(child, cgrp) {
-			DEFINE_WAIT(wait);
-
-			if (!cgroup_css(child, ss))
-				continue;
-
-			cgroup_get(child);
-			prepare_to_wait(&child->offline_waitq, &wait,
-					TASK_UNINTERRUPTIBLE);
-			cgroup_kn_unlock(of->kn);
-			schedule();
-			finish_wait(&child->offline_waitq, &wait);
-			cgroup_put(child);
-
-			return restart_syscall();
-		}
-	} while_each_subsys_mask();
-
 	cgrp->subtree_control = new_sc;
 	cgrp->subtree_ss_mask = new_ss;
 
-- 
2.5.0

