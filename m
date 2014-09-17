From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] cgroup: remove bogus comments
Date: Wed, 17 Sep 2014 18:19:24 +0800
Message-ID: <5419602C.4080303@huawei.com>
References: <54195FE1.9030607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54195FE1.9030607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We never grab cgroup mutex in fork and exit paths no matter whether
notify_on_release is set or not.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 26b8cb9..1abb554 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -967,14 +967,6 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * knows that the cgroup won't be removed, as cgroup_rmdir()
  * needs that mutex.
  *
- * The fork and exit callbacks cgroup_fork() and cgroup_exit(), don't
- * (usually) take cgroup_mutex.  These are the two most performance
- * critical pieces of code here.  The exception occurs on cgroup_exit(),
- * when a task in a notify_on_release cgroup exits.  Then cgroup_mutex
- * is taken, and if the cgroup count is zero, a usermode call made
- * to the release agent with the name of the cgroup (path relative to
- * the root of cgroup file system) as the argument.
- *
  * A cgroup can only be deleted if both its 'count' of using tasks
  * is zero, and its list of 'children' cgroups is empty.  Since all
  * tasks in the system use _some_ cgroup, and since there is always at
-- 
1.8.0.2
