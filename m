From: <kyler.zhangkui@huawei.com>
Subject: [PATCH] cgroup: bug fix of cgroup_root object was not released after cgroup umounted
Date: Mon, 14 Dec 2015 19:45:54 +0800
Message-ID: <1450093554-24474-1-git-send-email-kyler.zhangkui@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: tj@kernel.org, zhihui.gao@huawei.com, chenjie6@huawei.com, lizefan@huawei.com, Zhang Kui <kyler.zhangkui@huawei.com>, stable@vger.kernel.org

From: Zhang Kui <kyler.zhangkui@huawei.com>

Newsgroups: gmane.linux.kernel.cgroups, gmane.linux.kernel

test case:
    # cat test.sh
    mkdir rootdir
    mount -t cgroup xxx rootdir -o cpu

    mkdir rootdir/0

    rmdir rootdir/0
    umount rootdir

    rmdir rootdir
    # ./test.sh
    # cat /proc/cgroups
    #subsys_name    hierarchy       num_cgroups     enabled
    cpuset  0       1       1
    cpu     1       1       1
    cpuacct 0       1       1
    blkio   0       1       1
    devices 0       1       1
    freezer 0       1       1
    debug   0       1       1

The rootdir's cgroup_root is not released after it is umounted, the cpu
subsystem hierarchy id is not zero.
After that, can not mount other subsystem except cpu on the folder
rootdir.
It is because "rmdir rootdir/0" real action is done in workqueue,
the sub-cgroup "0" has not beend delete from the root->cgrp.self.children
during running "umount rootdir".

Fix this by checking whether cgroup_root has online child on umounting.

Cc: <stable@vger.kernel.org> # 4.1.y+
Signed-off-by: Zhang Kui <kyler.zhangkui@huawei.com>
---
 kernel/cgroup.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f1603c1..ec6aecc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2147,6 +2147,13 @@ static void cgroup_kill_sb(struct super_block *sb)
 {
 	struct kernfs_root *kf_root = kernfs_root_from_sb(sb);
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup *child;
+	int live_child = 0;
+
+	mutex_lock(&cgroup_mutex);
+	cgroup_for_each_live_child(child, &root->cgrp) {
+		live_child++;
+	}
 
 	/*
 	 * If @root doesn't have any mounts or children, start killing it.
@@ -2155,12 +2162,12 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 *
 	 * And don't kill the default root.
 	 */
-	if (!list_empty(&root->cgrp.self.children) ||
-	    root == &cgrp_dfl_root)
-		cgroup_put(&root->cgrp);
+	if (live_child || root == &cgrp_dfl_root)
+	cgroup_put(&root->cgrp);
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);
 
+	mutex_unlock(&cgroup_mutex);
 	kernfs_kill_sb(sb);
 }
 
-- 
2.5.0
