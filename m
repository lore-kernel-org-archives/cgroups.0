From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] cgroup: fix offlining child waiting in cgroup_subtree_control_write()
Date: Fri,  9 May 2014 15:32:49 -0400
Message-ID: <1399663975-315-2-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KKQW+mevezxl5nCp4mePwchcyWtY5e9rkZsVRBfQCkI=;
        b=HmcHauxCPzSIWx4W9+j6Ehh6d1RpzWFskyVTbK73j/hjAE1GBzA6Jqke/5unMe6C4T
         4oEKFjTe3o8K8dIlU0YbRVvKKuJCfKT9kvrJnTisZtiTvG3OIvNFl+4mbWGGX9LpE6b5
         Ym1TE55Ww3zNLWZns2enWSBdSEAQhIcKbD0K0gvqY6WXt4Y0UeA4Osr7+Cb3xfZXHFGy
         PND5LZxkMDUUy56O52eXZsN07gjPNiRX6lb8U9x8dwC/gJpYl8RaQcZGNlrTE1EnNEj8
         QAM+crNoHkhKcc5m/tQqcDH89vY54K+599oljv69JgRFgbGEIYqHNuFCAuiBO7f3wYmI
         S5yQ==
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_subtree_control_write() waits for offline to complete
child-by-child before enabling a controller; however, it has a couple
bugs.

* It doesn't initialize the wait_queue_t.  This can lead to infinite
  hang on the following schedule() among other things.

* It forgets to pin the child before releasing cgroup_tree_mutex and
  performing schedule().  The child may already be gone by the time it
  wakes up and invokes finish_wait().  Pin the child being waited on.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9db1a96..95fc66b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2594,16 +2594,18 @@ retry:
 			 * cases, wait till it's gone using offline_waitq.
 			 */
 			cgroup_for_each_live_child(child, cgrp) {
-				wait_queue_t wait;
+				DEFINE_WAIT(wait);
 
 				if (!cgroup_css(child, ss))
 					continue;
 
+				cgroup_get(child);
 				prepare_to_wait(&child->offline_waitq, &wait,
 						TASK_UNINTERRUPTIBLE);
 				mutex_unlock(&cgroup_tree_mutex);
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
+				cgroup_put(child);
 				goto retry;
 			}
 
-- 
1.9.0
