From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] cgroup: separate out cgroup_has_tasks()
Date: Sat, 10 Jun 2017 10:03:42 -0400
Message-ID: <20170610140351.10703-2-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DoTcx1AOvVHzNQiNd9HnQv3OzHT37WLBE+7npyJ8Wz0=;
        b=KhyyAT8ZoS1InuAwKrHH/ieuY+LZp4m3XKWH3SwXpnlmzKWZiU5touswshpSEJ7GSr
         mICPBLSW0r0Stklqieo2TE98rvu9GgHqWsOfYY2ff4WqvsEocOBuW6vz6C5+VCUrHpq4
         tC8vFK9SsVwrxsau9ItN7524wI5dZGmpNIp/r6t3pH0vtbBy77ZrcV6KHu+ctnWmoO2q
         umE169s6OB/YFxquMgecJWYRs8/vRRyJ7DhVdVmlnjZ0EMjkospNBo/Ld9uX9DUG9enO
         EE9mo3NaAAuxdtJYdgb1D+GQVf34ekMWF5IIr/5jp1AmTpgrs4kuibRKxdRwLHOXdOji
         oPhg==
In-Reply-To: <20170610140351.10703-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Tejun Heo <tj@kernel.org>

Separate out cgroup_has_tasks() test from
cgroup_subtree_control_write().  This will be used by the following
changes.

This patch doesn't cause any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 49 +++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8d4e85eae42c..dcd120af4084 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -581,6 +581,30 @@ static bool css_set_populated(struct css_set *cset)
 	return !list_empty(&cset->tasks) || !list_empty(&cset->mg_tasks);
 }
 
+static bool cgroup_has_tasks(struct cgroup *cgrp)
+{
+	struct cgrp_cset_link *link;
+	bool has_tasks = false;
+
+	/*
+	 * Because namespaces pin csets too, @cgrp->cset_links
+	 * might not be empty even when @cgrp is empty.  Walk and
+	 * verify each cset.
+	 */
+	spin_lock_irq(&css_set_lock);
+
+	list_for_each_entry(link, &cgrp->cset_links, cset_link) {
+		if (css_set_populated(link->cset)) {
+			has_tasks = true;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&css_set_lock);
+
+	return has_tasks;
+}
+
 /**
  * cgroup_update_populated - updated populated count of a cgroup
  * @cgrp: the target cgroup
@@ -2886,28 +2910,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * Except for the root, subtree_control must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
-	if (enable && cgroup_parent(cgrp)) {
-		struct cgrp_cset_link *link;
-
-		/*
-		 * Because namespaces pin csets too, @cgrp->cset_links
-		 * might not be empty even when @cgrp is empty.  Walk and
-		 * verify each cset.
-		 */
-		spin_lock_irq(&css_set_lock);
-
-		ret = 0;
-		list_for_each_entry(link, &cgrp->cset_links, cset_link) {
-			if (css_set_populated(link->cset)) {
-				ret = -EBUSY;
-				break;
-			}
-		}
-
-		spin_unlock_irq(&css_set_lock);
-
-		if (ret)
-			goto out_unlock;
+	if (enable && cgroup_parent(cgrp) && cgroup_has_tasks(cgrp)) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
 	/* save and update control masks and prepare csses */
-- 
2.13.0

