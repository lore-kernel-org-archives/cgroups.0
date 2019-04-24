From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cgroup: remove set but not used variable 'cgrp'
Date: Wed, 24 Apr 2019 16:06:14 +0800
Message-ID: <20190424080614.11876-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, hannes@cmpxchg.org, lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

kernel/cgroup/cgroup.c: In function 'cgroup_post_fork':
kernel/cgroup/cgroup.c:5946:19: warning: variable 'cgrp' set but not used [-Wunused-but-set-variable]

It is never used since introduction in
commit 76f969e8948d ("cgroup: cgroup v2 freezer")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/cgroup/cgroup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6f09f9b..c9f208d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5943,11 +5943,8 @@ void cgroup_post_fork(struct task_struct *child)
 		 * the task into the frozen state.
 		 */
 		if (unlikely(cgroup_task_freeze(child))) {
-			struct cgroup *cgrp;
-
 			spin_lock(&child->sighand->siglock);
 			WARN_ON_ONCE(child->frozen);
-			cgrp = cset->dfl_cgrp;
 			child->jobctl |= JOBCTL_TRAP_FREEZE;
 			spin_unlock(&child->sighand->siglock);
 
-- 
2.7.4


