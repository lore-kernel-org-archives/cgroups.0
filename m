From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: simplify code for cgroup_subtree_control_write()
Date: Mon,  8 Jul 2019 21:01:32 +0800
Message-ID: <20190708130132.5582-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

Process "enable" and "disable" earlier to simplify code.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 kernel/cgroup/cgroup.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bf9dbffd46b1..e49b8bde5c99 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3269,23 +3269,21 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 
+	enable &= ~(cgrp->subtree_control);
+	disable &= cgrp->subtree_control;
+
+	if (!enable && !disable) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	for_each_subsys(ss, ssid) {
 		if (enable & (1 << ssid)) {
-			if (cgrp->subtree_control & (1 << ssid)) {
-				enable &= ~(1 << ssid);
-				continue;
-			}
-
 			if (!(cgroup_control(cgrp) & (1 << ssid))) {
 				ret = -ENOENT;
 				goto out_unlock;
 			}
 		} else if (disable & (1 << ssid)) {
-			if (!(cgrp->subtree_control & (1 << ssid))) {
-				disable &= ~(1 << ssid);
-				continue;
-			}
-
 			/* a child has it enabled? */
 			cgroup_for_each_live_child(child, cgrp) {
 				if (child->subtree_control & (1 << ssid)) {
@@ -3296,11 +3294,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		}
 	}
 
-	if (!enable && !disable) {
-		ret = 0;
-		goto out_unlock;
-	}
-
 	ret = cgroup_vet_subtree_control_enable(cgrp, enable);
 	if (ret)
 		goto out_unlock;
-- 
2.19.1

