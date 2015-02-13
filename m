From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cpuset: initialize effective masks when clone_children
 is enabled
Date: Fri, 13 Feb 2015 11:19:49 +0800
Message-ID: <54DD6D55.2070603@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <christianvanbrauner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, =?GB2312?B?U3SopnBoYW5lIEdyYWJlcg==?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If clone_children is enabled, effective masks won't be initialized
due to the bug:

  # mount -t cgroup -o cpuset xxx /mnt
  # echo 1 > cgroup.clone_children
  # mkdir /mnt/tmp
  # cat /mnt/tmp/
  # cat cpuset.effective_cpus

  # cat cpuset.cpus
  0-15

And then this cpuset won't constrain the tasks in it.

Either the bug or the fix has no effect on unified hierarchy, as
there's no clone_chidren flag there any more.

Reported-by: Christian Brauner <christianvanbrauner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.17+
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b257f..7e9d711 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1992,7 +1992,9 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = parent->mems_allowed;
+	cs->effective_mems = parent->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
+	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
-- 
1.8.0.2
