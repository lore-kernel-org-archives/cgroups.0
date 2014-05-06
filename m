From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cgroup: use restart_syscall() for retries after offline waits in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 07:50:43 -0400
Message-ID: <1399377044-29873-4-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hnFZa8EQQlLs9+Eh8IFTtel+xeP7bZCiWLK1MbMm7IY=;
        b=xpPGpKyjEGOulIuvqPhJb+J6AILHUw3FQVf+m3vIDi6N1E0HZ406L3HkP8MJvmouWs
         WHk3SXD8j6ldHpEQzfXNpI7SAzgiKy7lBLZzt/Hvrbn10f38kWewZCIy3MWshQsycLtF
         WjR5vJcgCwf+B7ijomW/X0PN83cO/sP5oJV274GkK33jAiYNgEO2S3Jb/Se/SuAib5KT
         h8aC7OiE6ll8224EreoExAUvQq/vbfJucwYAv2Ehov6Ffg2+QtyiDjHyI/2QUpbbxmvg
         S0nh2PfXZ+7dj0zb86HbVA+pjxHQNtQ7xvPnpbfZf6vJgycvCJP+tnB8PZrDjn9h21Ks
         HYMA==
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

After waiting for a child to finish offline,
cgroup_subtree_control_write() jumps up to retry from after the input
parsing and active protection breaking.  This retry makes the
scheduled locking update more difficult.  Let's simplify it by
returning with restart_syscall() for retries.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9066fe9..3ced79a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2535,7 +2535,7 @@ out_finish:
 static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 					struct cftype *cft, char *buffer)
 {
-	unsigned int enable_req = 0, disable_req = 0, enable, disable;
+	unsigned int enable = 0, disable = 0;
 	struct cgroup *cgrp = dummy_css->cgroup, *child;
 	struct cgroup_subsys *ss;
 	char *tok, *p;
@@ -2552,11 +2552,11 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 				continue;
 
 			if (*tok == '+') {
-				enable_req |= 1 << ssid;
-				disable_req &= ~(1 << ssid);
+				enable |= 1 << ssid;
+				disable &= ~(1 << ssid);
 			} else if (*tok == '-') {
-				disable_req |= 1 << ssid;
-				enable_req &= ~(1 << ssid);
+				disable |= 1 << ssid;
+				enable &= ~(1 << ssid);
 			} else {
 				return -EINVAL;
 			}
@@ -2574,9 +2574,6 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	 */
 	cgroup_get(cgrp);
 	kernfs_break_active_protection(cgrp->control_kn);
-retry:
-	enable = enable_req;
-	disable = disable_req;
 
 	mutex_lock(&cgroup_tree_mutex);
 
@@ -2606,7 +2603,9 @@ retry:
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
 				cgroup_put(child);
-				goto retry;
+
+				ret = restart_syscall();
+				goto out_unbreak;
 			}
 
 			/* unavailable or not enabled on the parent? */
@@ -2690,6 +2689,7 @@ out_unlock:
 	mutex_unlock(&cgroup_mutex);
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
+out_unbreak:
 	kernfs_unbreak_active_protection(cgrp->control_kn);
 	cgroup_put(cgrp);
 	return ret;
-- 
1.9.0
