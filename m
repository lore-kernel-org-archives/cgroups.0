From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: remove redundant assignment in while loop of cgroup_calc_subtree_ss_mask()
Date: Mon, 22 Jul 2019 19:39:23 +0800
Message-ID: <20190722113923.16914-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

new_ss_mask is always not less than cur_ss_mask.
We don not need to update it with cur_ss_mask's value.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 kernel/cgroup/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 300b0c416341..2b8c39dabd26 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1520,7 +1520,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
  */
 static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
 {
-	u16 cur_ss_mask = subtree_control;
+	u16 cur_ss_mask = subtree_control, new_ss_mask;
 	struct cgroup_subsys *ss;
 	int ssid;
 
@@ -1528,9 +1528,8 @@ static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
 
 	cur_ss_mask |= cgrp_dfl_implicit_ss_mask;
 
+	new_ss_mask = cur_ss_mask;
 	while (true) {
-		u16 new_ss_mask = cur_ss_mask;
-
 		do_each_subsys_mask(ss, ssid, cur_ss_mask) {
 			new_ss_mask |= ss->depends_on;
 		} while_each_subsys_mask();
-- 
2.19.1

