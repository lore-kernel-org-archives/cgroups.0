From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] cgroup: factor out kill_css()
Date: Thu,  8 Aug 2013 16:13:49 -0400
Message-ID: <1375992831-4650-13-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9mYXyorwmEiC86h3mEld9udkjfX31swf/CDpGsX3pdw=;
        b=jT1w669UHrLL1iIMyS/AUd19MSDLV3VTHI8Q0eA2hVByHaC7XVIxpSoWw02E6T5CzZ
         UIcHKAckMzXDHM49/a56a0NA1DCf5WAQzVkFReUXZk4lzd2StXVRJTjg8ht5CNCZ7RQ/
         pkALG86Sti+Dx+Uxwtf+437b+73BkLlHW6kdUF7O0zQdpdlCK+S4Lk5NtuhwbQHs74xZ
         XVtXtlGudDJeiOkUn6D+tYuu5NZiLxE9oBt2TZQIoGmItMr354QiDmCBzuaRS9g2sxPx
         xzT8/DBAws+1ckuo6O0eKGWh2C9xPteLSSg2t+xB76LvbSIsqT+5gO3kYydDUDvR5iRm
         g3Xw==
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Factor out css ref killing from cgroup_destroy_locked() into
kill_css().  We're gonna add more to the path and the factored out
function will eventually be called from other places too.

While at it, replace open coded percpu_ref_get() with css_get() for
consistency.  This shouldn't cause any functional difference as the
function is not used for root cgroups.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 58 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da2c8e3..da5f5c2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4592,6 +4592,36 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 }
 
 /**
+ * kill_css - destroy a css
+ * @css: css to destroy
+ *
+ * This function initiates destruction of @css by putting its base
+ * reference.  ->css_offline() will be invoked asynchronously once
+ * css_tryget() is guaranteed to fail and when the reference count reaches
+ * zero, @css will be released.
+ */
+static void kill_css(struct cgroup_subsys_state *css)
+{
+	/*
+	 * Killing would put the base ref, but we need to keep it alive
+	 * until after ->css_offline().
+	 */
+	css_get(css);
+
+	/*
+	 * cgroup core guarantees that, by the time ->css_offline() is
+	 * invoked, no new css reference will be given out via
+	 * css_tryget().  We can't simply call percpu_ref_kill() and
+	 * proceed to offlining css's because percpu_ref_kill() doesn't
+	 * guarantee that the ref is seen as killed on all CPUs on return.
+	 *
+	 * Use percpu_ref_kill_and_confirm() to get notifications as each
+	 * css is confirmed to be seen as killed on all CPUs.
+	 */
+	percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
+}
+
+/**
  * cgroup_destroy_locked - the first stage of cgroup destruction
  * @cgrp: cgroup to be destroyed
  *
@@ -4637,30 +4667,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		return -EBUSY;
 
 	/*
-	 * Block new css_tryget() by killing css refcnts.  cgroup core
-	 * guarantees that, by the time ->css_offline() is invoked, no new
-	 * css reference will be given out via css_tryget().  We can't
-	 * simply call percpu_ref_kill() and proceed to offlining css's
-	 * because percpu_ref_kill() doesn't guarantee that the ref is seen
-	 * as killed on all CPUs on return.
-	 *
-	 * Use percpu_ref_kill_and_confirm() to get notifications as each
-	 * css is confirmed to be seen as killed on all CPUs.
-	 * cgroup_destroy_css_killed() will be invoked to perform the rest
-	 * of destruction once the percpu refs of all css's are confirmed
-	 * to be killed.
+	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
+	 * will be invoked to perform the rest of destruction once the
+	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
-
-		/*
-		 * Killing would put the base ref, but we need to keep it
-		 * alive until after ->css_offline.
-		 */
-		percpu_ref_get(&css->refcnt);
-
-		percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
-	}
+	for_each_root_subsys(cgrp->root, ss)
+		kill_css(cgroup_css(cgrp, ss->subsys_id));
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-- 
1.8.3.1
