From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] cgroup: fix a typo in comment.
Date: Mon, 25 Aug 2014 19:27:52 +0800
Message-ID: <1408966072-2142-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

There is no function named cgroup_enable_task_cg_links().
Instead, the correct function name in this comment should
be cgroup_enabled_task_cg_lists().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..64bbb56 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5161,7 +5161,7 @@ void cgroup_post_fork(struct task_struct *child)
 	int i;
 
 	/*
-	 * This may race against cgroup_enable_task_cg_links().  As that
+	 * This may race against cgroup_enable_task_cg_lists().  As that
 	 * function sets use_task_css_set_links before grabbing
 	 * tasklist_lock and we just went through tasklist_lock to add
 	 * @child, it's guaranteed that either we see the set
@@ -5176,7 +5176,7 @@ void cgroup_post_fork(struct task_struct *child)
 	 * when implementing operations which need to migrate all tasks of
 	 * a cgroup to another.
 	 *
-	 * Note that if we lose to cgroup_enable_task_cg_links(), @child
+	 * Note that if we lose to cgroup_enable_task_cg_lists(), @child
 	 * will remain in init_css_set.  This is safe because all tasks are
 	 * in the init_css_set before cg_links is enabled and there's no
 	 * operation which transfers all tasks out of init_css_set.
-- 
1.8.4.2
