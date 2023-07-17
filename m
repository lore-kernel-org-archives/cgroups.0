From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] cgroup: fix obsolete function name
Date: Mon, 17 Jul 2023 19:28:00 +0800
Message-ID: <20230717112800.2949233-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

cgroup_taskset_migrate() has been renamed to cgroup_migrate_execute() since
commit e595cd706982 ("cgroup: track migration context in cgroup_mgctx").
Update the corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a2700bf86698..40ee81f982ff 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2499,7 +2499,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 
 			/*
 			 * This function may be called both before and
-			 * after cgroup_taskset_migrate().  The two cases
+			 * after cgroup_migrate_execute().  The two cases
 			 * can be distinguished by looking at whether @cset
 			 * has its ->mg_dst_cset set.
 			 */
-- 
2.33.0

