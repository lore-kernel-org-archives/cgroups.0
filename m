From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Properly init nr_tasks in cgroup_taskset
Date: Thu, 14 Sep 2017 13:45:13 -0700
Message-ID: <1505421913-29577-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Commit 610467270fb3 ("cgroup: don't call migration methods if there
are no tasks to migrate") introduces a new field nr_tasks to the
cgroup_taskset structure for keeping track of the number of tasks
contained in the structure.  The initial value of this field, however,
is not guaranteed to be 0 as all the cgroup_taskset structures are
allocated from stack.  Therefore, we need to explicitly initilized
it in the CGROUP_TASKSET_INIT() macro for the new code to behave
correctly.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 5151ff2..6b4c04e 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -76,6 +76,7 @@ struct cgroup_mgctx {
 	.src_csets		= LIST_HEAD_INIT(tset.src_csets),		\
 	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),		\
 	.csets			= &tset.src_csets,				\
+	.nr_tasks		= 0,						\
 }
 
 #define CGROUP_MGCTX_INIT(name)							\
-- 
1.8.3.1
