From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] cgroup: remove cgroup_attach_task_current_cg()
Date: Fri, 20 Jan 2012 11:58:09 +0800
Message-ID: <4F18E651.2000109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

It's just a wrapper of cgroup_attach_task_all(), and it's no longer
used after commit 87d6a412bd1ed82c14cabd4b408003b23bbd2880
(vhost: fix attach to cgroups regression)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9b6021..dee53bd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -602,11 +602,6 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 
-static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
-{
-	return cgroup_attach_task_all(current, tsk);
-}
-
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
  * if cgroup_subsys.use_id == true. It can be used for looking up and scanning.
@@ -669,10 +664,6 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
 {
 	return 0;
 }
-static inline int cgroup_attach_task_current_cg(struct task_struct *t)
-{
-	return 0;
-}
 
 #endif /* !CONFIG_CGROUPS */
 
-- 
1.7.3.1
