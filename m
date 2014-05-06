From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: fix offlining child waiting in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 07:50:41 -0400
Message-ID: <1399377044-29873-2-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9OfGJ1QLvDbn9U7lD0Ov1LNDo1vxmBzUpBxlcUlAizA=;
        b=oqYZ/H/P7v+4nb0iGHddzmM/6kOM6ev6nZsmYR1AyBZ4dHoiK7zF7/5jIX70s/d6/g
         8muE7Yjo5bOqLRhCddQVg/MSOEdaAcutUqVkANDX+nXJxCICsp/osqwobwEeNw093/Io
         Nya7iHzrVrVd7pbh6UA3US7aSC4a7uoG7xBJHPsyL4c9cZ7dKFIa836+eX8gS9hyyu0o
         /J7WlB/Ott5W8ST9qSspbDNg86YyZwH1gpS4npvA/Oqur8ACQAP5j9rV5NA/BcAOjv0a
         1TmXjfnZwG2lJF+z0GmEvMaqI2rSPv1RLZX/ThqkeFevzYe2PSYqqD/GeIhyqdzqaGeW
         9XsQ==
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
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
index 07815ef..54fd12d 100644
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
