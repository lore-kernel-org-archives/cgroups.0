From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/2] cpuset: fix RCU lockdep splat
Date: Tue, 15 Jan 2013 14:10:57 +0800
Message-ID: <50F4F2F1.8070107@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Reading /proc/<pid>/cpuset triggered RCU warning, and this bug was
introduced by Commit 5d21cc2db040d01f8c19b8602f6987813e1176b4
("cpuset: replace cgroup_mutex locking with cpuset internal locking")

Here we can retreive tsk->cgroups and call cgroup_path() inside RCU
read section.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6aa5bbb..1a675e4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2678,15 +2678,15 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 		goto out_free;
 
 	retval = -EINVAL;
-	mutex_lock(&cpuset_mutex);
+	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	rcu_read_unlock();
 	if (retval < 0)
-		goto out_unlock;
+		goto out_put_task;
 	seq_puts(m, buf);
 	seq_putc(m, '\n');
-out_unlock:
-	mutex_unlock(&cpuset_mutex);
+out_put_task:
 	put_task_struct(tsk);
 out_free:
 	kfree(buf);
-- 
1.8.0.2
