From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/6] cgroup: remove duplicate RCU free on struct cgroup
Date: Thu, 17 Jan 2013 16:04:09 +0800
Message-ID: <50F7B079.50201@huawei.com>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50F7B040.2020906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

When destroying cgroup, though in cgroup_diput() we've called
synchronize_rcu(), we then still have to free cgroup via call_rcu().

The story is, long ago to fix a race between reading /proc/sched_debug
and freeing cgroup, the code was changed to utilize call_rcu().

Now we've splitted part of cpu cgroup css_alloc/free to css_online/offline,
which makes the race vanish, and this grants us to remove call_rcu().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 23a0ce1..d7fefeb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -892,7 +892,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		simple_xattrs_free(&cgrp->xattrs);
 
 		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-		kfree_rcu(cgrp, rcu_head);
+		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-- 
1.8.0.2
