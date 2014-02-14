From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/3] cgroup: fix memory leak in cgroup_mount()
Date: Fri, 14 Feb 2014 16:55:04 +0800
Message-ID: <52FDD9E8.4060408@huawei.com>
References: <52FDD9C4.1070001@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52FDD9C4.1070001@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

We should free the memory allocated in parse_cgroupfs_options() before
calling this function again.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0e794ca..37d94a2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1540,6 +1540,8 @@ retry:
 		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&cgroup_tree_mutex);
+			kfree(opts.release_agent);
+			kfree(opts.name);
 			msleep(10);
 			goto retry;
 		}
-- 
1.8.0.2
