From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: remove synchronize_rcu() from rebind_subsystems()
Date: Mon, 14 Jan 2013 17:24:18 +0800
Message-ID: <50F3CEC2.1020909@huawei.com>
References: <50F3CE8E.5000402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F3CE8E.5000402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Nothing's protected by RCU in rebind_subsystems(), and I can't think
of a reason why it is needed.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 67b0fa0..f43c929 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1079,7 +1079,6 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 		}
 	}
 	root->subsys_mask = root->actual_subsys_mask = final_subsys_mask;
-	synchronize_rcu();
 
 	return 0;
 }
-- 
1.8.0.2
