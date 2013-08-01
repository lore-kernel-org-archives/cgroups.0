From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/23] cgroup: unexport cgroup_css()
Date: Thu,  1 Aug 2013 17:50:01 -0400
Message-ID: <1375393801-4817-24-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=sgQEUtJKXlekEZJg7ERPxzZmyblWbdPmttdGy5fgTpk=;
        b=gazKhqz+FB2DdQKFYI+WEDuL4cAP69ZhZN7zPLNhUwiivUWuzbuLIavFGXkVgKERwF
         fN58gqZHQqaeP7o0s6kPHWrudli8PnvjjKV8Id9ohafmGxYDVMzyXfNPiDutJEdSG87K
         NNmA7il163GPd8/9gdxb3NeTTKVor2IQ4qPAmwcInavG684CGOLQvYVmUWszAmGmyHnn
         CJfLblS8d5nRK3q4Lm+EYhlLfuoWVPwF73WGnXjfERWW7qeXd1UZFBlzZnNVszx+gP6V
         rF/7RQzTzLStLAZMMqx4yu2oQCwx38Y1E5+ylQRT8fY75GKahyCqYuMgbqssgPvjqgkj
         mwcA==
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_css() no longer has any user left outside cgroup.c proper and
we don't want subsystems to grow new usages of the function.  cgroup
core should always provide the css to use to the subsystems, which
will make dynamic creation and destruction of css's across the
lifetime of a cgroup much more manageable than exposing the cgroup
directly to subsystems and let them dereference css's from it.

Make cgroup_css() a static function in cgroup.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 13 -------------
 kernel/cgroup.c        | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 28e21f9..1d81d25 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -679,19 +679,6 @@ struct cgroup_subsys_state *css_parent(struct cgroup_subsys_state *css)
 }
 
 /**
- * cgroup_css - obtain a cgroup's css for the specified subsystem
- * @cgrp: the cgroup of interest
- * @subsys_id: the subsystem of interest
- *
- * Return @cgrp's css (cgroup_subsys_state) associated with @subsys_id.
- */
-static inline struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
-						     int subsys_id)
-{
-	return cgrp->subsys[subsys_id];
-}
-
-/**
  * task_css_set_check - obtain a task's css_set with extra access conditions
  * @task: the task to obtain css_set for
  * @__c: extra condition expression to be passed to rcu_dereference_check()
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ead0088..f8739c7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -222,6 +222,19 @@ static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 
+/**
+ * cgroup_css - obtain a cgroup's css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @subsys_id: the subsystem of interest
+ *
+ * Return @cgrp's css (cgroup_subsys_state) associated with @subsys_id.
+ */
+static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
+					      int subsys_id)
+{
+	return cgrp->subsys[subsys_id];
+}
+
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
-- 
1.8.3.1
