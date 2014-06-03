From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/3] cgroup: make the default root invisible when it's umounted
Date: Tue, 3 Jun 2014 12:05:22 +0800
Message-ID: <538D4982.10905@huawei.com>
References: <538D4956.5050205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <538D4956.5050205@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Before this patch (in a fresh system):

   # cat /proc/$$/cgroup
   # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
   # umount /cgroup
   # cat /proc/$$/cgroup
   0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/

After this patch (in a fresh system):

   # cat ...
   # mount ...
   # umount ...
   # cat /proc/$$/cgroup
   #

You won't see the default root after it's umounted.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f73fe48..dabc486 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1788,6 +1788,8 @@ static void cgroup_kill_sb(struct super_block *sb)
 	} else {
 		if (root != &cgrp_dfl_root)
 			percpu_ref_kill(&root->cgrp.self.refcnt);
+		else
+			cgrp_dfl_root_visible = false;
 	}
 
 	kernfs_kill_sb(sb);
-- 
1.8.0.2
