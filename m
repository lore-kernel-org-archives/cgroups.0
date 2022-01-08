From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH -next] cgroup: Fix cgroup_can_fork() and cgroup_post_fork() kernel-doc comment
Date: Sat,  8 Jan 2022 14:38:12 +0800
Message-ID: <20220108063812.50370-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Add the description of @kargs in cgroup_can_fork() and
cgroup_post_fork() kernel-doc comment to remove warnings found
by running scripts/kernel-doc, which is caused by using 'make W=1'.

kernel/cgroup/cgroup.c:6235: warning: Function parameter or member
'kargs' not described in 'cgroup_can_fork'
kernel/cgroup/cgroup.c:6296: warning: Function parameter or member
'kargs' not described in 'cgroup_post_fork'

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b31e1465868a..37c49e1a672f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6224,6 +6224,7 @@ static void cgroup_css_set_put_fork(struct kernel_clone_args *kargs)
 /**
  * cgroup_can_fork - called on a new task before the process is exposed
  * @child: the child process
+ * @kargs: the arguments passed to create the child process
  *
  * This prepares a new css_set for the child process which the child will
  * be attached to in cgroup_post_fork().
@@ -6286,6 +6287,7 @@ void cgroup_cancel_fork(struct task_struct *child,
 /**
  * cgroup_post_fork - finalize cgroup setup for the child process
  * @child: the child process
+ * @kargs: the arguments passed to create the child process
  *
  * Attach the child process to its css_set calling the subsystem fork()
  * callbacks.
-- 
2.20.1.7.g153144c

