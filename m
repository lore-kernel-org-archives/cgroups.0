From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: remove a NULL check in cgroup_exit()
Date: Thu, 24 Jan 2013 14:43:51 +0800
Message-ID: <5100D827.20807@huawei.com>
References: <5100D810.5020406@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5100D810.5020406-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

init_task.cgroups is initialized at boot phase, and whenver a ask
is forked, it's cgroups pointer is inherited from its parent, and
it's never set to NULL afterwards.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 09c5869..5d4c92e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5011,8 +5011,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	}
 	task_unlock(tsk);
 
-	if (cg)
-		put_css_set_taskexit(cg);
+	put_css_set_taskexit(cg);
 }
 
 /**
-- 
1.8.0.2
