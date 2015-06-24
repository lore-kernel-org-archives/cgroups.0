From: Sheng Yong <shengyong1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: return -ESRCH if no tasks get migrated
Date: Wed, 24 Jun 2015 06:12:46 +0000
Message-ID: <1435126366-223103-1-git-send-email-shengyong1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When we migrate a task from one cgroup to another, if the task is exiting
or is just forked and not ready, the task will not be migrated.  In this
case, it would be better for cgroup_migrate() to return -ESRCH rather than
0. This behavour is changed since commit 081aa458c ("cgroup: consolidate
cgroup_attach_task() and cgroup_attach_proc()").

The testcase is following:
==============================
debian:~# cat zombie.c

 #include <unistd.h>
 #include <stdio.h>

int main()
{
	pid_t child;

	child = fork();
	if (child == 0) {
		printf("CHILD [%d]\n", getpid());
		execve("/bin/ls", NULL, NULL);
	} else if (child > 0) {
		printf("PARENT[%d]\n", getpid());
		sleep(1000);
	}
	return 0;
}

debian:~# mkdir /tmp/cgroup
debian:~# mount -t cgroup -o cpuset none /tmp/cgroup
debian:~# ./zombie
PARENT[3290]
CHILD [3291]

Change to the second terminal.
debian:~# mkdir /tmp/cgroup/sub
debian:~# ps aux | grep 3291
root	3291 0.0 0.0	0	0 tty1	*Z+*	02:04	0:00 [ls] <defunct>
debian:~# echo 3291 > /tmp/cgroup/sub/tasks; echo $?
0
debian:~# grep 3291 /tmp/cgroup/sub/tasks; echo $?
1
==============================

The migrate did not succeed, but no error was reported.  So we return
-ESRCH when no task is migrated, so that userspace executable could report
"No such process".

In addition, when doing transfer or setting subtree controller, it's OK to
skip tasks which are not migrated. So we check if the return value of
cgroup_migrate() is -ESRCH, and do not break the procedure if it is so.

Fixes: 081aa458c38b ("cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()")
Reported-by: Zhang Kui <kyler.zhangkui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sheng Yong <shengyong1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 469dd54..3f25de7c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2281,7 +2281,7 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 
 	/* methods shouldn't be called if no task is actually migrating */
 	if (list_empty(&tset.src_csets))
-		return 0;
+		return -ESRCH;
 
 	/* check that we can legitimately attach to the cgroup */
 	for_each_e_css(css, i, cgrp) {
@@ -2674,7 +2674,9 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 			threadgroup_unlock(task);
 			put_task_struct(task);
 
-			if (WARN(ret, "cgroup: failed to update controllers for the default hierarchy (%d), further operations may crash or hang\n", ret))
+			if (WARN(ret && ret != -ESRCH,
+				 "cgroup: failed to update controllers for the default hierarchy (%d), further operations may crash or hang\n",
+				 ret))
 				goto out_finish;
 		}
 	}
@@ -3743,7 +3745,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 			ret = cgroup_migrate(to, task, false);
 			put_task_struct(task);
 		}
-	} while (task && !ret);
+	} while (task && (!ret || ret == -ESRCH));
 out_err:
 	cgroup_migrate_finish(&preloaded_csets);
 	mutex_unlock(&cgroup_mutex);
-- 
1.8.3.4
