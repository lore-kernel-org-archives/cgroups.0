From: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>
Subject: [PATCH] cgroup/pid: fix the pid_cgrp attach bug in cgroup v2
Date: Fri,  2 Jul 2021 17:18:44 +0800
Message-ID: <20210702091844.737784-1-suhui@zeku.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zeku.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYkKuFIhnyWIyoJrGTPpBOke6zEuaYyrmL/Eg/xyoF0=;
 b=FB+2ETb5ycNf+9NKH/Q/YoBez9gaGRq5+vEP2w9uYPCiXW6OvMysVncdlqR2AVog6+Ahn8EwDGPbZrKi1WO6cp5cAVYV3QbVJ0zhLKHhRDS/9XTMtb0SsQKdCSTclcUDZAUESE5KTWwXbaEAWhzJ30fzLgMgAOKwApwEONMt20VH3J/ruPG0nr8jAkNTC11I7DqI7rpvw04lda2+TSZpmWlamvBDUDGbc2g1fbODCbUGj1FMb/ZhtsHzu0cp8T7oay6wwqsLvCzprtycjgFrE8BHW71fXR1YDrLzJYI+Vlc0WUxXXR+a3AOvrJtUq6LEzrppqoGxJ78pF7E7cSB/aA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>

pids_can_attach() should make sure the pids->counter not bigger
than pids->limit, so we should use pids_try_charge() here.

without the change:
root@test:/sys/fs/cgroup/test# cat pids.max
3
root@test:/sys/fs/cgroup/test# sleep 1000 &
[1] 3379
root@test:/sys/fs/cgroup/test# sleep 1000 &
[2] 3380
root@test:/sys/fs/cgroup/test# sleep 1000 &
[3] 3381
root@test:/sys/fs/cgroup/test# sleep 1000 &
[4] 3382
root@test:/sys/fs/cgroup/test# echo 3379 > cgroup.procs
root@test:/sys/fs/cgroup/test# echo 3380 > cgroup.procs
root@test:/sys/fs/cgroup/test# echo 3381 > cgroup.procs
root@test:/sys/fs/cgroup/test# echo 3382 > cgroup.procs
root@test:/sys/fs/cgroup/test# cat pids.max
3
root@test:/sys/fs/cgroup/test# cat pids.current
4
root@test:/sys/fs/cgroup/test# cat cgroup.procs
3379
3380
3381
3382
root@test:/sys/fs/cgroup/test#

with this change:
root@test:/sys/fs/cgroup/test# cat pids.current
3
root@test:/sys/fs/cgroup/test# cat pids.max
3
root@test:/sys/fs/cgroup/test# cat cgroup.procs
2614
3683
3684
root@test:/sys/fs/cgroup/test# sleep 10000 &
[5] 3733
root@test:/sys/fs/cgroup/test# echo 3733 > cgroup.procs
bash: echo: write error: Resource temporarily unavailable
root@test:/sys/fs/cgroup/test# cat cgroup.procs
2614
3683
3684
root@test:/sys/fs/cgroup/test# cat pids.current
3
root@test:/sys/fs/cgroup/test# dmesg |tail -n 1
[  863.612162] cgroup: attach rejected by pids controller in /test

Signed-off-by: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>
---
 kernel/cgroup/pids.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 511af87f685e..5e24990f28de 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -172,6 +172,7 @@ static int pids_can_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 	struct cgroup_subsys_state *dst_css;
+	int ret = 0;
 
 	cgroup_taskset_for_each(task, dst_css, tset) {
 		struct pids_cgroup *pids = css_pids(dst_css);
@@ -186,11 +187,17 @@ static int pids_can_attach(struct cgroup_taskset *tset)
 		old_css = task_css(task, pids_cgrp_id);
 		old_pids = css_pids(old_css);
 
-		pids_charge(pids, 1);
+		ret = pids_try_charge(pids, 1);
+		if (ret) {
+			pr_info("cgroup: attach rejected by pids controller in ");
+			pr_cont_cgroup_path(dst_css->cgroup);
+			pr_cont("\n");
+			break;
+		}
 		pids_uncharge(old_pids, 1);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void pids_cancel_attach(struct cgroup_taskset *tset)
-- 
2.25.1

