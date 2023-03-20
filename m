From: Cai Xinchen <caixinchen1@huawei.com>
Subject: [PATCH v2 4.19 3/3] cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
Date: Mon, 20 Mar 2023 01:15:07 +0000
Message-ID: <20230320011507.129441-4-caixinchen1@huawei.com>
References: <20230320011507.129441-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20230320011507.129441-1-caixinchen1@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: longman@redhat.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, gregkh@linuxfoundation.org, sashal@kernel.org
Cc: mkoutny@suse.com, zhangqiao22@huawei.com, juri.lelli@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 43626dade36fa74d3329046f4ae2d7fdefe401c6 upstream.

syzbot is hitting percpu_rwsem_assert_held(&cpu_hotplug_lock) warning at
cpuset_attach() [1], for commit 4f7e7236435ca0ab ("cgroup: Fix
threadgroup_rwsem <-> cpus_read_lock() deadlock") missed that
cpuset_attach() is also called from cgroup_attach_task_all().
Add cpus_read_lock() like what cgroup_procs_write_start() does.

Link: https://syzkaller.appspot.com/bug?extid=29d3a3b4d86c8136ad9e [1]
Reported-by: syzbot <syzbot+29d3a3b4d86c8136ad9e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 4f7e7236435ca0ab ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 kernel/cgroup/cgroup-v1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 61644976225a..c0ebb70808b6 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -13,6 +13,7 @@
 #include <linux/delayacct.h>
 #include <linux/pid_namespace.h>
 #include <linux/cgroupstats.h>
+#include <linux/cpu.h>
 
 #include <trace/events/cgroup.h>
 
@@ -55,6 +56,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
+	get_online_cpus();
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
@@ -71,6 +73,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 			break;
 	}
 	percpu_up_write(&cgroup_threadgroup_rwsem);
+	put_online_cpus();
 	mutex_unlock(&cgroup_mutex);
 
 	return retval;
-- 
2.17.1

